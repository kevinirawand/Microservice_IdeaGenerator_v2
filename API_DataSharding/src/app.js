const express = require("express");
const database = require("./utils/database");
const config = require('./config/config.json');
const dataSharding = require("./service/data-sharding-service");
const postToServer = require("./service/post-to-server-service");


const app = express();
const db = new database(config.database);


app.get('/api/data-sharding', async (req, res) => {
   try {
      const theUsername = await db.getTheUsername();

      const shardResult = await dataSharding(theUsername, 3);

      const data = ["bpkadjabarprov", "call112surabaya", "dedimulyadi71"];

      await postToServer('http://localhost:5000/api/scrape', data);

      // await postToServer('http://localhost:6000/api/scrape', ["call112surabaya"]);

      // await postToServer('http://localhost:7000/api/scrape', ["dedimulyadi71"]);

      res.status(200).json({
         code: 200,
         status: "OK"
         // data: shardResult
      });
   } catch (error) {
      res.status(400).json({
         code: 400,
         status: "ERROR",
         error: {
            message: error.toString()
         }
      });
   }
});



app.use(express.json());
app.use(async (req, res, next) => {
   const error = new Error("This Route Does Not Exist");
   error.status = 404
   next(error);
});

app.use((err, req, res, next) => {
   res.status(err.status || 500).json({
      error: {
         status: err.status || 500,
         message: err.message
      }
   });
});


app.listen(config.port, async () => {
   console.info(`Server Started On Port : ${config.port}`);

   await db.connect();
})