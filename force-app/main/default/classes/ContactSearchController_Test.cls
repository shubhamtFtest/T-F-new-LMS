@isTest
public class ContactSearchController_Test {
    @testSetup
    public static void setupTestData(){
        
        Id contactRecordTypeId = [Select Id, Name, sObjectType From RecordType Where sObjectType='Contact' AND Name ='T&F - Contacts'].Id;
        Id accountRecordTypeId = [Select Id, Name, sObjectType From RecordType Where sObjectType='Account' AND Name ='T&F - Accounts'].Id;
        
        Account acc = new Account( RecordTypeId = accountRecordTypeId, Name='Test Account', Phone='1234567890', Type='Agent' , 	
                                  Mailing_Country_List__c ='United Kingdom', Locale__c='APAC' , Sales_Region__c='Africa'
                                 );
        insert acc;
        
        Campus__c campus = new Campus__c( Name ='Test Campus' , Account__c = acc.Id, Mailing_Street__c='UK' , Mailing_City__c='UK',
                                         Mailing_Country_List__c ='United Kingdom' , Mailing_State_Province_List__c ='Antrim',
                                         Mailing_ZIP_Postal_Code__c = '12345'
                                        );
        insert campus;
        
        Department__c departmentName = new Department__c( Name='Test Department', Account__c = acc.Id, 	Campus__c=campus.Id,
                                                         Mailing_City__c='UK', Mailing_Street__c='UK', Mailing_ZIP_Postal_Code__c='12345',
                                                         Mailing_Country_List__c='United Kingdom', Mailing_State_Province_List__c='Antrim');
        insert departmentName;
        
        List<Contact> contactList = new List<Contact>();
        For(Integer i=0; i <= 200; i++){
            Contact con = new Contact( RecordTypeId = contactRecordTypeId, FirstName = 'Test' , LastName ='Contact '+i, AccountId = acc.Id,
                                      Email = 'test@testTF'+i+'.com', Campus__c = campus.Id, Department = departmentName.Id, LeadSource = 'Email',
                                      Business__c = 'CAS', Mailing_Country_List__c = 'Andorra', Status__c ='Active');
            contactList.add(con);
        }
        insert contactList;
        Test.startTest();
        ContactSearchController.contactSearchDefault(acc.Id,'','',0,5);
        ContactSearchController.contactSearchDefault('',campus.Id,'',0,5);
        ContactSearchController.contactSearchDefault('','',departmentName.Id,0,5);
        ContactSearchController.doSearchContact(acc.Id,'','','Test', '', '', '', '', '', '', '', '', '', '',0,5,'test');
        ContactSearchController.doSearchContact('',campus.Id,'','', 'CreatedDate', '2017-11-11', '2017-11-28', 'test', '', '', '', '', '', 'test',0,5,'');
        ContactSearchController.doSearchContact('','',departmentName.Id,'', 'CreatedDate', '2017-11-11', '2017-11-28', '', 'test', 'test', 'test', '', '', '',0,5,'test3');
        
        ContactSearchController.wrapperClass wrapperCls;   
        wrapperCls=ContactSearchController.getpicklistValue();
        // ContactSearchController.wrapperClass lstData=wrapperCls.getpicklistValue();
        Test.stopTest();
        
    }
    
    public static testMethod void contactSearchDefaultTest(){
        Id accountRecordTypeId = [Select Id, Name, sObjectType From RecordType Where sObjectType='Account' AND Name ='T&F - Accounts'].Id;
        Account acc = new Account( RecordTypeId = accountRecordTypeId, Name='Test Account2', Phone='1234567890', Type='Agent' , 	
                                  Mailing_Country_List__c ='United Kingdom', Locale__c='APAC' , Sales_Region__c='Africa'
                                 );
        insert acc;
        Test.startTest();
        ContactSearchController.contactSearchDefault(acc.Id,'','',0,5);
        Test.stopTest();
    }
    
    
}