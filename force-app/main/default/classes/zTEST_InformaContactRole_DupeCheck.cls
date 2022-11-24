/**
 * Tests: InformaContactRole_DupeCheck.trigger      100%
 */
@isTest
private class zTEST_InformaContactRole_DupeCheck {

    static testMethod void test_InformaContactRole_DupeCheck() {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        c.MailingCity = 'Test';
        update c;
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - One-Off Opportunity');
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id);
        Id icrRtId = MiscFunctions.getRecordtypeId('Informa_Contact_Role__c', 'T&F Contact Roles');
        
        zTEST_Shared.runTriggersForRecordtypes.put('InformaContactRole_DupeCheck', new Set<Id>{icrRtId});
        Informa_Contact_Role__c icr = new Informa_Contact_Role__c();
        icr.RecordTypeId = icrRtId;
        icr.Opportunity__c = opp.Id;
        icr.Contact__c = c.Id;
        icr.Contact_Role_s__c = 'Delivery;Invoice';
        icr.Primary_Contact__c = true;
        insert icr;

        Informa_Contact_Role__c icr2 = new Informa_Contact_Role__c();
        icr2.RecordTypeId = icrRtId;
        icr2.Opportunity__c = opp.Id;
        icr2.Contact__c = c.Id;
        icr2.Contact_Role_s__c = 'Delivery;Invoice';
        icr2.Primary_Contact__c = true;
        try {
            insert icr2;
        } catch (Exception e) {
        }

        Informa_Contact_Role__c icr3 = new Informa_Contact_Role__c();
        icr3.RecordTypeId = icrRtId;
        icr3.Opportunity__c = opp.Id;
        icr3.Contact__c = c.Id;
        icr3.Contact_Role_s__c = 'Delivery;Invoice';
        icr3.Primary_Contact__c = true;
        List<Informa_Contact_Role__c> icrsToInsert = new List<Informa_Contact_Role__c>();
        icrsToInsert.add(icr2);
        icrsToInsert.add(icr3);
        try {
            insert icrsToInsert;
        } catch (Exception e) {
        }

    }
}