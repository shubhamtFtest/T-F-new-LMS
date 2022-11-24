@isTest
public class zTEST_TF_IndiaRePrintServiceCallout {
    private class RestMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            String fullJson = '{"IsSucceeded":true,"Message":"Login successful.","StatusCode":200,"Data":{"Active":null,"EmailAddress":"amit.kumar@tandfindia.com","FirstName":"Amit","LastName":"Kumar","UserDomain":null,"UserName":"kumara","DomainName":"APACCORPLAN","UserID":18,"UserRole":null,"Password":"","UserRoleId":4,"Token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IkFtaXQiLCJlbWFpbCI6ImFtaXQua3VtYXJAdGFuZGZpbmRpYS5jb20iLCJyb2xlIjoiNCIsIm5hbWVpZCI6IjE4IiwibmJmIjoxNTkzNDg5NTY2LCJleHAiOjE1OTM1MTgzNjYsImlhdCI6MTU5MzQ4OTU2NiwiaXNzIjoiaHR0cDovLzEwLjEuOTYuMTY0OjgwMTUvIiwiYXVkIjoiQ2xpZW50U2FsZXNGb3JjZUFwcCJ9.tLg3CbMCSLgGiRMyQ4HUeFSzW9wueIfvPHw7LvGXWZ8","SecretKey":"TW9zaGWFcmV6UHJpdmE0ZUtleR==","IsSalesForceUser":true,"DomainId":2}}';
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(fullJson);
            res.setStatusCode(200);
            return res;
        }
    }
    private static IndiaReprintSettings__c settingsInstance;
    static testMethod void testPostMethod_Success(){
        settingsInstance = new IndiaReprintSettings__c();
		settingsInstance.Token_URL__c='http://indiareprintsfapi-test.taylorandfrancis.com/api/Login/Validate';
        settingsInstance.Reprint_Eligibility_API_URL__c='http://indiareprintsfapi-test.taylorandfrancis.com/api/Proposal/SaveManualProposal';
		insert settingsInstance;  
        contact cc=new contact();
        cc.lastname='rew';
        insert cc;
        String priceBookName = 'T&F India Pricebook';
        User u = zTEST_Shared.insertUser();
        User newusr = zTEST_Shared.insertUser();
        
        Id accountRecordtypeId = MiscFunctions.getRecordtypeId('Account', 'T&F - Accounts');
        //create test account
        Account testacc = new Account();
        testacc.RecordTypeId = accountRecordtypeId;
        testacc.Name = 'test';
        testacc.OwnerId = u.Id;
        testacc.Sales_Contact_Person__c = u.Id;
        insert testacc;
        
        //create demo account
        Account demoacc = new Account();               
        demoacc.RecordTypeId = accountRecordtypeId;
        demoacc.Name = 'demo';
        demoacc.OwnerId = u.Id;
        demoacc.Sales_Contact_Person__c = newusr.Id;
        insert demoacc;
        
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');       
        Product2 prdObj = createProductTestData();
        
        //create an opportunity
        Opportunity opp = new Opportunity();
        Date startDate = date.newInstance(2020, 02, 20);
        Date closeDate = Date.today().addDays(30);
        opp.name = 'test';
        opp.Proposal_Type__c = 'Reprint';
        opp.AccountId = testacc.Id;
        opp.RecordTypeId = oppRecordtypeId;
        opp.StageName = 'Prospect';
        opp.CloseDate = closeDate;
        opp.OwnerId = u.Id;
        insert opp;
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> priceBEList = new List<PricebookEntry>();
        PricebookEntry priceBE1 = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        priceBEList.add(priceBE1);                              
        insert priceBEList;
        
        Pricebook2 priceBook2 = new Pricebook2(Name = priceBookName, IsActive = True);
        insert priceBook2;
        
        List<PricebookEntry> priceBEList2 = new List<PricebookEntry>();
        PricebookEntry priceBE2 = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = priceBook2.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
        priceBEList2.add(priceBE2);                              
        insert priceBEList2;
        List<OpportunityLineItem> lstOLIInsert = new List<OpportunityLineItem>();         
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                          PricebookEntryId = priceBEList2[0].Id, 
                                                          IR_Product_Type__c = 'Rerun',
                                                          Distributor__c = testacc.Id
                                                         );
        lstOLIInsert.add(oli);               
        insert lstOLIInsert; 
        Test.setMock(HttpCalloutMock.class, new RestMock());
        Test.startTest();
        TF_IndiaRePrintServiceCallout.checkEligibility(opp.Id, lstOLIInsert);
        TF_IndiaRePrintServiceCallout.sendReprintEligibilityEmailNotification(opp.id);
        TF_IndiaRePrintServiceCallout.updateOpportunityEligibilityRequest(opp.id);

        Test.StopTest();
        
        
    }
    
    private static Product2 createProductTestData() {
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 product = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);
        product.name='test';
        product.IsActive=true;
        product.Description='test';
        product.RecordTypeId=productRecordtypeId;
        product.ProductCode='9780367463151';       
        insert product;
        return product;
    }    
}