using { italy.db.master, italy.db.transaction } from '../db/3_dataModel';

/* 
Il compilatore di default scarta la parte del nome che inizia con una lattera maiuscola, se il nome dato al servizio 
inizia con una lettera maiuscola allora viene scartata quella parte del nome che inzia con la seconda lettera maiuscola

Per dare al servizio il nome completo quando esso viene avviato dobbiamo usare: @( path : 'catalogService')

Aggiungere i seguenti parametri dopo l' url dell' oData per effettuare dei test su di esso:

/$count = permette di contare il numero di record presente nell' entity
?$top=2 = permette di visualizzare solo i primi due record presente nell' entity
/chiavePrimariaEntity = permette di visualizzare solo il record che possiede quella chiave primaria
?$select=nomeCampo1,nomeCampo2 = ci permette di visualizzare solo questi due campi per tutte le entity dell' oData

nomeEntity?$expand=nomeEntityAssociata =
{
    Es: address?$expand=businessPartner espande i record dell' entity nomeEntity che però hanno un ulteriore
    campo che si chiama nomeEntityAssociata e il record visualizzato all' interno di nomeEntityAssociata è quello che condivide
    il valore uguale tra il suo campo foreign key ed il campo primary key di nomeEntity.

    Es: address?$expand=businessPartner
}

nomeEntity?$expand=nomeChiaveEsternaInEntity =
{
    Espande tutti i record dell' entity nomeEntity che però hanno un ulteriore campo che si chiama 
    nomeChiaveEsternaInEntity e il record visualizzato all' interno del campo nomeChiaveEsternaInEntity 
    è quello che condivide il valore uguale tra il suo campo primary key ed il campo foreign key di nomeEntity

    Es: poItems?$expand=PARENT_KEY.  
}

nomeEntity?$expand=nomeChiaveEsternaInEntity($expand=nomeChiaveEsternaInEntityInNomeChiaveEsternaInEntity) = 
{
    Vengono visualizzati tutti i record dell' entity nomeEntity che però hanno un ulteriore campo che si chiama 
    nomeChiaveEsternaInEntity e il record visualizzato all' interno del campo nomeChiaveEsternaInEntity 
    è quello che condivide il valore uguale tra il suo campo primary key ed il campo foreign key di nomeEntity, a sua volta
    nomeChiaveEsternaInEntity ha un altro campo aggiuntivo chiamato nomeChiaveEsternaInEntityInNomeChiaveEsternaInEntity che
    ha come record quello che ha il valore del suo campo primary key uguale al campo foreign key di nomeChiaveEsternaInEntity.

    Es: poItems?$expand=PARENT_KEY($expand=PARTNER_GUID).  
}

*/

//L' annotation @readonly consente operazioni di sola lettura (GET)

/*
    Alle volte si ha necessità che un' entity possa essere letta ed anche cancellata ma non modificata o viceversa, 
    ma l' annotatione @readonly non permette ciò perchè consente operazioni di sola lettura, per ovviare a questo problema 
    ci viene in aiuto l' annotation Capabilities.
*/

service catalogService @(path : 'catalogService')
{
    entity businessPartner as projection on master.businessPartner;
    entity address as projection on master.address;

    @readonly
    entity product as projection on master.product;

    entity worker as projection on master.worker;

    
    entity purchaseOrder as projection on transaction.purchaseOrder;
    annotate catalogService.purchaseOrder with 
    @( 
        Capabilities:
        {
            InsertRestrictions : { Insertable: true }, //Possiamo inserire anche solo Insertable perchè il valore di default è true
            UpdateRestrictions : { Updatable: false},
            DeleteRestrictions : { Deletable: false },
        }
    );
    

    entity poItems as projection on transaction.poItems;
}