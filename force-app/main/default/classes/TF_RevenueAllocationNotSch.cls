/**
Author : Radhikay Banerjee
Test class :  TF_LicenseExpiryNotificationSchTest
Description : This schedular class is used to send SNS Notification if a license expired yesterday.
**/
global class TF_RevenueAllocationNotSch implements Schedulable{
    
     global void execute(SchedulableContext sc) {
      TF_RevenueAllocationNotificationBatch batch = new TF_RevenueAllocationNotificationBatch(); 
      database.executebatch(batch,10);
   }

}