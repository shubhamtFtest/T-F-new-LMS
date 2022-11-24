/*
Apex class		: DefaultCampaignMemberStatuses_Trig
Created by		:Syam Nukilla
Created Date	:2020.02.28
*/
@isTest
public class Test_DefaultCampaignMemberStatuses_Trig {
    public static testMethod void DefaultCampaignMemberStatusesTest(){
           
        Id cmpgnRecordTypeId = Schema.getGlobalDescribe().get('Campaign').getDescribe().getRecordTypeInfosByName().get('T&F Campaigns').getRecordTypeId();
        TriggerInterfaceHelper.runTrigger('DefaultCampaignMemberStatuses_Trig', 'Campaign', 1, 'ai',  cmpgnRecordTypeId, null);
        Campaign cmpnObj = new Campaign();
        cmpnObj.Name = 'testCmpn1';
        cmpnObj.Status = 'Pending';
        cmpnObj.StartDate = Date.newInstance(2020, 2, 28);
        cmpnObj.EndDate = Date.newInstance(2020, 2, 28).addDays(2);
        cmpnObj.RecordTypeId = cmpgnRecordTypeId;
        Test.startTest();
        insert cmpnObj;
        Test.stopTest();
    }
}