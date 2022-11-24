/************************************************************************** 
**CHG0039660
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com) 2011.12.13
***************************************************************************/
 
@isTest
private class zTest_CAS_OppLineItemAdoptStage {

    static testMethod void myUnitTest() {
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity');
        TriggerInterfaceHelper.runTrigger('CAS_OppLineItemAdoptStage_Trig', 'OpportunityLineItem', 99, 'au', oppRecordtypeId, null);
        
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id); 
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        
        CAS_Inspection_Copy__c ic = new CAS_Inspection_Copy__c();
            ic.Opportunity__c = Opp.Id;
            ic.Opportunity_Product__c = oli.Id;
            ic.Book_Order__c = '1234';
            ic.Book_Title__c = 'My title';
            ic.ISBN__c = '123';
            ic.Contact_Name__c = 'TEST.Shay.Spoonmore';
            ic.Contact_Email__c= 'Shay.Spoonmore@informaUSA.com';
            ic.IsTesting__c = true;
            ic.Sent_Created_Notification__c = null;
        insert ic;
        
        list<CAS_Inspection_Copy__c> inc = [Select c.Id, c.Opportunity__c, c.Opportunity_Product__c, c.SystemModstamp from CAS_Inspection_Copy__c c where c.Opportunity_Product__c =:oli.Id];
        //check ic copy was made
        System.assert((inc.Size() > 0));
        
        oli.Adoption_Stage__c = 'Completed - Adopted'; //
        Update oli;
        
        oli.Adoption_Stage__c = 'Completed - Order Confirmed'; //
        Update oli;
        
        oli.Adoption_Stage__c = 'Completed - Purchased'; //
        Update oli;
        
        oli.Adoption_Stage__c = 'Completed - Not appropriate'; //
        Update oli;
        
        oli.Adoption_Stage__c = 'Completed - Library Purchase'; //
        Update oli;
        
        oli.Adoption_Stage__c = 'Completed - No Response'; //
        Update oli;
    }
}