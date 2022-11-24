@isTest
public class zTest_setupCountryCode {

    @isTest
    private static  void createProductRecord(){
        //Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
            Product2 prodObject = new Product2(Name = 'Test Product',
                                           CPQ_Category__c = 'Technology',
                                           Distribution_Rights_Excluded_Countries__c = 'INQ,OUT,OER',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           Readership_Level__c = 'Test');	
            insert prodObject;
        
        	prodObject.Distribution_Rights_Excluded_Countries__c = 'INQ,LSF,OER';
                
			update prodObject;            
    }
}