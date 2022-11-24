/**********************************************************************
//This is test class for controller "TF_LicenseAlertPageExtension"

***********************************************************************/

@isTest
global class zTest_TF_LicenseAlertPageExtension {
    public static List<License__c> licenseList = new List<License__c>();
    public static Account a = new Account();
    public static Product2 p = new Product2();

    public static void setup() {
        // Created a account record  
        a.Name = 'test_acc';
        a.Type = 'Consortium';
        a.Ringgold_Account_ID__c = 'Ringgold Id 1';
        a.Customer_Id__c = 'Customer_Account_Id_1';
        insert a;
        
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
        
        //Creating license list        
        licenseList.add( new License__c( Customer__c = a.id, Product__c = p.id, Order_Number__c = 'Test ON', License_Type__c = 'Perpetual', Grant_Type__c = 'View; Download', Start_Date__c = Date.today().addDays(1), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'In progress' ) );
        licenseList.add( new License__c( Customer__c = a.id, Product__c = p.id, Order_Number__c = 'Test ON2', License_Type__c = 'Subscription', Grant_Type__c = 'Download', Start_Date__c = Date.today().addDays(1), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'In progress' ) );
        licenseList.add( new License__c( Customer__c = a.id, Product__c = p.id, Order_Number__c = 'Test ON3', License_Type__c = 'Perpetual', Grant_Type__c = 'Download', Start_Date__c = Date.today().addDays(1), End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today(), Status__c = 'Active', Update_Type__c = 'Static', Dynamic_License_End_Date__c = Date.today().addDays(5) ) );
        insert licenseList;
    }
    
    static testMethod void TF_LicenseAlertPage_Test() {
        setup();
        TriggerInterfaceHelper.runTrigger('TF_CreateLicenseJSON_Tgr', 'License__c', 1, 'bu,ai,au', null, null); 
        
        Test.startTest();
        License__c licUpdate = new License__c();
        licUpdate.id = licenseList[2].id;
        licUpdate.Dynamic_License_End_Date__c = Date.today().addDays(10);
        update licUpdate;
        ApexPages.StandardController sc = new ApexPages.StandardController(licenseList[2]);
        TF_LicenseAlertPageExtension controller = new TF_LicenseAlertPageExtension(sc);
        PageReference pageRef = Page.LicenseAlertPage;
        Test.setCurrentPage(pageRef);
        controller.stopLicenseAlert();
        Test.stopTest();
    }
}