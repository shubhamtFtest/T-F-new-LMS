/*****************************************************
* Tests:
*   Event_UpdateOppNextStep.trigger          93%
*   Task_UpdateOppNextStep.trigger           93%
*****************************************************/
@isTest
private class  zTEST_UpdateOppNextStep {

    static testMethod void test_UpdateOppNextStep() {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Opportunity');
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id);
        
        
        Event e = new Event();
        e.WhatId = opp.Id;
        e.Subject = 'Test';
        e.ActivityDate = date.today();
        e.ActivityDateTime = system.now();
        e.DurationInMinutes = 15;
        e.RecordTypeId = [SELECT Id FROM Recordtype WHERE Sobjecttype = 'Event' LIMIT 1].Id;
        insert e;

        Task t = new Task();
        t.WhatId = opp.Id;
        t.Subject = 'Test'; 
        t.ActivityDate = date.today();
        t.RecordTypeId = [SELECT Id FROM Recordtype WHERE Sobjecttype = 'Task' LIMIT 1].Id;
        insert t;
        
        zTEST_Shared.runTriggersForRecordtypes.put('Event_UpdateOppNextStep', new Set<Id>{e.RecordtypeId});
        zTEST_Shared.runTriggersForRecordtypes.put('Task_UpdateOppNextStep', new Set<Id>{t.RecordtypeId});
        
        e.ActivityDate = date.today().addDays(1);
        e.ActivityDateTime = system.now().addDays(1);
        update e;
        
        t.ActivityDate = date.today().addDays(2);
        update t;               

        e.ActivityDate = date.today().addDays(3);
        e.ActivityDateTime = system.now().addDays(3);
        update e;

    }
}