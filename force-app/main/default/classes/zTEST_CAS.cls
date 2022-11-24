/**************************************************
* Created by Jeff Lup, 2011.04.28
* Test methods for CAS triggers and classes.
* Trigger/Class names and coverage percentages
*   documented within each method.


* Other CAS classes/triggers tested in additional
*   classes as denoted below. 

// Tested in Tests_CASEmail...
//   - CASEmail.cls
//   - CAS_SendFeedbackEmail.trigger

// Tested in Tests_CASFeedback2Controller...
//   - CASFeedback2Controller.cls

// Tested in Tests_CASOppLineItemContactSubCode...
//   - CAS_OppLineItemContactSubCode.trigger
//   - CAS_OppLineItemContactSubCode.cls

// Tested in Tests_CASTextBookFeedbackLink...
//   - CASTextbookFeedbackLink.cls

// Tested in CASBulkSCAssignment.cls...
//   - CASBulkSCAssignment.cls

// CAS_CreateOppLineItem.trigger INACTIVE
// CAS_OLI_BooksInUseCreate.trigger INACTIVE
// CAS_OpportunityUpdateICOwner.trigger INACTIVE
// CAS_UpdateOpporunityStudent.trigger  INACTIVE

** Modified by Shay Spoonmore (shay.spoonmore@informausa.com) 2015-05-21 CHG0066391
** Modified by Jeff Lup - 2017.10.09 - CHG0038379
** Modified by Shefali Arora - 2019.06.27 - Case no : 01231085
**************************************************/

@isTest
private class zTEST_CAS {

    static testMethod void testCAS_1() {
        // CAS_BooksInUseCreate.cls                 100%
        // CAS_CreateOppLineItem.cls                83%
        // CAS_UpdatepProductPublisher.trigger      100% (80% in Tests_CAS)
        
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
        Id productRtId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products'); //CHG0038379

        TriggerInterfaceHelper.runTrigger('CAS_CreateOppLineItem_Trig', 'OpportunityLineItem', 99, 'bi', oppRtId, null);
        TriggerInterfaceHelper.runTrigger('CAS_BooksInUseCreate_Trig', 'OpportunityLineItem', 99, 'ai,au', oppRtId, null);
        TriggerInterfaceHelper.runTrigger('CAS_NewOpportunityProduct_Trig', 'OpportunityLineItem', 99, 'ai', oppRtId, null);
        
        User u = zTEST_Shared.insertUser();
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry(productRtId);
        Product2 p = [Select Subject_Classifications__c, Id From product2 where Id =:pbe.Product2Id];
        String addSubjectCodes = '; subj0101 - this is only a test1; subj0202 - this is only a test2';
        P.Subject_Classifications__c = P.Subject_Classifications__c + ' - test' + addSubjectCodes;
        update p;
        
        //For Case no: 01231085
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId,u.Id); 
        OpportunityContactRole ocr = zTEST_Shared.insertOpportunityContactRole(opp.Id, c.Id, 'Test');
        TriggerInterfaceHelper.runTrigger('OLI_DefaultContact_Trig', 'OpportunityLineItem', 1, 'bi', oppRtId, null);
        
        
        //Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId,u.Id);
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id, 'Completed - Adopted');
        OpportunityLineItem oli2 = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id, 'Completed - Adopted');

        // CAS_OppLineItemContactSubCode.trigger    100%
        // CAS_OppLineItemContactSubCode.cls        71% (95% in Tests_CASOppLineItemContactSubCode)
         TriggerInterfaceHelper.runTrigger('CAS_OppLineItemContactSubCode_Trig', 'OpportunityLineItem', 99, 'ai,au', oppRtId, null); 
        
        //Account a = zTEST_Shared.insertAccount(u.Id);
        //Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        Contact c2 = zTEST_Shared.insertContact(u.Id, a.Id);
        CAS_Subject_Code__c sc = zTEST_Shared.insertCASSubjectCode(u.Id);
        CAS_Subject_Code_Contact__c scc = zTEST_Shared.insertCASSubjectCodeContact(sc.Id, c.Id, u.Id);
        CAS_Subject_Code_Contact__c scc2 = zTEST_Shared.insertCASSubjectCodeContact(sc.Id, c2.Id, u.Id);
        
        
         
        //Create SubjectCodes
        CAS_Subject_Code__c subj = new CAS_Subject_Code__c(GT_Cat_Code__c='subj',name='subj - this is only a test1' );
        insert subj;
        
        CAS_Subject_Code__c subj1 = new CAS_Subject_Code__c(GT_Cat_Code__c='subj01',name='subj01 - this is only a test1',Parent__c= subj.id);
        insert subj1;
        subj1 = new CAS_Subject_Code__c(GT_Cat_Code__c='subj0101',name='subj0101 - this is only a test1',Parent__c= subj1.id);
        insert subj1;
        
        CAS_Subject_Code__c subj2 = new CAS_Subject_Code__c(GT_Cat_Code__c='subj02',name='subj02 - this is only a test1',Parent__c= subj.id);
        insert subj2;
        subj2 = new CAS_Subject_Code__c(GT_Cat_Code__c='subj0202',name='subj0202 - this is only a test1',Parent__c= subj2.id);
        insert subj2;
        
        oli.Recipient__c = c.Id;
        oli2.Recipient__c = c2.Id;
        
        update new OpportunityLineItem[]{oli,oli2};
        
        // CAS_SendNotifications.trigger            100%
        //CAS_OppLineItemICCreate_Trig.cls          100%
        
        TriggerInterfaceHelper.runTrigger('CAS_OppLineItemICCreate_Trig', 'OpportunityLineItem', 50, 'bu', oppRtId, null);
        
        CAS_Inspection_Copy__c ic = Tests_CASVitalSource.setupTestInspectionCopy(oli.Id,opp.Id);
        
        oli.Order_Type__c = 'HSS Vitalsource e-Exam copy';
        oli.VitalSource_Redeemed_Date__c = date.today().addDays(1);
        oli.Adoption_Stage__c = 'In-Process';
        oli.Fulfillment_House__c = 'test';
        oli.Shipping_Date__c = date.today();
        oli.IsTesting__c = True;
        update oli;
        oli.Shipping_Date__c = date.today().addDays(1);
        update oli;

        // CAS_OpportunityUpdateICOwner.cls         N/A
        // CAS_UpdateOpporunityStudent.cls          N/A
        User u2 = zTEST_Shared.insertUser();
        opp.OwnerId = u2.Id;
        opp.Number_of_Students__c = 2;
        PublicVariables.Opp_isBefore_FirstRun = true;
        PublicVariables.Opp_isAfter_FirstRun = true;
        update opp;
        
        // CASContactSearchExportController.cls     97% (82% in Tests_CAS)
        // CASContactSearchExportWrapper.cls        100% (0% in Tests_CAS)
        testContactSearchExportCourseCategories(opp, c);
        testContactSearchExportSubjectCodes(c);
        
        // CASOpportunityController.cls             95% (93% in Tests_CAS)
        testOpportunityController(opp);
        
        // CASInspectionCopyController.cls          95% (62% in Tests_CAS) already exists Tests_CASInspectionCopyController cover 92%
        //testInspectionCopyController(opp, pbe);
        //testInspectionCopyControllerBadUrl();
    }

 
    public static void testContactSearchExportCourseCategories(Opportunity opp, Contact c) {
        CAS_Course_Cat1__c c1 = new CAS_Course_Cat1__c(name='Level 1');
        insert c1;
        CAS_Course_Cat2__c c2 = new CAS_Course_Cat2__c(name='Level 2', CAS_Course_Cat1__c=c1.id);
        insert c2;
        CAS_Course_Cat3__c c3 = new CAS_Course_Cat3__c(name='Level 3', CAS_Course_Cat2__c=c2.id);
        insert c3;              

        opp.CAS_Course_Cat1__c = c1.id;
        opp.CAS_Course_Cat2__c = c2.id;
        opp.CAS_Course_Cat3__c = c3.id;
        update opp;

        OpportunityContactRole ocr = zTEST_Shared.insertOpportunityContactRole(opp.Id, c.Id);

        // setup a reference to the page the controller is expecting with the parameters
        PageReference pref = Page.CAS_Contact_Search_Export;
        pref.getParameters().put('searchType','CourseCategories');
        pref.getParameters().put('l1','Level 1');
        pref.getParameters().put('l2','Level 2');
        pref.getParameters().put('l3','Level 3');
        Date fDate = date.today().addDays(-1);
        pref.getParameters().put('f', '2011-05-01'); 
        Date tDate = date.today().addDays(1);
        pref.getParameters().put('t', tDate.year() + '-' + tDate.month() + '-' + tDate.day()); 
        pref.getParameters().put('c','Canada,United States');
        Test.setCurrentPage(pref);
        
        // Construct the custom controller
        CASContactSearchExportController con = new CASContactSearchExportController();
        
        List<CASContactSearchExportWrapper> wrapperList = con.wrapperList;     
    }
    
    public static void testContactSearchExportSubjectCodes(Contact c) {
        CAS_Subject_Code__c sc1 = zTEST_Shared.insertCASSubjectCode(c.OwnerId);
        CAS_Subject_Code__c sc2 = zTEST_Shared.insertCASSubjectCode(c.OwnerId);
        CAS_Subject_Code_Contact__c scc = zTEST_Shared.insertCASSubjectCodeContact(sc1.Id, c.Id, c.OwnerId);
        CAS_Subject_Code_Contact__c scc2 = zTEST_Shared.insertCASSubjectCodeContact(sc2.Id, c.Id, c.OwnerId);

        // setup a reference to the page the controller is expecting with the parameters
        PageReference pref = Page.CAS_Contact_Search_Export;
        pref.getParameters().put('searchType','SubjectCodes');
        pref.getParameters().put('scodes',sc1.id+','+sc2.id);
        pref.getParameters().put('c','Canada,United States');
        Test.setCurrentPage(pref);
        
        // Construct the custom controller
        CASContactSearchExportController con = new CASContactSearchExportController();   
    }    
    
    public static void testOpportunityController(Opportunity opp) {
        //CAS_Course_Cat1__c c1 = new CAS_Course_Cat1__c(name='Level 1', North_America__c=false);   CHG0036312
        CAS_Course_Cat1__c c1 = new CAS_Course_Cat1__c(name='Level 1');
        insert c1;
        CAS_Course_Cat2__c c2 = new CAS_Course_Cat2__c(name='Level 2', CAS_Course_Cat1__c=c1.id);
        insert c2;
        CAS_Course_Cat3__c c3 = new CAS_Course_Cat3__c(name='Level 3', CAS_Course_Cat2__c=c2.id);
        insert c3;              
        // setup a reference to the page the controller is expecting with the parameters
        PageReference pref = Page.CAS_Opportunity_Display;
        pref.getParameters().put('id',opp.id);
        Test.setCurrentPage(pref);
        
        // Construct the standard controller for the opporunity. 
        ApexPages.StandardController con = new ApexPages.StandardController(opp);  
        
        // Construct the controller class 
        CASOpportunityController ext = new CASOpportunityController(con);
        
        // Call the methods on the ext controller with null values      
        List<SelectOption> l1 = ext.level1Items;
        List<SelectOption> l2 = ext.level2Items;
        List<SelectOption> l3 = ext.level3Items; 
        
        // set the selected id
        ext.selectedLevel1 = c1.id;
        ext.selectedLevel2 = c2.Id;
        ext.selectedLevel3 = c3.Id;         
        
        // call the methods agai
        List<SelectOption> l1a = ext.level1Items;
        List<SelectOption> l2a = ext.level2Items;
        List<SelectOption> l3a = ext.level3Items;
        
        opp.CAS_Course_Cat1__c = c1.id;
        PageReference refCheck1 = ext.checkCategory();
        opp.CAS_Course_Cat1__c = null;
        PageReference refCheck2 = ext.checkCategory();
        
        PageReference refCategories = ext.goToCourseCategories();
        PageReference refSave = ext.save();
        ext.resetLevel2();
    }       
    
    private static void testInspectionCopyController(Opportunity opp, PricebookEntry pbe) {
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id, 'Created');
        oli.Book_Strengths__c = 'oli strengths';
        oli.Book_Weaknesses__c = 'oli weaknesses';  
        insert oli;             
        
        CAS_Inspection_Copy__c ic = zTEST_Shared.insertCASInspectionCopy(opp.Id, oli.Id);
        
        // setup a reference to the page the controller is expecting with the parameters
        PageReference pref = Page.ICFeedback;
        pref.getParameters().put('id',ic.id);
        Test.setCurrentPage(pref);
        CASInspectionCopyController ext = new CASInspectionCopyController();    
        PageReference ref = ext.save();  
        PageReference displayPage = Page.ICFeedback_Return;

        Boolean bTest = ext.renderRequiredTextbook;
        ext.renderRequiredTextbook = bTest;
        PageReference pref2 = ext.renderRequiredText();
        PageReference pref3 = ext.isValidId();
        String sTest = ext.getMappedAdoptionStage('I will be adopting this book for my course');
        sTest = ext.getMappedAdoptionStage('I will not adopt this book for my course');
        sTest = ext.getMappedAdoptionStage('I would like to adopt this book but it is currently under committee review');
        sTest = ext.getMappedAdoptionStage('I would like to recommend this book as a library purchase');
        sTest = ext.getMappedAdoptionStage('else');
        sTest = ext.getMappedAdoptionLevel('Required Textbook');
        sTest = ext.getMappedAdoptionLevel('Highly Recommended');
        sTest = ext.getMappedAdoptionLevel('else');

        ic.Adoption_Stage__c = 'I will not adopt this book for my course';
        update ic;
        oli.Book_Strengths__c = null;
        oli.Book_Weaknesses__c = null;
        update oli;
        pref = Page.ICFeedback;
        pref.getParameters().put('id',ic.id);
        Test.setCurrentPage(pref);
        ext = new CASInspectionCopyController();    
        PageReference pref4 = ext.save();
        PageReference pref5 = ext.renderRequiredText();

        ic.Adoption_Stage__c = 'I would like to return this book';
        update ic;
        pref = Page.ICFeedback;
        pref.getParameters().put('id',ic.id);
        Test.setCurrentPage(pref);
        ext = new CASInspectionCopyController();    
        PageReference pref6 = ext.save();
    }
    
    // tests the CASInspectionCopy Controller - BAD URL
    private static void testInspectionCopyControllerBadUrl() {
        PageReference pref = Page.ICFeedback;
        Test.setCurrentPage(pref);
        CASInspectionCopyController ext = new CASInspectionCopyController();
        // test that BAD urls are sent to the home page
        PageReference homePage = Page.ICHome;
        // ensure the url is valid
        System.assertEquals(ext.isValidId().getUrl(),homePage.getUrl());
    }
    
    private static void testInspectionCopyDisplayController(Opportunity opp, PricebookEntry pbe) {
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id, 'Created');
        CAS_Inspection_Copy__c ic = zTEST_Shared.insertCASInspectionCopy(opp.Id, oli.Id);
        PageReference pref = Page.CAS_Inspection_Copy_Display;
        pref.getParameters().put('id',ic.id);
        Test.setCurrentPage(pref);
        CASInspectionCopyDisplayController ext = new CASInspectionCopyDisplayController(new ApexPages.StandardController(ic));
        String sTest = ext.oliName;
    } 
}