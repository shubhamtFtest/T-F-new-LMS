@isTest
public class zTest_SalesCompanionWebsiteCustomerType {
	@isTest
    private static void customerType(){
        
        RecordType recordTypeName = [SELECT Name FROM recordtype WHERE sObjectType = 'Case' AND Name = 'T&F - Sales Companion Website Access'];
        Group queue = [SELECT Name FROM group WHERE type = 'Queue' AND name = 'Sales CW Access - Catch All'];
       
        //creating test case for instructor
        
        Case testCaseInstructor = new Case ();
        testCaseInstructor.OwnerId = queue.Id;
        testCaseInstructor.RecordTypeId = recordTypeName.Id;
        testCaseInstructor.Subject = 'Instructor Access Test';
        testCaseInstructor.Customer_Type111__c = 'Instructor';
        
        insert testCaseInstructor;
        
        Case loadCaseInstructor = [SELECT Query_Category__c, Query_Type__c FROM Case WHERE Id = :testCaseInstructor.Id];
      
        system.assertEquals('Instructor Access', loadCaseInstructor.Query_Category__c);
        system.assertEquals('Instructor Access', loadCaseInstructor.Query_Type__c);
        
        //creating test case for student access
        
        Case testCaseStudent = new Case ();
        testCaseStudent.OwnerId = queue.Id;
        testCaseStudent.RecordTypeId = recordTypeName.Id;
        testCaseStudent.Subject = 'Student Access Test';
        testCaseStudent.Customer_Type111__c = 'Student';
        
        insert testCaseStudent;
        
        Case loadCaseStudent = [SELECT Query_Category__c, Query_Type__c FROM Case WHERE Id = :testCaseStudent.Id];
      
        system.assertEquals('Student Access', loadCaseStudent.Query_Category__c);
        system.assertEquals('Student Access', loadCaseStudent.Query_Type__c);
        
        //creating test case for professional access
        
        Case testCaseProfessional = new Case ();
        testCaseProfessional.OwnerId = queue.Id;
        testCaseProfessional.RecordTypeId = recordTypeName.Id;
        testCaseProfessional.Subject = 'Professional Access Test';
        testCaseProfessional.Customer_Type111__c = 'Professional';
        
        insert testCaseProfessional;
        
        Case loadCaseProfessional = [SELECT Query_Category__c, Query_Type__c FROM Case WHERE Id = :testCaseProfessional.Id];
      
        system.assertEquals('Professional Access', loadCaseProfessional.Query_Category__c);
        system.assertEquals('Professional Access', loadCaseProfessional.Query_Type__c);
        
        //creating test case for researcher access
        
        Case testCaseResearcher = new Case ();
        testCaseResearcher.OwnerId = queue.Id;
        testCaseResearcher.RecordTypeId = recordTypeName.Id;
        testCaseResearcher.Subject = 'Researcher Access Test';
        testCaseResearcher.Customer_Type111__c = 'Researcher';
        
        insert testCaseResearcher;
        
        Case loadCaseResearcher = [SELECT Query_Category__c, Query_Type__c FROM Case WHERE Id = :testCaseResearcher.Id];
      
        system.assertEquals('Researcher Access', loadCaseResearcher.Query_Category__c);
        system.assertEquals('Researcher Access', loadCaseResearcher.Query_Type__c);
        
        
    }
    
    
}