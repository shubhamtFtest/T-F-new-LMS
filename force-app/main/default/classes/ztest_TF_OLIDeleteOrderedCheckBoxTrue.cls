@isTest
public class ztest_TF_OLIDeleteOrderedCheckBoxTrue {

      @isTest static void testPromoCodeDiscSingleUse() {
       
            
        
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
       // createSingleUseCpqDiscConfigSampleData();  
            
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
        PricebookEntry priceBE1 = new PricebookEntry(CurrencyIsoCode = 'GBP',IsActive = True, Pricebook2Id = standardPricebookId, Product2Id = prodObject.Id,
                                                     UnitPrice = 100.00);                                                                
        insert priceBE1;
            
            
            
      
        Product2 prodObject1 = new Product2(Name = 'Test Product1', 
                                           RecordTypeId = TFProductsRecordTypeId,
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           ProductCode = 'GACR',
                                           Readership_Level__c = 'Test',
                                           IsActive = true,
                                           Family = 'Journals-Author Side Charges');  
        insert prodObject1;
        
      
        PricebookEntry priceBE3 = new PricebookEntry(CurrencyIsoCode = 'GBP',IsActive = True, Pricebook2Id = standardPricebookId, Product2Id = prodObject1.Id,
                                                     UnitPrice = 100.00);                                                                
        insert priceBE3;
        
       /* Pricebook2 priceBook2 = new Pricebook2(Name = priceBookName, IsActive = True);
        insert priceBook2;
        

        PricebookEntry priceBE2 = new PricebookEntry(CurrencyIsoCode = 'GBP',IsActive = True, 
                                                     Pricebook2Id = priceBook2.Id, Product2Id = prodObject.Id,
                                                     UnitPrice = 100.00);    
                                     
        insert priceBE2;*/         
            
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accObject = new Account(Name = 'Test Account',RecordTypeId = TFAccountsRecordTypeId,Type = 'Customer');
            insert accObject;
            
            Prepay_Accounts__c prepayAccountObj = new Prepay_Accounts__c(Name = 'Test Prepay Account', AccountName__c = accObject.Id, Total_Budgeted_Amount__c=2000.00);
        insert prepayAccountObj; 
        
        Id automatedOppeBookDirectSalesOrdersRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F Automated eBooks Opportunity').getRecordTypeId();
        Opportunity AutomatedeBookOpp = new Opportunity(name='Test',AccountId  = accObject.Id,SBQQ__Ordered__c = True , recordtypeid=automatedOppeBookDirectSalesOrdersRecordTypeId, StageName = 'Prospect', CloseDate = date.today(), Type = 'New Business', LeadSource ='Agent', Lead_Source_Detail__c ='N/A',CurrencyIsoCode ='GBP');
        INSERT AutomatedeBookOpp;
            
         
            opportunitylineitem opd = new opportunitylineitem();
            opd.Product2Id = prodObject.Id;
            opd.opportunityId = AutomatedeBookOpp.Id;
            opd.PricebookEntryId = priceBE1.Id;
            opd.UnitPrice = 100;
            opd.Quantity = 1;
            
           insert opd;
            opportunitylineitem opd1 = new opportunitylineitem();
            opd1.Product2Id = prodObject1.Id;
            opd1.opportunityId = AutomatedeBookOpp.Id;
            opd1.PricebookEntryId = priceBE3.Id;
            opd1.UnitPrice = 100;
            opd1.Quantity = 1;
            
           insert opd1;
            
            TriggerInterface_OLI triggerInterface = new TriggerInterface_OLI();
            TriggerInterface_OLI.trig  triggerObj = new TriggerInterface_OLI.trig();
            triggerObj.isAfter = true;
            triggerObj.isDelete = true;
            List<opportunitylineitem> oppLineList = new List<opportunitylineitem>();
            oppLineList.add(opd1);
        
        triggerObj.oldList = oppLineList;
        
        TF_OLIDeleteOrderedCheckBoxTrue  controller = new TF_OLIDeleteOrderedCheckBoxTrue ();
        controller.run(triggerObj);
        }
      }
}