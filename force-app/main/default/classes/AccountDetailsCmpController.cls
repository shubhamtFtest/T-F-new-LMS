public without sharing class AccountDetailsCmpController {
	@AuraEnabled
    public static Account getAccountDetails(String recordId){
        Account thisAccount = null;
        if(recordId != null ){
            thisAccount = [SELECT  Id, Ringgold_Account_ID__c,Name,website, BillingStreet, BillingCity,BillingState, BillingCountry, Type, Classification__c,Owner.Name, Known_As__c, Customer_Id__c,CreatedBy.Name,LastModifiedBy.Name, ShippingCity,ShippingStreet,ShippingCountry,ShippingState,BillingPostalCode,ShippingPostalCode FROM Account WHERE Id =: recordId];
        }
        return thisAccount;
    }
}