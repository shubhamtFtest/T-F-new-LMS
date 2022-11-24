@isTest
public class zTEST_Trigger_SAP_BP {

    @isTest static void sap_Bp_Trigger(){
        TriggerInterfaceHelper.runTrigger('TF_SAP_BP_updateCountryISOCode', 'SAP_BP__c', 1, 'ai', null, null);   
        SAP_BP__c SAP_BP_Record_3 = new SAP_BP__c();
        SAP_BP_Record_3.Name = 'Pending';
        SAP_BP_Record_3.Address_Type__c = 'Account Mailing';
        insert SAP_BP_Record_3;
    }
}