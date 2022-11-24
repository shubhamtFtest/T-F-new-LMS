/** Created By: Piyush Jain
    Class: OrderHubCustomerDetailCancelCntrl
	Modified By: shalini Singh(13-07-2021) to show credit Note story(ticket SAL-3501)
**/
@isTest
global class OrderHubCustomerDetailCancelCntrl_Test {
    private static String orderHubURI = '/v1/orders/';
    private static String fetchSpecificOrderURI = '/v1/orders/';
    private static String createOrderURI = orderHubURI;
    
    @testSetup
    static void setupdata(){
        Account acc = new Account(Name = 'Test1', Customer_ID__c='1');
        insert acc;
        
        Setting__c settingObj = new Setting__c(Name = 'Order Detail Page Mapping' );
        insert settingObj;
        Setting_Item__c setting_ItemObj = new Setting_Item__c(Setting__c = settingObj.id ,Checkbox_2__c = true, Checkbox_4__c = true, Checkbox_1__c = true, Text_1__c ='UBX' ); 
        insert setting_ItemObj;
        
        Setting__c creditNoteSettingObj = new Setting__c(Name='Show Credit Note Process Error Logs');
        insert creditNoteSettingObj;
    }
    
    @isTest static void SearchDBTest(){	
        
        //public static String searchDB(String objectName, String fld_API_Text, String fld_API_Val,  Integer lim,String fld_API_Search,String searchText ){
        OrderHubCustomerDetailCancelCntrl.searchDB('Account','Name','Phone',1,'Name','Test');
    }
    @isTest static void getOrdersForCustomerTest(){
        account acc = [select id from account limit 1];
        Test.setMock(HttpCalloutMock.class, new TF_MockHttpRespCalloutGeneratorNew());
        Test.startTest();
        
        //  json class
        TF_OrderHubIntJSONResp TF_OrderHubIntJSONRespObj= OrderHubCustomerDetailCancelCntrl.getOrdersForCustomer(acc.id,'UBX','1','1');
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
        //  json class
        Test.stopTest();
    }
    
    
    @isTest static void getSingleOrderForCustomerTest(){
        account acc = [select id from account limit 1];
        Test.setMock(HttpCalloutMock.class, new TF_MockHttpRespCalloutGenerator());
        
        Test.startTest();
        OrderHubCustomerDetailCancelCntrl.getSalesType();
        orderCancelJSONResp JsonResponse =OrderHubCustomerDetailCancelCntrl.getSingleOrderForCustomer('ODR829240','1','1');
        orderCancelJSONResp.metadata metaObj  = JsonResponse.metadata;
        String meta = String.valueOf(metaObj.code ) + String.valueOf(metaObj.totalPagesize ) +  metaObj.message;
        orderCancelJSONResp.order dataObj =JsonResponse.order; // it's order
        system.debug('dataObj-'+dataObj);
        String seller = dataObj.seller;
        Decimal discountAmount = dataObj.discountAmount;
        String discountCurrency =  String.valueOf(dataObj.orderPrice) +String.valueOf(dataObj.release) + String.valueOf(dataObj.discount) + dataObj.confirmationNumber  + dataObj.discountCurrency + dataObj.orderDate + dataObj.discountCode + dataObj.orderStatus  + dataObj.buyerId + dataObj.customerId  + dataObj.description + dataObj.orderNumber  + dataObj.docDate  + dataObj.quoteNumber  + dataObj.notes + dataObj.webId + dataObj.opportunityId + dataObj.shipCustId + dataObj.externalOrderRef + dataObj.orderSource + dataObj.channel + dataObj.orderType  + dataObj.id;
        orderCancelJSONResp.invoices invoiceObj = dataObj.invoices[0];
        
        string currencyy = invoiceObj.currencyy + invoiceObj.broker +String.valueOf(invoiceObj.freightCharge) + invoiceObj.externalInvoiceRef  + String.valueOf(invoiceObj.freightTax) + invoiceObj.id + invoiceObj.paymentStatus + invoiceObj.paymentDueDate + invoiceObj.paymentUrl +invoiceObj.paymentTerm + String.valueOf(invoiceObj.invoicePaymentPastDue);
        orderCancelJSONResp.invoiceLineItems invoiOli = invoiceObj.invoiceLineItems[0];
        String invOliStr = invoiOli.productId + invoiOli.orderItemId + String.valueOf(invoiOli.quantity);
        
        // TF_SingleOrderDetailJsonResponse.payments payObj =   invoiceObj.payments[0];
        // String payStr = payObj.id  + payObj.paymentMethod  + payObj.paymentDescription   + payObj.paymentType   + payObj.cardType   + payObj.mcasId   + payObj.authDate   +  String.valueOf(payObj.paymentAmount);
        
        orderCancelJSONResp.billingAddress billingAddressobj = dataObj.billingAddress;
        string billingAddressobjStr = billingAddressobj.telephoneNo + billingAddressobj.addressRegion + billingAddressobj.addressContactName + billingAddressobj.addressLocality + billingAddressobj.addressContactEmail + billingAddressobj.addressCountry + billingAddressobj.addressOrganisation + billingAddressobj.addressLine3 + billingAddressobj.postalCode + billingAddressobj.addressLine2 + billingAddressobj.streetAddress + billingAddressobj.addressLine1 + billingAddressobj.businessPartnerNo + billingAddressobj.countryCode + billingAddressobj.id;
        
        orderCancelJSONResp.orderedItem orderedItemObj = dataObj.orderedItem.get(0);
        //String str = orderedItemObj.prodName + orderedItemObj.prodAuthor + orderedItemObj.versionType + orderedItemObj.currencyy + orderedItemObj.productId + orderedItemObj.sellingCurrency + orderedItemObj.id + orderedItemObj.lineItemType + orderedItemObj.discountCurrency + orderedItemObj.discountCode  + orderedItemObj.taxCode + orderedItemObj.description + String.valueOf(orderedItemObj.orderedQuantity)  + String.valueOf(orderedItemObj.sellingPrice)  + String.valueOf(orderedItemObj.price)  + String.valueOf(orderedItemObj.quantity)  + String.valueOf(orderedItemObj.discountAmount)  + String.valueOf(orderedItemObj.discount)  + String.valueOf(orderedItemObj.taxAmount);
        
        orderCancelJSONResp.fulfillments fulfillmentObj =  dataObj.fulfillments[0];
        String fulfillmentObjStr =  fulfillmentObj.termStartDate + fulfillmentObj.termEndDate + fulfillmentObj.licenseType + fulfillmentObj.bundle + fulfillmentObj.description + fulfillmentObj.printOnDemand  + fulfillmentObj.name + fulfillmentObj.catalogueNumber  + fulfillmentObj.id;
        
        orderCancelJSONResp.shippingAddress shippingAddressobj = dataObj.shippingAddress;
        string shippingAddressobjStr = shippingAddressobj.telephoneNo + shippingAddressobj.addressRegion + shippingAddressobj.addressContactName + shippingAddressobj.addressLocality + shippingAddressobj.addressContactEmail + shippingAddressobj.addressCountry + shippingAddressobj.addressOrganisation + shippingAddressobj.addressLine3 + shippingAddressobj.postalCode + shippingAddressobj.addressLine2 + shippingAddressobj.streetAddress + shippingAddressobj.addressLine1 + shippingAddressobj.businessPartnerNo + shippingAddressobj.countryCode + shippingAddressobj.id + shippingAddressobj.externalCustomerAddressId + shippingAddressobj.addressType+ shippingAddressobj.houseNumber+ shippingAddressobj.taxRegistrationNumber+ shippingAddressobj.taxCategory;
        Test.stopTest();
    }
    
    
    
    @isTest static void getfetchSpecificOrder(){
        String orderNum='89546';
        fetchSpecificOrderURI = fetchSpecificOrderURI  + orderNum;
        Map<String, String> headers = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        Account acc = new Account(Name = 'Test1');
        insert acc;
        
        Test.setMock(HttpCalloutMock.class, new TF_MockHttpRespCalloutGenerator());
        
        Test.startTest();
        TF_SingleOrderDetailJsonResponse JsonResponse =OrderHubCustomerDetailCancelCntrl.fetchSpecificOrder(orderNum, String.valueof(acc.id) );
        TF_SingleOrderDetailJsonResponse.metadata metaObj  = JsonResponse.metadata;
        String meta = String.valueOf(metaObj.code ) + String.valueOf(metaObj.totalPagesize ) +  metaObj.message;
        TF_SingleOrderDetailJsonResponse.order dataObj =JsonResponse.order; // it's order
        system.debug('dataObj-'+dataObj);
        String seller = dataObj.seller;
        Decimal discountAmount = dataObj.discountAmount;
        String discountCurrency =  String.valueOf(dataObj.orderPrice) +String.valueOf(dataObj.release) + String.valueOf(dataObj.discount) + dataObj.confirmationNumber  + dataObj.discountCurrency + dataObj.orderDate + dataObj.discountCode + dataObj.orderStatus  + dataObj.buyerId + dataObj.customerId  + dataObj.description + dataObj.orderNumber  + dataObj.docDate  + dataObj.quoteNumber  + dataObj.notes + dataObj.webId + dataObj.opportunityId + dataObj.shipCustId + dataObj.externalOrderRef + dataObj.orderSource + dataObj.channel + dataObj.orderType  + dataObj.id;
        TF_SingleOrderDetailJsonResponse.invoices invoiceObj = dataObj.invoices[0];
        
        string currencyy = invoiceObj.currencyy + invoiceObj.broker +String.valueOf(invoiceObj.freightCharge) + invoiceObj.externalInvoiceRef  + String.valueOf(invoiceObj.freightTax) + invoiceObj.id + invoiceObj.paymentStatus + invoiceObj.paymentDueDate + invoiceObj.paymentUrl +invoiceObj.paymentTerm + String.valueOf(invoiceObj.invoicePaymentPastDue);
        TF_SingleOrderDetailJsonResponse.invoiceLineItems invoiOli = invoiceObj.invoiceLineItems[0];
        String invOliStr = invoiOli.productId + invoiOli.orderItemId + String.valueOf(invoiOli.quantity);
        
        // TF_SingleOrderDetailJsonResponse.payments payObj =   invoiceObj.payments[0];
        // String payStr = payObj.id  + payObj.paymentMethod  + payObj.paymentDescription   + payObj.paymentType   + payObj.cardType   + payObj.mcasId   + payObj.authDate   +  String.valueOf(payObj.paymentAmount);
        
        TF_SingleOrderDetailJsonResponse.billingAddress billingAddressobj = dataObj.billingAddress;
        string billingAddressobjStr = billingAddressobj.telephoneNo + billingAddressobj.addressRegion + billingAddressobj.addressContactName + billingAddressobj.addressLocality + billingAddressobj.addressContactEmail + billingAddressobj.addressCountry + billingAddressobj.addressOrganisation + billingAddressobj.addressLine3 + billingAddressobj.postalCode + billingAddressobj.addressLine2 + billingAddressobj.streetAddress + billingAddressobj.addressLine1 + billingAddressobj.businessPartnerNo + billingAddressobj.countryCode + billingAddressobj.id;
        
        TF_SingleOrderDetailJsonResponse.orderedItem orderedItemObj = dataObj.orderedItem.get(0);
        String str = orderedItemObj.prodName + orderedItemObj.prodAuthor + orderedItemObj.versionType + orderedItemObj.currencyy + orderedItemObj.productId + orderedItemObj.sellingCurrency + orderedItemObj.id + orderedItemObj.lineItemType + orderedItemObj.discountCurrency + orderedItemObj.discountCode  + orderedItemObj.taxCode + orderedItemObj.description + String.valueOf(orderedItemObj.orderedQuantity)  + String.valueOf(orderedItemObj.sellingPrice)  + String.valueOf(orderedItemObj.price)  + String.valueOf(orderedItemObj.quantity)  + String.valueOf(orderedItemObj.discountAmount)  + String.valueOf(orderedItemObj.discount)  + String.valueOf(orderedItemObj.taxAmount);
        
        TF_SingleOrderDetailJsonResponse.fulfillments fulfillmentObj =  dataObj.fulfillments[0];
        String fulfillmentObjStr =  fulfillmentObj.termStartDate + fulfillmentObj.termEndDate + fulfillmentObj.licenseType + fulfillmentObj.bundle + fulfillmentObj.description + fulfillmentObj.printOnDemand  + fulfillmentObj.name + fulfillmentObj.catalogueNumber  + fulfillmentObj.id;
        
        TF_SingleOrderDetailJsonResponse.shippingAddress shippingAddressobj = dataObj.shippingAddress;
        string shippingAddressobjStr = shippingAddressobj.telephoneNo + shippingAddressobj.addressRegion + shippingAddressobj.addressContactName + shippingAddressobj.addressLocality + shippingAddressobj.addressContactEmail + shippingAddressobj.addressCountry + shippingAddressobj.addressOrganisation + shippingAddressobj.addressLine3 + shippingAddressobj.postalCode + shippingAddressobj.addressLine2 + shippingAddressobj.streetAddress + shippingAddressobj.addressLine1 + shippingAddressobj.businessPartnerNo + shippingAddressobj.countryCode + shippingAddressobj.id + shippingAddressobj.externalCustomerAddressId + shippingAddressobj.addressType+ shippingAddressobj.houseNumber+ shippingAddressobj.taxRegistrationNumber+ shippingAddressobj.taxCategory;
        Test.stopTest();
    }
    
    
    @isTest static void cancelSelectedOLIsTest(){
        String orderNum='89546';
        fetchSpecificOrderURI = fetchSpecificOrderURI  + orderNum;
        Map<String, String> headers = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        Account acc = new Account(Name = 'Test1');
        insert acc;
        
        Test.setMock(HttpCalloutMock.class, new TF_MockHttpRespCalloutGenerator());
        
        Test.startTest();
        TF_SingleOrderDetailJsonResponse JsonResponse =OrderHubCustomerDetailCancelCntrl.fetchSpecificOrder(orderNum, String.valueof(acc.id) );
        TF_SingleOrderDetailJsonResponse.metadata metaObj  = JsonResponse.metadata;
        String meta = String.valueOf(metaObj.code ) + String.valueOf(metaObj.totalPagesize ) +  metaObj.message;
        TF_SingleOrderDetailJsonResponse.order dataObj =JsonResponse.order; // it's order
        system.debug('dataObj-'+dataObj);
        String seller = dataObj.seller;
        Decimal discountAmount = dataObj.discountAmount;
        String discountCurrency =  String.valueOf(dataObj.orderPrice) +String.valueOf(dataObj.release) + String.valueOf(dataObj.discount) + dataObj.confirmationNumber  + dataObj.discountCurrency + dataObj.orderDate + dataObj.discountCode + dataObj.orderStatus  + dataObj.buyerId + dataObj.customerId  + dataObj.description + dataObj.orderNumber  + dataObj.docDate  + dataObj.quoteNumber  + dataObj.notes + dataObj.webId + dataObj.opportunityId + dataObj.shipCustId + dataObj.externalOrderRef + dataObj.orderSource + dataObj.channel + dataObj.orderType  + dataObj.id;
        TF_SingleOrderDetailJsonResponse.invoices invoiceObj = dataObj.invoices[0];
        
        string currencyy = invoiceObj.currencyy + invoiceObj.broker +String.valueOf(invoiceObj.freightCharge) + invoiceObj.externalInvoiceRef  + String.valueOf(invoiceObj.freightTax) + invoiceObj.id + invoiceObj.paymentStatus + invoiceObj.paymentDueDate + invoiceObj.paymentUrl +invoiceObj.paymentTerm + String.valueOf(invoiceObj.invoicePaymentPastDue);
        TF_SingleOrderDetailJsonResponse.invoiceLineItems invoiOli = invoiceObj.invoiceLineItems[0];
        String invOliStr = invoiOli.productId + invoiOli.orderItemId + String.valueOf(invoiOli.quantity);
        
        // TF_SingleOrderDetailJsonResponse.payments payObj =   invoiceObj.payments[0];
        // String payStr = payObj.id  + payObj.paymentMethod  + payObj.paymentDescription   + payObj.paymentType   + payObj.cardType   + payObj.mcasId   + payObj.authDate   +  String.valueOf(payObj.paymentAmount);
        
        TF_SingleOrderDetailJsonResponse.billingAddress billingAddressobj = dataObj.billingAddress;
        string billingAddressobjStr = billingAddressobj.telephoneNo + billingAddressobj.addressRegion + billingAddressobj.addressContactName + billingAddressobj.addressLocality + billingAddressobj.addressContactEmail + billingAddressobj.addressCountry + billingAddressobj.addressOrganisation + billingAddressobj.addressLine3 + billingAddressobj.postalCode + billingAddressobj.addressLine2 + billingAddressobj.streetAddress + billingAddressobj.addressLine1 + billingAddressobj.businessPartnerNo + billingAddressobj.countryCode + billingAddressobj.id;
        
        TF_SingleOrderDetailJsonResponse.orderedItem orderedItemObj = dataObj.orderedItem.get(0);
        String str = orderedItemObj.prodName + orderedItemObj.prodAuthor + orderedItemObj.versionType + orderedItemObj.currencyy + orderedItemObj.productId + orderedItemObj.sellingCurrency + orderedItemObj.id + orderedItemObj.lineItemType + orderedItemObj.discountCurrency + orderedItemObj.discountCode  + orderedItemObj.taxCode + orderedItemObj.description + String.valueOf(orderedItemObj.orderedQuantity)  + String.valueOf(orderedItemObj.sellingPrice)  + String.valueOf(orderedItemObj.price)  + String.valueOf(orderedItemObj.quantity)  + String.valueOf(orderedItemObj.discountAmount)  + String.valueOf(orderedItemObj.discount)  + String.valueOf(orderedItemObj.taxAmount);
        
        TF_SingleOrderDetailJsonResponse.fulfillments fulfillmentObj =  dataObj.fulfillments[0];
        String fulfillmentObjStr =  fulfillmentObj.termStartDate + fulfillmentObj.termEndDate + fulfillmentObj.licenseType + fulfillmentObj.bundle + fulfillmentObj.description + fulfillmentObj.printOnDemand  + fulfillmentObj.name + fulfillmentObj.catalogueNumber  + fulfillmentObj.id;
        
        TF_SingleOrderDetailJsonResponse.shippingAddress shippingAddressobj = dataObj.shippingAddress;
        string shippingAddressobjStr = shippingAddressobj.telephoneNo + shippingAddressobj.addressRegion + shippingAddressobj.addressContactName + shippingAddressobj.addressLocality + shippingAddressobj.addressContactEmail + shippingAddressobj.addressCountry + shippingAddressobj.addressOrganisation + shippingAddressobj.addressLine3 + shippingAddressobj.postalCode + shippingAddressobj.addressLine2 + shippingAddressobj.streetAddress + shippingAddressobj.addressLine1 + shippingAddressobj.businessPartnerNo + shippingAddressobj.countryCode + shippingAddressobj.id + shippingAddressobj.externalCustomerAddressId + shippingAddressobj.addressType+ shippingAddressobj.houseNumber+ shippingAddressobj.taxRegistrationNumber+ shippingAddressobj.taxCategory;
        
        //Shalini
        Credit_Note_Order__c creditNoteCustomSetting = new Credit_Note_Order__c(Send_emails_on_failure__c = true, Alert_Email_Addresses__c = 'test@gmail.com,Shal@gmail.com');
        insert creditNoteCustomSetting;
        List<TF_SingleOrderDetailJsonResponse.orderedItem> orderedItemList = dataObj.orderedItem;
        OrderHubCustomerDetailCancelCntrl.cancelSelectedOrder('89547', orderedItemList, dataObj, 'Test');
        Test.stopTest();
    }
    
    
    global class TF_MockHttpRespCalloutGenerator implements HttpCalloutMock {
        // Implement this interface method
        global HTTPResponse respond(HTTPRequest req) {
            
            // Create a fake response  orderedItem
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setHeader('total_pages', '2');
            // String setBody ='{"metadata":{"code":200,"message":"Order details retrieved"},"order":{"AccountName":"test account (have lots of orders )","billingAddress":{"addressContactEmail":"rahul.c.singh@informa.com","addressContactName":"Rahul Humphrey","addressCountry":"India","addressId":0,"addressLine1":"3 Doris St","addressLine2":"#143, 144, Hosur Main Road","addressLine3":"Koramangala 5th Block","addressLocality":"Bengaluru","addressRegion":"Karnataka","businessPartnerNo":"0003719048","countryCode":"IN","id":"0","postalCode":"504020","telephoneNo":"8986116512"},"buyerId":"rahul.c.singh@informa.com","channel":"UBX","confirmationNumber":0,"customerId":"20","id":"0","invoice":{"broker":"UBX","currencyy":"USD","externalInvoiceRef":"0947759939","id":"862195"},"orderDate":"2019-03-28","orderedItem":[{"currencyy":"USD","fulfillment":{"description":"UBX Title Purchase","grantType":["viewOnline","download"],"id":"2701790","licenseType":"perpetual","name":"UBX Title Purchase"},"id":"3063489","lineItemType":"title","orderedQuantity":1,"pri":180,"prodName":"Pig Health","productId":"9781315157061","quantity":1,"sellingPrice":212.4,"taxAmount":"32.40","versionType":"e-Book"}],"orderNumber":"ODR863293","orderPrice":212.4,"orderStatus":"INVOICED","orderType":"SALES","payment":{"paymentDueDate":"2019-04-27","paymentId":1166,"paymentMethod":"INVOICE","paymentTerm":"Z030"},"release":0,"seller":"TANDF"}}';
            String setBody = '{'+
                '    \"metadata\": {'+
                '        \"message\": \"Order details retrieved\",'+
                '        \"code\": 200'+
                '    },'+
                '    \"order\": {'+
                '        \"id\": 800833,'+
                '        \"orderType\": \"SALES\",'+
                '        \"channel\": \"GOBI\",'+
                '        \"externalOrderRef\": \"TAF0000109985\",'+
                '        \"opportunityId\": null,'+
                '        \"notes\": null,'+
                '        \"quoteNumber\": null,'+
                '        \"orderNumber\": \"ODR800833\",'+
                '        \"confirmationNumber\": null,'+
                '        \"customerId\": \"108\",'+
                '        \"buyerId\": \"102059\",'+
                '        \"discount\": null,'+
                '        \"discountCode\": null,'+
                '        \"discountCurrency\": null,'+
                '        \"discountAmount\": null,'+
                '        \"orderDate\": \"2019-06-21\",'+
                '        \"orderPrice\": 157.7,'+
                '        \"orderStatus\": \"OPEN\",'+
                '        \"invoices\": ['+
                '            {'+
                '                \"invoiceLineItems\": ['+
                '                    {'+
                '                        \"orderItemId\": 4863917,'+
                '                        \"quantity\": 1,'+
                '                        \"productId\": \"9781315263120\"'+
                '                    }'+
                '                ],'+
                '                \"invoicePaymentPastDue\": false,'+
                '                \"id\": 800465,'+
                '                \"externalInvoiceRef\": \"0952001196\",'+
                '                \"broker\": \"GOBI\",'+
                '                \"freightCharge\": null,'+
                '                \"freightTax\": null,'+
                '                \"currency\": \"USD\",'+
                '                \"paymentStatus\": \"PENDING\",'+
                '                \"paymentDueDate\": \"2019-07-21T13:44:51.178+0000\",'+
                '                \"paymentTerm\": \"Z030\",'+
                '                \"paymentUrl\": null,'+
                '                \"payments\": []'+
                '            }'+
                '        ],'+
                '        \"seller\": \"TANDF\",'+
                '        \"billingAddress\": {'+
                '            \"id\": 800875,'+
                '            \"addressLine1\": \"999 Maple Street\",'+
                '            \"addressLine2\": null,'+
                '            \"addressLine3\": null,'+
                '            \"addressCountry\": \"UNITED STATES OF AMERICA\",'+
                '            \"addressLocality\": \"CONTOOCOOK\",'+
                '            \"addressRegion\": \"NH\",'+
                '            \"addressContactName\": \"nullnull\",'+
                '            \"addressContactEmail\": \"amith.cv@informa.com\",'+
                '            \"addressOrganisation\": null,'+
                '            \"postalCode\": \"03229-3374\",'+
                '            \"streetAddress\": null,'+
                '            \"businessPartnerNo\": \"1208965\",'+
                '            \"countryCode\": \"US\",'+
                '            \"telephoneNo\": null,'+
                '            \"externalCustomerAddressId\": \"28401\",'+
                '            \"addressType\": null,'+
                '            \"houseNumber\": null,'+
                '            \"taxRegistrationNumber\": null,'+
                '            \"taxCategory\": null'+
                '        },'+
                '        \"shippingAddress\": {'+
                '            \"id\": 800876,'+
                '            \"addressLine1\": \"2&4 Park Square\",'+
                '            \"addressLine2\": null,'+
                '            \"addressLine3\": null,'+
                '            \"addressCountry\": \"UK\",'+
                '            \"addressLocality\": \"CONTOOCOOK\",'+
                '            \"addressRegion\": \"NH\",'+
                '            \"addressContactName\": \"nullnull\",'+
                '            \"addressContactEmail\": \"test@informatest.in\",'+
                '            \"addressOrganisation\": null,'+
                '            \"postalCode\": \"03229-3374\",'+
                '            \"streetAddress\": null,'+
                '            \"businessPartnerNo\": \"0003810490\",'+
                '            \"countryCode\": \"US\",'+
                '            \"telephoneNo\": null,'+
                '            \"externalCustomerAddressId\": \"34292\",'+
                '            \"addressType\": null,'+
                '            \"houseNumber\": null,'+
                '            \"taxRegistrationNumber\": null,'+
                '            \"taxCategory\": null'+
                '        },'+
                '        \"fulfillments\": ['+
                '            {'+
                '                \"fulfillmentLineItems\": ['+
                '                    {'+
                '                        \"orderItemId\": 4863917,'+
                '                        \"productId\": \"9781315263120\",'+
                '                        \"fulfillmentStatus\": \"NOT_FULFILLED\",'+
                '                        \"fulfillmentQuantity\": 1'+
                '                    }'+
                '                ],'+
                '                \"id\": 4580427,'+
                '                \"name\": \"Gobi Order Fulfillment\",'+
                '                \"description\": \"Gobi Order Fulfillment Description\",'+
                '                \"licenseType\": \"perpetual\",'+
                '                \"termStartDate\": null,'+
                '                \"termEndDate\": null,'+
                '                \"grantType\": ['+
                '                    \"viewOnline\",'+
                '                    \"download\"'+
                '                ],'+
                '                \"bundle\": null,'+
                '                \"printOnDemand\": null,'+
                '                \"catalogueNumber\": null,'+
                '                \"shipmentStatus\": null,'+
                '                \"status\": null'+
                '            }'+
                '        ],'+
                '        \"orderedItem\": ['+
                '            {'+
                '                \"id\": 4863917,'+
                '                \"productId\": \"9781315263120\",'+
                '                \"price\": 190,'+
                '                \"sellingPrice\": 157.7,'+
                '                \"currency\": \"USD\",'+
                '                \"sellingCurrency\": \"USD\",'+
                '                \"quantity\": 1,'+
                '                \"orderedQuantity\": 1,'+
                '                \"lineItemType\": \"Ebook\",'+
                '                \"discount\": 17,'+
                '                \"discountCode\": null,'+
                '                \"discountCurrency\": null,'+
                '                \"discountAmount\": 32.3,'+
                '                \"taxCode\": null,'+
                '                \"taxAmount\": 0,'+
                '                \"description\": null,'+
                '                \"status\": null'+
                '            }'+
                '        ],'+
                '        \"description\": null,'+
                '        \"docDate\": null,'+
                '        \"release\": null,'+
                '        \"webId\": null,'+
                '        \"shipCustId\": null,'+
                '        \"orderSource\": null,'+
                '        \"rateOfExchange\": null,'+
                '        \"subTotalPrice\": 157.7,'+
                '        \"totalTax\": 0'+
                '    }'+
                '}';
            res.setBody(setBody);
            res.setStatusCode(200);
            res.setStatus('Ok');
            return res;
        }
    }
    
    global class TF_MockHttpRespCalloutGeneratorNew implements HttpCalloutMock {
        // Implement this interface method
        global HTTPResponse respond(HTTPRequest req) {
            
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
                '                        \"externalInvoiceRef\": \"jghsdf\",'+
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
                '                    \"addressContactEmail\": \"rahul.c.singh@informa.com\",'+
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
    
    global class MockHttpRespCalloutForSingleOrder implements HttpCalloutMock {
        // Implement this interface method
        global HTTPResponse respond(HTTPRequest req) {
            
            String jsonStr = '{'+
                '    \"metadata\": {'+
                '        \"message\": \"Orders retrieved\",'+
                '        \"code\": 200'+
                '    },'+
                '    \"data\": {'+
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
                '                        \"externalInvoiceRef\": \"jghsdf\",'+
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
                '                    \"addressContactEmail\": \"rahul.c.singh@informa.com\",'+
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
                '        \"totalCount\": 1'+
                '    }'+
                '}';
            
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