/******************************************************
* Created by Hailey Niemand, 2013.11.11
* Test method for:
*   - TF_Opp_SubjectAreaRequired_Trig.cls     100%
******************************************************/

@isTest
private class zTEST_TF_Opp_SubjectAreaRequired {

  static testMethod void test_TF_Opp_SubjectAreaRequired() {
    User u = zTEST_Shared.insertUser();
    Id accountRecordtypeId = MiscFunctions.getRecordtypeId('Account', 'T&F - Accounts');
    Account a = zTEST_Shared.insertAccount(u.Id, accountRecordtypeId);
    Id contactRecordtypeId = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts');
    Contact con = zTest_Shared.insertContact(u.Id, a.Id, contactRecordtypeId);
    PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();
    Product2 p = [SELECT Name FROM Product2 WHERE Id = :pbe.Product2Id];
    TFSettings__c tfS = new TFSettings__c();
    tfS.TokenProducts__c = p.Name;
    insert tfS;
    Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity');
    Opportunity opp = zTest_Shared.insertOpportunity (oppRecordtypeId, u.Id, a.Id);
    OpportunityLineItem oli = zTest_Shared.insertOpportunityLineItem (pbe.Id, Opp.Id);
    //zTEST_Shared.runTriggersForRecordtypes.put('TF_Opp_SubjectAreaRequired', new Set<Id>{opp.RecordtypeId});
    TriggerInterfaceHelper.runTrigger('TF_Opp_SubjectAreaRequired_Trig', 'Opportunity', 99, 'bu', oppRecordtypeId, null);
    try {
        opp.StageName = 'Closed Won';
        Update opp;
    } catch(Exception e) {    
    }
  }
}