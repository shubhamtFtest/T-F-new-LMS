@isTest
global with sharing class Ztest_OA_OrderWebServiceCalloutRetry implements HttpCalloutMock { 
    
    private integer statusCode;
    private String responseJson;
    
    public Ztest_OA_OrderWebServiceCalloutRetry(integer statusCode, String responseJson){
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
                                           Readership_Level__c = 'Test',
                                          IsActive = True);
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
        //quoteobject.Journal_Code__c = 'OABI';
        quoteObject.Business_Partner_Billing_Number__c = '0003728934';
        quoteObject.Customer_Bill_Address_ID__c = '1591788299963UJP';
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
        quoteLineObject.SBQQ__Optional__c = false;
        
        insert quoteLineObject;
        
        quoteObject.Article_Acceptance_Status__c = 'Accepted';
        quoteObject.Author_Status__c = 'Accepted';
        quoteObject.CSD_Approval_Status__c = 'Approved';
        UPDATE quoteObject;        
        return quoteObject.Id; 
    }
    
    @isTest static void testSendOrderNotification_taxApi() { 
        string jsonStr = '{{"salesOrg" : "IN01","productType" : "TF-ARTICLE","metaData" : {"currency" : "USD","customer" : {"customerEmail" : "test@gmail.com"},"addressGroup" : {"shipTo" : {"personName" : {"lastName" : " test","firstNames" : "test"},"address" : {"state" : null,"postalCode" : "798798789","phoneNumber" : "87879798","phoneExtension" : "","Organisation" : "Test_Const_Camp01","faxNumber" : "","department" : null,"country" : "BD","city" : "my City","bpNumber" : null,"addressLine2" : null,"addressLine1" : "Street 1"}},"billTo" : {"personName" : {"lastName" : " test","firstNames" : "test"},"address" : {"state" : null,"postalCode" : "798798789","phoneNumber" : "87879798","phoneExtension" : "","Organisation" : null,"faxNumber" : "","department" : "","country" : "BD","city" : "my City","bpNumber" : "0003728934","addressLine2" : null,"addressLine1" : "Street 1"}}}},"items" : [ {"quantity" : 1,"productId" : "OABI","price" : 225.00,"discount" : 0.000}, {"quantity" : 1,"productId" : "OABI","price" : 2950.00,"discount" : 0.000}]}';
        Id quoteID = createSampleDataForSelf();
        List<Id> quoteIds = new List<Id>{quoteID};
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Ztest_TF_OrderHubWebServiceCallout(200, jsonStr));
        OA_OrderWebServiceCalloutRetryController.quoteOrderCalloutRetry(quoteID);
        OA_OrderWebServiceCalloutRetryController.fetchQuote(quoteID);
        //TF_OrderHubWebServiceCallout.sendOrderNotification(quoteIds);       
        Test.stopTest();
    }
    
    @isTest static void testSendOrderNotification_taxApi2() { 
        string jsonStr = '{{"salesOrg" : "IN01","productType" : "TF-ARTICLE","metaData" : {"currency" : "USD","customer" : {"customerEmail" : "test@gmail.com"},"addressGroup" : {"shipTo" : {"personName" : {"lastName" : " test","firstNames" : "test"},"address" : {"state" : null,"postalCode" : "798798789","phoneNumber" : "87879798","phoneExtension" : "","Organisation" : "Test_Const_Camp01","faxNumber" : "","department" : null,"country" : "BD","city" : "my City","bpNumber" : null,"addressLine2" : null,"addressLine1" : "Street 1"}},"billTo" : {"personName" : {"lastName" : " test","firstNames" : "test"},"address" : {"state" : null,"postalCode" : "798798789","phoneNumber" : "87879798","phoneExtension" : "","Organisation" : null,"faxNumber" : "","department" : "","country" : "BD","city" : "my City","bpNumber" : "0003728934","addressLine2" : null,"addressLine1" : "Street 1"}}}},"items" : [ {"quantity" : 1,"productId" : "OABI","price" : 225.00,"discount" : 0.000}, {"quantity" : 1,"productId" : "OABI","price" : 2950.00,"discount" : 0.000}]}';
        Id quoteID = createSampleDataForSelf();
        List<Id> quoteIds = new List<Id>{quoteID};
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Ztest_TF_OrderHubWebServiceCallout(200, jsonStr));
        OA_OrderWebServiceCalloutRetryController.quoteOrderCalloutRetry(quoteID);
        //TF_OrderHubWebServiceCallout.sendOrderNotification(quoteIds);       
        Test.stopTest();
    }

    @isTest static void testSendOrderNotification_taxApi400() { 
        string jsonStr = '{{"salesOrg" : "IN01","productType" : "TF-ARTICLE","metaData" : {"currency" : "USD","customer" : {"customerEmail" : "test@gmail.com"},"addressGroup" : {"shipTo" : {"personName" : {"lastName" : " test","firstNames" : "test"},"address" : {"state" : null,"postalCode" : "798798789","phoneNumber" : "87879798","phoneExtension" : "","Organisation" : "Test_Const_Camp01","faxNumber" : "","department" : null,"country" : "BD","city" : "my City","bpNumber" : null,"addressLine2" : null,"addressLine1" : "Street 1"}},"billTo" : {"personName" : {"lastName" : " test","firstNames" : "test"},"address" : {"state" : null,"postalCode" : "798798789","phoneNumber" : "87879798","phoneExtension" : "","Organisation" : null,"faxNumber" : "","department" : "","country" : "BD","city" : "my City","bpNumber" : "0003728934","addressLine2" : null,"addressLine1" : "Street 1"}}}},"items" : [ {"quantity" : 1,"productId" : "OABI","price" : 225.00,"discount" : 0.000}, {"quantity" : 1,"productId" : "OABI","price" : 2950.00,"discount" : 0.000}]}';

        Id quoteID = createSampleDataForSelf();
        List<Id> quoteIds = new List<Id>{quoteID};
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Ztest_TF_OrderHubWebServiceCallout(400, jsonStr));
        OA_OrderWebServiceCalloutRetryController.quoteOrderCalloutRetry(quoteID);
        //TF_OrderHubWebServiceCallout.sendOrderNotification(quoteIds);
        TF_OrderHubWebServiceCallout.alarmNotificationOrderCreationFailure(quoteID);
        TF_OrderHubWebServiceCallout.updateOrderHubID(quoteID, '1234567');
        TF_OrderHubWebServiceCallout.updateTaxAmount(quoteID, 36);
        TF_OrderHubWebServiceCallout.getFirstName('test_Siddhant');
        TF_OrderHubWebServiceCallout.getLastName('Tyagi');
        Test.stopTest();
    }
    
    @isTest static void testSendOrderNotification_taxApi_invalid() { 
        string jsonStr = '{{"salesOrg" : "IN01","productType" : "TF-ARTICLE","metaData" : {"currency" : "USD","customer" : {"customerEmail" : "test@gmail.com"},"addressGroup" : {"shipTo" : {"personName" : {"lastName" : " test","firstNames" : "test"},"address" : {"state" : null,"postalCode" : "798798789","phoneNumber" : "87879798","phoneExtension" : "","Organisation" : "Test_Const_Camp01","faxNumber" : "","department" : null,"country" : "BD","city" : "my City","bpNumber" : null,"addressLine2" : null,"addressLine1" : "Street 1"}},"billTo" : {"personName" : {"lastName" : " test","firstNames" : "test"},"address" : {"state" : null,"postalCode" : "798798789","phoneNumber" : "87879798","phoneExtension" : "","Organisation" : null,"faxNumber" : "","department" : "","country" : "BD","city" : "my City","bpNumber" : "0003728934","addressLine2" : null,"addressLine1" : "Street 1"}}}},"items" : [ {"quantity" : 1,"productId" : "OABI","price" : 225.00,"discount" : 0.000}, {"quantity" : 1,"productId" : "OABI","price" : 2950.00,"discount" : 0.000}]}';
        Id quoteID = createSampleDataForSelf();
        List<Id> quoteIds = new List<Id>{quoteID};
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Ztest_TF_OrderHubWebServiceCallout(200, jsonStr));
        OA_OrderWebServiceCalloutRetryController.quoteOrderCalloutRetry(quoteID);
        //TF_OrderHubWebServiceCallout.sendOrderNotification(quoteIds);       
        Test.stopTest();
    }
    
    @isTest static void testSendOrderNotification_self() { 
        string jsonStr = '{{"salesOrg" : "IN01","productType" : "TF-ARTICLE","metaData" : {"currency" : "USD","customer" : {"customerEmail" : "test@gmail.com"},"addressGroup" : {"shipTo" : {"personName" : {"lastName" : " test","firstNames" : "test"},"address" : {"state" : null,"postalCode" : "798798789","phoneNumber" : "87879798","phoneExtension" : "","Organisation" : "Test_Const_Camp01","faxNumber" : "","department" : null,"country" : "BD","city" : "my City","bpNumber" : null,"addressLine2" : null,"addressLine1" : "Street 1"}},"billTo" : {"personName" : {"lastName" : " test","firstNames" : "test"},"address" : {"state" : null,"postalCode" : "798798789","phoneNumber" : "87879798","phoneExtension" : "","Organisation" : null,"faxNumber" : "","department" : "","country" : "BD","city" : "my City","bpNumber" : "0003728934","addressLine2" : null,"addressLine1" : "Street 1"}}}},"items" : [ {"quantity" : 1,"productId" : "OABI","price" : 225.00,"discount" : 0.000}, {"quantity" : 1,"productId" : "OABI","price" : 2950.00,"discount" : 0.000}]}';
        Id quoteID = createSampleDataForSelf();
        List<Id> quoteIds = new List<Id>{quoteID};
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Ztest_TF_OrderHubWebServiceCallout(200, jsonStr));
        OA_OrderWebServiceCalloutRetryController.quoteOrderCalloutRetry(quoteID);
        //TF_OrderHubWebServiceCallout.sendOrderNotification(quoteIds);       
        Test.stopTest();
    }
    
    @isTest static void testSendOrderNotification_OrderHub_invalid() { 
		string jsonStr = '';
        Id quoteID = createSampleDataForSelf();
        List<Id> quoteIds = new List<Id>{quoteID};
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Ztest_TF_OrderHubWebServiceCallout(200, jsonStr));
        OA_OrderWebServiceCalloutRetryController.quoteOrderCalloutRetry(quoteID);
        //TF_OrderHubWebServiceCallout.sendOrderNotification(quoteIds);       
        Test.stopTest();
    }
    
    @isTest static void testSendOrderNotification_organization() { 
        String jsonStr = '{"withholdInvoice" : false,"totalTax" : 0.0,"seller" : "TANDF","quoteNumber" : "Q-17310","orderType" : "SALES","orderStatus" : "OPEN","orderPrice" : 3175.00,"orderedItem" : [ {"taxCode" : null,"taxAmount" : 0.0,"sellingPrice" : 225.00,"salesType" : "RAPID-TRACK-FEE","salesOrg" : "IN01","quantity" : 1.00,"productId" : "OABI_32432432423423","price" : 225.00,"orderedQuantity" : 1.00,"currency" : "USD","lineItemType" : "TF-JOURNAL","discountCurrency" : "USD","discountCode" : null,"discountAmount" : 0.00,"discount" : 0.00,"description" : "test"}, {"taxCode" : null,"taxAmount" : 0.0,"sellingPrice" : 2950.00,"salesType" : "APC-FEE","salesOrg" : "IN01","quantity" : 1.00,"productId" : "OABI_32432432423423","price" : 2950.00,"orderedQuantity" : 1.00,"currency" : "USD","lineItemType" : "TF-JOURNAL","discountCurrency" : "USD","discountCode" : null,"discountAmount" : 0.00,"discount" : 0.00,"description" : "test"} ],"externalOrderRef" : "32432432423423","customerId" : "Test_Const_Camp01","channel" : "TF-SUBMISSION-PLATFORM","buyerId" : "test@gmail.com","billingAddress" : {"taxRegistrationNumber" : null,"taxCategory" : null,"postalCode" : "798798789","externalCustomerAddressId" : "a1y3E000000FCKkQAO","countryCode" : "BD","businessPartnerNo" : "0003728934","addressRegion" : null,"addressOrganisation" : "Test_Const_Camp01","addressLocality" : "my City","addressLine2" : null,"addressLine1" : "Street 1","addressCountry" : "Bangladesh","addressContactLastName" : null,"addressContactFirstName" : null,"addressContactEmail" : "test@gmail.com"}}';

        Id quoteID = createSampleDataForSelf();
        List<Id> quoteIds = new List<Id>{quoteID};
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Ztest_TF_OrderHubWebServiceCallout(200, jsonStr));
        OA_OrderWebServiceCalloutRetryController.quoteOrderCalloutRetry(quoteID);
        //TF_OrderHubWebServiceCallout.sendOrderNotification(quoteIds);       
        Test.stopTest();
    }
    
    @isTest static void testSendOrderNotification_thirdparty() { 
        String jsonStr = '{"withholdInvoice" : false,"totalTax" : 0.0,"seller" : "TANDF","quoteNumber" : "Q-17310","orderType" : "SALES","orderStatus" : "OPEN","orderPrice" : 3175.00,"orderedItem" : [ {"taxCode" : null,"taxAmount" : 0.0,"sellingPrice" : 225.00,"salesType" : "RAPID-TRACK-FEE","salesOrg" : "IN01","quantity" : 1.00,"productId" : "OABI_32432432423423","price" : 225.00,"orderedQuantity" : 1.00,"currency" : "USD","lineItemType" : "TF-JOURNAL","discountCurrency" : "USD","discountCode" : null,"discountAmount" : 0.00,"discount" : 0.00,"description" : "test"}, {"taxCode" : null,"taxAmount" : 0.0,"sellingPrice" : 2950.00,"salesType" : "APC-FEE","salesOrg" : "IN01","quantity" : 1.00,"productId" : "OABI_32432432423423","price" : 2950.00,"orderedQuantity" : 1.00,"currency" : "USD","lineItemType" : "TF-JOURNAL","discountCurrency" : "USD","discountCode" : null,"discountAmount" : 0.00,"discount" : 0.00,"description" : "test"} ],"externalOrderRef" : "32432432423423","customerId" : "Test_Const_Camp01","channel" : "TF-SUBMISSION-PLATFORM","buyerId" : "test@gmail.com","billingAddress" : {"taxRegistrationNumber" : null,"taxCategory" : null,"postalCode" : "798798789","externalCustomerAddressId" : "a1y3E000000FCKkQAO","countryCode" : "BD","businessPartnerNo" : "0003728934","addressRegion" : null,"addressOrganisation" : "Test_Const_Camp01","addressLocality" : "my City","addressLine2" : null,"addressLine1" : "Street 1","addressCountry" : "Bangladesh","addressContactLastName" : null,"addressContactFirstName" : null,"addressContactEmail" : "test@gmail.com"}}';

        Id quoteID = createSampleDataForSelf();
        List<Id> quoteIds = new List<Id>{quoteID};
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Ztest_TF_OrderHubWebServiceCallout(200, jsonStr));
        OA_OrderWebServiceCalloutRetryController.quoteOrderCalloutRetry(quoteID);
        //TF_OrderHubWebServiceCallout.sendOrderNotification(quoteIds);       
        Test.stopTest();
    }
    
    @isTest static void testSendOrderNotification_thirdpartyorganization() { 
		string jsonStr = '{"withholdInvoice" : false,"totalTax" : 0.0,"seller" : "TANDF","quoteNumber" : "Q-17310","orderType" : "SALES","orderStatus" : "OPEN","orderPrice" : 3175.00,"orderedItem" : [ {"taxCode" : null,"taxAmount" : 0.0,"sellingPrice" : 225.00,"salesType" : "RAPID-TRACK-FEE","salesOrg" : "IN01","quantity" : 1.00,"productId" : "OABI_32432432423423","price" : 225.00,"orderedQuantity" : 1.00,"currency" : "USD","lineItemType" : "TF-JOURNAL","discountCurrency" : "USD","discountCode" : null,"discountAmount" : 0.00,"discount" : 0.00,"description" : "test"}, {"taxCode" : null,"taxAmount" : 0.0,"sellingPrice" : 2950.00,"salesType" : "APC-FEE","salesOrg" : "IN01","quantity" : 1.00,"productId" : "OABI_32432432423423","price" : 2950.00,"orderedQuantity" : 1.00,"currency" : "USD","lineItemType" : "TF-JOURNAL","discountCurrency" : "USD","discountCode" : null,"discountAmount" : 0.00,"discount" : 0.00,"description" : "test"} ],"externalOrderRef" : "32432432423423","customerId" : "Test_Const_Camp01","channel" : "TF-SUBMISSION-PLATFORM","buyerId" : "test@gmail.com","billingAddress" : {"taxRegistrationNumber" : null,"taxCategory" : null,"postalCode" : "798798789","externalCustomerAddressId" : "a1y3E000000FCKkQAO","countryCode" : "BD","businessPartnerNo" : "0003728934","addressRegion" : null,"addressOrganisation" : "Test_Const_Camp01","addressLocality" : "my City","addressLine2" : null,"addressLine1" : "Street 1","addressCountry" : "Bangladesh","addressContactLastName" : null,"addressContactFirstName" : null,"addressContactEmail" : "test@gmail.com"}}';

        Id quoteID = createSampleDataForSelf();
        List<Id> quoteIds = new List<Id>{quoteID};
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Ztest_TF_OrderHubWebServiceCallout(200, jsonStr));
        OA_OrderWebServiceCalloutRetryController.quoteOrderCalloutRetry(quoteID);
        //TF_OrderHubWebServiceCallout.sendOrderNotification(quoteIds);       
        Test.stopTest();
    } 
        
    @isTest static void testOHPostCallout_invalid() { 
		string jsonStr = '{}';
        Id quoteID = createSampleDataForSelf();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Ztest_TF_OrderHubWebServiceCallout(200, jsonStr));
        TF_OrderHubWebServiceCallout.OrderHubResultDetails response = TF_OrderHubWebServiceCallout.callOrderHubApi(quoteID,0,'Self','124');       
        Test.stopTest();
    }

    @isTest static void testOHPostCallout_invalid2() { 
		string jsonStr = '{}';
        Id quoteID = createSampleDataForSelf();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Ztest_TF_OrderHubWebServiceCallout(200, jsonStr));
        TF_OrderHubWebServiceCallout.OrderHubResultDetails response = TF_OrderHubWebServiceCallout.callOrderHubApi(quoteID,0,'Organization','123');       
        Test.stopTest();
    }
    
    @isTest static void testOHPostCallout_invalid3() { 
		string jsonStr = '{}';
        Id quoteID = createSampleDataForSelf();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Ztest_TF_OrderHubWebServiceCallout(200, jsonStr));
        TF_OrderHubWebServiceCallout.OrderHubResultDetails response = TF_OrderHubWebServiceCallout.callOrderHubApi(quoteID,0,'Self','124');       
        Test.stopTest();
    }
    
    @isTest static void testSendOrderNotification_prepayQuote() { 
        //string jsonStr = '{"metadata": {"message": "Order Created Successfully!","code": 201},"data": {"orderNumber": "ODR975336","listOfOrderNumber": null}}';
        string jsonStr = '{"withholdInvoice" : false,"totalTax" : 0.0,"seller" : "TANDF","quoteNumber" : "Q-17310","orderType" : "SALES","orderStatus" : "OPEN","orderPrice" : 3175.00,"orderedItem" : [ {"taxCode" : null,"taxAmount" : 0.0,"sellingPrice" : 225.00,"salesType" : "RAPID-TRACK-FEE","salesOrg" : "IN01","quantity" : 1.00,"productId" : "OABI_32432432423423","price" : 225.00,"orderedQuantity" : 1.00,"currency" : "USD","lineItemType" : "TF-JOURNAL","discountCurrency" : "USD","discountCode" : null,"discountAmount" : 0.00,"discount" : 0.00,"description" : "test"}, {"taxCode" : null,"taxAmount" : 0.0,"sellingPrice" : 2950.00,"salesType" : "APC-FEE","salesOrg" : "IN01","quantity" : 1.00,"productId" : "OABI_32432432423423","price" : 2950.00,"orderedQuantity" : 1.00,"currency" : "USD","lineItemType" : "TF-JOURNAL","discountCurrency" : "USD","discountCode" : null,"discountAmount" : 0.00,"discount" : 0.00,"description" : "test"} ],"externalOrderRef" : "32432432423423","customerId" : "Test_Const_Camp01","channel" : "TF-SUBMISSION-PLATFORM","buyerId" : "test@gmail.com","billingAddress" : {"taxRegistrationNumber" : null,"taxCategory" : null,"postalCode" : "798798789","externalCustomerAddressId" : "a1y3E000000FCKkQAO","countryCode" : "BD","businessPartnerNo" : "0003728934","addressRegion" : null,"addressOrganisation" : "Test_Const_Camp01","addressLocality" : "my City","addressLine2" : null,"addressLine1" : "Street 1","addressCountry" : "Bangladesh","addressContactLastName" : null,"addressContactFirstName" : null,"addressContactEmail" : "test@gmail.com"}}';

        Id quoteID = createSampleDataForSelf();
        List<Id> quoteIds = new List<Id>{quoteID};
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Ztest_TF_OrderHubWebServiceCallout(200, jsonStr));
        OA_OrderWebServiceCalloutRetryController.quoteOrderCalloutRetry(quoteID);
        //TF_OrderHubWebServiceCallout.sendOrderNotification(quoteIds);       
        Test.stopTest();
    }


    private static void customSetting() {
        TF_OrgSpecificProps__c setting = new TF_OrgSpecificProps__c();
        setting.OrderHubApi_URL__c = 'https://api-uat.taylorandfrancis.com/v1/orders/bp';
		setting.OrderHubCalcTaxApi_URL__c = 'https://secure-uat.taylorfrancis.com/calculatetax';
        setting.EmailAddressForOrderHubAlarmNotification__c = 'Amit.Kumar@tandfindia.com';
        setting.EmailAddressFoTaxrAlarmNotification__c='Amanica.nagunuri@informa.com';
        setting.Order_Hub_Mandatory_Countries__c = 'US,CA,BR';
        insert setting;     
    }    
}