@IsTest
global with sharing class LightningSelfRegisterControllerTest {
    
    
    /* Verifies that IsValidPassword method with various password combinations. */
    @IsTest
    static void testIsValidPassword() {
        System.assert(LightningSelfRegisterController.isValidPassword('password?@12334', 'password?@12334') == true);
        System.assert(LightningSelfRegisterController.isValidPassword('password?@12334', 'dummyPassword') == false);
        System.assert(LightningSelfRegisterController.isValidPassword('password?@12334', null) == false);
        System.assert(LightningSelfRegisterController.isValidPassword(null, 'fakePwd') == false);
        LightningSelfRegisterController.selfRegister('firstName','lastName', ' test @ gmail.com ', 'password?@12334', 'password?@12334', null, null, null, null, false);
        
    }
    @IsTest
    static void testValidatePassword() {
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.RunAs(thisUser) {
            Account ac = new Account(name='test ac');
            insert ac;
            Contact con = new Contact(FirstName='test',LastName='test con', AccountId = ac.id);
            insert con;
            
            //UserRole r = [SELECT id, name FROM UserRole WHERE Name = 'Taylor & Francis' LIMIT 1]; // [ Select Id, name From UserRole Where PortalType = 'None' Limit 1 ];
            Profile p = [SELECT Id FROM Profile WHERE Name='Agent Extranet Community User'];
            //User u=new User(Alias = 'standt1',BMIS_Account_Number__c='12324',PortalRole = 'Manager',IsActive=true,CommunityNickname='testNick',Country='United Kingdom',Email='demo1@randomdemodomain.com',EmailEncodingKey='UTF-8', LastName='Testing',FirstName='test', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='testAgentExtra@agent.com',ContactId=con.ID);
            User u=new User(Alias = 'standt1',BMIS_Phone__c='7878878787',BMIS_Account_Number__c='12324',PortalRole = 'Manager',IsActive=true,CommunityNickname='testNick',Country='United Kingdom',Email='demo1@randomdemodomain.com',EmailEncodingKey='UTF-8', LastName='Testing',FirstName='test', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='testAgentExtra@agent.com',ContactId=con.ID);
            insert u;    
            
            String password='password?@12334';
            String confirmPassword='password?@12334';
            LightningSelfRegisterController.validatePassword(u,password,confirmPassword);
            System.assertEquals(LightningSelfRegisterController.validatePassword(u,password,confirmPassword), '');
            //System.assertEquals(LightningSelfRegisterController.validatePassword(u,password,confirmPassword));
        }
    }
    @IsTest
    static void testSiteAsContainerEnabled() {
        System.assertNotEquals(null, LightningSelfRegisterController.siteAsContainerEnabled('https://portaleu1-developer-edition.eu11.force.com'));
    }
    
    /* Verifies the selfRegistration method flow with various invalid inputs */
    @IsTest
    static void testSelfRegistration() {
        BMIS_Setting__c BMIS_SettingRecord = new BMIS_Setting__c();
        BMIS_SettingRecord.BMIS_Endpoint__c = 'https://api-uat.taylorandfrancis.com/v1/bmis/salesforce/accountInfo/';     
        insert BMIS_SettingRecord;
        Map < String, String > paramsMap = initializeParams(); String zipCode;
        string jsondata ='';
        jsondata = '[{"dbRequired":false,"fieldPath":"BMIS_Account_Number__c","label":"Account Number","required":false,"type":{},"value":"12345"},{"dbRequired":false,"fieldPath":"BMIS_Phone__c","label":"Phone Number","required":false,"type":{},"value":"7878878787"},{"dbRequired":false,"fieldPath":"BMIS_Zipcode__c","label":"Zipcode","required":false,"type":{},"value":"2112"}]';
        //  System.assertNotEquals(null, paramsMap);
        //  System.assertEquals(Label.Site.lastname_is_required, LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), '', paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true));
        //  System.assertEquals('First name is required.', LightningSelfRegisterController.selfRegister(null, paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), jsondata, paramsMap.get('startUrl'), true));
        //  System.assertEquals(Label.Site.email_is_required, LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), '', paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), jsondata , paramsMap.get('startUrl'), true));
        //  System.assertEquals(Label.site.passwords_dont_match, LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordWrong'), null, paramsMap.get('regConfirmUrl'), jsondata, paramsMap.get('startUrl'), true));
        LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordWrong'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), false);
        jsondata = '[{"dbRequired":false,"fieldPath":"BMIS_Account_Number__c","label":"Account Number","required":false,"type":{},"value":"12345"},{"dbRequired":false,"fieldPath":"BMIS_Phone__c","label":"Phone Number","required":false,"type":{},"value":"7878878787"},{"dbRequired":false,"fieldPath":"BMIS_Zipcode__c","label":"Zipcode","required":false,"type":{},"value":"65211"}]';
        LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordWrong'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), false);
        
        jsondata = '[{"dbRequired":false,"fieldPath":"BMIS_Account_Number__c","label":"Account Number","required":false,"type":{},"value":"12345"},{"dbRequired":false,"fieldPath":"BMIS_Phone__c","label":"Phone Number","required":false,"type":{},"value":"7878878787"},{"dbRequired":false,"fieldPath":"BMIS_Zipcode__c","label":"Zipcode","required":false,"type":{},"value":"65211"}]';
        LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordWrong'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), false);
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TF_AG_MockHttpResponseGenerator());
        system.debug('Error 1 =====>'+paramsMap.get('firstName'));
        system.debug('Error 2 =====>'+paramsMap.get('lastName'));
        system.debug('Error 3 =====>'+paramsMap.get('email'));
        system.debug('Error 4 =====>'+paramsMap.get('password'));
        system.debug('Error 5 =====>'+paramsMap.get('confirmPasswordWrong'));
        system.debug('Error 6 =====>'+paramsMap.get('accountId'));
        system.debug('Error 7 =====>'+paramsMap.get('regConfirmUrl'));
        system.debug('Error 8 =====>'+paramsMap.get('startUrl'));
        LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordWrong'), paramsMap.get('accountId'), paramsMap.get('regConfirmUrl'),jsondata,paramsMap.get('startUrl'), false);
        
        test.stoptest();
    }
    
    static void testSelfRegistration1() {
        Map < String, String > paramsMap = initializeParams();
        string jsondata = '[{"dbRequired":false,"fieldPath":"BMIS_Account_Number__c","label":"Account Number","required":false,"type":{},"value":"12345"},{"dbRequired":false,"fieldPath":"BMIS_Phone__c","label":"Phone Number","required":false,"type":{},"value":"7878878787"},{"dbRequired":false,"fieldPath":"BMIS_Zipcode__c","label":"Zipcode","required":false,"type":{},"value":"2112"}]';
        
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TF_AG_MockHttpResponseGenerator1());
        LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordWrong'), paramsMap.get('accountId'), paramsMap.get('regConfirmUrl'),jsondata,paramsMap.get('startUrl'), false);
        test.stoptest();
    }
    static void testSelfRegistration_telephone() {
        Map < String, String > paramsMap = initializeParams();
        string jsondata = '[{"dbRequired":false,"fieldPath":"BMIS_Account_Number__c","label":"Account Number","required":false,"type":{},"value":"12345"},{"dbRequired":false,"fieldPath":"BMIS_Phone__c","label":"Phone Number","required":false,"type":{},"value":"7878878787"},{"dbRequired":false,"fieldPath":"BMIS_Zipcode__c","label":"Zipcode","required":false,"type":{},"value":"65211"}]';
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TF_AG_MockHttpResponseGenerator1());
        LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordWrong'), paramsMap.get('accountId'), paramsMap.get('regConfirmUrl'),jsondata,paramsMap.get('startUrl'), false);
        test.stoptest();
    }
    
    /* Verifies the selfRegistration flow for valid inputs */
    @IsTest
    static void testSelfRegisterWithProperCredentials() {
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.RunAs(thisUser) {
            Map < String, String > paramsMap = initializeParams();
            Account ac = new Account(name='test ac');
            insert ac;
            Contact con = new Contact(FirstName='test',LastName='test con',email='test26@gmail.com', AccountId = ac.id);
            insert con;  
            Profile p = [SELECT Id FROM Profile WHERE Name='Agent Extranet Community User'];
            // User u=new User(Alias = 'standt1',isActive=true, BMIS_Account_Number__c='12324',FirstName='test',PortalRole = 'Manager',CommunityNickname='testNick',Country='United Kingdom',Email='demo1@randomdemodomain.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='testAgentExtra@agent.com',ContactId=con.ID);
            User u=new User(Alias = 'standt1',BMIS_Phone__c='7878878787',BMIS_Account_Number__c='12324',PortalRole = 'Manager',IsActive=true,CommunityNickname='testNick',Country='United Kingdom',Email='demo1@randomdemodomain.com',EmailEncodingKey='UTF-8', LastName='Testing',FirstName='test', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='testAgentExtra@agent.com',ContactId=con.ID);
            insert u;
            System.debug('con:='+con);
            LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), u.email, paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true);
        }
    }
    
    /* Verifies SelfRegistration flow with an accounId that is created within the test */
    @IsTest
    static void testSelfRegisterWithCreatedAccount() {
        Account acc = new Account(name = 'test acc');
        insert acc;
        //List < Account > accounts = [SELECT Id FROM Account LIMIT 1];
        List<Account> accounts = new List<Account>();
        accounts.add(new account(name='test accounts'));
        insert accounts;
        System.assert(!accounts.isEmpty(), 'There must be at least one account in this environment!');
        String accountId = accounts[0].Id;
        Map < String, String > paramsMap = initializeParams();
        LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), accountId, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), false);
    }
    
    @IsTest
    static void testGetNullExtraFields() {
        System.assertEquals(new List < Map < String, Object >> (), LightningSelfRegisterController.getExtraFields(null));
    }
    
    @IsTest
    static void testGetNonEmptyExtraFields() {
        string jsondata = '[{"dbRequired":false,"fieldPath":"BMIS_Account_Number__c","label":"Account Number","required":false,"type":{},"value":"12345"},{"dbRequired":false,"fieldPath":"BMIS_Phone__c","label":"Phone Number","required":false,"type":{},"value":"7878878787"},{"dbRequired":false,"fieldPath":"BMIS_Zipcode__c","label":"Zipcode","required":false,"type":{},"value":"2112"}]';
        
        System.assertEquals(new List < Map < String, Object >> (), LightningSelfRegisterController.getExtraFields(jsondata));
    }
    
    /* Verifies validation of extraFields within the Self Registration flow */
    @IsTest
    static void testGetExtraFieldsInSelfRegistration() {
        string jsondata = '[{"dbRequired":false,"fieldPath":"BMIS_Account_Number__c","label":"Account Number","required":false,"type":{},"value":"12345"},{"dbRequired":false,"fieldPath":"BMIS_Phone__c","label":"Phone Number","required":false,"type":{},"value":""},{"dbRequired":false,"fieldPath":"BMIS_Zipcode__c","label":"Zipcode","required":false,"type":{},"value":"2112"}]';
        List < Map < String, Object >> fieldlist = new List < Map < String, Object >> ();
        Map < String, String > paramsMap = initializeParams();
        Map < String, Object > fieldMap = new Map < String, Object > ();
        fieldMap.put('description', 'new field');
        fieldMap.put('fieldPath', 'dummyPath');
        fieldlist.add(fieldMap);
        String extraFields = JSON.serialize(fieldlist);
        LightningSelfRegisterController.getExtraFields(extraFields);
        LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), extraFields, paramsMap.get('startUrl'), true);
        LightningSelfRegisterController.selfRegister(null,paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), extraFields, paramsMap.get('startUrl'), true);
        LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'),null, paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), extraFields, paramsMap.get('startUrl'), true);
        LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'),paramsMap.get('lastName'), null, paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), extraFields, paramsMap.get('startUrl'), true);
        LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'),paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), jsondata, paramsMap.get('startUrl'), true);
        string jsondata1 = '[{"dbRequired":false,"fieldPath":"BMIS_Account_Number__c","label":"Account Number","required":false,"type":{},"value":"12345"},{"dbRequired":false,"fieldPath":"BMIS_Phone__c","label":"Phone Number","required":false,"type":{},"value":"787878787"},{"dbRequired":false,"fieldPath":"BMIS_Zipcode__c","label":"Zipcode","required":false,"type":{},"value":""}]';
        
        LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'),paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), jsondata1, paramsMap.get('startUrl'), true);
        
    }
    
    @IsTest
    static void LightningSelfRegisterControllerInstantiation() {
        LightningSelfRegisterController controller = new LightningSelfRegisterController();
        System.assertNotEquals(controller, null);
    }
    
    @isTest
    static void testsetExperienceId(){
        string str='.in';
        string st='';
        LightningSelfRegisterController.setExperienceId(str);
        LightningSelfRegisterController.setExperienceId(st);
    }
    
    /* Helper method to initialize the parameters required for SelfRegistration. */
    private static Map < String, String > initializeParams() {
        Map < String, String > paramsMap = new Map < String, String > ();
        String firstName = 'test';
        String lastName = 'User';
        String email = 'testUser@salesforce.com';
        String password = 'testuser123';
        String confirmPasswordCorrect = 'testuser123';
        String confirmPasswordWrong = 'wrongpassword';
        String accountId = 'testuser123';
        String regConfirmUrl = 'http://registration-confirm.com';
        String startUrl = 'http://my.company.salesforce.com';
        paramsMap.put('firstName', firstName);
        paramsMap.put('lastName', lastName);
        paramsMap.put('email', email);
        paramsMap.put('password', password);
        paramsMap.put('confirmPasswordCorrect', confirmPasswordCorrect);
        paramsMap.put('confirmPasswordWrong', confirmPasswordWrong);
        paramsMap.put('accountId', accountId);
        paramsMap.put('regConfirmUrl', regConfirmUrl);
        paramsMap.put('startUrl', startUrl);
        return paramsMap;
    }
    
    global class TF_AG_MockHttpResponseGenerator implements HttpCalloutMock {
        // Implement this interface method
        global HTTPResponse respond(HTTPRequest req) {
            // Optionally, only send a mock response for a specific endpoint
            // and method.
            //System.assertEquals('http://example.com/example/test', req.getEndpoint());
            //System.assertEquals('GET', req.getMethod());
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"access_token":"f53490297036576a7c62a3bae1d418f8","token_type":"Bearer","expires_in": 3600,"id_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpcCI6IiIsImNvbnRlbnRfY2Vuc29yaW5nX2VuYWJsZWQiOmZhbHNlLCJzY29wZSI6WyJ1bmxpY2Vuc2VkX3NlYXJjaCIsInByb2R1Y3RfYWNjZXNzIl0sInRlcnJpdG9yeV90eXBlIjoiY291bnRyeSIsImNsaWVudCI6eyJfaWQiOiI1YmNkNzQxMjg0ZDJjZjFmMDBjOTI3NmUiLCJ1c2VybmFtZSI6InJhamVzaC5rdXNod2FoYS5nYjFAaW5mb3JtYS5jb20iLCJuYW1lIjoiVU5TREciLCJjbGllbnRJZCI6IjhjMDYxOWVhN2U3ZGM2ODE5YjdlYzY1MTliYTZjOTc0MDVhMDQyZjRkMTM4Mzc1ZDQ1MDgxNDUxYzk5MDU4MTAiLCJyZWRpcmVjdF91cmlzIjpbImh0dHA6Ly9sb2NhbGhvc3Q6ODA4MCJdfSwiciI6WyJCVVMiXSwiaXNzIjoiaHR0cHM6Ly9hY2NvdW50cy11YXQudGF5bG9yZnJhbmNpcy5jb20vaWRlbnRpdHkvIiwiZXhwIjoxNTU2NzA2NDAzLCJpYXQiOjE1NTY3MDI4MDMsImF1ZCI6IjhjMDYxOWVhN2U3ZGM2ODE5YjdlYzY1MTliYTZjOTc0MDVhMDQyZjRkMTM4Mzc1ZDQ1MDgxNDUxYzk5MDU4MTAiLCJzdWIiOm51bGx9.TR_bIrIOEOwV844gYevwXqfAVSEW6C2QI2EqU838UXz5N8O_kn_ixezI87lR6HfjYECm_nCtD1J7xQw4hVrcGHDQ9j5YS3iBI33M9BDDjblC9YODNsRdjvCn4ggG1CTGZ4wV9Ie_ya4QVKr7JjF3jqeu3wdXQrjXLeudqRd10lyGSkZAXv4A9J4okUvy9LuLvcNFk3KkP3M6TQwPHuTbvC9LZxJFu5qcxQP3yDZnRQDaHi1EuV-A43e_BcQufVz3TPXz1dMNZ13VX1Hez2gteOewp9hglvheaMDjr7ytTJ8QCJ5v9VmMWcTosljOVRvW38C5_APnxnpXcJMYNPc-lQ"}');
            res.setStatusCode(200);
            res.setStatus('OK');
            return res;
        }
    }
    global class TF_AG_MockHttpResponseGenerator1 implements HttpCalloutMock {
        // Implement this interface method
        global HTTPResponse respond(HTTPRequest req) {
            // Optionally, only send a mock response for a specific endpoint
            // and method.
            //System.assertEquals('http://example.com/example/test', req.getEndpoint());
            //System.assertEquals('GET', req.getMethod()); 
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"access_token":"f53490297036576a7c62a3bae1d418f8","token_type":"Bearer","expires_in": 3600,"id_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpcCI6IiIsImNvbnRlbnRfY2Vuc29yaW5nX2VuYWJsZWQiOmZhbHNlLCJzY29wZSI6WyJ1bmxpY2Vuc2VkX3NlYXJjaCIsInByb2R1Y3RfYWNjZXNzIl0sInRlcnJpdG9yeV90eXBlIjoiY291bnRyeSIsImNsaWVudCI6eyJfaWQiOiI1YmNkNzQxMjg0ZDJjZjFmMDBjOTI3NmUiLCJ1c2VybmFtZSI6InJhamVzaC5rdXNod2FoYS5nYjFAaW5mb3JtYS5jb20iLCJuYW1lIjoiVU5TREciLCJjbGllbnRJZCI6IjhjMDYxOWVhN2U3ZGM2ODE5YjdlYzY1MTliYTZjOTc0MDVhMDQyZjRkMTM4Mzc1ZDQ1MDgxNDUxYzk5MDU4MTAiLCJyZWRpcmVjdF91cmlzIjpbImh0dHA6Ly9sb2NhbGhvc3Q6ODA4MCJdfSwiciI6WyJCVVMiXSwiaXNzIjoiaHR0cHM6Ly9hY2NvdW50cy11YXQudGF5bG9yZnJhbmNpcy5jb20vaWRlbnRpdHkvIiwiZXhwIjoxNTU2NzA2NDAzLCJpYXQiOjE1NTY3MDI4MDMsImF1ZCI6IjhjMDYxOWVhN2U3ZGM2ODE5YjdlYzY1MTliYTZjOTc0MDVhMDQyZjRkMTM4Mzc1ZDQ1MDgxNDUxYzk5MDU4MTAiLCJzdWIiOm51bGx9.TR_bIrIOEOwV844gYevwXqfAVSEW6C2QI2EqU838UXz5N8O_kn_ixezI87lR6HfjYECm_nCtD1J7xQw4hVrcGHDQ9j5YS3iBI33M9BDDjblC9YODNsRdjvCn4ggG1CTGZ4wV9Ie_ya4QVKr7JjF3jqeu3wdXQrjXLeudqRd10lyGSkZAXv4A9J4okUvy9LuLvcNFk3KkP3M6TQwPHuTbvC9LZxJFu5qcxQP3yDZnRQDaHi1EuV-A43e_BcQufVz3TPXz1dMNZ13VX1Hez2gteOewp9hglvheaMDjr7ytTJ8QCJ5v9VmMWcTosljOVRvW38C5_APnxnpXcJMYNPc-lQ"}');
            res.setStatusCode(404);
            res.setStatus('Not Found');
            return res;
        }
    }
}