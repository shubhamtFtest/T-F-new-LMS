/***************************************************************************
Author : Vikas Varshney
Description : This class sends notification to SNS for AddLicense/UpdateLicense/CancelLicense/ExpireLicense
Test class : zTest_TF_AssetCreation_Trigger
**************************************************************************************/

public with sharing class TF_AssetCreation_Trigger implements TriggerInterface_Asset.Runnable {
    public String licenseStrJSON = '';
    public Boolean afterFlag = false;
    public Boolean insertFlag = false;
    public Boolean updateFlag = false;
    public List<AssetEMSWrapper> assetWrapperList;
    
    public void run(TriggerInterface_Asset.Trig trig) {
        Set<Id> assetIdSet = new Set<Id>(); 
        List<Asset> assetList = new List<Asset>();
        afterFlag = trig.isAfter;
        insertFlag = trig.isInsert;
        updateFlag = trig.isUpdate;
        Boolean cancelLicenseFlag = false; //SFAL-129 Vikas Varshney
        
        //Iterating asset list to get asset Id set
        if ( trig.isAfter && ( trig.isInsert || trig.isUpdate ) ) {
            if ( !trig.newList.isEmpty() ) {
                for ( Asset lic : trig.newList ) {
                    if ( ( trig.isAfter && trig.isInsert ) ) {
                        assetIdSet.add( lic.id );
                    }
                    
                    if ( trig.isAfter && trig.isUpdate && trig.oldMap.get(lic.id).Status != lic.Status && lic.Status.equalsIgnoreCase('Cancelled') ) { //SFAL-129 Vikas Varshney
                        assetIdSet.add( lic.id );
                        cancelLicenseFlag  = true;
                    }
                }
            }
        }
        System.debug('assetIdSet size =====>' + assetIdSet.size());
        System.debug('assetIdSet =====>' + assetIdSet);
        
        try {
            if ( !assetIdSet.isEmpty() ) {
                assetList = [ SELECT id, Name, TF_Grant_Type__c, Status, TF_License_Version__c, TF_License_Type__c, PurchaseDate, TF_Subscription_End_Date__c, Product2Id, Product2.Hub_Id__c, TF_Product_Version_Number__c, AccountId, Account.Type, Account.BillingCountry, Account.Customer_Id__c, ContactId, TF_Access_Scope__c, TF_OMS_Order_Id__c, TF_Product_Type__c, ( SELECT id, name, TF_Policy_Name__c, TF_Unit__c, TF_Unit_value__c FROM License_Policies__r ) FROM Asset WHERE id IN:assetIdSet ORDER BY Name ];
            }
            
            if ( !assetList.isEmpty() ) {
                if ( afterFlag && insertFlag ) {
                    assetJSONCreation(assetList, 'AddLicense');
                } else if ( afterFlag && updateFlag && cancelLicenseFlag ) { //SFAL-129 Vikas Varshney
                    assetJSONCreation(assetList, 'CancelLicense');
                }
            }
        } catch ( Exception ex ) {
            System.debug('************ Asset Trigger Exception ************' + ex.getMessage());
        }
    }
    
    //method to create a JSON on license creation and updation and passing the same to call Entitlement Management System (EMS) via SNS
    public void assetJSONCreation ( List<Asset> newAssetList, String licType ) {
        assetWrapperList = new List<AssetEMSWrapper>();
        Set<String> accCountrySet = new Set<String>(); //SFAL-242 Vikas Varshney
        Map<String, String> accCountryToCodeMap = new Map<String, String>();
        
        if ( !newAssetList.isEmpty() ) {
            for ( Asset licc : newAssetList ) {
                if ( licc.Account != NULL && String.isNotBlank(licc.Account.BillingCountry) ) { //SFAL-242 Vikas Varshney
                    accCountrySet.add( licc.Account.BillingCountry );
                }
            }
        }
        
        for ( country__c countrry : [ Select id, name, Country_2__c from country__c WHERE Name IN:accCountrySet ] ) { //SFAL-242 Vikas Varshney
            accCountryToCodeMap.put(countrry.name, countrry.Country_2__c);
        }
        System.debug('accCountryToCodeMap size =====>' + accCountryToCodeMap.size());
        System.debug('accCountryToCodeMap =====>' + accCountryToCodeMap);
        
        //Creating a JSON string for license object if license set is not null
        if ( !newAssetList.isEmpty() ) {
            for ( Asset lic : newAssetList ) {
                List<String> grantList = new List<String>();
                grantList.add( lic.TF_Grant_Type__c );
                
                //Creating wrapper
                AssetEMSWrapper assetWrapperRecord = new AssetEMSWrapper();
                assetWrapperRecord.header = new AssetEMSWrapper.Header();
                assetWrapperRecord.body = new AssetEMSWrapper.Body();
                assetWrapperRecord.body.Policy = new AssetEMSWrapper.Policy();
                
                //Mapping header values
                assetWrapperRecord.header.id = ( lic.Product2 != NULL && String.isNotBlank(lic.Product2.Hub_Id__c) ) ? lic.Product2.Hub_Id__c : '';
                assetWrapperRecord.header.timestamp = String.valueOf(System.now());
                assetWrapperRecord.header.source = 'Entitlements'; //need to check mapping
                assetWrapperRecord.header.application = 'UBX'; //need to check mapping
                assetWrapperRecord.header.action = licType;
                assetWrapperRecord.header.version = '1.0.0'; //need to check mapping
                
                //Mapping Body values
                assetWrapperRecord.body.status =  String.isNotBlank(lic.Status) ? lic.Status : '';
                assetWrapperRecord.body.licenseId = lic.id;
                assetWrapperRecord.body.licenseName = lic.Name;
                assetWrapperRecord.body.licenseVersion = String.valueOf(lic.TF_License_Version__c);
                assetWrapperRecord.body.licenseType = String.isNotBlank(lic.TF_License_Type__c) ? lic.TF_License_Type__c : '';
                assetWrapperRecord.body.licenseStartDate = lic.PurchaseDate != NULL ? String.valueOf( lic.PurchaseDate ) : '';
                assetWrapperRecord.body.licenseEndDate = lic.TF_Subscription_End_Date__c != NULL ? String.valueOf( lic.TF_Subscription_End_Date__c ) : '';
                assetWrapperRecord.body.grantType = grantList;
                assetWrapperRecord.body.licenseUpdateEndDate = lic.TF_Subscription_End_Date__c != NULL ? String.valueOf( lic.TF_Subscription_End_Date__c ) : '';
                //assetWrapperRecord.body.billingCountry = ( lic.Account != NULL && String.isNotBlank(lic.Account.BillingCountry) ) ? lic.Account.BillingCountry : '';
                assetWrapperRecord.body.billingCountry = ( accCountryToCodeMap.containsKey(lic.Account.BillingCountry) ) ? accCountryToCodeMap.get(lic.Account.BillingCountry) : '';
                assetWrapperRecord.body.productId = ( lic.Product2 != NULL && String.isNotBlank(lic.Product2.Hub_Id__c) ) ? lic.Product2.Hub_Id__c : '';
                assetWrapperRecord.body.oldproductversion = '';
                assetWrapperRecord.body.latestproductVersion = String.isNotBlank(lic.TF_Product_Version_Number__c) ? lic.TF_Product_Version_Number__c : '';
                assetWrapperRecord.body.productType = lic.TF_Product_Type__c != NULL ? lic.TF_Product_Type__c : '' ;
                assetWrapperRecord.body.customerId =  ( lic.Account != NULL && String.isNotBlank(lic.Account.Customer_Id__c) ) ? lic.Account.Customer_Id__c : ''; //SFAL-650
                assetWrapperRecord.body.customerType = ( lic.Account != NULL && String.isNotBlank(lic.Account.Type) ) ? lic.Account.Type : '';
                assetWrapperRecord.body.accessScope = String.isBlank(lic.TF_Access_Scope__c) ? 'Global' : lic.TF_Access_Scope__c;
                assetWrapperRecord.body.updateType = lic.TF_License_Type__c != NULL ? lic.TF_License_Type__c : '' ;
                
                //Mapping policy values
                if ( !lic.License_Policies__r.isEmpty() ) {
                    for ( TF_License_Policy__c licPolicy : lic.License_Policies__r ) {
                        assetWrapperRecord.body.Policy.drm = 'true';
                        if ( licPolicy.TF_Policy_Name__c == 'Concurrency' ) {
                            assetWrapperRecord.body.Policy.Concurrency = licPolicy.TF_Unit_value__c;
                        }
                        if ( licPolicy.TF_Policy_Name__c == 'Copy' ) {
                            assetWrapperRecord.body.Policy.copycount = licPolicy.TF_Unit_value__c;
                        }
                        if ( licPolicy.TF_Policy_Name__c == 'Print' ) {
                            assetWrapperRecord.body.Policy.printcount = licPolicy.TF_Unit_value__c;
                        }
                    }
                } else {
                    assetWrapperRecord.body.Policy.drm = '';
                    assetWrapperRecord.body.Policy.Concurrency = '';
                    assetWrapperRecord.body.Policy.copycount = '';
                    assetWrapperRecord.body.Policy.printcount = '';
                }
                assetWrapperList.add(assetWrapperRecord);
            }
        }
        System.debug('assetWrapperList Size =====>' + assetWrapperList.size());
        System.debug('assetWrapperList =====>' + assetWrapperList);
        
        //Serializing JSON if license wrapper list is not null
        if ( !assetWrapperList.isEmpty() && assetWrapperList.size() > 0 && assetWrapperList.size() <= 100 ) {
            licenseStrJSON = JSON.serialize(assetWrapperList);
            System.debug('licenseStrJSON =====>' + licenseStrJSON);
            callingSNSServiceLMSFuture(licenseStrJSON);
        } else {
            //need to cover other licenses
        }
    }
    
    @future(callout=true)
    public static void callingSNSServiceLMSFuture ( String licenseJsonStr ) {
        callingSNSServiceLMS(licenseJsonStr);
    }
    
    public static void callingSNSServiceLMS ( String licenseJsonString ) {
        HttpResponse awsResponse;
        List<AssetEMSWrapper> assetWrapList = new List<AssetEMSWrapper>();
        String snsJSONStr;
        Map<String, String> msgAttMap; //SFAL-208 Vikas Varshney
        System.debug('licenseJsonString =====>' + licenseJsonString);
        
        try {
            if ( String.isNotBlank(licenseJsonString) ) {
                assetWrapList = (List<AssetEMSWrapper>)System.JSON.deserialize( licenseJsonString, List<AssetEMSWrapper>.class);
            }
            System.debug('assetWrapList Size =====>' + assetWrapList.size());
            System.debug('assetWrapList =====>' + assetWrapList);
            
            if ( assetWrapList != NULL && assetWrapList.size() > 0 && assetWrapList.size() <= 100 ) {
                for ( AssetEMSWrapper wrapperRecord : assetWrapList ) {
                    awsResponse = new HttpResponse();
                    snsJSONStr = '';
                    msgAttMap = new Map<String, String>();
                    snsJSONStr = JSON.serialize(wrapperRecord);
                    msgAttMap.put('productType', wrapperRecord.body.productType);
                    msgAttMap.put('customerType', wrapperRecord.body.customerType);
                    System.debug('snsJSONStr =====>' + snsJSONStr);
                    System.debug('msgAttMap =====>' + msgAttMap);
                    awsResponse = postNotificationToSNSLMS( snsJSONStr, msgAttMap );
                    System.debug('awsResponse body =====>' + awsResponse.getBody());
                    System.debug('awsResponse Status =====>' + awsResponse.getStatus());
                    
                    if ( awsResponse != NULL && String.valueOf(awsResponse.getStatusCode()).startsWith('2') && awsResponse.getStatus().containsIgnoreCase('OK')) {
                        System.debug('*********** SNS SUCCESS ***********' + awsResponse);
                    } else {
                        System.debug('*************** SNS Failure ***************');
                        //need to cover failure scenario
                    }
                }
            }
        } catch ( Exception ex ) {
            System.debug('************ Future Failure ************' + ex.getMessage());
        }
    }
    
    //post notification to SNS, this method is implemented for posting the notification to SNS
    public static HttpResponse postNotificationToSNSLMS( String message, Map<String, String> msgAttributeMap ) {
        TF_AwsRestWrapper tFAwsRestWrapper = new TF_AwsRestWrapper();
        System.debug('msgAttributeMap =====>' + msgAttributeMap);
        try{
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            String keyAccessId = (String) orgSpecificProps.get('AWS_SNS_LMS2_0_Access_Key_Id__c');
            String secretAccessKey = (String) orgSpecificProps.get('AWS_SNS_LMS2_0_Secret_Access_key__c');
            String topicArn = (String) orgSpecificProps.get('AWS_SNS_LMS2_0_TopicArn__c');
            String regionName = (String) orgSpecificProps.get('AWS_SNS_LMS2_0_Region_Name__c');
            String hostUrl = (String) orgSpecificProps.get('AWS_SNS_LMS2_0_Host_Url__c');
            
            if( String.isNotBlank(regionName) && String.isNotBlank(keyAccessId) && String.isNotBlank(secretAccessKey) && String.isNotBlank(hostUrl) && String.isNotBlank(topicArn) && String.isNotBlank(message)){
                HttpResponse response = tFAwsRestWrapper.postToSNSLMS(message, msgAttributeMap, 'application/xml', regionName, keyAccessId, secretAccessKey, hostUrl, topicArn);
                return response;
            }
            else {
                throw new SFDCCustomException('One or more org specific property for AWS is blank');
            }
        } catch ( Exception e ) {
            System.debug('Error in processing method postNotificationsToSNS, Error Message:::::' + e.getMessage());
        }
        return null;
    }
}