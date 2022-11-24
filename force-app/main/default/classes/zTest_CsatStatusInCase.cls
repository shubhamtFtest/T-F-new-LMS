//Creted by Ashish Purwar
//This class is test class for class CsatStatusInCase
@isTest 
private class zTest_CsatStatusInCase {
    static testmethod  void test_CsatStatusInCase() {    
        User u = zTEST_Shared.noinsertUser();
        u.CurrencyIsoCode = 'USD';
        u.LocaleSidKey = 'en_US';
        insert u;
        
        Id AccRecordTypeId = MiscFunctions.getRecordtypeId('Account', 'T&F - Accounts');
        Account a = zTEST_Shared.insertAccount(u.Id,AccRecordTypeId);
        case caseforAccount=zTest_Shared.insertCase(a.Id,'Account'); 
        TriggerInterfaceHelper.runTrigger('CsatStatusInCase_Trig', 'CSAT__c',1,'ai,au',null,null);
        csat__c CSATforAccount1=zTest_Shared.insertCSAT('Test Class CSAT1', caseforAccount.Id, system.today(), 'Yes', 9, 9,u.CurrencyIsoCode); 
        System.assertEquals(True,[SELECT csat_received__c from case where Id=:caseforAccount.Id][0].csat_received__c);
    }
    
}