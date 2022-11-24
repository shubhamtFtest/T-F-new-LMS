/**
Author : Radhikay Banerjee
Test class :  TF_LicenseExpiryNotificationBatchTest
Description : This batch class is used to send SNS Notification for revenue allocation of all type(Static/Dynamic) of Perpetual and Subscription based license.
**/
global class TF_RevenueAllocationNotificationBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    global database.querylocator start(Database.BatchableContext BC) {
        List<String> licenseType = new List<String>{'Static','Dynamic'};
        List<String> businessModel = new List<String>{'Subscription','Perpetual'};
        Date yesterdayDate = System.today();
        yesterdayDate = yesterdayDate.addDays(-1);
        String query = 'SELECT Id, Product2Id, InstallDate, SBQQ__Bundled__c, UsageEndDate, TF_Product_Type__c, TF_Subscription_End_Date__c , SBQQ__SubscriptionStartDate__c , Product2.Hub_Id__c, TF_Customer_Id__c, TF_License_Type__c, TF_Business_Model__c,TF_OMS_Order_Id__c, Tf_is_Fulfilled__c  FROM Asset where TF_Subscription_End_Date__c =: yesterdayDate OR Tf_is_Fulfilled__c = true  ';
        System.debug('TF_RevenueAllocationNotificationBatch SOQL = ' + query);
        return Database.getQueryLocator(query);        

    }
    global void execute(Database.BatchableContext BC, List<Asset> scope){
        Map<Id, Asset> staticPerpetualLicenseMap = new Map<Id, Asset>();
        Map<Id, Asset> staticSubscriptionLicenseMap = new Map<Id, Asset>();
        Map<Id, Asset> dynamicPerpetualLicenseMap = new Map<Id, Asset>();
        Map<Id, Asset> dynamicSubscriptionLicenseMap = new Map<Id, Asset>();
        List<String> orderIdList = new List<String>();
        Map<String, Order> assetOrderMap = new Map<String, order>();
        Date yesterdayDate = System.today();
        yesterdayDate = yesterdayDate.addDays(-1);
        
        if(scope != null && scope.size() > 0){
            for(Asset asset : scope){
                System.debug('asset.TF_OMS_Order_Id__c : '+ asset.TF_OMS_Order_Id__c);
                orderIdList.add(asset.TF_OMS_Order_Id__c);
            }
            List<Order> orderList = [SELECT Id, T_F_Order_Number__c, Total_Price__c ,EffectiveDate,OrderReferenceNumber  FROM Order where OrderReferenceNumber IN:orderIdList];
            if(orderList != null && orderList.size() > 0){
                for(Order tOrder : orderList){
                    assetOrderMap.put(tOrder.OrderReferenceNumber, tOrder);
                }
            }
            for(Asset thisAsset : scope){
                if(thisAsset.TF_License_Type__c != null && thisAsset.TF_License_Type__c == 'Static'){
                    if(thisAsset.TF_Business_Model__c != null && thisAsset.TF_Business_Model__c == 'Perpetual' ){
                        if(thisAsset.Tf_is_Fulfilled__c && thisAsset.SBQQ__Bundled__c ){
                            staticPerpetualLicenseMap.put(thisAsset.id, thisAsset);
                            System.debug('staticPerpetualLicenseMap : ' + staticPerpetualLicenseMap);
                        }
                    }
                    if(thisAsset.TF_Business_Model__c != null && thisAsset.TF_Business_Model__c == 'Subscription' && thisAsset.SBQQ__Bundled__c && thisAsset.TF_Subscription_End_Date__c == yesterdayDate){
                        staticSubscriptionLicenseMap.put(thisAsset.id, thisAsset);
                        System.debug('staticSubscriptionLicenseMap : ' + staticSubscriptionLicenseMap);
                    }    
                }else{
                    if(thisAsset.TF_License_Type__c != null && thisAsset.TF_License_Type__c == 'Dynamic' && thisAsset.SBQQ__Bundled__c && thisAsset.TF_Subscription_End_Date__c == yesterdayDate){
                       if(thisAsset.TF_Business_Model__c != null && thisAsset.TF_Business_Model__c == 'Perpetual' ){
                            dynamicPerpetualLicenseMap.put(thisAsset.id, thisAsset);
                           System.debug('dynamicPerpetualLicenseMap : ' + dynamicPerpetualLicenseMap);
                        }
                        if(thisAsset.TF_Business_Model__c != null && thisAsset.TF_Business_Model__c == 'Subscription' ){
                            dynamicSubscriptionLicenseMap.put(thisAsset.id, thisAsset);
                            System.debug('dynamicSubscriptionLicenseMap : ' + dynamicSubscriptionLicenseMap);
                        }  
                    }     
                }
            } 
            
            if(staticPerpetualLicenseMap.size() > 0){
                allLicenseSNSNotification(staticPerpetualLicenseMap, assetOrderMap);
            }
            if(staticSubscriptionLicenseMap.size() > 0){
                allLicenseSNSNotification(staticSubscriptionLicenseMap, assetOrderMap);
            }
            if(dynamicPerpetualLicenseMap.size() > 0){
                allLicenseSNSNotification(dynamicPerpetualLicenseMap, assetOrderMap);
            }
            if(dynamicSubscriptionLicenseMap.size() > 0){
                allLicenseSNSNotification(dynamicSubscriptionLicenseMap, assetOrderMap);
            }
        }
        
       
        
        
    }    
    global void finish(Database.BatchableContext BC){
      System.debug('TF_RevenueAllocationNotificationBatch: finish');
       
    }
    
    private static void allLicenseSNSNotification(Map<Id, Asset> licenseMap, Map<String, Order> assetOrderMap){
        String json;
        TF_AWSService awsService = new TF_AWSService();
        System.debug('licenseMap :: '+ licenseMap);
        System.debug('assetOrderMap :: '+ assetOrderMap);
        if(assetOrderMap != null && assetOrderMap.size() > 0 && licenseMap != null && licenseMap.size() > 0){
            for(Asset thisAsset : licenseMap.Values()){
                 System.debug('assetOrderMap Value:: '+ assetOrderMap.get(thisAsset.TF_OMS_Order_Id__c));
                Order thisOrder = assetOrderMap.get(thisAsset.TF_OMS_Order_Id__c);
                System.debug('thisOrder :: '+ thisOrder);
                json = TF_GenerateJson.GenerateSNSJsonRevAllcocation(thisAsset,thisOrder);
                HttpResponse response = awsService.postRevenueAllocationNotificationToSNS(json);
            }
               
        }
    }
    
}