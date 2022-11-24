/*
* Tests:  Lead_SendConvertNotification_Trig    
*/

@isTest
private class zTEST_Lead_SendConvertNotification_Trig {
    static testMethod void test_Lead_SendConvertNotification_Trig() {
        
        Id TF_Journals_Leads_RT = MiscFunctions.getRecordtypeId('Lead', 'T&F - Leads'); //CHG0038379

        TriggerInterfaceHelper.runTrigger('Lead_SendConvertNotification_Trig', 'Lead', 99, 'au', TF_Journals_Leads_RT, null);
        User u = zTEST_Shared.insertUser();
        
       /* Trigger__c trg = new Trigger__c();
        trg.Name ='Lead_SendConvertNotification_Trig';
        trg.Object__c='Lead';
        trg.Enabled__c =true;
        trg.Execution_Order__c =1;
        trg.After_Update__c =true;
        Insert trg;
        Trigger_Recordtype__c trgrec =new   Trigger_Recordtype__c();
        trgrec.Trigger__c = trg.id;
        trgrec.Recordtype_Id__c = TF_Journals_Leads_RT;
        trgrec.Name = 'T&F - Journals Leads';
        trgrec.Enabled__c =true;
        insert trgrec;
      */
        Lead lead = zTEST_Shared.insertLead(u.Id, TF_Journals_Leads_RT);
        
        lead.Status ='Disqualified';
        lead.Lead_Qualifier__c =u.id;
        update lead;
        System.debug('lead.Status : '+lead.Status);
      
    }
}