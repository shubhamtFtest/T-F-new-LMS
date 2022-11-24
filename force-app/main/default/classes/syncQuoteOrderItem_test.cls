@isTest
public class syncQuoteOrderItem_test {

    @isTest static void testPromoCodeDiscSingleUse() {
       
            
        
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
            
         Order automatedOrderTest = new Order(AccountId = accObject.Id,Pricebook2Id = standardPricebookId,OpportunityId = AutomatedeBookOpp.Id,EffectiveDate =date.today(),CurrencyIsoCode ='GBP',Status ='DRAFT');
        insert automatedOrderTest;
            OrderItem opd = new OrderItem();
            opd.Product2Id = prodObject.Id;
            opd.OrderId = automatedOrderTest.Id;
            opd.PricebookEntryId = priceBE1.Id;
            opd.UnitPrice = 100;
            opd.Quantity = 1;
            
           insert opd;
            
             Id automatedeBookDirectSalesOrdersRecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Automated eBook Direct Sales Orders').getRecordTypeId();
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(Article_Title__c = 'Test', PromoCode__c = 'MAK-2018-USJFISD',SBQQ__Status__c = 'Draft',SBQQ__Opportunity2__c = AutomatedeBookOpp.Id,SBQQ__Primary__c = True,
                                                            SBQQ__ExpirationDate__c = date.today()+20,RecordTypeId=automatedeBookDirectSalesOrdersRecordTypeId);
            insert quoteObject;
            List<SBQQ__QuoteLine__c> listToInsert = new List<SBQQ__QuoteLine__c>();
            
            SBQQ__QuoteLine__c quoteLineObject1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id, SBQQ__Product__c = prodObject1.Id, Discount_Rules_Applied__c = 'Prepay');
       		 insert quoteLineObject1;
           /* SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(
                SBQQ__Quote__c = quoteObject.Id, 
                SBQQ__Product__c = prodObject.Id,
                Discount_Rules_Applied__c = 'PROMOCODE');
            listToInsert.add(quoteLineObject);
            
            SBQQ__QuoteLine__c quoteLineObject1 = new SBQQ__QuoteLine__c(
                SBQQ__Quote__c = quoteObject.Id, 
                SBQQ__Product__c = prodObject1.Id,
                Discount_Rules_Applied__c = 'PROMOCODE');
            listToInsert.add(quoteLineObject1);
            insert listToInsert;*/
            
            
            TriggerInterface_SBQQ_QuoteLine triggerInterface = new TriggerInterface_SBQQ_QuoteLine();
            TriggerInterface_SBQQ_QuoteLine.trig  triggerObj = new TriggerInterface_SBQQ_QuoteLine.trig();
            triggerObj.isAfter = true;
            triggerObj.isInsert = true;
            List<SBQQ__QuoteLine__c> quoteLineList = new List<SBQQ__QuoteLine__c>();
            quoteLineList.add(quoteLineObject1);
        
        triggerObj.newList = quoteLineList;
        
        syncQuoteOrderItem  controller = new syncQuoteOrderItem ();
        controller.run(triggerObj);

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