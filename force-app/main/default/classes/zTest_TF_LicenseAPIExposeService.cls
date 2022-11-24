/**********************************************************************
//This is test class for class "TF_LicenseAPIExposeService"
***********************************************************************/

@isTest
global class zTest_TF_LicenseAPIExposeService {
    static List<License__c> licenseList = new List<License__c>();
    static final String baseUrl = Url.getSalesforceBaseUrl().toExternalForm();
    static Account acc = new Account();
    static List<Account> accList = new List<Account>();
    static List<Contact> conList = new List<Contact>();
    static Product2 p = new Product2();@testSetup
    public static void setup() {
        //Create a Account record
        acc = new Account();
        acc.Name ='Test';
        acc.Type = 'Consortium';
        acc.Customer_Id__c = '1234';
        insert acc;
        
        accList.add( new Account( Name ='Test', Type = 'Consortium', Customer_Id__c = '12345' ) );
        accList.add( new Account( Name ='Test', Type = 'Consortium', Customer_Id__c = '123456' ) );
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
        licenseList.add( new License__c( Customer__c = acc.id, Product__c = p.id, Order_Number__c = 'Test ON', License_Type__c = 'Trial', Grant_Type__c = 'View; Download', Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'Active' ) );
        licenseList.add( new License__c( Customer__c = acc.id, Product__c = p.id, Order_Number__c = 'Test ON2', License_Type__c = 'Subscription', Grant_Type__c = 'Download', Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'Active' ) );
        licenseList.add( new License__c( Customer__c = acc.id, Product__c = p.id, Order_Number__c = 'Test ON3', License_Type__c = 'Perpetual', Grant_Type__c = 'View; Download', Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'Active' ) );
        licenseList.add( new License__c( Customer__c = acc.id, Product__c = p.id, Order_Number__c = 'Test ON4', License_Type__c = 'Perpetual', Grant_Type__c = 'View; Download', Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'In progress' ) );
        licenseList.add( new License__c( Customer__c = acc.id, Product__c = p.id, Order_Number__c = 'Test ON5', License_Type__c = 'Perpetual', Grant_Type__c = 'View; Download', Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'Expired' ) );
        licenseList.add( new License__c( Customer__c = accList[0].id, Product__c = p.id, Order_Number__c = 'Test ON6', License_Type__c = 'Perpetual', Grant_Type__c = 'View; Download', Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'Active' ) );
        licenseList.add( new License__c( Contact__c = conList[0].id, Product__c = p.id, Order_Number__c = 'Test ON7', License_Type__c = 'Perpetual', Grant_Type__c = 'View; Download', Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'Active' ) );
        licenseList.add( new License__c( Customer__c = acc.id, Product__c = p.id, Order_Number__c = 'Test ON8', License_Type__c = 'Trial', Grant_Type__c = 'View; Download', Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'Deactivated' ) );
        insert licenseList;
    }
    
    static TestMethod void invalidResource_Test () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/test/1234';
        req.addParameter('status', 'Active');
        req.addParameter('limit', '10');
        req.addParameter('offset', '0');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static TestMethod void getLicensesByPartyId_Test () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/customer/1234';
        req.addParameter('status', 'Active');
        req.addParameter('limit', '10');
        req.addParameter('offset', '0');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static TestMethod void partyId_BlankTest () {
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/customer/';
        req.addParameter('status', 'Active');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static TestMethod void partyId_Test2 () {
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/customer/1234';
        req.addParameter('status', 'Activer');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static TestMethod void partyId_Test3 () {
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/customer/1234';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static TestMethod void partyId_Test4 () {
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/customer/12345';
        req.addParameter('status', 'Active');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static TestMethod void partyId_Test5 () {
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/customer/12345';
        req.addParameter('status', '');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static TestMethod void partyId_Test6 () {
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/customer/1234';
        req.addParameter('status', 'Active');
        req.addParameter('limit', '10');
        req.addParameter('offset', '2001');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static TestMethod void partyId_Test7 () {
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/customer/1234';
        req.addParameter('status', 'All');
        req.addParameter('limit', '10');
        req.addParameter('offset', '');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static TestMethod void partyId_Test8 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/customer/1234';
        req.addParameter('status', 'Inprogress');
        req.addParameter('limit', '10');
        req.addParameter('offset', '0');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static TestMethod void partyId_Test8_1 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/customer/1234';
        req.addParameter('status', 'Active,InProgress,Expired,Deactivated');
        req.addParameter('limit', '20');
        req.addParameter('offset', '3');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static TestMethod void partyId_Test9 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/customer/'+accList[1].Customer_Id__c;
        req.addParameter('status', 'Inprogress');
        req.addParameter('limit', '10');
        req.addParameter('offset', '0');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static TestMethod void partyId_Test10 () {
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/customer/53453454';
        req.addParameter('status', 'All');
        req.addParameter('limit', '10');
        req.addParameter('offset', '0');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static TestMethod void allLicenses_Test () {
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/customer/1234';
        req.addParameter('status', 'All');
        req.addParameter('limit', '10');
        req.addParameter('offset', '0');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static TestMethod void multipleLicenses_Test1 () {
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/multipleLicenses';
        req.addParameter('Ids', 'a3K1l000000AlafEAC,a3K1l000000ARygEAG,a3K1l000000AQKtEAO,a3K1l000000AR2hEAG,a3K1l000000A5KtEAK,a3K1l000000AS1uEAG');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static TestMethod void multipleLicenses_Test2 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/multipleLicenses';
        String licIds = licenseList[0].id+','+licenseList[1].id+','+licenseList[2].id;
        req.addParameter('Ids', licIds);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static TestMethod void multipleLicenses_Test3 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/multipleLicenses';
        String licIds = licenseList[0].id;
        req.addParameter('Ids', licIds);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static TestMethod void multipleLicenses_Test4 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/multipleLicenses';
        String licIds = licenseList[0].id;
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static TestMethod void multipleLicenses_Test5 () {
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/multipleLicenses';
        req.addParameter('Ids', '');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static TestMethod void multipleLicenses_Test6 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/multipleLicenses';
        String licIds = licenseList[0].id+','+licenseList[0].id+','+licenseList[0].id+','+licenseList[0].id+','+licenseList[0].id+','+licenseList[0].id+','+licenseList[0].id+','+licenseList[0].id+','+licenseList[0].id+','+licenseList[0].id+','+licenseList[0].id;
        req.addParameter('Ids', licIds);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static testMethod void collectionLicense_Test1 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/validateCollectionLicense';
        req.addParameter('limit', '10');
        String parttyIds = accList[0].Customer_Id__c+','+accList[1].Customer_Id__c+',111111111';
        req.addParameter('partyId', parttyIds);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static testMethod void collectionLicense_Test2 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/validateCollectionLicense';
        req.addParameter('limit', '10');
        String parttyIds = accList[0].Customer_Id__c;
        req.addParameter('partyId', parttyIds);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static testMethod void collectionLicense_Test3 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/validateCollectionLicense';
        String parttyIds = accList[0].Customer_Id__c;
        req.addParameter('partyId', parttyIds);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static testMethod void collectionLicense_Test4 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/validateCollectionLicense';
        req.addParameter('limit', '10');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static testMethod void collectionLicense_Test5 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/validateCollectionLicense';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static testMethod void collectionLicense_Test6 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/validateCollectionLicense';
        req.addParameter('limit', '10');
        String parttyIds = '';
        req.addParameter('partyId', parttyIds);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static testMethod void collectionLicense_Test7 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/validateCollectionLicense';
        req.addParameter('limit', '0');
        String parttyIds = accList[0].Customer_Id__c;
        req.addParameter('partyId', parttyIds);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static testMethod void collectionLicense_Test8 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/validateCollectionLicense';
        req.addParameter('limit', 'ddgh');
        String parttyIds = accList[0].Customer_Id__c+','+conList[0].party_Id__c;
        req.addParameter('partyId', parttyIds);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static testMethod void collectionLicense_Test9 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/validateCollectionLicense';
        req.addParameter('limit', '11000');
        String parttyIds = accList[0].Customer_Id__c+','+conList[0].party_Id__c+',111111111';
        req.addParameter('partyId', parttyIds);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static testMethod void collectionLicense_Test10 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/validateCollectionLicense';
        req.addParameter('limit', '10');
        String parttyIds = accList[0].Customer_Id__c+','+conList[0].party_Id__c+',111111111';
        req.addParameter('partyId', parttyIds);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static testMethod void collectionLicense_Test11 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/validateCollectionLicense';
        req.addParameter('limit', '2');
        String parttyIds = accList[0].Customer_Id__c+','+accList[1].Customer_Id__c+',111111111';
        req.addParameter('partyId', parttyIds);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static testMethod void collectionLicense_Test12 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/validateCollectionLicense';
        req.addParameter('limit', '20');
        String parttyIds = accList[0].Customer_Id__c+','+accList[1].Customer_Id__c+',111111111';
        req.addParameter('partyId', parttyIds);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static testMethod void appliedCollectionCount_Test1 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/appliedCollectionCount/partyId/1234';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static testMethod void appliedCollectionCount_Test2 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/appliedCollectionCount/partyId/';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static testMethod void ContactsOrderByName_Test1 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/getIndividualContacts';
        req.addParameter('limit', '10');
        req.addParameter('offset', '0');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static testMethod void ContactsOrderByName_Test2 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/getIndividualContacts';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static testMethod void ContactsOrderByName_Test3 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/getIndividualContacts';
        req.addParameter('limit', '1');
        req.addParameter('offset', '2');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static testMethod void FetchLicenseByIds_Test1 () {
        setup();
        String body = '{"licenseIds": ["' + licenseList[0].id + '","' + licenseList[1].id + '"]}';
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/fetchLicenseByIds';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(body);
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doPost();
        Test.stopTest();
    }
    
    static testMethod void FetchLicenseByIds_Test2 () {
        setup();
        String body = '{"licenseIds": ["' + licenseList[0].id + '","' + licenseList[1].id + '"],}';
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/fetchLicenseByIds';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(body);
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doPost();
        Test.stopTest();
    }
    
    static testMethod void PostHasPartUpdate_Test () {
        setup();
        String body = '{"header": {},"body": {"product": {"_id": "' + p.Hub_Id__c + '","type": "collection","version": "1.0.18","title": "sdgo goal 1"},"parts": [{"_id": "fd428c4f-edc2-4dcc-9f04-376fa52d8ac3","type": "chapter","version": "1.0.0","position": 1}],"partsAdded": ["fd428c4f-edc2-4dcc-9f04-376fa52d8ac3"],"partsDeleted": [""]}}';
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/postHasPartUpdate';
        req.addParameter('type', 'update_dynamic_license');
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(body);
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doPost();
        Test.stopTest();
    }
    
    static testMethod void PostHasPartUpdate_Test2 () {
        setup();
        String body = '{"header": {},"body": {"product": {"_id": "' + p.Hub_Id__c + '","type": "collection","version": "1.0.18","title": "sdgo goal 1"},"parts": [{"_id": "fd428c4f-edc2-4dcc-9f04-376fa52d8ac3","type": "chapter","version": "1.0.0","position": 1}],"partsAdded": ["fd428c4f-edc2-4dcc-9f04-376fa52d8ac3",],"partsDeleted": [""]}}';
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/postHasPartUpdate';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(body);
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doPost();
        Test.stopTest();
    }
    
    static testMethod void PostHasPartUpdate_Test3 () {
        setup();
        String body = '';
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/postHasPartUpdate';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(body);
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doPost();
        Test.stopTest();
    }
    
    static testMethod void PostHasPartUpdate_Test4 () {
        setup();
        String body = '{"headerr": {},"bodyy": {}}';
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/postHasPartUpdate';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(body);
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doPost();
        Test.stopTest();
    }
    
    static TestMethod void getLicenseByOrganization_Test1 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/getLicenseByOrganization';
        req.addParameter('orgId', acc.id);
        req.addParameter('partyId', acc.Customer_Id__c);
        req.addParameter('licenseId', licenseList[0].id);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static TestMethod void getLicenseByOrganization_Test2 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/getLicenseByOrganization';
        req.addParameter('orgId', acc.id);
        req.addParameter('partyId', acc.Customer_Id__c);
        req.addParameter('licenseId', licenseList[0].id+','+licenseList[0].id);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static TestMethod void getLicenseByOrganization_Test3 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/getLicenseByOrganization';
        req.addParameter('orgId', acc.id+','+acc.id);
        req.addParameter('partyId', acc.Customer_Id__c);
        req.addParameter('licenseId', licenseList[0].id);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static TestMethod void getLicenseByOrganization_Test4 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/getLicenseByOrganization';
        req.addParameter('orgId', acc.id);
        req.addParameter('partyId', acc.Customer_Id__c+','+acc.Customer_Id__c);
        req.addParameter('licenseId', licenseList[0].id);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
    
    static TestMethod void getLicenseByOrganization_Test5 () {
        setup();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/getLicenseByOrganization';
        req.addParameter('orgId', acc.id);
        req.addParameter('partyId', acc.Customer_Id__c);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doGet();
        Test.stopTest();
    }
}