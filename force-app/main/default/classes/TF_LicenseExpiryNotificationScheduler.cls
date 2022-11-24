/**
Author : Radhikay Banerjee
Test class :  TF_LicenseExpiryNotificationSchTest
Description : This schedular class is used to send SNS Notification if a license expired yesterday.
**/
global class TF_LicenseExpiryNotificationScheduler implements Schedulable{
    global void execute(SchedulableContext sc) {
        TF_LicenseExpiryNotificationBatch batch = new TF_LicenseExpiryNotificationBatch(); 
        database.executebatch(batch,1);
    }
}