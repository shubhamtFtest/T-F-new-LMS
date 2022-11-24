/********************************************************************
  Modified By : Siddhant Tyagi
  Last Modified Date : 05/09/2019
********************************************************************/
public class TF_PreventQuoteLineDelTrigHandler {
    /*public static void preventQuoteLineDeletion(Set<Id> quotelineIdSet){
        List<SBQQ__QuoteLine__c> quotelineList = new List<SBQQ__QuoteLine__c>();
        if(!quotelineIdSet.isEmpty()){
              quotelineList = [SELECT id,SBQQ__Quote__r.CSD_Approval_Status__c,SBQQ__Quote__r.SBQQ__Status__c FROM SBQQ__QuoteLine__c WHERE Id in :quotelineIdSet];
       
              for(SBQQ__QuoteLine__c quotelineObj : quotelineList){
                    if(quotelineObj.SBQQ__Quote__r.CSD_Approval_Status__c == 'Rejected'){
                        Trigger.oldMap.get(quotelineObj.Id).addError('You cannot delete the Quote Line of a Rejected quote.');
                    }
                  
                    if(quotelineObj.SBQQ__Quote__r.SBQQ__Status__c == 'Expired'){
                        Trigger.oldMap.get(quotelineObj.Id).addError('You cannot delete the Quote Line of an Expired quote.');
                    }
              }
         }
    }*/
    
    public static void updateSocietyManualCheck(List<SBQQ__QuoteLine__c> quotelineList){
        List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
        Map<Id,SBQQ__Quote__c> quoteMap = new Map<Id,SBQQ__Quote__c>();
        
        if(!quotelineList.isEmpty()){
            for(SBQQ__QuoteLine__c quoteLineObj : quotelineList){
                SBQQ__Quote__c quoteObj = new SBQQ__Quote__c();
                //System.debug('*********quoteLineObj.Best_Discount_Rule__c'+quoteLineObj.Best_Discount_Rule__c);
                if(quoteLineObj.Best_Discount_Rule__c == 'Society'){
                    quoteObj.Id = quoteLineObj.SBQQ__Quote__c;
                    quoteObj.Society_Manual_Check__c = true;
                }
                else{
                    quoteObj.Id = quoteLineObj.SBQQ__Quote__c;
                    quoteObj.Society_Manual_Check__c = false;
                }
               quoteMap.put(quoteLineObj.SBQQ__Quote__c,quoteObj); 
            }
        }
         quoteList = quoteMap.values();
        if(!quoteList.isEmpty()){
            update quoteList;
        }
    }
    
    public static void updateSocManualCheckAfterDel(List<SBQQ__QuoteLine__c> quotelineList){
        Map<Id,SBQQ__Quote__c> quoteMap = new Map<Id,SBQQ__Quote__c>();
        List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
        
        if(!quotelineList.isEmpty()){
            for(SBQQ__QuoteLine__c quoteLineObj : quotelineList){
                SBQQ__Quote__c quoteObj = new SBQQ__Quote__c();
				quoteObj.Id = quoteLineObj.SBQQ__Quote__c;
                quoteObj.Journal__c = null;
                if(quoteLineObj.Best_Discount_Rule__c == 'Society'){
                    quoteObj.Society_Manual_Check__c = false;
                }
				quoteMap.put(quoteLineObj.SBQQ__Quote__c,quoteObj);
            }
        }
        quoteList = quoteMap.values();
        if(!quoteList.isEmpty()){
            update quoteList;
        }
    }
	
	public static void updateJournalFieldOnQuote(List<SBQQ__QuoteLine__c> quotelineList){
        Map<Id,SBQQ__Quote__c> quoteMap = new Map<Id,SBQQ__Quote__c>();
        List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
       
        if(!quotelineList.isEmpty()){
            for(SBQQ__QuoteLine__c quoteLineObj : quotelineList){
                 SBQQ__Quote__c quoteObj = new SBQQ__Quote__c();
                quoteObj.Id = quoteLineObj.SBQQ__Quote__c;
                quoteObj.Journal__c = quoteLineObj.SBQQ__ProductName__c;
                quoteMap.put(quoteLineObj.SBQQ__Quote__c,quoteObj);  
            }
        }
        quoteList = quoteMap.values();
        if(!quoteList.isEmpty()){
            update quoteList;
        }
    }
}