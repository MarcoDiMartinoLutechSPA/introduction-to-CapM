using { italy.db.master } from '../db/3_dataModel';

service highSalary 
{
    entity Workers as projection on master.worker; 
    function getHighestSalary() returns Decimal(15,2);
}