using { italy.db.master } from '../db/3_dataModel';

service CQLService 
{
    @readonly
    entity readWorker as projection on master.worker;

    @insertonly
    entity insertWorker as projection on master.worker;

    @updateonly
    entity updateWorker as projection on master.worker;

    @deleteonly
    entity deleteWorker as projection on master.worker;
}