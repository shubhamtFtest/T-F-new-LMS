@isTest
public class zTEST_TF_downloadPDF {
	@isTest
    public static void downloadPDF(){
        
        //Test Account Insert
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        Id recordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F Automated eBooks Opportunity');
        
        // Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        Pricebook2 pricebk = new Pricebook2(Id = Test.getStandardPricebookId());
        
        SAP_BP__c sapObject = new SAP_BP__c(Account_Id__c = a.Id,First_Name__c = 'test_first_name',Last_Name__c = 'test_last_name',Email__c = 'test@gmail.com',Name = 'TPENDING',Street__c = 'Test Street',Region__c = 'Test_Region',Address_Type__c = 'Account Mailing',State__c = 'test state',Country__c = 'test',City__c = 'test city',Status__c = true);
        insert sapObject;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.StageName = 'Acceptance';
        opp.AccountId = a.id;
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Bill_to_BP__c = sapObject.id;
        opp.Order_Status__c = 'Failed';
        opp.Licence_Exit_Clause__c = 'Yes';
        opp.Ship_to_BP__c = sapObject.id;
        opp.Account_Validate_Opp__c = true;
        insert opp;
        
        //Create Quote
        Id quoteRecordtypeId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'Automated eBook Direct Sales Orders');
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Opportunity2__c = opp.Id,SBQQ__BillingCity__c = 'test Billing',SBQQ__Account__c = a.Id, Payer_Account__c = a.Id, SBQQ__ExpirationDate__c = System.today() + 60, SBQQ__Status__c = 'Accepted', SBQQ__Primary__c=true,Quote_Type__c = 'Direct Sale', RecordTypeId = quoteRecordtypeId); 
        insert quoteObject;system.debug(quoteObject.recordTypeId);
                
        Country__c countryObject = new Country__c(Country_2__c = 'ab',Name = 'test');
        insert countryObject;
        
        Order o = new Order();
        o.OpportunityId = opp.Id;
        o.Name = 'Test Order ';
        o.Status = 'Draft';
        o.SBQQ__Quote__c = quoteObject.id;
        o.EffectiveDate = system.today();
        o.EndDate = system.today() + 4;
        o.AccountId = a.id;
        o.Pricebook2Id =  pricebk.Id ;
        o.OrderReferenceNumber = '15';
        o.Order_Channel__c = 'EBK AGENT SALES';
        o.Type = 'SALES';
        insert o;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenDetailsGeneratorSuccess());
        TF_downloadPDF.downloadPDF(o.id);
        TF_downloadPDF.mogrifyJSON('{ "totalTax" : 0.000, "subTotalPrice" : 715.00, "sponsors" : null}');
        test.stopTest();      
    }
    
    public class TokenDetailsGeneratorSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            TokenDetails token = new TokenDetails();
            res.setBody('{"metadata":{"message":"Order details retrieved","code":200},"order":{"totalDiscountAmount":0.00,"originalOrderRef":null,"returnRemarks":null,"id":820560,"orderType":"SALES","channel":"EBK_DIRECT_SALES","externalOrderRef":"00000560","opportunityId":"0061l00000K3AbkAAF","notes":null,"quoteNumber":"Q-06006","orderNumber":"ODR820560","confirmationNumber":560,"customerId":"100","buyerId":"100","discount":0.00,"discountCode":null,"discountCurrency":null,"discountAmount":0.00,"orderDate":"2020-05-06","orderPrice":69.54,"orderStatus":"OPEN","invoices":[{"invoiceLineItems":[{"orderItemId":5610116,"quantity":1,"productId":"9781315220314"}],"invoiceType":"INVOICE","originalInvoiceRef":null,"royaltyNotified":null,"invoicePaymentPastDue":false,"id":821477,"externalInvoiceRef":"0952320940","broker":"EBK_DIRECT_SALES","freightCharge":0.00,"freightTax":0.00,"currency":"USD","paymentStatus":"PENDING","paymentDueDate":"2020-06-05T09:40:01.801+0000","paymentTerm":"Z030","paymentUrl":null,"salesOrg":"IN01","readyForDownload":null,"payments":[],"paymentAcknowledgementDate":null}],"seller":"TANDF","billingAddress":{"id":824750,"addressLine1":"13 rue de Toul ,Le Fer à Cheval  36 Route du Crêt","addressLine2":null,"addressLine3":null,"addressCountry":"France","addressLocality":"Lille","addressRegion":"Alpes (Hautes)","addressContactName":"Test 15april","addressContactEmail":"15april@gmail.com","addressOrganisation":null,"postalCode":"59000","streetAddress":null,"businessPartnerNo":"0004105484","countryCode":"FR","telephoneNo":null,"externalCustomerAddressId":null,"addressType":null,"houseNumber":null,"taxRegistrationNumber":null,"taxCategory":null,"addressContactFirstName":null,"addressContactLastName":null},"shippingAddress":{"id":824751,"addressLine1":"13 rue de Toul ,Le Fer à Cheval  36 Route du Crêt","addressLine2":null,"addressLine3":null,"addressCountry":"France","addressLocality":"Lille","addressRegion":"Alpes (Hautes)","addressContactName":"Test tax","addressContactEmail":"test.email@tax.com","addressOrganisation":null,"postalCode":"59000","streetAddress":null,"businessPartnerNo":"0004105485","countryCode":"FR","telephoneNo":null,"externalCustomerAddressId":null,"addressType":null,"houseNumber":null,"taxRegistrationNumber":null,"taxCategory":null,"addressContactFirstName":null,"addressContactLastName":null},"fulfillments":[{"licenseId":"115236","fulfillmentLineItems":[{"orderItemId":5610116,"productId":"9781315220314","fulfillmentStatus":"FULFILLED","fulfillmentQuantity":1}],"id":4598001,"name":"UBX Title Purchase","description":"UBX Title Purchase","licenseType":"perpetual","termStartDate":null,"termEndDate":null,"grantType":["viewOnline","download"],"bundle":null,"printOnDemand":null,"catalogueNumber":null,"shipmentStatus":null,"status":null}],"orderedItem":[{"id":5610116,"productId":"9781315220314","price":57.95,"sellingPrice":69.54,"currency":"USD","sellingCurrency":null,"quantity":1,"orderedQuantity":1,"lineItemType":"EBOOK","salesType":null,"discount":0.00,"discountCode":null,"discountCurrency":"USD","discountAmount":0.00,"taxCode":"ZMSC","taxAmount":11.59,"description":null,"status":null,"salesOrg":null}],"description":null,"docDate":null,"release":null,"webId":null,"shipCustId":null,"orderSource":null,"rateOfExchange":0.00,"subTotalPrice":57.95,"totalTax":11.59,"paid":false,"fulfilled":true}}');
            res.setStatusCode(200);
            return res;
        }
    }
    class TokenDetails {
        private String details ='TokenValue' ;
        private String access_token ='123';
        private String token_type ='123';
        private Decimal expires_in = 123;
        private String id_token='123'; 
        private String refresh_token='123';
    }
}