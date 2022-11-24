@istest
public with sharing class zTest_OppRenewalReminder {
    static testmethod void testSample() {
        Test.startTest();
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        Id oppRecordtypeId = '0120Y000000Wn9V'; //T&F eBooks Consortium Opportunity (Direct)
        Opportunity prevOpp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);
        Opportunity opp = zTEST_Shared.noinsertOpportunity(oppRecordtypeId, u.Id, a.Id);
        opp.StageName = 'Evaluating';
        opp.Don_t_Send__c=false;
        opp.Stage_Date__c=system.today();
        opp.Probability = 10;
        opp.Previous_Renewal__c = prevOpp.Id;
        opp.Date_Sent__c=null;
        //opp.Recipients__r.Email='Test@gmail.com';
        insert opp;
        
        TF_ERN_Settings__c setting = new TF_ERN_Settings__c();
        setting.Name='EST';
        setting.Inbound_Email_Error_Address__c = 'tes@gmail.com';
        insert setting;
        
        OpportunityContactRole ocr = zTEST_Shared.insertOpportunityContactRole(opp.id, c.Id);
        ocr.Role='Delivery';
        ocr.IsPrimary = True;
        update ocr;
        
        
        
        
        Product2 p2 = zTEST_Shared.insertProduct2();
        Product2 p = zTEST_Shared.noinsertProduct2();
        p.Target_Product__c = p2.Id;
        insert p;
         PricebookEntry pbe = zTEST_Shared.insertPricebookEntry(Test.getStandardPricebookId(), p.Id);
        PricebookEntry pbe2 = zTEST_Shared.insertPricebookEntry(Test.getStandardPricebookId(), p2.Id);
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id);
        oli.UnitPrice = null;
        oli.TotalPrice = 100.00;
        oli.Quantity = 1;
        //oli.TotalPrice_GBP__c = 60;
        oli.TotalPrice_USD__c = 400.00;
        insert oli;
        
         opp.Date_Sent__c = null;
         update opp;
        
        Product2 p21 = zTEST_Shared.insertProduct2();
        Product2 p1 = zTEST_Shared.noinsertProduct2();
        p1.Target_Product__c = p21.Id;
        insert p1;
        PricebookEntry pbe1 = zTEST_Shared.insertPricebookEntry(Test.getStandardPricebookId(), p1.Id);
        PricebookEntry pbe21 = zTEST_Shared.insertPricebookEntry(Test.getStandardPricebookId(), p21.Id);
        OpportunityLineItem oli1 = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id);
        oli1.UnitPrice = null;
        oli1.TotalPrice = 200.00;
        oli1.Quantity = 1;
        oli.TotalPrice_USD__c = 400.00;
        //oli1.TotalPrice_GBP__c = 60;
        insert oli1;
        
        
        
        
        Task t = new Task();
        t.Subject = 'Renewal Reminder';
        t.Status = 'Completed';
        t.WhatId = opp.Id;
        t.Description = 'testing';
        t.RecordtypeId = '0120Y000000WnAe';
        insert t;
        
        //opp.StageName='Evaluating';
       // update opp;
        
        system.debug('****'+c.Email);
        OppRenewalReminder  obj = new OppRenewalReminder();
        String schedule = '0 0 23 * * ?';
    system.schedule('Nightly Update', schedule, obj);
        Test.stopTest();
    }

}