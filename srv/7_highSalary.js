const cds = require('@sap/cds');

module.exports = srv => 
{
    srv.on('getHighestSalary', async () =>
    {
        try
        {
            const {worker} = cds.entities('italy.db.master');

            //fetch the worker with highest salary
            const highestSalaryWorker = await 
            cds.run(SELECT.one `SALARY_AMOUNT as highestSalary` .from(worker).orderBy `SALARY_AMOUNT DESC`);

            if(highestSalaryWorker)
            {
                return highestSalaryWorker.highestSalary;
            } 
            else 
            {
                return null;
            }
        }
        catch (error)
        {
            console.error('Error fetching highest Salary: ' , error);
            return null;
        }
    })
}