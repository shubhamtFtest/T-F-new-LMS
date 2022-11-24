public class OA_OrderWebServiceCalloutRetryController {
	@AuraEnabled
    public Static SBQQ__Quote__c fetchQuote(string quoteId){
        SBQQ__Quote__c quoteRec = new SBQQ__Quote__c();
        quoteRec = [Select Id,SBQQ__Status__c,Order_Hub_Number__c,Invoice_Number__c  from SBQQ__Quote__c where Id =: quoteId];
        return quoteRec;
    }
    @AuraEnabled
    public Static string quoteOrderCalloutRetry(string quoteId){
        if(quoteId != null){
            TF_OrderHubWebServiceCallout.sendOrderNotification(quoteId);
        }
        return 'Success';
    }
}