public class TF_AWSService{
     
    TF_AwsRestWrapper  tFAwsRestWrapper = new TF_AwsRestWrapper();
    /*
** Get Collection product detail and place it in aws s3
*/              
    public String putProductJsonToS3(String payload, String productId, String bucketName){
        try{
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            String folderPath = '';
            String regionName = (String) orgSpecificProps.get('AWS_Region_Name__c');
            String keyAccessId = (String) orgSpecificProps.get('AWS_Access_Key_Id__c');
            String secretAccessKey = (String) orgSpecificProps.get('AWS_Secret_Access_key__c');
            String hostUrl = 'https://'+ bucketName + (String) orgSpecificProps.get('AWS_S3_Host_Url__c');
            if( String.isNotBlank(regionName) && String.isNotBlank(keyAccessId) && String.isNotBlank(secretAccessKey) && String.isNotBlank(hostUrl) && String.isNotBlank(productId)){
                String sampleText = 'test string';
                String objectName = 'test ObjectName';
                String response = tFAwsRestWrapper.put(payload ,'application/json', regionName, folderPath, productId, productId, keyAccessId, secretAccessKey, hostUrl);
                if(response != null){
                    System.debug('Product Placed in S3');
                    return response;
                } else {
                    System.debug('Error Placing the product in S3');
                    return null;
                } 
            }
            else {
                throw new SFDCCustomException('One or more org specific property for AWS is blank');
            }
        } catch(Exception e){
            System.debug('Error in processing method putProductJsonToS3, Error Message:'+e.getMessage());
        }
        return null;
    }
    
    /**
     * Set the Product product notification
     **/
    public HttpResponse sendCustomerNotification(String message) {
          try{
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            String regionName = (String) orgSpecificProps.get('AWS_Region_Name__c');
            String keyAccessId = (String) orgSpecificProps.get('AWS_Access_Key_Id__c');
            String secretAccessKey = (String) orgSpecificProps.get('AWS_Secret_Access_key__c');
            String hostUrl = (String) orgSpecificProps.get('AWS_SNS_Host_Url__c');
            String topicArn = (String) orgSpecificProps.get('AWS_SNS_TopicArn__c');
            
             
            system.debug('topicArn'+topicArn);
            if( String.isNotBlank(regionName) && String.isNotBlank(keyAccessId) && String.isNotBlank(secretAccessKey) && String.isNotBlank(hostUrl) && String.isNotBlank(topicArn) && String.isNotBlank(message)){
                HttpResponse response = tFAwsRestWrapper.postToSNS(message, 'application/json', regionName, keyAccessId, secretAccessKey, hostUrl, topicArn);
                System.debug('response:'+response);
                return response;
            }
            else {
                throw new SFDCCustomException('One or more org specific property for AWS is blank');
            }
        } catch(Exception e){
            System.debug('Error in processing method postNotificationToSNS, Error Message:'+e.getMessage());
        }
        return null;

    }
    
    /*
**  place UUID mapping request JSON in S3
*/              
    public String putUUIDRequestJsonToS3(String payload, String productId, String bucketName, String folderPath){
        try{
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            String regionName = (String) orgSpecificProps.get('AWS_Region_Name__c');
            String keyAccessId = (String) orgSpecificProps.get('AWS_Access_Key_Id__c');
            String secretAccessKey = (String) orgSpecificProps.get('AWS_Secret_Access_key__c');
            String hostUrl = 'https://'+ bucketName + (String) orgSpecificProps.get('AWS_S3_Host_Url__c');
            if( String.isNotBlank(regionName) && String.isNotBlank(keyAccessId) && String.isNotBlank(secretAccessKey) && String.isNotBlank(hostUrl) && String.isNotBlank(productId)){
                String sampleText = 'test string';
                String objectName = 'test ObjectName';
                String response = tFAwsRestWrapper.put(payload ,'application/json', regionName, folderPath, productId, productId, keyAccessId, secretAccessKey, hostUrl);
                if(response != null){
                    System.debug('JSON Placed in S3');
                    return response;
                } else {
                    System.debug('Error Placing the JSON in S3');
                    return null;
                }
            }
            else {
                throw new SFDCCustomException('One or more org specific property for AWS is blank');
            }
        } catch(Exception e){
            System.debug('Error in processing method putUUIDRequestJsonToS3, Error Message:'+e.getMessage());
        }
        return null;
    }
    
    /*
** Get Collection product detail from aws s3
*/
    public String getUUIDJsonFromS3(String fileName, String folderPath){
        try{
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            String regionName = (String) orgSpecificProps.get('AWS_Region_Name__c');
            String keyAccessId = (String) orgSpecificProps.get('AWS_Access_Key_Id__c');
            String secretAccessKey = (String) orgSpecificProps.get('AWS_Secret_Access_key__c');
            String bucketName = (String) orgSpecificProps.get('AWS_S3_Validation_Bucket__c');
            String hostUrl = 'https://'+ bucketName + (String) orgSpecificProps.get('AWS_S3_Host_Url__c');
            
            if(String.isNotBlank(regionName) && String.isNotBlank(keyAccessId) && String.isNotBlank(secretAccessKey) && String.isNotBlank(hostUrl)){
                String objectName = 'test ObjectName';
                String response = tFAwsRestWrapper.get(regionName, folderPath, fileName, fileName, keyAccessId, secretAccessKey, hostUrl);
                if(response != null){
                    //System.debug('response'+response);
                    return response;
                }
            } 
            else {
                throw new SFDCCustomException('One or more org specific property for AWS is blank');
            }
        } catch(Exception e){
            System.debug('Error in processing method getUUIDJsonFromS3, Error Message:'+ e.getMessage());
        }
        return null;
    }  
    
    /*
** post s3 location to sns
*/
    public HttpResponse postNotificationToSNS(String message, String productId){
        try{
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            String regionName = (String) orgSpecificProps.get('AWS_Region_Name__c');
            String keyAccessId = (String) orgSpecificProps.get('AWS_Access_Key_Id__c');
            String secretAccessKey = (String) orgSpecificProps.get('AWS_Secret_Access_key__c');
            String hostUrl = (String) orgSpecificProps.get('AWS_SNS_Host_Url__c');
            String topicArn = (String) orgSpecificProps.get('AWS_SNS_TopicArn__c');
            system.debug('topicArn'+topicArn);
            if( String.isNotBlank(regionName) && String.isNotBlank(keyAccessId) && String.isNotBlank(secretAccessKey) && String.isNotBlank(hostUrl) && String.isNotBlank(topicArn) && String.isNotBlank(message)){
                HttpResponse response = tFAwsRestWrapper.postToSNS(message, 'application/xml', regionName, keyAccessId, secretAccessKey, hostUrl, topicArn);
                return response;
            }
            else {
                throw new SFDCCustomException('One or more org specific property for AWS is blank');
            }
        } catch(Exception e){
            System.debug('Error in processing method postNotificationToSNS, Error Message:'+e.getMessage());
        }
        return null;
    }
    
    /*
	** post s3 location to sns
	*/
    public HttpResponse postAccountSyncNotificationToSNS(String message){
        try{
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            String regionName = (String) orgSpecificProps.get('AWS_Account_Request_Region_Name__c');
            String keyAccessId = (String) orgSpecificProps.get('AWS_Access_Key_Id__c');
            String secretAccessKey = (String) orgSpecificProps.get('AWS_Secret_Access_key__c');
            String hostUrl = (String) orgSpecificProps.get('AWS_Account_Request_SNS_Host_Url__c');
            String topicArn = (String) orgSpecificProps.get('AWS_Account_Request_SNS_TopicArn__c');
            system.debug('topicArn'+topicArn);
            if( String.isNotBlank(regionName) && String.isNotBlank(keyAccessId) && String.isNotBlank(secretAccessKey) && String.isNotBlank(hostUrl) && String.isNotBlank(topicArn) && String.isNotBlank(message)){
                HttpResponse response = tFAwsRestWrapper.postToSNS(message, 'application/json', regionName, keyAccessId, secretAccessKey, hostUrl, topicArn);
                System.debug('postAccountSyncNotificationToSNS Response : '+response);
                return response;
            }
            else {
                throw new SFDCCustomException('One or more org specific property for AWS is blank');
            }
        } catch(Exception e){
            System.debug('Error in processing method postNotificationToSNS, Error Message:'+e.getMessage());
        }
        return null;
    }
    
    /*
	** post s3 location to sns
	*/
    public HttpResponse postAccountSyncNotificationToSNSNamedCred(String message){
        try{
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            String topicArn = (String) orgSpecificProps.get('AWS_Account_Request_SNS_TopicArn__c');
            HttpRequest req = new HttpRequest();
            String finalMessage = EncodingUtil.urlEncode(message, 'UTF-8');
            System.debug('finalMessage' + finalMessage);
            req.setEndpoint('callout:AWS/?Action=Publish&Version=2010-03-31&Message='+finalMessage+'&TopicArn='+topicARN);
			req.setMethod('POST');
			req.setHeader('Content-Type','application/json');
            req.setBody(message);
			Http http = new Http();
			HTTPResponse res = http.send(req);
			System.debug(res.getBody());
			System.debug(res.getStatusCode());
			System.debug(res.getStatus());
        } catch(Exception e){
            System.debug('Error in processing method postAccountSyncNotificationToSNSNamedCred, Error Message:'+e.getMessage());
        }
        return null;
    }
    
    /*
** post to sqs
*/
    public HttpResponse postNotificationToSQS(String messageBody){
        try{
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            String regionName =         (String) orgSpecificProps.get('AWS_Region_Name__c');
            String keyAccessId =        (String) orgSpecificProps.get('AWS_SQS_Access_Key_Id__c');
            String secretAccessKey =    (String) orgSpecificProps.get('AWS_SQS_Secret_Access_key__c');
            String hostUrl =            (String) orgSpecificProps.get('AWS_SQS_Host_Url__c');   
            String queueName =          (String) orgSpecificProps.get('AWS_SQS_Queue_Name__c');
            
            if( String.isNotBlank(regionName) && String.isNotBlank(keyAccessId) && String.isNotBlank(secretAccessKey) && String.isNotBlank(hostUrl) && String.isNotBlank(messageBody)){
                HttpResponse response = tFAwsRestWrapper.postToSQS(messageBody, 'application/xml', regionName, keyAccessId, secretAccessKey, hostUrl, queueName);
                System.debug('response : '+response);
                return response;
            }
            else {
                throw new SFDCCustomException('One or more org specific property for AWS is blank');
            }
        } catch(Exception e){
            System.debug('Error in processing method postNotificationToSQS, Error Message:'+e.getMessage());
            
        }
        return null;
    }
    
    public HttpResponse postRevenueAllocationNotificationToSNS(String message){
        try{
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            String regionName = (String) orgSpecificProps.get('AWS_SNS_LMS2_0_OMS_Region_Name__c');
            String keyAccessId = (String) orgSpecificProps.get('AWS_SNS_LMS2_0_OMS_Access_Key_Id__c');
            String secretAccessKey = (String) orgSpecificProps.get('AWS_SNS_LMS2_0_OMS_Secret_Access_key__c');
            String hostUrl = (String) orgSpecificProps.get('AWS_SNS_LMS2_0_OMS_Host_Url__c');
            String topicArn = (String) orgSpecificProps.get('AWS_SNS_LMS2_0_OMS_TopicArn__c');
             
            
            system.debug('topicArn'+topicArn);
            if( String.isNotBlank(regionName) && String.isNotBlank(keyAccessId) && String.isNotBlank(secretAccessKey) && String.isNotBlank(hostUrl) && String.isNotBlank(topicArn) && String.isNotBlank(message)){
                HttpResponse response = tFAwsRestWrapper.postToSNS(message, 'application/json', regionName, keyAccessId, secretAccessKey, hostUrl, topicArn);
                System.debug('postRevenueAllocationNotificationToSNS Response : '+response);
                return response;
            }
            else {
                throw new SFDCCustomException('One or more org specific property for AWS is blank');
            }
        } catch(Exception e){
            System.debug('Error in processing method postRevenueAllocationNotificationToSNS, Error Message:'+e.getMessage());
        }
        return null;
    }
}