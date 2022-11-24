@isTest
public class zTest_reActivateQuoteTriggerHelper {
	
     @isTest static void testPromoCodeDiscSingleUse() {
       Integer i = 0;
         for (Id recordTypeId : Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosById().keySet()) {
             TriggerInterfaceHelper.runTrigger('reActivateQuoteTriggerHelper', 'SBQQ__Quote__c', ++i, 'au', recordTypeId, null);
            ++i; 
          
        }
            
        
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
        createSingleUseCpqDiscConfigSampleData();
        String priceBookName = 'T&F CPQ Price Book 2017';
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
        Product2 prodObject = new Product2(Name = 'Test Product', 
                                           RecordTypeId = TFProductsRecordTypeId,
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           ProductCode = 'GACR',
                                           Readership_Level__c = 'Test',
                                           IsActive = true,
                                           Family = 'Journals-Author Side Charges');  
        insert prodObject;
        
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> priceBEList = new List<PricebookEntry>();            
        PricebookEntry priceBE1 = new PricebookEntry(CurrencyIsoCode = 'USD',IsActive = True, Pricebook2Id = standardPricebookId, Product2Id = prodObject.Id,
                                                     UnitPrice = 100.00);                                  
        priceBEList.add(priceBE1);                              
        insert priceBEList;
        
        Pricebook2 priceBook2 = new Pricebook2(Name = priceBookName, IsActive = True);
        insert priceBook2;
        
        List<PricebookEntry> priceBEList2 = new List<PricebookEntry>();
        PricebookEntry priceBE2 = new PricebookEntry(CurrencyIsoCode = 'USD',IsActive = True, 
                                                     Pricebook2Id = priceBook2.Id, Product2Id = prodObject.Id,
                                                     UnitPrice = 100.00);    
        
        priceBEList2.add(priceBE2);                              
        insert priceBEList2;            
            
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accObject = new Account(Name = 'Test Account',RecordTypeId = TFAccountsRecordTypeId,Type = 'Customer');
            insert accObject;
            
            
             Id automatedeBookDirectSalesOrdersRecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Automated eBook Direct Sales Orders').getRecordTypeId();
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(Article_Title__c = 'Test', PromoCode__c = 'MAK-2018-USJFISD',SBQQ__Status__c = 'Expired',
                                                            SBQQ__ExpirationDate__c = date.today()+20,RecordTypeId=automatedeBookDirectSalesOrdersRecordTypeId);
            insert quoteObject;
            
            i = 0;
         for (Id recordTypeId : Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosById().keySet()) {
             TriggerInterfaceHelper.runTrigger('reActivateQuoteTriggerHelper', 'SBQQ__Quote__c', ++i, 'au', recordTypeId, null);
            ++i; 
          
        }
            
            quoteObject.SBQQ__Status__c = 'Draft';
            update quoteObject;
            

        }
    }
 private static void createSingleUseCpqDiscConfigSampleData() {
            Id TFCPQDiscountConfigurationRecordTypeId = Schema.SObjectType.CPQ_Discount_Configuration__c.getRecordTypeInfosByName().get('T&F - PromoCode').getRecordTypeId();
            CPQ_Discount_Configuration__c cpqDiscConfigObject = new CPQ_Discount_Configuration__c();             
            cpqDiscConfigObject.RecordTypeId = TFCPQDiscountConfigurationRecordTypeId;
            cpqDiscConfigObject.Discount_Type__c = '% Discount';
            cpqDiscConfigObject.Discount_Value_Percentage__c = 50.0;
            cpqDiscConfigObject.Promocode__c = 'MAK-2018-USJFISD';
            cpqDiscConfigObject.Product_Code__c = 'GACR';
            cpqDiscConfigObject.Discount_Display_Name__c = 'Coupon code';
            cpqDiscConfigObject.Active__c = true;
            cpqDiscConfigObject.Single_Use__c = true;
            cpqDiscConfigObject.Used_Quote__c='';
            cpqDiscConfigObject.Number_of_Quotes_used_this_PromoCode__c=null;
            cpqDiscConfigObject.Start_Date__c = date.today();
            cpqDiscConfigObject.End_Date__c = date.today()+20;
            insert cpqDiscConfigObject; 
    }    
    
    
}