//Creted by Ashish Purwar on 05-03-2018
//This class is test class for batch class BatchCSATRollupSummary
@isTest
public class zTest_BatchCSATRollupSummary {
    static testMethod void test_BatchCSATRollupSummary() 
    {
        User u = zTEST_Shared.noinsertUser();
        u.CurrencyIsoCode = 'USD';
        u.LocaleSidKey = 'en_US';
        insert u;
        Id AccRecordTypeId = MiscFunctions.getRecordtypeId('Account', 'T&F - Accounts'); 
        Account a = zTEST_Shared.insertAccount(u.Id,AccRecordTypeId); 
        Contact Con=zTEST_Shared.insertContact(u.Id, a.Id) ; 
        case caseforAccount=zTest_Shared.insertCase(a.Id,'Account'); 
        case caseforContact=zTest_Shared.insertCase(Con.Id,'Contact');        
        csat__c CSATforAccount1=zTest_Shared.insertCSAT('Test Class CSAT1', caseforAccount.Id, system.today(), 'Yes', 9, 9,u.CurrencyIsoCode); 
        csat__c CSATforAccount2=zTest_Shared.insertCSAT('Test Class CSAT2', caseforAccount.Id, system.today(), 'No', 4, 4,u.CurrencyIsoCode); 
        csat__c CSATforContact1=zTest_Shared.insertCSAT('Test Class CSAT1', caseforContact.Id, system.today(), 'Yes', 9, 9,u.CurrencyIsoCode);
        csat__c CSATforContact2=zTest_Shared.insertCSAT('Test Class CSAT1', caseforContact.Id, system.today(), 'No', 4, 4,u.CurrencyIsoCode);
        Date myDate = Date.newInstance(2016, 2, 17);
        csat__c CSATforAccountOld=zTest_Shared.insertCSAT('Test Class CSATOld', caseforAccount.Id, myDate, 'Yes', 9, 9,u.CurrencyIsoCode); 
        Test.startTest();
            BatchCSATRollupSummary CSAT1 = new BatchCSATRollupSummary();         	 
        	DataBase.executeBatch(CSAT1);             
        Test.stopTest();
       
        
    }

}