/********************************************************
This handler class is used for TF_QuoteTrigger trigger.
*********************************************************/
Public class TF_QuoteTriggerHandler {
    /**********************************************************
This method is called after updating Quote records.
********************************************************/
    Public static void onAfterUpdate(List<SBQQ__Quote__c> newQuote, Map<Id,SBQQ__Quote__C> OldQuoteMap) {
        Set<Id> quoteIdSet = new Set<Id>();
        Set<Id> accountIdSet = new Set<Id>();
        Map<Id,Id> oldAccountMap = new Map<Id,Id>();
        for(SBQQ__Quote__c quoteObj : newQuote) {
            if(quoteObj.sbqq__account__c != null) {
                quoteIdSet.add(quoteObj.id);
                accountIdSet.add(quoteObj.SBQQ__Account__c);
                //If the account is changed, then delete the prepay account transaction associated with old account
                if((quoteObj.SBQQ__Account__c != oldQuoteMap.get(quoteObj.id).SBQQ__Account__c)) {
                    oldAccountMap.put( quoteObj.id,oldQuoteMap.get(quoteObj.id).SBQQ__Account__c);
                }
            }
          /*  if(quoteObj.Use_Prepay_Budget__c == false && oldQuoteMap.get(quoteObj.id).Use_prepay_budget__c == true) {
                    oldAccountMap.put( quoteObj.id,quoteObj.SBQQ__Account__c);
                }*/
            
        }
        if(!oldAccountMap.isEmpty()) {
            deleteoldAccountPrepayTransaction(oldAccountMap);
        }
        if(!quoteIdSet.isEmpty()) {
            createPrepayTransaction(quoteIdSet,accountIdSet);
        }
        
    }
    
    /********************************************************
This method is called after undeleting Quote records..
********************************************************/
    Public static void onAfterUndelete(List<SBQQ__Quote__c> newQuote) {
        Set<Id> quoteIdSet = new Set<Id>();
        Set<Id> accountIdSet = new Set<Id>();
        for(SBQQ__Quote__c quoteObj : newQuote) {
            if(quoteObj.sbqq__account__c != null) {
                quoteIdSet.add(quoteObj.id);
                accountIdSet.add(quoteObj.SBQQ__Account__c);
            }
        }
        if(!quoteIdSet.isEmpty()) {
            createPrepayTransaction(quoteIdSet,accountIdSet);
        }
    }
    
    /********************************************************
This method is called before deleting Quote records..
********************************************************/
    Public static void onBeforeDelete(List<SBQQ__Quote__c> oldQuote) {
        deletePrepayTransaction (oldQuote);
    }
    
    /*****************************************************************
This method is used to create/update/delete Prepay Account Transactions records.
*****************************************************************/
    Public static void createPrepayTransaction (Set<Id> quoteId, Set<Id> accountId) {
        Set<SBQQ__Quote__c> quoteObjSet = new Set<SBQQ__Quote__c>();
        Set<SBQQ__Quote__c> prepayactstSet = new Set<SBQQ__Quote__c>();
        
        List<Prepay_Account_Transactions__c> updateprepayAccTrstList = new List<Prepay_Account_Transactions__c>();
        List<Prepay_Account_Transactions__c> deleteprepayAccTrstList = new List<Prepay_Account_Transactions__c>();
        List<Prepay_Account_Transactions__c> prepayAccTrstList = new List<Prepay_Account_Transactions__c>();
        Map<Id,Account> AccountMap = new Map<Id,Account>([select id,(select id from Prepay_Accounts__r) from account where id in :accountId]);
        Map<Id,SBQQ__Quote__c> quoteMap = new Map<Id,SBQQ__Quote__c> ([Select id,SBQQ__Account__c,SBQQ__Account__r.Prepay_Account_Count__c,SBQQ__NetAmount__c,Use_Prepay_Budget__c,
                                                                       (select id,Discount_Rules_Applied__c from SBQQ__LineItems__r), 
                                                                       (select id,Quote_ID__c,Copy_Quote_Value__c from PrepayAccountTransactions__r)
                                                                       from SBQQ__Quote__c where id in :quoteId]);
        for(SBQQ__Quote__c quoteObj : quoteMap.values()) { 
            
            //If the quote lines are empty or use prepay budget is false and prepay account transactions is not empty for Quote then delete prepay account transaction
            
            if((quoteObj.SBQQ__LineItems__r.isEmpty() || quoteObj.Use_Prepay_Budget__c == false) && !quoteObj.PrepayAccountTransactions__r.isEmpty()) {
                for(Prepay_Account_Transactions__c pac : quoteObj.PrepayAccountTransactions__r) {
                    deleteprepayAccTrstList.add(pac);
                }
                
            } 
            // If quote account is prepay account and there is no prepay transaction record for quote then create prepay transaction record.
            if(quoteObj.SBQQ__Account__r.Prepay_Account_Count__c > 0  && quoteObj.PrepayAccountTransactions__r.isEmpty() && quoteObj.Use_Prepay_Budget__c == true ) {
                Prepay_Account_Transactions__c pac = new Prepay_Account_Transactions__c();
                            pac.Quote_ID__c = quoteObj.id;
                            pac.PrepayAccounts__c = AccountMap.get(quoteObj.SBQQ__Account__c).Prepay_Accounts__r[0].id;
                            pac.Copy_Quote_Value__c = quoteObj.SBQQ__NetAmount__c;
                            prepayAccTrstList.add(pac);
            }
            // If quote account is prepay account and prepay transaction record is there then update the prepay transaction record.
            else if (!quoteObj.PrepayAccountTransactions__r.isEmpty()) {
                            for(Prepay_Account_Transactions__c pac : quoteObj.PrepayAccountTransactions__r) {
                                if(pac.Copy_Quote_Value__c != quoteObj.SBQQ__NetAmount__c) {
                                    pac.Copy_Quote_Value__c = quoteObj.SBQQ__NetAmount__c;
                                    updateprepayAccTrstList.add(pac);
                                }
                            }
                            
                        }         
            
        /*    for(SBQQ__QuoteLine__c quotelineObj : quoteObj.SBQQ__LineItems__r) {
                if(quotelineObj.Discount_Rules_Applied__c != null && quotelineObj.Discount_Rules_Applied__c != '') {
                    prepayactstSet.add(quoteObj);
                    if(quotelineObj.Discount_Rules_Applied__c.contains('Prepay')) {
                        prepayactstSet.remove(quoteObj);
 // If quoteline contains 'prepay' and there is no prepay transaction record for quote then create prepay transaction record.
                        if(quoteObj.PrepayAccountTransactions__r.isEmpty() && !AccountMap.get(quoteObj.SBQQ__Account__c).Prepay_Accounts__r.isEmpty())  {
                            
                            Prepay_Account_Transactions__c pac = new Prepay_Account_Transactions__c();
                            pac.Quote_ID__c = quoteObj.id;
                            pac.PrepayAccounts__c = AccountMap.get(quoteObj.SBQQ__Account__c).Prepay_Accounts__r[0].id;
                            pac.Copy_Quote_Value__c = quoteObj.SBQQ__NetAmount__c;
                            prepayAccTrstList.add(pac);
                        }   
 // If quote contains 'prepay' and prepay transaction record is there then update the prepay transaction record.
                        else if (!quoteObj.PrepayAccountTransactions__r.isEmpty()) {
                            for(Prepay_Account_Transactions__c pac : quoteObj.PrepayAccountTransactions__r) {
                                if(pac.Copy_Quote_Value__c != quoteObj.SBQQ__NetAmount__c) {
                                    pac.Copy_Quote_Value__c = quoteObj.SBQQ__NetAmount__c;
                                    updateprepayAccTrstList.add(pac);
                                }
                            }
                            
                        }               
                    }
                    break;
                }
                
            } */
        }
        if(!prepayAccTrstList.isEmpty()) {
            insert prepayAccTrstList;
        }
        if(!deleteprepayAccTrstList.isEmpty()) {
            Database.delete(deleteprepayAccTrstList,false);
        }
        if(!updateprepayAccTrstList.isEmpty()) {
            update updateprepayAccTrstList;
        }
       /* if(!prepayactstSet.isEmpty()) {
            List<SBQQ__Quote__c> quotelst = new List<SBQQ__Quote__c>();
            quotelst.addAll(prepayactstSet);
            deletePrepayTransaction(quotelst);
        }*/
    }
    
    /*****************************************************************
This method is used to delete Prepay Account Transactions records.
*****************************************************************/
    Public static void deletePrepayTransaction (List<SBQQ__Quote__c> quotelst) {
        List<Prepay_Account_Transactions__c> prepayAccTranst = new List<Prepay_Account_Transactions__c>();
        prepayAccTranst = [select id,Quote_ID__c from Prepay_Account_Transactions__c where Quote_ID__c in :quotelst];
        if(!prepayAccTranst.isEmpty()) {
            // Database.delete(prepayAccTranst,false);
            delete prepayAccTranst;
        }
    }
    
    /*****************************************************************
This method is used to delete old Prepay Account Transactions records.
*****************************************************************/
    Public static void deleteoldAccountPrepayTransaction (Map<Id,Id> accountquoteMap) {
        List<Prepay_Account_Transactions__c> prepayAccTranst = new List<Prepay_Account_Transactions__c>();
        List<Prepay_Account_Transactions__c> deleteprepayAccTranslist = new List<Prepay_Account_Transactions__c>();
        prepayAccTranst = [select id,PrepayAccounts__r.AccountName__c,Quote_ID__c from Prepay_Account_Transactions__c where Quote_ID__c in :accountquoteMap.keyset()];
        for(Prepay_Account_Transactions__c pact : prepayAccTranst) {
            if(pact.prepayAccounts__r.AccountName__c == accountquoteMap.get(pact.Quote_ID__c)) {
                deleteprepayAccTranslist.add(pact);
            }
        }
        if(!deleteprepayAccTranslist.isEmpty()) {
            // Database.delete(deleteprepayAccTranslist,false);
            delete deleteprepayAccTranslist;
        }
    }
}