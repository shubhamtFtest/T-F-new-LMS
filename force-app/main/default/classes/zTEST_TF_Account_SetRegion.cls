/******************************************************
* Created by Hailey Niemand, 2014.02.10
* Test method for:
*   - Account.TF_Account_SetRegion.trigger  100%
******************************************************/

@isTest
private class zTEST_TF_Account_SetRegion {

    static testMethod void test_TF_Account_SetRegion() {
        Setting__c s = new Setting__c();
        S.Name = 'TF Country Regions';
        s.Text_1_Label__c = 'Country';
        s.Text_1_Order__c = 1; 
        s.Text_2_Label__c = 'Region';
        s.Text_2_Order__c = 1;
        insert s;
        
        Setting_Item__c si = new Setting_Item__c();
        si.Setting__c = s.Id;
        si.Text_1__c = 'United Kingdom';
        si.Text_2__c = 'UK/EMEA';
        insert si;
        
        User u = zTEST_Shared.insertUser();
        Id accountRecordtypeId = MiscFunctions.getRecordtypeId('Account', 'T&F - Accounts');
        Account a = zTEST_Shared.noinsertAccount(u.Id);
        a.RecordTypeId = accountRecordtypeId;
        a.Shipping_City__c = 'London';
        a.Shipping_Country_List__c = 'England';
        insert a;
        //zTEST_Shared.runTriggersForRecordtypes.put('TF_Account_SetRegion', new Set<Id>{a.RecordtypeId});
        TriggerInterfaceHelper.runTrigger('TF_Account_SetRegion_Trig', 'Account', 2, 'bi,bu', accountRecordtypeId, null);
        a.Shipping_Country_List__c = 'United Kingdom';
        update a;
    }
}