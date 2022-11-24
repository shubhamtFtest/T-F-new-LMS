@isTest
global with sharing class Ztest_TF_OrderHubWebServiceCallout implements HttpCalloutMock {
    
    private integer statusCode;
    private String responseJson;
    
    public Ztest_TF_OrderHubWebServiceCallout(integer statusCode, String responseJson){
        this.statusCode = statusCode;
        this.responseJson = responseJson;
    }     
    
    public HTTPResponse respond(HTTPRequest req) {
        // Create a mock response
        HttpResponse resp = new HttpResponse();
        resp.setHeader('Content-Type', 'application/json');
        resp.setBody(responseJson);      
        resp.setStatusCode(statusCode);
        return resp;
    } 

    private static Id createSampleDataForSelf() {
		customSetting();
        
        //Create Account
        Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        Account accObject = new Account(Name = 'Test Acc',RecordTypeId = TFAccountsRecordTypeId,Type = 'Customer');
        insert accObject;
        
        //Create contact 
        Contact c = new Contact(AccountId = accObject.Id, Lastname = 'Test contact');
        insert c;
        
        //Create Prepay Account
        Prepay_Accounts__c prepayAccountObj = new Prepay_Accounts__c(Name = 'Test Prepay Account', AccountName__c = accObject.Id);
        insert prepayAccountObj;
        
        //Create Product
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
        Product2 prodObject = new Product2(RecordTypeId = TFProductsRecordTypeId, 
                                           Name = 'Test Prod',
                                           Family = 'Journals-Author Side Charges',
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           Readership_Level__c = 'Test');
        insert prodObject; 
        
        //Create Quote
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c();
        quoteObject.SBQQ__Account__c = accObject.Id;
        quoteObject.Payer_Account__c = accObject.Id;
        quoteObject.Organization_Name__c = 'Test Organization Name';
        quoteObject.DOI__c = 'Test DOI';
        quoteObject.Payer__c = 'Self';
        quoteObject.SBQQ__ExpirationDate__c=date.today()+20; 
        quoteObject.Purchase_Order_Number__c = 'Test Order Number';
        quoteObject.Article_Title__c = 'Test article';
        quoteObject.Payer_Email__c = 'test@test.com';
        quoteObject.CurrencyIsoCode = 'GBP';
        quoteObject.VAT_Number__c = '00000000';
        quoteObject.Payer_Contact_Name__c = 'Test Payer';
        quoteObject.Payer_Email__c = 'test@test.com';
        quoteObject.Payer_Organization_Name__c = 'Test Organization Name';
        quoteObject.SBQQ__BillingCountry__c = 'Test Billing Country';
        quoteObject.SBQQ__BillingStreet__c = 'Test Billing Street';
        quoteObject.Bill_To_Street_2__c = 'Test Billing Street2';
        quoteObject.SBQQ__BillingCity__c = 'Test Billing City';
        quoteObject.SBQQ__BillingState__c = 'Test Billing State';
        quoteObject.Bill_To_State_ISO_Code__c = 'ISO';
        quoteObject.SBQQ__BillingPostalCode__c = '12345';
        quoteObject.Tax_Category__c = '12345';
        quoteObject.Tax_Registration_Number__c = '12345';
        
        quoteObject.Primary_Contact_Name__c = 'contact name';
        quoteObject.Ship_to_Organization__c = 'TEST APC PrePay 1';        
        quoteObject.SBQQ__ShippingStreet__c = 'address1';
        quoteObject.Ship_To_Street_2__c = 'address2';
        quoteObject.SBQQ__ShippingCity__c = 'city';
        quoteObject.SBQQ__ShippingState__c = 'state';
        quoteObject.Ship_To_State_ISO_Code__c = 'ISO';
        quoteObject.SBQQ__ShippingPostalCode__c = '12345';
        quoteObject.Primary_Contact_s_Phone_Number__c = '1234567890';  
        quoteobject.Business_Partner_Billing_Number__c ='123';
        insert quoteObject;
        
        //Create QuoteLine
        SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c();
        quoteLineObject.SBQQ__Quote__c = quoteObject.Id; 
        quoteLineObject.SBQQ__Product__c = prodObject.Id;
        quoteLineObject.CurrencyIsoCode = 'GBP';
        quoteLineObject.SBQQ__ProratedListPrice__c = 0;
        quoteLineObject.Best_Discount_Rule__c = 'Test Discount';
        quoteLineObject.SBQQ__ListPrice__c = 1000;
        quoteLineObject.SBQQ__Quantity__c = 5;
        
        insert quoteLineObject;
        
        quoteObject.Article_Acceptance_Status__c = 'Accepted';
        quoteObject.Author_Status__c = 'Accepted';
        quoteObject.CSD_Approval_Status__c = 'Approved';
        UPDATE quoteObject;        
        return quoteObject.Id; 
    }
    
    @isTest static void testSendOrderNotification_taxApi() { 
        string jsonStr ='{"metadata": {"code": 200,"timestamp": "2019.06.21.09.37.20.715","details": null},"data": {"productType": "ARTICLE","items": [{"offerCode": null,"quantity": 1,"priceCode": null,"productId": "GCTR","price": 2950,"tax": 0,"taxRates": []}]}}';       
        Id quoteID = createSampleDataForSelf();
        List<Id> quoteIds = new List<Id>{quoteID};
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Ztest_TF_OrderHubWebServiceCallout(200, jsonStr));
        TF_OrderHubWebServiceCallout.sendOrderNotification(quoteIds);       
        Test.stopTest();
    }

    @isTest static void testSendOrderNotification_taxApi400() { 
        string jsonStr ='{"metadata": {"code": 200,"timestamp": "2019.06.21.09.37.20.715","details": null},"data": {"productType": "ARTICLE","items": [{"offerCode": null,"quantity": 1,"priceCode": null,"productId": "GCTR","price": 2950,"tax": 0,"taxRates": []}]}}';       
        Id quoteID = createSampleDataForSelf();
        List<Id> quoteIds = new List<Id>{quoteID};
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Ztest_TF_OrderHubWebServiceCallout(400, jsonStr));
        TF_OrderHubWebServiceCallout.sendOrderNotification(quoteIds);       
        Test.stopTest();
    }
    
    @isTest static void testSendOrderNotification_taxApi_invalid() { 
        string jsonStr ='{"metadata": {"code": 200,"timestamp": "2019.06.21.09.37.20.715","details": null},"data": {"productType": "ARTICLE","items": [{"offerCode": null,"quantity": 1,"priceCode": null,"productId": "GCTR","price": 2950,"tax": 0,"taxRates": []}]}}';       
        Id quoteID = createSampleDataForSelf_invalid();
        List<Id> quoteIds = new List<Id>{quoteID};
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Ztest_TF_OrderHubWebServiceCallout(200, jsonStr));
        TF_OrderHubWebServiceCallout.sendOrderNotification(quoteIds);       
        Test.stopTest();
    }
    
    @isTest static void testSendOrderNotification_self() { 
        string jsonStr = '{"metadata": {"message": "Order Created Successfully!","code": 201},"data": {"orderNumber": "ODR975336","listOfOrderNumber": null}}';
        Id quoteID = createSampleDataForSelf();
        List<Id> quoteIds = new List<Id>{quoteID};
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Ztest_TF_OrderHubWebServiceCallout(200, jsonStr));
        TF_OrderHubWebServiceCallout.sendOrderNotification(quoteIds);       
        Test.stopTest();
    }
    
    @isTest static void testSendOrderNotification_OrderHub_invalid() { 
		string jsonStr = '';
        Id quoteID = createSampleDataForSelf();
        List<Id> quoteIds = new List<Id>{quoteID};
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Ztest_TF_OrderHubWebServiceCallout(200, jsonStr));
        TF_OrderHubWebServiceCallout.sendOrderNotification(quoteIds);       
        Test.stopTest();
    }
    
    @isTest static void testSendOrderNotification_organization() { 
        string jsonStr = '{"metadata": {"message": "Order Created Successfully!","code": 201},"data": {"orderNumber": "ODR975336","listOfOrderNumber": null}}';
        Id quoteID = createSampleDataForOrganization();
        List<Id> quoteIds = new List<Id>{quoteID};
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Ztest_TF_OrderHubWebServiceCallout(200, jsonStr));
        TF_OrderHubWebServiceCallout.sendOrderNotification(quoteIds);       
        Test.stopTest();
    }
    
    @isTest static void testSendOrderNotification_thirdparty() { 
        string jsonStr = '{"metadata": {"message": "Order Created Successfully!","code": 201},"data": {"orderNumber": "ODR975336","listOfOrderNumber": null}}';
        Id quoteID = createSampleDataForThirdParty();
        List<Id> quoteIds = new List<Id>{quoteID};
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Ztest_TF_OrderHubWebServiceCallout(200, jsonStr));
        TF_OrderHubWebServiceCallout.sendOrderNotification(quoteIds);       
        Test.stopTest();
    }
    
    @isTest static void testSendOrderNotification_thirdpartyorganization() { 
        string jsonStr = '{"metadata": {"message": "Order Created Successfully!","code": 201},"data": {"orderNumber": "ODR975336","listOfOrderNumber": null}}';
        Id quoteID = createSampleDataForThirdPartyOrganization();
        List<Id> quoteIds = new List<Id>{quoteID};
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Ztest_TF_OrderHubWebServiceCallout(200, jsonStr));
        TF_OrderHubWebServiceCallout.sendOrderNotification(quoteIds);       
        Test.stopTest();
    } 
    
        
    @isTest static void testOHPostCallout_invalid() { 
		string jsonStr = '{}';
        Id quoteID = createSampleData_invalid();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Ztest_TF_OrderHubWebServiceCallout(200, jsonStr));
        TF_OrderHubWebServiceCallout.OrderHubResultDetails response = TF_OrderHubWebServiceCallout.callOrderHubApi(quoteID,0,'Self','124');       
        Test.stopTest();
    }

    @isTest static void testOHPostCallout_invalid2() { 
		string jsonStr = '{}';
        Id quoteID = createSampleData_invalid();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Ztest_TF_OrderHubWebServiceCallout(200, jsonStr));
        TF_OrderHubWebServiceCallout.OrderHubResultDetails response = TF_OrderHubWebServiceCallout.callOrderHubApi(quoteID,0,'Organization','123');       
        Test.stopTest();
    }
    
    @isTest static void testSendOrderNotification_prepayQuote() { 
        string jsonStr = '{"metadata": {"message": "Order Created Successfully!","code": 201},"data": {"orderNumber": "ODR975336","listOfOrderNumber": null}}';
        Id quoteID = createSampleDataForPrepayQuote();
        List<Id> quoteIds = new List<Id>{quoteID};
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Ztest_TF_OrderHubWebServiceCallout(200, jsonStr));
        TF_OrderHubWebServiceCallout.sendOrderNotification(quoteIds);       
        Test.stopTest();
    }

    private static Id createSampleDataForSelf_invalid() {
		customSetting(); 
        
        //Create Account
        Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        Account accObject = new Account(Name = 'Test Acc',RecordTypeId = TFAccountsRecordTypeId,Type = 'Customer');
        insert accObject;
        
        //Create contact 
        Contact c = new Contact(AccountId = accObject.Id, Lastname = 'Test contact');
        insert c;
        
        //Create Prepay Account
        Prepay_Accounts__c prepayAccountObj = new Prepay_Accounts__c(Name = 'Test Prepay Account', AccountName__c = accObject.Id);
        insert prepayAccountObj;
        
        //Create Product
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
        Product2 prodObject = new Product2(RecordTypeId = TFProductsRecordTypeId, 
                                           Name = 'Test Prod',
                                           Family = 'Journals-Author Side Charges',
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           Readership_Level__c = 'Test');
        insert prodObject; 
        
        //Create Quote
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c();
        quoteObject.SBQQ__Account__c = accObject.Id;
        quoteObject.Payer_Account__c = accObject.Id;
        quoteObject.DOI__c = 'Test DOI';
        quoteObject.Payer__c = 'Self';
        quoteObject.SBQQ__ExpirationDate__c=date.today()+20; 
        quoteObject.Purchase_Order_Number__c = 'Test Order Number';
        quoteObject.Article_Title__c = 'Test article';
        quoteObject.Payer_Email__c = 'test@test.com';
        quoteObject.CurrencyIsoCode = 'GBP';
        quoteObject.VAT_Number__c = '00000000';
        quoteObject.Payer_Contact_Name__c = 'Test Payer';
        quoteObject.Payer_Email__c = 'test@test.com';
        quoteObject.Payer_Organization_Name__c = 'Test Organization Name';
        quoteObject.SBQQ__BillingCountry__c = 'Test Billing Country';
        //quoteObject.SBQQ__BillingStreet__c = 'Test Billing Street';
        quoteObject.Bill_To_Street_2__c = 'Test Billing Street2';
        quoteObject.SBQQ__BillingCity__c = 'Test Billing City';
        quoteObject.SBQQ__BillingState__c = 'Test Billing State';
        quoteObject.SBQQ__BillingPostalCode__c = '12345';
        quoteObject.Tax_Category__c = '12345';
        quoteObject.Tax_Registration_Number__c = '12345';
        
        quoteObject.Primary_Contact_Name__c = 'contact name';
        quoteObject.Ship_to_Organization__c = 'TEST APC PrePay 1';        
        //quoteObject.SBQQ__ShippingStreet__c = 'address1';
        quoteObject.Ship_To_Street_2__c = 'address2';
        quoteObject.SBQQ__ShippingCity__c = 'city';
        quoteObject.SBQQ__ShippingState__c = 'state';
        quoteObject.SBQQ__ShippingPostalCode__c = '12345';
        quoteObject.Primary_Contact_s_Phone_Number__c = '1234567890';        
        insert quoteObject;
        
        //Create QuoteLine
        SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c();
        quoteLineObject.SBQQ__Quote__c = quoteObject.Id; 
        quoteLineObject.SBQQ__Product__c = prodObject.Id;
        quoteLineObject.CurrencyIsoCode = 'GBP';
        quoteLineObject.SBQQ__ProratedListPrice__c = 0;
        quoteLineObject.Best_Discount_Rule__c = 'Test Discount';
        quoteLineObject.SBQQ__ListPrice__c = 1000;
        quoteLineObject.SBQQ__Quantity__c = 5;
        
        insert quoteLineObject;
        
        quoteObject.Article_Acceptance_Status__c = 'Accepted';
        quoteObject.Author_Status__c = 'Accepted';
        quoteObject.CSD_Approval_Status__c = 'Approved';
        UPDATE quoteObject;        
        return quoteObject.Id; 
    }


    private static Id createSampleDataForPrepayQuote() {
		customSetting(); 
        
        //Create Account
        Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        Account accObject = new Account(Name = 'Test Acc',RecordTypeId = TFAccountsRecordTypeId,Type = 'Customer');
        insert accObject;
        
        //Create contact 
        Contact c = new Contact(AccountId = accObject.Id, Lastname = 'Test contact');
        insert c;
        
        //Create Prepay Account
        Prepay_Accounts__c prepayAccountObj = new Prepay_Accounts__c(Name = 'Test Prepay Account', AccountName__c = accObject.Id);
        insert prepayAccountObj;
        
        //Create Product
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
        Product2 prodObject = new Product2(RecordTypeId = TFProductsRecordTypeId, 
                                           Name = 'Test Prod',
                                           Family = 'Journals-Author Side Charges',
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           Readership_Level__c = 'Test');
        insert prodObject; 
        
        //Create Quote
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c();
        quoteObject.SBQQ__Account__c = accObject.Id;
        quoteObject.Payer_Account__c = accObject.Id;
        quoteObject.Use_Prepay_Budget__c = true;
        quoteObject.Organization_Name__c = 'Test Organization Name';
        quoteObject.DOI__c = 'Test DOI';
        quoteObject.Payer__c = 'Organization';
        quoteObject.SBQQ__ExpirationDate__c=date.today()+20; 
        quoteObject.Purchase_Order_Number__c = 'Test Order Number';
        quoteObject.Article_Title__c = 'Test article';
        quoteObject.Payer_Email__c = 'test@test.com';
        quoteObject.CurrencyIsoCode = 'GBP';
        quoteObject.VAT_Number__c = '00000000';
        quoteObject.Payer_Contact_Name__c = 'Test Payer';
        quoteObject.Payer_Email__c = 'test@test.com';
        quoteObject.Payer_Organization_Name__c = 'Test Organization Name';
        quoteObject.SBQQ__BillingCountry__c = 'Test Billing Country';
        quoteObject.SBQQ__BillingStreet__c = 'Test Billing Street';
        quoteObject.Bill_To_Street_2__c = 'Test Billing Street2';
        quoteObject.SBQQ__BillingCity__c = 'Test Billing City';
        quoteObject.SBQQ__BillingState__c = 'Test Billing State';
        quoteObject.SBQQ__BillingPostalCode__c = '12345';
        
        quoteObject.Primary_Contact_Name__c = 'contact name';
        quoteObject.Ship_to_Organization__c = 'TEST APC PrePay 1';        
        quoteObject.SBQQ__ShippingStreet__c = 'address1';
        quoteObject.Ship_To_Street_2__c = 'address2';
        quoteObject.SBQQ__ShippingCity__c = 'city';
        quoteObject.SBQQ__ShippingState__c = 'state';
        quoteObject.SBQQ__ShippingPostalCode__c = '12345';
        quoteObject.Primary_Contact_s_Phone_Number__c = '1234567890';        
        insert quoteObject;
        
        //Create QuoteLine
        SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c();
        quoteLineObject.SBQQ__Quote__c = quoteObject.Id; 
        quoteLineObject.SBQQ__Product__c = prodObject.Id;
        quoteLineObject.CurrencyIsoCode = 'GBP';
        quoteLineObject.SBQQ__ProratedListPrice__c = 0;
        quoteLineObject.Best_Discount_Rule__c = 'Test Discount';
        quoteLineObject.SBQQ__ListPrice__c = 1000;
        quoteLineObject.SBQQ__Quantity__c = 5;
        
        insert quoteLineObject;
        
        quoteObject.Article_Acceptance_Status__c = 'Accepted';
        quoteObject.Author_Status__c = 'Accepted';
        quoteObject.CSD_Approval_Status__c = 'Approved';
        quoteObject.CanInvoice__c = true;
        UPDATE quoteObject;        
        return quoteObject.Id; 
    }
    
    private static Id createSampleDataForOrganization() {
		customSetting();
        
        //Create Account
        Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        Account accObject = new Account(Name = 'Test Acc',RecordTypeId = TFAccountsRecordTypeId,Type = 'Customer');
        insert accObject;
        
        //Create contact 
        Contact c = new Contact(AccountId = accObject.Id, Lastname = 'Test contact');
        insert c;
        
        //Create Prepay Account
        Prepay_Accounts__c prepayAccountObj = new Prepay_Accounts__c(Name = 'Test Prepay Account', AccountName__c = accObject.Id);
        insert prepayAccountObj;
        
        //Create Product
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
        Product2 prodObject = new Product2(RecordTypeId = TFProductsRecordTypeId, 
                                           Name = 'Test Prod',
                                           Family = 'Journals-Author Side Charges',
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           Readership_Level__c = 'Test');
        insert prodObject; 
        
        //Create Quote
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c();
        quoteObject.SBQQ__Account__c = accObject.Id;
        quoteObject.Payer_Account__c = accObject.Id;
        quoteObject.DOI__c = 'Test DOI';
        quoteObject.Organization_Name__c = 'Test Organization Name';
        quoteObject.Payer__c = 'Organization';
        quoteObject.SBQQ__ExpirationDate__c=date.today()+20; 
        quoteObject.Purchase_Order_Number__c = 'Test Order Number';
        quoteObject.Article_Title__c = 'Test article';
        quoteObject.Payer_Email__c = 'test@test.com';
        quoteObject.CurrencyIsoCode = 'GBP';
        quoteObject.VAT_Number__c = '00000000';
        quoteObject.Payer_Contact_Name__c = 'Test Payer';
        quoteObject.Payer_Email__c = 'test@test.com';
        quoteObject.Payer_Organization_Name__c = 'Test Organization Name';
        quoteObject.SBQQ__BillingCountry__c = 'Test Billing Country';
        quoteObject.SBQQ__BillingStreet__c = 'Test Billing Street';
        quoteObject.Bill_To_Street_2__c = 'Test Billing Street2';
        quoteObject.SBQQ__BillingCity__c = 'Test Billing City';
        quoteObject.SBQQ__BillingState__c = 'Test Billing State';
        quoteObject.SBQQ__BillingPostalCode__c = '12345';
        
        quoteObject.Primary_Contact_Name__c = 'contact name';
        quoteObject.Ship_to_Organization__c = 'TEST APC PrePay 1';        
        quoteObject.SBQQ__ShippingStreet__c = 'address1';
        quoteObject.Ship_To_Street_2__c = 'address2';
        quoteObject.SBQQ__ShippingCity__c = 'city';
        quoteObject.SBQQ__ShippingState__c = 'state';
        quoteObject.SBQQ__ShippingPostalCode__c = '12345';
        quoteObject.Primary_Contact_s_Phone_Number__c = '1234567890';        
        insert quoteObject;
        
        //Create QuoteLine
        SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c();
        quoteLineObject.SBQQ__Quote__c = quoteObject.Id; 
        quoteLineObject.SBQQ__Product__c = prodObject.Id;
        quoteLineObject.CurrencyIsoCode = 'GBP';
        quoteLineObject.SBQQ__ProratedListPrice__c = 0;
        quoteLineObject.Best_Discount_Rule__c = 'Test Discount';
        quoteLineObject.SBQQ__ListPrice__c = 1000;
        quoteLineObject.SBQQ__Quantity__c = 5;
        
        insert quoteLineObject;
        
        quoteObject.Article_Acceptance_Status__c = 'Accepted';
        quoteObject.Author_Status__c = 'Accepted';
        quoteObject.CSD_Approval_Status__c = 'Approved';
        quoteObject.CanInvoice__c = true;
        UPDATE quoteObject;        
        return quoteObject.Id; 
    }
    
    private static Id createSampleDataForThirdParty() {
		customSetting();
        
        //Create Account
        Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        Account accObject = new Account(Name = 'Test Acc',RecordTypeId = TFAccountsRecordTypeId,Type = 'Customer');
        insert accObject;
        
        //Create contact 
        Contact c = new Contact(AccountId = accObject.Id, Lastname = 'Test contact');
        insert c;
        
        //Create Prepay Account
        Prepay_Accounts__c prepayAccountObj = new Prepay_Accounts__c(Name = 'Test Prepay Account', AccountName__c = accObject.Id);
        insert prepayAccountObj;
        
        //Create Product
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
        Product2 prodObject = new Product2(RecordTypeId = TFProductsRecordTypeId, 
                                           Name = 'Test Prod',
                                           Family = 'Journals-Author Side Charges',
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           Readership_Level__c = 'Test');
        insert prodObject; 
        
        //Create Quote
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c();
        quoteObject.SBQQ__Account__c = accObject.Id;
        quoteObject.Payer_Account__c = accObject.Id;
        quoteObject.DOI__c = 'Test DOI';
        quoteObject.Organization_Name__c = 'Test Organization Name';
        quoteObject.Payer__c = 'Third Party';
        quoteObject.SBQQ__ExpirationDate__c=date.today()+20; 
        quoteObject.Purchase_Order_Number__c = 'Test Order Number';
        quoteObject.Article_Title__c = 'Test article';
        quoteObject.Payer_Email__c = 'test@test.com';
        quoteObject.CurrencyIsoCode = 'GBP';
        quoteObject.VAT_Number__c = '00000000';
        quoteObject.Payer_Contact_Name__c = 'Test Payer';
        quoteObject.Payer_Email__c = 'test@test.com';
        quoteObject.Payer_Organization_Name__c = 'Test Organization Name';
        quoteObject.SBQQ__BillingCountry__c = 'Test Billing Country';
        quoteObject.SBQQ__BillingStreet__c = 'Test Billing Street';
        quoteObject.Bill_To_Street_2__c = 'Test Billing Street2';
        quoteObject.SBQQ__BillingCity__c = 'Test Billing City';
        quoteObject.SBQQ__BillingState__c = 'Test Billing State';
        quoteObject.SBQQ__BillingPostalCode__c = '12345';
        
        quoteObject.Primary_Contact_Name__c = 'contact name';
        quoteObject.Ship_to_Organization__c = 'TEST APC PrePay 1';        
        quoteObject.SBQQ__ShippingStreet__c = 'address1';
        quoteObject.Ship_To_Street_2__c = 'address2';
        quoteObject.SBQQ__ShippingCity__c = 'city';
        quoteObject.SBQQ__ShippingState__c = 'state';
        quoteObject.SBQQ__ShippingPostalCode__c = '12345';
        quoteObject.Primary_Contact_s_Phone_Number__c = '1234567890';        
        insert quoteObject;
        
        //Create QuoteLine
        SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c();
        quoteLineObject.SBQQ__Quote__c = quoteObject.Id; 
        quoteLineObject.SBQQ__Product__c = prodObject.Id;
        quoteLineObject.CurrencyIsoCode = 'GBP';
        quoteLineObject.SBQQ__ProratedListPrice__c = 0;
        quoteLineObject.Best_Discount_Rule__c = 'Test Discount';
        quoteLineObject.SBQQ__ListPrice__c = 1000;
        quoteLineObject.SBQQ__Quantity__c = 5;
        
        insert quoteLineObject;
        
        quoteObject.Article_Acceptance_Status__c = 'Accepted';
        quoteObject.Author_Status__c = 'Accepted';
        quoteObject.CSD_Approval_Status__c = 'Approved';
        quoteObject.CanInvoice__c = true;
        UPDATE quoteObject;        
        return quoteObject.Id; 
    }
    
    private static Id createSampleDataForThirdPartyOrganization() {
		customSetting();         
        //Create Account
        Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        Account accObject = new Account(Name = 'Test Acc',RecordTypeId = TFAccountsRecordTypeId,Type = 'Customer');
        insert accObject;
        
        //Create contact 
        Contact c = new Contact(AccountId = accObject.Id, Lastname = 'Test contact');
        insert c;
        
        //Create Prepay Account
        Prepay_Accounts__c prepayAccountObj = new Prepay_Accounts__c(Name = 'Test Prepay Account', AccountName__c = accObject.Id);
        insert prepayAccountObj;
        
        //Create Product
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
        Product2 prodObject = new Product2(RecordTypeId = TFProductsRecordTypeId, 
                                           Name = 'Test Prod',
                                           Family = 'Journals-Author Side Charges',
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           Readership_Level__c = 'Test');
        insert prodObject; 
        
        //Create Quote
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c();
        quoteObject.SBQQ__Account__c = accObject.Id;
        quoteObject.Payer_Account__c = accObject.Id;
        quoteObject.DOI__c = 'Test DOI';
        quoteObject.Organization_Name__c = 'Test Organization Name';
        quoteObject.Payer__c = 'Third party Organization';
        quoteObject.SBQQ__ExpirationDate__c=date.today()+20; 
        quoteObject.Purchase_Order_Number__c = 'Test Order Number';
        quoteObject.Article_Title__c = 'Test article';
        quoteObject.Payer_Email__c = 'test@test.com';
        quoteObject.CurrencyIsoCode = 'GBP';
        quoteObject.VAT_Number__c = '00000000';
        quoteObject.Payer_Contact_Name__c = 'Test Payer';
        quoteObject.Payer_Email__c = 'test@test.com';
        quoteObject.Payer_Organization_Name__c = 'Test Organization Name';
        quoteObject.SBQQ__BillingCountry__c = 'Test Billing Country';
        quoteObject.SBQQ__BillingStreet__c = 'Test Billing Street';
        quoteObject.Bill_To_Street_2__c = 'Test Billing Street2';
        quoteObject.SBQQ__BillingCity__c = 'Test Billing City';
        quoteObject.SBQQ__BillingState__c = 'Test Billing State';
        quoteObject.SBQQ__BillingPostalCode__c = '12345';
        
        quoteObject.Primary_Contact_Name__c = 'contact name';
        quoteObject.Ship_to_Organization__c = 'TEST APC PrePay 1';        
        quoteObject.SBQQ__ShippingStreet__c = 'address1';
        quoteObject.Ship_To_Street_2__c = 'address2';
        quoteObject.SBQQ__ShippingCity__c = 'city';
        quoteObject.SBQQ__ShippingState__c = 'state';
        quoteObject.SBQQ__ShippingPostalCode__c = '12345';
        quoteObject.Primary_Contact_s_Phone_Number__c = '1234567890';
        insert quoteObject;
        
        //Create QuoteLine
        SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c();
        quoteLineObject.SBQQ__Quote__c = quoteObject.Id; 
        quoteLineObject.SBQQ__Product__c = prodObject.Id;
        quoteLineObject.CurrencyIsoCode = 'GBP';
        quoteLineObject.SBQQ__ProratedListPrice__c = 0;
        quoteLineObject.Best_Discount_Rule__c = 'Test Discount';
        quoteLineObject.SBQQ__ListPrice__c = 1000;
        quoteLineObject.SBQQ__Quantity__c = 5;
        
        insert quoteLineObject;
        
        quoteObject.Article_Acceptance_Status__c = 'Accepted';
        quoteObject.Author_Status__c = 'Accepted';
        quoteObject.CSD_Approval_Status__c = 'Approved';
        quoteObject.CanInvoice__c = true;
        UPDATE quoteObject;        
        return quoteObject.Id; 
    }    
    
    private static Id createSampleData() {
		customSetting(); 
        
        //Create Account
        Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        Account accObject = new Account(Name = 'Test Acc',RecordTypeId = TFAccountsRecordTypeId,Type = 'Customer');
        insert accObject;
        
        //Create contact 
        Contact c = new Contact(AccountId = accObject.Id, Lastname = 'Test contact');
        insert c;
        
        //Create Prepay Account
        Prepay_Accounts__c prepayAccountObj = new Prepay_Accounts__c(Name = 'Test Prepay Account', AccountName__c = accObject.Id);
        insert prepayAccountObj;
        
        //Create Product
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
        Product2 prodObject = new Product2(RecordTypeId = TFProductsRecordTypeId, 
                                           Name = 'Test Prod',
                                           Family = 'Journals-Author Side Charges',
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           Readership_Level__c = 'Test');
        insert prodObject; 
        
        //Create Quote
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c();
        quoteObject.SBQQ__Account__c = accObject.Id;
        quoteObject.Payer_Account__c = accObject.Id;
        quoteObject.DOI__c = 'Test DOI';
        quoteObject.Organization_Name__c = 'Test Organization Name';
        quoteObject.Payer__c = 'Self';
        quoteObject.SBQQ__ExpirationDate__c=date.today()+20; 
        quoteObject.Purchase_Order_Number__c = 'Test Order Number';
        quoteObject.Article_Title__c = 'Test article';
        quoteObject.Payer_Email__c = 'test@test.com';
        quoteObject.CurrencyIsoCode = 'GBP';
        quoteObject.VAT_Number__c = '00000000';
        quoteObject.Payer_Contact_Name__c = 'Test Payer';
        quoteObject.Payer_Organization_Name__c = 'Test Organization Name';
        quoteObject.Tax_Category__c = '12345';
        quoteObject.Tax_Registration_Number__c = '12345';
        
        quoteObject.Primary_Contact_Name__c = 'amit kumar';
        quoteObject.Primary_Contact_s_Phone_Number__c = '12345';
        quoteObject.Primary_Contact_s_email_id__c = 'amit.kumar@tandfindia.com';
        
        quoteObject.SBQQ__BillingStreet__c = 'address1';
        quoteObject.Bill_To_Street_2__c = 'address2';
        quoteObject.SBQQ__BillingCity__c = 'city';
        quoteObject.SBQQ__BillingState__c = 'state';
        quoteObject.SBQQ__BillingPostalCode__c = '12345';
        quoteObject.SBQQ__BillingCountry__c = 'India';
        
        quoteObject.Ship_to_Organization__c = '12345';
        quoteObject.Payer_Department__c = '12345';
        quoteObject.SBQQ__ShippingStreet__c = 'address1';
        quoteObject.Ship_To_Street_2__c = 'address2';
        quoteObject.SBQQ__ShippingCity__c = 'city';
        quoteObject.SBQQ__ShippingState__c = 'state';
        quoteObject.SBQQ__ShippingPostalCode__c = '12345';
        quoteObject.SBQQ__ShippingCountry__c = 'India';        
        insert quoteObject;
        
        //Create QuoteLine
        SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c();
        quoteLineObject.SBQQ__Quote__c = quoteObject.Id; 
        quoteLineObject.SBQQ__Product__c = prodObject.Id;
        quoteLineObject.CurrencyIsoCode = 'GBP';
        quoteLineObject.SBQQ__ProratedListPrice__c = 0;
        quoteLineObject.Best_Discount_Rule__c = 'Test Discount';
        quoteLineObject.SBQQ__ListPrice__c = 1000;
        quoteLineObject.SBQQ__Quantity__c = 5;
        insert quoteLineObject;
        
        quoteObject.Article_Acceptance_Status__c = 'Accepted';
        quoteObject.Author_Status__c = 'Accepted';
        quoteObject.CSD_Approval_Status__c = 'Approved';
        UPDATE quoteObject;        
        return quoteObject.Id; 
    }
    
    private static Id createSampleData_invalid() {
		customSetting(); 
        
        //Create Account
        Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        Account accObject = new Account(Name = 'Test Acc',RecordTypeId = TFAccountsRecordTypeId,Type = 'Customer');
        insert accObject;
        
        //Create contact 
        Contact c = new Contact(AccountId = accObject.Id, Lastname = 'Test contact');
        insert c;
        
        //Create Prepay Account
        Prepay_Accounts__c prepayAccountObj = new Prepay_Accounts__c(Name = 'Test Prepay Account', AccountName__c = accObject.Id);
        insert prepayAccountObj;
        
        //Create Product
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
        Product2 prodObject = new Product2(RecordTypeId = TFProductsRecordTypeId, 
                                           Name = 'Test Prod',
                                           Family = 'Journals-Author Side Charges',
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           Readership_Level__c = 'Test');
        insert prodObject; 
        
        //Create Quote
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c();
        quoteObject.SBQQ__Account__c = accObject.Id;
        quoteObject.Payer_Account__c = accObject.Id;
        quoteObject.DOI__c = 'Test DOI';
        quoteObject.Organization_Name__c = 'Test Organization Name';
        quoteObject.Payer__c = 'Self';
        quoteObject.SBQQ__ExpirationDate__c=date.today()+20; 
        quoteObject.Purchase_Order_Number__c = 'Test Order Number';
        quoteObject.Article_Title__c = 'Test article';
        quoteObject.Payer_Email__c = 'test@test.com';
        quoteObject.CurrencyIsoCode = 'GBP';
        quoteObject.VAT_Number__c = '00000000';
        quoteObject.Payer_Contact_Name__c = 'Test Payer';
        quoteObject.Payer_Organization_Name__c = 'Test Organization Name';
        quoteObject.Tax_Category__c = '12345';
        quoteObject.Tax_Registration_Number__c = '12345';
        
        quoteObject.Primary_Contact_Name__c = 'amit kumar';
        quoteObject.Primary_Contact_s_Phone_Number__c = '12345';
        quoteObject.Primary_Contact_s_email_id__c = 'amit.kumar@tandfindia.com';
        
        quoteObject.SBQQ__BillingStreet__c = 'address1';
        quoteObject.Bill_To_Street_2__c = 'address2';
        quoteObject.SBQQ__BillingCity__c = 'city';
        quoteObject.SBQQ__BillingState__c = 'state';
        quoteObject.SBQQ__BillingPostalCode__c = '12345';
        quoteObject.SBQQ__BillingCountry__c = 'India';
        
        quoteObject.Ship_to_Organization__c = '12345';
        quoteObject.Payer_Department__c = '12345';
        quoteObject.SBQQ__ShippingStreet__c = 'address1';
        quoteObject.Ship_To_Street_2__c = 'address2';
        quoteObject.SBQQ__ShippingCity__c = 'city';
        quoteObject.SBQQ__ShippingState__c = 'state';
        quoteObject.SBQQ__ShippingPostalCode__c = '12345';
        quoteObject.SBQQ__ShippingCountry__c = 'India';        
        insert quoteObject;
        
        //Create QuoteLine
        SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c();
        quoteLineObject.SBQQ__Quote__c = quoteObject.Id; 
        quoteLineObject.SBQQ__Product__c = prodObject.Id;
        quoteLineObject.CurrencyIsoCode = 'GBP';
        quoteLineObject.SBQQ__ProratedListPrice__c = 0;
        quoteLineObject.Best_Discount_Rule__c = 'Test Discount';
        quoteLineObject.SBQQ__ListPrice__c = 1000;
        quoteLineObject.SBQQ__Quantity__c = 5;
        insert quoteLineObject;
        
        quoteObject.Article_Acceptance_Status__c = 'Accepted';
        quoteObject.Author_Status__c = 'Accepted';
        quoteObject.CSD_Approval_Status__c = 'Approved';
        UPDATE quoteObject;        
        return quoteObject.Id; 
    }
    
    private static void customSetting() {
        TF_OrgSpecificProps__c setting = new TF_OrgSpecificProps__c();
        setting.OrderHubApi_URL__c = 'https://api-dev.taylorandfrancis.com/v1/orders/bp';
		setting.OrderHubCalcTaxApi_URL__c = 'https://secure-dev.taylorfrancis.com/calctax';
        setting.EmailAddressForOrderHubAlarmNotification__c = 'Amit.Kumar@tandfindia.com';
        setting.EmailAddressFoTaxrAlarmNotification__c='Amanica.nagunuri@informa.com';
        setting.Order_Hub_Mandatory_Countries__c = 'US,CA,BR';
        insert setting;     
    }    
}