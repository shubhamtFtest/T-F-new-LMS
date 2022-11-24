/**
Author : Radhikay Banerjee
Test class :  TF_LicenseExpiryNotificationBatchTest
Description : This batch class is used to send SNS Notification if a license expired yesterday.
**/
global class TF_LicenseExpiryNotificationBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    public String uri;
    public TF_AWSService awsService;
    public Map<String, String> headers;  

    global database.querylocator start(Database.BatchableContext BC) {
        List<String> inactiveStatus = new List<String>{'Expired','Cancelled'};
        String businessModel = 'Subscription';
        Date yesterdayDate = System.today();
        yesterdayDate = yesterdayDate.addDays(-1);
        String query = 'SELECT Id, Product2Id, Product2.Hub_Id__c, TF_Customer_Id__c FROM Asset WHERE TF_Business_Model__c =: businessModel AND TF_Subscription_End_Date__c =: yesterdayDate AND Status NOT IN:inactiveStatus ';
        System.debug('TF_LicenseExpiryNotificationBatch SOQL = ' + query);
        return Database.getQueryLocator(query);        

    }
    global void execute(Database.BatchableContext BC, List<Asset> scope){
       System.debug('TF_LicenseExpiryNotificationBatch: Inside execute');
        System.debug('scope: '+scope);
        System.debug('scope size: '+scope.size());
        List<Asset> updatedAssetList = new List<Asset>();
        
        String finalMessageBody;
        for(Asset scopeAsset : scope){
            finalMessageBody = generateJSONMessage(scopeAsset);
            Map<String, String> msgAttributeMap = new Map<String, String>();
            msgAttributeMap.put('','');
            HttpResponse resp = TF_AssetCreation_Trigger.postNotificationToSNSLMS (finalMessageBody, msgAttributeMap);
            if(resp.getStatus() == 'Success'){
                Asset updateAsset = new Asset();
                updateAsset.Id = scopeAsset.Id;
                updateAsset.Status = 'Expired';
                updatedAssetList.add(updateAsset); 
            }
        }
        
        if(updatedAssetList != null && updatedAssetList.size() > 0){
            Database.update(updatedAssetList);
        }
        
        
        
    }    
    global void finish(Database.BatchableContext BC){
      System.debug('TF_LicenseExpiryNotificationBatch: finish');
       
    }
    
    private static String generateJSONMessage(Asset thisAsset){
        String finalMsg;
        String messageBody = '{ "headers":{"id":"'+ thisAsset.Product2.Hub_Id__c +'","source":"Salesforce","timestamp":"'+String.valueOf(Datetime.now())+'","action": "ExpireLicense","version":"1.0"},"body":{ ';
        messageBody = messageBody + '"status": "","licenseId": "' + thisAsset.Id + '","licenseName": "","licenseVersion": "","licenseType": "","licenseStartDate": "","licenseEndDate": "","grantType": [],"licenseUpdateEndDate": "","billingCountry": "","productId":"' + thisAsset.Product2Id + '","oldproductversion":"","latestproductVersion": "","productType": "","customerId":"' + thisAsset.TF_Customer_Id__c + '","customerType": "","accessScope": "","updateType": "","policy": {"drm":"true","Concurrency":"","copycount":"","printcount":""}}';
        
        finalMsg = messageBody + '}';
        return finalMsg;
    }
          

}