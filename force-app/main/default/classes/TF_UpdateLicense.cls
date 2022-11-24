@RestResource(urlMapping='/v4/licenses/LicenseId/*')
global with sharing class TF_UpdateLicense {
    @HttpPatch
    global static void doPatch() {
        
        RestRequest AssetRequest = RestContext.request;
        String AssetRequestURI = AssetRequest.requestURI;
        String AssetId = AssetRequestURI.substring(AssetRequestURI.lastIndexOf('/') + 1);
        String requestBody = AssetRequest.requestBody.toString();
        System.debug('requestBody--->'+requestBody); 
        System.debug('AssetRequest--->'+AssetRequest); 
        Asset assetRec;
        
        if(String.isNotEmpty(AssetId)) {
            assetRec = (Asset)JSON.deserialize(requestBody, Asset.class);
            System.debug('Asset--->'+assetRec);
            if(assetRec.Tf_is_Fulfilled__c==true || assetRec.Tf_is_Fulfilled__c==false)
            {
                if(assetRec.TF_Entitlement_Creation_Status__c =='Pending' || assetRec.TF_Entitlement_Creation_Status__c == 'Failed' || assetRec.TF_Entitlement_Creation_Status__c == 'Created'){
                    assetRec.Id = AssetId;
                    update assetRec;
                }
                else{
                    System.debug('Error TF_Entitlement_Creation_Status__c');
                }
            }
            else{
                System.debug('Error Tf_is_Fulfilled__c');
            }
            
        }
    }
}