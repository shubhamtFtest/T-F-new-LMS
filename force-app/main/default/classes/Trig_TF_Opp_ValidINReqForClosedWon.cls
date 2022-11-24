//Tested by: zTestTrig_TF_Opp_ValidINReqForClosedWon.cls
//Created by Amit Kumar - 2018.07.17
//Service now ticket: CHG0043878

public with sharing class Trig_TF_Opp_ValidINReqForClosedWon implements TriggerInterface_Opp.Runnable {
    public void run(TriggerInterface_Opp.Trig trig) {
        if (trig.isUpdate && trig.isBefore) {                      
            Boolean isBooks;
            String msg = 'The invoice number on this opportunity does not contain the correct amount of characters.  Hint:- SAP(9 digit), PT(8 to 11 digits), Quickfill(6 digits).';            
            /*
    		0120Y000000Wn8YQAS //T&F eBooks Customer Opportunity (Direct)
            0120Y000000Wn9YQAS //T&F eBooks Consortium Opportunity (Direct)
            0120Y000000Wn9ZQAS //T&F eBooks Consortium Opportunity (Price Agreement)           
            */           
            Set<Id> EBOOK_RECORDTYPES = new Set<Id>{'0120Y000000Wn9Y','0120Y000000Wn9Z','0120Y000000Wn8Y'}; 
            isBooks = (EBOOK_RECORDTYPES.contains(trig.newList[0].recordTypeID)) ? true : false;
            if (trig.newList[0].StageName == 'Closed Won' && trig.oldList[0].StageName != 'Closed Won' && isBooks == true){
                List<OpportunityLineItem> OppLineItemList = [SELECT Id,ProductName__c,Product_Name__c,Invoice_Date__c,Invoice_Number__c,Invoice_System__c From OpportunityLineItem where OpportunityId = :trig.newList[0].Id];
                if (OppLineItemList.Size() > 0 ) {
                    for(OpportunityLineItem Oli: OppLineItemList){
                        String invoiceType = Oli.Invoice_System__c;
                        String invoiceNum = Oli.Invoice_Number__c;                       
                        if(invoiceNum == null){
                            trig.newList[0].addError(msg);
                            break;
                        }else {
                            if(invoiceType == 'SAP'){
                              	Pattern p = Pattern.compile('^[0-9]{9}'); 
                                Matcher pm = p.matcher(invoiceNum); 
                                if(!pm.matches()){
                                    trig.newList[0].addError(msg);
                                    break;
                                }                                
                            }else if(invoiceType == 'PT'){
                              	Pattern p = Pattern.compile('^[0-9]{8,11}');
                                Matcher pm = p.matcher(invoiceNum); 
                                if(!pm.matches()){
                                    trig.newList[0].addError(msg);
                                    break;
                                }                                
                            }else if(invoiceType == 'Quickfill'){
                              	Pattern p = Pattern.compile('^[0-9]{6}'); 
                                Matcher pm = p.matcher(invoiceNum); 
                                if(!pm.matches()){
                                    trig.newList[0].addError(msg);
                                    break;
                                }                                
                            }                                    
                        }
                    }                     
                }
            }
        }
    }
}