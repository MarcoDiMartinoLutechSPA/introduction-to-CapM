const { resolve } = require('@sap/cds');
const cds = require('@sap/cds');
const {worker} = cds.entities('italy.db.master');

const CQLService = function(service)
{
    //Legge i dati dell' entity worker
    service.on('READ', 'readWorker', async(req, res) => 
    {
        var results = [];
        results = await cds.tx(req).run(SELECT.from(worker).where({"FIRST_NAME" : "Saurabh"}));
        return results;
    });

    //Inserisce i dati nell' entity worker
    service.on('CREATE', 'insertWorker', async(req, res) =>
    {
        let returnData = await cds.transaction(req).run([
            INSERT.into(worker).entries([req.data])
        ]).then((resolve, reject) => 
        {
            if(typeof(resolve) !== undefined)
            {
                return req.data;
            }
            else 
            {
                req.error(500, "Si è verificato un errore imprevisto!");
            }
        }).catch(e => 
        {
            req.error(500, "Si è verificato il seguente errore: " + e.toString());
        });

        return returnData;
    });

    //Modifica i dati nell' entity worker
    service.on('UPDATE', 'updateWorker', async(req, res) => 
    {
        let returnData = await cds.transaction(req).run([
            UPDATE(worker).set({
                FIRST_NAME : req.data.FIRST_NAME
            }).where({ID : req.data.ID}),

            UPDATE(worker).set({
                LAST_NAME : req.data.LAST_NAME
            }).where({ID : req.data.ID}),
        ]).then((resolve, reject) => 
        {
            if(typeof(resolve) !== undefined)
            {
                return req.data;
            }
            else 
            {
                req.error(500, "Si è verificato un errore imprevisto!");
            }
        }).catch(e => 
        {
            req.error(500, "Si è verificato il seguente errore: " + e.toString());
        });

        return returnData;
    });

    //Elimina i dati nell' entity worker
    service.on('DELETE', 'deleteWorker', async(req, res) => 
    {
        let returnData = await cds.transaction(req).run([
            DELETE.from(worker).where(req.data)
        ]).then((resolve, reject) => 
        {
            if(typeof(resolve) !== undefined)
            {
                return req.data;
            }
            else 
            {
                req.error(500, "Si è verificato un errore imprevisto!");
            }
        }).catch(e => 
        {
            req.error(500, "Si è verificato il seguente errore: " + e.toString());
        });

        return returnData;
    });
}

module.exports = CQLService;