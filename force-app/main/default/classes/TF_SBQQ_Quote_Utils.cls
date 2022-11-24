/*
* CAB Ticket #: CHG0037688
* Changes: lines 46 - 74, related to CHG0037688
* Changes: lines 54 - 60, related to CHG0037688
*/
public with sharing class TF_SBQQ_Quote_Utils {
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
        Map<Id,SBQQ__Quote__c> quoteMap = new Map<Id,SBQQ__Quote__c> ([Select id,SBQQ__Account__c,SBQQ__Account__r.Prepay_Account_Count__c, Payer_Account__r.Prepay_Account_Count__c ,SBQQ__NetAmount__c,Use_Prepay_Budget__c,
                                                                       (select id,Discount_Rules_Applied__c from SBQQ__LineItems__r), 
                                                                       (select id,Quote_ID__c,Copy_Quote_Value__c from PrepayAccountTransactions__r), Author_Status__c, Article_Acceptance_Status__c, CSD_Approval_Status__c
                                                                       from SBQQ__Quote__c where id in :quoteId]);
        System.debug('*********** Inside TF_SBQQ_Quote_Utils ***********');
        for(SBQQ__Quote__c quoteObj : quoteMap.values()) { 
            
            //If the quote lines are empty or use prepay budget is false and prepay account transactions is not empty for Quote then delete prepay account transaction
            System.debug('***** quoteObj.SBQQ__LineItems__r.isEmpty() ' + quoteObj.SBQQ__LineItems__r.isEmpty());
            System.debug('***** quoteObj.Use_Prepay_Budget__c ' + quoteObj.Use_Prepay_Budget__c);
            System.debug('***** quoteObj.PrepayAccountTransactions__r.isEmpty() '+ quoteObj.PrepayAccountTransactions__r.isEmpty());

            if((quoteObj.SBQQ__LineItems__r.isEmpty() || quoteObj.Use_Prepay_Budget__c == false) && !quoteObj.PrepayAccountTransactions__r.isEmpty()) {
                for(Prepay_Account_Transactions__c pac : quoteObj.PrepayAccountTransactions__r) {
                    deleteprepayAccTrstList.add(pac);
                }
                
            } 
            // If quote account is prepay account and there is no prepay transaction record for quote then create prepay transaction record.
            System.debug('*****  quoteObj.Payer_Account__c  ' + quoteObj.Payer_Account__c );
            System.debug('*****  quoteObj.Payer_Account__r.Prepay_Account_Count__c  ' + quoteObj.Payer_Account__r.Prepay_Account_Count__c );
            System.debug('*****  quoteObj.PrepayAccountTransactions__r.isEmpty()  ' + quoteObj.PrepayAccountTransactions__r.isEmpty() );
            System.debug('*****  quoteObj.Use_Prepay_Budget__c  ' + quoteObj.Use_Prepay_Budget__c );
            System.debug('*****  quoteObj.Author_Status__c ' + quoteObj.Author_Status__c );
            System.debug('*****  quoteObj.Article_Acceptance_Status__c ' + quoteObj.Article_Acceptance_Status__c );
            System.debug('*****  quoteObj.CSD_Approval_Status__c' + quoteObj.CSD_Approval_Status__c );
            if((quoteObj.Payer_Account__c != null && quoteObj.Payer_Account__r.Prepay_Account_Count__c > 0)  && quoteObj.PrepayAccountTransactions__r.isEmpty() && quoteObj.Use_Prepay_Budget__c == true ) {
                System.debug('*** Inside 1st if statment ***');
                Prepay_Account_Transactions__c pac = new Prepay_Account_Transactions__c();
                            pac.Quote_ID__c = quoteObj.id;
                            pac.PrepayAccounts__c = AccountMap.get(quoteObj.Payer_Account__c).Prepay_Accounts__r[0].id;
                            if(quoteObj.Author_Status__c != null && quoteObj.Article_Acceptance_Status__c != null && quoteObj.CSD_Approval_Status__c != null ) {
                                if( quoteObj.Author_Status__c.equals('Accepted') &&  quoteObj.Article_Acceptance_Status__c.equals('Accepted') &&  ( quoteObj.CSD_Approval_Status__c.equals('Approved') || quoteObj.CSD_Approval_Status__c.equals('Automatic Approval'))) {
                                    pac.Copy_Quote_Value__c = quoteObj.SBQQ__NetAmount__c;  
                                }
                            }
                            prepayAccTrstList.add(pac);
            }
            // If quote account is prepay account and prepay transaction record is there then update the prepay transaction record.
            else if (!quoteObj.PrepayAccountTransactions__r.isEmpty()) {
                            System.debug('*** Inside 2nd if statment ***');
                            for(Prepay_Account_Transactions__c pac : quoteObj.PrepayAccountTransactions__r) {
                                if(pac.Copy_Quote_Value__c != quoteObj.SBQQ__NetAmount__c) {
                                    if(quoteObj.Author_Status__c != null && quoteObj.Article_Acceptance_Status__c != null  && quoteObj.CSD_Approval_Status__c != null ) {
                                        if( quoteObj.Author_Status__c.equals('Accepted') &&  quoteObj.Article_Acceptance_Status__c.equals('Accepted') && ( quoteObj.CSD_Approval_Status__c.equals('Approved') || quoteObj.CSD_Approval_Status__c.equals('Automatic Approval'))) {
                                            pac.Copy_Quote_Value__c = quoteObj.SBQQ__NetAmount__c;
                                            updateprepayAccTrstList.add(pac);
                                        }
                                    }
                                }
                            }
                            
            }         
            

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

    /************************************************************************************************************************
      This method is used to get Country Applicable List field value based on Applicable List & EIFL fields on Country record.
    *************************************************************************************************************************/
    public static String getCountryApplicableListValue(String applicableListValue, Boolean eIFLValue){
        String countryApplicableListValue = '';
        //Check whether Applicable List on Country record is NULL.
        if(applicableListValue != Null){
              countryApplicableListValue = applicableListValue;
              if(eIFLValue != False){
                    countryApplicableListValue = countryApplicableListValue + ', EIFL';
              }
        }
        
        //Check whether Applicable List is NULL & EIFL is checked.
        if(applicableListValue == Null && eIFLValue == True){
              countryApplicableListValue = 'EIFL';
        }
        
        //Check whether Applicable List is NULL & EIFL is unchecked.
        if(applicableListValue == Null && eIFLValue == False){
              countryApplicableListValue = '';
        }
        
        return countryApplicableListValue;
    }  
}