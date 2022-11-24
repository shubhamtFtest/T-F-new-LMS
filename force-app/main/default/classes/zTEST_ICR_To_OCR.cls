/**
 * Tests: InformaContactRole_To_OpportunityContactRole.trigger      100%
 */
@isTest
private class zTEST_ICR_To_OCR {

    static testMethod void test_ICR_To_OCR() {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        c.MailingCity = 'Test';
        update c;
        
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - One-Off Opportunity'); //CHG0038379
        Id icrRtId = MiscFunctions.getRecordtypeId('Informa_Contact_Role__c', 'T&F Contact Roles'); //CHG0038379
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id);
        
        //Id EPFR_OPPORTUNITIES = MiscFunctions.getRecordtypeId('Opportunity', 'EPFR - Opportunities');
        //Opportunity opp = zTEST_Shared.insertOpportunity(EPFR_OPPORTUNITIES, u.Id);
        //Id EPFR_ICR = MiscFunctions.getRecordtypeId('Informa_Contact_Role__c', 'EPFR - Informa Contact Role');
        
        zTEST_Shared.runTriggersForRecordtypes.put('InformaContactRole_To_OpportunityContactRole', new Set<Id>{icrRtId});
        Informa_Contact_Role__c icr = new Informa_Contact_Role__c();
        icr.RecordTypeId = icrRtId;
        icr.Opportunity__c = opp.Id;
        icr.Contact__c = c.Id;
        icr.Contact_Role_s__c = 'Delivery;Invoice';
        icr.Primary_Contact__c = true;
        insert icr;
        icr.Primary_Contact__c = false;
        update icr;
        delete icr;
        undelete icr;
    }
}