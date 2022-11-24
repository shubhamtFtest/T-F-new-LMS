/*
* Tests:  Contact_UpdatePartyId_Trig        100%
*/
@isTest
private class zTEST_Contact_UpdatePartyId_Trig {
	static testMethod void test_Contact_UpdatePartyId_Trig() {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Id TF_CONTACTS_RT = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts');
        TriggerInterfaceHelper.runTrigger('Contact_UpdatePartyId_Trig', 'Contact', 99, 'bi', TF_CONTACTS_RT, null);
        
        List<Contact> contacts = new List<Contact>();
        for (integer i = 0; i < 200; i++) {
            Contact c = zTEST_Shared.noinsertContact(u.Id, a.Id);
            contacts.add(c);
        }
        insert contacts;
        
        integer nextPartyId = PartyIdIncrementer.getNextPartyId();        
    }
}