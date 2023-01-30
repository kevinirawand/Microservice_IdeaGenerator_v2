const mysql = require("promise-mysql");

function log(info) {
   console.log(info);
}

class Db {
   constructor(config) {
      this.config = config;
   }

   async connect() {
      try {
         this.connection = await mysql.createConnection(this.config);
         
         console.info("Database Connected");
      } catch (error) {
         console.error(error);
      }
   }

   destroy() {
      this.connection.destroy();
   }

   async getTheUsername() {
      // let query = `SELECT tg.ig_username FROM tbl_scrap_targets tg INNER JOIN tbl_engines en ON en.id_engine = tg.id_engine INNER JOIN tbl_users_scrap_targets us ON us.id_scrap_target = tg.id_scrap_target INNER JOIN tbl_users u ON u.id_user = us.id_user WHERE en.id_engine = 1 AND u.active = 1 GROUP BY tg.ig_username`;
      let query = `SELECT tg.ig_username FROM tbl_scrap_targets tg INNER JOIN tbl_engines en ON en.id_engine = tg.id_engine INNER JOIN tbl_users_scrap_targets us ON us.id_scrap_target = tg.id_scrap_target INNER JOIN tbl_users u ON u.id_user = us.id_user WHERE en.id_engine = 1 AND u.active = 1 AND tg.ig_username NOT IN (SELECT DISTINCT ig_username FROM tbl_scraping WHERE DATE(created) = DATE(NOW())) GROUP BY tg.ig_username`;
      const data = await this.connection.query(query);
      let arrayUsername = [];
      data.forEach(row => {
         arrayUsername.push(row.ig_username);
      });
      return arrayUsername;
   }

   async getContributorsByIgUsername(igUsername) {
      let query = `SELECT c.ig_username, c.contributor_id FROM tbl_contributors c JOIN tbl_users u ON c.user_id = u.id_user WHERE u.ig_username = ? AND u.active = 1 GROUP BY c.ig_username, c.contributor_id`;
      const data = await this.connection.query(query, [igUsername]);
      let arrayUsername = [];
      data.forEach(row => {
         arrayUsername.push({ ig_username: row.ig_username, contributor_id: row.contributor_id });
      });
      return arrayUsername;
   }

   async insertScrape(data) {
      let query = `INSERT INTO tbl_scraping(ig_username,url,follower_count,like_count,comment_count,response_count,taken_at,completed,category) VALUES ? `;
      let rows = [];
      for (const datum of data) {
         const d = [datum.ig_username, datum.url, datum.follower_count, datum.like_count, datum.comment_count, datum.response_count, datum.taken_at, datum.completed, datum.category];
         rows.push(d);
      }
      try {
         await this.connection.query(query, [rows]);
         return true;
      } catch (error) {
         log(error);
         return false;
      }
   }

   async updateScrape(datum) {
      const qu = `UPDATE tbl_scraping SET follower_count = ?, like_count = ?, comment_count = ?, response_count = ?, taken_at = ?, completed = ?, category = ? WHERE url = ?`;
      const quv = [datum.follower_count, datum.like_count, datum.comment_count, datum.response_count, datum.taken_at, datum.completed, datum.category, datum.url];
      try {
         await this.connection.query(qu, quv);
         return true;
      } catch (e) {
         log(e);
         return false;
      }
   }

   async selectScrape(datum) {
      const qi = `SELECT * FROM tbl_scraping WHERE url = ?`;
      const qiv = [datum.url];
      try {
         return await this.connection.query(qi, qiv);
      } catch (e) {
         log(e);
         return [];
      }
   }

   async insertOrUpdateScrape(data) {
      let query = `INSERT INTO tbl_scraping(ig_username,url,follower_count,like_count,comment_count,response_count,taken_at,completed,category) VALUES ? `;
      let rows = [];
      for (const datum of data) {
         // TODO need more code to catch ERROR because different data
         if (datum.ig_username == null) {
            log("ERROR: Username is not available, maybe the FORMAT is not prefered");
            return false;
         }
         const d = [datum.ig_username, datum.url, datum.follower_count, datum.like_count, datum.comment_count, datum.response_count, datum.taken_at, datum.completed, datum.category];
         // update if it exist
         let idata = await this.selectScrape(datum);
         if (idata && idata.length > 0) {
            await this.updateScrape(datum);
         } else {
            rows.push(d);
         }
      }
      if (rows.length > 0) {
         try {
            await this.connection.query(query, [rows]);
            return true;
         } catch (error) {
            log(error);
            return false;
         }
      }
   }

   async selectContributorResults(datum, isLike) {
      let qi = `SELECT * FROM tbl_contributor_results WHERE contributor_id = ? AND post_url = ? AND is_like = 1`;
      let qiv = [datum[0], datum[1]];
      if (!isLike) {
         qi = `SELECT * FROM tbl_contributor_results WHERE contributor_id = ? AND post_url = ? && is_date = ? AND is_comment = 1`;
         qiv = [datum[0], datum[1], datum[4]];
      }
      try {
         return await this.connection.query(qi, qiv);
      } catch (e) {
         log(e);
         return [];
      }
   }

   async insertOrUpdateContributorResults(data, page, isLike = true) {
      let query = `INSERT INTO tbl_contributor_results(contributor_id,post_url,is_comment,is_like,is_date,post_date) VALUES ? `;
      let rows = [];
      for (const datum of data) {
         let d = [datum.contributor_id, page.post_url, 0, 1, null, page.taken_at];
         if (!isLike) {
            d = [datum.contributor_id, page.post_url, 1, 0, datum.is_date, page.taken_at];
         }
         // update if it exist
         let idata = await this.selectContributorResults(d, isLike);
         if (idata && idata.length > 0) {
            continue;
         } else {
            rows.push(d);
         }
      }
      if (rows.length > 0) {
         try {
            await this.connection.query(query, [rows]);
            return true;
         } catch (error) {
            log(error);
            return false;
         }
      }
   }
}

module.exports = Db;