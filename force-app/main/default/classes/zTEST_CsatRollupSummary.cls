//Creted by Ashish Purwar
//This class is test class for class CSATRollupSummary
@isTest 
private class zTEST_CsatRollupSummary {
    static testmethod  void test_CsatRollupSummary() {    
        User u = zTEST_Shared.noinsertUser();
        u.CurrencyIsoCode = 'USD';
        u.LocaleSidKey = 'en_US';
        insert u;
        
        Id AccRecordTypeId = MiscFunctions.getRecordtypeId('Account', 'T&F - Accounts'); 
        
        Account a = zTEST_Shared.insertAccount(u.Id,AccRecordTypeId); 
        Contact Con=zTEST_Shared.insertContact(u.Id, a.Id) ; 
        
        //Id CaseRecordTypeId = MiscFunctions.getRecordtypeId('caseforAccountCase', 'T&F - CSD'); 
                   
        case caseforAccount=zTest_Shared.insertCase(a.Id,'Account'); 
        case caseforContact=zTest_Shared.insertCase(Con.Id,'Contact'); 
        
        TriggerInterfaceHelper.runTrigger('CsatRollupSummary_Trig', 'CSAT__c',1,'ai,au',null,null);
        
        csat__c CSATforAccount1=zTest_Shared.insertCSAT('Test Class CSAT1', caseforAccount.Id, system.today(), '5', 9, 9,u.CurrencyIsoCode); 
        csat__c CSATforAccount2=zTest_Shared.insertCSAT('Test Class CSAT2', caseforAccount.Id, system.today(), '1', 4, 4,u.CurrencyIsoCode);  
        
        csat__c CSATforContact1=zTest_Shared.insertCSAT('Test Class CSAT1', caseforContact.Id, system.today(), '6', 9, 9,u.CurrencyIsoCode);
        csat__c CSATforContact2=zTest_Shared.insertCSAT('Test Class CSAT1', caseforContact.Id, system.today(), '2', 4, 4,u.CurrencyIsoCode);
        System.assertEquals(0.50,[SELECT CSAT_Percentage__c from account where Id=:a.Id][0].CSAT_Percentage__c);
       
    }
    
}