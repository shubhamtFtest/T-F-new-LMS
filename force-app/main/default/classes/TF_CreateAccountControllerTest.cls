@IsTest(SeeAllData=false)
public class TF_CreateAccountControllerTest {
    
    @isTest
    public static void createAccountTest(){
        
        //Provide fields of Account
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.BillingCity = 'Test';
        acc.BillingPostalCode = 'Test';
        acc.BillingStreet = 'Test';
        acc.Mailing_State_List__c = '--- None ---';
        acc.Shipping_State_List__c = '--- None ---';
        acc.Billing_State_List__c = '--- None ---';
        acc.Mailing_Country_List__c = '--- None ---';
        acc.Shipping_Country_List__c = '--- None ---';
        acc.Billing_Country_List__c = '--- None ---';
        
        String BillingAddLine1 = 'Test';
        String BillingAddLine2 = 'Test';
        String MailingAddLine1 = 'Test';
        String MailingAddLine2 = 'Test';
        String ShippingAddLine1 = 'Test';
        String ShippingAddLine2 = 'Test'; 
        boolean next = true;
        boolean prev = false;
        decimal off = 10; 
        decimal pageNumber = 10;
        String updateOrInsert='NewCustomer';
        
        //Insert account to create user
        Account parentAcc = new Account();
        parentAcc.Name='Parent TestAccount';
        parentAcc.BillingCity='Test';
        parentAcc.BillingPostalCode='Test';
        parentAcc.Aggregator_identifier__c = 'ProQuest';
        insert parentAcc; 
        
        //Insert Contact to create user
        Contact userCon = new Contact();
        userCon.LastName  = 'Test';
        userCon.AccountId = parentAcc.id;
        system.debug('AccountId------'+userCon.AccountId);
        insert userCon;
        
        //Insert user
        User currentUser = new User();
        currentUser.Username='currentusertest@gmail.com';
        currentUser.ContactId = userCon.ID;
        currentUser.Contact = userCon;
        currentUser.LastName = 'Test';
        currentUser.Email = 'currentusertest@gmail.com';
        currentUser.Alias = 'testAcc';
        currentUser.TimeZoneSidKey ='GMT';
        currentUser.LocaleSidKey ='en_US';
        currentUser.EmailEncodingKey ='ISO-8859-1';
        SObject profTest = [ select id from profile where Name= 'Customer Community Plus User Account Request' LIMIT 1];
        currentUser.ProfileId = (ID) profTest.get('ID'); 
        currentUser.LanguageLocaleKey = 'en_US';
        currentUser.CommunityNickname = 'Test01';
        insert currentUser;
        
        Country__c CountryObj = new Country__c();
        CountryObj.Country_2__c  = 'IN';
        CountryObj.Name  = 'India'; 
        insert CountryObj;       
        
  		//Insert list of IP 
        End_User_Access__c a = new End_User_Access__c(Description__c = 'Test Description',IP_Range__c='Test',Type__c='Standard',Account__c=acc.Id);
        End_User_Access__c b = new End_User_Access__c(Description__c = 'Test Description',IP_Range__c='Test',Type__c='Standard',Account__c=acc.Id);
        End_User_Access__c[] ListForIP = new End_User_Access__c[]{a,b};
            
        //Insert list of IP's ID set for update   
        String[] NewListForIPSet = new String[]{'a3e1l000000281i', 'a3e1l000000281r'};
                
        //Insert remote access field
        End_User_Access__c remoteAccess = new End_User_Access__c(Entity_ID__c='Test Remote',Account__c=acc.Id);
        End_User_Access__c[] EndUserRemoteAccess = new End_User_Access__c[]{remoteAccess};  
        
        //Insert ID of remote access for update
        String[] NewEndUserRemoteAccessSet = new String[]{'a3e1l000000281r'};    
                
        //Insert list of contact
        Contact con = new Contact(LastName='Test Contact');
        Contact[] ListForContact = new Contact[]{con};
            
        //Insert list of contact for update
        Contact newContact = new Contact(LastName='New Test Contact');
        Contact[] NewListForContact = new Contact[]{newContact};
            
        String verifyAddressesInfo = 'verifying';
        Boolean billingCountryNotUpdate = true;
        String[] billingStateNoneUpdate = new String[]{'Test'};
        Boolean shippingCountryNotUpdate = true;
        String[] shippingStateNoneUpdate = new String[]{'Test'};
        Boolean mailingCountryNotUpdate = true;
        String[] mailingStateNoneUpdate = new String[]{'Test'};
        String contrfieldApiName = 'India';
        String depfieldApiName = 'Rajasthan';
        String validFor = 'Test';
        Integer val = 1;
        
        System.runAs(currentUser){
            TF_CreateAccountController.createAccount(acc, verifyAddressesInfo, billingCountryNotUpdate, billingStateNoneUpdate, shippingCountryNotUpdate, shippingStateNoneUpdate, mailingCountryNotUpdate, mailingStateNoneUpdate,  NewEndUserRemoteAccessSet, NewListForIPSet, NewListForContact, updateOrInsert, ListForContact, ListForIP, EndUserRemoteAccess, BillingAddLine1, BillingAddLine2, MailingAddLine1, MailingAddLine2, ShippingAddLine1, ShippingAddLine2,'testdata');  
            TF_CreateAccountController.getRoleList();
            TF_CreateAccountController.getTypeList();
            TF_CreateAccountController.getAccount(next, prev, pageNumber, off);        
            TF_CreateAccountController.fetchUser();
            
            //Insert fields for dependent picklist
            Account account = new Account();
            account.Name='TestAccount';
            account.BillingCity='Test';
            account.BillingPostalCode='Test';
            account.BillingStreet='Test';
            insert account;
            
            TF_CreateAccountController.decimalToBinary(val);
            TF_CreateAccountController.base64ToBits(validFor);
            TF_CreateAccountController.getMailingDependentMap(account, contrfieldApiName, depfieldApiName);
            TF_CreateAccountController.getShippingDependentMap(account, contrfieldApiName, depfieldApiName);
            TF_CreateAccountController.getBillingDependentMap(account, contrfieldApiName, depfieldApiName);
            
            //Search method
            Date startDate = date.newInstance(2019, 08, 12);
            Date endDate = date.newInstance(2019, 09, 12);
			Decimal PageNumberSearch = 10;
            Decimal offSearch = 10;
            
            string searchNameKeyword='';
            boolean nextSearch = true;
            boolean prevSearch = false;
            TF_CreateAccountController.fetchAccountDataByName(searchNameKeyword, startDate, endDate, nextSearch, prevSearch, PageNumberSearch, offSearch);
            
            string searchNameKeywordTest='Test';
            boolean nextSearchTest = false;
            boolean prevSearchTest = true;
            Date startDateNull = null;
            Date endDateNull = null;
            TF_CreateAccountController.fetchAccountDataByName(searchNameKeywordTest, startDateNull, endDateNull, nextSearchTest, prevSearchTest, PageNumberSearch, offSearch);
			TF_CreateAccountController.fetchAccountDataByName(searchNameKeywordTest, startDate, endDate, nextSearchTest, prevSearchTest, PageNumberSearch, offSearch);
        	TF_CreateAccountController.fetchAccountDataByName(searchNameKeyword, startDateNull, endDateNull, nextSearchTest, prevSearchTest, PageNumberSearch, offSearch);

            //Delete Account
            /*Account delAcc = new Account();
            delAcc.Name = 'Delete Account';
            delAcc.BillingCity = 'Test';
            delAcc.BillingPostalCode = 'Test';
            delAcc.BillingStreet = 'Test';
            insert delAcc;
            TF_CreateAccountController.deleteAccount(delAcc);*/
        }
    }
    

    @isTest
    public static void updateAccountTest(){
        
        //Insert Account
        Account acc = new Account();
        acc.Name='TestAccount';
        acc.BillingCity='Test';
        acc.BillingPostalCode='Test';
        acc.BillingStreet='Test';
        acc.Mailing_State_List__c='Test1';
        acc.Shipping_State_List__c='Test1';
        acc.Billing_State_List__c='Test1';
        acc.Mailing_Country_List__c='Test';
        acc.Shipping_Country_List__c='Test';
        acc.Billing_Country_List__c='Test';
        insert acc;
        
        String BillingAddLine1='';
        String BillingAddLine2='';
        String MailingAddLine1='';
        String MailingAddLine2='';
        String ShippingAddLine1='';
        String ShippingAddLine2=''; 
        boolean next = false;
        boolean prev = true;
        decimal off = 10; 
        decimal pageNumber = 10;
        String updateOrInsert='updateCustomer';
        
		//Insert account to create user        
        Account parentAcc = new Account();
        parentAcc.Name='Parent TestAccount';
        parentAcc.BillingCity='Test';
        parentAcc.BillingPostalCode='Test';
        parentAcc.Aggregator_identifier__c = 'GOBI';
        insert parentAcc; 
        
        //Insert Contact to create user
        Contact userCon = new Contact();
        userCon.LastName  = 'Test';
        userCon.AccountId = parentAcc.id;
        system.debug('AccountId------'+userCon.AccountId);
        insert userCon;
        
        //Insert user
        User currentUser = new User();
        currentUser.Username = 'currentusertest@gmail.com';
        currentUser.ContactId = userCon.ID;
        currentUser.Contact = userCon;
        currentUser.LastName = 'Test';
        currentUser.Email = 'currentusertest@gmail.com';
        currentUser.Alias = 'testAcc';
        currentUser.TimeZoneSidKey ='GMT';
        currentUser.LocaleSidKey ='en_US';
        currentUser.EmailEncodingKey ='ISO-8859-1';
        SObject profTest = [ select id from profile where Name= 'Customer Community Plus User Account Request' LIMIT 1];
        currentUser.ProfileId = (ID) profTest.get('ID'); 
        currentUser.LanguageLocaleKey = 'en_US';
        currentUser.CommunityNickname = 'Test01';
        insert currentUser;

        Country__c CountryObj = new Country__c();
        CountryObj.Country_2__c  = 'IN';
        CountryObj.Name  = 'India'; 
        insert CountryObj;       
        
        //Insert list of IP
        End_User_Access__c a = new End_User_Access__c(Description__c='Test Description',IP_Range__c='Test',Type__c='Standard',Account__c=acc.Id);
        End_User_Access__c b = new End_User_Access__c(Description__c='Test Description',IP_Range__c='Test',Type__c='Standard',Account__c=acc.Id);
        End_User_Access__c[] ListForIP = new End_User_Access__c[]{a,b};
            
        //Insert list of IP's ID set for update    
        String[] NewListForIPSet = new String[]{'a3e1l000000281i', 'a3e1l000000281r'};
        
        //Insert remote access field
        End_User_Access__c remoteAccess = new End_User_Access__c(Entity_ID__c='Test Remote',Account__c=acc.Id);
        End_User_Access__c[] EndUserRemoteAccess = new End_User_Access__c[]{remoteAccess};  
        
        //Insert ID of remote access for update
        String[] NewEndUserRemoteAccessSet = new String[]{'a3e1l000000281r'};    
        
        Contact sfdcContact = new Contact(LastName='Test Contact', Email = 'test@gmail.com');
        insert sfdcContact;
            
        //Insert list of contact
        Contact con1 = new Contact(LastName='Test Contact', id= sfdcContact.id, Email = 'test@gmail.com');
        Contact con2 = new Contact(LastName='Test Contact', Email = 'test@gmail.com');
        Contact con3 = new Contact(LastName='Test Contact', Email = 'test1@gmail.com');
        Contact[] ListForContact = new Contact[]{con1, con2, con3};
            
        //Insert list of contact for update
        Contact newContact1 = new Contact(LastName='New Test Contact', id= sfdcContact.id, Email = 'test@gmail.com');
        Contact newContact2 = new Contact(LastName='New Test Contact', Email = 'test@gmail.com');
        Contact[] NewListForContact = new Contact[]{newContact1, newContact2};
            
        String verifyAddressesInfo = 'verifying';
        Boolean billingCountryNotUpdate = true;
        String[] billingStateNoneUpdate = new String[]{'Test'};
        Boolean shippingCountryNotUpdate = true;
        String[] shippingStateNoneUpdate = new String[]{'Test'};
        Boolean mailingCountryNotUpdate = true;
        String[] mailingStateNoneUpdate = new String[]{'Test'};
        String contrfieldApiName = 'India';
        String depfieldApiName = 'Rajasthan';
        String validFor = 'Test';
        Integer val = 1;
        
        System.runAs(currentUser){
            TF_CreateAccountController.createAccount(acc, verifyAddressesInfo, billingCountryNotUpdate, billingStateNoneUpdate, shippingCountryNotUpdate, shippingStateNoneUpdate, mailingCountryNotUpdate, mailingStateNoneUpdate,  NewEndUserRemoteAccessSet, NewListForIPSet, NewListForContact, updateOrInsert, ListForContact, ListForIP, EndUserRemoteAccess, BillingAddLine1, BillingAddLine2, MailingAddLine1, MailingAddLine2, ShippingAddLine1, ShippingAddLine2,null);  
            TF_CreateAccountController.getRoleList();
            TF_CreateAccountController.getTypeList();
            TF_CreateAccountController.getAccount(next, prev, pageNumber, off);        
            TF_CreateAccountController.fetchUser();
            
            //Insert fields for dependent picklist
            Account account = new Account();
            account.Name='TestAccount';
            account.BillingCity='Test';
            account.BillingPostalCode='Test';
            account.BillingStreet='Test';
            insert account;
            
            TF_CreateAccountController.decimalToBinary(val);
            TF_CreateAccountController.base64ToBits(validFor);
            TF_CreateAccountController.getMailingDependentMap(account, contrfieldApiName, depfieldApiName);
            TF_CreateAccountController.getShippingDependentMap(account, contrfieldApiName, depfieldApiName);
            TF_CreateAccountController.getBillingDependentMap(account, contrfieldApiName, depfieldApiName);
            
            //Search method
            Decimal PageNumberSearch = 10;
            decimal offSearch = 10;
            Date startDate = date.newInstance(2019, 08, 12);
            Date endDate = date.newInstance(2019, 09, 12);
            
            string searchNameKeyword = '';
            boolean nextSearch = false;
            boolean prevSearch = false;
            TF_CreateAccountController.fetchAccountDataByName(searchNameKeyword, startDate, endDate, nextSearch, prevSearch, PageNumberSearch, offSearch);
            
            string searchNameKeywordTest = 'Test';
            boolean nextSearchAccount = false;
            boolean prevSearchAccount = true;
            Date startDateNull = null;
            Date endDateNull = null;
            TF_CreateAccountController.fetchAccountDataByName(searchNameKeywordTest, startDate, endDate, nextSearchAccount, prevSearchAccount, PageNumberSearch, offSearch);
       		TF_CreateAccountController.fetchAccountDataByName(searchNameKeywordTest, startDateNull, endDateNull, nextSearchAccount, prevSearchAccount, PageNumberSearch, offSearch);
       		TF_CreateAccountController.fetchAccountDataByName(searchNameKeyword, startDateNull, endDateNull, nextSearchAccount, prevSearchAccount, PageNumberSearch, offSearch);
		
        }
    }
    
    
    
    @isTest
    public static void insertAndUpdateAccountTest(){
        
        //Provide fields of Account
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.BillingCity = 'Test';
        acc.BillingPostalCode = 'Test';
        acc.BillingStreet = 'Test';
        acc.Mailing_Country_List__c = '';
        acc.Shipping_Country_List__c = '';
        acc.Billing_Country_List__c = '';
        
        String BillingAddLine1 = '';
        String BillingAddLine2 = '';
        String MailingAddLine1 = '';
        String MailingAddLine2 = '';
        String ShippingAddLine1 = '';
        String ShippingAddLine2 = ''; 
        boolean next = true;
        boolean prev = false;
        decimal off = 10; 
        decimal pageNumber = 10;
        String updateOrInsert='NewCustomer';
        
        //Insert account to create user
        Account parentAcc = new Account();
        parentAcc.Name='Parent TestAccount';
        parentAcc.BillingCity='Test';
        parentAcc.BillingPostalCode='Test';
        parentAcc.Aggregator_identifier__c = 'ProQuest';
        insert parentAcc; 
        
        //Insert Contact to create user
        Contact userCon = new Contact();
        userCon.LastName  = 'Test';
        userCon.AccountId = parentAcc.id;
        system.debug('AccountId------'+userCon.AccountId);
        insert userCon;
        
        //Insert user
        User currentUser = new User();
        currentUser.Username='currentusertest@gmail.com';
        currentUser.ContactId = userCon.ID;
        currentUser.Contact = userCon;
        currentUser.LastName = 'Test';
        currentUser.Email = 'currentusertest@gmail.com';
        currentUser.Alias = 'testAcc';
        currentUser.TimeZoneSidKey ='GMT';
        currentUser.LocaleSidKey ='en_US';
        currentUser.EmailEncodingKey ='ISO-8859-1';
        SObject profTest = [ select id from profile where Name= 'Customer Community Plus User Account Request' LIMIT 1];
        currentUser.ProfileId = (ID) profTest.get('ID'); 
        currentUser.LanguageLocaleKey = 'en_US';
        currentUser.CommunityNickname = 'Test01';
        insert currentUser;
        
        Country__c CountryObj = new Country__c();
        CountryObj.Country_2__c  = 'IN';
        CountryObj.Name  = 'India'; 
        insert CountryObj;       
        
  		//Insert list of IP 
        End_User_Access__c a = new End_User_Access__c(Description__c = 'Test Description',IP_Range__c='Test',Type__c='Standard',Account__c=acc.Id);
        End_User_Access__c b = new End_User_Access__c(Description__c = 'Test Description',IP_Range__c='Test',Type__c='Standard',Account__c=acc.Id);
        End_User_Access__c[] ListForIP = new End_User_Access__c[]{a,b};
            
        //Insert list of IP's ID set for update   
        String[] NewListForIPSet = new String[]{'a3e1l000000281i', 'a3e1l000000281r'};
                
        //Insert remote access field
        End_User_Access__c remoteAccess = new End_User_Access__c(Entity_ID__c='Test Remote',Account__c=acc.Id);
        End_User_Access__c[] EndUserRemoteAccess = new End_User_Access__c[]{remoteAccess};  
        
        //Insert ID of remote access for update
        String[] NewEndUserRemoteAccessSet = new String[]{'a3e1l000000281r'};    
                
        //Insert list of contact
        Contact con1 = new Contact(LastName='Test Contact1', Email='test@gmail.com');
        Contact con2 = new Contact(LastName='Test Contact2', Email='test1@gmail.com');
        Contact[] ListForContact = new Contact[]{con1, con2};
            
        Contact sfdcContact = new Contact(LastName='Test Contact1', Email='test@gmail.com'); 
        insert sfdcContact;
        //Insert list of contact for update
        Contact newContact = new Contact(LastName='New Test Contact', Email='test@gmail.com');
        Contact[] NewListForContact = new Contact[]{newContact};
            
        String verifyAddressesInfo = 'verifying';
        Boolean billingCountryNotUpdate = true;
        String[] billingStateNoneUpdate = new String[]{'Test'};
        Boolean shippingCountryNotUpdate = true;
        String[] shippingStateNoneUpdate = new String[]{'Test'};
        Boolean mailingCountryNotUpdate = true;
        String[] mailingStateNoneUpdate = new String[]{'Test'};
        String contrfieldApiName = 'India';
        String depfieldApiName = 'Rajasthan';
        String validFor = 'Test';
        Integer val = 1;
        
        System.runAs(currentUser){
            TF_CreateAccountController.createAccount(acc, verifyAddressesInfo, billingCountryNotUpdate, billingStateNoneUpdate, shippingCountryNotUpdate, shippingStateNoneUpdate, mailingCountryNotUpdate, mailingStateNoneUpdate,  NewEndUserRemoteAccessSet, NewListForIPSet, NewListForContact, updateOrInsert, ListForContact, ListForIP, EndUserRemoteAccess, BillingAddLine1, BillingAddLine2, MailingAddLine1, MailingAddLine2, ShippingAddLine1, ShippingAddLine2,null);  
        }
    }
    
    
}