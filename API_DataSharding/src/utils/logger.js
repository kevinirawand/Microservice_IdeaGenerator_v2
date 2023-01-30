const writelog = require("writelog");
const moment = require('moment');

let logger = {
   localDate: (date) => {
      if (!date) date = new Date();
      const utc = date.getTime();
      return new Date(utc + (3600000 * 7));
   },
   logFile: (info, filename = "logger") => {
      const d = logger.localDate();
      writelog((moment().format("YYYYMMDD") + "." + filename), info, { history: 1000 });
   },
   logFileDanger: (info) => {
      writelog((moment().format("YYYYMMDD") + ".danger"), info);
   },
   logFileOld: (info, filename = "logger") => {
      const d = logger.localDate();
      writelog((d.getFullYear() + `${(d.getMonth() + 1)}`.padStart(2, '0') + `${d.getDate()}`.padStart(2, '0') + "." + filename), info, { history: 1000 });
   }
}
module.exports = logger;