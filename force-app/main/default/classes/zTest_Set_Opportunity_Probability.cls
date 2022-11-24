/************************************************************************
* 
*   Created by: Tom Reed - 2018-10-01
*   Test Class for: Set_Opportunity_Probability
*
*************************************************************************/
@isTest
public class zTest_Set_Opportunity_Probability {
    
    public static testmethod void Test_Set_Opportunity_Probability(){
        String runningUser = UserInfo.getUserId();
        Account newAccount = zTest_Shared.insertAccount(runningUser);
        Id devRecordTypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity');
        TriggerInterfaceHelper.runTrigger('Set_Opportunity_Probability', 'Opportunity', 99, 'bi,bu', devRecordTypeId, null);
        
        Setting__c stageMappingsSetting = new Setting__c(Name = 'StageProbabilityMapping');
        insert stageMappingsSetting;
        Setting_Item__c settingItem = new Setting_Item__c(Setting__c=stageMappingsSetting.Id,Text_1__c=devRecordTypeId,Text_2__c='Initiating',Text_3__c='10');
        insert settingItem;
        
        Opportunity newOpp = new Opportunity(Lead_Source_Description__c='Event Sign Up',LeadSource='Direct',Type='New Business',AccountId=newAccount.Id,Name='Test',StageName='Initiating',CloseDate=system.today(),RecordTypeId=devRecordTypeId);
        system.debug(newOpp);
        insert newOpp;
        Opportunity testOpp = [SELECT Id, Probability FROM Opportunity WHERE Id =: newOpp.Id];
        system.assertEquals(10, testOpp.Probability);
    }    
}