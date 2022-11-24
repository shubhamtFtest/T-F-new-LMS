/**************************************************
* Created by Tom Reed
* Test methods for Link_CAB_Tickets_ctr
**************************************************/

@isTest
public class zTest_Link_CAB_Tickets_ctr {

    Public Static testMethod void TestController(){   
        
        Date dateToday = system.today();
        Id userId = UserInfo.getUserId();
        system.debug(userId);
        
        
        // Create a Meeting Record
        Meeting__c testMeetingRecord = New Meeting__c(Name = 'Test Meeting');  
        Insert testMeetingRecord;
        
        // Create A Case To Link
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Salesforce Internal Support').getRecordTypeId();
        Case testCase = New Case(Implementation_Plan__c = 'test', Subject = 'Test Subject', Description = 'Test Description',Area__c = 'Salesforce Classic', Application__c = 'Sales', Approval_Status__c = 'TDA Approved', Testing_Signoff_Received_From__c = userId, Target_Resolution_Date__c = dateToday, Release_Notes_Rich__c = 'test', Origin = 'Web', Type = 'Question', Status = 'TDA Approved', RecordTypeId = caseRecordTypeId);
		insert testCase;
        testCase.Status = 'Pending CAB';
        update testCase;
        
        Test.startTest();  
        // Set The Test Page To My Visualforce Page
        Test.setCurrentPage(Page.Link_CAB_Tickets);
        ApexPages.currentPage().getParameters().put('id',testMeetingRecord.Id);
        // Call The Constructor
        Link_CAB_Tickets_ctr controller = new Link_CAB_Tickets_ctr (new ApexPages.StandardController(testMeetingRecord));
        Link_CAB_Tickets_ctr.addCabCases(); 
        Test.stopTest();     
    } 
}