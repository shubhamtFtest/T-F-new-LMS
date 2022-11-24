@IsTest
private class Ztest_TF_DataAPIService
{
 
 private static final String baseUrl = Url.getSalesforceBaseUrl().toExternalForm();

 static testMethod void testPostMethod1(){
    String priceBookName = 'T&F CPQ Price Book 2017';
    Quote_Service_Settings__c customSetting = new Quote_Service_Settings__c(Name = 'Informa Plc', TF_Ebook_Opportunity_RecordType__c = '0120Y000000Wn8Y', eBook_PriceBook__c = '01s0Y00000832cj', Standard_PriceBook__c ='01s0Y0000082Fix', T_F_Online_User__c='0050Y000002ItxQ');
    insert customSetting; 
     
    TF_DataAPIService.createLeadRequest leaddetails = new TF_DataAPIService.createLeadRequest();
    TF_DataAPIService.TFDataAPIResponse dataAPIResponse = new TF_DataAPIService.TFDataAPIResponse(); 
    leaddetails.firstName = 'Test First Name';
    leaddetails.lastName= 'Test Last Name';
    leaddetails.company= 'SRS Univerity';
    leaddetails.leadSource= 'Customer Interaction';
    leaddetails.ringgold= '12233';
    leaddetails.jobCategory= 'TestCat';
    leaddetails.leadStatus= 'Contacted';
    leaddetails.phone= '1233456575758';
    leaddetails.email= 'alex.job@srsuniveristy.com';
    leaddetails.temperature= 'Red';
    leaddetails.promotionName= 'SDE0099EDR';
    leaddetails.business= 'ebooks';  
    leaddetails.address = new TF_DataAPIService.ContactAddress();    
    leaddetails.address.city = 'Test City';
    leaddetails.address.street = 'Test Street';
    leaddetails.address.state = 'KA';
    leaddetails.address.country = 'India';
    leaddetails.address.zipCode = '000000';
    leaddetails.address.zip = '000000';
                                
    leaddetails.product = new TF_DataAPIService.ProductDetails();
    Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
    Product2 prodObject = new Product2(Name = 'Test Product', 
                                RecordTypeId = TFProductsRecordTypeId,
                                CPQ_Category__c = 'Technology',
                                Article_Type__c = 'Letter',
                                Sales_Organization__c = 'NA',
                                Open_Access_Category__c = 'Open',
                                ProductCode = 'XYZ',
                                Readership_Level__c = 'Test',
                                IsActive = true,
                                Family = 'Journals-Author Side Charges');  
    insert prodObject;
     
    //leaddetails.product.salesforceID = prodObject.Id;    
    leaddetails.product.name = 'Introducing public administration';  
    leaddetails.product.salesforceID = prodObject.Id;

    Lead ledObject = new Lead(Company='Test Company',Email='test@test.com',Status='Open',LeadSource='Customer Interaction',
                                firstName='Test First Name',lastName='Test Last Name',Department__c='IT',
                                Country_List__c='India',State_List__c='AK',Business__c='ebooks');
    insert ledObject;     
     
    Note note = new Note();
    note.ParentId = ledObject.id;
    note.Title = 'Note title';
    note.Body = 'Lead Request Information';
    insert note;     
     note nt=[select title from Note where parentid=:ledObject.id];
     system.debug(nt.title);
    
    String requestJSON = JSON.serialize(leaddetails);
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();

    req.requestURI = baseUrl + '/services/apexrest/dataService/v1.0/createLead';  
    req.requestBody = Blob.valueOf(requestJSON);
    req.httpMethod = 'POST';
            
    RestContext.request = req;
    RestContext.response = res;
    
    Test.startTest();
    TF_DataAPIService.doPost();
    Test.stopTest();
    String responeJSON = RestContext.response.responseBody.toString();
    TF_DataAPIService.TFDataAPIResponse response = (TF_DataAPIService.TFDataAPIResponse)JSON.deserialize(responeJSON, TF_DataAPIService.TFDataAPIResponse.class);
    
    //System.debug('msg-'+ response);
    System.assertEquals(null, response.errorMessage);
    System.assertEquals(true, response.success);
 }
 
 static testMethod void testPostMethod2(){
    String priceBookName = 'T&F CPQ Price Book 2017';
    Quote_Service_Settings__c customSetting = new Quote_Service_Settings__c(Name = 'Informa Plc', TF_Ebook_Opportunity_RecordType__c = '0120Y000000Wn8Y', eBook_PriceBook__c = '01s0Y00000832cj', Standard_PriceBook__c ='01s0Y0000082Fix', T_F_Online_User__c='0050Y000002ItxQ');
    insert customSetting;  
    TF_DataAPIService.createOpportunityRequest oppdetails = new TF_DataAPIService.createOpportunityRequest();
    TF_DataAPIService.TFDataAPIResponse dataAPIResponse = new TF_DataAPIService.TFDataAPIResponse(); 
    
    oppdetails.opportunityType = 'eBook';
    oppdetails.opportunityName = 'Test Trial - CRCnetBASE';
    oppdetails.type = 'New Business';
    oppdetails.orderType = 'Trial';
    oppdetails.leadSource = 'Customer Interaction';
    oppdetails.leadSourceDetail = 'Inbound customer call/email';
    oppdetails.opportunityCurrency = 'USD';
    oppdetails.stage = 'Investigating';
    oppdetails.closeDate = date.ValueOf('2016-07-25');
    oppdetails.productFamily = 'netBase';
    oppdetails.productInterestCategory = 'eBooks';
    oppdetails.trialStart = date.ValueOf('2017-07-25');
    oppdetails.trialEnd = date.ValueOf('2017-08-25');
      
    //Create an account
    Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
    Account accObject = new Account(Name = 'Test Account', RecordTypeId = TFAccountsRecordTypeId,Type = 'Customer'); 
    insert accObject;  
       
    // Create an opportunity
    Id TFOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F - eBooks Opportunity').getRecordTypeId();
    Opportunity newOpp = new Opportunity(Name = 'Test Opportunity Name',
                                        Type = 'New Business',
                                        Order_Type__c = 'Trial',
                                        leadSource = 'Customer Interaction',
                                        Lead_Source_Detail__c = 'Inbound customer call/email',
                                        CurrencyIsoCode = 'USD',
                                        StageName = 'stage',
                                        CloseDate = date.ValueOf('2017-07-25'),
                                        Product_Family__c = 'netbase',
                                        Product_Interest_Category__c = 'cat',                   
                                        Trial_Start__c = date.ValueOf('2017-07-25'),
                                        Trial_End__c = date.ValueOf('2017-07-25'),      
                                        AccountId = accObject.Id,
                                        RecordTypeId = TFOpportunityRecordTypeId);                
           
    insert newOpp; 
    
    //Create a product                 
    oppdetails.product = new TF_DataAPIService.ProductDetails();
    Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
    Product2 prodObject = new Product2(Name = 'Test Product', 
                                RecordTypeId = TFProductsRecordTypeId,
                                CPQ_Category__c = 'Technology',
                                Article_Type__c = 'Letter',
                                Sales_Organization__c = 'NA',
                                Open_Access_Category__c = 'Open',
                                ProductCode = 'XYZ',
                                Readership_Level__c = 'Test',
            IsActive = true,
            Family = 'Journals-Author Side Charges');  
    insert prodObject;
        
    String standardPricebookId = Test.getStandardPricebookId();
    List<PricebookEntry> priceBEList = new List<PricebookEntry>();
    PricebookEntry priceBE1 = new PricebookEntry(
                                    CurrencyIsoCode = 'USD',
                                    IsActive = True, 
                                    Pricebook2Id = standardPricebookId, 
                                    Product2Id = prodObject.Id,
                                    UnitPrice = 100.00);                                  
    priceBEList.add(priceBE1);                              
    insert priceBEList;
    
    Pricebook2 priceBook2 = new Pricebook2(Name = priceBookName, IsActive = True);
    insert priceBook2;
    
    List<PricebookEntry> priceBEList2 = new List<PricebookEntry>();
    PricebookEntry priceBE2 = new PricebookEntry(CurrencyIsoCode = 'USD',IsActive = True, Pricebook2Id = priceBook2.Id, Product2Id = prodObject.Id,UnitPrice = 100.00);                                            
    priceBEList2.add(priceBE2);                              
    insert priceBEList2;
    
    //Create contact     
    Contact conObject = new Contact(AccountId = accObject.Id,FirstName = 'test',LastName = 'test');      
    insert conObject; 
     
    //Add contact role to opportunity 
    OpportunityContactRole newContactRoleList = new OpportunityContactRole(ContactId = conObject.Id,
                                                     OpportunityId = newOpp.Id,
                                                     Role = 'Decision Maker',
                                                     IsPrimary = true);
     insert newContactRoleList;     
     
    oppdetails.product.salesforceID = prodObject.Id;
    oppdetails.product.name = 'Introducing public administration';
    oppdetails.product.salesPrice = 1.23; 
     
    oppdetails.account = new TF_DataAPIService.AccountDetails();    
     
    oppdetails.account.salesforceID = accObject.Id;
    oppdetails.account.ringgold = '1234';
    
    oppdetails.contact = new TF_DataAPIService.ContactDetails();
    oppdetails.contact.salesforceID = conObject.Id;
    oppdetails.contact.email = 'alex.bob@gmail.com';
    oppdetails.contact.role = 'Decision Maker';

    String requestJSON = JSON.serialize(oppdetails);
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();

    req.requestURI = baseUrl + '/services/apexrest/dataService/v1.0/createOpportunity';  
    req.requestBody = Blob.valueOf(requestJSON);
    req.httpMethod = 'POST';
    //System.debug('json-'+ requestJSON);        
    RestContext.request = req;
    RestContext.response = res;
     
    Test.startTest();
    TF_DataAPIService.doPost();
    Test.stopTest();
    String responeJSON = RestContext.response.responseBody.toString();
    TF_DataAPIService.TFDataAPIResponse response = (TF_DataAPIService.TFDataAPIResponse)JSON.deserialize(responeJSON, TF_DataAPIService.TFDataAPIResponse.class);
    
    //System.debug('msg-'+ response);
    System.assertEquals(null, response.errorMessage); 
    System.assertEquals(true, response.success);     
 }

  static testMethod void testPostMethod3(){
    String priceBookName = 'T&F CPQ Price Book 2017';
    Quote_Service_Settings__c customSetting = new Quote_Service_Settings__c(Name = 'Informa Plc', TF_Ebook_Opportunity_RecordType__c = '0120Y000000Wn8Y', eBook_PriceBook__c = '01s0Y00000832cj', Standard_PriceBook__c ='01s0Y0000082Fix', T_F_Online_User__c='0050Y000002ItxQ');
    insert customSetting; 
     
    TF_DataAPIService.createLeadRequest leaddetails = new TF_DataAPIService.createLeadRequest();
    TF_DataAPIService.TFDataAPIResponse dataAPIResponse = new TF_DataAPIService.TFDataAPIResponse(); 
    leaddetails.firstName = 'Test First Name';
    leaddetails.lastName= 'Test Last Name';
    leaddetails.company= 'SRS Univerity';
    leaddetails.leadSource= 'Customer Interaction';
    leaddetails.ringgold= '12233';
    leaddetails.jobCategory= 'TestCat';
    leaddetails.leadStatus= 'Contacted';
    leaddetails.phone= '1233456575758';
    leaddetails.email= 'alex.job@srsuniveristy.com';
    leaddetails.temperature= 'Red';
    leaddetails.promotionName= 'SDE0099EDR';
    leaddetails.business= 'ebooks';  
    leaddetails.address = new TF_DataAPIService.ContactAddress();    
    leaddetails.address.city = 'Test City';
    leaddetails.address.street = 'Test Street';
    leaddetails.address.state = 'KA';
    leaddetails.address.country = 'India';
    leaddetails.address.zipCode = '000000';
    leaddetails.address.zip = '000000';
                                
    leaddetails.product = new TF_DataAPIService.ProductDetails();
    Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
     
    //leaddetails.product.salesforceID = prodObject.Id;    
    leaddetails.product.name = 'Introducing public administration';  
  
    
    String requestJSON = JSON.serialize(leaddetails);
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();

    req.requestURI = baseUrl + '/services/apexrest/dataService/v1.0/createLead';  
    req.requestBody = Blob.valueOf(requestJSON);
    req.httpMethod = 'POST';
            
    RestContext.request = req;
    RestContext.response = res;
    
    Test.startTest();
    TF_DataAPIService.doPost();
    Test.stopTest();
    String responeJSON = RestContext.response.responseBody.toString();
    TF_DataAPIService.TFDataAPIResponse response = (TF_DataAPIService.TFDataAPIResponse)JSON.deserialize(responeJSON, TF_DataAPIService.TFDataAPIResponse.class);
    
    //System.debug('msg-'+ response);
    System.assertEquals(null, response.errorMessage);
    System.assertEquals(true, response.success);
 }


}