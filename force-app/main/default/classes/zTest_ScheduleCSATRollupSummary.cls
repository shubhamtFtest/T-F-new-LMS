//Creted by Ashish Purwar on 05-03-2018
//This class is test class for scheduler class ScheduleCSATRollupSummary
@isTest
public class zTest_ScheduleCSATRollupSummary {
    static testMethod void  testschedule() {        
        Test.StartTest();
        ScheduleCSATRollupSummary sh1 = new ScheduleCSATRollupSummary();      
        String sch = '0 48 17 07 05 ?';
        system.schedule('Test ScheduleCSATRollupSummary', sch, sh1);
        Test.stopTest();
        
    }
}