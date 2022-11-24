/**********************************************************************
//This is test class for class "TF_EntitlementRetryFramework"

***********************************************************************/

@isTest
global class ztest_TF_EntitlementRetryFramework {
    static List<Account> accList = new List<Account>();
    static List<Case> caseList = new List<Case>();
    static Product2 p;
    //static Opportunity opp;
    static OpportunityLineItem oli;
    static final String baseUrl = Url.getSalesforceBaseUrl().toExternalForm();
    static List<License__c> licenseList = new List<License__c>();
    static List<Exception_Log__c> exceptonLogList = new List<Exception_Log__c>();
    static Map<Id, License__c> licenseIdToLicensMap = new Map<Id, License__c>();
    static Map<Id, Exception_Log__c> licenseInsrtB2BCheckMap = new Map<Id, Exception_Log__c>();
    static Map<Id, Exception_Log__c> licenseInsrtConsortiumCheckMap = new Map<Id, Exception_Log__c>();
    static Map<Id, Exception_Log__c> licenseMemberInsertCheckMap = new Map<Id, Exception_Log__c>();
    static Map<Id, Exception_Log__c> licenseUpdateCheckMap = new Map<Id, Exception_Log__c>();
    static Map<Id, Exception_Log__c> entitlementInboundMap = new Map<Id, Exception_Log__c>();
    static Map<Exception_Log__c, Id> licenseMemberUpdateCheckMap = new Map<Exception_Log__c, Id>();
    static Map<Id, Exception_Log__c> entitlementInboundUpdateMap = new Map<Id, Exception_Log__c>();
    
    public static void setup () {
        Id caseInternalSupportRTId = [ SELECT id FROM RecordType WHERE sObjectType = 'Case' AND Name = 'Salesforce Internal Support' ].id;
        TriggerInterfaceHelper.runTrigger('TF_ExceptionResolvedCase_Tgr', 'Case', 1, 'au', caseInternalSupportRTId, null); 
        
        //insert custom setting
        TF_OrgSpecificProps__c tf_OrgSpecificProps = new TF_OrgSpecificProps__c();
        tf_OrgSpecificProps.AWS_Region_Name__c              = 'eu-west-1';
        tf_OrgSpecificProps.AWS_SQS_Access_Key_Id__c        = 'AKIAIWLW7TNA5CXZWOAA';
        tf_OrgSpecificProps.AWS_SQS_Secret_Access_key__c    = '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';
        tf_OrgSpecificProps.AWS_SQS_Host_Url__c             = 'https://sqs.eu-west-1.amazonaws.com';
        tf_OrgSpecificProps.AWS_SQS_Queue_Name__c           = '/012177264511/sqs-euw1-ap-pe-df-salesforce-license-listener-dev';
        insert tf_OrgSpecificProps;
        
        //Creating List of Account
        accList.add( new Account( Name ='TestAccount1', Type = 'Consortium', Ringgold_Account_ID__c = 'Ringgold Id 1', customer_Id__c = '12345' ) );
        accList.add( new Account( Name ='TestAccount2', Type = 'Customer', Ringgold_Account_ID__c = 'Ringgold Id 2', customer_Id__c = '123456' ) );
        insert accList;
        
        //Creating list of case
        caseList.add( new Case( RecordTypeId = caseInternalSupportRTId, Status = 'New', Priority = 'Low', Application__c = 'License and Entitlement', Type = 'Outbound Failure', Origin = 'Other', Subject = 'License creation or updation failed in Entitlement Hub for license', Description = 'An error occurred in License record. Error message: Bad Request' ) );
        caseList.add( new Case( RecordTypeId = caseInternalSupportRTId, Status = 'New', Priority = 'Low', Application__c = 'License and Entitlement', Type = 'Inbound Failure', Origin = 'Other', Subject = 'License creation or updation failed in Entitlement Hub for license', Description = 'An error occurred in License record. Error message: Bad Request' ) );
        caseList.add( new Case( RecordTypeId = caseInternalSupportRTId, Status = 'New', Priority = 'Low', Application__c = 'Opportunity To OrderHub Integration', Type = 'Outbound Failure', Origin = 'Other', Subject = 'Closed Won Opportunity failed to create Order in Order Hub', Description = 'An error occurred in Opportunity record. Error message: Bad Request' ) );
        caseList.add( new Case( RecordTypeId = caseInternalSupportRTId, Status = 'New', Priority = 'Low', Application__c = 'License and Entitlement', Type = 'Outbound Failure', Origin = 'Other', Subject = 'License creation or updation failed in Entitlement Hub for license', Description = 'An error occurred in License record. Error message: Bad Request' ) );
        caseList.add( new Case( RecordTypeId = caseInternalSupportRTId, Status = 'New', Priority = 'Low', Application__c = 'License and Entitlement', Type = 'Inbound Failure', Origin = 'Other', Subject = 'License creation or updation failed in Entitlement Hub for license', Description = 'An error occurred in License record. Error message: Bad Request' ) );
        insert caseList;
        
        //Create a Product record
        p = new Product2();
        p.Name = 'Test_Pro';
        p.isActive = true;
        p.Hub_Id__c = 'Hub Id 9999999999';
        p.Family = 'UNSDG';
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
        
        
        //Creating Opportunity record
        /*opp = new Opportunity();
        Id Record_type_id = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F - eBooks Opportunity').getRecordTypeId(); //T&F - Journals Opportunity
        opp.Name = 'test2';
        opp.RecordTypeId = Record_type_id;
        opp.Start_Date__c = Date.today();
        opp.End_Date__c = Date.today();
        opp.StageName = 'Investigating'; //Investigating
        opp.CloseDate = System.today().addDays(9);
        opp.Type ='Renewal';
        opp.LeadSource = 'Direct';
        opp.Volume_Year__c = 'a' ;
        opp.AccountId = accList[0].Id;        
        insert opp;
        
        //Creating Opportunity Line item
        oli = new OpportunityLineItem();
        oli.OpportunityId = opp.Id;
        oli.Product2Id = p.Id;
        oli.Quantity = 12;
        oli.UnitPrice = 67;
        oli.PriceBookEntryId = customPrice.id;
        insert oli;*/
        
        //Creating license list        
        licenseList.add( new License__c( Customer__c = accList[0].id, Product__c = p.id, Order_Number__c = 'Test ON', License_Type__c = 'Perpetual', Grant_Type__c = 'View; Download', Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'Active' ) );
        licenseList.add( new License__c( Customer__c = accList[1].id, Product__c = p.id, Order_Number__c = 'Test ON2', License_Type__c = 'Subscription', Grant_Type__c = 'Download', Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'Active' ) );
        insert licenseList;
        
        //creating map of license id and license record
        for ( License__c lic : licenseList ) {
            licenseIdToLicensMap.put( lic.id, lic );
        }
        
        //Creating license Member list
        List<License_Memeber__c> licMemberList = new List<License_Memeber__c>();
        licMemberList.add( new License_Memeber__c( Account__c = accList[0].id, License__c = licenseList[0].id ) );
        licMemberList.add( new License_Memeber__c( Account__c = accList[0].id, License__c = licenseList[0].id ) );
        insert licMemberList;
        
        /*//Creating Account to Opportunity record
        List<Account_To_Opportunity__c> accToOppList = new List<Account_To_Opportunity__c>();
        //accToOppList.add( new Account_To_Opportunity__c( Account__c = accList[0].id, Opportunity__c = opp.id ) );
        //accToOppList.add( new Account_To_Opportunity__c( Account__c = accList[1].id, Opportunity__c = opp.id ) );
        insert accToOppList;*/
        
        //Creating list of exception log
        exceptonLogList.add( new Exception_Log__c( Case__c = caseList[0].id, Object_ID__c = licenseList[0].id, Object_Type__c = 'License', Error_Type__c = 'Outbound', Error_message__c = 'Bad Request', Type_of_Action__c = 'Insert', Request_JSON__c = '{"type":"AddLicense","status":"Active","startDate":"2019-01-01","salesforceAccountID":"0011l000003cePLAAY","ringgoldID":"","removeMember":[],"productId":"Test Hub Id","orderNumber":"Test Order Number from Postman on dated 23/11/18","licenseType":"Perpetual","licenseId":"'+licenseList[0].id+'","grantType":["View","Download"],"endDate":"2019-01-02","customerType":"Consortium","addMember":[{"salesforceAccountID":"'+accList[0].id+'","ringgoldID":"12345"}]}', Resolution_Status__c = 'New' ) );
        exceptonLogList.add( new Exception_Log__c( Case__c = caseList[0].id, Object_ID__c = licenseList[0].id, Object_Type__c = 'License', Error_Type__c = 'Outbound', Error_message__c = 'Bad Request', Type_of_Action__c = 'Insert', Request_JSON__c = '{"type":"AddLicense","status":"Active","startDate":"2019-01-01","salesforceAccountID":"0011l0000039R0gAAE","ringgoldID":"Test_Account_Ringgold","removeMember":[],"productId":"Test Hub Id","orderNumber":"Test Order Number from Postman on dated 23/11/18","licenseType":"Perpetual","licenseId":"'+licenseList[0].id+'","grantType":["View","Download"],"endDate":"2019-01-02","customerType":"B2B","addMember":[]}', Resolution_Status__c = 'New' ) );
        exceptonLogList.add( new Exception_Log__c( Case__c = caseList[0].id, Object_ID__c = licenseList[0].id, Object_Type__c = 'License', Error_Type__c = 'Outbound', Error_message__c = 'Bad Request', Type_of_Action__c = 'Insert', Request_JSON__c = '{"type":"UpdateLicense","status":"Active","startDate":"2019-01-01","salesforceAccountID":"0011l000003cePLAAY","ringgoldID":"","removeMember":[],"productId":"Test Hub Id","orderNumber":"Test Order Number from Postman on dated 23/11/18","licenseType":"Subscription","licenseId":"'+licenseList[0].id+'","grantType":["View","Download"],"endDate":"2019-01-02","customerType":"Consortium","addMember":[{"salesforceAccountID":"'+accList[0].id+'","ringgoldID":""}]}', Resolution_Status__c = 'New' ) );
        exceptonLogList.add( new Exception_Log__c( Case__c = caseList[0].id, Object_ID__c = licenseList[1].id, Object_Type__c = 'License', Error_Type__c = 'Outbound', Error_message__c = 'Bad Request', Type_of_Action__c = 'Update', Request_JSON__c = '{"type":"UpdateLicense","status":"Active","startDate":"2019-01-01","salesforceAccountID":"0011l0000039R0gAAE","ringgoldID":"Test_Account_Ringgold","removeMember":[],"productId":"Test Hub Id","orderNumber":"Test Order Number from Postman on dated 23/11/18","licenseType":"Perpetual","licenseId":"'+licenseList[1].id+'","grantType":["View","Download"],"endDate":"2019-01-02","customerType":"B2B","addMember":[]}', Resolution_Status__c = 'New' ) );
        exceptonLogList.add( new Exception_Log__c( Case__c = caseList[0].id, Object_ID__c = licenseList[0].id, Object_Type__c = 'License', Error_Type__c = 'Outbound', Error_message__c = 'Bad Request', Type_of_Action__c = 'Update', Request_JSON__c = '{"type":"UpdateLicense","status":"Active","startDate":"2019-01-01","salesforceAccountID":"0011l000003cePLAAY","ringgoldID":"","removeMember":[{"salesforceAccountID":"0011l000002TqkzAAC","ringgoldID":"12345"}],"productId":"Test Hub Id","orderNumber":"Test Order Number from Postman on dated 23/11/18","licenseType":"Subscription","licenseId":"'+licenseList[0].id+'","grantType":["View","Download"],"endDate":"2019-01-02","customerType":"Consortium","addMember":[]}', Resolution_Status__c = 'New' ) );
        exceptonLogList.add( new Exception_Log__c( Case__c = caseList[1].id, Object_ID__c = licenseList[0].id, Object_Type__c = 'License', Error_Type__c = 'Inbound', Error_message__c = 'Bad Request', Type_of_Action__c = 'Update', Request_JSON__c = '{"licenseID" : "'+licenseList[0].id+'",  "status" : "created",  "message" : "Test message from test class"}', Resolution_Status__c = 'New' ) );
        exceptonLogList.add( new Exception_Log__c( Case__c = caseList[1].id, Object_ID__c = licenseList[0].id, Object_Type__c = 'License', Error_Type__c = 'Inbound', Error_message__c = 'Bad Request', Type_of_Action__c = 'Insert', Request_JSON__c = '{"licenseID" : "'+licenseList[0].id+'",  "status" : "created",  "message" : "Test message from test class"}', Resolution_Status__c = 'New' ) );
        //exceptonLogList.add( new Exception_Log__c( Case__c = caseList[2].id, Object_ID__c = opp.id, Object_Type__c = 'Opportunity', Error_Type__c = 'Outbound', Error_message__c = 'Bad Request', Type_of_Action__c = 'Update', Request_JSON__c = '{"seller":"TANDF","orderType":"SALES","orderStatus":"PLACED","orderedItem":[{"sellingPrice":200.00,"quantity":1,"productId":"'+p.Hub_Id__c+'","price":200.00,"orderedQuantity":1,"lineItemType":"UNSDG","fulfillment":{"termStartDate":"2018-12-03","termEndDate":"2018-11-28","name":"Fulfillment for Subscription license","licenseType":"Subscription","grantType":[],"description":"Fulfillment for Subscription license","bundle":"UNSDGO JAN2019"},"currency":"USD"}],"opportunityId":"'+opp.id+'","customerId":"'+accList[0].Id+'","channel":"SFDC","billingAddress":{"streetAddress":"","postalCode":"2010178","addressRegion":"Goa","addressOrganisation":"","addressLocality":"dfgh","addressLine3":"","addressLine2":"","addressLine1":"abcd","addressId":"","addressCountry":"India","addressContactName":"","addressContactEmail":""}}', Resolution_Status__c = 'New' ) );
        exceptonLogList.add( new Exception_Log__c( Case__c = caseList[3].id, Object_ID__c = licenseList[0].id, Object_Type__c = 'Platform Event', Error_Type__c = 'Outbound', Error_message__c = '400 Bad Request : SenderAWS.SimpleQueueService.NonExistentQueueThe specified queue does not exist for this wsdl version.1d3e2856-735a-5bfb-a6c2-7c981dfb389f', Type_of_Action__c = 'Update', Request_JSON__c = '{"type":"HasPartUpdate","licenseIds":["'+licenseList[0].id+','+licenseList[1].id+'"]}', Resolution_Status__c = 'New' ) );
        exceptonLogList.add( new Exception_Log__c( Case__c = caseList[3].id, Object_ID__c = licenseList[0].id, Object_Type__c = 'Platform Event', Error_Type__c = 'Outbound', Error_message__c = '400 Bad Request : SenderAWS.SimpleQueueService.NonExistentQueueThe specified queue does not exist for this wsdl version.1d3e2856-735a-5bfb-a6c2-7c981dfb389f', Type_of_Action__c = 'Update', Request_JSON__c = '{"type":"HasPartUpdate","licenseIds":["'+licenseList[0].id+'"]}', Resolution_Status__c = 'New' ) );
        exceptonLogList.add( new Exception_Log__c( Case__c = caseList[4].id, Object_ID__c = licenseList[0].id, Object_Type__c = 'Platform Event', Error_Type__c = 'Inbound', Error_message__c = '400 Bad Request : SenderAWS.SimpleQueueService.NonExistentQueueThe specified queue does not exist for this wsdl version.1d3e2856-735a-5bfb-a6c2-7c981dfb389f', Type_of_Action__c = 'Update', Request_JSON__c = '{"Type":"HasPartUpdate","status":"failed","message":"not found","licenseID":"'+licenseList[0].id+'"}', Resolution_Status__c = 'New' ) );
        exceptonLogList.add( new Exception_Log__c( Case__c = caseList[4].id, Object_ID__c = licenseList[0].id, Object_Type__c = 'Platform Event', Error_Type__c = 'Inbound', Error_message__c = '400 Bad Request : SenderAWS.SimpleQueueService.NonExistentQueueThe specified queue does not exist for this wsdl version.1d3e2856-735a-5bfb-a6c2-7c981dfb389f', Type_of_Action__c = 'Update', Request_JSON__c = '{"Type":"HasPartUpdate","status":"failed","message":"not found","licenseID":"'+licenseList[1].id+'"}', Resolution_Status__c = 'New' ) );
        exceptonLogList.add( new Exception_Log__c( Case__c = caseList[1].id, Object_ID__c = licenseList[1].id, Object_Type__c = 'License', Error_Type__c = 'Inbound', Error_message__c = '400 Bad Request', Type_of_Action__c = 'Update', Request_JSON__c = '{"Type":"UpdateLicense","status":"failed","message":"not found","licenseID":"'+licenseList[1].id+'"}', Resolution_Status__c = 'New' ) );
        insert exceptonLogList;
        
        for ( Exception_Log__c excptn : exceptonLogList ) {
            if ( excptn.Object_ID__c.startsWith( License__c.sobjecttype.getDescribe().getKeyPrefix() ) ) {
                licenseInsrtB2BCheckMap.put( excptn.Object_ID__c, excptn );
                licenseMemberUpdateCheckMap.put( excptn, excptn.Object_ID__c );
            }
        }
    }
    
    public  static testMethod void outBound_Test () {
        setup();
        caseList[0].status = 'Closed - Completed';
        
        Test.startTest();
        Test.setMock ( HttpCalloutMock.class, new MockGenerator_Test() );
        update caseList[0];
        System.enqueueJob( new TF_AsyncLicenseUpdateQueueable( licenseIdToLicensMap, licenseMemberInsertCheckMap, licenseUpdateCheckMap, licenseInsrtB2BCheckMap, licenseMemberUpdateCheckMap, entitlementInboundUpdateMap ) );
        Test.stopTest();
        
        System.debug('caseList[0] ==========>' + caseList[0]);
    }
    
    public  static testMethod void inBound_Test () {
        setup();
        //caseList[1].status = 'Closed';
        caseList[1].status = 'Closed - Completed';
        entitlementInboundUpdateMap.put( exceptonLogList[11].Object_ID__c, exceptonLogList[11] );
        System.debug('entitlementInboundUpdateMap Test class ===========>' + entitlementInboundUpdateMap);
        
        Test.startTest();
        Test.setMock ( HttpCalloutMock.class, new MockGenerator_Test() );
        update caseList[1];
        System.enqueueJob( new TF_AsyncLicenseUpdateQueueable( licenseIdToLicensMap, licenseMemberInsertCheckMap, licenseUpdateCheckMap, licenseInsrtB2BCheckMap, licenseMemberUpdateCheckMap, entitlementInboundUpdateMap ) );
        Test.stopTest();
    }
    
    public  static testMethod void licenseB2B_Test () {
        setup();
        Test.startTest();
        System.enqueueJob( new TF_AsyncLicenseB2BInsertQueueable( licenseIdToLicensMap, licenseInsrtB2BCheckMap, licenseInsrtB2BCheckMap, licenseInsrtB2BCheckMap, licenseInsrtB2BCheckMap, licenseInsrtB2BCheckMap, licenseMemberUpdateCheckMap, entitlementInboundUpdateMap ) );
        System.enqueueJob( new TF_AsyncLicenseConsortiumInsertQueueable( licenseIdToLicensMap, licenseInsrtB2BCheckMap, licenseInsrtB2BCheckMap, licenseInsrtB2BCheckMap, licenseInsrtB2BCheckMap, licenseMemberUpdateCheckMap, entitlementInboundUpdateMap ) );
        System.enqueueJob( new TF_AsyncLicenseMemberInsertQueueable( licenseIdToLicensMap, licenseInsrtB2BCheckMap, licenseInsrtB2BCheckMap, licenseInsrtB2BCheckMap, licenseMemberUpdateCheckMap, entitlementInboundUpdateMap ) );
        System.enqueueJob( new TF_AsyncLicenseUpdateQueueable( licenseIdToLicensMap, licenseInsrtB2BCheckMap, licenseInsrtB2BCheckMap, licenseInsrtB2BCheckMap, licenseMemberUpdateCheckMap, entitlementInboundUpdateMap ) );
        System.enqueueJob( new TF_AsyncLicenseMemberUpdateQueueable( licenseIdToLicensMap, licenseMemberUpdateCheckMap ) );
        Test.stopTest();
    }
    
    public static testMethod void hasPart_Test () {
        setup();
        caseList[3].status = 'Closed - Completed';
        
        Test.startTest();
        Test.setMock ( HttpCalloutMock.class, new MockGenerator_Test() );
        update caseList[3];
        Test.stopTest();
    }
    
    public static testMethod void hasPart_Inbound_Test () {
        setup();
        caseList[4].status = 'Closed - Completed';
        
        Test.startTest();
        Test.setMock ( HttpCalloutMock.class, new MockGenerator_Test() );
        update caseList[4];
        Test.stopTest();
    }
    
    /*public  static testMethod void oppClosedWon_Test () {
        setup();
        System.debug('caseList[2].id =========>' + caseList[2].id);
        
        opp.StageName = 'Closed Won';
        opp.Renewal_Method__c = 'Direct';
        opp.Grant_Type__c = 'View; Download';
        update opp;
        
        Case casse = new Case( id = caseList[2].id, Status = 'Closed' );
        System.debug('casse.id =========>' + casse.id);
        
        Test.startTest();
        Test.setMock ( HttpCalloutMock.class, new MockGenerator_Test() );
        update casse;
        Test.stopTest();
    }*/
    
    //class to create a mock response
    global class MockGenerator_Test implements HttpCalloutMock {
        global HttpResponse respond ( HTTPRequest  req ) {

            //System.assertEquals('POST', req.getMethod());

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setStatus('OK');
            res.setBody('GREAT RESPONSE');
            
            return res;
        }
    }
}