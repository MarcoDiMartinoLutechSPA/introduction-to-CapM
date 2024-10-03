module.exports = cds.service.impl(async function() {
    const { Worker } = this.entities;

    this.on('hike', async req => 
    {
        const { ID } = req.data;

        if (!ID) 
        {
            return req.reject(400, 'ID is required');
        }

        console.log(`Received request to increment salary for Worker with ID: ${ID}`);

        // Start a new transaction
        const tx = cds.transaction(req);

        try 
        {
            // Retrieve the current salary amount of the Worker using full entity name
            const workers = await tx.read(Worker).where({ ID: ID });

            if (!workers || workers.length === 0) 
            {
                await tx.rollback();
                return req.reject(404, `Worker with ID ${ID} not found.`);
            }

            const currentSalary = workers[0].SALARY_AMOUNT;
            console.log(`Current salary of Worker with ID ${ID} is ${currentSalary}`);

            // Perform the update operation to increment salaryAmount by 20000
            const result = await tx.update(Worker).set({ SALARY_AMOUNT: currentSalary + 20000 }).where({ ID: ID });

            if (result === 0) 
            {
                await tx.rollback();
                return req.reject(500, 'Failed to update salary');
            }

            console.log(`Salary of Worker with ID ${ID} incremented by 20000`);

            // Retrieve the updated Worker within the same transaction before committing
            const updatedWorker = await tx.read(Worker).where({ ID: ID });

            if (!updatedWorker || updatedWorker.length === 0) 
            {
                await tx.rollback();
                return req.reject(500, 'Failed to retrieve updated Worker');
            }

            // Commit the transaction
            await tx.commit();

            console.log(`Updated Worker with ID ${ID} retrieved successfully`);

            return req.reply({ message: "Incremented", Worker: updatedWorker[0] });
        } 
        catch(error) 
        {
            // Rollback the transaction in case of error
            console.error("Error during hike action:", error);

            try 
            {
                await tx.rollback();
            } 
            catch (rollbackError) 
            {
                console.error("Rollback failed:", rollbackError);
            }

            return req.reject(500, `Error: ${error.message}`);
        }
    });
});
