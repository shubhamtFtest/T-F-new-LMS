/**
Author : Radhikay Banerjee
Apex class :  TF_BundleItemDeletionSchedular
**/
@isTest(seeAllData=false)
public class TF_BundleItemDeletionSchedularTest {
     @istest 
     private static void test_execute(){
         Test.startTest();
         TF_BundleItemDeletionSchedular sch = new TF_BundleItemDeletionSchedular();
     //Define cron expression
     String cronExp1 = '0 0 * * * ?';
     String jobID = System.schedule('TF_BundleItemDeletionSchedular', cronExp1, sch); 
         Test.stopTest();
       
     }
}