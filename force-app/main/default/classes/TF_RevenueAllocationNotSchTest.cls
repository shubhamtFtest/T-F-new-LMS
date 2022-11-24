/**
Author : Radhikay Banerjee
Apex class :  TF_RevenueAllocationNotSch
**/
@isTest(seeAllData=false)
public class TF_RevenueAllocationNotSchTest {
     @istest 
     private static void test_execute(){
         Test.startTest();
         TF_RevenueAllocationNotSch sch = new TF_RevenueAllocationNotSch();
     //Define cron expression
     String cronExp1 = '0 0 * * * ?';
     String jobID = System.schedule('TF_RevenueAllocationNotSch', cronExp1, sch); 
         Test.stopTest();
       
     }
}