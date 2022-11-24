/*
* Tests:  BatchOppRenewalReminder        93%
ScheduleOppRenewalReminder 75%
Created by Bharat - 2017.12.11 - Ticket #CHG0038754
*/
@isTest
public class zTest_BatchOppRenewalReminder {
    private static testmethod void test1(){
        User u;
        User userSamantha=[select id from user where Name='Samantha Given'];
        if(userSamantha ==null){
            u = zTEST_Shared.insertUser();
        }else{
            u=userSamantha;
        }
    //    BatchOppRenewal__c cusBatch=BatchOppRenewal__c.getValues('UserID');
      //  Id userId=cusBatch.UserId__c;
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);    
        Id oppRecordtypeId = [select id from recordtype where name='T&F - eBooks Opportunity'].id;
    //    Id oppRecordtypeId = '012600000005OrVAAU'; //IFI Opportunities
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);
        opp.StageName='Evaluating';
        opp.Don_t_Send__c=false;
        opp.Start_Date__c=system.today().adddays(31);
        update opp;
        Product2 p = zTEST_Shared.insertProduct2();
       // p.Division__c = 'EPFR';
        update p;
        Pricebook2 pb = zTEST_Shared.insertPricebook2_2();
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry(pb.Id, p.Id);
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        oli.TotalPrice_USD__c=200;
        oli.TotalPrice = 100.00;
        oli.Quantity = 1;
        oli.TotalPrice_GBP__c = 60;
       // oli.TotalPrice_USD__c = 400.00;
        update oli;
        Informa_Contact_Role__c icr = new Informa_Contact_Role__c();
		icr.Opportunity__c = opp.Id;
		icr.Contact__c = c.Id;
        icr.Contact_Role_s__c = 'Billing';
        insert icr;
        BatchOppRenewal__c setting = new BatchOppRenewal__c();
        setting.Name = 'UserID';
        setting.userId__c = u.id;
        insert setting;
        OpportunityContactRole ocr =new OpportunityContactRole();
        ocr.OpportunityId=opp.Id;
        ocr.isPrimary=true;
        ocr.ContactId=c.id;
        insert ocr;
        Task t = new Task();
        t.Subject = 'Renewal Reminder';
        t.Status = 'Completed';
        t.WhatId = opp.Id;
        t.Description = 'testing';
        t.RecordtypeId = '0120Y000000WnAe';
        insert t;
        Test.startTest();
        BatchOppRenewalReminder obj = new BatchOppRenewalReminder();
        DataBase.executeBatch(obj); 
        Test.stopTest();
       
    }
    private static testmethod void testScheduleOppRenewalReminder(){
        test.startTest();
        ScheduleOppRenewalReminder obj = new ScheduleOppRenewalReminder();
        obj.execute(null);
        Test.stopTest(); 
    }
}