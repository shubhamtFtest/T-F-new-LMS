/**
* Author     : Avinash Singh
* Company    : Informa
* Date       : 2017-03-16
* Class      : InformaLoginController 
* Modified by:   
**/

@isTest
public class zTest_InformaLoginController {
  static testMethod void TestInformaLoginController()
    {
        Salesforce_Org__c so = new Salesforce_Org__c (Name='QuickSilver',ClientKey__c='3MVG9ZL0ppGP5UrA91pNZMs8eQ1qX6ejh2JBTdE4AMnYyWsp0HQxR_ATj6Wi6nIezzmP4Ye7CCcFfYOr8f5wL',Target_Oid__c='00D28000001OkO8EAK', ClientSecret__c='5405636128108993139', domain__c='https://quicksilver-dev-ed.my.salesforce.com', Email__c='avi.1967@gmail.com', Org__c='QuickSilver', Password__c='cgiytr456', User_Name__c='quicksilver@marvels.com');        
        insert so;
        
        ApexPages.currentPage().getParameters().put('Org',so.Org__c);
        InformaLoginController ilc = new InformaLoginController();
        ilc.click();
    }
}