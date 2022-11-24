/*
*   Tests:
*       Trig_Opp_TF_StageValidation.cls             100%
*       Trig_Opp_TF_Validation.cls                  96%
*       Trig_Opp_PrimaryOcrRequiredToCloseWon.cls   100%
*       Trig_Opp_RenewalTFeBooks.cls                97%
*       OppRenewalPrompt_TFeBooks_Email.cls         100%
*       OppRenewalPromptTFHomePageController.cls    85%
*       OppRenewalPrompt_TFeBooksController.cls     87%
*       OppRenewalPromptLb_TFeBooksController.cls   88%
*       OppRenewalTFeBooks.cls                      87%
*           
*/
@isTest
private class zTEST_OppRenewalTFeBooks {

    static testMethod void test_Trig_Opp_TF_StageValidation() {
        //***** Tests: Trig_Opp_TF_StageValidation.cls *****
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - eBooks Consortium Opportunity (Direct)'); //CHG0038379
        Opportunity prevOpp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);
        Opportunity opp = zTEST_Shared.noinsertOpportunity(oppRecordtypeId, u.Id, a.Id);
        opp.StageName = 'Prospect';
        opp.Probability = 5;
        opp.Previous_Renewal__c = prevOpp.Id;
        opp.Type = 'New Business';
        insert opp;
        
        //TriggerInterfaceHelper.runTrigger('Trig_Opp_TF_StageValidation', 'Opportunity', 1, 'bi,bu',  oppRecordtypeId, null);

        Test.startTest();

        try {
            TriggerInterfaceHelper.runTrigger('Trig_Opp_TF_StageValidation', 'Opportunity', 1, 'bi,bu',  oppRecordtypeId, null);
            opp.StageName = 'Evaluating';
            opp.Probability = 50;
            update opp;
        } catch (exception e) { //'An opportunity must have products with amounts before being allowed to move to the stage of "Evaluating".'
        }

        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(opp.Id);
        oli.UnitPrice = 100;
        oli.Quantity = 1;
        oli.TotalPrice = null;
        //oli.TotalPrice_USD__c = 100;
        oli.TotalPrice_GBP__c = 100;
        insert oli;
        
        try {
            opp.StageName = 'Closed Won';
            opp.Probability = 100;
            opp.Order_Type__c = 'Trial';
            update opp;     
        } catch (exception e) { //'An opportunity must be at the stage of "Evaluating" before being allowed to move past this stage.'
        }

        opp.StageName = 'Evaluating';
        opp.Probability = 50;
        opp.Order_Type__c = 'Trial';
        
        try {
            update opp;
            opp.StageName = 'Closed Won';
            opp.Probability = 100;
            update opp;     
        } catch (exception e) { //'A "Trial" Opportunity cannot be moved to "Closed Won".  Please change this opportunity\'s Order Type before proceeding.'
        }
        
        Test.stopTest();
    }

    static testMethod void test_Trig_Opp_TF_Validation() {
        //***** Tests: Trig_Opp_TF_Validation.cls *****
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - eBooks Consortium Opportunity (Direct)'); //CHG0038379
        Opportunity prevOpp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);
        Opportunity opp = zTEST_Shared.noinsertOpportunity(oppRecordtypeId, u.Id, a.Id);
        opp.StageName = 'Prospect';
        opp.Probability = 10;
        opp.Previous_Renewal__c = prevOpp.Id;
        opp.Order_Type__c = 'Subscription';
        opp.Product_Family__c = 'Family 1';
        insert opp;
        
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(opp.Id);
        oli.UnitPrice = 100;
        oli.Quantity = 1;
        oli.TotalPrice = null;
        oli.TotalPrice_USD__c = 100;
        oli.TotalPrice_GBP__c = 100;
        insert oli;
        
        opp.StageName = 'Evaluating';
        opp.Probability = 40;
        opp.Order_Type__c = 'Trial';
        update opp;
        
        TriggerInterfaceHelper.runTrigger('Trig_Opp_TF_Validation', 'Opportunity', 1, 'bi,bu',  oppRecordtypeId, null);

        Test.startTest();
        
        try {
            opp.StageName = 'Closed Won';
            opp.Probability = 100;
            update opp;     
        } catch (exception e) { //'You may not mark this opportunity Closed Won because it contains non-zero products without an Invoice Number.'
        }

        try {
            opp.Product_Family__c = 'Family 2';
            update opp;     
        } catch (exception e) { //'You may not change the Product Family because this opportunity contains products.'
        }
                
        Test.stopTest();
    }

    static testMethod void test_Trig_Opp_PrimaryOcrRequiredToCloseWon() {
        //***** Tests: Trig_Opp_PrimaryOcrRequiredToCloseWon.cls *****
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - eBooks Consortium Opportunity (Direct)'); //CHG0038379
        Opportunity prevOpp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);
        Opportunity opp = zTEST_Shared.noinsertOpportunity(oppRecordtypeId, u.Id, a.Id);
        opp.StageName = 'Prospect';
        opp.Probability = 10;
        opp.Previous_Renewal__c = prevOpp.Id;
        insert opp;

        TriggerInterfaceHelper.runTrigger('Trig_Opp_PrimaryOcrRequiredToCloseWon', 'Opportunity', 1, 'bu',  oppRecordtypeId, null);
        
        Test.startTest();
        
        opp.StageName = 'Evaluating';
        opp.Probability = 40;
        opp.Order_Type__c = 'New Business';
        update opp;

        try {
            opp.StageName = 'Closed Won';
            opp.Probability = 100;
            update opp;     
        } catch (exception e) { //'Primary Contact is required before moving your opportunity to Closed Won.'
        }

        OpportunityContactRole ocr = zTEST_Shared.insertOpportunityContactRole(opp.id, c.Id);
        
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(opp.Id);
        oli.UnitPrice = 100;
        oli.Quantity = 1;
        oli.TotalPrice = null;
        oli.TotalPrice_USD__c = 100;
        oli.TotalPrice_GBP__c = 100;
        insert oli;

        opp.StageName = 'Closed Won';
        opp.Probability = 100;
        opp.Start_Date__c = Date.today().addYears(-1);
        opp.End_Date__c = Date.today();
        opp.CloseDate = Date.today();
        opp.Renewal_Method__c = 'test';
        opp.Opportunity_for_Renewal__c = 'Yes';
        update opp;
        
        Test.stopTest();
    }

    static testMethod void test_Trig_Opp_RenewalTFeBooks() {
        //***** Tests: Trig_Opp_RenewalTFeBooks.cls *****
        //***** Tests: OppRenewalPrompt_TFeBooks_Email.cls *****
        //***** Tests: OppRenewalTFeBooks *****
        User u = zTEST_Shared.insertUser();
        BatchOppRenewal__c csetting = new BatchOppRenewal__c();
        csetting.Name = 'UserID';
        csetting.userId__c = u.id;
        insert csetting;
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        c.Email='test@gmail.com';
        update c;
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - eBooks Consortium Opportunity (Direct)'); //CHG0038379
        Opportunity prevOpp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);
        Opportunity opp = zTEST_Shared.noinsertOpportunity(oppRecordtypeId, u.Id, a.Id);
        opp.StageName = 'Prospect';
        opp.Probability = 10;
        opp.Previous_Renewal__c = prevOpp.Id;
        opp.Start_Date__c = Date.today();
        opp.End_Date__c = Date.today().addYears(1);
        opp.CloseDate = Date.today().addYears(1);
        opp.Product_Family__c = 'netBase';
        opp.Parent_Opportunty__c = prevOpp.id;
        opp.Order_Type__c = 'One-Time Purchase';
        insert opp;
        
        Opportunity oppRecod = zTEST_Shared.noinsertOpportunity(oppRecordtypeId, u.Id, a.Id);
        oppRecod.StageName = 'Prospect';
        oppRecod.Probability = 10;
        oppRecod.Previous_Renewal__c = prevOpp.Id;
        oppRecod.Start_Date__c = Date.today();
        oppRecod.CloseDate = Date.today().addYears(1);
        oppRecod.Product_Family__c = 'netBase';
        oppRecod.Parent_Opportunty__c = prevOpp.id;
        //oppRecod.Order_Type__c = 'Maintenance';
        insert oppRecod;
        
        //insert Account to Opportunity record
        List<Account_To_Opportunity__c> accToOppList = new List<Account_To_Opportunity__c>();
        accToOppList.add( new Account_To_Opportunity__c( Account__c = a.id, Opportunity__c = opp.id ) );
        accToOppList.add( new Account_To_Opportunity__c( Account__c = a.id, Opportunity__c = oppRecod.id ) );
        insert accToOppList;
        
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(opp.Id);
        oli.UnitPrice = 100;
        oli.Quantity = 1;
        oli.TotalPrice = null;
        oli.TotalPrice_USD__c = 100;
        oli.TotalPrice_GBP__c = 100;
        insert oli;
        
        Id OrgWideEmailAddressId = [select id from OrgWideEmailAddress where DisplayName = 'Taylor and Francis'].id;
        
        TF_ERN_Settings__c setting = new TF_ERN_Settings__c();
        setting.Org_Wide_Email_Address_Id__c = OrgWideEmailAddressId;
        setting.Sales_Rep_Id__c = u.Id;
        setting.Customer_Service_Email__c = 'test@gmail.com';
        insert setting;

        TriggerInterfaceHelper.runTrigger('Trig_Opp_RenewalTFeBooks', 'Opportunity', 1, 'bu',  oppRecordtypeId, null);

        //Test.startTest();
                
        opp.StageName = 'Closed Won';
        opp.Type = 'Renewal';
        opp.Start_Date__c = date.today();
        opp.End_Date__c = date.today();
        opp.Renewal_Method__c = 'test';
        opp.Opportunity_for_Renewal__c = 'Yes';
        update opp;

        try {
            opp.StageName = 'Evaluating';
            opp.Type = 'New Business';
            opp.Don_t_Send__c = false;
            opp.Order_Type__c = 'Subscription';
            opp.Renewal_Method__c = 'Direct';
            opp.Previous_Renewal__c = prevOpp.Id;
            update opp;
        } catch (Exception e) { //'Missing Primary Contact.  No emails were sent.'
        }

        OpportunityContactRole ocr = zTEST_Shared.insertOpportunityContactRole(opp.id, c.Id);
        OpportunityContactRole ocr2 = zTEST_Shared.insertOpportunityContactRole(oppRecod.id, c.Id);
        
        try {
            opp.StageName = 'Evaluating';
            opp.Type = 'New Business';
            update opp;
        } catch (Exception e) { //'Primary Contact Missing Email Address.  No emails were sent.'
        }

        c.Email = 'test@gmail.com';
        update c;
        opp.StageName = 'TEMP'; //Reset
        update opp;

        //delete oli;

        try {
            opp.StageName = 'Evaluating';
            opp.Type = 'New Business';
            update opp;
        } catch (Exception e) { //'Missing Products.  No emails were sent.'
        }
        
        Test.startTest();

        oli = zTEST_Shared.noinsertOpportunityLineItem(opp.Id);
        oli.UnitPrice = 100;
        oli.Quantity = 1;
        oli.TotalPrice = null;
        oli.TotalPrice_USD__c = 100;
        oli.TotalPrice_GBP__c = 100;
        insert oli;

        opp.AccountId = null;
        update opp;

        try {
            opp.StageName = 'Evaluating';
            opp.Type = 'New Business';
            update opp;
        } catch (Exception e) { //'The Opportunity has no Amount.  No emails were sent.'
        }

        opp.AccountId = a.Id;
        update opp;
                
        opp.StageName = 'Evaluating';
        opp.Type = 'New Business';
        update opp;

        opp.StageName = 'TEMP'; //Reset
        update opp;
        
        opp.Product_Family__c = 'netBase';
        opp.StageName = 'Evaluating';
        update opp;

        OpportunityLineItem oli2 = zTEST_Shared.noinsertOpportunityLineItem(opp.Id);
        oli2.UnitPrice = 100;
        oli2.Quantity = 1;
        oli2.TotalPrice = null;
        oli2.TotalPrice_USD__c = 100;
        oli2.TotalPrice_GBP__c = 100;
        insert oli2;

        opp.StageName = 'TEMP'; //Reset
        update opp;
        
        opp.Product_Family__c = 'netBase';
        opp.StageName = 'Evaluating';
        update opp;

        opp.StageName = 'TEMP'; //Reset
        update opp;
        
        opp.Product_Family__c = 'Not netBase';
        opp.StageName = 'Evaluating';
        update opp;
        
        opp.Customer_Response__c = 'Renew'; 
        update opp;

        opp.Customer_Response__c = 'TEMP'; //Reset
        update opp;

        opp.Customer_Response__c = 'Decline';
        update opp;
        
        opp.StageName = 'Acceptance';
        update opp;

        opp.StageName = 'Closed Lost';
        update opp;
        
        Test.stopTest();
    }

    static testMethod void test_OppRenewalPromptTFHomePageController() {
        //***** Tests: OppRenewalPromptTFHomePageController.cls *****
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - eBooks Consortium Opportunity (Direct)'); //CHG0038379
        Opportunity prevOpp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);
        Opportunity opp = zTEST_Shared.noinsertOpportunity(oppRecordtypeId, u.Id, a.Id);
        opp.Type = 'New Business';
        opp.StageName = 'Prospect';
        opp.Probability = 10;
        opp.Previous_Renewal__c = prevOpp.Id;
        insert opp;
        
        OpportunityContactRole ocr = zTEST_Shared.insertOpportunityContactRole(opp.id, c.Id);
        
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(opp.Id);
        oli.UnitPrice = 100;
        oli.Quantity = 1;
        oli.TotalPrice = null;
        oli.TotalPrice_USD__c = 100;
        oli.TotalPrice_GBP__c = 100;
        insert oli;

        opp.StageName = 'Closed Won';
        opp.Probability = 100;
        opp.Start_Date__c = Date.today().addYears(-1);
        opp.End_Date__c = Date.today();
        opp.CloseDate = Date.today();
        opp.Renewal_Method__c = 'test';
        opp.Opportunity_for_Renewal__c = 'Yes';
        update opp;
        
        opp.Order_Type__c = 'Subscription';
        opp.Next_Renewal__c = null;
        opp.Reason_No_Renewal__c = null;
        update opp;
        
        //TF_ERN_Settings__c setting = new TF_ERN_Settings__c();
        //setting.Go_Live_Date__c = Date.today().addYears(-1);
        //insert setting;
        
        TF_ERN_Settings__c setting = TF_ERN_Settings__c.getInstance( UserInfo.getOrganizationId() );
        setting.Go_Live_Date__c = Date.today().addYears(-1);
        insert setting;
        
        Test.startTest();
        
        pageReference pg = Page.Opp_RenewalPrompt_TF_HomePage;
        //pg.getParameters().put('id', opp.Id);
        Test.setCurrentPage(pg);
        //OppRenewalPromptTFHomePageController con = new OppRenewalPromptTFHomePageController(new ApexPages.StandardController(opp));
        OppRenewalPromptTFHomePageController con = new OppRenewalPromptTFHomePageController();
        
        Test.stopTest();
    }

    static testMethod void test_OppRenewalPrompt_TFeBooksController() {
        //***** Tests: OppRenewalPrompt_TFeBooksController.cls *****
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - eBooks Consortium Opportunity (Direct)'); //CHG0038379
        Opportunity prevOpp = zTEST_Shared.noinsertOpportunity(oppRecordtypeId, u.Id, a.Id);
        prevOpp.Opportunity_for_Renewal__c = 'Yes';
        prevOpp.StageName = 'Prospect';// 'Closed Won'
        prevOpp.Next_Renewal__c = null;
        prevOpp.Start_Date__c = Date.today().addYears(-1);
        prevOpp.End_Date__c = Date.today();
        prevOpp.CloseDate = Date.today();
        prevOpp.Type = 'New Business';
        insert prevOpp;
        OpportunityLineItem oliPrev = zTEST_Shared.noinsertOpportunityLineItem(prevOpp.Id);
        oliPrev.UnitPrice = 100;
        oliPrev.Quantity = 1;
        oliPrev.TotalPrice = null;
        //oli.TotalPrice_USD__c = 100;
        oliPrev.TotalPrice_GBP__c = 100;
        insert oliPrev;
        prevOpp.Renewal_Method__c = 'test';
        prevOpp.StageName = 'Closed Won';
        update prevOpp;
        
        Opportunity opp = zTEST_Shared.noinsertOpportunity(oppRecordtypeId, u.Id, a.Id);
        opp.Type = 'New Business';
        opp.StageName = 'Prospect';
        opp.Probability = 10;
        opp.Previous_Renewal__c = prevOpp.Id;
        insert opp;
        
        OpportunityContactRole ocr = zTEST_Shared.insertOpportunityContactRole(opp.id, c.Id);
        
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(opp.Id);
        oli.UnitPrice = 100;
        oli.Quantity = 1;
        oli.TotalPrice = null;
        oli.TotalPrice_USD__c = 100;
        oli.TotalPrice_GBP__c = 100;
        insert oli;

        opp.StageName = 'Closed Won';
        opp.Probability = 100;
        opp.Start_Date__c = Date.today().addYears(-1);
        opp.End_Date__c = Date.today();
        opp.CloseDate = Date.today();
        opp.Renewal_Method__c = 'test';
        opp.Opportunity_for_Renewal__c = 'No';
        opp.Reason_No_Renewal__c = 'Test Reason1';
        update opp;
        
        opp.Order_Type__c = 'Subscription';
        opp.Next_Renewal__c = null;
        opp.Reason_No_Renewal__c = 'Test Reason2';
        update opp;
        
        //TF_ERN_Settings__c setting = new TF_ERN_Settings__c();
        //setting.Go_Live_Date__c = Date.today().addYears(-1);
        //insert setting;
        
        //TF_ERN_Settings__c setting = TF_ERN_Settings__c.getInstance( UserInfo.getOrganizationId() );
        //setting.Go_Live_Date__c = Date.today().addYears(-1);
        //insert setting;
        
        Test.startTest();
        
        pageReference pg = Page.Opp_RenewalPrompt_TFeBooks;
        pg.getParameters().put('id', opp.Id);
        Test.setCurrentPage(pg);
        OppRenewalPrompt_TFeBooksController con = new OppRenewalPrompt_TFeBooksController(new ApexPages.StandardController(opp));
        
        Boolean showPrompt = con.getShowPrompt();

        TF_ERN_Settings__c setting = TF_ERN_Settings__c.getInstance( UserInfo.getOrganizationId() );
        setting.Go_Live_Date__c = Date.today().addYears(-1);
        insert setting;
        
        showPrompt = con.getShowPrompt();
        /*prevOpp.Opportunity_for_Renewal__c = 'Yes';
        prevOpp.StageName = 'Closed Won';
        prevOpp.Next_Renewal__c = null;
        prevOpp.Start_Date__c = Date.today().addYears(-1);
        prevOpp.End_Date__c = Date.today();
        prevOpp.CloseDate = Date.today();
        prevOpp.Type = 'New Business';
        prevOpp.Next_Renewal__c = opp.Id;
        insert prevOpp;*/

        Test.stopTest();
    }
    
    static testMethod void test_OppRenewalPromptLb_TFeBooksController() {
        //***** Tests: OppRenewalPromptLb_TFeBooksController.cls *****
        //***** Tests: OppRenewalTFeBooks *****
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - eBooks Consortium Opportunity (Direct)'); //CHG0038379
        Opportunity prevOpp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);
        Opportunity opp = zTEST_Shared.noinsertOpportunity(oppRecordtypeId, u.Id, a.Id);
        opp.Type = 'New Business';
        opp.StageName = 'Prospect';
        opp.Probability = 10;
        opp.Previous_Renewal__c = prevOpp.Id;
        opp.Start_Date__c = Date.today();
        opp.End_Date__c = Date.today().addYears(1);
        opp.CloseDate = Date.today().addYears(1);
        opp.ReVisit_Date__c = Date.today();
        
        insert opp;
        opp.StageName = 'Investigating';
        update opp;
        
        TF_ERN_Settings__c setting = TF_ERN_Settings__c.getInstance( UserInfo.getOrganizationId() );
        setting.Sales_Rep_Id__c = u.Id;
        insert setting;

        Test.startTest();
        
        pageReference pg = Page.Opp_RenewalPromptLb_TFeBooks;
        pg.getParameters().put('id', opp.Id);
        Test.setCurrentPage(pg);
        OppRenewalPromptLb_TFeBooksController con = new OppRenewalPromptLb_TFeBooksController(new ApexPages.StandardController(opp));
        
        Boolean showOldStatge = con.showOldStage;
        Pagereference yesRenewal = con.yesRenewal();
        con.reasonForNoRenewal = 'test';
        Pagereference noRenewal = con.noRenewal();
        con.oldStage = 'Prospect';
        Pagereference cancelClosedWon = con.cancelClosedWon();

        Test.stopTest();
    }
    
}