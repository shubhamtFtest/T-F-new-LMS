/*********************************************************************
This the test class for the class "TF_License_Update_Event_Tgr_Cls"
**********************************************************************/

@isTest
global class zTest_TF_License_Update_Event_Tgr {
    static List<Product2> productList = new List<Product2>();
    static List<Case> caseList = new List<Case>();
    static List<Account> accList = new List<Account>();
    static List<License__c> licenseList = new List<License__c>();
    
    public static void setup() {
        
        TF_OrgSpecificProps__c setting = new TF_OrgSpecificProps__c();
        setting.AWS_Region_Name__c                      = 'eu-west-1';
        setting.AWS_SNS_License_Access_Key_Id__c        = 'AKIAIBL26CL3XLPTDEIQ';
        setting.AWS_SNS_License_Secret_Access_key__c    = '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';
        setting.AWS_S3_Host_Url__c                      = '.s3.eu-west-1.amazonaws.com  ';
        setting.AWS_S3_License_Validation_Bucket__c     = 's3-euw1-ap-pe-sf-notifications-d ';
        setting.AWS_SQS_Access_Key_Id__c                = 'AKIAIWLW7TNA5CXZWOAA';
        setting.AWS_SQS_Secret_Access_key__c            = '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';
        setting.AWS_SQS_Host_Url__c                     = 'https://sqs.eu-west-1.amazonaws.com';
        setting.AWS_SQS_Queue_Name__c                   = '/012177264511/sqs-euw1-ap-pe-df-salesforce-license-listener-dev';
        setting.AWS_SNS_License_TopicArn__c             = 'arn:aws:sns:eu-west-1:012177264511:sns-euw1-ap-pe-df-salesforce-license-listener-dev';
        setting.AWS_SNS_Host_Url__c                     = 'https://sns.eu-west-1.amazonaws.com';
        setting.AWS_SNS_License_Region_Name__c          = 'eu-west-1';
        setting.AWS_SNS_License_Host_Url__c             = 'https://sns.eu-west-1.amazonaws.com';
        insert setting;
        
        //Creating List of Account
        accList.add( new Account( Name ='TestAccount1', Type = 'Consortium', Ringgold_Account_ID__c = 'Ringgold Id 1', Customer_Id__c = '12345' ) );
        accList.add( new Account( Name ='TestAccount2', Type = 'Customer', Ringgold_Account_ID__c = 'Ringgold Id 2', Customer_Id__c = '123456' ) );
        insert accList;
        
        //Creating a Product record
        productList.add( new Product2(Name = 'Test_Product1', isActive = true, Hub_Id__c = 'Test Hub Id1'));
        productList.add( new Product2(Name = 'Test_Product2', isActive = true, Hub_Id__c = 'Test Hub Id2'));
        insert productList;

        //Creating standard price book entry
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = productList[0].Id, UnitPrice = 100, IsActive = true);
        insert standardPrice;
        
        //Creating a custom Pricebook
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        //Creating custom price book entry
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = productList[0].Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        //Creating standard price book entry
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = productList[1].Id, UnitPrice = 100, IsActive = true);
        insert standardPrice1;
        
        //Creating a custom Pricebook
        Pricebook2 customPB1 = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB1;
        
        //Creating custom price book entry
        PricebookEntry customPrice1 = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = productList[1].Id, UnitPrice = 12000, IsActive = true);
        insert customPrice1;
        
        //Creating license list        
        licenseList.add( new License__c( Customer__c = accList[0].id, Product__c = productList[0].id, Order_Number__c = 'Test ON1', License_Type__c = 'Perpetual', Update_Type__c = 'Static', Grant_Type__c = 'View; Download', Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'Active' ) );
        licenseList.add( new License__c( Customer__c = accList[1].id, Product__c = productList[1].id, Order_Number__c = 'Test ON2', License_Type__c = 'Subscription', Update_Type__c = 'Static', Grant_Type__c = 'Download', Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'Active' ) );
        licenseList.add( new License__c( Customer__c = accList[0].id, Product__c = productList[0].id, Order_Number__c = 'Test ON3', License_Type__c = 'Subscription', Update_Type__c = 'Static', Grant_Type__c = 'Download', Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'In progress' ) );
        insert licenseList;
        
        //Creating a Case record
        String caseSub = 'License creation or updation failed in Entitlement Hub for license : ' + licenseList[2].id;
        caseList.add(new Case(Status = 'New', Priority = 'Low', Application__c = 'License and Entitlement', Type = 'Outbound Failure', Origin = 'Other', Subject = caseSub));
        insert caseList;
    }
    
    static testMethod void hasPartUpdate_Test() {
        setup();
        
        String requesttBody = '{"header": {},"body": {"product": {"_id": "' + productList[0].Hub_Id__c + '","type": "collection","version": "1.0.18","title": "sdgo goal 1"},"parts": [{"_id": "fd428c4f-edc2-4dcc-9f04-376fa52d8ac3","type": "chapter","version": "1.0.0","position": 1}],"partsAdded": ["fd428c4f-edc2-4dcc-9f04-376fa52d8ac3"],"partsDeleted": [""]}}';
        requesttBody = requesttBody.replace( '_id', 'x_id' );
        requesttBody = requesttBody.replace( 'event-payload-type', 'event_payload_type' );
        requesttBody = requesttBody.replace( 'event-type', 'event_type' );
        requesttBody = requesttBody.replace( 'status-description', 'status_description' );
        TF_HasPartWrapper hasPartRequestt = new TF_HasPartWrapper();
        hasPartRequestt = (TF_HasPartWrapper)System.JSON.deserialize( requesttBody, TF_HasPartWrapper.class);
        System.debug('hasPartRequestt =====>' + hasPartRequestt);
        
        Map<String, String> hubIdToJsonStrMap = new Map<String, String>();
        
        List<TF_HasPartWrapper.licenseDetails> licenseWrapperList = new List<TF_HasPartWrapper.licenseDetails>();
        for ( License__c lic : licenseList ) {
            TF_HasPartWrapper.licenseDetails licenseWrapperRecord = new TF_HasPartWrapper.licenseDetails();
            licenseWrapperRecord.licenseId = lic.id;
            licenseWrapperRecord.partyId = ( ( lic.customer__c != NULL && String.isNotBlank(lic.customer__r.customer_Id__c) ? String.valueOf(lic.customer__r.customer_Id__c) : ( ( lic.contact__c != NULL && String.isNotBlank(lic.contact__r.party_Id__c) ) ? String.valueOf(lic.contact__r.party_Id__c) : '') ) );
            licenseWrapperRecord.access_scope = String.isBlank(lic.Access_Scope__c) ? 'Global' : lic.Access_Scope__c;
            licenseWrapperRecord.status = String.isNotBlank(lic.Status__c) ? lic.Status__c : '';
            licenseWrapperList.add(licenseWrapperRecord);
        }
        
        hasPartRequestt.Body.licenses = licenseWrapperList;
        
        if ( hasPartRequestt.body.product.x_id != NULL ) {
            hubIdToJsonStrMap.put(hasPartRequestt.body.product.x_id, JSON.serialize(hasPartRequestt));
        }
        
        System.debug('hubIdToJsonStrMap =====>' + hubIdToJsonStrMap);
        System.debug('hubIdToJsonStrMap Size =====>' + hubIdToJsonStrMap.size());
        if ( !hubIdToJsonStrMap.isEmpty() ) {
            Test.startTest();
            Test.setMock ( HttpCalloutMock.class, new MockGenerator_Test() );
            TF_License_Update_Event_Tgr_Cls.s3LicenseCalloutAndSNSNotify( hubIdToJsonStrMap );
            Test.stopTest();
        }
    }
    
    static testMethod void hasPartUpdate_Test2() {
        setup();
        
        String requesttBody = '{"header": {},"body": {"product": {"_id": "' + productList[0].Hub_Id__c + '","type": "collection","version": "1.0.18","title": "sdgo goal 1"},"parts": [{"_id": "fd428c4f-edc2-4dcc-9f04-376fa52d8ac3","type": "chapter","version": "1.0.0","position": 1}],"partsAdded": ["fd428c4f-edc2-4dcc-9f04-376fa52d8ac3"],"partsDeleted": [""]}}';
        requesttBody = requesttBody.replace( '_id', 'x_id' );
        requesttBody = requesttBody.replace( 'event-payload-type', 'event_payload_type' );
        requesttBody = requesttBody.replace( 'event-type', 'event_type' );
        requesttBody = requesttBody.replace( 'status-description', 'status_description' );
        TF_HasPartWrapper hasPartRequestt = new TF_HasPartWrapper();
        hasPartRequestt = (TF_HasPartWrapper)System.JSON.deserialize( requesttBody, TF_HasPartWrapper.class);
        System.debug('hasPartRequestt =====>' + hasPartRequestt);
        
        Map<String, String> hubIdToJsonStrMap = new Map<String, String>();
        
        List<TF_HasPartWrapper.licenseDetails> licenseWrapperList = new List<TF_HasPartWrapper.licenseDetails>();
        for ( License__c lic : licenseList ) {
            TF_HasPartWrapper.licenseDetails licenseWrapperRecord = new TF_HasPartWrapper.licenseDetails();
            licenseWrapperRecord.licenseId = lic.id;
            licenseWrapperRecord.partyId = ( ( lic.customer__c != NULL && String.isNotBlank(lic.customer__r.customer_Id__c) ? String.valueOf(lic.customer__r.customer_Id__c) : ( ( lic.contact__c != NULL && String.isNotBlank(lic.contact__r.party_Id__c) ) ? String.valueOf(lic.contact__r.party_Id__c) : '') ) );
            licenseWrapperRecord.access_scope = String.isBlank(lic.Access_Scope__c) ? 'Global' : lic.Access_Scope__c;
            licenseWrapperRecord.status = String.isNotBlank(lic.Status__c) ? lic.Status__c : '';
            licenseWrapperList.add(licenseWrapperRecord);
        }
        
        hasPartRequestt.Body.licenses = licenseWrapperList;
        
        if ( hasPartRequestt.body.product.x_id != NULL ) {
            hubIdToJsonStrMap.put(hasPartRequestt.body.product.x_id, JSON.serialize(hasPartRequestt));
        }
        
        System.debug('hubIdToJsonStrMap =====>' + hubIdToJsonStrMap);
        System.debug('hubIdToJsonStrMap Size =====>' + hubIdToJsonStrMap.size());
        if ( !hubIdToJsonStrMap.isEmpty() ) {
            Test.startTest();
            try {
                TF_License_Update_Event_Tgr_Cls.s3LicenseCalloutAndSNSNotify( hubIdToJsonStrMap );
            } catch ( Exception ex ) {
                System.debug('Exception =====>' + ex.getMessage());
            }
            Test.stopTest();
        }
    }
    
    /*
    static testMethod void LicenseUpdate() {
        setup();
        
        //Create a license platform event     
        List<License_Update_Event__e> license_Update_List = new List<License_Update_Event__e>();
        license_Update_List.add( new License_Update_Event__e( hubID__c = 'Test Hub Id1', Update_Type__c = 'UPDATE_DYNAMIC_LICENSE') );
        license_Update_List.add( new License_Update_Event__e( hubID__c = 'Test Hub Id2', Update_Type__c = 'UPDATE_ALL_LICENSEEEEE') );
        license_Update_List.add( new License_Update_Event__e( hubID__c = 'Test Hub Id2', Update_Type__c = 'UPDATE_ALL_LICENSE') );
        license_Update_List.add( new License_Update_Event__e( hubID__c = '', Update_Type__c = 'UPDATE_ALL_LICENSE') );
        license_Update_List.add( new License_Update_Event__e( hubID__c = 'Test Hub Id2', Update_Type__c = '') );
        
        Test.startTest();
        //Publishing platform event record
        List<Database.SaveResult> results = EventBus.publish(license_Update_List);
        Test.stopTest();
    }
    
    static testMethod void LicenseUpdate1() {
        //setup();
        
        //Create a license platform event     
        List<License_Update_Event__e> license_Update = new List<License_Update_Event__e>();
        license_Update.add( new License_Update_Event__e( hubID__c = 'Test Hub Id1', Update_Type__c = 'UPDATE_ALL_LICENSEEEEE') );
        
        Test.startTest();
        //Publishing platform event record
        List<Database.SaveResult> results = EventBus.publish(license_Update);
        Test.stopTest();
        
        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) 
            {
                System.debug('Successfully published event.');
            } 
            else 
            {
                for(Database.Error err : sr.getErrors())
                {
                    System.debug('Error returned: ' +  err.getStatusCode() + err.getMessage());
                }
            }
        }
     }
     
    static testMethod void LicenseUpdate3() {
    setup();
    
    //Create a license platform event     
    List<License_Update_Event__e> license_Update = new List<License_Update_Event__e>();
    license_Update.add( new License_Update_Event__e( hubID__c = '', Update_Type__c = 'UPDATE_ALL_LICENSE') );
    
    Test.startTest();
    //Publishing platform event record
    List<Database.SaveResult> results = EventBus.publish(license_Update);
    Test.stopTest();
        
     for (Database.SaveResult sr : results) {
         if (sr.isSuccess()) 
            {
              System.debug('Successfully published event.');
            } 
         else 
            {
               for(Database.Error err : sr.getErrors())
               {
               System.debug('Error returned: ' +  err.getStatusCode() + err.getMessage());
               }
            }
         }
     }
     
    static testMethod void LicenseUpdate4() {
        setup();
        
        //Create a license platform event     
        List<License_Update_Event__e> license_Update = new List<License_Update_Event__e>();
        license_Update.add( new License_Update_Event__e( hubID__c = 'Test Hub Id1', Update_Type__c = '') );
    
        Test.startTest();
        //Publishing platform event record
        List<Database.SaveResult> results = EventBus.publish(license_Update);
        Test.stopTest();
        
        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) 
            {
                System.debug('Successfully published event.');
            } 
            else 
            {
                for(Database.Error err : sr.getErrors())
                {
                    System.debug('Error returned: ' +  err.getStatusCode() + err.getMessage());
                }
            }
        }
    }
    */
    
    //class to create a mock response
    global class MockGenerator_Test implements HttpCalloutMock {
        global HttpResponse respond ( HTTPRequest  req ) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setStatus('OK');
            res.setBody('{"header": {},"body": {"product": {"_id": "' + productList[0].Hub_Id__c + '","type": "collection","version": "1.0.18","title": "sdgo goal 1"},"parts": [{"_id": "fd428c4f-edc2-4dcc-9f04-376fa52d8ac3","type": "chapter","version": "1.0.0","position": 1}],"partsAdded": ["fd428c4f-edc2-4dcc-9f04-376fa52d8ac3"],"partsDeleted": [""]}}');
            return res;
        }
    }
}