@isTest
public class OpportunitySearchController_Test {
    @testSetup
    public static void setupTestData(){
        
        Id opportunitRecordTypeId = [Select Id, Name, sObjectType From RecordType Where sObjectType='Opportunity' AND Name ='T&F - CAS Opportunity'].Id;
        Id accountRecordTypeId = [Select Id, Name, sObjectType From RecordType Where sObjectType='Account' AND Name ='T&F - Accounts'].Id;
        Profile__c customSetProfile = new Profile__c();
        customSetProfile.SetupOwnerId=Userinfo.getProfileId();
        string recordType='\''+ [select id from recordtype where sobjecttype='Opportunity' Limit 1 ].id+'\'';
        system.debug('recordType'+recordType);
        customSetProfile.RecordTypes__c=recordType;
        insert customSetProfile;
        
        User u1 = zTEST_Shared.insertUser();
        User u2 = zTEST_Shared.insertUser();
        
        Account acc = new Account( RecordTypeId = accountRecordTypeId, Name='Test Account', Phone='1234567890', Type='Agent' ,  
                                  Mailing_Country_List__c ='United Kingdom', Locale__c='APAC' , Sales_Region__c='Africa'
        );
        insert acc;
        
        Campus__c campus = new Campus__c( Name ='Test Campus' , Account__c = acc.Id, Mailing_Street__c='UK' , Mailing_City__c='UK',
                                         Mailing_Country_List__c ='United Kingdom' , Mailing_State_Province_List__c ='Antrim',
                                         Mailing_ZIP_Postal_Code__c = '12345'
        );
        insert campus;
        
        Department__c departmentName = new Department__c( Name='Test Department', Account__c = acc.Id,  Campus__c=campus.Id,
                                                          Mailing_City__c='UK', Mailing_Street__c='UK', Mailing_ZIP_Postal_Code__c='12345',
                                                          Mailing_Country_List__c='United Kingdom', Mailing_State_Province_List__c='Antrim');
        insert departmentName;
        Test.startTest();
        system.debug('acc.Id'+acc.Id);
        OpportunitySearchController.opportunitySearchDefault(acc.Id,'','',0,5);
        OpportunitySearchController.opportunitySearchDefault('',campus.Id,'',0,5);
        OpportunitySearchController.opportunitySearchDefault('','',departmentName.Id,0,5);
        OpportunitySearchController.opportunitySearch(acc.Id,'','','test','2017-11-11', '2017-11-28', 'test','test', 'test','test','','CloseDate',0,5,'Open');        
        OpportunitySearchController.opportunitySearch('',campus.Id,'','test','2017-11-11', '2017-11-28', 'test','test', 'test','test','\''+opportunitRecordTypeId+'\'','CreatedDate',0,5,'');
        OpportunitySearchController.opportunitySearch('','',departmentName.Id,'test','2017-11-11', '2017-11-28', 'test','test', 'test','test','\''+opportunitRecordTypeId+'\'','',0,5,'Closed');
 
        Test.stopTest();
        List<Opportunity> opportunityList = new List<Opportunity>();
        
        System.runAs(u1) {
            for(Integer i=0; i<=200; i++){
                Opportunity opp = new Opportunity(RecordTypeId = opportunitRecordTypeId, Name='Test Opportunity '+i, AccountId = acc.Id, CloseDate = System.today(), StageName ='Prospect',
                                                 LeadSource ='Direct', Course_Start_Date__c= System.today(), Number_of_Students__c = 200,
                                                 Type='Course', Campus__c = campus.Id,  Department__c = departmentName.Id, OwnerId = u2.id);
                opportunityList.add(opp);
            }
        }
        insert opportunityList;
        Opportunity opp=zTEST_Shared.insertOpportunity(opportunitRecordTypeId, userinfo.getUserId());
        OpportunityDataWrapper opportunityWrapper = new OpportunityDataWrapper();
        opportunityWrapper.Name = opp.Name;
        opportunityWrapper.AccountName = opp.Account.Name;
        opportunityWrapper.StageName = opp.StageName;
        opportunityWrapper.CampusName = 'testCampus';
        opportunityWrapper.DepartmentName = 'testDepartment';
        opportunityWrapper.Amount = 100;
        opportunityWrapper.CloseDate = opp.CloseDate;
        opportunityWrapper.CourseStartDate = opp.Course_Start_Date__c;
        opportunityWrapper.NumberofStudents = 5;
        opportunityWrapper.Type = opp.Type;
        opportunityWrapper.Id = opp.Id;
        opportunityWrapper.baseURL = 'https://www.google.com';
        opportunityWrapper.TotalRecords=30;
        opportunityWrapper.OwnerName=userinfo.getUserName();
        
     /*   OpportunityDataWrapper obj;
        obj.TotalRecords=10;
        obj.AccountName='tes';
        obj.Amount=100;
        obj.CourseStartDate=system.Date.today();
        obj.baseURL='test';
        obj.DepartmentName='test';
        obj.NumberofStudents=2;
        obj.Name='Test';
       */  
    }
    
    public static testMethod void opportunitySearchDefaultTest(){
        OpportunitySearchController.getTypeValue(false);
        OpportunitySearchController.getTypeValue(true);
    }
    
}