using { italy.db.master } from '../db/3_dataModel';

service increment 
{
    entity Worker as projection on master.worker; 
    action hike(ID : UUID);
}

/* 
Se vogliamo implentare un servizio che non è presente in un file .cds che ha lo stesso nome del file service.js dobbiamo 
utilizzare questa sintassi:

@impl: './6_incrementLogic.js'

service increment 
{
    entity Worker as projection on master.worker; 
    action hike(ID : UUID);
}
*/