/**********************************************************************
//This is test class for trigger "TF_CreateLicenseJSON_Tgr"

***********************************************************************/

@isTest
global class zTest_TF_CreateLicenseJSON_Tgr {
    
    public static List<License__c> licenseListt = new List<License__c>();
    public static Account a = new Account();
    public static Account a2 = new Account();
    public static Product2 p = new Product2();
    public static TF_OrgSpecificProps__c tf_OrgSpecificProps = new TF_OrgSpecificProps__c();
    
    public static void setup() {
        // Created a account record  
        a.Name = 'test_acc';
        a.Type = 'Consortium';
        a.Ringgold_Account_ID__c = 'Ringgold Id 1';
        a.Customer_Id__c = '12345';
        insert a;
        a2.Name = 'test_acc';
        a2.Type = 'Customer';
        a2.Ringgold_Account_ID__c = 'Ringgold Id 2';
        a2.Customer_Id__c = '123456';
        insert a2;
        
        //Created a product record
        p.Name = 'test_pro';
        p.IsActive = true;
        p.Hub_Id__c = 'Hub Id 9999999999';
        p.inLanguage__c = 'en';
        insert p;
        
        //Creating standard price book entry
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = p.Id, UnitPrice = 100, IsActive = true);
        insert standardPrice;
        
        //Creating a custom Pricebook
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        //Creating custom price book entry
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = p.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        //insert custom setting
        tf_OrgSpecificProps.AWS_Region_Name__c              = 'eu-west-1';
        tf_OrgSpecificProps.AWS_SQS_Access_Key_Id__c        = 'AKIAIWLW7TNA5CXZWOAA';
        tf_OrgSpecificProps.AWS_SQS_Secret_Access_key__c    = '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';
        tf_OrgSpecificProps.AWS_SQS_Host_Url__c             = 'https://sqs.eu-west-1.amazonaws.com';
        tf_OrgSpecificProps.AWS_SQS_Queue_Name__c           = '/012177264511/sqs-euw1-ap-pe-df-salesforce-license-listener-dev';
        insert tf_OrgSpecificProps;
        
        //Creating license list        
        licenseListt.add( new License__c( Customer__c = a.id, Product__c = p.id, Order_Number__c = 'Test ON', License_Type__c = 'Perpetual', Grant_Type__c = 'View; Download', Start_Date__c = Date.today().addDays(1), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'In progress' ) );
        licenseListt.add( new License__c( Customer__c = a2.id, Product__c = p.id, Order_Number__c = 'Test ON2', License_Type__c = 'Subscription', Grant_Type__c = 'Download', Start_Date__c = Date.today().addDays(1), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'In progress' ) );
        licenseListt.add( new License__c( Customer__c = a.id, Product__c = p.id, Order_Number__c = 'Test ON3', License_Type__c = 'Perpetual', Update_Type__c = 'Dynamic', Grant_Type__c = 'Download', Start_Date__c = Date.today().addDays(1), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'In progress' ) );
    }
    
    //Method is to cover json cretion while license insertion
    static testMethod void CreateLicenseJSONTest() {
        setup();
        TriggerInterfaceHelper.runTrigger('TF_CreateLicenseJSON_Tgr', 'License__c', 1, 'bu,ai', null, null); 

        //Creating license list
        licenseListt.add( new License__c( Customer__c = a.id, Product__c = p.id, Order_Number__c = 'Test ON', License_Type__c = 'Perpetual', Update_Type__c = 'Static', Grant_Type__c = 'View; Download', Start_Date__c = Date.today().addDays(1), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'In progress' ) );
        licenseListt.add( new License__c( Customer__c = a2.id, Product__c = p.id, Order_Number__c = 'Test ON2', License_Type__c = 'Subscription', Update_Type__c = 'Dynamic', Grant_Type__c = 'Download', Start_Date__c = Date.today().addDays(1), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'In progress' ) );
        licenseListt.add( new License__c( Customer__c = a.id, Product__c = p.id, Order_Number__c = 'Test ON3', License_Type__c = 'Perpetual', Update_Type__c = 'Dynamic', Grant_Type__c = 'Download', Start_Date__c = Date.today().addDays(1), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'In progress' ) );

        Test.startTest();
        Test.setMock ( HttpCalloutMock.class, new MockGenerator_Test() );
        insert licenseListt;

        
        List<License__c> licenseExistingList = [ SELECT id, Entitlement_Request_Status__c, Customer__c, Product__c, Order_Number__c, License_Type__c, Grant_Type__c,
                                                Start_Date__c, End_Date__c, Purchase_Date__c, Status__c FROM License__c ];
        
        //TriggerInterfaceHelper.runTrigger('TF_CreateLicenseJSON_Tgr', 'License__c', 1, 'au', null, null); 
        //Updating License
        List<License__c> licenseUpdateList = new List<License__c>();
        licenseUpdateList.add( new License__c( id = licenseExistingList[0].id, Order_Number__c = 'Update Test ON3', License_Type__c = 'Subscription', Grant_Type__c = 'Download', End_Date__c = Date.today().addDays(22) ) );
        licenseUpdateList.add( new License__c( id = licenseExistingList[1].id, Order_Number__c = 'Update Test ON4', Grant_Type__c = 'View' ) );
        licenseUpdateList.add( new License__c( id = licenseExistingList[2].id, Order_Number__c = 'Update Test ON5', Grant_Type__c = 'View', End_Date__c = NULL ) );
        update licenseUpdateList;
        
        licenseUpdateList[0].License_Type__c = 'Perpetual';
        licenseUpdateList[0].End_Date__c = NULL;
        update licenseUpdateList[0];
        
        //TriggerInterfaceHelper.runTrigger('TF_CreateLicenseJSON_Tgr', 'License__c', 1, 'bd', null, null); 
        delete licenseUpdateList[0];
        Test.stopTest();
    }
    
    //Covering negative cases by keeping license few fields as blank
    static testMethod void CreateLicenseJSONErrorTest() {
        setup();
        
        //Creating License list
        licenseListt.add( new License__c( Customer__c = a.id, Product__c = p.id, Order_Number__c = 'Test ON', License_Type__c = 'Perpetual', Grant_Type__c = 'View; Download', Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'In progress' ) );
        licenseListt.add( new License__c( Customer__c = a2.id, Product__c = p.id, Order_Number__c = 'Test ON2', License_Type__c = 'Subscription', Grant_Type__c = 'Download', Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'In progress' ) );
        
        insert licenseListt;
        /*
        System.debug('licenseListt.size() =====>' + licenseListt.size());
        
        //inserting case
        List<Case> insertCaseList = new List<Case>();
        String subj = 'Test Subject'+insertCaseList[0].id;
        insertCaseList.add( new Case( Subject = subj, Type = 'Enhancement' ) );
        insert insertCaseList;
        */
        TriggerInterfaceHelper.runTrigger('TF_CreateLicenseJSON_Tgr', 'License__c', 1, 'au', null, null); 
        
        //Updating License
        License__c licenseUpdate = new License__c( id = licenseListt[0].id );
        licenseUpdate.Order_Number__c = '';
        licenseUpdate.License_Type__c = 'Subscription';
        licenseUpdate.Grant_Type__c = 'View';
        
        try {
            Test.startTest();
            Test.setMock ( HttpCalloutMock.class, new MockGenerator_Fail_Test() );
            update licenseUpdate;
            Test.stopTest(); 
        }catch ( Exception e ) {
            System.debug('Error in catch block =======>' + e);
        }
    }
    
    //Covering negative cases by keeping license few fields as blank
    static testMethod void existingCaseTest() {
        setup();
        
        //Creating License list
        licenseListt.add( new License__c( Customer__c = a.id, Product__c = p.id, Order_Number__c = 'Test ON', License_Type__c = 'Perpetual', Grant_Type__c = 'View; Download', Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'In progress' ) );
        licenseListt.add( new License__c( Customer__c = a2.id, Product__c = p.id, Order_Number__c = 'Test ON2', License_Type__c = 'Subscription', Grant_Type__c = 'Download', Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'In progress' ) );
        
        insert licenseListt;
        System.debug('licenseListt.size() =====>' + licenseListt.size());
        
        //inserting case
        String caseRecordTypeId = [ SELECT id, name FROM RecordType WHERE sObjectType = 'Case' AND Name = 'Salesforce Internal Support' LIMIT 1 ].id;
        List<Case> insertCaseList = new List<Case>();
        String subj = 'Test Subject'+licenseListt[0].id;
        insertCaseList.add( new Case( RecordTypeId = caseRecordTypeId, status = 'New', Subject = subj, Type = 'Enhancement' ) );
        insert insertCaseList;
        
        TriggerInterfaceHelper.runTrigger('TF_CreateLicenseJSON_Tgr', 'License__c', 1, 'au', null, null); 
        
        //Updating License
        License__c licenseUpdate = new License__c( id = licenseListt[0].id );
        licenseUpdate.Order_Number__c = '';
        licenseUpdate.License_Type__c = 'Subscription';
        licenseUpdate.Grant_Type__c = 'View';
        
        try {
            Test.startTest();
            Test.setMock ( HttpCalloutMock.class, new MockGenerator_Test() );
            update licenseUpdate;
            Test.stopTest(); 
        }catch ( Exception e ) {
            System.debug('Error in catch block =======>' + e);
        }
    }
    
    //method to delete license
    static testMethod void delete_License() {
        setup();
        insert licenseListt;

        License__c licenseDelete = new License__c(id = licenseListt[0].id);
        TriggerInterfaceHelper.runTrigger('TF_CreateLicenseJSON_Tgr', 'License__c', 1, 'bd', null, null); 
        try {
            Test.setMock ( HttpCalloutMock.class, new MockGenerator_Test() );
            delete licenseDelete;
        }catch ( Exception e ) {
            System.debug('Error in catch block =======>' + e);
        }        
    }
    
    //method to cover has part update part
    static testMethod void TF_LicenseAlertPage_Test() {
        setup();
        TriggerInterfaceHelper.runTrigger('TF_CreateLicenseJSON_Tgr', 'License__c', 1, 'bu,ai,au', null, null); 
        License__c lic = new License__c( Customer__c = a.id, Product__c = p.id, Order_Number__c = 'Test ON3', License_Type__c = 'Perpetual', Grant_Type__c = 'Download', Start_Date__c = Date.today().addDays(1), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'Active', Update_Type__c = 'Dynamic', Dynamic_License_End_Date__c = Date.today().addDays(5) );
        insert lic;
        
        Test.startTest();
        License__c licUpdate = new License__c();
        licUpdate.id = lic.id;
        licUpdate.Dynamic_License_End_Date__c = Date.today().addDays(2);
        update licUpdate;
        ApexPages.StandardController sc = new ApexPages.StandardController(lic);
        TF_LicenseAlertPageExtension controller = new TF_LicenseAlertPageExtension(sc);
        PageReference pageRef = Page.LicenseAlertPage;
        Test.setCurrentPage(pageRef);
        controller.stopLicenseAlert();
        Test.stopTest();
    }
    
    //method to cover cloning part
    static testMethod void TF_LicenseClone_Test() {
        setup();
        TriggerInterfaceHelper.runTrigger('TF_CreateLicenseJSON_Tgr', 'License__c', 1, 'bi,bu,ai', null, null); 
        License__c licCloneInsert1 = new License__c( Customer__c = a.id, Product__c = p.id, Order_Number__c = 'Test ON', License_Type__c = 'Perpetual', Grant_Type__c = 'View; Download', Start_Date__c = Date.today().addDays(1), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'In progress' );
        insert licCloneInsert1;
        
        License__c licCloneInsert2 = licCloneInsert1.clone(false, false, false, false);
        insert licCloneInsert2;
    }
    
    //class to create a mock response
    global class MockGenerator_Test implements HttpCalloutMock {
        global HttpResponse respond ( HTTPRequest  req ) {

            System.assertEquals('POST', req.getMethod());

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setStatus('OK');
            res.setBody('GREAT RESPONSE');
            
            return res;
        }
    }
      
    //class to create a mock response
    global class MockGenerator_Fail_Test implements HttpCalloutMock {
        global HttpResponse respond ( HTTPRequest  req ) {
        
            System.assertEquals('POST', req.getMethod());
        
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(504);
            res.setStatus('OK');
            res.setBody('GREAT RESPONSE');
            
            return res;
        }
    }
}