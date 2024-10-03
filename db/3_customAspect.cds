namespace italy.customAspect;

type Gender : String(1) enum 
{
    male = 'M';
    female = 'F';
    other = 'O';
    noDisclosure = 'N';
}

//Bisogna utilizzare assert.format per la convalida. Controlla il numero di telefono e il formato delle e-mail.

type PhoneNumber : String(30) @assert.format : '^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]\d{3}[\s.-]\d{4}$';
type Email : String(255) @assert.format : '^[a-zA-Z0-9_.±]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+$';

/* 
    Definiamo un aspect chiamato amount e lo richiamiamo dentro il file 3_dataModel.cds in più entity senza l' aspect amount 
    avremmo dovuto inserire i campi dentro di esso per tutte le entity su cui viene richiamato.
*/

type AmountType : Decimal(15,2); 

aspect Amount 
{
    CURRENCY_CODE : String(4);
    GROSS_AMOUNT : AmountType;
    NET_AMOUNT : AmountType;
    TAX_AMOUNT : AmountType;
}

