/**************************************************************************
  This handler class is for TF_UpdateSocietyDiscountAmountFieldTrigger trigger.
***************************************************************************/
public class TF_UpdateSocietyDiscountAmountHandler{

    /*****************************************************************
    This method is used to update Society Discount Amount field on QuoteLine.
    ******************************************************************/
    public static void updateSocietyDiscountAmount(List<Society_Quote__c> societyQuoteLst){
    Set<Id> quoteLineIdSet = new Set<Id>();
    Set<Id> societyQuoteLineIdSet = new Set<Id>();
    Set<Id> accountIdSet = new Set<Id>();
    //List<SBQQ__QuoteLine__c> updateQuoteLineList = new List<SBQQ__QuoteLine__c>();
    Set<Id> updateQuoteLineIdSet = new Set<Id>();
    List<Society_Quote__c> societyQuoteList = new List<Society_Quote__c>();
    Map<Id,SBQQ__QuoteLine__c> IdvsQuoteLineMap = new Map<Id,SBQQ__QuoteLine__c>();
    List<SBQQ__QuoteLine__c> updatedQuoteLineList = new List<SBQQ__QuoteLine__c>();
    Set<Id> setQuoteId = new Set<Id>();
	//Update Quote records
	//List<SBQQ__Quote__c> quoteList2 = new List<SBQQ__Quote__c>();
    SBQQ__Quote__c updateQuote = new SBQQ__Quote__c();
    
    for(Society_Quote__c societyQuoteObj: societyQuoteLst){
        if(societyQuoteObj.Quote_Line__c != NULL){
            quoteLineIdSet.add(societyQuoteObj.Quote_Line__c);
        }
    } 
    
    societyQuoteList = [SELECT id,Name,Quote_Line__c,Society__c from  Society_Quote__c where Quote_Line__c in :quoteLineIdSet]; 
        
    // This executes only if the society quote is deleted
    if(Trigger.isDelete) { 
    Map<Id,SBQQ__QuoteLine__c> societyQuoteMap = new Map<Id,SBQQ__QuoteLine__c>([select id, SBQQ__Quote__r.Society_Manual_Check__c, Best_Society_Discount_Display_Name__c, (select id,Name,Quote_Line__c,Society__c from Associated_Societies__r) from SBQQ__QuoteLine__c where id in :quoteLineIdSet ]);
        for(SBQQ__QuoteLine__c ql : societyQuoteMap.values()) {
            if(ql.Associated_Societies__r.isEmpty()) {
                ql.Society_Discount_Amount__c = null;
				ql.Best_Society_Discount_Display_Name__c = null;
                ql.Best_Discount_Society__c = null;
                ql.Best_Discount_Society_Id__c = null;
                ql.SBQQ__AdditionalDiscountAmount__c = null;
                ql.Discount_Rules_Applied__c = '';
                IdvsQuoteLineMap.put(ql.id,ql);
                //updateQuote.Id = ql.SBQQ__Quote__c;
				//updateQuote.Society_Manual_Check__c = false; 
                //quoteList2.add(updateQuote);
            }
        }
    }
    // End of society quote deletion.
    
    for(Society_Quote__c societyQuoteObj: societyQuoteList){
        if(societyQuoteObj.Quote_Line__c != NULL){
            societyQuoteLineIdSet.add(societyQuoteObj.Quote_Line__c);
        }
        accountIdSet.add(societyQuoteObj.Society__c); 
    }    
    
    //Fetch QuoteLine records.
    List<SBQQ__QuoteLine__c> quoteLineList = new List<SBQQ__QuoteLine__c>();
    quoteLineList = [SELECT Society_Discount_Amount__c, SBQQ__Product__c, SBQQ__ListPrice__c,SBQQ__Quote__c, Best_Society_Discount_Display_Name__c FROM SBQQ__QuoteLine__c where Id in :societyQuoteLineIdSet];
    
    for(SBQQ__QuoteLine__c quoteLineObj : quoteLineList){
        quoteLineObj.Society_Discount_Amount__c = NULL;
		quoteLineObj.Best_Society_Discount_Display_Name__c = NULL;
        updatedQuoteLineList.add(quoteLineObj);
        setQuoteId.add(quoteLineObj.SBQQ__Quote__c);
    }
    
    //Fetch Quote records.
    List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>(); 
    quoteList = [SELECT id,Today_Date__c,Society_Manual_Check__c,CurrencyIsoCode from SBQQ__Quote__c where Id in :setQuoteId];
    
    //Fetch Account records.
    List<Account> accountList = new List<Account>();
    accountList = [SELECT Id, Name, Manual_Check__c FROM Account where Id in :accountIdSet];
        
    Id societyDiscountRecordTypeId = Schema.SObjectType.CPQ_Discount_Configuration__c.getRecordTypeInfosByName().get('T&F - Society Discount').getRecordTypeId();
    System.debug('accountList** : '+accountList+''+accountList.size());
    
    //Fetch Discount Configuration records.
    List<CPQ_Discount_Configuration__c> discountConfigList = new List<CPQ_Discount_Configuration__c>();
    discountConfigList = [SELECT Active__c, Discount_Type__c, Discount_Value_Amount__c, Discount_Value_Percentage__c, Product__c, Society__c,Society__r.Name,Start_Date__c,End_Date__c,Discount_Display_Name__c,CurrencyIsoCode FROM CPQ_Discount_Configuration__c where Society__c in :accountIdSet AND Active__c = true AND RecordTypeId = :societyDiscountRecordTypeId];
    
    System.debug('discountConfigList** : '+discountConfigList+''+discountConfigList.size());
	
    for(SBQQ__Quote__c quote : quoteList){
        for(CPQ_Discount_Configuration__c discountConfigObj: discountConfigList){
            //First condition is for checking whether Today Date of Quote is less than or equal to End Date of Discount Configuration record.
            //Second condition is for checking whether Today Date of Quote is greater than or equal to Start Date of Discount Configuration record.
            if((quote.Today_Date__c <= discountConfigObj.End_Date__c) && (quote.Today_Date__c >= discountConfigObj.Start_Date__c)){
                for(Account accountObj: accountList){
                
                    if(discountConfigObj.Society__c == accountObj.Id){

                        for(SBQQ__QuoteLine__c quoteLineObj : updatedQuoteLineList){
                        
                            if(discountConfigObj.Product__c == quoteLineObj.SBQQ__Product__c){
                                System.debug('Inside product** :');
                                //Check whether Discount Type is '% Discount'.
                                if(discountConfigObj.Discount_Type__c == '% Discount'){
                                    System.debug('Inside % Discount** :');
                                    if(quoteLineObj.Society_Discount_Amount__c == null){
                                        quoteLineObj.Society_Discount_Amount__c = (discountConfigObj.Discount_Value_Percentage__c * quoteLineObj.SBQQ__ListPrice__c)/100;
                                        System.debug('discountConfigObj.Discount_Value_Percentage__c * quoteLineObj.SBQQ__ListPrice__c'+discountConfigObj.Discount_Value_Percentage__c * quoteLineObj.SBQQ__ListPrice__c);
                                        System.debug('quoteLineObj.Society_Discount_Amount__c'+quoteLineObj.Society_Discount_Amount__c);
										quoteLineObj.Best_Society_Discount_Display_Name__c = discountConfigObj.Discount_Display_Name__c;
                                        quoteLineObj.Best_Discount_Society__c = discountConfigObj.Society__r.Name;
                                        quoteLineObj.Best_Discount_Society_Id__c = discountConfigObj.Society__c;
                                        IdvsQuoteLineMap.put(quoteLineObj.Id,quoteLineObj);
										//quote.Society_Manual_Check__c = accountObj.Manual_Check__c;
										//quoteList2.add(quote);
                                    }
                                    else{
                                         System.debug('Inside else % Discount** :');
                                        if(quoteLineObj.Society_Discount_Amount__c < (discountConfigObj.Discount_Value_Percentage__c * quoteLineObj.SBQQ__ListPrice__c)/100){
                                            quoteLineObj.Society_Discount_Amount__c = (discountConfigObj.Discount_Value_Percentage__c * quoteLineObj.SBQQ__ListPrice__c)/100;
                                            quoteLineObj.Best_Society_Discount_Display_Name__c = discountConfigObj.Discount_Display_Name__c;
											quoteLineObj.Best_Discount_Society__c = discountConfigObj.Society__r.Name;  
                                            quoteLineObj.Best_Discount_Society_Id__c = discountConfigObj.Society__c;
                                            IdvsQuoteLineMap.put(quoteLineObj.Id,quoteLineObj);
											//quote.Society_Manual_Check__c = accountObj.Manual_Check__c;
											//quoteList2.add(quote);
                                        }
                                    }
                                } 
                                //Check whether Discount Type is 'Amount Discount'.
                                else if((discountConfigObj.Discount_Type__c == 'Amount Discount') && (quote.CurrencyIsoCode == discountConfigObj.CurrencyIsoCode)){
                                        System.debug('Inside Amount Discount** :');
                                    if(quoteLineObj.Society_Discount_Amount__c == null){
                                        quoteLineObj.Society_Discount_Amount__c = discountConfigObj.Discount_Value_Amount__c; 
                                        quoteLineObj.Best_Society_Discount_Display_Name__c = discountConfigObj.Discount_Display_Name__c;										
                                        quoteLineObj.Best_Discount_Society__c = discountConfigObj.Society__r.Name;
                                        quoteLineObj.Best_Discount_Society_Id__c = discountConfigObj.Society__c;
                                        IdvsQuoteLineMap.put(quoteLineObj.Id,quoteLineObj);
										//quote.Society_Manual_Check__c = accountObj.Manual_Check__c;
										//quoteList2.add(quote);
                                        System.debug('quoteLineObj.Society_Discount_Amount__c : '+quoteLineObj.Society_Discount_Amount__c);
                                    }
                                    else{
                                        System.debug('Inside else Amount Discount** :');
                                        if(quoteLineObj.Society_Discount_Amount__c < discountConfigObj.Discount_Value_Amount__c){
                                            quoteLineObj.Society_Discount_Amount__c = discountConfigObj.Discount_Value_Amount__c;  
											quoteLineObj.Best_Society_Discount_Display_Name__c = discountConfigObj.Discount_Display_Name__c;
                                            quoteLineObj.Best_Discount_Society__c = discountConfigObj.Society__r.Name;
                                            quoteLineObj.Best_Discount_Society_Id__c = discountConfigObj.Society__c;
                                            IdvsQuoteLineMap.put(quoteLineObj.Id,quoteLineObj);
											//quote.Society_Manual_Check__c = accountObj.Manual_Check__c;
											//quoteList2.add(quote);
                                        }
                                    }   
                                } 
                                //Check whether Discount Type is 'Fixed Amount Discount'.
                                else if((discountConfigObj.Discount_Type__c == 'Fixed Amount Discount') && (quote.CurrencyIsoCode == discountConfigObj.CurrencyIsoCode)){
                                     System.debug('Inside Fixed Amount Discount** :');
                                    if(quoteLineObj.Society_Discount_Amount__c == null){
                                        quoteLineObj.Society_Discount_Amount__c = quoteLineObj.SBQQ__ListPrice__c - discountConfigObj.Discount_Value_Amount__c;  
										quoteLineObj.Best_Society_Discount_Display_Name__c = discountConfigObj.Discount_Display_Name__c;
                                        quoteLineObj.Best_Discount_Society__c = discountConfigObj.Society__r.Name;
                                        quoteLineObj.Best_Discount_Society_Id__c = discountConfigObj.Society__c;
                                        IdvsQuoteLineMap.put(quoteLineObj.Id,quoteLineObj);
										//quote.Society_Manual_Check__c = accountObj.Manual_Check__c;
										//quoteList2.add(quote);
                                    }
                                    else{
                                        System.debug('Inside else Fixed Amount Discount** :');
                                        if(quoteLineObj.Society_Discount_Amount__c < (quoteLineObj.SBQQ__ListPrice__c - discountConfigObj.Discount_Value_Amount__c)){
                                            quoteLineObj.Society_Discount_Amount__c = quoteLineObj.SBQQ__ListPrice__c - discountConfigObj.Discount_Value_Amount__c; 
                                            quoteLineObj.Best_Society_Discount_Display_Name__c = discountConfigObj.Discount_Display_Name__c;											
                                            quoteLineObj.Best_Discount_Society__c = discountConfigObj.Society__r.Name;
                                            quoteLineObj.Best_Discount_Society_Id__c = discountConfigObj.Society__c;
                                            IdvsQuoteLineMap.put(quoteLineObj.Id,quoteLineObj);
											//quote.Society_Manual_Check__c = accountObj.Manual_Check__c;
											//quoteList2.add(quote);
                                        }
                                    }  
                                }
                                
                            }                     
                        }
                    }
                }
            } 
        }
    }   
    
	/*if(!quoteList2.isEmpty()){
        Database.Update(quoteList2); 
    }
	System.debug('quoteList2****************'+quoteList2);*/
	
    System.debug('IdvsQuoteLineMap****************'+IdvsQuoteLineMap.values());
    	
    if(!IdvsQuoteLineMap.isEmpty()){
       Database.Update(IdvsQuoteLineMap.values(), false); 
       //update IdvsQuoteLineMap.values();
    }
        
    }
	
	/*public static void preventSocQuoteDeletion(Set<Id> socQuoteIdSet){
		List<Society_Quote__c> societyQuoteList = new List<Society_Quote__c>();
        if(!socQuoteIdSet.isEmpty()){
              societyQuoteList = [SELECT id,Quote_Line__r.SBQQ__Quote__r.CSD_Approval_Status__c,Quote_Line__r.SBQQ__Quote__r.SBQQ__Status__c FROM Society_Quote__c WHERE Id in :socQuoteIdSet];
       
              for(Society_Quote__c societyQuoteObj : societyQuoteList){
                    if(societyQuoteObj.Quote_Line__r.SBQQ__Quote__r.CSD_Approval_Status__c == 'Rejected'){
                        Trigger.oldMap.get(societyQuoteObj.Id).addError('You cannot delete the Society Quote of a Rejected quote.');
                    }
                  
                    if(societyQuoteObj.Quote_Line__r.SBQQ__Quote__r.SBQQ__Status__c == 'Expired'){
                        Trigger.oldMap.get(societyQuoteObj.Id).addError('You cannot delete the Society Quote of an Expired quote.');
                    }
              }
        }
	}*/
}