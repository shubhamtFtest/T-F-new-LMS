/**************************************************
* Created by: Tom Reed: 2018-07-30
* Tested method for: ReleaseNotesPDF_ctr
**************************************************/

@istest
public class zTest_ReleaseNotesPDF {
    
    Public Static testMethod void TestReleaseNotes_ctr(){          
        
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Salesforce Internal Support').getRecordTypeId();  
        Date dateToday = date.today();
        Case testCase = new Case(Add_to_Release_Notes__c = true, RecordTypeId = devRecordTypeId, Application__c = 'CAS - Course Adoption System', Release_Notes_rich__c='test', Target_Resolution_Date__c=dateToday);
        insert testCase;
        
        Test.startTest();       
        
        String startDateValue = string.valueOf(date.today());
        String endDateValue = string.valueOf(date.today().adddays(7));
        
        ReleaseNotesPDF_ctr testController = new ReleaseNotesPDF_ctr();       
        PageReference pageRef = Page.ReleaseNotesPDF;
        pageRef.getParameters().put('startdate', startDateValue);
        pageRef.getParameters().put('enddate', endDateValue);
        Test.setCurrentPage(pageRef);
        
        testController.getParameter();
        
        Test.stopTest();
        
    }   
}