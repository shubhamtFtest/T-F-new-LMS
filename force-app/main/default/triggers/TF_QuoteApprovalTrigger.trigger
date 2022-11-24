/*********************************************************************************************
  This trigger is used to update CSD Approval Status and Approved / Rejected Date of Quote.
**********************************************************************************************/
trigger TF_QuoteApprovalTrigger on Quote_Approval__c (after update) {

 //   Set<Id> quoteSet = new Set<Id>();
    
	//if(TF_CheckRecursive.runOnce5()){
	//	if(Trigger.isUpdate && Trigger.isAfter){
 //          for(Quote_Approval__c quoteApp : Trigger.New){
 //              quoteSet.add(quoteApp.Quote__c);
 //          }
    
 //          if(!quoteSet.isEmpty())
 //             TF_QuoteApprovalHandler.updateQuoteApprovalStatus(quoteSet);  
 //       }
	//}      
}