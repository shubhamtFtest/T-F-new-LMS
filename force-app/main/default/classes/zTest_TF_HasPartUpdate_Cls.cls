/**********************************************************************
//This is test class is for "TF_HasPartUpdate_Cls"
***********************************************************************/

@isTest
global class zTest_TF_HasPartUpdate_Cls {
    static List<License__c> licenseList = new List<License__c>();
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
    
    static TestMethod void hasPartUpdate_Cls_Test () {
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
    
    static TestMethod void hasPartUpdate_Cls_Test2 () {
        setup();
        String body = '{"header": {},"body": {"product": {"_id": "' + p.Hub_Id__c + '","type": "collection","version": "1.0.18","title": "sdgo goal 1"},"parts": [{"_id": "fd428c4f-edc2-4dcc-9f04-376fa52d8ac3","type": "chapter","version": "1.0.0","position": 1}],"partsAdded": ["fd428c4f-edc2-4dcc-9f04-376fa52d8ac3"],"partsDeleted": [""]}}';
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response1 = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/licenses/postHasPartUpdate';
        req.addParameter('type', 'update_all_license');
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(body);
        RestContext.request = req;
        RestContext.response = response1;
        TF_LicenseAPIExposeService.doPost();
        Test.stopTest();
    }
}