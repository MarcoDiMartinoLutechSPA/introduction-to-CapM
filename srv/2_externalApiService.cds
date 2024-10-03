//using {nomeDB.db.nomeEntità} from 'pathNomeFileDovePresenteEntità'

using { italy.db.externalData } from '../db/2_externalApiDataModel';

service externalApiService
{
    //l' entity externalApi è una proiezione di externalData 
    entity externalApi as projection on externalData
}