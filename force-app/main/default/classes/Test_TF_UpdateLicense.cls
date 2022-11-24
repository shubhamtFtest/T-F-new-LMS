@isTest
public class Test_TF_UpdateLicense {
    
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
    
    public static testMethod void testMethod1()
    {
        setup();
        //String JSONMsg = '[{"Tf_is_Fulfilled__c": "true", "TF_Entitlement_Creation_Status__c" : "Failed","Id":licenseList[0].Id}]';
        
        Asset assetRec = [SELECT Id,Tf_is_Fulfilled__c,TF_Entitlement_Creation_Status__c  FROM Asset LIMIT 1];
        assetRec.Tf_is_Fulfilled__c = true;
        assetRec.TF_Entitlement_Creation_Status__c = 'Failed';
        
        String JSONMsg = JSON.serialize(assetRec) ;
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        system.debug('licenseList'+licenseList);
        req.requestURI = '/services/apexrest/v4/licenses/LicenseId/'+licenseList[0].Id;
        req.httpMethod = 'PATCH';
        req.requestBody = Blob.valueof(JSONMsg);
        
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        TF_UpdateLicense.doPatch();
        Test.stopTest();
    }
}