/**********************************************************************
//This is test class for Lightning controller 'TF_POFLicenseController'

***********************************************************************/

@isTest
global class zTest_TF_POFLicenseController {
    public static Account a;
    public static Account a2;
    public static Account a3;
    public static List<License__c> licenseRecordList;
    //public static License__c licenseRecord1;
    //public static License__c licenseRecord2;
    public static List<License_Memeber__c> licMemberList;
    public static TandF_Account_to_Consortium__c accToConsortiumRecord;
    public static List<Id> accIdList = new List<Id>();
    public static List<Account> accList = new List<Account>();
    public static Contact con  = new Contact();
    
    public static void setup() {
        // Created a account record
        a = new Account();
        a.Name = 'Test Acc1';
        a.Type = 'Consortium';
        a.Customer_Id__c = '123456';
        insert a;
        
        a2 = new Account();
        a2.Name = 'Test Acc2';
        a2.Type = 'Customer';
        a2.Customer_Id__c = 'Test Customer_Id';
        insert a2;
        
        a3 = new Account();
        a3.Name = 'Test Acc3';
        a3.Type = 'Customer';
        a3.Customer_Id__c = 'fgrfgfhttjttjsaa';
        insert a3;
        
        con.LastName = 'Test';
        con.Email = 'test@test.com';
        con.Party_Id__c = '100';
        con.AccountId = a.id;
        insert con;
        
        accIdList.add( a.id );
        accIdList.add( a2.id );
        accIdList.add( a3.id );
        
        //Created a product record
        Product2 p = new Product2();
        p.Name = 'test_pro';
        p.IsActive = true;
        p.Hub_Id__c = '9999999999';
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
        
        Id licenseAccRecordTypeId = Schema.SObjectType.License__c.getRecordTypeInfosByName().get('T&F Account License').getRecordTypeId();
        Id licenseConRecordTypeId = Schema.SObjectType.License__c.getRecordTypeInfosByName().get('T&F Individual License').getRecordTypeId();
        
        //Creating License record list
        licenseRecordList = new List<License__c>();
        licenseRecordList.add( new License__c( RecordTypeId = licenseAccRecordTypeId, Customer__c = a.id, Product__c = p.id, Order_Number__c = 'Test ON', License_Type__c = 'Perpetual', Grant_Type__c = 'View; Download', Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'Active' ) );
        licenseRecordList.add( new License__c( RecordTypeId = licenseAccRecordTypeId, Customer__c = a2.id, Product__c = p.id, Order_Number__c = 'Test ON', License_Type__c = 'Subscription', Grant_Type__c = 'View', Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(3), Purchase_Date__c = Date.today(), Status__c = 'Active' ) );
        licenseRecordList.add( new License__c( RecordTypeId = licenseAccRecordTypeId, Customer__c = a3.id, Product__c = p.id, Order_Number__c = 'Test OFF', License_Type__c = 'Trial', Grant_Type__c = 'View', Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(3), Purchase_Date__c = Date.today(), Status__c = 'Active' ) );
        licenseRecordList.add( new License__c( RecordTypeId = licenseAccRecordTypeId, Customer__c = a.id, Product__c = p.id, Order_Number__c = 'Test Order_Number', License_Type__c = 'Perpetual', Grant_Type__c = 'View', Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(3), Purchase_Date__c = Date.today(), Status__c = 'Active' ) );
        insert licenseRecordList;
        
        
        //Creating license Member list
        licMemberList = new List<License_Memeber__c>();
        licMemberList.add( new License_Memeber__c( Account__c = a.id, License__c = licenseRecordList[0].id ) );
        licMemberList.add( new License_Memeber__c( Account__c = a2.id, License__c = licenseRecordList[1].id ) );
        licMemberList.add( new License_Memeber__c( Account__c = a3.id, License__c = licenseRecordList[2].id ) );
        insert licMemberList;
        
        //Creating consortium member record
        accToConsortiumRecord = new TandF_Account_to_Consortium__c(Consortium_Member__c = a2.id, ConsortiumParent__c = a.id);
        insert accToConsortiumRecord;
    }
    
    //test method to cover lightning controller 'TF_POFLicenseController'
    static testMethod void consortiumMemebrs_Test() {
        try {
            setup();
        } catch ( Exception e ) {
            System.debug('*********** Inside consortiumMemebrs_Test **********');
            System.debug('Exception ===========>' + e);
        }
        TF_POFLicenseController.getConsortiumMemebrs(licenseRecordList[0].id);
        TF_POFLicenseController.updateConsortiumMemebers(licenseRecordList[0].id, accIdList);
    }
    
    //method to cover if-else part of TF_POFLicenseController.updateConsortiumMemebers
    static testMethod void consortiumMemebrs_Test2() {
        try {
            setup();
        } catch ( Exception e ) {
            System.debug('****************Inside consortiumMemebrs_Test2 ***********');
            System.debug('Exception ===========>' + e);
        }
        //accIdList.clear();
        //TF_POFLicenseController.updateConsortiumMemebers(licenseRecordList[0].id, accIdList);
        TF_POFLicenseController.fetchAccountDetailForLicense( accIdList[0] );
        TF_POFLicenseController.getConsortiumMembersForAccount( accIdList[0] );
    }
    
    //method to cover if-else part of TF_POFLicenseController.updateConsortiumMemebers
    static testMethod void consortiumMemebrs_Test3() {
        try {
            setup();
        } catch ( Exception e ) {
            System.debug('**************Inside consortiumMemebrs_Test3*****');
            System.debug('Exception ===========>' + e);
        }
        List<License_Memeber__c> licMemberDelList = new List<License_Memeber__c>();
        
        for ( License_Memeber__c licMember : licMemberList ) {
            licMemberDelList.add( licMember );
        }
        Delete licMemberDelList;
        
        TF_POFLicenseController.updateConsortiumMemebers(licenseRecordList[0].id, accIdList);
    }
    
    //method to cover if-else part of TF_POFLicenseController.updateConsortiumMemebers
    static testMethod void consortiumMemebrs_Test4() {
        try {
            setup();
        } catch ( Exception e ) {
            System.debug('***********Inside consortiumMemebrs_Test4***********');
            System.debug('Exception ===========>' + e);
        }
        accIdList.remove(1);
        
        List<License_Memeber__c> licMemberDelList = new List<License_Memeber__c>();
        for ( License_Memeber__c licMember : licMemberList ) {
            licMemberDelList.add( licMember );
        }
        Delete licMemberDelList;
        List<License_Memeber__c> licMemList = new List<License_Memeber__c> ();
        licMemList.add( new License_Memeber__c ( Account__c = a2.id, License__c = licenseRecordList[0].id ) );
        licMemList.add( new License_Memeber__c ( Account__c = a2.id, License__c = licenseRecordList[0].id ) );
        insert licMemList;
        TF_POFLicenseController.updateConsortiumMemebers(licenseRecordList[0].id, accIdList);
        //TF_POFLicenseController.isUbxAccResponse(accIdList[0]);
    }
    
    //method to show validation error for customer Id
    static testMethod void consortiumMemebrs_Test5 () {
        try {
            setup();
        } catch ( Exception e ) {
            System.debug('***********Inside consortiumMemebrs_Test5 ***********');
            System.debug('Exception ===========>' + e);
        }
        accIdList.clear();
        
        //updating customer id of acount as blank
        a2.Customer_Id__c = '';
        update a2;
        
        accIdList.add( a2.id );
        TF_POFLicenseController.updateConsortiumMemebers(licenseRecordList[3].id, accIdList);
    }
    
    //Method to cover Account Customer Id
    static testMethod void accountCustomerId_Test6() {
        try {
            setup();
        } catch ( Exception e ) {
            System.debug('Exception========>'+ e );
        }
        TF_POFLicenseController.updateAccountPartyIdForLicense(a.id);
        }
    
    static testMethod void consortiumMemebrs_Test7 () {
        Account accInsert = new Account();
        try {
            setup();
            accInsert.Name = 'Test Acc1';
            accInsert.Type = 'Consortium';
            insert accInsert;
        } catch ( Exception e ) {
            System.debug('***********Inside consortiumMemebrs_Test6 ***********');
            System.debug('Exception ===========>' + e);
        }
        String accIdString = '';
        
        for ( Id accId : accIdList ) {
            accIdString += '"' + accId + '"' + ',';
        }
        accIdString.removeEnd(',');
        accIdString = '[' + accIdString + ']';
        //accIdString = '{"2":[{0011l000009UvIfAAK, 0011l00000BP2vxAAD, 0011l000002TqkzAAC}]"}';
        //TF_POFLicenseController.updateStringConsortiumMemebers( licenseRecordList[0].id, accIdString );
        TF_POFLicenseController.fetchContactDetailForLicense( con.id );
        TF_POFLicenseController.updateContactPartyIdForLicense( con.id, 'test@test.com' );
        TF_POFLicenseController.getRecordTypeId( 'License__c', 'T&F Individual License' );
        //accIdString = '{"2":"0011l000009UvIfAAK,0011l00000BP2vxAAD,0011l000002TqkzAAC"}';
        //TF_POFLicenseController.updateStringConsortiumMemebers( licenseRecordList[0].id, accIdString );
        TF_POFLicenseController.isUbxAccResponse( accInsert.id );
        TF_POFLicenseController.isUbxAccResponse( accIdList[0] );
    }
}