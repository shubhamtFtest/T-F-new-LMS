//zTEST_TF_LicenseEmailBatch
//This is the test class of the Batch class : TF_LicenseEmailBatch

@isTest
global class zTEST_TF_LicenseEmailBatch {
    static testMethod void LicenseEmailBatch_Test () {
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
        
        DateTime nowTime = DateTime.now().addDays(-1).addhours(-8);
        //Created  a license list    
        List<License__c> licenseList = new List<License__c>();
        //licenseList.add( new License__c( License_Type__c = 'Subscription', Update_Type__c = 'Static', Status__c = 'Active', Order_Number__c = 'Order1', Product__c = p.id, End_Date__c = Date.today().addDays(-1), Purchase_Date__c = Date.today().addDays(4), Customer__c = accList[0].id, Start_Date__c =  Date.today().addDays(-5), Grant_Type__c = 'View'));
        //licenseList.add( new License__c( License_Type__c = 'Trial', Update_Type__c = 'Dynamic', Status__c = 'Active', Order_Number__c = 'Order2', Product__c = p.id, End_Date__c = Date.today().addDays(-1), Purchase_Date__c = Date.today().addDays(3), Customer__c = accList[0].id, Start_Date__c =  Date.today().addDays(-4), Grant_Type__c = 'Download' ));
        //licenseList.add( new License__c( License_Type__c = 'Subscription', Update_Type__c = 'Static', Status__c = 'In progress', Order_Number__c = 'Order3', Product__c = p.id, End_Date__c = Date.today().addDays(-1), Purchase_Date__c = Date.today().addDays(5), Customer__c = accList[1].id, Start_Date__c =  Date.today().addDays(-6), Grant_Type__c = 'View'));
        licenseList.add( new License__c( CreatedDate = nowTime, LastModifiedDate = nowTime, License_Type__c = 'Trial', Update_Type__c = 'Dynamic', Status__c = 'License created successfully, Entitlement Creation in progress', Order_Number__c = 'Order4', Product__c = p.id, End_Date__c = Date.today().addDays(-1), Purchase_Date__c = Date.today().addDays(2), Customer__c = accList[1].id, Start_Date__c =  Date.today().addDays(-3), Grant_Type__c = 'View; Download'));
        //licenseList.add( new License__c( License_Type__c = 'Perpetual', Update_Type__c = 'Static', Status__c = 'In progress', Order_Number__c = 'Order5', Product__c = p.id, End_Date__c = Date.today().addDays(-1), Purchase_Date__c = Date.today().addDays(3), Customer__c = accList[2].id, Start_Date__c =  Date.today().addDays(-2), Grant_Type__c = 'Download' ));
        insert licenseList;
        
        Test.startTest();
        //Test.setMock ( HttpCalloutMock.class, new MockGenerator_Test() );
        TF_LicenseEmailBatch license_EmailBatch = new TF_LicenseEmailBatch();
        Database.executeBatch(license_EmailBatch,200);
        //Test.setMock ( HttpCalloutMock.class, new MockGenerator_Test() );
        Test.stopTest();
    }
}