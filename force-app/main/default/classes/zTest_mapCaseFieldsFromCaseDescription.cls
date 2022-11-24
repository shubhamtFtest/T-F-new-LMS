/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
 * Test class for "mapCaseFieldsFromCaseDescriptionJSON" at 100% test coverage.
 * Created by Matthew Smith and Tom Reed on November 29th 2019.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
@isTest
public class zTest_mapCaseFieldsFromCaseDescription {
    
    @isTest
    private static void mappingJSONFromCaseTest() {
        RecordType recordTypeName = [SELECT Name FROM recordtype WHERE sObjectType = 'Case' AND Name = 'T&F - Sales Companion Website Access'];
        TriggerInterfaceHelper.runTrigger('mapCaseFieldsFromCaseDescriptionJSON', 'Case', 1, 'ai', recordTypeName.Id, null);
		Group queue = [SELECT Name FROM group WHERE type = 'Queue' AND name = 'Sales CW Access - Catch All'];  
        RecordType accountRecordTypeName = [SELECT Name FROM recordtype WHERE sObjectType = 'Account' AND Name = 'T&F - Accounts'];
        RecordType contactRecordTypeName = [SELECT Name FROM recordtype WHERE sObjectType = 'Contact' AND Name = 'T&F - Contacts'];
        String correctJSONMessage = '{"Name":"Matthew Smith","Email":"matthewjksmith@hotmail.co.uk","Type_Of_User":"Instructor","Textbook_Title":"A Beginners Guide to Structural Equation Modeling"}';
        String incorrectJSONMessage = '"Name":"Matthew Smith","Email":"matthewjksmith@hotmail.co.uk","Type_Of_User":"Instructor","Textbook_Title":"A Beginners Guide to Structural Equation Modeling"';
        
        //creating test account
        Account testAccount = new Account ();
        testAccount.Name = 'Test Account';
        testAccount.Type = 'Customer';
        testAccount.Classification__c = 'Bookseller';
        testAccount.CurrencyIsoCode = 'USD';
        testAccount.Mailing_Country_List__c = 'United Kingdom';
        testAccount.BillingCity = 'Test Billing';
        testAccount.BillingStreet = 'Test Billing';
        testAccount.BillingPostalCode = '111111';
        testAccount.ShippingCity = 'Test Shipping';
        testAccount.RecordTypeId = accountRecordTypeName.Id;
        system.assertEquals(accountRecordTypeName.Id, testAccount.RecordTypeId);
        insert testAccount;
        system.assertEquals(testAccount.Id, testAccount.Id);
        
        //creating test contact
        Contact testContact = new Contact();
        testContact.AccountId = testAccount.Id;
        testContact.FirstName = 'Matthew';
        testContact.LastName = 'Smith'; 
		testContact.Email = 'matthewjksmith@hotmail.co.uk';
        testContact.Mailing_Country_List__c = 'United Kingdom';
        testContact.Business__c = 'CAS';
        testContact.LeadSource = 'Direct';
        testContact.RecordTypeId = contactRecordTypeName.Id;
        insert testContact;
        system.assertEquals(testAccount.Id, testContact.AccountId);
        
        //Creating New Case
        Case testCase = new Case ();
        testCase.Subject = 'Test';
        testCase.Description = correctJSONMessage;
        testCase.AccountId = null;
        testCase.ContactId = null;
        testCase.SuppliedEmail = 'matthew.smith.gb1@tandf.co.uk';
        testCase.OwnerId = queue.Id;
        testCase.RecordTypeId = recordTypeName.Id;
        //inserting new case
        insert testCase;
        
        Case loadCase = [SELECT ContactId, SuppliedEmail FROM Case WHERE Id = :testCase.Id];
        //check to see if supplied email is updated to the email from the JSON
        system.assertEquals('matthewjksmith@hotmail.co.uk', loadCase.SuppliedEmail);
        
        //updating created case
        loadCase.ContactId = testContact.Id;
		//check to see if suppliedemail is now te contactid
		system.assertEquals(testContact.Id, loadCase.ContactId);     
        system.assertEquals(testContact.Email, loadCase.SuppliedEmail);
        
        //creating new case for incorrect JSON
        Case testCase1 = new Case ();
        testCase1.Subject = 'Test';
        testCase1.Description = incorrectJSONMessage;
        testCase1.AccountId = null;
        testCase1.ContactId = null;
        testCase1.SuppliedEmail = 'matthew.smith.gb1@tandf.co.uk';
        testCase1.OwnerId = queue.Id;
        testCase1.RecordTypeId = recordTypeName.Id;
        //instering new case
        insert testCase1;        
	}
  
}