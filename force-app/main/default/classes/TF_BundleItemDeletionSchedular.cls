/**
Author : Radhikay Banerjee
Test class :  TF_BundleItemDeletionSchedularTest
Description : This schedular class is used to delete bundle line Items.
**/
global class TF_BundleItemDeletionSchedular implements Schedulable{
    
     global void execute(SchedulableContext sc) {
      TF_BundleItemDeletionBatch batch = new TF_BundleItemDeletionBatch(); 
      database.executebatch(batch,50);
   }

}