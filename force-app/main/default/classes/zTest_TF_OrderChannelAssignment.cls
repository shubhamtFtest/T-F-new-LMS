@isTest
public class zTest_TF_OrderChannelAssignment {
    @isTest
    private static  void createProductRecord(){
        Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        Account accObject = new Account(Name = 'Test Account',
                                        RecordTypeId = TFAccountsRecordTypeId,
                                        Type = 'Customer'); 
        insert accObject;
        
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
        Product2 prodObject = new Product2(Name = 'Test Product', 
                                           RecordTypeId = TFProductsRecordTypeId,
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           Readership_Level__c = 'Test');	
        insert prodObject;										   
        
        Prepay_Accounts__c prepayAccountObj = new Prepay_Accounts__c(Name = 'Test Prepay Account', AccountName__c = accObject.Id, Total_Budgeted_Amount__c=2000.00);
        insert prepayAccountObj; 
        
        Id automatedOppeBookDirectSalesOrdersRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F Automated eBooks Opportunity').getRecordTypeId();
        Opportunity AutomatedeBookOpp = new Opportunity(name='Test',AccountId  = accObject.Id, recordtypeid=automatedOppeBookDirectSalesOrdersRecordTypeId, StageName = 'Prospect', CloseDate = date.today(), Type = 'New Business', LeadSource ='Agent', Lead_Source_Detail__c ='N/A',CurrencyIsoCode ='GBP');
        INSERT AutomatedeBookOpp;
        
        Id automatedeBookDirectSalesOrdersRecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Automated eBook Direct Sales Orders').getRecordTypeId();
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Account__c = accObject.Id,SBQQ__Primary__c = True, Quote_Type__c = 'Agent eBook orders',SBQQ__Opportunity2__c = AutomatedeBookOpp.Id, RecordTypeId=automatedeBookDirectSalesOrdersRecordTypeId, Payer_Account__c = accObject.Id, SBQQ__ExpirationDate__c = date.today()+20, Use_Prepay_Budget__c = true);   
        insert quoteObject;
        
        SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id, SBQQ__Product__c = prodObject.Id, Discount_Rules_Applied__c = 'Prepay');
        insert quoteLineObject;
        system.debug('OrderInsertStart--->');
        TriggerInterfaceHelper.runTrigger('TF_OrderChannelAssignment', 'Order', 98, 'bi', null, null);
        test.startTest();
        Order automatedOrderTest = new Order(AccountId = accObject.Id,OpportunityId = AutomatedeBookOpp.Id,EffectiveDate =date.today(),CurrencyIsoCode ='GBP',Status ='DRAFT');
        insert automatedOrderTest;
        test.stopTest();
    }
    
     @isTest
    private static  void createProductRecordforDirectSalesQuote(){
        Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        Account accObject = new Account(Name = 'Test Account',
                                        RecordTypeId = TFAccountsRecordTypeId,
                                        Type = 'Customer'); 
        insert accObject;
        
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
        Product2 prodObject = new Product2(Name = 'Test Product', 
                                           RecordTypeId = TFProductsRecordTypeId,
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           Readership_Level__c = 'Test');	
        insert prodObject;										   
        
        Prepay_Accounts__c prepayAccountObj = new Prepay_Accounts__c(Name = 'Test Prepay Account', AccountName__c = accObject.Id, Total_Budgeted_Amount__c=2000.00);
        insert prepayAccountObj; 
        
        Id automatedOppeBookDirectSalesOrdersRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F Automated eBooks Opportunity').getRecordTypeId();
        Opportunity AutomatedeBookOpp = new Opportunity(name='Test',AccountId  = accObject.Id, recordtypeid=automatedOppeBookDirectSalesOrdersRecordTypeId, StageName = 'Prospect', CloseDate = date.today(), Type = 'New Business', LeadSource ='Agent', Lead_Source_Detail__c ='N/A',CurrencyIsoCode ='GBP');
        INSERT AutomatedeBookOpp;
        
        Id automatedeBookDirectSalesOrdersRecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Automated eBook Direct Sales Orders').getRecordTypeId();
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Account__c = accObject.Id,SBQQ__Primary__c = True, Quote_Type__c = 'Direct Sale',SBQQ__Opportunity2__c = AutomatedeBookOpp.Id, RecordTypeId=automatedeBookDirectSalesOrdersRecordTypeId, Payer_Account__c = accObject.Id, SBQQ__ExpirationDate__c = date.today()+20, Use_Prepay_Budget__c = true);   
        insert quoteObject;
        
        SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id, SBQQ__Product__c = prodObject.Id, Discount_Rules_Applied__c = 'Prepay');
        insert quoteLineObject;
        system.debug('OrderInsertStart--->');
        TriggerInterfaceHelper.runTrigger('TF_OrderChannelAssignment', 'Order', 98, 'bi', null, null);
        test.startTest();
        Order automatedOrderTest = new Order(AccountId = accObject.Id,OpportunityId = AutomatedeBookOpp.Id,EffectiveDate =date.today(),CurrencyIsoCode ='GBP',Status ='DRAFT');
        insert automatedOrderTest;
        test.stopTest();
    }
}