@isTest
public class zTEST_TF_LicenseEmailBatch_Schedule {
    static testmethod void schedulerTest() {
        Test.startTest();
        TF_LicenseEmailBatch_Schedule sch1 = new TF_LicenseEmailBatch_Schedule();
        String cron_exp = '0 00 * * * ?';
        System.schedule('Test check', cron_exp, sch1);
        
        String jobId = System.schedule('ScheduleApexClassTest',  cron_exp, new TF_LicenseEmailBatch_Schedule());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(cron_exp, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
}