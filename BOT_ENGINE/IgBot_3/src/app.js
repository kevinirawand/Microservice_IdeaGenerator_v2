const express = require("express");
const config = require("./config/config.json");
const Db = require("./utils/Db");
const getScrape = require("./service/scrap-service");


const app = express();
app.use(express.json());
const database = new Db(config.database);

app.post('/api/scrape', async (req, res) => {
   try {
      await getScrape(database, req.body);

      res.status(200).send("SUKSES SCRAPE");
   } catch (error) {
      res.status(error.status).json({
         date: response.headers.date,
         code: response.status,
         status: response.statusText,
         errors: {
            message: error.toString()
         }
      })

      // console.error(error)
   }

   setTimeout(process.exit(1), 10000);
})


app.listen(config.port, async () => {
   console.info(`Server Started On Port : ${config.port}`);

   await database.connect();
});