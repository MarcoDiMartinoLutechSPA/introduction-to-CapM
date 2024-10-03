//Convertiamo un servizio oData V4 in un servizio oData V2.
//andare al seguente link: https://www.npmjs.com/package/@sap/cds-odata-v2-adapter-proxy

const cds = require("@sap/cds");
const cov2ap = require("@sap/cds-odata-v2-adapter-proxy");
cds.on("bootstrap", (app) => app.use(cov2ap()));
module.exports = cds.server;