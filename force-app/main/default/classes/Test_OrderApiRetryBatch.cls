@isTest
public class Test_OrderApiRetryBatch {
    
    @isTest private static void OrderApiRetryBatchTest(){  
        Product2 pi = new product2(Name ='xy',IsActive = true);
        insert pi;
        string jsonbody = '{"id":982309,"orderType":"SALES","channel":"ASC","externalOrderRef":"745858","opportunityId":null,"notes":null,"quoteNumber":"a1y9E000001aGXEQA2","orderNumber":"ODR982309","confirmationNumber":null,"customerId":"0019E00000yzJXjQAM","buyerId":"0039E00000sjn1EQAQ","discount":null,"discountCode":null,"discountCurrency":null,"discountAmount":null,"orderDate":"2019-08-28","orderPrice":2395.00,"orderStatus":"Draft","invoices":[{"invoiceLineItems":[{"orderItemId":3914235,"quantity":1,"productId":"'+pi.Id+'"}],"invoicePaymentPastDue":false,"id":976406,"externalInvoiceRef":"0952001204","broker":"ASC","freightCharge":null,"freightTax":null,"currency":"EUR","paymentStatus":"PENDING","paymentDueDate":1569560999203,"paymentTerm":"Z030","paymentUrl":null,"salesOrg":"IN01","readyForDownload":null,"payments":[]}],"seller":"TANDF","billingAddress":{"id":977830,"addressLine1":"Schimmelt 32","addressLine2":null,"addressLine3":null,"addressCountry":"Netherlands","addressLocality":"Eindhoven","addressRegion":"North Brabant","addressContactName":null,"addressContactEmail":"amanica.nagunuri@informa.com","addressOrganisation":null,"postalCode":"5611 ZX","streetAddress":null,"businessPartnerNo":"0003721339","countryCode":"NL","telephoneNo":null,"externalCustomerAddressId":"a1y1j000000wQWuAAM","addressType":null,"houseNumber":null,"taxRegistrationNumber":null,"taxCategory":null,"addressContactFirstName":"amanica","addressContactLastName":" N"},"shippingAddress":null,"fulfillments":[],"orderedItem":[{"id":3914235,"productId":"'+pi.Id+'","price":2395.00,"sellingPrice":2395.00,"currency":"EUR","sellingCurrency":null,"quantity":1,"orderedQuantity":1,"lineItemType":"Open Access Fee","discount":0.000,"discountCode":null,"discountCurrency":"EUR","discountAmount":0.00,"taxCode":null,"taxAmount":0,"description":null,"status":null,"salesOrg":null}],"description":"test","docDate":null,"release":null,"webId":null,"shipCustId":null,"orderSource":null,"rateOfExchange":null,"subTotalPrice":null,"totalTax":0}';
        Setting__c  settingOrderApiLogs = new  Setting__c(Name = 'OrderApi_Error_Logs');
        insert settingOrderApiLogs;
        List<Setting_Item__c> lstOfSettingItem = new List<Setting_Item__c>();
        for(Integer i= 0; i<=10; i++){
            Setting_Item__c settingItemOrderApiLogs = new Setting_Item__c();
            settingItemOrderApiLogs.Text_3__c ='1234567:07/31/2019';
            settingItemOrderApiLogs.Setting__c =settingOrderApiLogs.Id;
            settingItemOrderApiLogs.Text_2__c='ERROR: Customer not exist in SF. on line 291';
            settingItemOrderApiLogs.Long_Text_1__c = jsonbody;
            lstOfSettingItem.add(settingItemOrderApiLogs);
        }
        
        insert lstOfSettingItem;             
        Test.startTest();
        OrderApiRetryBatch objBatch = new OrderApiRetryBatch();
        DataBase.executeBatch(objBatch);  
        Test.stopTest();       
    }
    
    @isTest private static void OrderApiRetryBatchTest1(){   
        Product2 pi = new product2(Name ='xy',IsActive = true);
        insert pi;
        Setting__c  settingOrderApiLogs = new  Setting__c(Name = 'OrderApi_Error_Logs');
        insert settingOrderApiLogs ;
        string jsonbody ='{"id":1061228,"orderType":"SALES","channel":"GOBI","externalOrderRef":"TAF5000004406","opportunityId":null,"notes":null,"quoteNumber":null,"orderNumber":"ODR1061228","confirmationNumber":null,"customerId":"97546","buyerId":"102059","discount":null,"discountCode":null,"discountCurrency":null,"discountAmount":null,"orderDate":"2019-09-07","orderPrice":306.27,"orderStatus":"OPEN","invoices":[{"invoiceLineItems":[{"orderItemId":6501922,"quantity":1,"productId":"9781315044330"},{"orderItemId":6501923,"quantity":1,"productId":"9781315765754"}],"invoicePaymentPastDue":false,"id":1061177,"externalInvoiceRef":"0952104530","broker":"GOBI","freightCharge":null,"freightTax":null,"currency":"USD","paymentStatus":"PENDING","paymentDueDate":1570447758698,"paymentTerm":"Z030","paymentUrl":null,"salesOrg":"IN01","readyForDownload":null,"payments":[]}],"seller":"TANDF","billingAddress":{"id":1063350,"addressLine1":"999 Maple Street","addressLine2":null,"addressLine3":null,"addressCountry":"UNITED STATES OF AMERICA","addressLocality":"CONTOOCOOK","addressRegion":"NH","addressContactName":"nullnull","addressContactEmail":"econtent@ybp.com","addressOrganisation":null,"postalCode":"03229-3374","streetAddress":null,"businessPartnerNo":"1208965","countryCode":"US","telephoneNo":null,"externalCustomerAddressId":"28401","addressType":null,"houseNumber":null,"taxRegistrationNumber":null,"taxCategory":null,"addressContactFirstName":null,"addressContactLastName":null},"shippingAddress":{"id":1063351,"addressLine1":"WIVENHOE PARK","addressLine2":"COLCHESTER","addressLine3":null,"addressCountry":"United Kingdom","addressLocality":"COLCHESTER","addressRegion":null,"addressContactName":"Universityof Essex","addressContactEmail":"collad@essex.ac.uk","addressOrganisation":null,"postalCode":"CO4 3SQ","streetAddress":null,"businessPartnerNo":"0003873169","countryCode":"GB","telephoneNo":null,"externalCustomerAddressId":"32535","addressType":null,"houseNumber":null,"taxRegistrationNumber":null,"taxCategory":null,"addressContactFirstName":null,"addressContactLastName":null},"fulfillments":[{"fulfillmentLineItems":[{"orderItemId":6501922,"productId":"9781315044330","fulfillmentStatus":"NOT_FULFILLED","fulfillmentQuantity":1},{"orderItemId":6501923,"productId":"9781315765754","fulfillmentStatus":"NOT_FULFILLED","fulfillmentQuantity":1}],"id":6152232,"name":"Gobi Order Fulfillment","description":"Gobi Order Fulfillment Description","licenseType":"perpetual","termStartDate":null,"termEndDate":null,"grantType":["viewOnline","download"],"bundle":null,"printOnDemand":null,"catalogueNumber":null,"shipmentStatus":null,"status":null}],"orderedItem":[{"id":6501922,"productId":"9781315044330","price":193,"sellingPrice":160.19,"currency":"USD","sellingCurrency":"USD","quantity":1,"orderedQuantity":1,"lineItemType":"Ebook","discount":17.00,"discountCode":null,"discountCurrency":null,"discountAmount":32.81,"taxCode":null,"taxAmount":0.00,"description":null,"status":null,"salesOrg":null},{"id":6501923,"productId":"9781315765754","price":176,"sellingPrice":146.08,"currency":"USD","sellingCurrency":"USD","quantity":1,"orderedQuantity":1,"lineItemType":"Ebook","discount":17.00,"discountCode":null,"discountCurrency":null,"discountAmount":29.92,"taxCode":null,"taxAmount":0.00,"description":null,"status":null,"salesOrg":null}],"description":null,"docDate":null,"release":null,"webId":null,"shipCustId":null,"orderSource":null,"rateOfExchange":null,"subTotalPrice":null,"totalTax":0.00}0}'; 
        
        Setting_Item__c settingItemOrderApiLogs = new Setting_Item__c(Text_3__c='1234567:07/31/2019',Long_Text_1__c=jsonbody,Text_2__c='ERROR: Customer not exist in SF. on line 291', Setting__c=settingOrderApiLogs.id);
        insert settingItemOrderApiLogs; 
        
        Test.startTest();
        OrderApiRetryBatch objBatch = new OrderApiRetryBatch();
        DataBase.executeBatch(objBatch);
        OrderApiRetryBatch_Schedule objSchedule = new OrderApiRetryBatch_Schedule();      
        String sch = '0 0 2 * * ?'; 
        system.schedule('Test OrderApiRetryBatch Schedule', sch, objSchedule); 
        Test.stopTest(); 
        
    }
    
}