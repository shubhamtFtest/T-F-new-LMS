/******************************************************************
* Tests: ZTEST_TF_IndiaReprintAPI             90%
*******************************************************************/

@IsTest
private class ZTEST_TF_IndiaReprintAPI {
    private static final String baseUrl = Url.getSalesforceBaseUrl().toExternalForm();
    
    static testMethod void testPostMethod_Success(){
        String priceBookName = 'T&F India Pricebook';
        
        TF_IndiaReprintAPI.UpdateProductRequest oppdetails = new TF_IndiaReprintAPI.UpdateProductRequest();
        TF_IndiaReprintAPI.UpdateProductResponse dataAPIResponse = new TF_IndiaReprintAPI.UpdateProductResponse(); 

        //Create a user
        User u = zTEST_Shared.insertUser();
        //Create an account
        Account a = zTEST_Shared.insertAccount(u.Id);
        Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        Account accObject = new Account(Name = 'Test Account', RecordTypeId = TFAccountsRecordTypeId, Type = 'Customer'); 
        insert accObject;  
        
        //Create a product                 
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
        Product2 prodObject = new Product2(Name = 'Test Product', 
                                           RecordTypeId = TFProductsRecordTypeId,
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           ProductCode = '9780367001209',
                                           Readership_Level__c = 'Test',
                                           IsActive = true,
                                           Family = 'Journals-Author Side Charges');  
        insert prodObject;
        
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> priceBEList = new List<PricebookEntry>();
        PricebookEntry priceBE1 = new PricebookEntry(
            CurrencyIsoCode = 'INR',
            IsActive = True, 
            Pricebook2Id = standardPricebookId, 
            Product2Id = prodObject.Id,
            UnitPrice = 100.00);                                  
        priceBEList.add(priceBE1);                              
        insert priceBEList;
        
        Pricebook2 priceBook2 = new Pricebook2(Name = priceBookName, IsActive = True);
        insert priceBook2;
        
        List<PricebookEntry> priceBEList2 = new List<PricebookEntry>();
        PricebookEntry priceBE2 = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = priceBook2.Id, Product2Id = prodObject.Id,UnitPrice = 100.00);                                            
        priceBEList2.add(priceBE2);                              
        insert priceBEList2;
        
        //Create contact     
        Contact conObject = new Contact(AccountId = a.Id, FirstName = 'test', LastName = 'test');      
        insert conObject; 

        // Create an opportunity
        Id TFOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F - India Reprint').getRecordTypeId();
        Opportunity newOpp = new Opportunity(Name = 'Test Opportunity Name',
                                             Proposal_Type__c = 'Reprint',
                                             CurrencyIsoCode = 'INR',
                                             StageName = 'Prospect',
                                             CloseDate =system.today(),     
                                             AccountId = a.Id,
                                             RecordTypeId = TFOpportunityRecordTypeId);                
        
        insert newOpp; 
        
        //Add contact role to opportunity 
        OpportunityContactRole newContactRoleList = new OpportunityContactRole(ContactId = conObject.Id,OpportunityId = newOpp.Id,Role = 'Decision Maker',IsPrimary = true);
        insert newContactRoleList;     

        List<OpportunityLineItem> lstOLIInsert = new List<OpportunityLineItem>();         
        OpportunityLineItem oliNew = new OpportunityLineItem(
            OpportunityId = newOpp.Id, 
            Quantity = 5, 
            Required_Version_Type__c = 'Paperback',
            PricebookEntryId = priceBEList2[0].Id, 
            IR_Product_Type__c = 'Rerun'
        );
        lstOLIInsert.add(oliNew);               
        insert lstOLIInsert;
        
        String requestJSON = '{"status": true, "msg": "error message","opportunityId": "'+newOpp.Id+'", "runStatus": "Pass", "lineItems" : [{"productid" : "'+lstOLIInsert[0].Id+'", "isbn" : "9780367001209","status":"Pass", "remarks":"test remark"}]}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = baseUrl + '/services/apexrest/IndiaReprintService/updatProductStatus';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        System.debug('jsonTestClass::'+ requestJSON);        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_IndiaReprintAPI.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_IndiaReprintAPI.UpdateProductResponse response = (TF_IndiaReprintAPI.UpdateProductResponse)JSON.deserialize(responeJSON, TF_IndiaReprintAPI.UpdateProductResponse.class);       
        System.debug('msg-'+ response);   
    }
    
    static testMethod void testPostMethod_Fail1(){
        String priceBookName = 'T&F India Pricebook';
        
        TF_IndiaReprintAPI.UpdateProductRequest oppdetails = new TF_IndiaReprintAPI.UpdateProductRequest();
        TF_IndiaReprintAPI.UpdateProductResponse dataAPIResponse = new TF_IndiaReprintAPI.UpdateProductResponse(); 
        
        String requestJSON = '{"status": true, "msg": "error message","opportunityId": "0061X00000AL0lD", "lineItems" : [{"productid" : "00k1X000006CYQw", "isbn" : "9780367001209","status":"Pass", "remarks":"test remark"}]}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = baseUrl + '/services/apexrest/IndiaReprintService/updatProductStatus';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        System.debug('jsonTestClass::'+ requestJSON);        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_IndiaReprintAPI.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_IndiaReprintAPI.UpdateProductResponse response = (TF_IndiaReprintAPI.UpdateProductResponse)JSON.deserialize(responeJSON, TF_IndiaReprintAPI.UpdateProductResponse.class);       
        System.debug('msg-'+ response);   
    }
    
    static testMethod void testPostMethod_Fail2(){
        String priceBookName = 'T&F India Pricebook';
        
        TF_IndiaReprintAPI.UpdateProductRequest oppdetails = new TF_IndiaReprintAPI.UpdateProductRequest();
        TF_IndiaReprintAPI.UpdateProductResponse dataAPIResponse = new TF_IndiaReprintAPI.UpdateProductResponse(); 
        
        String requestJSON = '{"status": true, "msg": "error message","opportunityId": "", "runStatus": "Pass", "lineItems" : [{"productid" : "00k1X000006CYQw", "isbn" : "9780367001209","status":"Pass", "remarks":"test remark"}]}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = baseUrl + '/services/apexrest/IndiaReprintService/updatProductStatus';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        System.debug('jsonTestClass::'+ requestJSON);        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_IndiaReprintAPI.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_IndiaReprintAPI.UpdateProductResponse response = (TF_IndiaReprintAPI.UpdateProductResponse)JSON.deserialize(responeJSON, TF_IndiaReprintAPI.UpdateProductResponse.class);       
        System.debug('msg-'+ response);   
    }     
}