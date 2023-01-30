const logger = require("../utils/logger");
const axios = require('axios');


const postToServer = async (address, data) => {
   const port = address.split(":")[2].split("/", 1)[0];
   // POST DATA TO ADDRESS

   axios.post(address, data)
      .then(function (response) {
         console.log(port);
         logger.logFile(`{
            date: ${response.headers.date},
            code: ${response.status},
            status: ${response.statusText},
            data: {
               message: ${response.data}
            }
         }`, port)
      })
      .catch(function (error) {
         logger.logFile(`{
            ${error}
         }`, `error_log`)
      });

}

module.exports = postToServer;