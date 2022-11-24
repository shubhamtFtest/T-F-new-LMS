//This is the test class of the Batch class : TF_LicenseStaticBatch

@isTest
global class zTEST_TF_LicenseStaticBatch {
    static testMethod void LicenseStaticBatch_Test () {

        //Created Account records
        List<Account> accList = new List<Account>();
        accList.add(new Account(Name = 'Test1', Type = 'Customer', Ringgold_Account_ID__c = '12345', Customer_Id__c = '11111'));
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
        
        //Created  a license list    
        List<License__c> licenseList = new List<License__c>();
        licenseList.add( new License__c( License_Type__c = 'Subscription', Dynamic_License_End_Date__c = Date.today().addDays(-1), Update_Type__c = 'Dynamic', Status__c = 'Active', Order_Number__c = 'Order1', Product__c = p.id, End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today().addDays(4), Customer__c = accList[0].id, Start_Date__c =  Date.today(), Grant_Type__c = 'View'));
        licenseList.add( new License__c( License_Type__c = 'Trial', Dynamic_License_End_Date__c = Date.today().addDays(-1), Update_Type__c = 'Dynamic', Status__c = 'Active', Order_Number__c = 'Order2', Product__c = p.id, End_Date__c = Date.today().addDays(5), Purchase_Date__c = Date.today().addDays(3), Customer__c = accList[0].id, Start_Date__c =  Date.today(), Grant_Type__c = 'Download' ));
        insert licenseList;
        
        Test.startTest();
        TF_LicenseStaticBatch license_Static_Batch = new TF_LicenseStaticBatch();
        Database.executeBatch(license_Static_Batch,200);
        Test.stopTest();
    }
}