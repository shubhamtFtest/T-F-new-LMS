/**
Author : Radhikay Banerjee
Apex class :  TF_LicenseExpiryNotificationScheduler
**/
@isTest(seeAllData=false)
public class TF_LicenseExpiryNotificationSchTest {
     @istest 
     private static void test_execute(){
         Test.startTest();
         TF_LicenseExpiryNotificationScheduler sch = new TF_LicenseExpiryNotificationScheduler();
     //Define cron expression
     String cronExp1 = '0 0 * * * ?';
     String jobID = System.schedule('TF_LicenseExpiryNotificationScheduler', cronExp1, sch); 
         Test.stopTest();
       
     }
}