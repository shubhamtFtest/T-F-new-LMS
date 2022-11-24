/***************************************************************************************
   This test class is used for TF_SBcreatePriceBookEntry batch class.
******************************************************************************************/
@isTest
public class zTEST_TF_SBcreatePriceBookEntry {
    /****************************************************************************************
     This method is used to test TF_SBcreatePriceBookEntry batch class.
    *****************************************************************************************/
    @isTest static void testCreatePriceBookEntry() {
        system.runAs( new User( ID = UserInfo.getUserId() ) ) { 
            //Create TF_PriceBookEntry_Currencies__c custom settings
            List<TF_PriceBookEntry_Currencies__c> priceBECList = new List<TF_PriceBookEntry_Currencies__c>();
            TF_PriceBookEntry_Currencies__c priceBEC1 = new TF_PriceBookEntry_Currencies__c(CurrencyIsoCode = 'USD', Name = 'USD');
            priceBECList.add(priceBEC1);
            TF_PriceBookEntry_Currencies__c priceBEC2 = new TF_PriceBookEntry_Currencies__c(CurrencyIsoCode = 'EUR', Name = 'EUR');
            priceBECList.add(priceBEC2);
            TF_PriceBookEntry_Currencies__c priceBEC3 = new TF_PriceBookEntry_Currencies__c(CurrencyIsoCode = 'GBP', Name = 'GBP');
            priceBECList.add(priceBEC3);
            TF_PriceBookEntry_Currencies__c priceBEC4 = new TF_PriceBookEntry_Currencies__c(CurrencyIsoCode = 'AUD', Name = 'AUD');
            priceBECList.add(priceBEC4);
            insert priceBECList;
            
            //Create Products
            List<Product2> productList = new List<Product2>();
            Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
            Product2 prodObject = new Product2(RecordTypeId = TFProductsRecordTypeId, 
                                           Name = 'Test Prod',
                                           Family = 'Journals-Author Side Charges',
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           Readership_Level__c = 'Test',
                                           IsActive = true);
            productList.add(prodObject); 
            Product2 prodObject2 = new Product2(RecordTypeId = TFProductsRecordTypeId, 
                                           Name = 'Test Prod2',
                                           Family = 'Journals-Author Side Charges',
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           Readership_Level__c = 'Test',
                                           IsActive = true);
            productList.add(prodObject2);
            insert  productList;
            Product2 prodObj = new Product2();
            prodObj = [SELECT Id,IsActive,Name FROM Product2 where Name = 'Test Prod'];
            Product2 prodObj2 = new Product2();
            prodObj2 = [SELECT Id,IsActive,Name FROM Product2 where Name = 'Test Prod2'];
            
            //Insert Price Book Entries in standard Price Book for both products
            String standardPricebookId =Test.getStandardPricebookId();
            List<PricebookEntry> priceBEList = new List<PricebookEntry>();
            PricebookEntry priceBEObj1 = new PricebookEntry(CurrencyIsoCode = 'AUD',IsActive = True, Pricebook2Id = standardPricebookId, Product2Id = prodObj.Id,
                                                          UnitPrice = 100.00);
            priceBEList.add(priceBEObj1);
            PricebookEntry priceBEObj2 = new PricebookEntry(CurrencyIsoCode = 'GBP',IsActive = True, Pricebook2Id = standardPricebookId, Product2Id = prodObj.Id,
                                                          UnitPrice = 200.00);
            priceBEList.add(priceBEObj2);
            PricebookEntry priceBEObj3 = new PricebookEntry(CurrencyIsoCode = 'EUR',IsActive = True, Pricebook2Id = standardPricebookId, Product2Id = prodObj.Id,
                                                          UnitPrice = 300.00);
            priceBEList.add(priceBEObj3);
            PricebookEntry priceBEObj4 = new PricebookEntry(CurrencyIsoCode = 'USD',IsActive = True, Pricebook2Id = standardPricebookId, Product2Id = prodObj2.Id,
                                                          UnitPrice = 400.00);
            priceBEList.add(priceBEObj4);
            PricebookEntry priceBEObj5 = new PricebookEntry(CurrencyIsoCode = 'EUR',IsActive = True, Pricebook2Id = standardPricebookId, Product2Id = prodObj2.Id,
                                                          UnitPrice = 500.00);
            priceBEList.add(priceBEObj5);
            insert priceBEList;
            
            //Insert Price Book Entries in custom Price Book for first product
            Pricebook2 priceBook2 = new Pricebook2(Name = 'T&F CPQ Price Book 2017', IsActive = True);
            insert priceBook2;
            Pricebook2 PriceB2 = new Pricebook2();
            priceB2 = [SELECT Id,IsActive,IsStandard,Name FROM Pricebook2 where Name = 'T&F CPQ Price Book 2017'];
            
            List<PricebookEntry> priceBEList2 = new List<PricebookEntry>();
            PricebookEntry priceBEObject1 = new PricebookEntry(CurrencyIsoCode = 'AUD',IsActive = True, Pricebook2Id = priceB2.Id, Product2Id = prodObj.Id,
                                                          UnitPrice = 600.00);
            priceBEList2.add(priceBEObject1);
            PricebookEntry priceBEObject2 = new PricebookEntry(CurrencyIsoCode = 'GBP',IsActive = True, Pricebook2Id = priceB2.Id, Product2Id = prodObj.Id,
                                                          UnitPrice = 700.00, Utility_Created__c = True);
            priceBEList2.add(priceBEObject2);
            insert priceBEList2;
              
            Test.startTest();
            
            //Run batch class
            Id batchJobId1 = Database.executeBatch(new TF_SBcreatePriceBookEntry(), 200);
            
            //Insert Price Book Entry in custom Price Book for second Product
            PricebookEntry priceBEObject3 = new PricebookEntry(CurrencyIsoCode = 'USD',IsActive = True, Pricebook2Id = priceB2.Id, Product2Id = prodObj2.Id,
                                                          UnitPrice = 700.00);
            insert priceBEObject3;
            
            ////Run batch class
            Id batchJobId2 = Database.executeBatch(new TF_SBcreatePriceBookEntry(), 200);
            Test.stopTest();
        
            
            List<PricebookEntry> priceBEList3 = new List<PricebookEntry>();
            priceBEList3 = [SELECT CurrencyIsoCode,Id,IsActive,Name,Pricebook2Id,Product2Id,UnitPrice,UseStandardPrice,Utility_Created__c FROM PricebookEntry 
                        WHERE Product2Id = :prodObj.Id AND Pricebook2Id = :priceB2.Id];
            System.assertEquals(priceBEList3.size(), 4);
            
            List<PricebookEntry> priceBEList4 = new List<PricebookEntry>();
            priceBEList4 = [SELECT CurrencyIsoCode,Id,IsActive,Name,Pricebook2Id,Product2Id,UnitPrice,UseStandardPrice,Utility_Created__c FROM PricebookEntry 
                        WHERE Product2Id = :prodObj2.Id AND Pricebook2Id = :priceB2.Id];
            System.assertEquals(priceBEList4.size(), 4);
        }   
    }
}