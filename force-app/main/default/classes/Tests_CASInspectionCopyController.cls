/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Tests_CASInspectionCopyController {

    static testMethod void myUnitTest() {
      /**  
        user u = [Select id from User where id = '005600000013ck5'];//Site User
        
        CAS_Inspection_Copy__c ic = [Select c.Id, c.Name,
            c.Opportunity__c
            , c.Book_Order__c
            , c.Opportunity_Product__c
            , c.SystemModstamp  
                , c.Adoption_Stage__c
                ,c.Adoption_Level__c
                , c.Adoption_Short__c, c.Contact_Rep__c, c.Additional_Comments__c
                , c.IsAdoptionShort__c, c.Reason_Lost__c
            from CAS_Inspection_Copy__c c
            where c.Book_Order__c != null and c.Opportunity__c != null and c.Opportunity_Product__c != null order by c.SystemModstamp  desc limit 1];
        
        ic.Adoption_Stage__c ='I will not adopt this book for my course';
        ic.Book_Strengths__c = 'good';
        ic.Book_Weaknesses__c = 'good';
        ic.Year_of_Study__c = 'Graduate';
        Update ic;
        
        PageReference pref = Page.ICFeedback;
        pref.getParameters().put('id',ic.id);
        Test.setCurrentPage(pref);
        CASInspectionCopyController con = new CASInspectionCopyController();
        con.renderRequiredText();
        pref = con.save();
        
        //bad URL
        pref = Page.ICFeedback;
        pref.getParameters().put('id','001');
        Test.setCurrentPage(pref);
        con = new CASInspectionCopyController();
        con.isValidId();
        //pref = con.save();
        
        //show decision date and day task
        ic.Adoption_Stage__c ='This book is under committee review';
        ic.Decision_Date__c = date.today().addDays(20);
        Update ic;
        
        pref = Page.ICFeedback;
        pref.getParameters().put('id',ic.id);
        Test.setCurrentPage(pref);
        con = new CASInspectionCopyController();
        con.isValidId();
        con.renderRequiredText();
        pref = con.save();
        
        //Test all Adoption Stages
        ic.Adoption_Stage__c ='I will be adopting this book for my course';
        ic.Adoption_Level__c = 'Required Textbook';
        Update ic;
       pref = Page.ICFeedback;
       pref.getParameters().put('id',ic.id);
        Test.setCurrentPage(pref);
        con = new CASInspectionCopyController();
        con.renderRequiredText();
       pref = con.save();
        
       ic.Adoption_Stage__c ='I never received this book';
       Update ic;
       pref = Page.ICFeedback;
       pref.getParameters().put('id',ic.id);
        Test.setCurrentPage(pref);
       con = new CASInspectionCopyController();
       con.renderRequiredText();
       pref = con.save();
       
       ic.Adoption_Stage__c ='I\'m still reviewing this book';
        ic.Adoption_Level__c = 'Highly Recommended';
        ic.Decision_Date__c = date.today();
        Update ic;
       pref = Page.ICFeedback;
       pref.getParameters().put('id',ic.id);
        Test.setCurrentPage(pref);
        con = new CASInspectionCopyController();
        con.renderRequiredText();
       pref = con.save();
       
       ic.Adoption_Stage__c ='I will not adopt this book for my course';
        ic.Adoption_Level__c = 'Highly Recommended';
        ic.Decision_Date__c = null;
        Update ic;
       pref = Page.ICFeedback;
       pref.getParameters().put('id',ic.id);
        Test.setCurrentPage(pref);
        con = new CASInspectionCopyController();
        con.renderRequiredText();
       pref = con.save();
        

        ic.Adoption_Stage__c ='I would like to recommend this book as a library purchase';
        ic.Adoption_Level__c = 'Highly Recommended';
        ic.Decision_Date__c = null;
        Update ic;
       pref = Page.ICFeedback;
       pref.getParameters().put('id',ic.id);
        Test.setCurrentPage(pref);
        con = new CASInspectionCopyController();
        con.renderRequiredText();
       pref = con.save();
       
       ic.Adoption_Stage__c ='X';
        ic.Adoption_Level__c = 'X';
        
        ic.Decision_Date__c = null;
        Update ic;
       pref = Page.ICFeedback;
       pref.getParameters().put('id',ic.id);
        Test.setCurrentPage(pref);
        con = new CASInspectionCopyController();
        con.renderRequiredText();
       pref = con.save();
*/
    }
}