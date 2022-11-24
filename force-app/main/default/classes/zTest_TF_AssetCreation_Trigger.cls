/*********************************************************************************
Author : Vikas Varshney
Apex class : TF_AssetCreation_Trigger
*******************************************************************************/

@isTest
global class zTest_TF_AssetCreation_Trigger {
    static final String baseUrl = Url.getSalesforceBaseUrl().toExternalForm();
    
    static testMethod void CreateAssetTest() {
        Id TF_Asset_RT = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('T&F-License').getRecordTypeId();
        TriggerInterfaceHelper.runTrigger('TF_AssetCreation_Trigger', 'Asset', 1, 'ai,au', TF_Asset_RT, null);
        
        Account acc = new Account();
        acc.Customer_Id__c = '98422';
        acc.name = 'TestAcc';
        insert acc;
        
        Product2 p = new Product2();
        p.Name = 'test_pro';
        p.IsActive = true;
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
        List<Asset> licenseList = new List<Asset>();
        licenseList.add( new Asset(Name = 'Testing 2', AccountId = acc.id, Status = 'Created', Product2Id = p.id, TF_Sales_Channel__c = 'UBX', TF_Entitlement_Creation_Status__c = 'Pending', TF_Grant_Type__c = 'ViewOnline', InstallDate = Date.today().addDays(5), UsageEndDate = Date.today().addDays(10)));
        licenseList.add( new Asset(Name = 'Testing 3', AccountId = acc.id, Status = 'Created', Product2Id = p.id, TF_Sales_Channel__c = 'UBX', TF_Entitlement_Creation_Status__c = 'Pending', TF_Grant_Type__c = 'ViewOnline', InstallDate = Date.today().addDays(5), UsageEndDate = Date.today().addDays(10)));
        licenseList.add( new Asset(Name = 'Testing 4', AccountId = acc.id, Status = 'Created', Product2Id = p.id, TF_Sales_Channel__c = 'UBX', TF_Entitlement_Creation_Status__c = 'Pending', TF_Grant_Type__c = 'ViewOnline', InstallDate = Date.today().addDays(5), UsageEndDate = Date.today().addDays(10)));
        insert licenseList;
        
        //Creating License Policies
        List<TF_License_Policy__c> licensePolicyList = new List<TF_License_Policy__c>();
        licensePolicyList.add( new  TF_License_Policy__c(TF_Asset__c = licenseList[0].Id,TF_Policy_Name__c = 'Concurrency',TF_Scope__c = 'Global',TF_Unit_value__c  = '10'));
        insert licensePolicyList;
       
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri = baseUrl + '/services/apexrest/LicenseCreateRequestAPI/salesforceLicenseCreation';
        request.httpMethod = 'POST';
        request.requestBody = blob.valueOf('{"orderNumber":"ODR98739393","requestId":"78979879","requestType":"Create","requestPayload":{"orderId":"100","source":"OMS","salesChannel":"UBX","customer":{"partyId":"98422","type":"CONSORTIUM","members":["98422"]},"products":[{"productType":"COLLECTION","productUUID":"e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a","version":"1.0","orderLineItemId":"1234","licenseDetails":{"channel":"UBX","startDate":"2023-12-31","endDate":"2024-12-31","licenseType":"Subscription","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":false,"concurrency":"0","grantType":["Download"],"copyCount":"1","printCount":"1"}}}]},"callBackurl":"Provided by OMS"}');
        RestContext.request = request;
        RestContext.response = res;
        Test.startTest();
        TF_LicenseRequestCreationAPI.licenseCreationSync();
        Test.stopTest();
        List<Record_Creation_Request__c> rcrList = [ SELECT id, name FROM Record_Creation_Request__c ];
        System.debug('rcrList Size =====>' + rcrList.size());
        System.debug('rcrList =====>' + rcrList);
        if ( !rcrList.isEmpty() ) {
            List<Asset> assetList = [ SELECT id, name FROM Asset WHERE TF_License_Creation_Request__c =:rcrList[0].id ];
        }
        System.debug('res =====>' + res);
        if ( res != NULL ) {
            String actualRes = res.responseBody.toString(); //Converting Blob to String
        	System.debug('actual  =====>' + actualRes);
        }
       
    }
}