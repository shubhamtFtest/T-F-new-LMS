//This is the test class for TF_LicenseStaticBatch_Schedule

@isTest
public class zTEST_TF_LicenseStaticBatch_Schedule {
    static testmethod void staticSchedulerTest() {
        Test.startTest();
        TF_LicenseStaticBatch_Schedule sch1 = new TF_LicenseStaticBatch_Schedule();
        String cron_exp = '0 5 0 1/1 * ? *';
        System.schedule('Test check', cron_exp, sch1);
        
        String jobId = System.schedule('ScheduleApexClassTest',  cron_exp, new TF_LicenseStaticBatch_Schedule());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(cron_exp, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
}