/** Created By: Shalini Singh 
    Class: Trig_cancelNonSFOrder
**/
@isTest
public class Trig_cancelNonSFOrderTest {

    @testSetup
    static void setupdata(){
        //Test Account Insert
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
    }
    
	@isTest
    public static void testCancelorder(){
        account a = [select id from account limit 1];
        Id ordRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Credit Note Order').getRecordTypeId();
        TriggerInterfaceHelper.runTrigger('Trig_cancelNonSFOrder', 'Order', 96, 'ai', ordRecordTypeId, null);  
        
        Order o = new Order();
        o.Name = 'Test Order ';
        o.RecordTypeId = ordRecordTypeId;
        o.Status = 'OPEN';
        o.EffectiveDate = system.today();
        o.EndDate = system.today() + 4;
        o.AccountId = a.id;
        o.OrderReferenceNumber = '15';
        o.Cancelled_Order_Reference_Number__c = '15';
        o.Channel__c = 'UBX';
        o.Type = 'SALES';
        insert o;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new generatorSuccess());
        //TriggerInterfaceHelper.runTrigger('Trig_cancelNonSFOrder', 'Order', 96, 'ai', ordRecordTypeId, null); 
        test.stopTest(); 
        Trig_cancelNonSFOrder.retryCancelSelectedOrder(o.id);
        Trig_cancelNonSFOrder.getOrderDetails(o.id);
    }
    
    @isTest
    public static void testCancelorder_1(){
        account a = [select id from account limit 1];
        Id ordRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Credit Note Order').getRecordTypeId();
        
        Order o = new Order();
        o.Name = 'Test Order ';
        o.RecordTypeId = ordRecordTypeId;
        o.Status = 'OPEN';
        o.EffectiveDate = system.today();
        o.EndDate = system.today() + 4;
        o.AccountId = a.id;
        o.OrderReferenceNumber = '';
        o.Channel__c = 'UBX';
        o.Type = 'SALES';
        insert o;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new generatorSuccess());
        Trig_cancelNonSFOrder.retryCancelSelectedOrder(o.id);
        test.stopTest(); 
    }
    
    @isTest
    public static void testCancelorder_2(){
        account a = [select id from account limit 1];
        Id ordRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Credit Note Order').getRecordTypeId();
        
        Order o = new Order();
        o.Name = 'Test Order ';
        o.RecordTypeId = ordRecordTypeId;
        o.Status = 'OPEN';
        o.EffectiveDate = system.today();
        o.EndDate = system.today() + 4;
        o.AccountId = a.id;
        o.OrderReferenceNumber = '15';
        o.Channel__c = 'UBX';
        o.Type = 'SALES';
        insert o;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new generatorError());
        Trig_cancelNonSFOrder.retryCancelSelectedOrder(o.id);
        test.stopTest(); 
    }
    
    public class generatorSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"metadata":{"message":"Order details retrieved","code":200},"order":{"totalDiscountAmount":0.00,"originalOrderRef":null,"returnRemarks":null,"id":820560,"orderType":"SALES","channel":"EBK_DIRECT_SALES","externalOrderRef":"00000560","opportunityId":"0061l00000K3AbkAAF","notes":null,"quoteNumber":"Q-06006","orderNumber":"ODR820560","confirmationNumber":560,"customerId":"100","buyerId":"100","discount":0.00,"discountCode":null,"discountCurrency":null,"discountAmount":0.00,"orderDate":"2020-05-06","orderPrice":69.54,"orderStatus":"OPEN","invoices":[{"invoiceLineItems":[{"orderItemId":5610116,"quantity":1,"productId":"9781315220314"}],"invoiceType":"INVOICE","originalInvoiceRef":null,"royaltyNotified":null,"invoicePaymentPastDue":false,"id":821477,"externalInvoiceRef":"0952320940","broker":"EBK_DIRECT_SALES","freightCharge":0.00,"freightTax":0.00,"currency":"USD","paymentStatus":"PENDING","paymentDueDate":"2020-06-05T09:40:01.801+0000","paymentTerm":"Z030","paymentUrl":null,"salesOrg":"IN01","readyForDownload":null,"payments":[],"paymentAcknowledgementDate":null}],"seller":"TANDF","billingAddress":{"id":824750,"addressLine1":"13 rue de Toul ,Le Fer à Cheval  36 Route du Crêt","addressLine2":null,"addressLine3":null,"addressCountry":"France","addressLocality":"Lille","addressRegion":"Alpes (Hautes)","addressContactName":"Test 15april","addressContactEmail":"15april@gmail.com","addressOrganisation":null,"postalCode":"59000","streetAddress":null,"businessPartnerNo":"0004105484","countryCode":"FR","telephoneNo":null,"externalCustomerAddressId":null,"addressType":null,"houseNumber":null,"taxRegistrationNumber":null,"taxCategory":null,"addressContactFirstName":null,"addressContactLastName":null},"shippingAddress":{"id":824751,"addressLine1":"13 rue de Toul ,Le Fer à Cheval  36 Route du Crêt","addressLine2":null,"addressLine3":null,"addressCountry":"France","addressLocality":"Lille","addressRegion":"Alpes (Hautes)","addressContactName":"Test tax","addressContactEmail":"test.email@tax.com","addressOrganisation":null,"postalCode":"59000","streetAddress":null,"businessPartnerNo":"0004105485","countryCode":"FR","telephoneNo":null,"externalCustomerAddressId":null,"addressType":null,"houseNumber":null,"taxRegistrationNumber":null,"taxCategory":null,"addressContactFirstName":null,"addressContactLastName":null},"fulfillments":[{"licenseId":"115236","fulfillmentLineItems":[{"orderItemId":5610116,"productId":"9781315220314","fulfillmentStatus":"FULFILLED","fulfillmentQuantity":1}],"id":4598001,"name":"UBX Title Purchase","description":"UBX Title Purchase","licenseType":"perpetual","termStartDate":null,"termEndDate":null,"grantType":["viewOnline","download"],"bundle":null,"printOnDemand":null,"catalogueNumber":null,"shipmentStatus":null,"status":null}],"orderedItem":[{"id":5610116,"productId":"9781315220314","price":57.95,"sellingPrice":69.54,"currency":"USD","sellingCurrency":null,"quantity":1,"orderedQuantity":1,"lineItemType":"EBOOK","salesType":null,"discount":0.00,"discountCode":null,"discountCurrency":"USD","discountAmount":0.00,"taxCode":"ZMSC","taxAmount":11.59,"description":null,"status":null,"salesOrg":null}],"description":null,"docDate":null,"release":null,"webId":null,"shipCustId":null,"orderSource":null,"rateOfExchange":0.00,"subTotalPrice":57.95,"totalTax":11.59,"paid":false,"fulfilled":true}}');
            res.setStatusCode(201);
            return res;
        }
    }
    
    public class generatorError implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"metadata": {"message": "Test Error","code": 400} }');
            res.setStatusCode(400);
            return res;
        }
    }
}