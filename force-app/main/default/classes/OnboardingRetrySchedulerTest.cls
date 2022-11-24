@isTest(seeAllData=false)
public class OnboardingRetrySchedulerTest {
     @istest 
     private static void test_execute(){
         Test.startTest();
         OnBoardingRetryScheduler sch = new OnBoardingRetryScheduler();
		 //Define cron expression
		 String cronExp1 = '0 0 * * * ?';
		 String jobID = System.schedule('Onborading_RetryTest_01', cronExp1, sch); 
         Test.stopTest();
       
     }
}