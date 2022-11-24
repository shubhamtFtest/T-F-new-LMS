/**********************************************************************
//This is test class for class "TF_LicenseAPIService"

***********************************************************************/

@isTest
public class zTEST_TF_LicenseAPIService {
    static Account acc;
    static Account acc2;
    static Product2 p;
    //static Opportunity opp;
    //static OpportunityLineItem oli;
    static final String baseUrl = Url.getSalesforceBaseUrl().toExternalForm();
    static List<License__c> licenseList = new List<License__c>();
    
    public static void setup()
    {
        //Create a Account record
        acc = new Account();
        acc.Name ='Test';
        acc.Type = 'Consortium';
        acc.Customer_Id__c = '12345';
        insert acc;
        
        //Create a Account record
        acc2 = new Account();
        acc2.Name ='Test2';
        acc2.Type = 'Consortium';
        acc2.Customer_Id__c = '123456';
        insert acc2;
        
        //Create a Product record
        p = new Product2();
        p.Name = 'Test_Pro';
        p.isActive = true;
        p.Hub_Id__c = 'Hub Id 9999999999';
        p.Family = 'Collections';
        p.inLanguage__c = 'en';
        insert p;
        
        //Creating standard price book entry
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = p.Id, UnitPrice = 100, IsActive = true);
        insert standardPrice;
        
        //Creating a custom Pricebook
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        //Creating custom price book entry
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = p.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        /*
        //Creating Opportunity record
        opp = new Opportunity();
        Id Record_type_id = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F - One-Off Opportunity').getRecordTypeId();
        opp.Name = 'test2';
        opp.StageName = 'Investigating';
        opp.Start_Date__c = System.today();
        opp.CloseDate = System.today().addDays(9);
        opp.Type ='Renewal';
        opp.LeadSource = 'Direct';
        opp.Volume_Year__c = 'a' ;
        opp.AccountId = acc.Id;        
        insert opp;
        
        //Creating Opportunity Line item
        oli = new OpportunityLineItem();
        oli.OpportunityId = opp.Id;
        oli.Product2Id = p.Id;
        oli.Quantity = 12;
        oli.UnitPrice = 67;
        oli.Net_Price__c = 25;
        oli.Invoice_Date__c = System.today().addDays(5);
        oli.Invoice_Number__c = '1289';
        oli.TotalPrice_GBP__c = 10;
        oli.PriceBookEntryId = customPrice.id;
        insert oli;
        */
        //Creating license list        
        licenseList.add( new License__c( Customer__c = acc.id, Product__c = p.id, Order_Number__c = 'Test ON', License_Type__c = 'Trial', Grant_Type__c = 'View; Download', Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'Active' ) );
        licenseList.add( new License__c( Customer__c = acc2.id, Product__c = p.id, Order_Number__c = 'Test ON2', License_Type__c = 'Subscription', Grant_Type__c = 'Download', Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'Active' ) );
        //licenseList.add( new License__c( Customer__c = acc.id, Product__c = p.id, Order_Number__c = 'Test ON', License_Type__c = 'Perpetual', Grant_Type__c = 'View; Download', Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'Active' ) );
        insert licenseList; 
            
        /*
        //Creating Account to Opportunity record
        List<Account_To_Opportunity__c> accToOppList = new List<Account_To_Opportunity__c>();
        accToOppList.add( new Account_To_Opportunity__c( Account__c = acc.id, Opportunity__c = opp.id ) );
        accToOppList.add( new Account_To_Opportunity__c( Account__c = acc2.id, Opportunity__c = opp.id ) );
        insert accToOppList;
        */
    }
    
    //Covering the updateValidation method
    static TestMethod void testStatus() {
        setup();
        
        //Initializing rest resource variables
        TF_LicenseAPIService.UpdateEntitlementResponse updateWrapper = new TF_LicenseAPIService.UpdateEntitlementResponse();
        updateWrapper.licenseID = licenseList[0].id;
        updateWrapper.status = 'created';
        updateWrapper.Type = 'AddLicense';
        updateWrapper.message = '';
        
        TF_LicenseAPIService.UpdateEntitlementStatusRequest updateResponse = new TF_LicenseAPIService.UpdateEntitlementStatusRequest();
        updateResponse.response = new List<TF_LicenseAPIService.UpdateEntitlementResponse>();
        updateResponse.response.add(updateWrapper);
        
        String licenseJSON = JSON.serialize(updateResponse);
        
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/LicenseService/updateEntitlementStatus';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(licenseJSON);
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIService.doPost();
        Test.stopTest();
        
        List<License__c> licenseCheck = [SELECT id, Entitlement_Creation_Status__c FROM License__c WHERE Entitlement_Creation_Status__c = 'created'];
        System.assertEquals( 1, licenseCheck.size() );        
    }
    
    //method to test different license ID
    static TestMethod void testDifferentLicenseID() {
        setup();
        
        //Initializing rest resource variables
        TF_LicenseAPIService.UpdateEntitlementResponse updateWrapper = new TF_LicenseAPIService.UpdateEntitlementResponse();
        updateWrapper.licenseID = licenseList[0].id;
        updateWrapper.status = 'failed';
        updateWrapper.Type = 'AddLicense';
        updateWrapper.message = 'not found';
        
        TF_LicenseAPIService.UpdateEntitlementStatusRequest updateResponse = new TF_LicenseAPIService.UpdateEntitlementStatusRequest();
        updateResponse.response = new List<TF_LicenseAPIService.UpdateEntitlementResponse>();
        updateResponse.response.add(updateWrapper);
        
        String licenseJSON = JSON.serialize(updateResponse);
        
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/LicenseService/updateEntitlementStatus';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(licenseJSON);
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIService.doPost();
        Test.stopTest();
        
        List<License__c> licenseCheck = [SELECT id, Entitlement_Creation_Status__c FROM License__c WHERE Entitlement_Creation_Status__c = 'failed'];
        System.assertEquals( 1, licenseCheck.size() );        
    }
    
    //method to cover updateValidation
    static TestMethod void Test_Status() {
        setup();
        
        //Initializing rest resource variables
        TF_LicenseAPIService.UpdateEntitlementResponse updateWrapper = new TF_LicenseAPIService.UpdateEntitlementResponse();
        updateWrapper.licenseID = licenseList[0].id;
        updateWrapper.status = 'failed';
        updateWrapper.Type = 'UpdateLicense';
        updateWrapper.message = 'TEst';
        
        TF_LicenseAPIService.UpdateEntitlementStatusRequest updateResponse = new TF_LicenseAPIService.UpdateEntitlementStatusRequest();
        updateResponse.response = new List<TF_LicenseAPIService.UpdateEntitlementResponse>();
        updateResponse.response.add(updateWrapper);
        
        String licenseJSON = JSON.serialize(updateResponse);
        
        Test.startTest();
        RestRequest request3 = new RestRequest();
        RestResponse response3 = new RestResponse();
        request3.requestUri = baseUrl + '/services/apexrest/LicenseService/updateEntitlementStatus';
        request3.httpMethod = 'POST';
        request3.requestBody = Blob.valueOf(licenseJSON);
        RestContext.request = request3;
        RestContext.response = response3;
        TF_LicenseAPIService.doPost();
        Test.stopTest();
         
        List<License__c> licenseCheck = [SELECT id, Entitlement_Creation_Status__c FROM License__c WHERE Entitlement_Creation_Status__c = 'failed'];
        System.assertEquals( 1, licenseCheck.size() );     
    }
    
    //To cover the updateValidation method - if the license Type is HaspArtUpdate
    static TestMethod void testLicenseId() {
        setup();
  
        //Initializing rest resource variables
        TF_LicenseAPIService.UpdateEntitlementResponse updateWrapper = new TF_LicenseAPIService.UpdateEntitlementResponse();
        updateWrapper.licenseID = licenseList[0].id;
        updateWrapper.status = 'failed';
        updateWrapper.Type = 'HasPartUpdate';
        updateWrapper.message = 'Test';
        
        TF_LicenseAPIService.UpdateEntitlementStatusRequest updateResponse = new TF_LicenseAPIService.UpdateEntitlementStatusRequest();
        updateResponse.response = new List<TF_LicenseAPIService.UpdateEntitlementResponse>();
        updateResponse.response.add(updateWrapper);
        
        String licenseJSON = JSON.serialize(updateResponse);
        
        Test.startTest();
        RestRequest request5 = new RestRequest();
        RestResponse response5 = new RestResponse();
        request5.requestUri = baseUrl + '/services/apexrest/LicenseService/updateEntitlementStatus';
        request5.httpMethod = 'POST';
        request5.requestBody = Blob.valueOf(licenseJSON);
        RestContext.request = request5;
        RestContext.response = response5;
        TF_LicenseAPIService.doPost();
        Test.stopTest();        
    }
    
    //method to test blank license id
    static TestMethod void testBlankLicense() {
        setup();
        
        //Initializing rest resource variables
        TF_LicenseAPIService.UpdateEntitlementResponse updateWrapper = new TF_LicenseAPIService.UpdateEntitlementResponse();
        updateWrapper.licenseID = '';
        updateWrapper.status = 'failed';
        updateWrapper.Type = 'HasPartUpdate';
        updateWrapper.message = 'Messageeeeee';
        
        TF_LicenseAPIService.UpdateEntitlementStatusRequest updateResponse = new TF_LicenseAPIService.UpdateEntitlementStatusRequest();
        updateResponse.response = new List<TF_LicenseAPIService.UpdateEntitlementResponse>();
        updateResponse.response.add(updateWrapper);
        
        String licenseJSON = JSON.serialize(updateResponse);
        
        
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/LicenseService/updateEntitlementStatus';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(licenseJSON);
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIService.doPost();
        Test.stopTest();
    }
    
    //method to test blank response
    static TestMethod void testBlankResponse() {

        TF_LicenseAPIService.UpdateEntitlementStatusRequest updateResponse = new TF_LicenseAPIService.UpdateEntitlementStatusRequest();
        updateResponse.response = new List<TF_LicenseAPIService.UpdateEntitlementResponse>();

        String licenseJSON = JSON.serialize(updateResponse);
        
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/LicenseService/updateEntitlementStatus';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(licenseJSON);
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIService.doPost();
        Test.stopTest();
    }
    
    //method to test wrong license id
    static TestMethod void testWrongLicenseId() {
        setup();
        
        //Initializing rest resource variables
        TF_LicenseAPIService.UpdateEntitlementResponse updateWrapper = new TF_LicenseAPIService.UpdateEntitlementResponse();
        updateWrapper.licenseID = licenseList[0].id+'gtgtgt4589838890';
        updateWrapper.status = 'created';
        updateWrapper.Type = 'AddLicense';
        updateWrapper.message = '';
        
        TF_LicenseAPIService.UpdateEntitlementStatusRequest updateResponse = new TF_LicenseAPIService.UpdateEntitlementStatusRequest();
        updateResponse.response = new List<TF_LicenseAPIService.UpdateEntitlementResponse>();
        updateResponse.response.add(updateWrapper);
        
        String licenseJSON = JSON.serialize(updateResponse);
        
        
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/LicenseService/updateEntitlementStatus';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(licenseJSON);
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIService.doPost();
        Test.stopTest();
    }
    
    //method to test blank status
    static TestMethod void testBlankStatus() {
        setup();
        
        //Initializing rest resource variables
        TF_LicenseAPIService.UpdateEntitlementResponse updateWrapper = new TF_LicenseAPIService.UpdateEntitlementResponse();
        updateWrapper.licenseID = licenseList[0].id;
        updateWrapper.status = '';
        updateWrapper.Type = 'AddLicense';
        updateWrapper.message = 'test';
        
        TF_LicenseAPIService.UpdateEntitlementStatusRequest updateResponse = new TF_LicenseAPIService.UpdateEntitlementStatusRequest();
        updateResponse.response = new List<TF_LicenseAPIService.UpdateEntitlementResponse>();
        updateResponse.response.add(updateWrapper);
        
        String licenseJSON = JSON.serialize(updateResponse);
        
        
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/LicenseService/updateEntitlementStatus';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(licenseJSON);
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIService.doPost();
        Test.stopTest();
    }
    
    //method to test other status
    static TestMethod void testOtherStatus() {
        setup();
        
        //Initializing rest resource variables
        TF_LicenseAPIService.UpdateEntitlementResponse updateWrapper = new TF_LicenseAPIService.UpdateEntitlementResponse();
        updateWrapper.licenseID = licenseList[0].id;
        updateWrapper.status = 'other';
        updateWrapper.Type = 'AddLicense';
        updateWrapper.message = 'test';
        
        TF_LicenseAPIService.UpdateEntitlementStatusRequest updateResponse = new TF_LicenseAPIService.UpdateEntitlementStatusRequest();
        updateResponse.response = new List<TF_LicenseAPIService.UpdateEntitlementResponse>();
        updateResponse.response.add(updateWrapper);
        
        String licenseJSON = JSON.serialize(updateResponse);
        
        
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/LicenseService/updateEntitlementStatus';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(licenseJSON);
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIService.doPost();
        Test.stopTest();
    }
    
    //method to test other status
    static TestMethod void testBlankType() {
        setup();
        
        //Initializing rest resource variables
        TF_LicenseAPIService.UpdateEntitlementResponse updateWrapper = new TF_LicenseAPIService.UpdateEntitlementResponse();
        updateWrapper.licenseID = licenseList[0].id;
        updateWrapper.status = 'created';
        updateWrapper.Type = '';
        updateWrapper.message = 'test';
        
        TF_LicenseAPIService.UpdateEntitlementStatusRequest updateResponse = new TF_LicenseAPIService.UpdateEntitlementStatusRequest();
        updateResponse.response = new List<TF_LicenseAPIService.UpdateEntitlementResponse>();
        updateResponse.response.add(updateWrapper);
        
        String licenseJSON = JSON.serialize(updateResponse);
        
        
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/LicenseService/updateEntitlementStatus';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(licenseJSON);
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIService.doPost();
        Test.stopTest();
    }
    
    //method to test other status
    static TestMethod void testOtherType() {
        setup();
        
        //Initializing rest resource variables
        TF_LicenseAPIService.UpdateEntitlementResponse updateWrapper = new TF_LicenseAPIService.UpdateEntitlementResponse();
        updateWrapper.licenseID = licenseList[0].id;
        updateWrapper.status = 'created';
        updateWrapper.Type = 'AddDeLicense';
        updateWrapper.message = 'test';
        
        TF_LicenseAPIService.UpdateEntitlementStatusRequest updateResponse = new TF_LicenseAPIService.UpdateEntitlementStatusRequest();
        updateResponse.response = new List<TF_LicenseAPIService.UpdateEntitlementResponse>();
        updateResponse.response.add(updateWrapper);
        
        String licenseJSON = JSON.serialize(updateResponse);
        
        
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/LicenseService/updateEntitlementStatus';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(licenseJSON);
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIService.doPost();
        Test.stopTest();
    }
    
    /*
    //method to cover both grant type
    static TestMethod void test() {
        setup();
        
        //opp.StageName = 'Closed Won';
        //update opp;
        
        //Creating request grant type list
        List<String> reqGrantTypeList = new List<String>();
        reqGrantTypeList.add('View');
        reqGrantTypeList.add('Download');
        
        //Initializing rest resouce variables
        TF_LicenseAPIService.CreateLicenseRequest request = new TF_LicenseAPIService.CreateLicenseRequest();
        request.salesforceID = opp.id;
        request.licenseType = 'Perpetual';
        request.orderNumber= '1198785496';
        request.startDate = Date.today();
        request.endDate = Date.today().addDays(5);
        request.purchaseDate = Date.today();
        request.grantType = reqGrantTypeList;
        
        String myJSON = JSON.serialize(request);
        
        Test.startTest();
        RestRequest request1 = new RestRequest();
        RestResponse res = new RestResponse();
        request1.requestUri = baseUrl + '/services/apexrest/LicenseService/createLicense';
        request1.httpMethod = 'POST';
        request1.requestBody = Blob.valueof(myJSON);
        RestContext.request = request1;
        RestContext.response = res;
        TF_LicenseAPIService.doPost();
        Test.stopTest();
    }
    
    //method to call only one grant Type
    static TestMethod void test2() {
        setup();
        
        opp.StageName = 'Closed Won';
        update opp;
        
        //Creating request grant type list
        List<String> reqGrantTypeList = new List<String>();
        reqGrantTypeList.add('View');

        //Initializing rest resouce variables
        TF_LicenseAPIService.CreateLicenseRequest request = new TF_LicenseAPIService.CreateLicenseRequest();
        request.salesforceID      = opp.id;
        request.licenseType    = 'Perpetual';
        request.orderNumber   = '1198785496';
        request.startDate = Date.today();
        request.endDate = Date.today().addDays(5);
        request.purchaseDate = Date.today();
        request.grantType = reqGrantTypeList;
        
        String myJSON = JSON.serialize(request);
        
        Test.startTest();
        RestRequest request1 = new RestRequest();
        RestResponse res = new RestResponse();
        request1.requestUri = baseUrl + '/services/apexrest/LicenseService/createLicense';
        request1.httpMethod = 'POST';
        request1.requestBody = Blob.valueof(myJSON);
        RestContext.request = request1;
        RestContext.response = res;
        TF_LicenseAPIService.doPost();
        Test.stopTest();
    }
    
    
    //to cover validate method case - if Grant Type is NULL
    static TestMethod void test3() {
        setup();
        
        opp.StageName = 'Closed Won';
        update opp;
        
        //Creating request grant type list
        List<String> reqGrantTypeList = new List<String>(); //to cover test case
        //reqGrantTypeList.add('View');

        //Initializing rest resouce variables
        TF_LicenseAPIService.CreateLicenseRequest request = new TF_LicenseAPIService.CreateLicenseRequest();
        request.salesforceID = opp.id;
        request.licenseType = 'Subscription';
        request.orderNumber = '1198785496';
        request.startDate = Date.today();
        request.endDate = Date.today().addDays(5);
        request.purchaseDate = Date.today();
        request.grantType = reqGrantTypeList; //to cover catch block
        
        String myJSON = JSON.serialize(request);
        
        Test.startTest();
        RestRequest request1 = new RestRequest();
        RestResponse res = new RestResponse();
        request1.requestUri = baseUrl + '/services/apexrest/LicenseService/createLicense';
        request1.httpMethod = 'POST';
        request1.requestBody = Blob.valueof(myJSON);
        RestContext.request = request1;
        RestContext.response = res;
        TF_LicenseAPIService.doPost();

        RestRequest request2 = new RestRequest();
        RestResponse res2 = new RestResponse();
        request2.requestUri = baseUrl + '/services/apexrest/LicenseService';
        request2.httpMethod = 'POST';
        request2.requestBody = Blob.valueof(myJSON);
        RestContext.request = request2;
        RestContext.response = res2;
        TF_LicenseAPIService.doPost();
        Test.stopTest();
    }
    
    //to cover validate method case - if License Type is different
    static testMethod void test4() {
        setup();
        
        opp.StageName = 'Closed Won';
        update opp;
        
        //Creating request grant type list
        List<String> reqGrantTypeList = new List<String>();
        reqGrantTypeList.add('View');
        reqGrantTypeList.add('Download');
        
        //Initializing rest resouce variables
        TF_LicenseAPIService.CreateLicenseRequest request = new TF_LicenseAPIService.CreateLicenseRequest();
        request.salesforceID      = opp.id;
        request.licenseType    = 'Test'; //License Type different to cover test case
        request.orderNumber   = '1198785496';
        request.startDate = Date.today();
        request.endDate = Date.today().addDays(5);
        request.purchaseDate = Date.today();
        request.grantType = reqGrantTypeList;
        
        String myJSON = JSON.serialize(request);
        
        Test.startTest();
        RestRequest request1 = new RestRequest();
        RestResponse res = new RestResponse();
        request1.requestUri = baseUrl + '/services/apexrest/LicenseService/createLicense';
        request1.httpMethod = 'POST';
        request1.requestBody = Blob.valueof(myJSON);
        RestContext.request = request1;
        RestContext.response = res;
        TF_LicenseAPIService.doPost();
        Test.stopTest();
    }
    
    //to cover validate method case - if start date is greater than end date
    static testMethod void test5() {
        setup();
        
        opp.StageName = 'Closed Won';
        update opp;
        
        //Creating request grant type list
        List<String> reqGrantTypeList = new List<String>();
        reqGrantTypeList.add('View');
        reqGrantTypeList.add('Download');
        
        //Initializing rest resouce variables
        TF_LicenseAPIService.CreateLicenseRequest request = new TF_LicenseAPIService.CreateLicenseRequest();
        request.salesforceID      = opp.id;
        request.licenseType    = 'Perpetual';
        request.orderNumber   = '1198785496';
        request.startDate = Date.today();
        request.endDate = Date.today().addDays(-5); //start date is greater than end date to cover test case
        request.purchaseDate = Date.today();
        request.grantType = reqGrantTypeList;
        
        String myJSON = JSON.serialize(request);
        
        Test.startTest();
        RestRequest request1 = new RestRequest();
        RestResponse res = new RestResponse();
        request1.requestUri = baseUrl + '/services/apexrest/LicenseService/createLicense';
        request1.httpMethod = 'POST';
        request1.requestBody = Blob.valueof(myJSON);
        RestContext.request = request1;
        RestContext.response = res;
        TF_LicenseAPIService.doPost();
        Test.stopTest();
    }
    
    //to cover validate method case - SalesforceId
    static testMethod void test6() {
        setup();
        
        opp.StageName = 'Closed Won';
        update opp;
        
        //Creating request grant type list
        List<String> reqGrantTypeList = new List<String>();
        reqGrantTypeList.add('View');
        reqGrantTypeList.add('Download');
        
        //Initializing rest resouce variables
        TF_LicenseAPIService.CreateLicenseRequest request = new TF_LicenseAPIService.CreateLicenseRequest();
        request.salesforceID      = opp.id+'tdrtreg'; //to cover test case
        request.licenseType    = 'Perpetual';
        request.orderNumber   = '1198785496';
        request.startDate = Date.today();
        request.endDate = Date.today().addDays(5);
        request.purchaseDate = Date.today();
        request.grantType = reqGrantTypeList;
        
        String myJSON = JSON.serialize(request);
        
        Test.startTest();
        RestRequest request1 = new RestRequest();
        RestResponse res = new RestResponse();
        request1.requestUri = baseUrl + '/services/apexrest/LicenseService/createLicense';
        request1.httpMethod = 'POST';
        request1.requestBody = Blob.valueof(myJSON);
        RestContext.request = request1;
        RestContext.response = res;
        TF_LicenseAPIService.doPost();
        Test.stopTest();
    }
    
    //to cover validate method case - if Grant Type is different
    static testMethod void test7() {
        setup();
        
        opp.StageName = 'Closed Won';
        update opp;
        
        //Creating request grant type list
        List<String> reqGrantTypeList = new List<String>();
        reqGrantTypeList.add('Test');

        //Initializing rest resouce variables
        TF_LicenseAPIService.CreateLicenseRequest request = new TF_LicenseAPIService.CreateLicenseRequest();
        request.salesforceID      = opp.id; //to cover test case
        request.licenseType    = 'Perpetual';
        request.orderNumber   = '1198785496';
        request.startDate = Date.today();
        request.endDate = Date.today().addDays(5);
        request.purchaseDate = Date.today();
        request.grantType = reqGrantTypeList;
        
        String myJSON = JSON.serialize(request);
        
        Test.startTest();
        RestRequest request1 = new RestRequest();
        RestResponse res = new RestResponse();
        request1.requestUri = baseUrl + '/services/apexrest/LicenseService/createLicense';
        request1.httpMethod = 'POST';
        request1.requestBody = Blob.valueof(myJSON);
        RestContext.request = request1;
        RestContext.response = res;
        TF_LicenseAPIService.doPost();
        Test.stopTest();
    }
    
    //to cover validate method case - if Purchase Date is NULL
    static testMethod void test8() {
        setup();
        
        opp.StageName = 'Closed Won';
        update opp;
        
        //Creating request grant type list
        List<String> reqGrantTypeList = new List<String>();
        reqGrantTypeList.add('View');

        //Initializing rest resouce variables
        TF_LicenseAPIService.CreateLicenseRequest request = new TF_LicenseAPIService.CreateLicenseRequest();
        request.salesforceID      = opp.id; //to cover test case
        request.licenseType    = 'Perpetual';
        request.orderNumber   = '1198785496';
        request.startDate = Date.today();
        request.endDate = Date.today().addDays(5);
        //request.purchaseDate = Date.today();
        request.grantType = reqGrantTypeList;
        
        String myJSON = JSON.serialize(request);
        
        Test.startTest();
        RestRequest request1 = new RestRequest();
        RestResponse res = new RestResponse();
        request1.requestUri = baseUrl + '/services/apexrest/LicenseService/createLicense';
        request1.httpMethod = 'POST';
        request1.requestBody = Blob.valueof(myJSON);
        RestContext.request = request1;
        RestContext.response = res;
        TF_LicenseAPIService.doPost();
        Test.stopTest();
    }
    
    // to cover validate method case - if Salesforce Id is null
    static testMethod void test9() {
        setup();
        
        opp.StageName = 'Closed Won';
        update opp;
        
        //Creating request grant type list
        List<String> reqGrantTypeList = new List<String>();
        reqGrantTypeList.add('View');

        //Initializing rest resouce variables
        TF_LicenseAPIService.CreateLicenseRequest request = new TF_LicenseAPIService.CreateLicenseRequest();
        //request.salesforceID      =  opp.id;
        request.licenseType    = 'Perpetual';
        request.orderNumber   = '1198785496';
        request.startDate = Date.today();
        request.endDate = Date.today().addDays(5);
        request.purchaseDate = Date.today();
        request.grantType = reqGrantTypeList;
        
        String myJSON = JSON.serialize(request);
        
        Test.startTest();
        RestRequest request1 = new RestRequest();
        RestResponse res = new RestResponse();
        request1.requestUri = baseUrl + '/services/apexrest/LicenseService/createLicense';
        request1.httpMethod = 'POST';
        request1.requestBody = Blob.valueof(myJSON);
        RestContext.request = request1;
        RestContext.response = res;
        TF_LicenseAPIService.doPost();
        Test.stopTest();
    }
    
    // to cover validate method case - if Start Date is missing
    static testMethod void test10() {
        setup();
        
        opp.StageName = 'Closed Won';
        update opp;
        
        //Creating request grant type list
        List<String> reqGrantTypeList = new List<String>();
        reqGrantTypeList.add('View');

        //Initializing rest resouce variables
        TF_LicenseAPIService.CreateLicenseRequest request = new TF_LicenseAPIService.CreateLicenseRequest();
        request.salesforceID      =  opp.id;
        request.licenseType    = 'Perpetual';
        request.orderNumber   = '1198785496';
        request.startDate = Null;
        request.endDate = Date.today().addDays(5);
        request.purchaseDate = Date.today();
        request.grantType = reqGrantTypeList;
        
        String myJSON = JSON.serialize(request);
        
        Test.startTest();
        RestRequest request1 = new RestRequest();
        RestResponse res = new RestResponse();
        request1.requestUri = baseUrl + '/services/apexrest/LicenseService/createLicense';
        request1.httpMethod = 'POST';
        request1.requestBody = Blob.valueof(myJSON);
        RestContext.request = request1;
        RestContext.response = res;
        TF_LicenseAPIService.doPost();
        Test.stopTest();
    }
    
    // to cover validate method case - if End Date is missing
    static testMethod void test11() {
        setup();
        
        opp.StageName = 'Closed Won';
        update opp;
        
        //Creating request grant type list
        List<String> reqGrantTypeList = new List<String>();
        reqGrantTypeList.add('View');

        //Initializing rest resouce variables
        TF_LicenseAPIService.CreateLicenseRequest request = new TF_LicenseAPIService.CreateLicenseRequest();
        request.salesforceID      =  opp.id;
        request.licenseType    = 'Perpetual';
        request.orderNumber   = '1198785496';
        request.startDate = Date.today();
        //request.endDate = Date.today().addDays(5);
        request.purchaseDate = Date.today();
        request.grantType = reqGrantTypeList;
        
        String myJSON = JSON.serialize(request);
        
        Test.startTest();
        RestRequest request1 = new RestRequest();
        RestResponse res = new RestResponse();
        request1.requestUri = baseUrl + '/services/apexrest/LicenseService/createLicense';
        request1.httpMethod = 'POST';
        request1.requestBody = Blob.valueof(myJSON);
        RestContext.request = request1;
        RestContext.response = res;
        TF_LicenseAPIService.doPost();
        Test.stopTest();
    }
    // to cover validate method case - if License Type is missing
    static testMethod void test12() {
        setup();
        
        opp.StageName = 'Closed Won';
        update opp;
        
        //Creating request grant type list
        List<String> reqGrantTypeList = new List<String>();
        reqGrantTypeList.add('View');

        //Initializing rest resouce variables
        TF_LicenseAPIService.CreateLicenseRequest request = new TF_LicenseAPIService.CreateLicenseRequest();
        request.salesforceID      =  opp.id;
        //request.licenseType    = 'Perpetual';
        request.orderNumber   = '1198785496';
        request.startDate = Date.today();
        request.endDate = Date.today().addDays(5);
        request.purchaseDate = Date.today();
        request.grantType = reqGrantTypeList;
        
        String myJSON = JSON.serialize(request);
        
        Test.startTest();
        RestRequest request1 = new RestRequest();
        RestResponse res = new RestResponse();
        request1.requestUri = baseUrl + '/services/apexrest/LicenseService/createLicense';
        request1.httpMethod = 'POST';
        request1.requestBody = Blob.valueof(myJSON);
        RestContext.request = request1;
        RestContext.response = res;
        TF_LicenseAPIService.doPost();
        Test.stopTest();
    }
    
    // to cover validate method case - if End Date is missing and License Type is Subscription or Trial
    static testMethod void test13() {
        setup();
        
        opp.StageName = 'Closed Won';
        update opp;
        
        //Creating request grant type list
        List<String> reqGrantTypeList = new List<String>();
        reqGrantTypeList.add('View');

        //Initializing rest resouce variables
        TF_LicenseAPIService.CreateLicenseRequest request = new TF_LicenseAPIService.CreateLicenseRequest();
        request.salesforceID      =  opp.id;
        request.licenseType    = 'Subscription';
        request.orderNumber   = '1198785496';
        request.startDate = Date.today();
        //request.endDate = Date.today().addDays(5);
        request.purchaseDate = Date.today();
        request.grantType = reqGrantTypeList;
        
        String myJSON = JSON.serialize(request);
        
        Test.startTest();
        RestRequest request1 = new RestRequest();
        RestResponse res = new RestResponse();
        request1.requestUri = baseUrl + '/services/apexrest/LicenseService/createLicense';
        request1.httpMethod = 'POST';
        request1.requestBody = Blob.valueof(myJSON);
        RestContext.request = request1;
        RestContext.response = res;
        TF_LicenseAPIService.doPost();
        Test.stopTest();
    }
    
    //to cover stage name as closed won
    static testMethod void test14 () {
        setup();
        
        opp.StageName = 'Closed Won';
        update opp;
        
        //Creating request grant type list
        List<String> reqGrantTypeList = new List<String>();
        reqGrantTypeList.add('View');
        reqGrantTypeList.add('Download');
        
        //Initializing rest resouce variables
        TF_LicenseAPIService.CreateLicenseRequest request = new TF_LicenseAPIService.CreateLicenseRequest();
        request.salesforceID = opp.id;
        request.licenseType = 'Perpetual';
        request.orderNumber= '1198785496';
        request.startDate = Date.today();
        request.endDate = Date.today().addDays(5);
        request.purchaseDate = Date.today();
        request.grantType = reqGrantTypeList;
        
        String myJSON = JSON.serialize(request);
        
        Test.startTest();
        RestRequest request1 = new RestRequest();
        RestResponse res = new RestResponse();
        request1.requestUri = baseUrl + '/services/apexrest/LicenseService/createLicense';
        request1.httpMethod = 'POST';
        request1.requestBody = Blob.valueof(myJSON);
        RestContext.request = request1;
        RestContext.response = res;
        TF_LicenseAPIService.doPost();
        Test.stopTest();
    }
    */
}