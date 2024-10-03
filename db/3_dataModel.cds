namespace italy.db;

//$self si usa quando si vuole confrontare la chiave primaria di questa tabella con quella di un'altra tabella.

/*
master context: contiene entità che rappresentano dati di riferimento (Master Data) — tipicamente statici o con 
                cambiamenti meno frequenti.

transaction context: contiene entità che rappresentano dati transazionali — dati dinamici che rappresentano eventi o 
                     processi operativi, spesso legati ai dati di riferimento.
*/

/* 
localized: quando si utilizza il termine localized, in un qualsiasi campo verrà creata automaticamente una tabella aggiuntiva.
           che quando sarà compilata in SQL Standard avrà come nome nomeTabella_texts.
*/

//I nomi delle entity una volta converiti in SQL Standard hanno questa struttura databaseName_db_contextType_entityName

//key ID : UUID; inserisci un ID univoco come chiave primaria senza che sia inserito manualmente in un file csv

/* 
    ASPECT

    Per utilizzare gli Aspect predefiniti bisogna importare la libreria: @sap/cds/common

    Si può usare cuid come comoda scorciatoia, per aggiungere chiavi primarie canoniche e universalmente univoche alle 
    definizioni delle entità.


    Aspect managed

    Utilizzare managed, per aggiungere quattro elementi per catturare le informazioni di gestione dei record 
    createdAt, createdBy, modifiedAt, modifiedBy
*/

/*
    @title : '{i18n>bp_key}' ci permette di convertire il nome del campo da quello che abbimo inserito nell' entity 
    a quello che abbiamo bindato come valore alla chiave bp_key nel file i18n
*/

using { cuid, managed } from '@sap/cds/common';
using { italy.customAspect } from './3_customAspect';

context master 
{
    entity worker : cuid, managed
    {
        //key ID : UUID;
        FIRST_NAME : String(30);
        LAST_NAME : String(30);
        GENDER : customAspect.Gender; 
        PHONE_NUMBER : customAspect.PhoneNumber;
        EMAIL : customAspect.Email;
        CURRENCY_CODE : String(3);
        SALARY_AMOUNT : Decimal(15,2); //Il primo parametro indica le cifre prima della virgola, mentre il secondo le cifre dopo la virgola
        //Si contano 7 campi in questa entity ma in verità ce ne sono 11, i quattro campi aggiuntivi sono: createdAt, createdBy, modifiedAt, modifiedBy
    }

    entity businessPartner : managed
    {       @title : '{i18n>bp_key}'
        key NODE_KEY : String(50);
            @title : '{i18n>bp_role}'
            BP_ROLE : Integer;
            @title : '{i18n>email_address}'
            EMAIL_ADDRESS : String(50);
            @title : '{i18n>phone_number}'
            PHONE_NUMBER : Integer;
            @title : '{i18n>fax_number}'
            FAX_NUMBER : Integer;
            @title : '{i18n>web_address}'
            WEB_ADDRESS : String(100);
            ADDRESS_GUID : Association to one address;
            @title : '{i18n>bp_id}'
            BP_ID : Integer;
            @title : '{i18n>company_name}'
            COMPANY_NAME : String(30);   
    }

    /*
    Sintassi alternativa per gestire le labels i18n:

    annotate businessPartner with 
    {
        NODE_KEY       @title : '{i18n>bp_key}';
        BP_ROLE        @title : '{i18n>bp_role}';
        EMAIL_ADDRESS  @title : '{i18n>email_address}'; 
        PHONE_NUMBER   @title : '{i18n>phone_number}'; 
        FAX_NUMBER     @title : '{i18n>fax_number}';
        WEB_ADDRESS    @title : '{i18n>web_address}';
        BP_ID          @title : '{i18n>bp_id}';  
        COMPANY_NAME    @title : '{i18n>company_name}';
    }
    */
    
    entity address
    {
        key NODE_KEY : String(50);
            CITY : String(44);
            POSTAL_CODE : String(8);
            STREET : String(44);
            BUILDING : String(128);
            COUNTRY : String(44);
            ADDRESS_TYPE : String(44);
            VAL_START_DATE : Date;
            VAL_END_DATE : Date;
            LATITUDE : Decimal;
            LONGITUDE : Decimal;
            businessPartner : Association to one businessPartner on businessPartner.ADDRESS_GUID = $self;
    }

    entity product
    {
        key NODE_KEY : String(50);
            PRODUCT_ID : String(20);
            TYPE_CODE : String(2);
            CATEGORY : String(32);
            DESCRIPTION : localized String(255);
            SUPPLIER_GUID : Association to one businessPartner;
            TAX_TARIF_CODE : Integer;
            MEASURE_UNIT : String(2);
            WEIGHT_MEASURE : Decimal;
            WEIGHT_UNIT: String(2);
            CURRENCY_CODE : String(4);
            PRICE : Decimal;
            WIDTH : Decimal;
            DEPTH : Decimal;
            HEIGHT : Decimal;
            DIM_UNIT : String(2);     
    }
}

context transaction 
{
    entity purchaseOrder : customAspect.Amount 
    {
        key NODE_KEY : String(50);
            PO_ID : String(24);
            PARTNER_GUID : Association to one master.businessPartner;
            LIFECYCLE_STATUS : String(1);
            OVERALL_STATUS : String(1);
            items : Association to many poItems on items.PARENT_KEY = $self;
    }

    entity poItems : customAspect.Amount
    {
        key NODE_KEY : String(50);
            PARENT_KEY : Association to one purchaseOrder;
            PO_ITEM_POS : Integer;
            PRODUCT_GUID : Association to one master.product;
    }
}
