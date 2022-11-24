/**********************************************************************
//This is test class for trigger "TF_LicenseMemberJSON_Tgr"

***********************************************************************/

@isTest
global class zTest_TF_LicenseMemberJSON_Tgr {
    public static void setup() {
        TriggerInterfaceHelper.runTrigger('TF_LicenseMemberJSON_Tgr', 'License_Memeber__c', 1, 'ai,au,bd', null, null); 
        // Created a account record  
        Account a = new Account();
        a.Name = 'test_acc';
        a.Ringgold_Account_ID__c = 'Account1_License_Member';
        a.Type = 'Consortium';
        a.Customer_Id__c = '12345';
        insert a;
        
        Account a2 = new Account();
        a2.Name = 'test_acc';
        a2.Type = 'Customer';
        a2.Ringgold_Account_ID__c = 'Account2_License_Member';
        a2.Customer_Id__c = '123456';
        insert a2;
        
        //Created a product record
        Product2 p = new Product2();
        p.Name = 'test_pro';
        p.IsActive = true;
        p.Hub_Id__c = 'Hub Id 9999999999';
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
        
        //Creating license list
        List<License__c> licenseList = new List<License__c>();
        licenseList.add( new License__c( Customer__c = a.id, Product__c = p.id, Order_Number__c = 'Test ON1', License_Type__c = 'Perpetual', Update_Type__c = 'Dynamic', Grant_Type__c = 'View; Download', Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'Active' ) );
        licenseList.add( new License__c( Customer__c = a2.id, Product__c = p.id, Order_Number__c = 'Test ON2', License_Type__c = 'Subscription', Update_Type__c = 'Static', Grant_Type__c = 'Download', Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'Active' ) );
        licenseList.add( new License__c( Customer__c = a.id, Product__c = p.id, Order_Number__c = 'Test ON3', License_Type__c = 'Perpetual', Update_Type__c = 'Dynamic', Grant_Type__c = 'Download', Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'Active' ) );
        licenseList.add( new License__c( Customer__c = a.id, Product__c = p.id, Order_Number__c = 'Test ON4', License_Type__c = 'Perpetual', Update_Type__c = 'Dynamic', Grant_Type__c = 'Download', Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'In progress' ) );
        insert licenseList;
        
        //insert custom setting
        TF_OrgSpecificProps__c tf_OrgSpecificProps = new TF_OrgSpecificProps__c();
        tf_OrgSpecificProps.AWS_Region_Name__c              = 'eu-west-1';
        tf_OrgSpecificProps.AWS_SQS_Access_Key_Id__c        = 'AKIAIWLW7TNA5CXZWOAA';
        tf_OrgSpecificProps.AWS_SQS_Secret_Access_key__c    = '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';
        tf_OrgSpecificProps.AWS_SQS_Host_Url__c             = 'https://sqs.eu-west-1.amazonaws.com';
        tf_OrgSpecificProps.AWS_SQS_Queue_Name__c           = '/012177264511/sqs-euw1-ap-pe-df-salesforce-license-listener-dev';
        insert tf_OrgSpecificProps;
        
        //Creating license Member list
        List<License_Memeber__c> licMemberList = new List<License_Memeber__c>();
        licMemberList.add( new License_Memeber__c( Account__c = a.id, License__c = licenseList[0].id ) );
        licMemberList.add( new License_Memeber__c( Account__c = a2.id, License__c = licenseList[0].id ) );
        licMemberList.add( new License_Memeber__c( Account__c = a.id, License__c = licenseList[1].id ) );
        licMemberList.add( new License_Memeber__c( Account__c = a2.id, License__c = licenseList[1].id ) );
        licMemberList.add( new License_Memeber__c( Account__c = a.id, License__c = licenseList[2].id ) );
        licMemberList.add( new License_Memeber__c( Account__c = a.id, License__c = licenseList[3].id ) );
        
        Test.startTest();
        Test.setMock ( HttpCalloutMock.class, new MockGenerator_Test() );
        insert licMemberList;
        Test.stopTest();
        
        //Deleting license member
        delete licMemberList[0];
        delete licMemberList[5];
    }
    
    //This method is to cover json creation while license member insertion, updation and deletion
    static testMethod void licenseMemberJSONTest() {
        setup();
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
}