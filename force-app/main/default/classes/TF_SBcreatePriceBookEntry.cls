/**
* Batch class 
*/
global class TF_SBcreatePriceBookEntry implements Database.Batchable<sObject>
{
    Private String productFamilyName = 'Journals-Author Side Charges';
    Private String cpqPricebookName = 'T&F CPQ Price Book 2017';
    Private Id RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
    
    global  String query;
    
    
    global TF_SBcreatePriceBookEntry() 
    {
        GenerateQuery(); 
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }
    
    
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        Set<Id> productIdSet = new Set<Id>();
        Set<Id> productIdSetToUpdate = new Set<Id>();
        List<Id> productIdList = new List<Id>();
        //Add the product ID for which the price to be checked 
        for (sObject o : scope)
        {
            Product2 prod = (Product2) o;
            productIdList.add(prod.id);
        }
        // Get the currencies from custom settings for which the price to be created
        Map<String, TF_PriceBookEntry_Currencies__c> pbeCurrencyMap= TF_PriceBookEntry_Currencies__c.getAll();
        // Get the active currencies in salesforce
        List<currencyType> activeCurrencyLst=[select id, isoCode, conversionrate from CurrencyType WHERE isocode in :pbeCurrencyMap.keyset() and isactive = true];
        Set<String> pbeCurrencySet= new Set<String>();
        // check the custom settings currency is active in salesforce and add it to set
        /*for(string pbecurr : pbeCurrencyMap.keyset()) {
            for(currencyType activeCurr : activeCurrencyLst) {
                if(pbecurr == activeCurr.IsoCode) {
                    pbeCurrencySet.add(pbecurr.toUpperCase());
                    break;                    
                } 
                
            }
        }*/
         for(currencyType activeCurr : activeCurrencyLst) {
            pbeCurrencySet.add(activeCurr.IsoCode);     
        }
        //Get the products and price book entries for which the price book entries to be created
        /*List<Product2> productMap = new List<Product2>([select id, (select id,utility_created__c from pricebookentries where currencyisocode in :pbecurrencyset and pricebook2.Name = :cpqPricebookName )
                                                        from product2 where id in :productIdList]);*/
         if (pbeCurrencySet.size() > 0) {     // added if condition 
            List<Product2> productMap = new List<Product2>([SELECT Id, 
                                                                (SELECT Id, Utility_Created__c 
                                                                 FROM pricebookentries 
                                                                 WHERE CurrencyIsoCode IN :pbecurrencyset 
                                                                    AND Pricebook2.Name = :cpqPricebookName 
                                                                    AND IsActive = TRUE)
                                                            FROM Product2 
                                                            WHERE Id IN :productIdList]);
         
        // Add only the products for which the price is not present for all the currencies
        for(Product2 prod: productMap) {
            if(prod.pricebookentries.size() < pbeCurrencySet.size() && prod.pricebookentries.size() > 0) {
                productIdSet.add(prod.id);
            }
        
            // Get the price book entries which are created by this batch class.
            for(Pricebookentry pb : prod.pricebookentries) {
                if(pb.Utility_Created__c == true) {
                    productIdSetToUpdate.add(prod.Id);
                    break;
                }
            }
        }
         }
        // create price book entries for the missing currencies
        if(!productIdSet.isEmpty() && !pbeCurrencySet.isEmpty()) {
            TF_SBcreatePriceBookEntryHandler.createPriceBookEntries(productIdSet, pbeCurrencySet);
        }  
        //check whether the price in price book entries which are created using conversion rate has changed
        if(!productIdSetToUpdate.isEmpty() && !pbeCurrencySet.isEmpty()) {
            TF_SBcreatePriceBookEntryHandler.updateprices(productIdSetToUpdate, pbeCurrencySet);
        }  
    }     
    
    global void finish(Database.BatchableContext BC)
    {
        
    } 
    
    Public void GenerateQuery()
    {
        //String baseQuery = 'Select Id, name From Product2 where family= \''+productFamilyName+'\' and RecordTypeid= \''+RecordTypeId+'\'';
        String baseQuery = 'SELECT Id, Name FROM Product2 WHERE Family = \''+productFamilyName+'\' AND RecordTypeid = \''+RecordTypeId+'\' AND IsActive = TRUE';
        this.query = baseQuery;
    }
}