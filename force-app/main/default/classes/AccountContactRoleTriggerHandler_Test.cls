/****************************************************************************************************************************
* Class Name : AccountContactRoleTriggerHandler_test
* Project : WS6 JCM Pardot Phase 2
* Purpose : Test class for AccountContactRoleTriggerHandler
* Author : Divya Rao (Appirio)
* Date : 10/08/2016
* JIRA numbers : WCE - 594
*****************************************************************************************************************************/
@isTest
private class AccountContactRoleTriggerHandler_Test {
    
    @isTest static void test_method_one() {
        list<Account> a = new list<Account>{new Account(Name = 'A Big Test Corp.'), new Account(Name = 'Big Test Corp.')};
        insert a;
        
        RecordType[] rt = getRecordTypes();
        
        Contact con1 = new Contact();
        con1.AccountId = a[0].id;
        //con1.RecordTypeId = rt[1].Id;
        con1.RecordTypeId = rt[0].Id;
        con1.LastName = 'Turner';
        string email = 'test' + datetime.now().millisecond() + '@test.com';
        con1.Email = email;
        insert con1;
       // con1.pi__last_activity__c =Datetime.newInstance(2014, 08, 1, 0, 0, 0);

        AccountContactRole__c acr=new AccountContactRole__c();
        acr.contactId__c=con1.id;
        acr.AccountID__c = a[0].id;
        acr.Last_Interaction_Date__c = Datetime.newInstance(2016, 08, 10, 0, 0, 0);
        insert acr;

        List<Contact> listUpdatedContact = new List<Contact>([SELECT ID,ACR_Last_Interaction__c FROM Contact 
            WHERE ID=:acr.contactId__c]);
        System.assertEquals(listUpdatedContact[0].ACR_Last_Interaction__c,acr.Last_Interaction_Date__c);
    }
    
    private static RecordType[] getRecordTypes(){
        //RecordType[] rt = [select Id, name from RecordType where name in ('T&F - CSD', 'T&F - Online Contacts') order by Name]; //01260000000J2hmAAC - T&F - Online Contacts
        //system.assertEquals(2, rt.size(), 'Recordtype error: 1 or more not found');
        RecordType[] rt = [select Id, name from RecordType where name in ('T&F - Contacts') order by Name]; //01260000000J2hmAAC - T&F - Contacts
        system.assertEquals(1, rt.size(), 'Recordtype error: 1 not found');
        
        return rt;
    }
    
    
    
    
}