/*
* Class: OrderCancellationCtrl
* Created by Piyush Jain
*/
@IsTest(SeeAllData=false)
public class zTEST_OrderCancellationCtrl  implements HttpCalloutMock{
    private integer statusCode;
    private String responseJson;
    private static String getUrlSuccess = '{"metadata":{"message":"Order details retrieved","code":200},"order":{"totalDiscountAmount":26.07,"originalOrderRef":null,"cancelReason":null,"id":824121,"orderType":"SALES","channel":"EBK_DIRECT_SALES","externalOrderRef":"00000775","opportunityId":"0061l00000KfcOXAAZ","notes":null,"quoteNumber":"Q-06058","orderNumber":"ODR824121","confirmationNumber":775,"customerId":"100","buyerId":"100","discount":0.00,"discountCode":null,"discountCurrency":null,"discountAmount":0.00,"orderDate":"2020-07-08","orderPrice":147.78,"orderStatus":"OPEN","invoices":[{"invoiceLineItems":[{"orderItemId":6699095,"quantity":1,"productId":"9781315221878"},{"orderItemId":6699096,"quantity":1,"productId":"9781315221854"},{"orderItemId":6699097,"quantity":1,"productId":"9781315220314"}],"invoiceType":"INVOICE","originalInvoiceRef":null,"royaltyNotified":null,"salesOrderNumber":"0006978202","invoicePaymentPastDue":false,"id":827320,"externalInvoiceRef":"0952383786","broker":"EBK_DIRECT_SALES","freightCharge":0.00,"freightTax":0.00,"currency":"USD","paymentStatus":"PENDING","paymentDueDate":"2020-08-07T06:36:03.340+0000","paymentTerm":"Z030","paymentUrl":null,"salesOrg":"IN01","readyForDownload":null,"payments":[],"paymentAcknowledgementDate":null}],"seller":"TANDF","billingAddress":{"id":828375,"addressLine1":"30 Via Monte S Gabriele","addressLine2":null,"addressLine3":null,"addressCountry":"Italy","addressLocality":"Trieste","addressRegion":null,"addressContactName":"Tom Jones","addressContactEmail":"tj@gmail.com","addressOrganisation":null,"postalCode":"34127","streetAddress":null,"businessPartnerNo":"0004106288","countryCode":"IT","telephoneNo":null,"externalCustomerAddressId":null,"addressType":null,"houseNumber":null,"taxRegistrationNumber":null,"taxCategory":null,"addressContactFirstName":null,"addressContactLastName":null},"shippingAddress":null,"fulfillments":[{"licenseId":"115236","fulfillmentLineItems":[{"orderItemId":6699095,"productId":"9781315221878","fulfillmentStatus":"NOT_FULFILLED","fulfillmentQuantity":1},{"orderItemId":6699096,"productId":"9781315221854","fulfillmentStatus":"NOT_FULFILLED","fulfillmentQuantity":1},{"orderItemId":6699097,"productId":"9781315220314","fulfillmentStatus":"NOT_FULFILLED","fulfillmentQuantity":1}],"id":4598358,"name":"UBX Title Purchase","description":"UBX Title Purchase","licenseType":"perpetual","termStartDate":null,"termEndDate":null,"grantType":["viewOnline","download"],"bundle":null,"printOnDemand":null,"catalogueNumber":null,"shipmentStatus":null,"status":null}],"orderedItem":[{"id":6699095,"productId":"9781315221878","price":57.95,"sellingPrice":49.26,"currency":"USD","sellingCurrency":null,"quantity":1,"orderedQuantity":1,"lineItemType":"EBOOK","salesType":null,"discount":15.00,"discountCode":null,"discountCurrency":"USD","discountAmount":8.69,"taxCode":"ZMSC","taxAmount":0.00,"description":null,"status":"NOT_FULFILLED","salesOrg":null},{"id":6699096,"productId":"9781315221854","price":57.95,"sellingPrice":49.26,"currency":"USD","sellingCurrency":null,"quantity":1,"orderedQuantity":1,"lineItemType":"EBOOK","salesType":null,"discount":15.00,"discountCode":null,"discountCurrency":"USD","discountAmount":8.69,"taxCode":"ZMSC","taxAmount":0.00,"description":null,"status":"NOT_FULFILLED","salesOrg":null},{"id":6699097,"productId":"9781315220314","price":57.95,"sellingPrice":49.26,"currency":"USD","sellingCurrency":null,"quantity":1,"orderedQuantity":1,"lineItemType":"EBOOK","salesType":null,"discount":15.00,"discountCode":null,"discountCurrency":"USD","discountAmount":8.69,"taxCode":"ZMSC","taxAmount":0.00,"description":null,"status":"NOT_FULFILLED","salesOrg":null}],"description":null,"docDate":null,"release":null,"webId":null,"shipCustId":null,"orderSource":null,"rateOfExchange":0.00,"subTotalPrice":147.78,"totalTax":0.00,"paid":false,"fulfilled":false}}';
    private static String cancelOrderSuccess = '{"metadata":{"message":"Order Cancelled Successfully!","code":201},"data":{"previousOrderNumber":"ODR824121","reversalOrderNumber":"ODR824122","revisedOrderNumber":"ODR824123"}}';

    public zTEST_OrderCancellationCtrl(integer statusCode, String responseJson){
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
      
    @testSetup static void setup(){
        Account acc = new Account(Name='test',customer_id__c='97546');
        insert  acc;
        
        Setting__c  settingOrderCancelReason = new  Setting__c(Name = 'Order Cancellation Reason');
        insert settingOrderCancelReason ;
        Setting_Item__c settingItemOrderCancelReason = new Setting_Item__c(Text_1__c='Incorrect Address',Setting__c=settingOrderCancelReason.id);
        insert settingItemOrderCancelReason;
        
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        orgSpecificProps.Order_Cancellation__c = 'https://api-uat.taylorandfrancis.com/v1/orders/';
        insert orgSpecificProps;
		
        SAP_BP__c SAP_BP_Record = new SAP_BP__c();
        SAP_BP_Record.Name = 'Pending';
        SAP_BP_Record.Address_Type__c = 'Account Mailing';
        SAP_BP_Record.BP__c = 'Test';
        insert SAP_BP_Record;
       
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.stageName = 'Test';
        opp.Order_Status__c = 'Successful';
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Bill_to_BP__c = SAP_BP_Record.id;
        insert opp;
        
        Product2 pro = new Product2();
        pro.Name = 'Test';
        pro.ProductCode = '9781315221854';
        pro.IsActive = true;
        pro.ISBN__c='9875628223';
        insert pro;
        
        PricebookEntry priceBookEntry = new PricebookEntry();
        priceBookEntry.UnitPrice = 1;
        priceBookEntry.Pricebook2Id = Test.getStandardPricebookId();
        priceBookEntry.Product2Id = pro.id;
        insert priceBookEntry;
        
        Order order_Record = new Order();
        order_Record.Name = 'Test';
        order_Record.OpportunityId = opp.id;
        order_Record.Pricebook2Id = Test.getStandardPricebookId();
        order_Record.AccountId = acc.id;
        order_Record.EffectiveDate = Date.newInstance(2019, 12, 9);
        order_Record.Status = 'Draft';
        order_Record.Message__c = 'Tax Calculation-Success';
        order_Record.OrderReferenceNumber = 'Test';
        insert order_Record;
        
        Order order_Record_1 = new Order();
        order_Record_1.Name = 'Test 1';
        order_Record_1.OpportunityId = opp.id;
        order_Record_1.Pricebook2Id = Test.getStandardPricebookId();
        order_Record_1.AccountId = acc.id;
        order_Record_1.EffectiveDate = Date.newInstance(2019, 12, 9);
        order_Record_1.Status = 'Draft';
        order_Record_1.Message__c = '';
        order_Record_1.OrderReferenceNumber = 'Test';
        insert order_Record_1;
        
        OrderItem orderProduct = new OrderItem();
        orderProduct.OrderId = order_Record.id;
        orderProduct.Quantity = 1;
        orderProduct.UnitPrice = 20;
        orderProduct.PricebookEntryId = priceBookEntry.id;
        orderProduct.SBQQ_NetTotal__c = 786786;
        orderProduct.Discount_Amount__c = 786786;
        orderProduct.SBQQ__OrderedQuantity__c = 786786;
        orderProduct.SBQQ__TaxCode__c = 'Test';
        orderProduct.SBQQ__TaxAmount__c = 786786;
        insert orderProduct;
        
        OrderItem orderProduct_1 = new OrderItem();
        orderProduct_1.OrderId = order_Record.id;
        orderProduct_1.Quantity = 1;
        orderProduct_1.UnitPrice = 30;
        orderProduct_1.PricebookEntryId = priceBookEntry.id;
        orderProduct_1.SBQQ_NetTotal__c = 786786;
        orderProduct_1.Discount_Amount__c = 786786;
        orderProduct_1.SBQQ__OrderedQuantity__c = 786786;
        orderProduct_1.SBQQ__TaxCode__c = 'Test';
        orderProduct_1.SBQQ__TaxAmount__c = 786786;
        insert orderProduct_1;
        
    }
    
    @isTest
    Public static void orderCancellation(){   
        OrderCancellationCtrl.wrapOrderItem wrapOrderItemObj = new OrderCancellationCtrl.wrapOrderItem();
        OrderCancellationCtrl.wrapOrderItem wrapOrderItemObj_1 = new OrderCancellationCtrl.wrapOrderItem();
        List<OrderCancellationCtrl.wrapOrderItem> wraporderItemList = new List<OrderCancellationCtrl.wrapOrderItem>();
        
        Account acc = [Select id, Name from Account where Name ='test'];
        Order order_Record = [Select id,Message__c from Order where  Name ='Test'];
        OrderItem orderProduct = [Select id,ISBN__c,Quantity,UnitPrice,PricebookEntryId,SBQQ_NetTotal__c from OrderItem where UnitPrice =20 limit 1];
        OrderItem orderProduct_1 = [Select id,ISBN__c,Quantity,UnitPrice,PricebookEntryId,SBQQ_NetTotal__c from OrderItem where UnitPrice =30 limit 1];
        
        wrapOrderItemObj.oliId = orderProduct.Id;
        wrapOrderItemObj.qtyToReduce = 1;
        wrapOrderItemObj.ordItem = orderProduct;
        wraporderItemList.add(wrapOrderItemObj);
        
        wrapOrderItemObj_1.oliId = orderProduct_1.Id;
        wrapOrderItemObj_1.qtyToReduce = 0;
        wrapOrderItemObj_1.ordItem = orderProduct_1;
        wraporderItemList.add(wrapOrderItemObj_1);
        
        system.debug('wraporderItemList '+wraporderItemList);
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTEST_OrderCancellationCtrl(200, getUrlSuccess));
        OrderCancellationCtrl.getOrderItems(order_Record.id);
        OrderCancellationCtrl.cancelSelectedOLIs(wraporderItemList,'Test',order_Record.Id);
        OrderCancellationCtrl.checkCurrentOrderDetails(order_Record.id);
        OrderCancellationCtrl.getOrdCancellationReason();
        OrderCancellationCtrl.updateOrderMessageField('Order cancellation from order hub', order_Record);
        test.stopTest(); 
    }
    
    @isTest
    Public static void orderCancellationError(){   
        OrderCancellationCtrl.wrapOrderItem wrapOrderItemObj = new OrderCancellationCtrl.wrapOrderItem();
        List<OrderCancellationCtrl.wrapOrderItem> wraporderItemList = new List<OrderCancellationCtrl.wrapOrderItem>();
        
        Account acc = [Select id, Name from Account where Name ='test'];
        Order order_Record = [Select id,Message__c from Order where  Name ='Test'];
        Order order_Record_1 = [Select id,Message__c from Order where  Name ='Test 1'];
        OrderItem orderProduct = [Select id,ISBN__c,Quantity,UnitPrice,PricebookEntryId,SBQQ_NetTotal__c from OrderItem where UnitPrice =20 limit 1];
        OrderItem orderProduct_1 = [Select id,ISBN__c,Quantity,UnitPrice,PricebookEntryId,SBQQ_NetTotal__c from OrderItem where UnitPrice =30 limit 1];
        
        wrapOrderItemObj.oliId = orderProduct.Id;
        wrapOrderItemObj.qtyToReduce = 1;
        wrapOrderItemObj.ordItem = orderProduct;
        wraporderItemList.add(wrapOrderItemObj);
       
        system.debug('wraporderItemList '+wraporderItemList);
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTEST_OrderCancellationCtrl(400, getUrlSuccess));
        OrderCancellationCtrl.cancelSelectedOLIs(wraporderItemList,'Test',order_Record.Id);
        OrderCancellationCtrl.updateOrderMessageField('Order cancellation from order hub', order_Record_1);
        test.stopTest(); 
    }

}