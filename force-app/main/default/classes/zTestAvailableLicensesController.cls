@isTest
private class zTestAvailableLicensesController{
    static testMethod void validateLicenseData(){
        
        Test.startTest();
        Setting__c setting=new Setting__c();
        setting.Name='Limited Licenses';
        insert setting;
        Setting_Item__c settItm=new Setting_Item__c();
        settItm.Text_1__c='1';
        settItm.Setting__c=setting.Id;
        insert settItm;
        AvailableLicensesController avlLicCtr=new AvailableLicensesController();
        Integer total=avlLicCtr.SalesforceFull_Total;
        Integer used=avlLicCtr.SalesforceFull_Used;
        Integer rem=avlLicCtr.SalesforceFull_Remaining;
        Integer limTotal=avlLicCtr.SalesforceLimited_Total;
        Integer limUsed=avlLicCtr.SalesforceLimited_Used;
        Integer limRem=avlLicCtr.SalesforceLimited_Remaining;
        Integer fullTota=avlLicCtr.ForceCom_Total;
        Integer fullUsed=avlLicCtr.ForceCom_Used;
        Integer fullRem=avlLicCtr.ForceCom_Remaining;
        Integer limTotal1=avlLicCtr.CommunityPlus_Total;
        Integer commUsed=avlLicCtr.CommunityPlus_Used;
        Integer commRem=avlLicCtr.CommunityPlus_Remaining;
        Test.stopTest();
    }
    static testMethod void validateLicenseData2(){
        
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='CAS - BU Administrator User']; 
        Setting__c setting=new Setting__c();
        setting.Name='Limited License Profiles';
        insert setting;
        Setting_Item__c settItm=new Setting_Item__c();
        settItm.Text_1__c=p.Id;
        settItm.Setting__c=setting.Id;
        insert settItm;
        AvailableLicensesController avlLicCtr=new AvailableLicensesController();
        
        Test.stopTest();
    }
}