/*
* Tests: Case_AccountSearchController 	100%
*/
@isTest
private class zTEST_Case_AccountSearch {

    static testMethod void test_Case_AccountSearch() {
		//Setup sample data
		User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
		Contact c = zTEST_Shared.noinsertContact(u.Id, a.Id);
		c.Email = 'test@test.com';
		insert c;
		Contact c2 = zTEST_Shared.noinsertContact(u.Id, null);
		c2.Email = 'test2@test.com';
		insert c2;
		Case cse = new Case();
		insert cse;
		//ISO_Country__c country = new ISO_Country__c();
		//country.Name = 'test';
		//country.ISO_Code__c = 'TS';
		//insert country;
        
        //Setup a reference to the page the controller is expecting with the parameters
        PageReference pRef = Page.Case_AccountSearch;
        pRef.getParameters().put('id',cse.id);
        Test.setCurrentPage(pRef);

        //Setup a reference to the controller
        Case_AccountSearchController ext = new Case_AccountSearchController(new ApexPages.StandardController(cse));
        
        //Call methods
        List<Account> accounts = ext.accounts;
        ext.searchValue = 'test';
        accounts = ext.accounts;
        ext.searchMethod = 'Account Name';
        accounts = ext.accounts;
        ext.searchMethod = 'Ringgold ID';
        accounts = ext.accounts;
        ext.searchMethod = 'BP';
        accounts = ext.accounts;
        ext.searchMethod = '';
        accounts = ext.accounts;
        
        ext.doSearch();
        ext.doSelect();
        ext.doAddNew();
        ext.a.Name = 'test';
        ext.c.LastName = 'test';
        ext.a.Shipping_Country_List__c = 'United States';
        ext.doSave();
        ext.a.Shipping_State_List__c = 'FL';
        ext.c.Email = 'test@test.com';
        ext.doSave();
        ext.useDupe();
        ext.c.Email = 'test2@test.com';
        ext.doSave();
        ext.c.Email = 'test3@test.com';
        ext.doSave();
        ext.goBackToSearch();
        ext.doCancel();        
    }
}