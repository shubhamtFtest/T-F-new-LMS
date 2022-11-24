global class TF_Batch_DeleteBundleLineItemsAndProduct implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts{
    
    private String orgPrdId;
    
    List<Bundle_Line_Item__c> fullBLItms = new List<Bundle_Line_Item__c>() ;
    
    public TF_Batch_DeleteBundleLineItemsAndProduct(String productId) {
        orgPrdId = productId;
    }
    
    global Database.queryLocator start(Database.BatchableContext BC) {
        
        Product2 originalProduct = [select Id,name, Hub_Id__c FROM Product2 WHERE id = :orgPrdId limit 1];
        String queryString = 'SELECT id FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c =: orgPrdId ORDER BY Content_Position__c'; 
        return Database.getQueryLocator(queryString);
        
    }
    
    global void execute(Database.BatchableContext BC,  List<Bundle_Line_Item__c> BLIlist) {
        if(!BLIlist.isEmpty() && BLIlist.size() >0 && BLIlist!= null){
            Database.delete(BLIlist, false);
        }
    }
    
    global void finish(Database.BatchableContext BC) { 
        
        try
        {
            List<Pricebook2> priceBookId;
            Id standardPriceBookId;
            List<Pricebook2> priceEbookBookId;
            Id ebookPriceBookId;
            
            if (test.isrunningtest())
            {
                standardPriceBookId=Test.getStandardPricebookId();       
            }
            else
            {
                priceBookId=[select Id from Pricebook2 where isStandard=true];
                standardPriceBookId= priceBookId[0].id; 
                priceEbookBookId=[select Id from Pricebook2 where name='T&F - eBooks Pricebook'];
                ebookPriceBookId= priceEbookBookId[0].id; 
            }
            
            List <PricebookEntry> pbe = [select UnitPrice,CurrencyIsoCode from Pricebookentry where product2id=:orgPrdId];
            //Deleting the Related Order 

            List<OrderItem> orderLineItems = [Select id,Product2Id from OrderItem where Product2Id = :orgPrdId];
            system.debug('orderLineItems'+orderLineItems);
            database.delete(orderLineItems);
            
            //Deleting the Opp Line Items 

            /*List<OpportunityLineItem> oppLineItems = [Select id,Product2Id from OpportunityLineItem  where Product2Id = :orgPrdId];
            if(oppLineItems.size() > 0){
                database.delete(oppLineItems);
            }*/
            //Deleting the Product
            product2 prd = new product2();
            prd.id = orgPrdId ; 
            database.delete(prd);
            
            //Deleting the PriceBookEntry
            database.delete(pbe);
            
        }
        Catch(Exception ex){
            system.debug(ex.getMessage());
        }
        
    }   
}