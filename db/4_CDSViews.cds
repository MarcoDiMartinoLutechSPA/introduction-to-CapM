
namespace italy.db;

using { italy.db.master, italy.db.transaction } from './3_dataModel';

context CDSViews 
{
    define view ![poDetails] as select from transaction.purchaseOrder
    {
        key PO_ID as ![purchaseOrders],
        PARTNER_GUID.BP_ID as ![vendorID],
        PARTNER_GUID.COMPANY_NAME as ![companyName],
        GROSS_AMOUNT as ![poGrossAmount],
        CURRENCY_CODE as ![poCurrencyCode],
        key items.PO_ITEM_POS as ![itemPosition],
        items.PRODUCT_GUID.PRODUCT_ID as ![productID],
        items.PRODUCT_GUID.DESCRIPTION as ![productDescription],
        PARTNER_GUID.ADDRESS_GUID.CITY as ![city],
        PARTNER_GUID.ADDRESS_GUID.COUNTRY as ![country],
        items.GROSS_AMOUNT as ![itemGrossAmount],
        items.NET_AMOUNT as ![itemNetAmount],
        items.TAX_AMOUNT as ![itemTaxAmount]
    }

    define view ![itemView] as select from transaction.poItems 
    {
        key PARENT_KEY.PARTNER_GUID.NODE_KEY as ![vendor],
        PRODUCT_GUID.NODE_KEY as ![productID],
        CURRENCY_CODE as ![currencyCode],
        TAX_AMOUNT as ![taxAmount],
        PARENT_KEY.OVERALL_STATUS as ![poStatus]
    }

    //Using Aggregation

    define view productSum as select from master.product as prod 
    {
        key PRODUCT_ID as ![productID],
        texts.DESCRIPTION as ![description],

        (select from transaction.poItems as a {
            SUM(a.GROSS_AMOUNT) as SUM
        } where a.PRODUCT_GUID.NODE_KEY = prod.NODE_KEY) as PO_SUM : Decimal(10,2)
    }
}
