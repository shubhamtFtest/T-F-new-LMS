/*
* Tests: EmailToCaseContactLookup_Bulk      100%
* Updated to only work with T&F, so do not deploy this again to the main org*********
*/
@isTest
private class zTEST_EmailToCaseContactLookup_Bulk {

    static testMethod void test_EmailToCaseContactLookup_Bulk() {
        
        Id rtId = MiscFunctions.getRecordtypeId('Case', 'T&F - CSD eBooks'); //CHG0038379
        Id contactRtId = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts'); //CHG0038379
        
        zTEST_Shared.runTrigger('EmailToCaseContactLookup_Bulk', rtId, 'ContactRecordtypeId='+contactRtId); //T&F - CSD eBooks
    
        User u = zTEST_Shared.insertUser();
		/*
        Sales_Team_Detail__c std = zTEST_Shared.noinsertSalesTeamDetail();
        std.Brand__c = 'Lloyd\'s List Group';
        std.Vertical__c = 'Lloyd\'s List';
        insert std;
        zTEST_Shared.assignUserToASalesTeam(u.Id, std.Id);
		*/
        
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.noinsertContact(u.Id, a.Id);
        //c.RecordTypeId = '01260000000J3FQAA0'; //Greenfield Contacts
        c.RecordTypeId = contactRtId; //T&F - Contacts
        c.Email = 'test1@example.com';
        //c.Sales_Team_Detail__c = std.Id;
        insert c;
        
        Id accountRtId = MiscFunctions.getRecordtypeId('Account', 'T&F - Accounts'); //CHG0038379
        
        Account a2 = zTEST_Shared.noInsertAccount(u.Id);
        a2.recordTypeId = accountRtId;
        a2.Shipping_Country_List__c = 'United Kingdom';
        a2.ShippingCountry = 'United Kingdom';
        a2.ShippingCity = 'London';
        insert a2;
        Contact c2 = zTEST_Shared.noinsertContact(u.Id, a2.Id);
        c2.RecordTypeId = contactRtId;
        c2.Email = 'test1@example.com';
        insert c2;
        
        /*
        Account a3 = zTEST_Shared.insertAccount(u.Id, '01260000000J14mAAC');
        Contact c3 = zTEST_Shared.noinsertContact(u.Id, a3.Id);
        c3.RecordTypeId = '01260000000J14oAAC'; //Ovum Contacts
        c3.Email = 'test1@example.com';
        insert c3;
        
        Account a4 = zTEST_Shared.insertAccount(u.Id, '01260000000DYv6AAG');
        Contact c4 = zTEST_Shared.noinsertContact(u.Id, a4.Id);
        c4.RecordTypeId = '01260000000DYv9AAG'; //ITM Contacts
        c4.Email = 'test1@example.com';
        insert c4;
		*/

        List<Case> cseList1 = new List<Case>();
        Case cse1 = new Case();
        cse1.RecordTypeId = rtId; //T&F - CSD eBooks
        cse1.Status = 'New';
        cse1.Origin = 'Email';
        cse1.SuppliedEmail = 'test1@example.com';
        cseList1.add(cse1);
        Case cse1b = new Case();
        cse1b.RecordTypeId = rtId; //T&F - CSD eBooks
        cse1b.Status = 'New';
        cse1b.Origin = 'Email';
        cse1b.SuppliedEmail = 'test2@example.com';
        cseList1.add(cse1b);
        insert cseList1;
        
        /*
        List<Case> cseList1 = new List<Case>();
        Case cse1 = new Case();
        cse1.RecordTypeId = rtId2; //IBI - LLG Case
        cse1.Status = 'New';
        cse1.Origin = 'Email';
        cse1.SuppliedEmail = 'test1@example.com';
        cseList1.add(cse1);
        Case cse1b = new Case();
        cse1b.RecordTypeId = rtId2; //IBI - LLG Case
        cse1b.Status = 'New';
        cse1b.Origin = 'Email';
        cse1b.SuppliedEmail = 'test2@example.com';
        cseList1.add(cse1b);
        insert cseList1;

        List<Case> cseList2 = new List<Case>();
        Case cse2 = new Case();
        cse2.RecordTypeId = rtId3; //Greenfield - Internal Support Case
        cse2.Status = 'New';
        cse2.Origin = 'Email';
        cse2.SuppliedEmail = 'test1@example.com';
        cseList2.add(cse2);
        Case cse2b = new Case();
        cse2b.RecordTypeId = rtId3; //Greenfield - Internal Support Case
        cse2b.Status = 'New';
        cse2b.Origin = 'Email';
        cse2b.SuppliedEmail = 'test2@example.com';
        cseList2.add(cse2b);
        insert cseList2;

        std.Brand__c = 'Datamonitor Healthcare';
        std.Vertical__c = 'Scrip Group';
        update std;

        List<Case> cseList3 = new List<Case>();
        Case cse3 = new Case();
        cse3.RecordTypeId = rtId4; //IBI - Pharma Case
        cse3.Status = 'New';
        cse3.Origin = 'Email';
        cse3.SuppliedEmail = 'test1@example.com';
        cseList3.add(cse3);
        Case cse3b = new Case();
        cse3b.RecordTypeId = rtId4; //IBI - Pharma Case
        cse3b.Status = 'New';
        cse3b.Origin = 'Email';
        cse3b.SuppliedEmail = 'test2@example.com';
        cseList3.add(cse3b);
        insert cseList3;

        std.Brand__c = 'Datamonitor Healthcare';
        std.Vertical__c = 'Healthcare';
        update std;

        List<Case> cseList4 = new List<Case>();
        Case cse4 = new Case();
        cse4.RecordTypeId = rtId5; //IBI - Client Services DMHC Cases
        cse4.Status = 'New';
        cse4.Origin = 'Email';
        cse4.SuppliedEmail = 'test1@example.com';
        cseList4.add(cse4);
        Case cse4b = new Case();
        cse4b.RecordTypeId = rtId5; //IBI - Client Services DMHC Cases
        cse4b.Status = 'New';
        cse4b.Origin = 'Email';
        cse4b.SuppliedEmail = 'test2@example.com';
        cseList4.add(cse4b);
        insert cseList4;

        std.Brand__c = 'Commercial';
        std.Vertical__c = 'Consumer';
        update std;

        List<Case> cseList5 = new List<Case>();
        Case cse5 = new Case();
        cse5.RecordTypeId = rtId7; //IBI - Client Services Commercial Consumer Cases
        cse5.Status = 'New';
        cse5.Origin = 'Email';
        cse5.SuppliedEmail = 'test1@example.com';
        cseList5.add(cse5);
        Case cse5b = new Case();
        cse5b.RecordTypeId = rtId7; //IBI - Client Services Commercial Consumer Cases
        cse5b.Status = 'New';
        cse5b.Origin = 'Email';
        cse5b.SuppliedEmail = 'test2@example.com';
        cseList5.add(cse5b);
        insert cseList5;

        std.Vertical__c = 'Agra';
        update std;

        List<Case> cseList6 = new List<Case>();
        Case cse6 = new Case();
        cse6.RecordTypeId = rtId8; //IBI - Client Services Commercial Agra Cases
        cse6.Status = 'New';
        cse6.Origin = 'Email';
        cse6.SuppliedEmail = 'test1@example.com';
        cseList6.add(cse6);
        Case cse6b = new Case();
        cse6b.RecordTypeId = rtId8; //IBI - Client Services Commercial Agra Cases
        cse6b.Status = 'New';
        cse6b.Origin = 'Email';
        cse6b.SuppliedEmail = 'test2@example.com';
        cseList6.add(cse6b);
        insert cseList6;

        std.Vertical__c = 'Verdict';
        update std;

        List<Case> cseList7 = new List<Case>();
        Case cse7 = new Case();
        cse7.RecordTypeId = rtId9; //IBI - Client Services Commercial Verdict Cases
        cse7.Status = 'New';
        cse7.Origin = 'Email';
        cse7.SuppliedEmail = 'test1@example.com';
        cseList7.add(cse7);
        Case cse7b = new Case();
        cse7b.RecordTypeId = rtId9; //IBI - Client Services Commercial Verdict Cases
        cse7b.Status = 'New';
        cse7b.Origin = 'Email';
        cse7b.SuppliedEmail = 'test2@example.com';
        cseList7.add(cse7b);
        insert cseList7;

        std.Vertical__c = 'Energy';
        update std;

        List<Case> cseList8 = new List<Case>();
        Case cse8 = new Case();
        cse8.RecordTypeId = rtId10; //IBI - Client Services Commercial Energy Cases
        cse8.Status = 'New';
        cse8.Origin = 'Email';
        cse8.SuppliedEmail = 'test1@example.com';
        cseList8.add(cse8);
        Case cse8b = new Case();
        cse8b.RecordTypeId = rtId10; //IBI - Client Services Commercial Energy Cases
        cse8b.Status = 'New';
        cse8b.Origin = 'Email';
        cse8b.SuppliedEmail = 'test2@example.com';
        cseList8.add(cse8b);
        insert cseList8;


        List<Case> cseList9 = new List<Case>();
        Case cse9 = new Case();
        cse9.RecordTypeId = rtId; //TF CSD eBooks
        cse9.Status = 'New';
        cse9.Origin = 'Email';
        cse9.SuppliedEmail = 'test1@example.com';
        cseList9.add(cse9);
        Case cse9b = new Case();
        cse9b.RecordTypeId = rtId; //TF CSD eBooks
        cse9b.Status = 'New';
        cse9b.Origin = 'Email';
        cse9b.SuppliedEmail = 'test2@example.com';
        cseList9.add(cse9b);
        insert cseList9;

        List<Case> cseList10 = new List<Case>();
        Case cse10 = new Case();
        cse10.RecordTypeId = rtId1; //Ovum Compliance
        cse10.Status = 'New';
        cse10.Origin = 'Email';
        cse10.SuppliedEmail = 'test1@example.com';
        cseList10.add(cse10);
        Case cse10b = new Case();
        cse10b.RecordTypeId = rtId1; //Ovum Compliance
        cse10b.Status = 'New';
        cse10b.Origin = 'Email';
        cse10b.SuppliedEmail = 'test2@example.com';
        cseList10.add(cse10b);
        insert cseList10;

        List<Case> cseList11 = new List<Case>();
        Case cse11 = new Case();
        cse11.RecordTypeId = rtId6; //ITM - Analyst Support
        cse11.Status = 'New';
        cse11.Origin = 'Email';
        cse11.SuppliedEmail = 'test1@example.com';
        cseList11.add(cse11);
        Case cse11b = new Case();
        cse11b.RecordTypeId = rtId6; //ITM - Analyst Support
        cse11b.Status = 'New';
        cse11b.Origin = 'Email';
        cse11b.SuppliedEmail = 'test2@example.com';
        cseList11.add(cse11b);
        insert cseList11;
		*/
    }
}