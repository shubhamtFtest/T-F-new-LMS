@isTest
	public class Test_caseController {
	static testMethod void testMethod1()
	{
		
		Case testCase = new Case();
		testCase.SuppliedName='Test Case' ;
		testCase.SuppliedEmail = 'testCase@xyz.com';
		testCase.SuppliedPhone= '123456789';
		insert testCase;
        Case testCase1 = new Case();
		testCase1.SuppliedName='Test Case1' ;
		testCase1.SuppliedEmail = 'testCase@xyz.com';
		testCase1.SuppliedPhone= '123456789';
		insert testCase1;
        
        Account acc = new Account();
        acc.Name = 'CSD Personal';
        insert acc;
     
        Test.StartTest();
        CaseController.getCaseRecord(testCase.Id);
        //system.debug('Get Case Record 24>>> '+testCase.Id);
        CaseController.getAccount();
        CaseController.getContactList(testCase.SuppliedName, testCase.SuppliedEmail, testCase.SuppliedPhone, acc.Id, 'CAS', 'United Kingdom');
        //system.debug('Line 28>>> '+CaseController.getContactList(testCase.SuppliedName, testCase.SuppliedEmail, testCase.SuppliedPhone, acc.Id, 'Marketing', 'United Kingdom'));
		Test.StopTest();
	}
}