/**
Author : Radhikay Banerjee
Apex class :  TF_LicenseExpiryNotificationBatch
**/
@isTest(seeAllData=false)
public class TF_LicenseExpiryNotificationBatchTest {
    
    @istest 
    private static void test_execute(){
        
        TF_OrgSpecificProps__c  orgspecificprops = new TF_OrgSpecificProps__c ();
        orgspecificprops.AWS_SNS_LMS2_0_Access_Key_Id__c   =   'test';
        orgspecificprops.AWS_SNS_LMS2_0_Secret_Access_key__c  = '1010E';
        orgspecificprops.AWS_SNS_LMS2_0_Region_Name__c = 'test';
        orgspecificprops.AWS_SNS_LMS2_0_TopicArn__c = 'test';
        orgspecificprops.AWS_SNS_LMS2_0_Host_Url__c = 'test';
        insert orgspecificprops;
        
        Date todaysDate = System.today();
        todaysDate = todaysDate.addDays(-1);
        Record_Creation_Request__c recordRequest = new Record_Creation_Request__c();
        recordRequest.TF_Request_JSON__c = 'JSONReq';
        recordRequest.TF_Status__c = 'RECEIVED';
        recordRequest.Request_Type__c = 'Create'; 
        recordRequest.TF_RequestID__c = '125';
        recordRequest.TF_CallBackUrl__c = 'callback URL'; 
        insert recordRequest;
        
        Asset thisAsset = new Asset();
        thisAsset.TF_Access_Scope__c = 'Global';
        thisAsset.TF_Business_Model__c = 'Subscription';
        thisAsset.TF_License_Type__c = 'Static';
        thisAsset.Name = 'Applied PsychologyTest';
        thisAsset.TF_License_Creation_Request__c =  recordRequest.Id;
        thisAsset.TF_Subscription_End_Date__c = todaysDate;
        insert thisAsset;
        
        Test.startTest();
        
        
        TF_LicenseExpiryNotificationBatch obj = new TF_LicenseExpiryNotificationBatch();
        DataBase.executeBatch(obj,100); 
        Test.stopTest();
        
    }
    
}