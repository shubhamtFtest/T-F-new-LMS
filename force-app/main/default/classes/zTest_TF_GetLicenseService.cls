/**********************************************************************
//This is test class for class "TF_GetLicenseService"
***********************************************************************/

@isTest
global class zTest_TF_GetLicenseService {
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
        p.Hub_Id__c = '9999999999';
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
        for(integer i =0;i<25;i++){
          licenseList.add( new Asset(Name = 'Testing'+i, AccountId = acc.id,Status = 'Created', Product2Id = p.id, TF_Sales_Channel__c = 'UBX', TF_Entitlement_Creation_Status__c = 'Pending', TF_Grant_Type__c = 'ViewOnline', InstallDate = Date.today().addDays(5), UsageEndDate = Date.today()));  
        }
        insert licenseList;
        system.debug('licenseList-Size'+licenseList.size());
        //Creating License Policies
        licensePolicyList.add( new  TF_License_Policy__c(TF_Asset__c = licenseList[0].Id,TF_Policy_Name__c = 'Concurrency',TF_Scope__c = 'Global',TF_Unit_value__c  = '10'));
        insert licensePolicyList;
    }
    static TestMethod void getLicensesByPartyId_Test () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/v4/licenses?partyId=98422&offset=1&limit=20&status=all';
        req.addParameter('partyId','98422');
        req.addParameter('limit', '1');
        req.addParameter('status', 'all');
        req.addParameter('offset', '1');
        system.debug('licenseList'+licenseList); 
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_GetLicenseService.getLicenseData();
        Test.stopTest();
    }
    static TestMethod void getLicensesByPartyId_Test1 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/v4/licenses?partyId=982&offset=0&limit=20&status=all';
        req.addParameter('partyId','982');
        req.addParameter('limit', '10');
        req.addParameter('offset', '0');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_GetLicenseService.getLicenseData();
        
        Test.stopTest();
    }
    static TestMethod void getLicensesByLicenseId () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/v4/licenses/'+licenseList[0].Id;
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_GetLicenseService.getLicenseData();
        Test.stopTest();
    }
    static TestMethod void cancelLicenseSync4() {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/v4/licenses/'+licenseList[0].Id+'&identifier=98422';
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = response1;
        TF_GetLicenseService.cancelLicenseSync();
        Test.stopTest();
    }
    static TestMethod void getLicensesByLicenseId_1 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/v4/licenses/asdasdas';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_GetLicenseService.getLicenseData();
        Test.stopTest();
    }
    static TestMethod void cancelLicenseSync() {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/v4/licenses/'+licenseList[0].Id;
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = response1;
        TF_GetLicenseService.cancelLicenseSync();
        Test.stopTest();
    }
    static TestMethod void cancelLicenseSync1() {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/v4/licenses/dsfsdfsdfs';
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = response1;
        TF_GetLicenseService.cancelLicenseSync();
        Test.stopTest();
    }
    static TestMethod void cancelLicenseSync2() {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/v4/licenses/a1y7Y000003Q9tLQAS';
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = response1;
        TF_GetLicenseService.cancelLicenseSync();
        Test.stopTest();
    }
    static TestMethod void cancelLicenseSync3() {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/v4/licenses/';
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = response1;
        TF_GetLicenseService.cancelLicenseSync();
        Test.stopTest();
    }
    static TestMethod void LicensePatch() {
        setup();
        String JSONMsg = '{"Tf_is_Fulfilled__c":"True","TF_Entitlement_Creation_Status__c":"Pending"}';
        Test.startTest();
        List<Asset> reqlicense = [Select Id, Name, TF_Entitlement_Creation_Status__c from Asset Where Name Like 'Testing%' Limit 1 ];
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/v4/licenses/'+ reqlicense[0].Id;
        req.httpMethod = 'PATCH';
        req.requestBody = Blob.valueof(JSONMsg);
        RestContext.request = req;
        RestContext.response = response1;
        TF_GetLicenseService.updateLicense();
        Test.stopTest();
    }
    static TestMethod void LicensePatch2() {
        setup();
        String JSONMsg = '{"Tf_is_Fulfilled__c":"False","TF_Entitlement_Creation_Status__c":"Pending"}';
        Test.startTest();
        List<Asset> reqlicense = [Select Id, Name, TF_Entitlement_Creation_Status__c from Asset Where Name Like 'Testing%' Limit 1 ];
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/v4/licenses/1'+ reqlicense[0].Id;
        req.httpMethod = 'PATCH';
        req.requestBody = Blob.valueof(JSONMsg);
        RestContext.request = req;
        RestContext.response = response1;
        TF_GetLicenseService.updateLicense();
        Test.stopTest();
    }
    static TestMethod void LicensePatch3() {
        setup();
        String JSONMsg = '{"Tf_is_Fulfilled__c":"True","TF_Entitlement_Creation_Status__c":"Pending"}';
        Test.startTest();
        List<Asset> reqlicense = [Select Id, Name, TF_Entitlement_Creation_Status__c from Asset Where Name Like 'Testing%' Limit 1 ];
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/v4/licenses/';
        req.httpMethod = 'PATCH';
        req.requestBody = Blob.valueof(JSONMsg);
        RestContext.request = req;
        RestContext.response = response1;
        TF_GetLicenseService.updateLicense();
        Test.stopTest();
    }
}