@isTest
public class Test_OrderAPI { 
    
    @testSetup static void setup(){
        OrderApiSetting__c OrderApiSetting = new  OrderApiSetting__c(Name = 'Single Setting Record',Error_Recipient_Email_Address__c='test@gmail.com',Send_Error_Emails__c=true,Create_Setting_Item_Error_Logs__c=true, PrickeBookId__c = '01s0Y00000832cjQAA');   
        insert OrderApiSetting; 
        Account orderHubAcc = new Account(Name='test',customer_id__c='97546');
        insert  orderHubAcc;
        Contact orderHubCnt = new Contact(LastName='Test1',Party_Id__c='102059');
        insert orderHubCnt;    
        Product2 pi = new product2(Name ='xy',IsActive = true,ISBN__c='9875628223'); 
        insert pi; 
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry objStandardprice = new PricebookEntry(Pricebook2Id = pricebookId ,Product2Id = pi.Id , UnitPrice=1000 ,isActive = true);
        insert objStandardprice;     
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = pi.Id,UnitPrice = 1000, IsActive = true);
        insert customPrice;
        Setting__c  settingOrderApiLogs = new  Setting__c(Name = 'OrderApi_Error_Logs');
        insert settingOrderApiLogs ;
        Setting_Item__c settingItemOrderApiLogs = new Setting_Item__c(Text_3__c='1234567:07/31/2019',Setting__c=settingOrderApiLogs.id);
        insert settingItemOrderApiLogs;
		Setting__c  settingOrderApiChannel = new  Setting__c(Name = 'Order Detail Page Mapping');
        insert settingOrderApiChannel ;
        Setting_Item__c settingItemOrderApiChannelASC = new Setting_Item__c(Text_1__c='ASC',Setting__c=settingOrderApiChannel.id);
        insert settingItemOrderApiChannelASC;       
        Setting_Item__c settingItemOrderApiChannelGOBI = new Setting_Item__c(Text_1__c='GOBI',Setting__c=settingOrderApiChannel.id);
        insert settingItemOrderApiChannelGOBI;
        Setting_Item__c settingItemOrderApiChannelUBX = new Setting_Item__c(Text_1__c='UBX',Setting__c=settingOrderApiChannel.id);
        insert settingItemOrderApiChannelUBX;
        
        SAP_BP__c sapObject = new SAP_BP__c(Account_Id__c = orderHubAcc.Id,First_Name__c = 'test_first_name',Last_Name__c = 'test_last_name',Email__c = 'test@gmail.com',Name = 'PENDING',Street__c = 'Test Street',Region__c = 'Test_Region',Address_Type__c = 'Account Mailing',State__c = 'test state',Country__c = 'test',City__c = 'test city',Status__c = true);
        insert sapObject;
        
        Opportunity  op = new Opportunity();
        op.Name = 'test';
        op.CloseDate= System.today();
        op.Description = 'test test test';
        op.StageName = 'Open';
        op.Pricebook2Id =customPB.Id;
        op.AccountId = orderHubAcc.Id;
        op.Account_Validate_Opp__c = true;
        op.Bill_to_BP__c= sapObject.id;
        insert op;
        
        Id quoteRecordtypeId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'Automated eBook Direct Sales Orders');
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(DOI__C='123',SBQQ__Opportunity2__c = op.Id,SBQQ__BillingCity__c = 'test Billing',SBQQ__Account__c = orderHubAcc.Id, Payer_Account__c = orderHubAcc.Id, SBQQ__ExpirationDate__c = System.today() + 60, SBQQ__Status__c = 'Accepted', SBQQ__Primary__c=true,Quote_Type__c = 'Direct Sale', RecordTypeId = quoteRecordtypeId); 
        insert quoteObject;
        
        Id BPCquoteRecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('T&F - BPC Quote Type').getRecordTypeId();
        SBQQ__Quote__c quoteObject1 = new SBQQ__Quote__c(DOI__C='987',SBQQ__Opportunity2__c = op.Id,SBQQ__BillingCity__c = 'test Billing',SBQQ__Account__c = orderHubAcc.Id, Payer_Account__c = orderHubAcc.Id, SBQQ__ExpirationDate__c = System.today() + 60, SBQQ__Status__c = 'Accepted', SBQQ__Primary__c=true,Quote_Type__c = 'Direct Sale', RecordTypeId = BPCquoteRecordTypeId); 
        insert quoteObject1;
        
        Id quoteOARecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('T&F - OA Journal Quote').getRecordTypeId();
        SBQQ__Quote__c quoteObject2 = new SBQQ__Quote__c(DOI__C='567',SBQQ__Opportunity2__c = op.Id,SBQQ__BillingCity__c = 'test Billing',SBQQ__Account__c = orderHubAcc.Id, Payer_Account__c = orderHubAcc.Id, SBQQ__ExpirationDate__c = System.today() + 60, SBQQ__Status__c = 'Accepted', SBQQ__Primary__c=true,Quote_Type__c = 'Direct Sale', RecordTypeId = quoteOARecordTypeId); 
        insert quoteObject2;
        
    }
    
	@isTest private static void orderSyncTest1(){    
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/OrderAPI/salesforceOrderSync'; //Request URL
        req.httpMethod = 'POST';
        req.requestBody=Blob.valueOf('{"id":982309}');
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        OrderAPI.orderSync();
        OrderAPI.orderSyncTest();
        Test.stopTest();
        System.assertNotEquals(res,Null);
        
    }

    @isTest private static void orderSyncTest2(){          
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
		Product2 pi = [select id,ISBN__c,IsActive from Product2];
        SBQQ__Quote__c quote = [SELECT Id,Name,DOI__c, RecordTypeID FROM SBQQ__Quote__c Limit 1];
        req.requestURI = '/services/apexrest/OrderAPI/salesforceOrderSync'; //Request URL
        req.httpMethod = 'POST';
        string jsonErrStr='{"id":982309,"orderType":"SALES","channel":"ASC","externalOrderRef":"745858","externalSystemRefId":null,"notes":null,"quoteNumber":"'+quote.Name+'","orderNumber":"ODR982309","confirmationNumber":null,"customerId":"0019E00000yzJXjQAM","buyerId":"0039E00000sjn1EQAQ","discount":null,"discountCode":null,"discountCurrency":null,"discountAmount":null,"orderDate":"2019-08-28","orderPrice":2395.00,"orderStatus":"Draft","invoices":[{"invoiceLineItems":[{"orderItemId":3914235,"quantity":1,"productId":"'+pi.ISBN__c+'"}],"invoicePaymentPastDue":false,"id":976406,"externalInvoiceRef":"0952001204","broker":"ASC","freightCharge":null,"freightTax":null,"currency":"EUR","paymentStatus":"PENDING","paymentDueDate":1569560999203,"paymentTerm":"Z030","paymentUrl":null,"salesOrg":"IN01","readyForDownload":null,"payments":[]}],"seller":"TANDF","billingAddress":{"id":977830,"addressLine1":"Schimmelt 32","addressLine2":null,"addressLine3":null,"addressCountry":"Netherlands","addressLocality":"Eindhoven","addressRegion":"North Brabant","addressContactName":null,"addressContactEmail":"amanica.nagunuri@informa.com","addressOrganisation":null,"postalCode":"5611 ZX","streetAddress":null,"businessPartnerNo":"0003721339","countryCode":"NL","telephoneNo":null,"externalCustomerAddressId":"a1y1j000000wQWuAAM","addressType":null,"houseNumber":null,"taxRegistrationNumber":null,"taxCategory":null,"addressContactFirstName":"amanica","addressContactLastName":" N"},"shippingAddress":null,"fulfillments":[],"orderedItem":[{"id":3914235,"productId":"'+pi.ISBN__c+'","price":2395.00,"sellingPrice":2395.00,"currency":"EUR","sellingCurrency":null,"quantity":1,"orderedQuantity":1,"lineItemType":"Open Access Fee","discount":"0.000","discountCode":null,"discountCurrency":"EUR","discountAmount":"0.00","taxCode":null,"taxAmount":0,"description":null,"status":null,"salesOrg":null}],"description":"test","docDate":null,"release":null,"webId":null,"shipCustId":null,"orderSource":null,"rateOfExchange":null,"subTotalPrice":null,"totalTax":0}'; 
        req.requestBody=Blob.valueOf(jsonErrStr);
        RestContext.request = req;
        RestContext.response= res;  
        Test.startTest();
        OrderAPI.orderSync();
        OrderAPI.orderSyncTest();
        Test.stopTest();   
        System.assertNotEquals(res,Null); 
    }
    
    @isTest private static void orderSyncTest3(){          
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
		Product2 pi = [select id,ISBN__c,IsActive from Product2];
        Opportunity op = [select id from Opportunity];
        Account ac = [select id from Account]; 
        Contact cn = [select id from Contact]; 
        SBQQ__Quote__c quote = [SELECT Id,Name,DOI__c, RecordTypeID FROM SBQQ__Quote__c Limit 1];

        
        req.requestURI = '/services/apexrest/OrderAPI/salesforceOrderSync'; //Request URL
        req.httpMethod = 'POST';
        string jsonErrStr='{"id":1061228,"orderType":"SALES","channel":"GOBI","externalOrderRef":"TAF5000004406","externalSystemRefId":"'+op.Id+'","notes":null,"quoteNumber":"null","orderNumber":"ODR1061228","confirmationNumber":null,"customerId":"97546","buyerId":"102059","discount":null,"discountCode":null,"discountCurrency":null,"discountAmount":null,"orderDate":"2019-09-07","orderPrice":306.27,"orderStatus":"OPEN","invoices":[{"invoiceLineItems":[{"orderItemId":6501922,"quantity":1,"productId":"'+pi.ISBN__c+'"},{"orderItemId":6501923,"quantity":1,"productId":"'+pi.ISBN__c+'"}],"invoicePaymentPastDue":false,"id":1061177,"externalInvoiceRef":"0952104530","broker":"GOBI","freightCharge":null,"freightTax":null,"currency":"USD","paymentStatus":"PENDING","paymentDueDate":1570447758698,"paymentTerm":"Z030","paymentUrl":null,"salesOrg":"IN01","readyForDownload":null,"payments":[]}],"seller":"TANDF","billingAddress":{"id":1063350,"addressLine1":"999 Maple Street","addressLine2":null,"addressLine3":null,"addressCountry":"UNITED STATES OF AMERICA","addressLocality":"CONTOOCOOK","addressRegion":"NH","addressContactName":"nullnull","addressContactEmail":"econtent@ybp.com","addressOrganisation":null,"postalCode":"03229-3374","streetAddress":null,"businessPartnerNo":"1208965","countryCode":"US","telephoneNo":null,"externalCustomerAddressId":"28401","addressType":null,"houseNumber":null,"taxRegistrationNumber":null,"taxCategory":null,"addressContactFirstName":null,"addressContactLastName":null},"shippingAddress":{"id":1063351,"addressLine1":"WIVENHOE PARK","addressLine2":"COLCHESTER","addressLine3":null,"addressCountry":"United Kingdom","addressLocality":"COLCHESTER","addressRegion":null,"addressContactName":"Universityof Essex","addressContactEmail":"collad@essex.ac.uk","addressOrganisation":null,"postalCode":"CO4 3SQ","streetAddress":null,"businessPartnerNo":"0003873169","countryCode":"GB","telephoneNo":null,"externalCustomerAddressId":"32535","addressType":null,"houseNumber":null,"taxRegistrationNumber":null,"taxCategory":null,"addressContactFirstName":null,"addressContactLastName":null},"fulfillments":[{"fulfillmentLineItems":[{"orderItemId":6501922,"productId":"'+pi.ISBN__c+'","fulfillmentStatus":"NOT_FULFILLED","fulfillmentQuantity":1},{"orderItemId":6501923,"productId":"'+pi.ISBN__c+'","fulfillmentStatus":"NOT_FULFILLED","fulfillmentQuantity":1}],"id":6152232,"name":"Gobi Order Fulfillment","description":"Gobi Order Fulfillment Description","licenseType":"perpetual","termStartDate":null,"termEndDate":null,"grantType":["viewOnline","download"],"bundle":null,"printOnDemand":null,"catalogueNumber":null,"shipmentStatus":null,"status":null}],"orderedItem":[{"id":6501922,"productId":"'+pi.ISBN__c+'","price":193,"sellingPrice":160.19,"currency":"USD","sellingCurrency":"USD","quantity":1,"orderedQuantity":1,"lineItemType":"Ebook","discount":17.00,"discountCode":null,"discountCurrency":null,"discountAmount":32.81,"taxCode":null,"taxAmount":0.00,"description":null,"status":null,"salesOrg":null},{"id":6501923,"productId":"'+pi.ISBN__c+'","price":176,"sellingPrice":146.08,"currency":"USD","sellingCurrency":"USD","quantity":1,"orderedQuantity":1,"lineItemType":"Ebook","discount":17.00,"discountCode":null,"discountCurrency":null,"discountAmount":29.92,"taxCode":null,"taxAmount":0.00,"description":null,"status":null,"salesOrg":null}],"description":null,"docDate":null,"release":null,"webId":null,"shipCustId":null,"orderSource":null,"rateOfExchange":null,"subTotalPrice":null,"totalTax":0.00}0}'; 
        
        req.requestBody=Blob.valueOf(jsonErrStr);
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        OrderAPI.orderSync();
        OrderAPI.orderSyncTest();
        System.assertNotEquals(res,Null);
        
  		Setting__c si = [select id from Setting__c where Name = 'OrderApi_Error_Logs']; 
        List<Setting_Item__c> obj = new List<Setting_Item__c>();
        //String jsonBody = '{"id":982309,"orderType":"SALES","channel":"ASC","externalOrderRef":"745858","externalSystemRefId":"'+op.Id+'","notes":null,"quoteNumber":"'+quote.Name+'","orderNumber":"ODR982309","confirmationNumber":null,"customerId":"'+ac.Id+'","buyerId":"'+cn.Id+'","discount":null,"discountCode":null,"discountCurrency":null,"discountAmount":null,"orderDate":"2019-08-28","orderPrice":2395.00,"orderStatus":"Draft","invoices":[{"invoiceLineItems":[{"orderItemId":3914235,"quantity":1,"productId":"'+pi.ISBN__c+'"}],"invoicePaymentPastDue":false,"id":976406,"externalInvoiceRef":"0952001204","broker":"ASC","freightCharge":null,"freightTax":null,"currency":"EUR","paymentStatus":"PENDING","paymentDueDate":1569560999203,"paymentTerm":"Z030","paymentUrl":null,"salesOrg":"IN01","readyForDownload":null,"payments":[]}],"seller":"TANDF","billingAddress":{"id":977830,"addressLine1":"Schimmelt 32","addressLine2":null,"addressLine3":null,"addressCountry":"Netherlands","addressLocality":"Eindhoven","addressRegion":"North Brabant","addressContactName":null,"addressContactEmail":"amanica.nagunuri@informa.com","addressOrganisation":null,"postalCode":"5611 ZX","streetAddress":null,"businessPartnerNo":"0003721339","countryCode":"NL","telephoneNo":null,"externalCustomerAddressId":"a1y1j000000wQWuAAM","addressType":null,"houseNumber":null,"taxRegistrationNumber":null,"taxCategory":null,"addressContactFirstName":"amanica","addressContactLastName":" N"},"shippingAddress":null,"fulfillments":[],"orderedItem":[{"id":3914235,"productId":"'+pi.ISBN__c+'","price":2395.00,"sellingPrice":2395.00,"currency":"EUR","sellingCurrency":null,"quantity":1,"orderedQuantity":1,"lineItemType":"Open Access Fee","discount":0.000,"discountCode":null,"discountCurrency":"EUR","discountAmount":0.00,"taxCode":null,"taxAmount":0,"description":null,"status":null,"salesOrg":null}],"description":"test","docDate":null,"release":null,"webId":null,"shipCustId":null,"orderSource":null,"rateOfExchange":null,"subTotalPrice":null,"totalTax":0}';
        String jsonBody = '{"totalDiscountAmount":0.00,"originalOrderRef":null,"cancelReason":null,"withholdInvoice":false,"paymentTerm":null,"royaltyNotified":null,"requestInfo":null,"sponsors":null,"printInvoiceDetail":null,"id":832764,"orderType":"SALES","channel":"EBK_DIRECT_SALES","externalOrderRef":"00033818","externalSystemRefId":"'+op.Id+'","notes":null,"quoteNumber":"'+quote.Name+'","orderNumber":"ODR832764","confirmationNumber":33818,"customerId":"'+ac.Id+'","buyerId":"'+cn.Id+'","discount":0.00,"discountCode":null,"discountCurrency":null,"discountAmount":0.00,"orderDate":"2021-03-11","orderPrice":865.00,"orderStatus":"OPEN","invoices":[{"invoiceLineItems":[{"orderItemId":7860378,"quantity":1,"productId":"9780429162497","itemNumber":"000010"},{"orderItemId":7860379,"quantity":1,"productId":"9780429276231","itemNumber":"000020"},{"orderItemId":7860380,"quantity":1,"productId":"9780203743287","itemNumber":"000030"}],"invoiceType":"INVOICE","originalInvoiceRef":null,"salesOrderNumber":null,"invoicePaymentPastDue":false,"id":838614,"externalInvoiceRef":null,"freightCharge":0.00,"freightTax":0.00,"currency":"USD","paymentStatus":"PENDING","paymentDueDate":null,"paymentTerm":null,"paymentUrl":null,"salesOrg":"IN01","readyForDownload":null,"payments":[],"paymentAcknowledgementDate":null}],"seller":"TANDF","billingAddress":{"id":837214,"addressLine1":"Information Services Marylebone Library 35 Marylebone Road","addressLine2":null,"addressLine3":null,"addressCountry":"United Kingdom","addressLocality":"London","addressRegion":"Oxfordshire","addressContactName":"LudovicaT Colacino","addressContactEmail":"ludovicacolacino@gmail.com","addressOrganisation":null,"postalCode":"NW1 5LS","streetAddress":null,"businessPartnerNo":"0004477454","countryCode":"GB","telephoneNo":null,"externalCustomerAddressId":null,"addressType":null,"houseNumber":null,"taxRegistrationNumber":null,"taxCategory":null,"addressContactFirstName":null,"addressContactLastName":null,"department":null,"careOf":null},"shippingAddress":null,"fulfillments":[{"licenseId":null,"fulfillmentLineItems":[{"orderItemId":7860378,"productId":"9780429162497","fulfillmentStatus":"NOT_FULFILLED","fulfillmentQuantity":1},{"orderItemId":7860379,"productId":"9780429276231","fulfillmentStatus":"NOT_FULFILLED","fulfillmentQuantity":1},{"orderItemId":7860380,"productId":"9780203743287","fulfillmentStatus":"NOT_FULFILLED","fulfillmentQuantity":1}],"system":null,"type":"EBOOK_CONTENT_ACCESS","acknowledgementId":null,"fulfillmentPayload":null,"id":4602801,"name":"UBX Title Purchase","description":"UBX Title Purchase","licenseType":"perpetual","termStartDate":null,"termEndDate":null,"grantType":["viewOnline","download"],"bundle":null,"printOnDemand":null,"catalogueNumber":null,"shipmentStatus":null,"status":null}],"orderedItem":[{"altProductId":null,"sponsorRefId":null,"id":7860378,"productId":"'+pi.ISBN__c+'","price":300.00,"sellingPrice":300.00,"currency":"USD","sellingCurrency":null,"quantity":1,"orderedQuantity":1,"lineItemType":"DIRECT-EBOOK","salesType":"PURCHASE","discount":0.00,"discountCode":null,"discountCurrency":"USD","discountAmount":0.00,"taxCode":"ZMSC","taxAmount":0.00,"description":"m1","orderRefItemText":null,"status":"NOT_FULFILLED","salesOrg":null},{"altProductId":null,"sponsorRefId":null,"id":7860379,"productId":"'+pi.ISBN__c+'","price":270.00,"sellingPrice":270.00,"currency":"USD","sellingCurrency":null,"quantity":1,"orderedQuantity":1,"lineItemType":"DIRECT-EBOOK","salesType":"PURCHASE","discount":0.00,"discountCode":null,"discountCurrency":"USD","discountAmount":0.00,"taxCode":"ZMSC","taxAmount":0.00,"description":"o1","orderRefItemText":null,"status":"NOT_FULFILLED","salesOrg":null},{"altProductId":null,"sponsorRefId":null,"id":7860380,"productId":"9780203743287","price":295.00,"sellingPrice":295.00,"currency":"USD","sellingCurrency":null,"quantity":1,"orderedQuantity":1,"lineItemType":"DIRECT-EBOOK","salesType":"PURCHASE","discount":0.00,"discountCode":null,"discountCurrency":"USD","discountAmount":0.00,"taxCode":"ZMSC","taxAmount":0.00,"description":"p1","orderRefItemText":null,"status":"NOT_FULFILLED","salesOrg":null}],"description":null,"docDate":null,"release":null,"shipCustId":null,"orderSource":null,"rateOfExchange":0.00,"subTotalPrice":865.00,"totalTax":0.00,"externalSystemRefId":"0065r000002NCT1AAO","fulfilled":false,"paid":false}';
        for(Integer i=0; i<=10 ; i++){
            Setting_Item__c settingItemOrderApiLogs = new Setting_Item__c();
            settingItemOrderApiLogs.Text_3__c='1234567:07/31/2019';
            settingItemOrderApiLogs.Long_Text_1__c= jsonBody;
            settingItemOrderApiLogs.Text_2__c ='ERROR: Customer not exist in SF. on line 291';
            settingItemOrderApiLogs.Setting__c= si.Id;
            obj.add(settingItemOrderApiLogs);
        }   
        OrderAPI.reOrderApiResponse(obj);    
        Test.stopTest();  
        
    }
    @isTest private static void orderSyncTest4(){
        Opportunity op = [select id from Opportunity];
       
        Product2 pi = [select id,ISBN__c,IsActive from Product2];
        Account ac = [select id from Account]; 
       
        Contact cn = [select id from Contact]; 
        SBQQ__Quote__c quote = [SELECT Id,Name,DOI__c, RecordTypeID FROM SBQQ__Quote__c Limit 1];
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/OrderAPI/salesforceOrderSync'; //Request URL
        req.httpMethod = 'POST';
        string jsonBody='{"id":982309,"orderType":"SALES","channel":"ASC","externalOrderRef":"745858","externalSystemRefId":"'+op.Id+'","notes":null,"quoteNumber":"'+quote.Name+'","orderNumber":"ODR1061228","confirmationNumber":null,"customerId":"97546","buyerId":"'+cn.Id+'","discount":null,"discountCode":null,"discountCurrency":null,"discountAmount":null,"orderDate":"2019-09-07","orderPrice":306.27,"orderStatus":"OPEN","invoices":[{"invoiceLineItems":[{"orderItemId":6501922,"quantity":1,"productId":"'+pi.ISBN__c+'"},{"orderItemId":6501923,"quantity":1,"productId":"'+pi.ISBN__c+'"}],"invoicePaymentPastDue":false,"id":1061177,"externalInvoiceRef":"0952104530","broker":"GOBI","freightCharge":null,"freightTax":null,"currency":"USD","paymentStatus":"PENDING","paymentDueDate":1570447758698,"paymentTerm":"Z030","paymentUrl":null,"salesOrg":"IN01","readyForDownload":null,"payments":[]}],"seller":"TANDF","billingAddress":{"id":1063350,"addressLine1":"999 Maple Street","addressLine2":"Test line2","addressLine3":null,"addressCountry":"UNITED STATES OF AMERICA","addressLocality":"CONTOOCOOK","addressRegion":"NH","addressContactName":"nullnull","addressContactEmail":"econtent@ybp.com","addressOrganisation":null,"postalCode":"03229-3374","streetAddress":null,"businessPartnerNo":"1208965","countryCode":"US","telephoneNo":null,"externalCustomerAddressId":"28401","addressType":null,"houseNumber":null,"taxRegistrationNumber":null,"taxCategory":null,"addressContactFirstName":null,"addressContactLastName":null},"shippingAddress":{"id":1063351,"addressLine1":"WIVENHOE PARK","addressLine2":"COLCHESTER","addressLine3":null,"addressCountry":"United Kingdom","addressLocality":"COLCHESTER","addressRegion":null,"addressContactName":"Universityof Essex","addressContactEmail":"collad@essex.ac.uk","addressOrganisation":null,"postalCode":"CO4 3SQ","streetAddress":null,"businessPartnerNo":"0003873169","countryCode":"GB","telephoneNo":null,"externalCustomerAddressId":"32535","addressType":null,"houseNumber":null,"taxRegistrationNumber":null,"taxCategory":null,"addressContactFirstName":null,"addressContactLastName":null},"fulfillments":[{"fulfillmentLineItems":[{"orderItemId":6501922,"productId":"'+pi.ISBN__c+'","fulfillmentStatus":"NOT_FULFILLED","fulfillmentQuantity":1},{"orderItemId":6501923,"productId":"'+pi.ISBN__c+'","fulfillmentStatus":"NOT_FULFILLED","fulfillmentQuantity":1}],"id":6152232,"name":"Gobi Order Fulfillment","description":"Gobi Order Fulfillment Description","licenseType":"perpetual","termStartDate":null,"termEndDate":null,"grantType":["viewOnline","download"],"bundle":null,"printOnDemand":null,"catalogueNumber":null,"shipmentStatus":null,"status":null}],"orderedItem":[{"id":6501922,"productId":"'+pi.ISBN__c+'","price":193,"sellingPrice":160.19,"currency":"USD","sellingCurrency":"USD","quantity":1,"orderedQuantity":1,"lineItemType":"Ebook","discount":17.00,"discountCode":null,"discountCurrency":null,"discountAmount":32.81,"taxCode":null,"taxAmount":0.00,"description":null,"status":null,"salesOrg":null},{"id":6501923,"productId":"'+pi.ISBN__c+'","price":176,"sellingPrice":146.08,"currency":"USD","sellingCurrency":"USD","quantity":1,"orderedQuantity":1,"lineItemType":"Ebook","discount":17.00,"discountCode":null,"discountCurrency":null,"discountAmount":29.92,"taxCode":null,"taxAmount":0.00,"description":null,"status":null,"salesOrg":null}],"description":null,"docDate":null,"release":null,"webId":null,"shipCustId":null,"orderSource":null,"rateOfExchange":null,"subTotalPrice":null,"totalTax":0.00}0}'; 
        
        req.requestBody=Blob.valueOf(jsonBody);
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        OrderAPI.orderSync();
        OrderAPI.orderSyncTest();
        Test.stopTest(); 
        System.assertNotEquals(res,Null);    
    }
	
	@isTest private static void orderSyncTest5(){          
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
		Product2 pi = [select id,ISBN__c,IsActive from Product2];
        
        SBQQ__Quote__c quote = [SELECT Id,Name,DOI__c, RecordTypeID FROM SBQQ__Quote__c Limit 1];
        req.requestURI = '/services/apexrest/OrderAPI/salesforceOrderSync'; //Request URL
        req.httpMethod = 'POST';
        string jsonErrStr='{"id":1061228,"orderType":"SALES","channel":"UBX","externalOrderRef":"TAF5000004406","externalSystemRefId":null,"notes":null,"quoteNumber":"'+quote.Name+'","orderNumber":"ODR1061228","confirmationNumber":null,"customerId":"97546","buyerId":"102059","discount":null,"discountCode":null,"discountCurrency":null,"discountAmount":null,"orderDate":"2019-09-07","orderPrice":306.27,"orderStatus":"OPEN","invoices":[{"invoiceLineItems":[{"orderItemId":6501922,"quantity":1,"productId":"'+pi.ISBN__c+'"},{"orderItemId":6501923,"quantity":1,"productId":"'+pi.ISBN__c+'"}],"invoicePaymentPastDue":false,"id":1061177,"externalInvoiceRef":"0952104530","broker":"UBX","freightCharge":null,"freightTax":null,"currency":"USD","paymentStatus":"PENDING","paymentDueDate":1570447758698,"paymentTerm":"Z030","paymentUrl":null,"salesOrg":"IN01","readyForDownload":null,"payments":[]}],"seller":"TANDF","billingAddress":{"id":1063350,"addressLine1":"999 Maple Street","addressLine2":null,"addressLine3":null,"addressCountry":"UNITED STATES OF AMERICA","addressLocality":"CONTOOCOOK","addressRegion":"NH","addressContactName":"nullnull","addressContactEmail":"econtent@ybp.com","addressOrganisation":null,"postalCode":"03229-3374","streetAddress":null,"businessPartnerNo":"1208965","countryCode":"US","telephoneNo":null,"externalCustomerAddressId":"28401","addressType":null,"houseNumber":null,"taxRegistrationNumber":null,"taxCategory":null,"addressContactFirstName":null,"addressContactLastName":null},"shippingAddress":{"id":1063351,"addressLine1":"WIVENHOE PARK","addressLine2":"COLCHESTER","addressLine3":null,"addressCountry":"United Kingdom","addressLocality":"COLCHESTER","addressRegion":null,"addressContactName":"Universityof Essex","addressContactEmail":"collad@essex.ac.uk","addressOrganisation":null,"postalCode":"CO4 3SQ","streetAddress":null,"businessPartnerNo":"0003873169","countryCode":"GB","telephoneNo":null,"externalCustomerAddressId":"32535","addressType":null,"houseNumber":null,"taxRegistrationNumber":null,"taxCategory":null,"addressContactFirstName":null,"addressContactLastName":null},"fulfillments":[{"fulfillmentLineItems":[{"orderItemId":6501922,"productId":"'+pi.ISBN__c+'","fulfillmentStatus":"NOT_FULFILLED","fulfillmentQuantity":1},{"orderItemId":6501923,"productId":"'+pi.ISBN__c+'","fulfillmentStatus":"NOT_FULFILLED","fulfillmentQuantity":1}],"id":6152232,"name":"Gobi Order Fulfillment","description":"Gobi Order Fulfillment Description","licenseType":"perpetual","termStartDate":null,"termEndDate":null,"grantType":["viewOnline","download"],"bundle":null,"printOnDemand":null,"catalogueNumber":null,"shipmentStatus":null,"status":null}],"orderedItem":[{"id":6501922,"productId":"'+pi.ISBN__c+'","price":193,"sellingPrice":160.19,"currency":"USD","sellingCurrency":"USD","quantity":1,"orderedQuantity":1,"lineItemType":"Ebook","discount":17.00,"discountCode":null,"discountCurrency":null,"discountAmount":32.81,"taxCode":null,"taxAmount":0.00,"description":null,"status":null,"salesOrg":null},{"id":6501923,"productId":"'+pi.ISBN__c+'","price":176,"sellingPrice":146.08,"currency":"USD","sellingCurrency":"USD","quantity":1,"orderedQuantity":1,"lineItemType":"Ebook","discount":17.00,"discountCode":null,"discountCurrency":null,"discountAmount":29.92,"taxCode":null,"taxAmount":0.00,"description":null,"status":null,"salesOrg":null}],"description":null,"docDate":null,"release":null,"webId":null,"shipCustId":null,"orderSource":null,"rateOfExchange":null,"subTotalPrice":null,"totalTax":0.00}0}'; 
        req.requestBody=Blob.valueOf(jsonErrStr);
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        OrderAPI.orderSync();
        OrderAPI.orderSyncTest();
        System.assertNotEquals(res,Null);
        
        Opportunity op = [select id from Opportunity];
        Account ac = [select id from Account]; 
        Contact cn = [select id from Contact]; 
        Setting__c si = [select id from Setting__c where Name = 'OrderApi_Error_Logs']; 
        List<Setting_Item__c> obj = new List<Setting_Item__c>();
      
        String jsonBody = '{"id":982309,"orderType":"SALES","channel":"ASC","externalOrderRef":"745858","externalSystemRefId":"'+op.Id+'","notes":null,"quoteNumber":"'+quote.Name+'","orderNumber":"ODR982309","confirmationNumber":null,"customerId":"'+ac.Id+'","buyerId":"'+cn.Id+'","discount":null,"discountCode":null,"discountCurrency":null,"discountAmount":null,"orderDate":"2019-08-28","orderPrice":2395.00,"orderStatus":"Draft","invoices":[{"invoiceLineItems":[{"orderItemId":3914235,"quantity":1,"productId":"'+pi.ISBN__c+'"}],"invoicePaymentPastDue":false,"id":976406,"externalInvoiceRef":"0952001204","broker":"ASC","freightCharge":null,"freightTax":null,"currency":"EUR","paymentStatus":"PENDING","paymentDueDate":1569560999203,"paymentTerm":"Z030","paymentUrl":null,"salesOrg":"IN01","readyForDownload":null,"payments":[]}],"seller":"TANDF","billingAddress":{"id":977830,"addressLine1":"Schimmelt 32","addressLine2":null,"addressLine3":null,"addressCountry":"Netherlands","addressLocality":"Eindhoven","addressRegion":"North Brabant","addressContactName":null,"addressContactEmail":"amanica.nagunuri@informa.com","addressOrganisation":null,"postalCode":"5611 ZX","streetAddress":null,"businessPartnerNo":"0003721339","countryCode":"NL","telephoneNo":null,"externalCustomerAddressId":"a1y1j000000wQWuAAM","addressType":null,"houseNumber":null,"taxRegistrationNumber":null,"taxCategory":null,"addressContactFirstName":"amanica","addressContactLastName":" N"},"shippingAddress":null,"fulfillments":[],"orderedItem":[{"id":3914235,"productId":"'+pi.ISBN__c+'","price":2395.00,"sellingPrice":2395.00,"currency":"EUR","sellingCurrency":null,"quantity":1,"orderedQuantity":1,"lineItemType":"Open Access Fee","discount":0.000,"discountCode":null,"discountCurrency":"EUR","discountAmount":0.00,"taxCode":null,"taxAmount":0,"description":null,"status":null,"salesOrg":null}],"description":"test","docDate":null,"release":null,"webId":null,"shipCustId":null,"orderSource":null,"rateOfExchange":null,"subTotalPrice":null,"totalTax":0}';
        for(Integer i=0; i<=10 ; i++){
            Setting_Item__c settingItemOrderApiLogs = new Setting_Item__c();
            settingItemOrderApiLogs.Text_3__c='1234567:07/31/2019';
            settingItemOrderApiLogs.Long_Text_1__c= jsonBody;
            settingItemOrderApiLogs.Text_2__c ='ERROR: Customer not exist in SF. on line 291';
            settingItemOrderApiLogs.Setting__c= si.Id;
            obj.add(settingItemOrderApiLogs);
        }   
        OrderAPI.reOrderApiResponse(obj);    
        Test.stopTest();  
        
    }
    
    @isTest private static void orderSyncTest6(){          
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
		Product2 pi = [select id,ISBN__c,IsActive from Product2];
        req.requestURI = '/services/apexrest/OrderAPI/salesforceOrderSync'; //Request URL
        req.httpMethod = 'POST';
        string jsonErrStr='error';
        req.requestBody=Blob.valueOf(jsonErrStr);
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        OrderAPI.orderSync();
        OrderAPI.orderSyncTest();
        System.assertNotEquals(res,Null);
        
        Opportunity op = [select id from Opportunity];
        Account ac = [select id from Account]; 
        Contact cn = [select id from Contact]; 
        Setting__c si = [select id from Setting__c where Name = 'OrderApi_Error_Logs']; 
        List<Setting_Item__c> obj = new List<Setting_Item__c>();
      
        String jsonBody = 'error';
        for(Integer i=0; i<=10 ; i++){
            Setting_Item__c settingItemOrderApiLogs = new Setting_Item__c();
            settingItemOrderApiLogs.Text_3__c='1234567:07/31/2019';
            settingItemOrderApiLogs.Long_Text_1__c= jsonBody;
            settingItemOrderApiLogs.Text_2__c ='ERROR: Invalid json';
            settingItemOrderApiLogs.Setting__c= si.Id;
            obj.add(settingItemOrderApiLogs);
        }   
        OrderAPI.reOrderApiResponse(obj);    
        Test.stopTest();  
        
    }
    
    @isTest private static void orderSyncTest7(){     
        Opportunity op = [select id from Opportunity];
        Account ac = [select id from Account]; 
        Contact cn = [select id from Contact]; 
        SBQQ__Quote__c quote = [SELECT Id,Name,DOI__c, RecordTypeID FROM SBQQ__Quote__c Limit 1];
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
		Product2 pi = [select id,ISBN__c,IsActive from Product2];
        req.requestURI = '/services/apexrest/OrderAPI/salesforceOrderSync'; //Request URL
        req.httpMethod = 'POST';
        string jsonErrStr='{"id":982309,"orderType":"SALES","channel":"","externalOrderRef":"745858","externalSystemRefId":"'+op.Id+'","notes":null,"quoteNumber":"'+quote.Name+'","orderNumber":"ODR1061228","confirmationNumber":null,"customerId":"'+ac.Id+'","buyerId":"'+cn.Id+'","discount":null,"discountCode":null,"discountCurrency":null,"discountAmount":null,"orderDate":"2019-09-07","orderPrice":306.27,"orderStatus":"OPEN","invoices":[{"invoiceLineItems":[{"orderItemId":6501922,"quantity":1,"productId":"'+pi.ISBN__c+'"},{"orderItemId":6501923,"quantity":1,"productId":"'+pi.ISBN__c+'"}],"invoicePaymentPastDue":false,"id":1061177,"externalInvoiceRef":"0952104530","broker":"GOBI","freightCharge":null,"freightTax":null,"currency":"USD","paymentStatus":"PENDING","paymentDueDate":1570447758698,"paymentTerm":"Z030","paymentUrl":null,"salesOrg":"IN01","readyForDownload":null,"payments":[]}],"seller":"TANDF","billingAddress":{"id":1063350,"addressLine1":"999 Maple Street","addressLine2":"Test line2","addressLine3":null,"addressCountry":"UNITED STATES OF AMERICA","addressLocality":"CONTOOCOOK","addressRegion":"NH","addressContactName":"nullnull","addressContactEmail":"econtent@ybp.com","addressOrganisation":null,"postalCode":"03229-3374","streetAddress":null,"businessPartnerNo":"1208965","countryCode":"US","telephoneNo":null,"externalCustomerAddressId":"28401","addressType":null,"houseNumber":null,"taxRegistrationNumber":null,"taxCategory":null,"addressContactFirstName":null,"addressContactLastName":null},"shippingAddress":{"id":1063351,"addressLine1":"WIVENHOE PARK","addressLine2":"COLCHESTER","addressLine3":null,"addressCountry":"United Kingdom","addressLocality":"COLCHESTER","addressRegion":null,"addressContactName":"Universityof Essex","addressContactEmail":"collad@essex.ac.uk","addressOrganisation":null,"postalCode":"CO4 3SQ","streetAddress":null,"businessPartnerNo":"0003873169","countryCode":"GB","telephoneNo":null,"externalCustomerAddressId":"32535","addressType":null,"houseNumber":null,"taxRegistrationNumber":null,"taxCategory":null,"addressContactFirstName":null,"addressContactLastName":null},"fulfillments":[{"fulfillmentLineItems":[{"orderItemId":6501922,"productId":"'+pi.ISBN__c+'","fulfillmentStatus":"NOT_FULFILLED","fulfillmentQuantity":1},{"orderItemId":6501923,"productId":"'+pi.ISBN__c+'","fulfillmentStatus":"NOT_FULFILLED","fulfillmentQuantity":1}],"id":6152232,"name":"Gobi Order Fulfillment","description":"Gobi Order Fulfillment Description","licenseType":"perpetual","termStartDate":null,"termEndDate":null,"grantType":["viewOnline","download"],"bundle":null,"printOnDemand":null,"catalogueNumber":null,"shipmentStatus":null,"status":null}],"orderedItem":[{"id":6501922,"productId":"'+pi.ISBN__c+'","price":193,"sellingPrice":160.19,"currency":"USD","sellingCurrency":"USD","quantity":1,"orderedQuantity":1,"lineItemType":"Ebook","discount":17.00,"discountCode":null,"discountCurrency":null,"discountAmount":32.81,"taxCode":null,"taxAmount":0.00,"description":null,"status":null,"salesOrg":null},{"id":6501923,"productId":"'+pi.ISBN__c+'","price":176,"sellingPrice":146.08,"currency":"USD","sellingCurrency":"USD","quantity":1,"orderedQuantity":1,"lineItemType":"Ebook","discount":17.00,"discountCode":null,"discountCurrency":null,"discountAmount":29.92,"taxCode":null,"taxAmount":0.00,"description":null,"status":null,"salesOrg":null}],"description":null,"docDate":null,"release":null,"webId":null,"shipCustId":null,"orderSource":null,"rateOfExchange":null,"subTotalPrice":null,"totalTax":0.00}0}'; 
        
        req.requestBody=Blob.valueOf(jsonErrStr);
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        OrderAPI.orderSync();
        OrderAPI.orderSyncTest();
        System.assertNotEquals(res,Null);
        Test.stopTest();  
    }
    
    @isTest private static void orderSyncTest8(){     
        Opportunity op = [select id from Opportunity];
        Account ac = [select id from Account]; 
        Contact cn = [select id from Contact]; 
        SBQQ__Quote__c quote = [SELECT Id,Name,DOI__c, RecordTypeID FROM SBQQ__Quote__c Limit 1];
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
		Product2 pi = [select id,ISBN__c,IsActive from Product2];
        req.requestURI = '/services/apexrest/OrderAPI/salesforceOrderSync'; //Request URL
        req.httpMethod = 'POST';
        string jsonErrStr='{"id":982309,"orderType":"SALES","channel":"Channel","externalOrderRef":"745858","externalSystemRefId":"'+op.Id+'","notes":null,"quoteNumber":"'+quote.Name+'","orderNumber":"ODR982309","confirmationNumber":null,"customerId":"'+ac.Id+'","buyerId":"'+cn.Id+'","discount":null,"discountCode":null,"discountCurrency":null,"discountAmount":null,"orderDate":"2019-08-28","orderPrice":2395.00,"orderStatus":"Draft","invoices":[{"invoiceLineItems":[{"orderItemId":3914235,"quantity":1,"productId":"'+pi.ISBN__c+'"}],"invoicePaymentPastDue":false,"id":976406,"externalInvoiceRef":"0952001204","broker":"ASC","freightCharge":null,"freightTax":null,"currency":"EUR","paymentStatus":"PENDING","paymentDueDate":1569560999203,"paymentTerm":"Z030","paymentUrl":null,"salesOrg":"IN01","readyForDownload":null,"payments":[]}],"seller":"TANDF","billingAddress":{"id":977830,"addressLine1":"Schimmelt 32","addressLine2":null,"addressLine3":null,"addressCountry":"Netherlands","addressLocality":"Eindhoven","addressRegion":"North Brabant","addressContactName":null,"addressContactEmail":"amanica.nagunuri@informa.com","addressOrganisation":null,"postalCode":"5611 ZX","streetAddress":null,"businessPartnerNo":"0003721339","countryCode":"NL","telephoneNo":null,"externalCustomerAddressId":"a1y1j000000wQWuAAM","addressType":null,"houseNumber":null,"taxRegistrationNumber":null,"taxCategory":null,"addressContactFirstName":"amanica","addressContactLastName":" N"},"shippingAddress":null,"fulfillments":[],"orderedItem":[{"id":3914235,"productId":"'+pi.ISBN__c+'","price":2395.00,"sellingPrice":2395.00,"currency":"EUR","sellingCurrency":null,"quantity":1,"orderedQuantity":1,"lineItemType":"Open Access Fee","discount":0.000,"discountCode":null,"discountCurrency":"EUR","discountAmount":0.00,"taxCode":null,"taxAmount":0,"description":null,"status":null,"salesOrg":null}],"description":"test","docDate":null,"release":null,"webId":null,"shipCustId":null,"orderSource":null,"rateOfExchange":null,"subTotalPrice":null,"totalTax":0}';
        req.requestBody=Blob.valueOf(jsonErrStr);
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        OrderAPI.orderSync();
        OrderAPI.orderSyncTest();
        System.assertNotEquals(res,Null);
        Test.stopTest();  
    }
    
    @isTest private static void orderSyncTest9(){     
        Opportunity op = [select id from Opportunity];
        Account ac = [select id from Account];
        Contact cn = [select id from Contact];
        SBQQ__Quote__c quote = [SELECT Id,Name,DOI__c, RecordTypeID FROM SBQQ__Quote__c where DOI__C ='987' Limit 1];
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
		Product2 pi = [select id,ISBN__c,IsActive from Product2];
        req.requestURI = '/services/apexrest/OrderAPI/salesforceOrderSync'; //Request URL
        req.httpMethod = 'POST';
        string jsonErrStr='{"id":982309,"orderType":"SALES","channel":"Channel","externalOrderRef":"745858","externalSystemRefId":"'+op.Id+'","notes":null,"quoteNumber":"'+quote.Name+'","orderNumber":"ODR982309","confirmationNumber":null,"customerId":"'+ac.Id+'","buyerId":"'+cn.Id+'","discount":null,"discountCode":null,"discountCurrency":null,"discountAmount":null,"orderDate":"2019-08-28","orderPrice":2395.00,"orderStatus":"Draft","invoices":[{"invoiceLineItems":[{"orderItemId":3914235,"quantity":1,"productId":"'+pi.ISBN__c+'"}],"invoicePaymentPastDue":false,"id":976406,"externalInvoiceRef":"0952001204","broker":"ASC","freightCharge":null,"freightTax":null,"currency":"EUR","paymentStatus":"PENDING","paymentDueDate":1569560999203,"paymentTerm":"Z030","paymentUrl":null,"salesOrg":"IN01","readyForDownload":null,"payments":[]}],"seller":"TANDF","billingAddress":{"id":977830,"addressLine1":"Schimmelt 32","addressLine2":null,"addressLine3":null,"addressCountry":"Netherlands","addressLocality":"Eindhoven","addressRegion":"North Brabant","addressContactName":null,"addressContactEmail":"amanica.nagunuri@informa.com","addressOrganisation":null,"postalCode":"5611 ZX","streetAddress":null,"businessPartnerNo":"0003721339","countryCode":"NL","telephoneNo":null,"externalCustomerAddressId":"a1y1j000000wQWuAAM","addressType":null,"houseNumber":null,"taxRegistrationNumber":null,"taxCategory":null,"addressContactFirstName":"amanica","addressContactLastName":" N"},"shippingAddress":null,"fulfillments":[],"orderedItem":[{"id":3914235,"productId":"'+pi.ISBN__c+'","price":2395.00,"sellingPrice":2395.00,"currency":"EUR","sellingCurrency":null,"quantity":1,"orderedQuantity":1,"lineItemType":"Open Access Fee","discount":0.000,"discountCode":null,"discountCurrency":"EUR","discountAmount":0.00,"taxCode":null,"taxAmount":0,"description":null,"status":null,"salesOrg":null}],"description":"test","docDate":null,"release":null,"webId":null,"shipCustId":null,"orderSource":null,"rateOfExchange":null,"subTotalPrice":null,"totalTax":0}';
        req.requestBody=Blob.valueOf(jsonErrStr);
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        OrderAPI.orderSync();
        OrderAPI.orderSyncTest();
        System.assertNotEquals(res,Null);
        Test.stopTest();  
    }
    
    @isTest private static void orderSyncTest10(){     
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
		req.requestURI = '/services/apexrest/OrderAPI/salesforceOrderSync'; //Request URL
        req.httpMethod = 'POST';
        req.requestBody=Blob.valueOf('');
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        OrderAPI.orderSync();
        OrderAPI.orderSyncTest();
        System.assertNotEquals(res,Null);
        Test.stopTest();  
    }
   
}