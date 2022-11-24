/**************************************************
* Created by: Tom Reed: 2018-07-30
* Test method for: ReleaseNotes_ctr
**************************************************/

@istest
public class zTest_ReleaseNotes_ctr {
    
    Public Static testMethod void testReleaseNotes_ctr(){          
        
        Date dateToday = date.today().adddays(2);
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Salesforce Internal Support').getRecordTypeId();
        
        Case testCase = new Case(Add_to_Release_Notes__c = true, Application__c = 'CAS - Course Adoption System', Release_Notes_rich__c='test', Target_Resolution_Date__c=dateToday, RecordTypeId=devRecordTypeId);
        insert testCase;
     
        Test.startTest();       
        
        date startDate = date.today();
        date endDate = date.today().adddays(7);
        
        ReleaseNotes_ctr.caseRecord testCaseRecord = new ReleaseNotes_ctr.caseRecord();
        testCaseRecord.department = testCase.Application__c;
        testCaseRecord.releaseDate = testCase.Target_Resolution_Date__c;
        testCaseRecord.releaseNotes = testCase.Release_Notes_rich__c;
        
        ReleaseNotes_ctr.getCaseData(string.ValueOf(startDate), string.ValueOf(endDate));
        
        Test.stopTest();        
    }    
}