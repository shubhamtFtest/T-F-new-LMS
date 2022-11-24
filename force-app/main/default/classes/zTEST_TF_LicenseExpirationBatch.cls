//This is the test class of the Batch class : TF_LicenseExpirationBatch

@isTest
global class zTEST_TF_LicenseExpirationBatch {
    static testMethod void LicenseExpirationBatch_Test () {
         TriggerInterfaceHelper.runTrigger('TF_CreateLicenseJSON_Tgr', 'License__c', 1, 'au', null, null); 
        
        //Created Account records
        List<Account> accList = new List<Account>();
        accList.add(new Account(Name = 'Test1', Type = 'Consortium', Ringgold_Account_ID__c = 'Ringgold1', Customer_Id__c = '12345'));
        accList.add(new Account(Name = 'Test2', Type = 'Customer', Ringgold_Account_ID__c = 'Ringgold2', Customer_Id__c = '123456'));
        accList.add(new Account(Name = 'Test3', Type = 'Consortium',Ringgold_Account_ID__c = 'Ringgold3', Customer_Id__c = '1234567'));
        insert accList;
        
        //Create a Product record
        Product2 p = new Product2();
        p.Name = 'Test_Product';
        p.IsActive = true;
        p.Hub_Id__c = 'Hub_Id_Product';
        insert p;
        
        //Creating standard price book entry
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = p.Id, UnitPrice = 200, IsActive = true);
        insert standardPrice;
        
        //Creating a custom Pricebook
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        //Creating custom price book entry
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = p.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        
        
        //insert custom setting
        TF_OrgSpecificProps__c tf_OrgSpecificProps = new TF_OrgSpecificProps__c();
        tf_OrgSpecificProps.AWS_Region_Name__c              = 'eu-west-1';
        tf_OrgSpecificProps.AWS_SQS_Access_Key_Id__c        = 'AKIAIWLW7TNA5CXZWOAA';
        tf_OrgSpecificProps.AWS_SQS_Secret_Access_key__c    = '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';
        tf_OrgSpecificProps.AWS_SQS_Host_Url__c             = 'https://sqs.eu-west-1.amazonaws.com';
        tf_OrgSpecificProps.AWS_SQS_Queue_Name__c           = '/012177264511/sqs-euw1-ap-pe-df-salesforce-license-listener-dev';
        insert tf_OrgSpecificProps;
        
        //Created  a license list    
        List<License__c> licenseList = new List<License__c>();
        licenseList.add( new License__c( License_Type__c = 'Subscription', Update_Type__c = 'Static', Status__c = 'Active', Order_Number__c = 'Order1', Product__c = p.id, End_Date__c = Date.today().addDays(-1), Purchase_Date__c = Date.today().addDays(4), Customer__c = accList[0].id, Start_Date__c =  Date.today().addDays(-5), Grant_Type__c = 'View'));
        licenseList.add( new License__c( License_Type__c = 'Trial', Update_Type__c = 'Dynamic', Status__c = 'Active', Order_Number__c = 'Order2', Product__c = p.id, End_Date__c = Date.today().addDays(-1), Purchase_Date__c = Date.today().addDays(3), Customer__c = accList[0].id, Start_Date__c =  Date.today().addDays(-4), Grant_Type__c = 'Download' ));
        licenseList.add( new License__c( License_Type__c = 'Subscription', Update_Type__c = 'Static', Status__c = 'In progress', Order_Number__c = 'Order3', Product__c = p.id, End_Date__c = Date.today().addDays(-1), Purchase_Date__c = Date.today().addDays(5), Customer__c = accList[1].id, Start_Date__c =  Date.today().addDays(-6), Grant_Type__c = 'View'));
        licenseList.add( new License__c( License_Type__c = 'Trial', Update_Type__c = 'Dynamic', Status__c = 'In progress', Order_Number__c = 'Order4', Product__c = p.id, End_Date__c = Date.today().addDays(-1), Purchase_Date__c = Date.today().addDays(2), Customer__c = accList[1].id, Start_Date__c =  Date.today().addDays(-3), Grant_Type__c = 'View; Download'));
        licenseList.add( new License__c( License_Type__c = 'Perpetual', Update_Type__c = 'Static', Status__c = 'In progress', Order_Number__c = 'Order5', Product__c = p.id, End_Date__c = Date.today().addDays(-1), Purchase_Date__c = Date.today().addDays(3), Customer__c = accList[2].id, Start_Date__c =  Date.today().addDays(-2), Grant_Type__c = 'Download' ));
        insert licenseList;
        
        Test.startTest();
        Test.setMock ( HttpCalloutMock.class, new MockGenerator_Test() );
        TF_LicenseExpirationBatch license_batch = new TF_LicenseExpirationBatch();
        Database.executeBatch(license_batch,200);
        Test.setMock ( HttpCalloutMock.class, new MockGenerator_Test() );
        Test.stopTest();
        
    }
    
    global class MockGenerator_Test implements HttpCalloutMock {
        global HttpResponse respond ( HTTPRequest req ) {

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