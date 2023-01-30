const IBot = require("./bot-service");
const helper = require("../utils/helper");


const getScrape = async (db, data) => {

   const HEADLESS = false; // use false for login only
   const DB_SAVE = true;

   // BYPASS account

   // const iBot = new IBot(config.account);

   // bypass account,
   const account = [
      {
         //[0] ready 11/11 03:20
         username: "suprihotman",
         password: "test12345!",
      },
   ];

   const iBot = new IBot(account[0]);
   // BYPASS account

   let failedUsername = [];

   function log(info) {
      console.log(info);
      helper.logFile(info, "index");
   }

   function Mylog(info) {
      console.log(info);
      helper.logFile(info, "KEVIN_TESTING");
   }

   async function getUsernamePage(username) {
      return await iBot.getUsernamePage(username);
   }

   async function getPagePage(shortCode, contributors) {
      return await iBot.getPagePage(shortCode, contributors);
   }

   function logDate(date) {
      if (!date) date = new Date();
      date = helper.localDate(date);
      return date.toISOString().replace(/T/, " ").replace(/\..+/, "");
   }

   function convertTimeToDate(timestamp) {
      const d = new Date(timestamp * 1000);
      return logDate(d);
   }

   function getCategory(pages) {
      if (pages.length <= 0) return [];
      let cat = [];
      pages.forEach((p) => {
         cat.push(p.like);
         log("THIS IS CATEGORY : " + p.like)
      });
      cat.sort((a, b) => {
         return a - b;
      });
      let highest = cat[cat.length - 1];
      // refer to engine.py using spike rate
      spikeRate = highest / cat[cat.length - 2];
      if (spikeRate > 2) {
         highest = cat[cat.length - 2];
      }
      const sprate = (highest - cat[0]) / 4;
      return { min: cat[0], sprate: sprate };
   }

   async function getLikeInfo(contributors, username, page) {
      log(
         "START get contributors like with username: " +
         username +
         " and shortcode: " +
         page.shortcode
      );
      // get all likers based on shortcode
      // return only contributors who like the page
      if (contributors && contributors.length > 0) {
         const contributorsLikers = await iBot.getContributorAsLiker(
            page.shortcode,
            contributors
         );
         // insert or update contributor results
         if (contributorsLikers.length > 0) {
            try {
               page.taken_at = convertTimeToDate(page.taken_at_timestamp);
               page.post_url = iBot.baseURL() + "p/" + page.shortcode;
               await db.insertOrUpdateContributorResults(contributorsLikers, page);
            } catch (error) {
               log("getLikeInfo: FAILED. Error: " + error);
            }
         }
      }
      log(
         "FINISH get contributors like with username: " +
         username +
         " and shortcode: " +
         page.shortcode
      );
      return true;
   }

   async function saveContributorsComments(contributorsComments, page) {
      if (contributorsComments && contributorsComments.length > 0) {
         try {
            page.taken_at = convertTimeToDate(page.taken_at_timestamp);
            page.post_url = iBot.baseURL() + "p/" + page.shortcode;
            // change date format
            for (var i = 0; i < contributorsComments.length; i++) {
               contributorsComments[i].is_date = convertTimeToDate(
                  contributorsComments[i].created_at
               );
            }
            await db.insertOrUpdateContributorResults(
               contributorsComments,
               page,
               false
            );
         } catch (error) {
            log("saveContributorsComments: FAILED. Error: " + error);
         }
      }
      return true;
   }

   async function scrape(theUsername) {
      // add false to see chromium browser
      await iBot.init(HEADLESS);

      const isLogin = await iBot.isLogin();
      if (isLogin) {
         // looping for scrape username page
         const UNTIL_INDEX = -1;

         for (let i = 0; i < theUsername.length; i++) {
            // contributor feature
            // get all database username based on username's shortcode
            const contributors = await db.getContributorsByIgUsername(theUsername[i]);
            const getPages = await getUsernamePage(theUsername[i]);
            if (!getPages) {
               // log("Username " + theUsername[i] + " gagal dirayap.");
               failedUsername.push(theUsername[i]);
               if (UNTIL_INDEX == i) {
                  i = theUsername.length;
                  break;
               }
               continue;
            }
            const pages = getPages.pages;
            const category = getCategory(pages);
            let r1 = category.sprate + category.min;
            let r2 = r1 + category.min;
            let r3 = r2 + category.min;
            // looping for scrape comment based on username page post
            let scrapeRows = [];
            for (const page of pages) {
               // log(page);
               // Optimize by using condition, if comment count 0 or comment Disabled, skip the line code below
               // BUT remember there is no caption comment there
               let post;
               if (page.comment > 0 && !page.commentDisabled) {
                  post = await getPagePage(page.shortcode, contributors);
               } else {
                  const pageURL = iBot.baseURL() + "p/" + page.shortcode;
                  post = {
                     username: theUsername[i],
                     pageURL: pageURL,
                     follower: page.follower,
                     like: page.like,
                     comment: 0,
                     response: 0,
                     commentDisabled: page.commentDisabled,
                  };
                  if (page.commentDisabled) {
                     log(
                        theUsername[i] +
                        " COMMENT of page: " +
                        page.shortcode +
                        " is DISABLED"
                     );
                  }
               }
               // log(post);
               // get engagement
               let engagement = "L";
               if (post.like >= r1 && post.like < r2) {
                  engagement = "M";
               } else if (post.like >= r2 && post.like < r3) {
                  engagement = "H";
               } else if (post.like >= r3) {
                  engagement = "H";
               }
               const scrapeRow = {
                  ig_username: post.username,
                  url: post.pageURL,
                  follower_count: post.follower,
                  like_count: post.like,
                  comment_count: post.comment,
                  response_count: post.response,
                  completed: 1,
                  taken_at: convertTimeToDate(page.taken_at_timestamp),
                  category: engagement,
               };
               scrapeRows.push(scrapeRow);

               // contributors like
               if (page.like > 0) {
                  if (DB_SAVE) {
                     await getLikeInfo(contributors, theUsername[i], page);
                  }
               }
               //contributors comments
               // think here, login is AVAILABLE
               if (post.contributorsComments && post.contributorsComments.length > 0) {
                  if (DB_SAVE) {
                     await saveContributorsComments(post.contributorsComments, page);
                  }
               }
            }
            if (scrapeRows.length > 0) {
               try {
                  if (DB_SAVE) {
                     await db.insertOrUpdateScrape(scrapeRows);
                  }
               } catch (error) {
                  log("SAVE SCRAPE: FAILED. Error: " + error);
               }
            }
            if (UNTIL_INDEX >= 0 && UNTIL_INDEX == i) {
               i = theUsername.length;
               break;
            }
         }
      } else {
         log("Cannot Login");
      }
   }

   // connect to DB

   const theUsername = data;
   log(theUsername)

   // const theUsername = ["bpkadjabarprov","call112surabaya","dedimulyadi71","denpasarkota","diskominfomks","dlh_jabar","geonusantara","joel_camerastore","mandalajati_unik","mediacenter_kotabengkulu","sonyalpha_id"];
   // const theUsername = [];

   // scrape IG
   log("=== START scrape with " + theUsername.length + " username(s)");
   await scrape(theUsername);

   // finishing
   iBot.exit();
   db.destroy();

   log("=== FINISH scrape with " + theUsername.length + " username(s)");
}

module.exports = getScrape;