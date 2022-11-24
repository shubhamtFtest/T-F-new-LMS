/*
* Tests:  SubjectInterest_SplitOutCodes_Trig		94%
*/
@isTest
private class zTEST_SubjectInterest_SplitOutCodes_Trig {
	static testMethod void test_SubjectInterest_SplitOutCodes_test() {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        
        List<Subject_Taxonomy__c> stList = new List<Subject_Taxonomy__c>();
        Subject_Taxonomy__c st1 = new Subject_Taxonomy__c();
        st1.Subject_Code__c = 'AS';
        st1.Subject_Name__c = 'ASTEST';
        stList.add(st1);
        Subject_Taxonomy__c st2 = new Subject_Taxonomy__c();
        st2.Subject_Code__c = 'AS0101';
        st2.Subject_Name__c = 'AS0101TEST';
        stList.add(st2);
		insert stList;        
        
        TriggerInterfaceHelper.runTrigger('SubjectInterest_SplitOutCodes_Trig', 'SubjectInterest__c', 99, 'ai,au', null, null);
		
        //Test original insert
        SubjectInterest__c si = new SubjectInterest__c();
        si.ContactID__c = c.Id;
        si.Subject_Interest_Role__c = 'Professional';
        si.Subject_Code_Level_1__c = 'AS, BS, CS';
        si.System_ID__c = 'Formstack';
        si.Date_Added_To_Role__c = system.now();
        insert si;
        
        List<SubjectInterest__c> sis = [SELECT Subject_Code_Level_1__c, Subject_Level_1_Name__c, Active__c, Subject__c, Subject_Interest_Role__c FROM SubjectInterest__c];
        
        for (SubjectInterest__c siTest : sis) {
            system.debug('TEST: Code1 - Name1 = ' + siTest.Subject_Code_Level_1__c + ' - ' + siTest.Subject_Level_1_Name__c);
            system.debug('TEST:       - Active = ' + siTest.Active__c + ', Subject__c =' + siTest.Subject__c + ', Subject_Interest_Role__c =' + siTest.Subject_Interest_Role__c);
        }

		//Test Update        
        si.Subject_Code_Level_1__c = 'AS, BS, CS, XY';
        si.Subject_Code_Level_3__c = 'AS0101, AS0102, AS0203, BS0101, BS0102, CS01,,,,,,,,,,,,,,,,,,,,,,,,,,,';
        si.System_ID__c = 'Formstack';
        update si;
        
        sis = [SELECT Subject_Code_Level_1__c, Subject_Level_1_Name__c,
               		Subject_Code_Level_2__c, Subject_Level_2_Name__c,
               		Subject_Code_Level_3__c, Subject_Level_3_Name__c,
               		Active__c, Subject__c, Subject_Interest_Role__c
               FROM SubjectInterest__c];
        
        for (SubjectInterest__c siTest : sis) {
            system.debug('TEST: -------------');
            system.debug('TEST: Code1 - Name1 = ' + siTest.Subject_Code_Level_1__c + ' - ' + siTest.Subject_Level_1_Name__c);
            system.debug('TEST: Code2 - Name2 = ' + siTest.Subject_Code_Level_2__c + ' - ' + siTest.Subject_Level_2_Name__c);
            system.debug('TEST: Code3 - Name3 = ' + siTest.Subject_Code_Level_3__c + ' - ' + siTest.Subject_Level_3_Name__c);
            system.debug('TEST:       - Active = ' + siTest.Active__c + ', Subject__c =' + siTest.Subject__c + ', Subject_Interest_Role__c =' + siTest.Subject_Interest_Role__c);
        }

    }
}