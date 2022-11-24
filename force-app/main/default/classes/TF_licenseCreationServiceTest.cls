/**
Author : Shubham Kumar
Apex class :  TF_licenseCreationService
**/
@isTest
public class TF_licenseCreationServiceTest {
    static List<Asset> licenseList = new List<Asset>();
    static List<TF_License_Policy__c> licensePolicyList = new List<TF_License_Policy__c>();
    static final String baseUrl = Url.getSalesforceBaseUrl().toExternalForm();
    static Account acc = new Account();
    static List<Account> accList = new List<Account>();
    static List<Contact> conList = new List<Contact>();
    static Product2 p = new Product2();
    @testSetup
    public static void setup() {
        //Create a Account record
        acc = new Account();
        acc.Name ='Test';
        acc.Type = 'Consortium';
        acc.Customer_Id__c = '98422';
        insert acc;
        
        accList.add( new Account( Name ='Test', Type = 'Consortium', Customer_Id__c = '98422' ) );
        accList.add( new Account( Name ='Test', Type = 'Consortium', Customer_Id__c = '98422' ) );
        insert accList;
        
        conList.add( new Contact( LastName = 'Test', party_Id__c = '201301' ) );
        insert conList;
        
        //Create a Product record
        p.Name = 'Test_Pro';
        p.isActive = true;
        p.Hub_Id__c = 'e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a';
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
        
        //Creating license list       
        system.debug(acc.id); 
        licenseList.add( new Asset(Name = 'Testing 2', AccountId = acc.id,Status = 'Created', Product2Id = p.id, TF_Sales_Channel__c = 'UBX', TF_Entitlement_Creation_Status__c = 'Pending', TF_Grant_Type__c = 'ViewOnline', InstallDate = Date.today().addDays(5), UsageEndDate = Date.today()));
        licenseList.add( new Asset(Name = 'Testing 3', AccountId = acc.id,Status = 'Created', Product2Id = p.id, TF_Sales_Channel__c = 'UBX', TF_Entitlement_Creation_Status__c = 'Pending', TF_Grant_Type__c = 'ViewOnline', InstallDate = Date.today().addDays(5), UsageEndDate = Date.today()));
        licenseList.add( new Asset(Name = 'Testing 4', AccountId = acc.id,Status = 'Created', Product2Id = p.id, TF_Sales_Channel__c = 'UBX', TF_Entitlement_Creation_Status__c = 'Pending', TF_Grant_Type__c = 'ViewOnline', InstallDate = Date.today().addDays(5), UsageEndDate = Date.today()));
        insert licenseList;
        
        //Creating License Policies
        licensePolicyList.add( new  TF_License_Policy__c(TF_Asset__c = licenseList[0].Id,TF_Policy_Name__c = 'Concurrency',TF_Scope__c = 'Global',TF_Unit_value__c  = '10'));
        insert licensePolicyList;
    }
    static testMethod void test_validateCancelRequest_Success ()
    {  
        Record_Creation_Request__c recordRequest = new Record_Creation_Request__c();
        recordRequest.TF_Request_JSON__c = 'JSONReq';
        recordRequest.TF_Status__c = 'RECEIVED';
        recordRequest.Request_Type__c = 'Create'; 
        recordRequest.TF_RequestID__c = '125';
        recordRequest.TF_CallBackUrl__c = 'callback URL'; 
        insert recordRequest;
        
        Asset thisAsset = new Asset();
        thisAsset.TF_Access_Scope__c = 'Global';
        thisAsset.TF_Business_Model__c = 'Subscription';
        thisAsset.TF_License_Type__c = 'Static';
        thisAsset.Name = 'Applied PsychologyTest';
        thisAsset.TF_License_Creation_Request__c =  recordRequest.Id; 
        insert thisAsset;
        
        String reqJson = '{"orderNumber":"","requestId":"009","requestType":"Cancel","requestPayload":{"originalRequestID":"125","licenseID":["'+ thisAsset.id +'"]},"callBackurl":"Provided by OMS"}';
        TF_LicenseCancellationRequestWrapper request = (TF_LicenseCancellationRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCancellationRequestWrapper.class);
        TF_licenseCreationService licenseServ = new TF_licenseCreationService();
        TF_LicenseCancellationRequestWrapper.CancelLicenseResponse response = licenseServ.validateCancelRequest(request);
        
        
        
        String reqJsonNew = '{"orderNumber":"111","requestId":"008","requestType":"Cancel","requestPayload":{"originalRequestID":"125","licenseID":[]},"callBackurl":"Provided by OMS"}';
        TF_LicenseCancellationRequestWrapper requestNew = (TF_LicenseCancellationRequestWrapper)JSON.deserialize(reqJsonNew, TF_LicenseCancellationRequestWrapper.class);
        
        TF_LicenseCancellationRequestWrapper.CancelLicenseResponse responseNew = licenseServ.validateCancelRequest(requestNew);
        
    }
    
    static testMethod void test_validateCancelRequest_LicenseIdMismatchorExpired ()
    {  
        Record_Creation_Request__c recordRequest = new Record_Creation_Request__c();
        recordRequest.TF_Request_JSON__c = 'JSONReq';
        recordRequest.TF_Status__c = 'RECEIVED';
        recordRequest.Request_Type__c = 'Create'; 
        recordRequest.TF_RequestID__c = '125';
        recordRequest.TF_CallBackUrl__c = 'callback URL'; 
        insert recordRequest;
        
        Asset thisAsset = new Asset();
        thisAsset.TF_Access_Scope__c = 'Global';
        thisAsset.TF_Business_Model__c = 'Subscription';
        thisAsset.TF_License_Type__c = 'Static';
        thisAsset.Status = 'Expired'; 
        thisAsset.Name = 'Applied PsychologyTest';
        thisAsset.TF_License_Creation_Request__c =  recordRequest.Id; 
        insert thisAsset;
        
        Asset thisAsset2 = new Asset();
        thisAsset2.TF_Access_Scope__c = 'Global';
        thisAsset2.TF_Business_Model__c = 'Subscription';
        thisAsset2.TF_License_Type__c = 'Static';
        thisAsset2.Name = 'Applied PsychologyTest1';
        insert thisAsset2;
        
        String reqJson = '{"orderNumber":"","requestId":"009","requestType":"Cancel","requestPayload":{"originalRequestID":"125","licenseID":["'+ thisAsset2.id +'"]},"callBackurl":"Provided by OMS"}';
        TF_LicenseCancellationRequestWrapper request = (TF_LicenseCancellationRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCancellationRequestWrapper.class);
        TF_licenseCreationService licenseServ = new TF_licenseCreationService();
        TF_LicenseCancellationRequestWrapper.CancelLicenseResponse response = licenseServ.validateCancelRequest(request);
        
        String reqJsonLicExpired = '{"orderNumber":"","requestId":"010","requestType":"Cancel","requestPayload":{"originalRequestID":"125","licenseID":["'+ thisAsset.id +'"]},"callBackurl":"Provided by OMS"}';
        TF_LicenseCancellationRequestWrapper requestLicExpired = (TF_LicenseCancellationRequestWrapper)JSON.deserialize(reqJsonLicExpired, TF_LicenseCancellationRequestWrapper.class);
        
        TF_LicenseCancellationRequestWrapper.CancelLicenseResponse responseLicExpired = licenseServ.validateCancelRequest(requestLicExpired);
        
    }    
    static testMethod void test_validateCancelRequest_NoOriginalReqId ()
    {  
        String reqJson = '{"orderNumber":"","requestId":"009","requestType":"Cancel","requestPayload":{"originalRequestID":"125","licenseID":["02i3N00000BOereQAD"]},"callBackurl":"Provided by OMS"}';
        TF_LicenseCancellationRequestWrapper request = (TF_LicenseCancellationRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCancellationRequestWrapper.class);
        TF_licenseCreationService licenseServ = new TF_licenseCreationService();
        TF_LicenseCancellationRequestWrapper.CancelLicenseResponse response = licenseServ.validateCancelRequest(request);
    }
    static testMethod void test_validateCancelRequest_NullOriginalReqId ()
    {  
        String reqJson = '{"orderNumber":"","requestId":"009","requestType":"Cancel","requestPayload":{"originalRequestID":"","licenseID":["02i3N00000BOereQAD"]},"callBackurl":"Provided by OMS"}';
        TF_LicenseCancellationRequestWrapper request = (TF_LicenseCancellationRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCancellationRequestWrapper.class);
        TF_licenseCreationService licenseServ = new TF_licenseCreationService();
        TF_LicenseCancellationRequestWrapper.CancelLicenseResponse response = licenseServ.validateCancelRequest(request);
    }
    
    static testMethod void test_validateCancelRequest_NullReqId ()
    {  
        String reqJson = '{"orderNumber":"","requestId":null,"requestType":"Cancel","requestPayload":{"originalRequestID":"125","licenseID":["02i3N00000BOereQAD"]},"callBackurl":"Provided by OMS"}';
        TF_LicenseCancellationRequestWrapper request = (TF_LicenseCancellationRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCancellationRequestWrapper.class);
        TF_licenseCreationService licenseServ = new TF_licenseCreationService();
        TF_LicenseCancellationRequestWrapper.CancelLicenseResponse response = licenseServ.validateCancelRequest(request);
    }
    
    static testMethod void test_validateCancelRequest_DupReqId ()
    {  
        Record_Creation_Request__c recordRequest = new Record_Creation_Request__c();
        recordRequest.TF_Request_JSON__c = 'JSONReq';
        recordRequest.TF_Status__c = 'RECEIVED';
        recordRequest.Request_Type__c = 'Create'; 
        recordRequest.TF_RequestID__c = '125';
        recordRequest.TF_CallBackUrl__c = 'callback URL'; 
        insert recordRequest;
        
        String reqJson = '{"orderNumber":"","requestId":"125","requestType":"Cancel","requestPayload":{"originalRequestID":"125","licenseID":["02i3N00000BOereQAD"]},"callBackurl":"Provided by OMS"}';
        TF_LicenseCancellationRequestWrapper request = (TF_LicenseCancellationRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCancellationRequestWrapper.class);
        TF_licenseCreationService licenseServ = new TF_licenseCreationService();
        TF_LicenseCancellationRequestWrapper.CancelLicenseResponse response = licenseServ.validateCancelRequest(request);
    }
    
    static testMethod void test_validateCancelRequest_NullReqType ()
    {  
        String reqJson = '{"orderNumber":"","requestId":"009","requestType":null,"requestPayload":{"originalRequestID":"125","licenseID":["02i3N00000BOereQAD"]},"callBackurl":"Provided by OMS"}';
        TF_LicenseCancellationRequestWrapper request = (TF_LicenseCancellationRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCancellationRequestWrapper.class);
        TF_licenseCreationService licenseServ = new TF_licenseCreationService();
        TF_LicenseCancellationRequestWrapper.CancelLicenseResponse response = licenseServ.validateCancelRequest(request);
    }
    
    static testMethod void test_validateCancelRequest_WrongReqType ()
    {  
        String reqJson = '{"orderNumber":"","requestId":"009","requestType":"abc","requestPayload":{"originalRequestID":"125","licenseID":["02i3N00000BOereQAD"]},"callBackurl":"Provided by OMS"}';
        TF_LicenseCancellationRequestWrapper request = (TF_LicenseCancellationRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCancellationRequestWrapper.class);
        TF_licenseCreationService licenseServ = new TF_licenseCreationService();
        TF_LicenseCancellationRequestWrapper.CancelLicenseResponse response = licenseServ.validateCancelRequest(request);
    }
    
    static testMethod void test_validateCancelRequest_NullCallBackUrl () 
    {  
        String reqJson = '{"orderNumber":"","requestId":"009","requestType":"Cancel","requestPayload":{"originalRequestID":"125","licenseID":["02i3N00000BOereQAD"]},"callBackurl":""}';
        TF_LicenseCancellationRequestWrapper request = (TF_LicenseCancellationRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCancellationRequestWrapper.class);
        TF_licenseCreationService licenseServ = new TF_licenseCreationService();
        TF_LicenseCancellationRequestWrapper.CancelLicenseResponse response = licenseServ.validateCancelRequest(request);
    }
    
    //TestMethods added by shubham Kumar
    static TestMethod void successSet() {
        setup();
        String reqJson = '{"orderNumber":"ODR98739393","requestId":"56489886","requestType":"Create","requestPayload":{"orderId":"100","source":"OMS","salesChannel":"UBX","customer":{"partyId":"98422","type":"INSTITUTION"},"products":[{"productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1235","productType":"COLLECTION","licenseDetails":{"channel":"UBX","startDate":"2023-06-17","licenseType":"Perpetual","licenseUpdateType":"Dynamic","accessScope":"Global","licenseUpdateEndDate":"2023-08-17","policies":{"drm":true,"concurrency":"1","grantType":["ViewOnline"],"copyCount":"2","printCount":"1"}}}]},"callBackurl":"Provided by OMS"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    
    static TestMethod void requestTypeValidation() {
        setup();
        String reqJson = '{"orderNumber":"ODR98739393","requestId":"UniqueId","requestPayload":{"orderId":"100","source":"OMS","salesChannel":"UBX","customer":{"partyId":"98422","type":"CONSORTIUM","members":["98422"]},"products":[{"productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"2019-08-17","endDate":"2020-08-17","licenseType":"Perpetual","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"concurrency":"0","grantType":["Both"],"copyCount":"1","printCount":"1"}}},{"productUUID":"f8c8c2bd-c534-4c31-b0ea-08f83cc88c03","version":"1.0","orderLineItemId":"1235","licenseDetails":{"channel":"UBX","startDate":"2019-08-17","endDate":"2020-08-17","licenseType":"Subscription","licenseUpdateType":"Dynamic","accessScope":"Global","subscriptionEndDate":"2020-08-17","policies":{"drm":true,"concurrency":"10","grantType":["ViewOnline"],"copyCount":"2","printCount":"3"}}}]},"callBackurl":"Provided by OMS"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    
    static TestMethod void successRequest() {
        setup();
        String reqJson = '{"orderNumber":"ODR98739393","requestId":"223578","requestType":"Create","requestPayload":{"orderId":"100","source":"OMS","salesChannel":"UBX","customer":{"partyId":"98422","type":"INSTITUTION"},"products":[{"productType":"collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"2022-07-07","endDate":"2022-07-08","licenseType":"Subscription","licenseUpdateType":"Dynamic","subscriptionEndDate":"2022-06-06","accessScope":"Global","policies":{"drm":true,"concurrency":"2","grantType":["ViewOnline"],"copyCount":"3","printCount":"5"}}}]},"callBackurl":"Provided by OMS"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    static TestMethod void dynamicValidation() {
        setup();
        String reqJson = '{"orderNumber":"ODR98739393","requestId":"78979879","requestType":"Create","requestPayload":{"orderId":"100","source":"OMS","salesChannel":"UBX","customer":{"partyId":"98422","type":"CONSORTIUM","members":["98422"]},"products":[{"productType":"Collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"2022-06-17","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"dynamic","accessScope":"Global","policies":{"drm":true,"concurrency":"0","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"Provided by OMS"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    static TestMethod void perpetualEndDateValidation() {
        setup();
        String reqJson = '{"orderNumber":"ODR98739393","requestId":"78979879","requestType":"Create","requestPayload":{"orderId":"100","source":"OMS","salesChannel":"UBX","customer":{"partyId":"6525908","type":"CONSORTIUM","members":["1"]},"products":[{"productType":"Collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"2022-06-17","endDate":"2022-08-17","licenseType":"Perpetual","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"concurrency":"0","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"Provided by OMS"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    static TestMethod void orderNumberValidationParameter() {
        setup();
        String reqJson = '{"":"ODR98739393","requestId":"78979879","requestType":"Create","requestPayload":{"orderId":"100","source":"OMS","salesChannel":"UBX","customer":{"partyId":"98422","type":"CONSORTIUM","members":["98422"]},"products":[{"productType":"Collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"2022-06-17","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"concurrency":"0","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"Provided by OMS"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    
    static TestMethod void concurrencyParameter() {
        
        setup();
        String reqJson = '{"orderNumber":"","requestId":"78979879","requestType":"Create","requestPayload":{"orderId":"100","source":"OMS","salesChannel":"UBX","customer":{"partyId":"98422","type":"CONSORTIUM","members":["98422"]},"products":[{"productType":"Collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"2022-06-17","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"concurrency":"2","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"Provided by OMS"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    
    static TestMethod void callbackUrlParameterblank() {
        
        setup();
        String reqJson = '{"orderNumber":"342423das","requestId":"78979879","requestType":"Create","requestPayload":{"orderId":"100","source":"OMS","salesChannel":"UBX","customer":{"partyId":"98422","type":"CONSORTIUM","members":["98422"]},"products":[{"productType":"Collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"2022-06-17","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"concurrency":"2","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":""}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    static TestMethod void callbackUrlParametermissing() {
        
        setup();
        String reqJson = '{"orderNumber":"342423das","requestId":"78979879","requestType":"create","requestPayload":{"orderId":"100","source":"OMS","salesChannel":"UBX","customer":{"partyId":"98422","type":"CONSORTIUM","members":["98422"]},"products":[{"productType":"Collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"2022-06-17","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"concurrency":"2","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"":"343434"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    static TestMethod void PayloadParametermissing() {
        
        setup();
        String reqJson = '{"orderNumber":"342423das","requestId":"78979879","requestType":"Create","":{"orderId":"100","source":"OMS","salesChannel":"UBX","customer":{"partyId":"98422","type":"CONSORTIUM","members":["98422"]},"products":[{"productType":"Collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"2022-06-17","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"concurrency":"2","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"343434"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    static TestMethod void orderIdParameterMissing() {
        
        setup();
        String reqJson = '{"orderNumber":"342423das","requestId":"78979879","requestType":"Create","requestPayload":{"orderId":"","source":"OMS","salesChannel":"UBX","customer":{"partyId":"98422","type":"CONSORTIUM","members":["98422"]},"products":[{"productType":"Collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"2022-06-17","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"concurrency":"2","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"343434"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    static TestMethod void orderIdParametervalueBlank() {
        
        setup();
        String reqJson = '{"orderNumber":"342423das","requestId":"78979879","requestType":"Create","requestPayload":{"":"fdsfsdf3443","source":"OMS","salesChannel":"UBX","customer":{"partyId":"98422","type":"CONSORTIUM","members":["98422"]},"products":[{"productType":"Collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"2022-06-17","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"concurrency":"2","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"343434"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    static TestMethod void sourceParametervaluemissing() {
        
        setup();
        String reqJson = '{"orderNumber":"342423das","requestId":"78979879","requestType":"Create","requestPayload":{"orderId":"fdsfsdf3443","":"OMS","salesChannel":"UBX","customer":{"partyId":"98422","type":"CONSORTIUM","members":["98422"]},"products":[{"productType":"Collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"2022-06-17","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"concurrency":"2","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"343434"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    static TestMethod void sourceIdParametervalueBlank() {
        setup();
        String reqJson = '{"orderNumber":"342423das","requestId":"78979879","requestType":"Create","requestPayload":{"orderId":"fdsfsdf3443","source":"","salesChannel":"UBX","customer":{"partyId":"98422","type":"CONSORTIUM","members":["98422"]},"products":[{"productType":"Collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"2022-06-17","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"concurrency":"2","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"343434"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    static TestMethod void dateValdiation() {
        setup();
        String reqJson = '{"orderNumber":"342423das","requestId":"78979879","requestType":"Create","requestPayload":{"orderId":"fdsfsdf3443","source":"OMS","salesChannel":"UBX","customer":{"partyId":"98422","type":"CONSORTIUM","members":["98422"]},"products":[{"productType":"Collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"2021-06-17","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"concurrency":"2","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"343434"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    static TestMethod void dateValdiation_v1(){
        setup();
        String reqJson = '{"orderNumber":"342423das","requestId":"78979879","requestType":"Create","requestPayload":{"orderId":"fdsfsdf3443","source":"OMS","salesChannel":"UBX","customer":{"partyId":"98422","type":"CONSORTIUM","members":["98422"]},"products":[{"productType":"Collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"2aw021-0a6-17","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"concurrency":"2","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"343434"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    static TestMethod void memberParamvalueBlanK() {
        
        setup();
        String reqJson = '{"orderNumber":"342423das","requestId":"78979879","requestType":"Create","requestPayload":{"orderId":"fdsfsdf3443","source":"OMS","salesChannel":"UBX","customer":{"partyId":"98422","type":"CONSORTIUM"},"products":[{"productType":"Collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"2022-06-17","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"concurrency":"2","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"343434"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    static TestMethod void salesChannelParametervaluemissing() {
        
        setup();
        String reqJson = '{"orderNumber":"342423das","requestId":"78979879","requestType":"Create","requestPayload":{"orderId":"fdsfsdf3443","source":"OMS","":"UBX","customer":{"partyId":"98422","type":"CONSORTIUM","members":["98422"]},"products":[{"productType":"Collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"","startDate":"2022-06-17","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"concurrency":"2","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"343434"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    static TestMethod void invalidsalesChannelParametervalue() {
        
        setup();
        String reqJson = '{"orderNumber":"342423das","requestId":"78979879","requestType":"Create","requestPayload":{"orderId":"fdsfsdf3443","source":"OMS","salesChannel":"dsfsf","customer":{"partyId":"98422","type":"CONSORTIUM","members":["98422"]},"products":[{"productType":"Collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"","startDate":"2022-06-17","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"concurrency":"2","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"343434"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    static TestMethod void salesChannelParametervalueBlank() {
        
        setup();
        String reqJson = '{"orderNumber":"342423das","requestId":"78979879","requestType":"Create","requestPayload":{"orderId":"fdsfsdf3443","source":"OMS","salesChannel":"","customer":{"partyId":"98422","type":"CONSORTIUM","members":["98422"]},"products":[{"productType":"Collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"":"UBX","startDate":"2022-06-17","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"concurrency":"2","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"343434"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    static TestMethod void customerParametervaluemissing() {
        
        setup();
        String reqJson = '{"orderNumber":"342423das","requestId":"78979879","requestType":"Create","requestPayload":{"orderId":"fdsfsdf3443","source":"OMS","salesChannel":"UBX","":{"partyId":"98422","type":"CONSORTIUM","members":["98422"]},"products":[{"productType":"Collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"2022-06-17","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"concurrency":"2","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"343434"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    static TestMethod void partIdvalueBlankParametermissing() {
        
        setup();
        String reqJson = '{"orderNumber":"342423das","requestId":"78979879","requestType":"Create","requestPayload":{"orderId":"fdsfsdf3443","source":"OMS","salesChannel":"UBX","customer":{"":"98422","type":"CONSORTIUM","members":["98422"]},"products":[{"productType":"Collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"2022-06-17","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"concurrency":"2","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"343434"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    static TestMethod void partIdvalueBlank() {
        
        setup();
        String reqJson = '{"orderNumber":"342423das","requestId":"78979879","requestType":"Create","requestPayload":{"orderId":"fdsfsdf3443","source":"OMS","salesChannel":"UBX","customer":{"partyId":"","type":"CONSORTIUM","members":["98422"]},"products":[{"productType":"Collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"2022-06-17","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"concurrency":"2","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"343434"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    static TestMethod void customerTypeInsituionmemberValdiation() {
        
        setup();
        String reqJson = '{"orderNumber":"342423das","requestId":"78979879","requestType":"Create","requestPayload":{"orderId":"fdsfsdf3443","source":"OMS","salesChannel":"UBX","customer":{"partyId":"98422","type":"INSTITUTION","members":["98422"]},"products":[{"productType":"Collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"2022-06-17","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"concurrency":"2","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"343434"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    static TestMethod void productParametermissing() {
        
        setup();
        String reqJson = '{"orderNumber":"342423das","requestId":"78979879","requestType":"Create","requestPayload":{"orderId":"fdsfsdf3443","source":"OMS","salesChannel":"UBX","customer":{"partyId":"98422","type":"CONSORTIUM","members":["98422"]},"":[{"productType":"Collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"2022-06-17","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"concurrency":"2","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"343434"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    static TestMethod void versionParametervalueMissing() {
        
        setup();
        String reqJson = '{"orderNumber":"342423das","requestId":"78979879","requestType":"Create","requestPayload":{"orderId":"fdsfsdf3443","source":"OMS","salesChannel":"UBX","customer":{"partyId":"98422","type":"CONSORTIUM","members":["98422"]},"products":[{"productType":"Collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"2022-06-17","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"concurrency":"2","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"343434"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    static TestMethod void productUUIDvalueBlank() {
        
        setup();
        String reqJson = '{"orderNumber":"342423das","requestId":"78979879","requestType":"create","requestPayload":{"orderId":"fdsfsdf3443","source":"OMS","salesChannel":"UBX","customer":{"partyId":"98422","type":"CONSORTIUM","members":["98422"]},"products":[{"productType":"Collection","productUUID":"","version":"","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"2022-06-17","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"concurrency":"2","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"343434"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    
    static TestMethod void productUUIDvalueMissing() {
        
        setup();
        String reqJson = '{"orderNumber":"342423das","requestId":"78979879","requestType":"Create","requestPayload":{"orderId":"fdsfsdf3443","source":"OMS","salesChannel":"UBX","customer":{"partyId":"98422","type":"CONSORTIUM","members":["98422"]},"products":[{"productType":"Collection","":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"2022-06-17","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"concurrency":"2","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"343434"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    static TestMethod void versionParametervalueBlank() {
        
        setup();
        String reqJson = '{"orderNumber":"342423das","requestId":"78979879","requestType":"Create","requestPayload":{"orderId":"fdsfsdf3443","source":"OMS","salesChannel":"UBX","customer":{"partyId":"98422","type":"CONSORTIUM","members":["98422"]},"products":[{"productType":"Collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"2022-06-17","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"concurrency":"2","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"343434"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    static TestMethod void startDatvalueBlank() {
        
        setup();
        String reqJson = '{"orderNumber":"342423das","requestId":"78979879","requestType":"Create","requestPayload":{"orderId":"fdsfsdf3443","source":"OMS","salesChannel":"UBX","customer":{"partyId":"98422","type":"CONSORTIUM","members":["98422"]},"products":[{"productType":"Collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"concurrency":"2","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"343434"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    static TestMethod void drmValidations() {
        
        setup();
        String reqJson = '{"orderNumber":"342423das","requestId":"78979879","requestType":"Create","requestPayload":{"orderId":"fdsfsdf3443","source":"OMS","salesChannel":"UBX","customer":{"partyId":"98422","type":"CONSORTIUM","members":["98422"]},"products":[{"productType":"Collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"":"2","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"343434"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    static TestMethod void drmValidations_v2() {
        
        setup();
        String reqJson = '{"orderNumber":"342423das","requestId":"78979879","requestType":"Create","requestPayload":{"orderId":"fdsfsdf3443","source":"OMS","salesChannel":"UBX","customer":{"partyId":"98422","type":"CONSORTIUM","members":["98422"]},"products":[{"productType":"Collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":true,"concurrency":"2","":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"343434"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }
    static TestMethod void licenseTypeValdiation() {
        
        setup();
        String reqJson = '{"orderNumber":"342423das","requestId":"78979879","requestType":"Create","requestPayload":{"orderId":"fdsfsdf3443","source":"OMS","salesChannel":"UBX","customer":{"partyId":"98422","type":"CONSORTIUM","members":["98422"]},"products":[{"productType":"Collection","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"2022-06-17","endDate":"2022-08-17","licenseType":"Subscription","licenseUpdateType":"","accessScope":"Global","policies":{"drm":true,"concurrency":"2","grantType":["download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"343434"}';
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(reqJson, TF_LicenseCreateRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        Licenseresponse = licenseService.create(request);
    }	
    
}