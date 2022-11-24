/**Auther: Shalini Singh
   Class: OrderAPI_OaEbkChargesChannel_BpcFlow
**/
@isTest(SeeAllData=false)
public class OrderAPI_OaEbkChargesChannel_BpcFlowTest {

    @testSetup static void setup(){
        OrderApiSetting__c OrderApiSetting = new  OrderApiSetting__c(Name = 'Single Setting Record',Error_Recipient_Email_Address__c='test@gmail.com',Send_Error_Emails__c=true,Create_Setting_Item_Error_Logs__c=true, PrickeBookId__c = '01s0Y00000832cjQAA');   
        insert OrderApiSetting; 
        Account orderHubAcc = new Account(Name='test',customer_id__c='98422');
        insert  orderHubAcc;
        Contact orderHubCnt = new Contact(LastName='Test1',Party_Id__c='102059');
        insert orderHubCnt;    
        
        Product2 pi = new product2(Name ='xy',IsActive = true,ISBN__c='9875628223'); 
        insert pi; 
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry PricebookEntry1 = new PricebookEntry(Pricebook2Id = pricebookId ,Product2Id = pi.Id , UnitPrice=1000 ,isActive = true);
        insert PricebookEntry1; 
        Product2 pi1 = new product2(Name ='xy',IsActive = true,ISBN__c='9875628223'); 
        insert pi1; 
        PricebookEntry PricebookEntry2 = new PricebookEntry(Pricebook2Id = pricebookId ,Product2Id = pi1.Id , UnitPrice=1000 ,isActive = true);
        insert PricebookEntry2; 
        
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
        Setting_Item__c settingItemOrderApiChannelASC = new Setting_Item__c(Text_1__c='ASC',Setting__c=settingOrderApiChannel.id, Checkbox_3__c=false);
        insert settingItemOrderApiChannelASC;       
        Setting_Item__c settingItemOrderApiChannelGOBI = new Setting_Item__c(Text_1__c='GOBI',Setting__c=settingOrderApiChannel.id, Checkbox_3__c=false);
        insert settingItemOrderApiChannelGOBI;
        Setting_Item__c settingItemOrderApiChannelUBX = new Setting_Item__c(Text_1__c='UBX',Setting__c=settingOrderApiChannel.id, Checkbox_3__c=false);
        insert settingItemOrderApiChannelUBX;
        Setting_Item__c settingItemOrderApiChannelOA_EBK_CHARGES = new Setting_Item__c(Text_1__c='OA_EBK_CHARGES',Setting__c=settingOrderApiChannel.id, Checkbox_3__c=false);
        insert settingItemOrderApiChannelOA_EBK_CHARGES; 
        
        SAP_BP__c sapObject = new SAP_BP__c(Account_Id__c = orderHubAcc.Id,First_Name__c = 'test_first_name',Last_Name__c = 'test_last_name',Email__c = 'test@gmail.com',Name = 'PENDING',Street__c = 'Test Street',Region__c = 'Test_Region',Address_Type__c = 'Account Mailing',State__c = 'test state',Country__c = 'test',City__c = 'test city',Status__c = true);
        insert sapObject;
        
        Opportunity  op = new Opportunity();
        op.Name = 'test';
        op.CloseDate= System.today();
        op.Description = 'test test test';
        op.StageName = 'Open';
        op.Pricebook2Id =pricebookId;
        op.AccountId = orderHubAcc.Id;
        op.Bill_to_BP__c = sapObject.id;
        op.Account_Validate_Opp__c = true;
        insert op;
        
        OpportunityLineItem oppLine = new OpportunityLineItem();
        oppLine.Pcm_ISBN__c = '9780367076016';
        oppLine.OpportunityId = op.id;
        oppLine.PricebookEntryId = PricebookEntry1.id;
        insert oppLine;
        
        Id quoteRecordtypeId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'T&F - BPC Quote Type');
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Opportunity2__c = op.Id,SBQQ__BillingCity__c = 'test Billing',SBQQ__Account__c = orderHubAcc.Id, Payer_Account__c = orderHubAcc.Id, SBQQ__ExpirationDate__c = System.today() + 60, SBQQ__Status__c = 'Accepted', SBQQ__Primary__c=true,Quote_Type__c = 'Direct Sale', RecordTypeId = quoteRecordtypeId); 
        insert quoteObject;
        
        Order order_Record = new Order();
        order_Record.OpportunityId = op.id;
        order_Record.Pricebook2Id = Test.getStandardPricebookId();
        order_Record.AccountId = orderHubAcc.id;
        order_Record.EffectiveDate = Date.newInstance(2019, 12, 9);
        order_Record.Status = 'Draft';
        order_Record.OrderReferenceNumber = 'ODR830008';
        insert order_Record;
        
        OrderItem orderProduct1 = new OrderItem();
        orderProduct1.OrderId = order_Record.id;
        orderProduct1.Quantity = 1;
        orderProduct1.UnitPrice = 20;
        orderProduct1.PricebookEntryId = PricebookEntry1.id;
        orderProduct1.PCM_ISBN__c = '9780429053528';
        orderProduct1.PCM_UUID__c = '1';
        insert orderProduct1;
        
        OrderItem orderProduct2 = new OrderItem();
        orderProduct2.OrderId = order_Record.id;
        orderProduct2.Quantity = 1;
        orderProduct2.UnitPrice = 20;
        orderProduct2.PricebookEntryId = PricebookEntry2.id;
        orderProduct2.PCM_ISBN__c = '9780367076016';
        orderProduct2.PCM_UUID__c = '2';
        insert orderProduct2;
        
    }
    
    @isTest
    private static void orderSyncTest1(){          
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        Product2 pi = [select id,ISBN__c,IsActive from Product2 Limit 1];
        SBQQ__Quote__c quote = [SELECT Id, Name, RecordTypeID FROM SBQQ__Quote__c Limit 1];
        Account acc = [Select id, Customer_Id__c, Name from Account where Name='test' Limit 1];
        opportunity op =[Select id, SBQQ__PrimaryQuote__c from opportunity Limit 1];
        string jsonString = '{ "totalDiscountAmount":0.00, "originalOrderRef":null, "cancelReason":null, "withholdInvoice":false, "paymentTerm":null, "royaltyNotified":null, "requestInfo":"", "sponsors":[ { "refId":1, "fundingStatement":null, "details":{ "sfCustomerId":"98422", "orcidId":null, "name":null, "externalRefId":null, "awardType":null, "awardId":null }, "license":{ "description":"ABC Test", "type":"open-access", "location":"http://creativecommons.org/licenses/by/4.0/" } } ], "id":830009, "orderType":"SALES", "channel":"OA_EBK_CHARGES", "externalOrderRef":"00031753", "externalSystemRefId":"'+op.id+'", "notes":null, "quoteNumber":"'+quote.Name+'", "orderNumber":"ODR830009", "confirmationNumber":31753, "customerId":"98422", "buyerId":"98422", "discount":0.00, "discountCode":null, "discountCurrency":null, "discountAmount":0.00, "orderDate":"2020-12-18", "orderPrice":3250.00, "orderStatus":"OPEN", "invoices":[ { "invoiceLineItems":[ { "orderItemId":7594991, "quantity":1, "productId":"9780429053528", "itemNumber":"000010" }, { "orderItemId":7594992, "quantity":1, "productId":"9780367076016", "itemNumber":"000020" } ], "invoiceType":"INVOICE", "originalInvoiceRef":null, "salesOrderNumber":null, "invoicePaymentPastDue":false, "id":835392, "externalInvoiceRef":null, "freightCharge":0.00, "freightTax":0.00, "currency":"USD", "paymentStatus":"PENDING", "paymentDueDate":null, "paymentTerm":null, "paymentUrl":null, "salesOrg":"IN01", "readyForDownload":null, "payments":[ ], "paymentAcknowledgementDate":null } ], "seller":"TANDF", "billingAddress":{ "id":834139, "addressLine1":"BUCKLEY BUILDING", "addressLine2":null, "addressLine3":null, "addressCountry":"United Kingdom", "addressLocality":"OXFORD", "addressRegion":"Oxfordshire", "addressContactName":"Matthew Wilks", "addressContactEmail":"10007283@brookes.ac.uk", "addressOrganisation":null, "postalCode":"OX30BP", "streetAddress":null, "businessPartnerNo":"0004398749", "countryCode":"GB", "telephoneNo":null, "externalCustomerAddressId":null, "addressType":null, "houseNumber":null, "taxRegistrationNumber":null, "taxCategory":null, "addressContactFirstName":null, "addressContactLastName":null, "department":null, "careOf":null }, "shippingAddress":{ "id":834140, "addressLine1":"BUCKLEY BUILDING", "addressLine2":null, "addressLine3":null, "addressCountry":"United Kingdom", "addressLocality":"OXFORD", "addressRegion":"Oxfordshire", "addressContactName":"Matthew Wilks", "addressContactEmail":"10007283@brookes.ac.uk", "addressOrganisation":null, "postalCode":"OX30BP", "streetAddress":null, "businessPartnerNo":"0004398749", "countryCode":"GB", "telephoneNo":null, "externalCustomerAddressId":null, "addressType":null, "houseNumber":null, "taxRegistrationNumber":null, "taxCategory":null, "addressContactFirstName":null, "addressContactLastName":null, "department":null, "careOf":null }, "fulfillments":[ ], "orderedItem":[ { "altProductId":"9780429053528", "sponsorRefId":[ 1 ], "id":7594991, "productId":"1", "price":1625.00, "sellingPrice":1625.00, "currency":"USD", "sellingCurrency":null, "quantity":1, "orderedQuantity":1, "lineItemType":"EBOOK", "salesType":"OA-FEE", "discount":0.00, "discountCode":null, "discountCurrency":"USD", "discountAmount":0.00, "taxCode":"ZMSC", "taxAmount":0.00, "description":null, "status":"NOT_FULFILLED", "salesOrg":null }, { "altProductId":"9780367076016", "sponsorRefId":[ 1 ], "id":7594992, "productId":"2", "price":1625.00, "sellingPrice":1625.00, "currency":"USD", "sellingCurrency":null, "quantity":1, "orderedQuantity":1, "lineItemType":"EBOOK", "salesType":"OA-FEE", "discount":0.00, "discountCode":null, "discountCurrency":"USD", "discountAmount":0.00, "taxCode":"ZMSC", "taxAmount":0.00, "description":null, "status":"NOT_FULFILLED", "salesOrg":null } ], "description":null, "docDate":null, "release":null, "webId":null, "shipCustId":null, "orderSource":null, "rateOfExchange":0.00, "subTotalPrice":3250.00, "totalTax":0.00, "paid":false, "fulfilled":false }';
        OrderAPI.OrderRequest request = (OrderAPI.OrderRequest)JSON.deserialize(jsonString, OrderAPI.OrderRequest.class);
        
        req.requestBody=Blob.valueOf(jsonString);
        RestContext.request = req;
        RestContext.response= res;  
        Test.startTest();
        OrderAPI_OaEbkChargesChannel_BpcFlow.salesforceOrderSyncOaEbkChargesChannel(request, jsonString, Test.getStandardPricebookId(), quote);
        Test.stopTest();   
    }   
    
    @isTest
    private static void orderSyncTest2(){          
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        Product2 pi = [select id,ISBN__c,IsActive from Product2 Limit 1];
        SBQQ__Quote__c quote = [SELECT Id, Name, RecordTypeID FROM SBQQ__Quote__c Limit 1];
        Account acc = [Select id, Customer_Id__c, Name from Account where Name='test' Limit 1];
        opportunity op =[Select id, SBQQ__PrimaryQuote__c from opportunity Limit 1];
        string jsonString = '{ "totalDiscountAmount":0.00, "originalOrderRef":"ODR830008", "cancelReason":null, "withholdInvoice":false, "paymentTerm":null, "royaltyNotified":null, "requestInfo":"", "sponsors":[ { "refId":1, "fundingStatement":null, "details":{ "sfCustomerId":"98422", "orcidId":null, "name":null, "externalRefId":null, "awardType":null, "awardId":null }, "license":{ "description":"ABC Test", "type":"open-access", "location":"http://creativecommons.org/licenses/by/4.0/" } } ], "id":830009, "orderType":"SALES", "channel":"OA_EBK_CHARGES", "externalOrderRef":"00031753", "externalSystemRefId":"'+op.id+'", "notes":null, "quoteNumber":"'+quote.Name+'", "orderNumber":"ODR830009", "confirmationNumber":31753, "customerId":"98422", "buyerId":"98422", "discount":0.00, "discountCode":null, "discountCurrency":null, "discountAmount":0.00, "orderDate":"2020-12-18", "orderPrice":3250.00, "orderStatus":"OPEN", "invoices":[ { "invoiceLineItems":[ { "orderItemId":7594991, "quantity":1, "productId":"9780429053528", "itemNumber":"000010" }, { "orderItemId":7594992, "quantity":1, "productId":"9780367076016", "itemNumber":"000020" } ], "invoiceType":"INVOICE", "originalInvoiceRef":null, "salesOrderNumber":null, "invoicePaymentPastDue":false, "id":835392, "externalInvoiceRef":null, "freightCharge":0.00, "freightTax":0.00, "currency":"USD", "paymentStatus":"PENDING", "paymentDueDate":null, "paymentTerm":null, "paymentUrl":null, "salesOrg":"IN01", "readyForDownload":null, "payments":[ ], "paymentAcknowledgementDate":null } ], "seller":"TANDF", "billingAddress":{ "id":834139, "addressLine1":"BUCKLEY BUILDING", "addressLine2":null, "addressLine3":null, "addressCountry":"United Kingdom", "addressLocality":"OXFORD", "addressRegion":"Oxfordshire", "addressContactName":"Matthew Wilks", "addressContactEmail":"10007283@brookes.ac.uk", "addressOrganisation":null, "postalCode":"OX30BP", "streetAddress":null, "businessPartnerNo":"0004398749", "countryCode":"GB", "telephoneNo":null, "externalCustomerAddressId":null, "addressType":null, "houseNumber":null, "taxRegistrationNumber":null, "taxCategory":null, "addressContactFirstName":null, "addressContactLastName":null, "department":null, "careOf":null }, "shippingAddress":{ "id":834140, "addressLine1":"BUCKLEY BUILDING", "addressLine2":null, "addressLine3":null, "addressCountry":"United Kingdom", "addressLocality":"OXFORD", "addressRegion":"Oxfordshire", "addressContactName":"Matthew Wilks", "addressContactEmail":"10007283@brookes.ac.uk", "addressOrganisation":null, "postalCode":"OX30BP", "streetAddress":null, "businessPartnerNo":"0004398749", "countryCode":"GB", "telephoneNo":null, "externalCustomerAddressId":null, "addressType":null, "houseNumber":null, "taxRegistrationNumber":null, "taxCategory":null, "addressContactFirstName":null, "addressContactLastName":null, "department":null, "careOf":null }, "fulfillments":[ ], "orderedItem":[ { "altProductId":"9780429053528", "sponsorRefId":[ 1 ], "id":7594991, "productId":"9780429053528", "price":1625.00, "sellingPrice":1625.00, "currency":"USD", "sellingCurrency":null, "quantity":1, "orderedQuantity":1, "lineItemType":"EBOOK", "salesType":"OA-FEE", "discount":0.00, "discountCode":null, "discountCurrency":"USD", "discountAmount":0.00, "taxCode":"ZMSC", "taxAmount":0.00, "description":null, "status":"NOT_FULFILLED", "salesOrg":null }, { "altProductId":"9780367076016", "sponsorRefId":[ 1 ], "id":7594992, "productId":"9780367076016", "price":1625.00, "sellingPrice":1625.00, "currency":"USD", "sellingCurrency":null, "quantity":1, "orderedQuantity":1, "lineItemType":"EBOOK", "salesType":"OA-FEE", "discount":0.00, "discountCode":null, "discountCurrency":"USD", "discountAmount":0.00, "taxCode":"ZMSC", "taxAmount":0.00, "description":null, "status":"NOT_FULFILLED", "salesOrg":null },{ "altProductId":"9780429053528", "sponsorRefId":[ 1 ], "id":7594991, "productId":"9780429053529", "price":1625.00, "sellingPrice":1625.00, "currency":"USD", "sellingCurrency":null, "quantity":1, "orderedQuantity":1, "lineItemType":"EBOOK", "salesType":"OA-FEE", "discount":0.00, "discountCode":null, "discountCurrency":"USD", "discountAmount":0.00, "taxCode":"ZMSC", "taxAmount":0.00, "description":null, "status":"NOT_FULFILLED", "salesOrg":null } ], "description":null, "docDate":null, "release":null, "webId":null, "shipCustId":null, "orderSource":null, "rateOfExchange":0.00, "subTotalPrice":3250.00, "totalTax":0.00, "paid":false, "fulfilled":false }';
        OrderAPI.OrderRequest request = (OrderAPI.OrderRequest)JSON.deserialize(jsonString, OrderAPI.OrderRequest.class);
        
        req.requestBody=Blob.valueOf(jsonString);
        RestContext.request = req;
        RestContext.response= res;  
        Test.startTest();
        OrderAPI_OaEbkChargesChannel_BpcFlow.salesforceOrderSyncOaEbkChargesChannel(request, jsonString, Test.getStandardPricebookId(), quote);
        Test.stopTest();   
    }
    
    @isTest
    private static void orderSyncTest3(){          
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        Product2 pi = [select id,ISBN__c,IsActive from Product2 Limit 1];
        SBQQ__Quote__c quote = [SELECT Id, Name, RecordTypeID FROM SBQQ__Quote__c Limit 1];
        Account acc = [Select id, Customer_Id__c, Name from Account where Name='test' Limit 1];
        opportunity op =[Select id, SBQQ__PrimaryQuote__c from opportunity Limit 1];
        string jsonString = '{ "totalDiscountAmount":0.00, "originalOrderRef":null, "cancelReason":null, "withholdInvoice":false, "paymentTerm":null, "royaltyNotified":null, "requestInfo":"", "sponsors":[ { "refId":1, "fundingStatement":null, "details":{ "sfCustomerId":"98422", "orcidId":null, "name":null, "externalRefId":null, "awardType":null, "awardId":null }, "license":{ "description":"ABC Test", "type":"open-access", "location":"http://creativecommons.org/licenses/by/4.0/" } } ], "id":830009, "orderType":"SALES", "channel":"XYZ", "externalOrderRef":"00031753", "externalSystemRefId":"'+op.id+'", "notes":null, "quoteNumber":"'+quote.Name+'", "orderNumber":"ODR830009", "confirmationNumber":31753, "customerId":"98422", "buyerId":"98422", "discount":0.00, "discountCode":null, "discountCurrency":null, "discountAmount":0.00, "orderDate":"2020-12-18", "orderPrice":3250.00, "orderStatus":"OPEN", "invoices":[ { "invoiceLineItems":[ { "orderItemId":7594991, "quantity":1, "productId":"9780429053528", "itemNumber":"000010" }, { "orderItemId":7594992, "quantity":1, "productId":"9780367076016", "itemNumber":"000020" } ], "invoiceType":"INVOICE", "originalInvoiceRef":null, "salesOrderNumber":null, "invoicePaymentPastDue":false, "id":835392, "externalInvoiceRef":null, "freightCharge":0.00, "freightTax":0.00, "currency":"USD", "paymentStatus":"PENDING", "paymentDueDate":null, "paymentTerm":null, "paymentUrl":null, "salesOrg":"IN01", "readyForDownload":null, "payments":[ ], "paymentAcknowledgementDate":null } ], "seller":"TANDF", "billingAddress":{ "id":834139, "addressLine1":"BUCKLEY BUILDING", "addressLine2":null, "addressLine3":null, "addressCountry":"United Kingdom", "addressLocality":"OXFORD", "addressRegion":"Oxfordshire", "addressContactName":"Matthew Wilks", "addressContactEmail":"10007283@brookes.ac.uk", "addressOrganisation":null, "postalCode":"OX30BP", "streetAddress":null, "businessPartnerNo":"0004398749", "countryCode":"GB", "telephoneNo":null, "externalCustomerAddressId":null, "addressType":null, "houseNumber":null, "taxRegistrationNumber":null, "taxCategory":null, "addressContactFirstName":null, "addressContactLastName":null, "department":null, "careOf":null }, "shippingAddress":{ "id":834140, "addressLine1":"BUCKLEY BUILDING", "addressLine2":null, "addressLine3":null, "addressCountry":"United Kingdom", "addressLocality":"OXFORD", "addressRegion":"Oxfordshire", "addressContactName":"Matthew Wilks", "addressContactEmail":"10007283@brookes.ac.uk", "addressOrganisation":null, "postalCode":"OX30BP", "streetAddress":null, "businessPartnerNo":"0004398749", "countryCode":"GB", "telephoneNo":null, "externalCustomerAddressId":null, "addressType":null, "houseNumber":null, "taxRegistrationNumber":null, "taxCategory":null, "addressContactFirstName":null, "addressContactLastName":null, "department":null, "careOf":null }, "fulfillments":[ ], "orderedItem":[ { "altProductId":"9780429053528", "sponsorRefId":[ 1 ], "id":7594991, "productId":"9780429053528", "price":1625.00, "sellingPrice":1625.00, "currency":"USD", "sellingCurrency":null, "quantity":1, "orderedQuantity":1, "lineItemType":"EBOOK", "salesType":"OA-FEE", "discount":0.00, "discountCode":null, "discountCurrency":"USD", "discountAmount":0.00, "taxCode":"ZMSC", "taxAmount":0.00, "description":null, "status":"NOT_FULFILLED", "salesOrg":null }, { "altProductId":"9780367076016", "sponsorRefId":[ 1 ], "id":7594992, "productId":"9780367076016", "price":1625.00, "sellingPrice":1625.00, "currency":"USD", "sellingCurrency":null, "quantity":1, "orderedQuantity":1, "lineItemType":"EBOOK", "salesType":"OA-FEE", "discount":0.00, "discountCode":null, "discountCurrency":"USD", "discountAmount":0.00, "taxCode":"ZMSC", "taxAmount":0.00, "description":null, "status":"NOT_FULFILLED", "salesOrg":null },{ "altProductId":"9780429053528", "sponsorRefId":[ 1 ], "id":7594991, "productId":"9780429053529", "price":1625.00, "sellingPrice":1625.00, "currency":"USD", "sellingCurrency":null, "quantity":1, "orderedQuantity":1, "lineItemType":"EBOOK", "salesType":"OA-FEE", "discount":0.00, "discountCode":null, "discountCurrency":"USD", "discountAmount":0.00, "taxCode":"ZMSC", "taxAmount":0.00, "description":null, "status":"NOT_FULFILLED", "salesOrg":null } ], "description":null, "docDate":null, "release":null, "webId":null, "shipCustId":null, "orderSource":null, "rateOfExchange":0.00, "subTotalPrice":3250.00, "totalTax":0.00, "paid":false, "fulfilled":false }';
        OrderAPI.OrderRequest request = (OrderAPI.OrderRequest)JSON.deserialize(jsonString, OrderAPI.OrderRequest.class);
        
        req.requestBody=Blob.valueOf(jsonString);
        RestContext.request = req;
        RestContext.response= res;  
        Test.startTest();
        OrderAPI_OaEbkChargesChannel_BpcFlow.salesforceOrderSyncOaEbkChargesChannel(request, jsonString, Test.getStandardPricebookId(), quote);
        Test.stopTest();   
    }
    
    @isTest
    private static void orderSyncTest4(){          
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        Product2 pi = [select id,ISBN__c,IsActive from Product2 Limit 1];
        SBQQ__Quote__c quote = [SELECT Id, Name, RecordTypeID FROM SBQQ__Quote__c Limit 1];
        Account acc = [Select id, Customer_Id__c, Name from Account where Name='test' Limit 1];
        opportunity op =[Select id, SBQQ__PrimaryQuote__c from opportunity Limit 1];
        string jsonString = '{ "totalDiscountAmount":0.00, "originalOrderRef":null, "cancelReason":null, "withholdInvoice":false, "paymentTerm":null, "royaltyNotified":null, "requestInfo":"", "sponsors":[ { "refId":1, "fundingStatement":null, "details":{ "sfCustomerId":"98422", "orcidId":null, "name":null, "externalRefId":null, "awardType":null, "awardId":null }, "license":{ "description":"ABC Test", "type":"open-access", "location":"http://creativecommons.org/licenses/by/4.0/" } } ], "id":830009, "orderType":"SALES", "channel":"OA_EBK_CHARGES", "externalOrderRef":"00031753", "externalSystemRefId":null, "notes":null, "quoteNumber":"'+quote.Name+'", "orderNumber":"ODR830009", "confirmationNumber":31753, "customerId":"98422", "buyerId":"98422", "discount":0.00, "discountCode":null, "discountCurrency":null, "discountAmount":0.00, "orderDate":"2020-12-18", "orderPrice":3250.00, "orderStatus":"OPEN", "invoices":[ { "invoiceLineItems":[ { "orderItemId":7594991, "quantity":1, "productId":"9780429053528", "itemNumber":"000010" }, { "orderItemId":7594992, "quantity":1, "productId":"9780367076016", "itemNumber":"000020" } ], "invoiceType":"INVOICE", "originalInvoiceRef":null, "salesOrderNumber":null, "invoicePaymentPastDue":false, "id":835392, "externalInvoiceRef":null, "freightCharge":0.00, "freightTax":0.00, "currency":"USD", "paymentStatus":"PENDING", "paymentDueDate":null, "paymentTerm":null, "paymentUrl":null, "salesOrg":"IN01", "readyForDownload":null, "payments":[ ], "paymentAcknowledgementDate":null } ], "seller":"TANDF", "billingAddress":{ "id":834139, "addressLine1":"BUCKLEY BUILDING", "addressLine2":null, "addressLine3":null, "addressCountry":"United Kingdom", "addressLocality":"OXFORD", "addressRegion":"Oxfordshire", "addressContactName":"Matthew Wilks", "addressContactEmail":"10007283@brookes.ac.uk", "addressOrganisation":null, "postalCode":"OX30BP", "streetAddress":null, "businessPartnerNo":"0004398749", "countryCode":"GB", "telephoneNo":null, "externalCustomerAddressId":null, "addressType":null, "houseNumber":null, "taxRegistrationNumber":null, "taxCategory":null, "addressContactFirstName":null, "addressContactLastName":null, "department":null, "careOf":null }, "shippingAddress":{ "id":834140, "addressLine1":"BUCKLEY BUILDING", "addressLine2":null, "addressLine3":null, "addressCountry":"United Kingdom", "addressLocality":"OXFORD", "addressRegion":"Oxfordshire", "addressContactName":"Matthew Wilks", "addressContactEmail":"10007283@brookes.ac.uk", "addressOrganisation":null, "postalCode":"OX30BP", "streetAddress":null, "businessPartnerNo":"0004398749", "countryCode":"GB", "telephoneNo":null, "externalCustomerAddressId":null, "addressType":null, "houseNumber":null, "taxRegistrationNumber":null, "taxCategory":null, "addressContactFirstName":null, "addressContactLastName":null, "department":null, "careOf":null }, "fulfillments":[ ], "orderedItem":[ { "altProductId":"9780429053528", "sponsorRefId":[ 1 ], "id":7594991, "productId":"9780429053528", "price":1625.00, "sellingPrice":1625.00, "currency":"USD", "sellingCurrency":null, "quantity":1, "orderedQuantity":1, "lineItemType":"EBOOK", "salesType":"OA-FEE", "discount":0.00, "discountCode":null, "discountCurrency":"USD", "discountAmount":0.00, "taxCode":"ZMSC", "taxAmount":0.00, "description":null, "status":"NOT_FULFILLED", "salesOrg":null }, { "altProductId":"9780367076016", "sponsorRefId":[ 1 ], "id":7594992, "productId":"9780367076016", "price":1625.00, "sellingPrice":1625.00, "currency":"USD", "sellingCurrency":null, "quantity":1, "orderedQuantity":1, "lineItemType":"EBOOK", "salesType":"OA-FEE", "discount":0.00, "discountCode":null, "discountCurrency":"USD", "discountAmount":0.00, "taxCode":"ZMSC", "taxAmount":0.00, "description":null, "status":"NOT_FULFILLED", "salesOrg":null },{ "altProductId":"9780429053528", "sponsorRefId":[ 1 ], "id":7594991, "productId":"9780429053529", "price":1625.00, "sellingPrice":1625.00, "currency":"USD", "sellingCurrency":null, "quantity":1, "orderedQuantity":1, "lineItemType":"EBOOK", "salesType":"OA-FEE", "discount":0.00, "discountCode":null, "discountCurrency":"USD", "discountAmount":0.00, "taxCode":"ZMSC", "taxAmount":0.00, "description":null, "status":"NOT_FULFILLED", "salesOrg":null } ], "description":null, "docDate":null, "release":null, "webId":null, "shipCustId":null, "orderSource":null, "rateOfExchange":0.00, "subTotalPrice":3250.00, "totalTax":0.00, "paid":false, "fulfilled":false }';
        OrderAPI.OrderRequest request = (OrderAPI.OrderRequest)JSON.deserialize(jsonString, OrderAPI.OrderRequest.class);
        
        req.requestBody=Blob.valueOf(jsonString);
        RestContext.request = req;
        RestContext.response= res;  
        Test.startTest();
        OrderAPI_OaEbkChargesChannel_BpcFlow.salesforceOrderSyncOaEbkChargesChannel(request, jsonString, Test.getStandardPricebookId(), quote);
        Test.stopTest();   
    }
    
}