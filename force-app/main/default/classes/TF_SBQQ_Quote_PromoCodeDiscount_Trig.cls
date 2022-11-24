public with sharing class TF_SBQQ_Quote_PromoCodeDiscount_Trig  implements TriggerInterface_SBQQ_Quote.Runnable {
    public void run(TriggerInterface_SBQQ_Quote.Trig trig) {
        
        if (trig.isAfter && (trig.isInsert || trig.isUpdate)) { 
            
            if (trig.newList[0].SBQQ__Status__c == 'Customer Accepted' && trig.oldList[0].SBQQ__Status__c != 'Customer Accepted'){                                
                
                system.debug('Promo Code Discount Trigger Executed.');
                List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
                
                List<SBQQ__QuoteLine__c> quoteLine = new List<SBQQ__QuoteLine__c>();
                List<Sales_Deal__c > cpqDiscountConfigObjList = new List<Sales_Deal__c >();
                Sales_Deal__c  cpqDiscountConfigObj = new Sales_Deal__c ();
                DateTime today = DateTime.now();
                if(!trig.newList.isEmpty()){
                    
                    set<String> quoteIds = new set<String>();
                    set<String> quotePromoCode = new set<String>();
                    Map<String, List<SBQQ__QuoteLine__c>> quoteQuoteLineMap = new Map<String, List<SBQQ__QuoteLine__c>>();
                    Map<String, Sales_Deal__c > quoteDiscountConfigMap = new Map<String, Sales_Deal__c >();
                    
                    for(SBQQ__Quote__c quoteRec : trig.newList){
                        quoteIds.add(quoteRec.Id);
                        if(string.isNotBlank(quoteRec.PromoCode__c)){
                            quotePromoCode.add(quoteRec.PromoCode__c);
                        }
                    }
                    
                    for(Sales_Deal__c  discountConfig : [SELECT Id, Active__c, Promocode__c, 
                                                                        Single_Use__c, Used_Quote__c, Number_of_Quotes_used_this_PromoCode__c, 
                                                                        End_Date__c, Promo_Code_Used_Date__c, Is_Used__c 
                                                                        FROM Sales_Deal__c  
                                                                        WHERE Promocode__c in : quotePromoCode]){
                        quoteDiscountConfigMap.put(discountConfig.Promocode__c, discountConfig);
                    }
                    
                    for(SBQQ__Quote__c quoteObj : [SELECT Id, (SELECT Id, Name,Best_Discount_Rule__c,Discount_Rules_Applied__c FROM SBQQ__LineItems__r LIMIT 1) FROM SBQQ__Quote__c WHERE Id IN : quoteIds]){
                        quoteQuoteLineMap.put(quoteObj.Id, quoteObj.SBQQ__LineItems__r);
                    }
                    
                    for (SBQQ__Quote__c quoteRec : trig.newList){                                                 
                        //quoteLine = [SELECT Id, Name,Best_Discount_Rule__c,Discount_Rules_Applied__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c = :quoteRec.Id limit 1];                                                                   
                        
                        quoteLine = quoteQuoteLineMap.get(quoteRec.Id);
                        
                        if (quoteLine != null && quoteLine.size() > 0){
                            if((quoteRec.PromoCode__c  != null && !String.isEmpty(quoteRec.PromoCode__c))) {

                                cpqDiscountConfigObj = quoteDiscountConfigMap.get(quoteRec.PromoCode__c);
                                /*cpqDiscountConfigObj = [SELECT Id, Active__c, Promocode__c, 
                                                        Single_Use__c, Used_Quote__c, Number_of_Quotes_used_this_PromoCode__c, 
                                                        End_Date__c, Promo_Code_Used_Date__c, Is_Used__c 
                                                        FROM Sales_Deal__c 
                                                        WHERE Promocode__c = :quoteRec.PromoCode__c limit 1]; */                           
                                
                                cpqDiscountConfigObj.Promo_Code_Used_Date__c = today; //case 01259265
                                cpqDiscountConfigObj.Is_Used__c = true; //case 01259265
                                
                                if(cpqDiscountConfigObj.Single_Use__c == true) {                           
                                    system.debug('Promocode is for single use');
                                    cpqDiscountConfigObj.Used_Quote__c = quoteRec.Name;                                  
                                    cpqDiscountConfigObj.Active__c = false; 
                                }else {                  
                                    system.debug('Promocode is for multiple use');
                                    if(cpqDiscountConfigObj.Number_of_Quotes_used_this_PromoCode__c  == NULL) {
                                        cpqDiscountConfigObj.Number_of_Quotes_used_this_PromoCode__c = 1;
                                    }else{
                                        cpqDiscountConfigObj.Number_of_Quotes_used_this_PromoCode__c = cpqDiscountConfigObj.Number_of_Quotes_used_this_PromoCode__c + 1;
                                    }
                                }
                                cpqDiscountConfigObjList.add(cpqDiscountConfigObj); 
                                quoteList.add(new SBQQ__Quote__c(Id = quoteRec.Id, Sales_Deal__c = cpqDiscountConfigObj.Id));
                            }
                        }
                    }
                }
                if(!cpqDiscountConfigObjList.isEmpty()){
                    update cpqDiscountConfigObjList;
                    update quoteList;
                }            
            }
        }
    }
}