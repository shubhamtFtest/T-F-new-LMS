/**
* Author : shashank
* Description : this class increses the code coverage of the class TF_OhIntSchduleChain and schjdulable and queuable class related to it.
* Changes : using TF_OhIntclneChain instead of TF_OrderHubIntclne
TODO:  more no. of invoices ,
*/

@isTest

global class zTestTF_OrderHubIntegrationSchduled {
    @TestSetup
    static void makeData(){
       
        // crearting an account
        Account acc = new account(name='acc test',Customer_ID__c  ='125',Shipping_Country_List__c='Test');
        insert acc;
        Account accSameCustId = new account(name='accSameCustId',Customer_ID__c  ='125',Shipping_Country_List__c='Test');
        insert accSameCustId;
        
        //creating custom object CountryWiseOppOwner__c
       
        insert new CountryWiseOppOwner__c(name='100',user__c='last',country__c='Test');
 //creating user Role
 //MIXED_DML_OPERATION
 MIXED_DML_OPERATION();
              String oppName = 'UBX self service eBooks – '+ String.valueOf(System.Today().year());
        Schema.DescribeSObjectResult oppSchema = Schema.SObjectType.Opportunity;
        Map<String,Schema.RecordTypeInfo> oppRecordTypeInfo = oppSchema.getRecordTypeInfosByName();
        // fetching recordtype of the opp "T&F eBooks Opportuniyty"
        Id opprtId = oppRecordTypeInfo.get('T&F - eBooks Opportunity').getRecordTypeId();
        // inserting the oppportunity with  required  field value
        Opportunity oppRec = new Opportunity();
        oppRec.RecordTypeId = opprtId;
        oppRec.Name = oppName;
        oppRec.AccountId = acc.Id;
        oppRec.CloseDate = system.today()+1;
        oppRec.StageName = 'Investigating';
        oppRec.Start_Date__c = system.today();
        oppRec.CurrencyIsoCode = 'USD';
        oppRec.ReVisit_Date__c = Date.today();
        insert oppRec;
        
    }
    @future
    public static void MIXED_DML_OPERATION(){
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
          
        //creating user
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = r.Id
        );
insert u;
    }
    @isTest
    static void orderHubIntegrationSchdupdate() {
        // the setting object to be used to error logging
        Setting__c settObj = new Setting__c(Name = 'OrderHubIntegrationErrorLogs');
        insert settObj;
        Setting__c settMapObj = new Setting__c(Name = 'OrderHubInt_SalesTypeToProductMapping');
        insert settMapObj;
        Setting_Item__c SettingItem = new Setting_Item__c(Checkbox_1__c = true, Text_1__c = 'UBX', Text_2__c ='01t0Y0000080nlpQAA', Setting__c =settMapObj.id);
        insert SettingItem;
        // crearting an account
        Account acc = [select id,Customer_ID__c from Account Limit 1 ];
        Opportunity oppRec = [select id from Opportunity Limit 1 ];
        
        List<OpportunityLineItem> listOpportunityLineItem = new List<OpportunityLineItem>();
        // inserting the opportunity line item , if the opportunity line item is present then it will update
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = oppRec.id;
        oli.Quantity = 1;
        oli.TotalPrice = 2;
        oli.PricebookEntryId = '01u0Y000008DO8KQAW';
        oli.Invoice_Number__c = 'invoiceNo';
        listOpportunityLineItem.add(oli);
        Database.SaveResult[] srList = Database.insert(listOpportunityLineItem, false);
        TF_OhIntclneChain TF_OhIntclneChainObject = new TF_OhIntclneChain();
        TF_OhIntclneChainObject.dataBaseSaveresult(srList,NULL,'oliINsert',listOpportunityLineItem);
        
        PricebookEntry pbe3 = new PricebookEntry(
            CurrencyIsoCode = 'USD',
            Pricebook2Id=Test.getStandardPricebookId(),
            Product2Id='01t0Y0000080nlpQAA',
            UnitPrice=0.00,
            IsActive=true
        );
        List<PricebookEntry> listPriceBok = new List<PricebookEntry>();
        Database.SaveResult srPb = Database.insert(pbe3, false);
        listPriceBok.add(pbe3);
        List<Database.SaveResult> listSaveRes = new List<Database.SaveResult>();
        listSaveRes.add(srPb);
        TF_OhIntclneChainObject.dataBaseSaveresult(listSaveRes,NULL,'PB insert',listPriceBok);
        
        Test.StartTest();
        TF_OhIntclneChain TF_OhIntclneChainObj = New TF_OhIntclneChain('UBX', '01t0Y0000080nlpQAA',0,6,false);
        Test.setMock(HttpCalloutMock.class, new TF_MockHttpRespCalloutGeneratorNew());
        TF_OhIntclneChainObj.execute();
        TF_OhIntclneChainObj.sendEmail(  'errorMessage', false,NULL  );
        
        //
        TF_OhIntSchduleChain reminder = new TF_OhIntSchduleChain();
        // Seconds Minutes Hours Day_of_month Month ?Day_of_week
        String sch = '36 6 8 8 5 ?';
        String jobID = System.schedule('uuubbbxx6', sch, reminder);
        //
        Test.stopTest();
        
    }
    
    @isTest
    static void orderHubIntegrationSchdOppInsert() {
        // the setting object to be used to error logging
        Setting__c settObj = new Setting__c(Name = 'OrderHubIntegrationErrorLogs');
        insert settObj;
        Setting__c settMapObj = new Setting__c(Name = 'OrderHubInt_SalesTypeToProductMapping');
        insert settMapObj;
        Setting_Item__c SettingItem = new Setting_Item__c(Checkbox_1__c = true, Text_1__c = 'UBX', Text_2__c ='01t0Y0000080nlpQAA', Setting__c =settMapObj.id);
        insert SettingItem;
        Setting_Item__c SettingItemALL = new Setting_Item__c(Checkbox_1__c = true, Text_1__c = 'ALL', Text_2__c ='', Setting__c =settMapObj.id);
        insert SettingItemALL;
        // crearting an account
        Account acc = new account(name='acc test',Customer_ID__c  ='125');
        insert acc;
        
        // for ocr but creating new contact is much better 
        // Contact con1 = new Contact();
        // con1.AccountId = acc.id;
        // con1.LastName = 'Turner';
        // con1.Email = 'econtent@ybp.com';
        // insert con1;
        
        
        Test.StartTest();
        TF_OhIntclneChain TF_OhIntclneChainObj = New TF_OhIntclneChain('UBX', '01t0Y0000080nlpQAA',0,6,true);
        Test.setMock(HttpCalloutMock.class, new TF_MockHttpRespCalloutGeneratorNew());
        TF_OhIntclneChainObj.execute();
        TF_OhIntclneChainObj.sendEmail(  'errorMessage', false,NULL  );
        Test.stopTest();
    }
    // down time
    @isTest
    static void oHA () {
        
        
    }
    
    
    
    @isTest
    static void orderHubIntegrationSchdprodIdBlank() {
        // the setting object to be used to error logging
        Setting__c settObj = new Setting__c(Name = 'OrderHubIntegrationErrorLogs');
        insert settObj;
        Setting__c settMapObj = new Setting__c(Name = 'OrderHubInt_SalesTypeToProductMapping');
        insert settMapObj;
        Setting_Item__c SettingItem = new Setting_Item__c(Checkbox_1__c = true, Text_1__c = 'UBX', Text_2__c ='', Setting__c =settMapObj.id);
        insert SettingItem;
        // crearting an account
        Account acc = new account(name='acc test',Customer_ID__c  ='125');
        insert acc;
        
        Test.StartTest();
        TF_OhIntclneChain TF_OhIntclneChainObj = New TF_OhIntclneChain('GOBI', '',0,6,true);
        Test.setMock(HttpCalloutMock.class, new TF_MockHttpRespCalloutGeneratorNew());
        TF_OhIntclneChainObj.execute();
        
        // downtime
        
        Test.stopTest();
    }
    
    @isTest
    static void orderHubIntRandomMethod() {
        
        Test.StartTest();
        
        
        Test.setMock(HttpCalloutMock.class, new TF_MockHttpRespCalloutGeneratorNew());
        TF_MockHttpRespCalloutGeneratorNew obj = new TF_MockHttpRespCalloutGeneratorNew();
        TF_OrderHubIntJSONResp tF_OrderHubIntJSONRespObj =(TF_OrderHubIntJSONResp) System.JSON.deserialize(obj.jsonStr.replace('"currency":','"currencyy":'), TF_OrderHubIntJSONResp.class);
        Opportunity oppRec = [select id from Opportunity Limit 1 ];
        TF_OhIntclneChain TF_OhIntclneChainObj = new TF_OhIntclneChain();
        OpportunityLineItem OpportunityLineItemObj = TF_OhIntclneChainObj.newOli(false, NULL,tF_OrderHubIntJSONRespObj.paginatedOrderResult.data[0], 'invoiceNo', oppRec.Id, '01u0Y000008DO8KQAW' );
        
        // downtime
        tF_OrderHubIntJSONRespObj =(TF_OrderHubIntJSONResp) System.JSON.deserialize(obj.jsonStr.replace('"currency":','"currencyy":'), TF_OrderHubIntJSONResp.class);
        
        TF_OrderHubPlatformExecutor TF_UbxPlatformExecutorObj = new TF_OrderHubPlatformExecutor();
        
        ///**/
        
        
        //  json class
        System.debug('TF_OrderHubIntJSONRespObj-'+TF_OrderHubIntJSONRespObj);
        TF_OrderHubIntJSONResp.paginatedOrderResult paginatedOrderResultobj = TF_OrderHubIntJSONRespObj.paginatedOrderResult;
        list<TF_OrderHubIntJSONResp.data> data = paginatedOrderResultobj.data;
        TF_OrderHubIntJSONResp.data dataObj = data.get(0);
        String seller = dataObj.seller;
        Decimal discountAmount = dataObj.discountAmount;
        String discountCurrency =  String.valueOf(dataObj.orderPrice) +String.valueOf(dataObj.release) + String.valueOf(dataObj.discount) + dataObj.confirmationNumber  + dataObj.discountCurrency + dataObj.orderDate + dataObj.discountCode + dataObj.orderStatus  + dataObj.buyerId + dataObj.customerId  + dataObj.description + dataObj.orderNumber  + dataObj.docDate  + dataObj.quoteNumber  + dataObj.notes + dataObj.webId + dataObj.opportunityId + dataObj.shipCustId + dataObj.externalOrderRef + dataObj.orderSource + dataObj.channel + dataObj.orderType  + dataObj.id;
        TF_OrderHubIntJSONResp.invoices invoiceObj = dataObj.invoices.get(0);
        string currencyy = invoiceObj.currencyy + invoiceObj.broker +String.valueOf(invoiceObj.freightCharge) + invoiceObj.externalInvoiceRef  + String.valueOf(invoiceObj.freightTax) + invoiceObj.id     +String.valueOf(invoiceObj.invoicePaymentPastDue)+String.valueOf(invoiceObj.paymentStatus)+String.valueOf(invoiceObj.paymentDueDate)+String.valueOf(invoiceObj.paymentUrl)+String.valueOf(invoiceObj.paymentTerm);
        // TF_OrderHubIntJSONResp.payments paymentsObj = (TF_OrderHubIntJSONResp.payments) dataObj.invoices.get(0).payments.get(0);
        // String pa = String.valueOf(paymentsObj.paymentAmount) + paymentsObj.id + paymentsObj.paymentMethod + paymentsObj.paymentDescription+ paymentsObj.paymentType+ paymentsObj.cardType+ paymentsObj.mcasId+ paymentsObj.authDate;
        
        TF_OrderHubIntJSONResp.invoiceLineItems invoiceLineItemsObj = dataObj.invoices.get(0).invoiceLineItems.get(0);
        String paq = String.valueOf(invoiceLineItemsObj.quantity) + invoiceLineItemsObj.productId + invoiceLineItemsObj.orderItemId;
        
        TF_OrderHubIntJSONResp.orderedItem orderedItemObj = dataObj.orderedItem.get(0);
        String str = orderedItemObj.currencyy + orderedItemObj.productId + orderedItemObj.sellingCurrency + orderedItemObj.id + orderedItemObj.lineItemType + orderedItemObj.discountCurrency + orderedItemObj.discountCode  + orderedItemObj.taxCode + orderedItemObj.description + String.valueOf(orderedItemObj.orderedQuantity)  + String.valueOf(orderedItemObj.sellingPrice)  + String.valueOf(orderedItemObj.price)  + String.valueOf(orderedItemObj.quantity)  + String.valueOf(orderedItemObj.discountAmount)  + String.valueOf(orderedItemObj.discount)  + String.valueOf(orderedItemObj.taxAmount) + String.valueOf(orderedItemObj.status);
        TF_OrderHubIntJSONResp.fulfillments fulfillmentObj =  dataObj.fulfillments[0];
        String fulfillmentObjStr =  fulfillmentObj.termStartDate + fulfillmentObj.termEndDate + fulfillmentObj.licenseType + fulfillmentObj.bundle + fulfillmentObj.description + fulfillmentObj.printOnDemand  + fulfillmentObj.name + fulfillmentObj.catalogueNumber  + fulfillmentObj.id;
        TF_OrderHubIntJSONResp.billingAddress billingAddressobj = dataObj.billingAddress;
        string billingAddressobjStr = billingAddressobj.telephoneNo + billingAddressobj.addressRegion + billingAddressobj.addressContactName + billingAddressobj.addressLocality + billingAddressobj.addressContactEmail + billingAddressobj.addressCountry + billingAddressobj.addressOrganisation + billingAddressobj.addressLine3 + billingAddressobj.postalCode + billingAddressobj.addressLine2 + billingAddressobj.streetAddress + billingAddressobj.addressLine1 + billingAddressobj.businessPartnerNo + billingAddressobj.countryCode + billingAddressobj.id;
        TF_OrderHubIntJSONResp.shippingAddress shippingAddressobj = dataObj.shippingAddress;
        string shippingAddressobjStr = shippingAddressobj.telephoneNo + shippingAddressobj.addressRegion + shippingAddressobj.addressContactName + shippingAddressobj.addressLocality + shippingAddressobj.addressContactEmail + shippingAddressobj.addressCountry + shippingAddressobj.addressOrganisation + shippingAddressobj.addressLine3 + shippingAddressobj.postalCode + shippingAddressobj.addressLine2 + shippingAddressobj.streetAddress + shippingAddressobj.addressLine1 + shippingAddressobj.businessPartnerNo + shippingAddressobj.countryCode + shippingAddressobj.id + shippingAddressobj.externalCustomerAddressId + shippingAddressobj.addressType+ shippingAddressobj.houseNumber+ shippingAddressobj.taxRegistrationNumber+ shippingAddressobj.taxCategory;
        
        
        //* for All condition in mapping */
        Setting__c settObj = new Setting__c(Name = 'OrderHubIntegrationErrorLogs');
        insert settObj;
        Setting__c settMapObj = new Setting__c(Name = 'OrderHubInt_SalesTypeToProductMapping');
        insert settMapObj;
        Setting_Item__c SettingItem = new Setting_Item__c(Checkbox_1__c = true, Text_1__c = 'UBX', Text_2__c ='01t0Y0000080nlpQAA', Setting__c =settMapObj.id);
        insert SettingItem;
        Setting_Item__c SettingItemALL = new Setting_Item__c(Checkbox_1__c = true, Text_1__c = 'ALL', Text_2__c ='', Setting__c =settMapObj.id);
        insert SettingItemALL;
        
        TF_OhIntSchduleChain reminder = new TF_OhIntSchduleChain();
        // Seconds Minutes Hours Day_of_month Month ?Day_of_week
        String sch = '36 6 8 8 5 ?';
        String jobID = System.schedule('OH 2', sch, reminder);
        
        
        // TF_OhIntQueueableChain coverage
        TF_OhOrderTypeSpecSchdlChain TF_OhOrderTypeSpecSchdlChainOBJ = new TF_OhOrderTypeSpecSchdlChain('','');
        // Seconds Minutes Hours Day_of_month Month ?Day_of_week
        String schqueable = '36 6 8 8 5 ?';
        String jobIDQuable = System.schedule('OH 3', schqueable, TF_OhOrderTypeSpecSchdlChainOBJ);
        
        Test.stopTest();
        
    }
    
    global class TF_MockHttpRespCalloutGeneratorNew implements HttpCalloutMock {
        // Implement this interface method
        
        String jsonStr = '{'+
            '    \"metadata\": {'+
            '        \"message\": \"Orders retrieved\",'+
            '        \"code\": 200'+
            '    },'+
            '    \"paginatedOrderResult\": {'+
            '        \"data\": ['+
            '            {'+
            '                \"id\": 975272,'+
            '                \"orderType\": \"SALES\",'+
            '                \"channel\": \"GOBI\",'+
            '                \"externalOrderRef\": \"TAF0000000019\",'+
            '                \"opportunityId\": null,'+
            '                \"notes\": null,'+
            '                \"quoteNumber\": null,'+
            '                \"orderNumber\": \"ODR975272\",'+
            '                \"confirmationNumber\": null,'+
            '                \"customerId\": \"125\",'+
            '                \"buyerId\": \"2924954\",'+
            '                \"discount\": null,'+
            '                \"discountCode\": null,'+
            '                \"discountCurrency\": null,'+
            '                \"discountAmount\": null,'+
            '                \"orderDate\": \"2019-06-14\",'+
            '                \"orderPrice\": 0,'+
            '                \"orderStatus\": \"OPEN\",'+
            '                \"invoices\": ['+
            '                    {'+
            '                        \"invoiceLineItems\": ['+
            '                            {'+
            '                                \"orderItemId\": 3894097,'+
            '                                \"quantity\": 1,'+
            '                                \"productId\": \"KE59538\"'+
            '                            }'+
            '                        ],'+
            '                        \"invoicePaymentPastDue\": false,'+
            '                        \"id\": 971054,'+
            '                        \"externalInvoiceRef\": \"invoiceNo\",'+
            '                        \"broker\": \"GOBI\",'+
            '                        \"freightCharge\": null,'+
            '                        \"freightTax\": null,'+
            '                        \"currency\": \"USD\",'+
            '                        \"paymentStatus\": \"PENDING\",'+
            '                        \"paymentDueDate\": null,'+
            '                        \"paymentTerm\": null,'+
            '                        \"paymentUrl\": null,'+
            '                        \"payments\": ['+
            '                            {'+
            '                                \"id\": 1896,'+
            '                                \"paymentMethod\": \"CREDITCARD\",'+
            '                                \"paymentDescription\": null,'+
            '                                \"paymentType\": null,'+
            '                                \"paymentAmount\": 159.3,'+
            '                                \"cardType\": \"VISA\",'+
            '                                \"mcasId\": \"2022593\",'+
            '                                \"authDate\": \"2019-06-24T11:30:32.000+0000\"'+
            '                            }'+
            '                        ]'+
            '                    },'+
            '                    {'+
            '                        \"invoiceLineItems\": ['+
            '                            {'+
            '                                \"orderItemId\": 3894097,'+
            '                                \"quantity\": 1,'+
            '                                \"productId\": \"KE59538\"'+
            '                            }'+
            '                        ],'+
            '                        \"invoicePaymentPastDue\": false,'+
            '                        \"id\": 971054,'+
            '                        \"externalInvoiceRef\": \"KE59538\",'+
            '                        \"broker\": \"GOBI\",'+
            '                        \"freightCharge\": null,'+
            '                        \"freightTax\": null,'+
            '                        \"currency\": \"USD\",'+
            '                        \"paymentStatus\": \"PENDING\",'+
            '                        \"paymentDueDate\": null,'+
            '                        \"paymentTerm\": null,'+
            '                        \"paymentUrl\": null,'+
            '                        \"payments\": ['+
            '                            {'+
            '                                \"id\": 1896,'+
            '                                \"paymentMethod\": \"CREDITCARD\",'+
            '                                \"paymentDescription\": null,'+
            '                                \"paymentType\": null,'+
            '                                \"paymentAmount\": 159.3,'+
            '                                \"cardType\": \"VISA\",'+
            '                                \"mcasId\": \"2022593\",'+
            '                                \"authDate\": \"2019-06-24T11:30:32.000+0000\"'+
            '                            }'+
            '                        ]'+
            '                    }'+
            '                ],'+
            '                \"seller\": \"TANDF\",'+
            '                \"billingAddress\": {'+
            '                    \"id\": 972462,'+
            '                    \"addressLine1\": \"YBP Library Services\",'+
            '                    \"addressLine2\": \"999 Maple Street\",'+
            '                    \"addressLine3\": null,'+
            '                    \"addressCountry\": \"UNITED STATES OF AMERICA\",'+
            '                    \"addressLocality\": \"CONTOOCOOK\",'+
            '                    \"addressRegion\": \"NH\",'+
            '                    \"addressContactName\": \"YBP Library Services\",'+
            '                    \"addressContactEmail\": \"econtent@ybp.com\",'+
            '                    \"addressOrganisation\": null,'+
            '                    \"postalCode\": \"03229-3374\",'+
            '                    \"streetAddress\": null,'+
            '                    \"businessPartnerNo\": \"0003720341\",'+
            '                    \"countryCode\": \"US\",'+
            '                    \"telephoneNo\": null,'+
            '                    \"externalCustomerAddressId\": \"27443\",'+
            '                    \"addressType\": null,'+
            '                    \"houseNumber\": null,'+
            '                    \"taxRegistrationNumber\": null,'+
            '                    \"taxCategory\": null'+
            '                },'+
            '                \"shippingAddress\": {'+
            '                    \"id\": 972463,'+
            '                    \"addressLine1\": \"Taylor & Francis Group (CRC Press Main Office)\",'+
            '                    \"addressLine2\": \"Suite 300, 6000 Broken Sound Parkway, NW\",'+
            '                    \"addressLine3\": null,'+
            '                    \"addressCountry\": \"United States of America\",'+
            '                    \"addressLocality\": \"Boca Raton\",'+
            '                    \"addressRegion\": \"FL\",'+
            '                    \"addressContactName\": \"nullnull\",'+
            '                    \"addressContactEmail\": \"econtent@ybp.com\",'+
            '                    \"addressOrganisation\": null,'+
            '                    \"postalCode\": \"33487\",'+
            '                    \"streetAddress\": null,'+
            '                    \"businessPartnerNo\": \"0003810471\",'+
            '                    \"countryCode\": \"US\",'+
            '                    \"telephoneNo\": null,'+
            '                    \"externalCustomerAddressId\": \"34282\",'+
            '                    \"addressType\": null,'+
            '                    \"houseNumber\": null,'+
            '                    \"taxRegistrationNumber\": null,'+
            '                    \"taxCategory\": null'+
            '                },'+
            '                \"fulfillments\": ['+
            '                    {'+
            '                        \"fulfillmentLineItems\": [],'+
            '                        \"id\": 3518067,'+
            '                        \"name\": \"Gobi Order Fulfillment\",'+
            '                        \"description\": \"Gobi Order Fulfillment Description\",'+
            '                        \"licenseType\": \"perpetual\",'+
            '                        \"termStartDate\": null,'+
            '                        \"termEndDate\": null,'+
            '                        \"grantType\": ['+
            '                            \"viewOnline\",'+
            '                            \"download\"'+
            '                        ],'+
            '                        \"bundle\": null,'+
            '                        \"printOnDemand\": null,'+
            '                        \"catalogueNumber\": null,'+
            '                        \"shipmentStatus\": null,'+
            '                        \"status\": null'+
            '                    }'+
            '                ],'+
            '                \"orderedItem\": ['+
            '                    {'+
            '                        \"id\": 3894097,'+
            '                        \"productId\": \"KE59538\",'+
            '                        \"price\": 41.4585,'+
            '                        \"sellingPrice\": 41.4585,'+
            '                        \"currency\": \"USD\",'+
            '                        \"sellingCurrency\": \"USD\",'+
            '                        \"quantity\": 1,'+
            '                        \"orderedQuantity\": 1,'+
            '                        \"lineItemType\": \"Ebook\",'+
            '                        \"discount\": 17,'+
            '                        \"discountCode\": null,'+
            '                        \"discountCurrency\": null,'+
            '                        \"discountAmount\": 8.4915,'+
            '                        \"taxCode\": null,'+
            '                        \"taxAmount\": 0,'+
            '                        \"description\": null,'+
            '                        \"status\": null'+
            '                    }'+
            '                ],'+
            '                \"description\": null,'+
            '                \"docDate\": null,'+
            '                \"release\": null,'+
            '                \"webId\": null,'+
            '                \"shipCustId\": null,'+
            '                \"orderSource\": null,'+
            '                \"rateOfExchange\": null,'+
            '                \"subTotalPrice\": 0,'+
            '                \"totalTax\": 0'+
            '            },'+
            '            {'+
            '                \"id\": 975272,'+
            '                \"orderType\": \"SALES\",'+
            '                \"channel\": \"GOBI\",'+
            '                \"externalOrderRef\": \"TAF0000000019\",'+
            '                \"opportunityId\": null,'+
            '                \"notes\": null,'+
            '                \"quoteNumber\": null,'+
            '                \"orderNumber\": \"ODR975272\",'+
            '                \"confirmationNumber\": null,'+
            '                \"customerId\": \"11111\",'+
            '                \"buyerId\": \"2924954\",'+
            '                \"discount\": null,'+
            '                \"discountCode\": null,'+
            '                \"discountCurrency\": null,'+
            '                \"discountAmount\": null,'+
            '                \"orderDate\": \"2019-06-14\",'+
            '                \"orderPrice\": 0,'+
            '                \"orderStatus\": \"OPEN\",'+
            '                \"invoices\": ['+
            '                    {'+
            '                        \"invoiceLineItems\": ['+
            '                            {'+
            '                                \"orderItemId\": 3894097,'+
            '                                \"quantity\": 1,'+
            '                                \"productId\": \"KE59538\"'+
            '                            }'+
            '                        ],'+
            '                        \"invoicePaymentPastDue\": false,'+
            '                        \"id\": 971054,'+
            '                        \"externalInvoiceRef\": \"invoiceNo\",'+
            '                        \"broker\": \"GOBI\",'+
            '                        \"freightCharge\": null,'+
            '                        \"freightTax\": null,'+
            '                        \"currency\": \"USD\",'+
            '                        \"paymentStatus\": \"PENDING\",'+
            '                        \"paymentDueDate\": null,'+
            '                        \"paymentTerm\": null,'+
            '                        \"paymentUrl\": null,'+
            '                        \"payments\": ['+
            '                            {'+
            '                                \"id\": 1896,'+
            '                                \"paymentMethod\": \"CREDITCARD\",'+
            '                                \"paymentDescription\": null,'+
            '                                \"paymentType\": null,'+
            '                                \"paymentAmount\": 159.3,'+
            '                                \"cardType\": \"VISA\",'+
            '                                \"mcasId\": \"2022593\",'+
            '                                \"authDate\": \"2019-06-24T11:30:32.000+0000\"'+
            '                            }'+
            '                        ]'+
            '                    },'+
            '                    {'+
            '                        \"invoiceLineItems\": ['+
            '                            {'+
            '                                \"orderItemId\": 3894097,'+
            '                                \"quantity\": 1,'+
            '                                \"productId\": \"KE59538\"'+
            '                            }'+
            '                        ],'+
            '                        \"invoicePaymentPastDue\": false,'+
            '                        \"id\": 971054,'+
            '                        \"externalInvoiceRef\": \"KE59538\",'+
            '                        \"broker\": \"GOBI\",'+
            '                        \"freightCharge\": null,'+
            '                        \"freightTax\": null,'+
            '                        \"currency\": \"USD\",'+
            '                        \"paymentStatus\": \"PENDING\",'+
            '                        \"paymentDueDate\": null,'+
            '                        \"paymentTerm\": null,'+
            '                        \"paymentUrl\": null,'+
            '                        \"payments\": ['+
            '                            {'+
            '                                \"id\": 1896,'+
            '                                \"paymentMethod\": \"CREDITCARD\",'+
            '                                \"paymentDescription\": null,'+
            '                                \"paymentType\": null,'+
            '                                \"paymentAmount\": 159.3,'+
            '                                \"cardType\": \"VISA\",'+
            '                                \"mcasId\": \"2022593\",'+
            '                                \"authDate\": \"2019-06-24T11:30:32.000+0000\"'+
            '                            }'+
            '                        ]'+
            '                    }'+
            '                ],'+
            '                \"seller\": \"TANDF\",'+
            '                \"billingAddress\": {'+
            '                    \"id\": 972462,'+
            '                    \"addressLine1\": \"YBP Library Services\",'+
            '                    \"addressLine2\": \"999 Maple Street\",'+
            '                    \"addressLine3\": null,'+
            '                    \"addressCountry\": \"UNITED STATES OF AMERICA\",'+
            '                    \"addressLocality\": \"CONTOOCOOK\",'+
            '                    \"addressRegion\": \"NH\",'+
            '                    \"addressContactName\": \"YBP Library Services\",'+
            '                    \"addressContactEmail\": \"econtent@ybp.com\",'+
            '                    \"addressOrganisation\": null,'+
            '                    \"postalCode\": \"03229-3374\",'+
            '                    \"streetAddress\": null,'+
            '                    \"businessPartnerNo\": \"0003720341\",'+
            '                    \"countryCode\": \"US\",'+
            '                    \"telephoneNo\": null,'+
            '                    \"externalCustomerAddressId\": \"27443\",'+
            '                    \"addressType\": null,'+
            '                    \"houseNumber\": null,'+
            '                    \"taxRegistrationNumber\": null,'+
            '                    \"taxCategory\": null'+
            '                },'+
            '                \"shippingAddress\": {'+
            '                    \"id\": 972463,'+
            '                    \"addressLine1\": \"Taylor & Francis Group (CRC Press Main Office)\",'+
            '                    \"addressLine2\": \"Suite 300, 6000 Broken Sound Parkway, NW\",'+
            '                    \"addressLine3\": null,'+
            '                    \"addressCountry\": \"United States of America\",'+
            '                    \"addressLocality\": \"Boca Raton\",'+
            '                    \"addressRegion\": \"FL\",'+
            '                    \"addressContactName\": \"nullnull\",'+
            '                    \"addressContactEmail\": \"econtent@ybp.com\",'+
            '                    \"addressOrganisation\": null,'+
            '                    \"postalCode\": \"33487\",'+
            '                    \"streetAddress\": null,'+
            '                    \"businessPartnerNo\": \"0003810471\",'+
            '                    \"countryCode\": \"US\",'+
            '                    \"telephoneNo\": null,'+
            '                    \"externalCustomerAddressId\": \"34282\",'+
            '                    \"addressType\": null,'+
            '                    \"houseNumber\": null,'+
            '                    \"taxRegistrationNumber\": null,'+
            '                    \"taxCategory\": null'+
            '                },'+
            '                \"fulfillments\": ['+
            '                    {'+
            '                        \"fulfillmentLineItems\": [],'+
            '                        \"id\": 3518067,'+
            '                        \"name\": \"Gobi Order Fulfillment\",'+
            '                        \"description\": \"Gobi Order Fulfillment Description\",'+
            '                        \"licenseType\": \"perpetual\",'+
            '                        \"termStartDate\": null,'+
            '                        \"termEndDate\": null,'+
            '                        \"grantType\": ['+
            '                            \"viewOnline\",'+
            '                            \"download\"'+
            '                        ],'+
            '                        \"bundle\": null,'+
            '                        \"printOnDemand\": null,'+
            '                        \"catalogueNumber\": null,'+
            '                        \"shipmentStatus\": null,'+
            '                        \"status\": null'+
            '                    }'+
            '                ],'+
            '                \"orderedItem\": ['+
            '                    {'+
            '                        \"id\": 3894097,'+
            '                        \"productId\": \"KE59538\",'+
            '                        \"price\": 41.4585,'+
            '                        \"sellingPrice\": 41.4585,'+
            '                        \"currency\": \"USD\",'+
            '                        \"sellingCurrency\": \"USD\",'+
            '                        \"quantity\": 1,'+
            '                        \"orderedQuantity\": 1,'+
            '                        \"lineItemType\": \"Ebook\",'+
            '                        \"discount\": 17,'+
            '                        \"discountCode\": null,'+
            '                        \"discountCurrency\": null,'+
            '                        \"discountAmount\": 8.4915,'+
            '                        \"taxCode\": null,'+
            '                        \"taxAmount\": 0,'+
            '                        \"description\": null,'+
            '                        \"status\": null'+
            '                    }'+
            '                ],'+
            '                \"description\": null,'+
            '                \"docDate\": null,'+
            '                \"release\": null,'+
            '                \"webId\": null,'+
            '                \"shipCustId\": null,'+
            '                \"orderSource\": null,'+
            '                \"rateOfExchange\": null,'+
            '                \"subTotalPrice\": 0,'+
            '                \"totalTax\": 0'+
            '            }'+
            '        ],'+
            '        \"totalCount\": 115'+
            '    }'+
            '}';
        global HTTPResponse respond(HTTPRequest req) {
            
            // Create a fake response  orderedItem
            HttpResponse res = new HttpResponse();
            //res.setHeader('Content-Type', 'application/json');
            res.setHeader('total_pages', '6');
            res.setBody(jsonStr);
            res.setStatusCode(200);
            res.setStatus('Ok');
            return res;
        }
    }
}