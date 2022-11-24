/**
Author : Radhikay Banerjee
Apex class :  TF_LicenseExpiryNotificationBatch
**/
@isTest(seeAllData=false)
public class TF_RevAllocationNotificationBatchTest  {
    
    @istest 
     private static void test_execute(){
         
        TF_OrgSpecificProps__c  orgspecificprops = new TF_OrgSpecificProps__c ();
        orgspecificprops.AWS_SNS_LMS2_0_OMS_Region_Name__c   =   'test';
        orgspecificprops.AWS_SNS_LMS2_0_OMS_Access_Key_Id__c  = '1010E';
        orgspecificprops.AWS_SNS_LMS2_0_OMS_Secret_Access_key__c = 'test';
        orgspecificprops.AWS_SNS_LMS2_0_OMS_Host_Url__c = 'test';
        orgspecificprops.AWS_SNS_LMS2_0_OMS_TopicArn__c = 'test';
        insert orgspecificprops;
          
         
         Date todaysDate = System.today();
        todaysDate = todaysDate.addDays(-1);
         
         Account thisAccount = new Account();
         thisAccount.Name = 'testAcc';
         thisAccount.Customer_Id__c = '022113';
         insert thisAccount;
         
         Record_Creation_Request__c recordRequest = new Record_Creation_Request__c();
        recordRequest.TF_Request_JSON__c = 'JSONReq';
        recordRequest.TF_Status__c = 'RECEIVED';
        recordRequest.Request_Type__c = 'Create'; 
        recordRequest.TF_RequestID__c = '125';
    recordRequest.TF_CallBackUrl__c = 'callback URL'; 
        insert recordRequest;
         
        Asset thisAsset = new Asset();
        thisAsset.TF_Business_Model__c = 'Subscription';
        thisAsset.TF_License_Type__c = 'Static';
        thisAsset.Name = 'Applied PsychologyTest';
        thisAsset.TF_License_Creation_Request__c =  recordRequest.Id;
        thisAsset.TF_Subscription_End_Date__c = todaysDate;
         thisAsset.TF_OMS_Order_Id__c = 'ORD0001';
        thisAsset.SBQQ__Bundled__c = true;
        insert thisAsset;
         Order thisOrder = new Order();
         thisOrder.T_F_Order_Number__c = '0001';
         thisOrder.OrderReferenceNumber = 'ORD0001';
         thisOrder.AccountId = thisAccount.Id;
         thisOrder.EffectiveDate = todaysDate.addDays(-3);
         thisOrder.Status = 'Draft';
         insert thisOrder;
         
         Test.startTest();
        

         TF_RevenueAllocationNotificationBatch obj = new TF_RevenueAllocationNotificationBatch();
         DataBase.executeBatch(obj,100); 
         Test.stopTest();
         
     }

}