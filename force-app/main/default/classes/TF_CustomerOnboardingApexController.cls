public class TF_CustomerOnboardingApexController {
@AuraEnabled
    public static Account getAccountDetails(String recordId){
        Account thisAccount = null;
        if(recordId != null ){
			thisAccount = [SELECT  Id, Ringgold_Account_ID__c,Name,Website,BillingCity,BillingPostalCode,Onboarding_Status__c ,BillingState, BillingCountry  FROM Account WHERE Id =: recordId];
            System.debug('Account:'+thisAccount);
        }
        return thisAccount;
    }
    
    @AuraEnabled
    public static void updateAccStatusPostEnrichment(String recordId){
        Account thisAccount = new Account();
        if(recordId != null ){
			thisAccount.id = recordId;
            thisAccount.Onboarding_Status__c = 'RingGold Enrichment Done';
            update thisAccount;
        }
    }

}