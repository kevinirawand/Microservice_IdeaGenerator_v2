const puppeteer = require("puppeteer");
const jsonfile = require('jsonfile')
const fs = require('fs')
var path = require('path');
const helper = require("../utils/helper");
const moment = require('moment');

const BASE_URL = "https://instagram.com/";
const DELAY = 3000;

function log(info) {
   console.log(info);
   helper.logFile(info, "ibot");
}


function Mylog(info) {
   console.log(info);
   helper.logFile(info, "KEVIN_TEST");
}

class IBot {
   constructor(options) {
      this.browser = null;
      this.page = null;
      this.username = options.username;
      this.password = options.password;
      this.kuePath = path.join(__dirname, '/sessions/kue' + options.username + '.json');
      this.hasSession = false;
   }

   baseURL() {
      return BASE_URL;
   }

   async init(headless = true) {
      try {
         log("INIT: Initializing The Browser!");
         if (!this.browser) {
            this.browser = await puppeteer.launch({ headless: headless });
         }
         if (!this.page) {
            this.page = await this.browser.newPage();
         }
         // await instagram.page.setViewport({ width: 1366, height: 768});
         log("INIT: Initialized!");
         return true;
      }
      catch (e) {
         log("INIT: error: ", e);
         return false;
      }
   }

   async writeCookies() {
      const cookiesObject = await this.page.cookies();
      jsonfile.writeFileSync(this.kuePath, cookiesObject, { spaces: 2 });
   }

   async exit() {
      await this.writeCookies();
      this.browser.close();
   }

   async login() {
      try {
         log("LOGIN: Loggin In! to " + this.username + ":" + this.password);
         await this.page.goto(BASE_URL, { waitUntil: "networkidle2" });
         await this.page.waitForTimeout(3000);
         await this.page.type('input[name="username"]', this.username, { delay: 100 });
         await this.page.type('input[name="password"]', this.password, { delay: 100 });
         await this.page.waitForTimeout(1000);
         await this.page.click('button[type="submit"]');
         await this.page.waitForTimeout(10000);
         // TODO try this:
         // await this.page.waitForNavigation({ waitUntil: 'networkidle0' });
         log("Successfully Logged In!");
         await this.writeCookies();
         return true;
      }
      catch (e) {
         log("LOGIN: error " + e);
         return false;
      }
   }

   async session() {
      try {
         log("Get file: " + this.kuePath);
         // Mylog("Get file: " + this.kuePath);
         const previousSession = fs.existsSync(this.kuePath);
         if (previousSession) {
            // If file exist load the cookies
            log("File exist");
            const cookiesArr = jsonfile.readFileSync(this.kuePath);
            if (cookiesArr.length !== 0) {
               for (let cookie of cookiesArr) {
                  // Mylog(cookie);
                  await this.page.setCookie(cookie);
               }
               log('Session has been loaded in the browser');
               this.hasSession = true;
               return true;
            }
         }
         log("Kue doesn't exist");
         return false;
      } catch {
         return false;
      }
   }

   async isLogin() {
      if (this.hasSession) return true;
      const hasSession = await this.session();
      if (!hasSession) {
         log("Cannot read session");
         const isLogin = await this.login();
         if (!isLogin) {
            log("Login failed");
            return false;
         }
      }
      return true;
   }

   scrapeProfilePage(html) {
      var json;
      log('sebelum masuk')
      try {
         var dataExp = /window\._sharedData\s?=\s?({.+);<\/script>/;
         log(dataExp);
         var dataString = html.match(dataExp)[1];
         json = JSON.parse(dataString);
      }
      catch (e) {
         log(e);
         if (process.env.NODE_ENV != 'production') {
            log('scrapeProfilePage => The HTML returned from instagram was not suitable for scraping');
         }
         return null
      }
      return json;
   }

   scrapePagePage(html) {
      var json;
      try {
         var dataExp = /window\.__additionalDataLoaded(.+)\/',(.+)\);<\/script>/;
         var dataString = html.match(dataExp)[2];
         json = JSON.parse(dataString);
      }
      catch (e) {
         if (process.env.NODE_ENV != 'production') {
            log('scrapePagePage => The HTML returned from instagram was not suitable for scraping');
         }
         return null
      }
      return json;
   }

   extractNewResponse(username, response) {
      if (response) {
         const user = response.data.user;
         const userPost = user.edge_owner_to_timeline_media;

         // fetch posting today or yesterday
         const pageInfo = userPost.page_info;
         const posts = userPost.edges;

         let pages = [];
         let isLast = false;
         posts.forEach(post => {
            const p = post?.node;
            if (p) {
               const timestamp = p.taken_at_timestamp;
               const td = moment(timestamp * 1000);
               let date = moment();
               date.subtract(1, 'days');
               if (td.year() == date.year() && td.month() == date.month() && td.date() == date.date()) {
                  pages.push({ shortcode: p.shortcode, taken_at_timestamp: p.taken_at_timestamp, like: p.edge_liked_by?.count, comment: p.edge_media_to_comment?.count, commentDisabled: p.comments_disabled, follower: user.edge_followed_by?.count });
               } else {
                  isLast = true;
               }
            }
         });

         log("Successfully Fetched Username: " + username + " with page count: " + pages.length);

         if (!isLast) {
            // TODO fetch more to get more post
            log("TODO fetch more to get more post");
         }

         return { pages: pages };
      } else {
         return false;
      }

   }

   fetchNewProfile(username) {

      const usePromise = new Promise(async (resolve, reject) => {
         var baseUsername = BASE_URL + username;
         // var baseUsername = `https://i.instagram.com/api/v1/users/web_profile_info/?username=` + username;

         this.page.on('response', async (response) => {
            if (response.url().includes(`https://www.instagram.com/api/v1/users/web_profile_info/`)) {
               try {
                  const newRespon = await response.json();
                  // console.info(`RESPONSE WITHOUT ERROR : ${response}`);
                  // Mylog(response.toString())
                  resolve(newRespon);
               } catch (error) {
                  const cek = String(response);
                  console.log("NOT JSON Format");
                  Mylog(response)
                  // console.info(`RESPONSE WITH ERROR : ${cek}`);
                  // console.info(`RESPONSE THIS ERROR : ${error}`);
               }
            }
         });
         await this.page.goto(baseUsername, { waitUntil: "networkidle2" });
         await this.page.content();
         setTimeout(() => {
            reject("fetchNewProfile => TIMEOUT");
         }, 5000);
      });
      return usePromise;
   }

   async getUsernamePage(username, delay = 3000) {
      try {
         // log("Fetching Username " + username);
         if (!await this.isLogin()) return;

         await this.page.waitForTimeout(delay);
         const newRespon = await this.fetchNewProfile(username);
         return this.extractNewResponse(username, newRespon);
      } catch (e) {
         log("USERNAME: error: " + e);
         return false;
      }
   }

   async graphqlReplies(commentId, replies, pageInfo) {
      const replyURL = BASE_URL + `graphql/query/?query_hash=1ee91c32fc020d44158a3192eda98247&variables={"comment_id":"` + commentId + `","first":10,"after":` + JSON.stringify(pageInfo?.end_cursor) + `}`;
      await this.page.waitForTimeout(DELAY);
      const response = await this.page.goto(replyURL, { waitUntil: "networkidle0" });
      const result = await response.json();
      if (result.data && result.data.comment && result.data.comment.edge_threaded_comments) {
         pageInfo = result.data.comment.edge_threaded_comments.page_info;
         const r = result.data.comment.edge_threaded_comments.edges;
         if (r.length > 0) {
            for (const rp of r) {
               replies.push(rp);
            }
         }
      } else {
         pageInfo = {
            has_next_page: false
         };
      }
      return { replies, pageInfo }
   }

   checkCommentAndReply(contributors = [], usersComments, cr) {
      if (contributors.length <= 0) {
         return;
      }
      const arrayC = contributors.map(val => {
         return val.ig_username;
      });
      for (const item of cr) {
         const itemC = { created_at: item.node.created_at, username: item.node.owner?.username };
         const iItem = arrayC.indexOf(item.node.owner?.username);
         if (iItem != -1) {
            itemC.contributor_id = contributors[iItem].contributor_id;
            // check existing
            const existingUC = usersComments.filter(d => d.created_at == item.node.created_at && d.username == item.node.owner?.username);
            if (existingUC.length == 0) {
               usersComments.push(itemC);
            }
         }
      }
   }

   async getReplies(username, comments, contributors) {
      let responseCount = 0;
      let otherComment = 0;
      let usersComments = [];
      if (comments && comments.length > 0) {
         // comments checked here
         this.checkCommentAndReply(contributors, usersComments, comments);
         for (let i = 0; i < comments.length; i++) {
            // check replies
            const threadComment = comments[i]?.node?.edge_threaded_comments;
            let replies = threadComment?.edges;
            // first replies checked here
            this.checkCommentAndReply(contributors, usersComments, replies);
            // get all reply until last reply
            let pageInfo = threadComment?.page_info;
            let j = 0;
            // limit to 100 thread
            while (pageInfo?.has_next_page && j < 10) {
               try {
                  const whileReply = await this.graphqlReplies(comments[i]?.node?.id, replies, pageInfo);
                  pageInfo = whileReply.pageInfo;
                  replies = whileReply.replies;
                  // next replies checked here
                  this.checkCommentAndReply(contributors, usersComments, replies);
               } catch (error) {
                  log(error);
               }
               j++;
            }
            if (replies && replies.length > 0) {
               for (let r = 0; r < replies.length; r++) {
                  const ru = replies[r].node?.owner?.username;
                  if (ru == username) {
                     responseCount++;
                  } else {
                     // this reply is from another
                     otherComment++;
                  }
               }
            }
         }
      }
      return { responseCount: responseCount, otherComment: otherComment, contributorsComments: usersComments };
   }

   async graphqlComment(pageId, commentInfo, delay, withCommentCount = false) {
      let commentURL = BASE_URL + `graphql/query/?query_hash=bc3296d1ce80a24b1b6e40b1e72903f5&variables={"shortcode":"` + pageId + `","first":50}`;
      if (commentInfo && commentInfo.has_next_page) {
         commentURL = BASE_URL + `graphql/query/?query_hash=bc3296d1ce80a24b1b6e40b1e72903f5&variables={"shortcode":"` + pageId + `","first":50,"after":` + JSON.stringify(commentInfo?.end_cursor) + `}`;
      }
      let comments = [];
      await this.page.waitForTimeout(delay);
      const response = await this.page.goto(commentURL, { waitUntil: "networkidle0" });
      const result = await response.json();
      if (result.data && result.data.shortcode_media && result.data.shortcode_media.edge_media_to_parent_comment) {
         commentInfo = result.data.shortcode_media.edge_media_to_parent_comment.page_info;
         comments = result.data.shortcode_media.edge_media_to_parent_comment.edges;
      } else {
         commentInfo = {
            has_next_page: false
         };
      }
      if (withCommentCount) {
         const commentCount = result?.data?.shortcode_media?.edge_media_to_parent_comment.count;
         return { commentInfo: commentInfo, comments: comments, commentCount: commentCount };
      } else {
         return { commentInfo: commentInfo, comments: comments };
      }
   }

   async graphqlLikers(pageId, likeInfo, delay) {
      let likerURL = BASE_URL + `graphql/query/?query_hash=d5d763b1e2acf209d62d22d184488e57&variables={"shortcode":"` + pageId + `","first":50}`;
      if (likeInfo?.has_next_page) {
         likerURL = BASE_URL + `graphql/query/?query_hash=d5d763b1e2acf209d62d22d184488e57&variables={"shortcode":"` + pageId + `","first":50,"after":"` + likeInfo?.end_cursor + `"}`;
      }
      let likers = [];
      await this.page.waitForTimeout(delay);
      const response = await this.page.goto(likerURL, { waitUntil: "networkidle0" });
      const result = await response.json();
      if (result.data && result.data.shortcode_media && result.data.shortcode_media.edge_liked_by) {
         likeInfo = result.data.shortcode_media.edge_liked_by.page_info;
         likers = result.data.shortcode_media.edge_liked_by.edges;
      } else {
         likeInfo = {
            has_next_page: false
         };
      }
      return { likeInfo: likeInfo, likers: likers };
   }

   chooseLikeEdges(contributors = [], likers = []) {
      const arrayC = contributors.map(val => {
         return val.ig_username;
      });
      let contributorsLikers = [];
      if (likers.length > 0) {
         for (const val of likers) {
            const un = val.node?.username;
            const indx = arrayC.indexOf(un);
            if (indx != -1) {
               contributorsLikers.push(contributors[indx]);
            }
         }
      }
      return contributorsLikers;
   }

   async getContributorAsLiker(shortcode, contributors, delay = 3000) {
      let i = 0;
      let checkZero = 0;
      let checkLess3 = 0;
      let likeInfo = {};
      let contributorsLikers = [];

      const rf = await this.graphqlLikers(shortcode, likeInfo, delay);
      likeInfo = rf.likeInfo;
      contributorsLikers = this.chooseLikeEdges(contributors, rf.likers);

      while (likeInfo.has_next_page && i < 20 && checkZero < 5 && checkLess3 < 5) {
         const r = await this.graphqlLikers(shortcode, likeInfo, delay);
         i++;
         if (r.likers.length == 0) {
            checkZero++;
         }
         if (r.likers.length <= 3) {
            checkLess3++;
         }

         likeInfo = r.likeInfo;

         // check liker with registered contributors;
         if (r.likers && r.likers.length > 0) {
            const cl = this.chooseLikeEdges(contributors, r.likers);
            if (cl && cl.length > 0) {
               contributorsLikers = contributorsLikers.concat(cl);
            }
         }
      }

      return contributorsLikers;
   }

   async extractPage(pageId, contributors, delay, data) {
      // log("Successfully Fetched Page " + pageId);
      const username = data.shortcode_media.owner?.username;
      const caption = data.shortcode_media.edge_media_to_caption?.edges[0]?.node?.text;
      const followerCount = data.shortcode_media.owner?.edge_followed_by?.count;
      const likeCount = data.shortcode_media.edge_media_preview_like?.count;

      let responseCount = 0;

      //START: data.shortcode_media.edge_media_to_parent_comment
      const graphqlCommentInfo = await this.graphqlComment(pageId, null, delay, true);
      const commentCount = graphqlCommentInfo.commentCount;
      let comments = graphqlCommentInfo.comments;
      let commentInfo = graphqlCommentInfo.commentInfo;
      // const commentCount = data.shortcode_media.edge_media_to_parent_comment?.count;
      // let comments = data.shortcode_media.edge_media_to_parent_comment?.edges;
      // let commentInfo = data.shortcode_media.edge_media_to_parent_comment?.page_info;
      //END: data.shortcode_media.edge_media_to_parent_comment

      let otherComment = comments?.length;
      let getRpl = await this.getReplies(username, comments, contributors);
      responseCount += getRpl.responseCount;
      otherComment += getRpl.otherComment;
      // looping until has_next_page false
      let i = 0;
      let checkZero = 0;
      let checkLess3 = 0;
      // log("WHILE index: " + i + " with comments: " + comments.length);
      // LIMIT fetching comment up to 20 (1000 comments)
      // check is the result count ++ less than commentCount
      // Zero result up to 5 times
      // Less 3 up to 5
      while (commentInfo.has_next_page && i < 20 && (responseCount + otherComment) < commentCount && checkZero < 5 && checkLess3 < 5) {
         const r = await this.graphqlComment(pageId, commentInfo, delay);
         commentInfo = r.commentInfo;
         comments = r.comments;
         getRpl = await this.getReplies(username, comments, contributors);
         responseCount += getRpl.responseCount;
         otherComment += getRpl.otherComment;
         otherComment += comments.length;
         i++;
         if (comments.length == 0) {
            checkZero++;
         }
         if (comments.length <= 3) {
            checkLess3++;
         }
         // log("WHILE index: " + i + " with comments: " + comments.length + " and next: " + commentInfo.has_next_page);
      }

      const pageUrl = BASE_URL + "p/" + pageId;

      log("username: " + username + "\tfollower: " + followerCount + "\tlike: " + likeCount + "\tindex: " + i + "\tprefComment: " + commentCount + "\tgetComment: " + otherComment + "\tresponse: " + responseCount + "\tw/zero: " + checkZero + "\tw/less3: " + checkLess3 + "\tURL: " + pageUrl);
      if (commentCount != (otherComment + responseCount)) {
         log("PROBLEM: not same between commentCount and otherComment+responseCount");
      }

      // best threatment todo now
      // TODO how to handle many comment without blocked
      if (commentCount > 1000) {
         otherComment = commentCount;
      }
      return { username: username, pageURL: pageUrl, follower: followerCount, like: likeCount, comment: otherComment, response: responseCount, caption: caption, contributorsComments: getRpl.contributorsComments };
   }

   async getGraphqlPage(pageId, delay) {
      let pageURL = BASE_URL + `graphql/query/?query_hash=7d4d42b121a214d23bd43206e5142c8c&variables={"shortcode":"` + pageId + `"}`;
      await this.page.waitForTimeout(delay);
      const response = await this.page.goto(pageURL, { waitUntil: "networkidle0" });
      return response.json();
   }

   async getPagePage(pageId, contributors, delay = 3000) {
      try {
         // log("Fetching Page " + pageId);
         if (!await this.isLogin()) return;

         await this.page.waitForTimeout(delay);
         const result = await this.getGraphqlPage(pageId, delay);
         if (result.data && result.data.shortcode_media) {
            return await this.extractPage(pageId, contributors, delay, result.data);
         } else {
            // TODO need more alternatif
            // return {username: username, pageURL: pageUrl, follower: followerCount, like: likeCount, comment: otherComment, response: responseCount, caption: caption};
            log("getPapgePage: TODO: handling another format");
            return false;
         }

         // await this.page.goto(pageUrl, {waitUntil: "networkidle2"});
         // const html = await this.page.content();
         // var data = this.scrapePagePage(html);
         // if (data && data.graphql && data.graphql.shortcode_media) {
         //     return this.extractPage(pageId, contributors, delay, data.graphql);
         // }
         // else {
         // }
      } catch (e) {
         log("PAGE: error: " + e);
         return false;
      }
   }
}

module.exports = IBot;