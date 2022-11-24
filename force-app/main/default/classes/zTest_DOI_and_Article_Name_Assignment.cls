/********************************************************************************
* 
*	Created by Tom Reed:
*		Test: DOI_and_Article_Name_Assignment_trig on ProductInterest__c at 100%
*
********************************************************************************/

@istest
Public class zTest_DOI_and_Article_Name_Assignment {
    
    static testmethod void CreateTestRecords(){
        
        TriggerInterfaceHelper.runTrigger('DOI_and_Article_Name_Assignment_trig', 'ProductInterest__c', 1, 'au,ai', null, null);
        
        Product2 ProductRecord = new Product2();
        ProductRecord.name = 'Test';
        INSERT ProductRecord;
        
        Setting__C SettingRecord = New Setting__C(name = 'DOI_and_Article_Name_Assignment_trig_List');
        Insert SettingRecord;
        
        Setting_item__C SettingItemRecord = New Setting_item__c();
        SettingItemRecord.Setting__c = SettingRecord.id;
        SettingItemRecord.Text_1__c = 'Author';
        INSERT SettingItemRecord;
        
        
        Contact ContactRecord = New Contact();
        ContactRecord.lastname = 'Tom Test';
        ContactRecord.Latest_Article_Journal__c = '';
        ContactRecord.Latest_Article_Title__c = '';
        ContactRecord.Latest_DOI_1__c = '';
        ContactRecord.Latest_DOI_2__c = '';
        ContactRecord.Published_Articles__c = 0;
        INSERT ContactRecord;
        
        ProductInterest__c ProductInterestRecord = New ProductInterest__c();
        ProductInterestRecord.ContactID__c = ContactRecord.id;
        ProductInterestRecord.product_interest_role__c = 'Author';
        ProductInterestRecord.DOI__c = 'Test';
        ProductInterestRecord.Article_Type__c = 'Article';
        ProductInterestRecord.ProductID__c = ProductRecord.id;
        ProductInterestRecord.Article_Name__c = 'Test Article Name';
        ProductInterestRecord.DOI__c = 'TestLeftString/TestRightString';       
        INSERT ProductInterestRecord;   
        
        
    }
    
}