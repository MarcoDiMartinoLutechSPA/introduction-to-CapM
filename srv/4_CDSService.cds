using { italy.db.CDSViews } from '../db/4_CDSViews';

service CDSViewsService @(path : 'CDSViewsService')
{
    entity poDetails as projection on CDSViews.poDetails;
    entity itemView as projection on CDSViews.itemView;
    entity productSum as projection on CDSViews.productSum;
}

