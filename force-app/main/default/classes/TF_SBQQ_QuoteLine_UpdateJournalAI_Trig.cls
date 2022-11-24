public with sharing class TF_SBQQ_QuoteLine_UpdateJournalAI_Trig  implements TriggerInterface_SBQQ_QuoteLine.Runnable {

    public void run(TriggerInterface_SBQQ_QuoteLine.Trig trig) {
        if ( (trig.isInsert || trig.isUpdate) && trig.isAfter ) {
            Map<Id,SBQQ__Quote__c> quoteMap = new Map<Id,SBQQ__Quote__c>();
            List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
            SBQQ__Quote__c quoteObj = new SBQQ__Quote__c();
            if(!trig.newList.isEmpty()){
                /*Dt:16-06-2022 - Syam.N
				In order to populate journal values from parent product through quoteline 
				As part of FSD Deoployment
				*/
                Map<String,String> prodQLMap = new Map<String,String>();
                Map<String,Product2> quoteLineProdMap = new Map<String,Product2>();
                for(SBQQ__QuoteLine__c quoteLineRec : trig.newList){
                    prodQLMap.put(quoteLineRec.Parent_Product__c,quoteLineRec.Id);
                }
                if(prodQLMap.keySet() != null){
                    for(Product2 pdRec:[SELECT Id,Name,ProductCode,Sales_Organization__c,Product_Type__c,Open_Access_Category__c 
                                        FROM Product2 
                                        WHERE Id IN :prodQLMap.keySet()]){
                        quoteLineProdMap.put(prodQLMap.get(pdRec.Id),pdRec);
                    }
                }
                for(SBQQ__QuoteLine__c quoteLineObj : trig.newList){
                    quoteObj.Id = quoteLineObj.SBQQ__Quote__c;
                    if(!quoteLineProdMap.isEmpty()){
                        quoteObj.Journal__c = quoteLineProdMap.get(quoteLineObj.Id).Name;
                        quoteObj.Product_Code__c = quoteLineProdMap.get(quoteLineObj.Id).ProductCode;
                        quoteObj.Sales_Organization__c = quoteLineProdMap.get(quoteLineObj.Id).Sales_Organization__c;
                        quoteObj.Journal_Code__c = quoteLineProdMap.get(quoteLineObj.Id).ProductCode;
                        quoteObj.Product_Type__c = quoteLineProdMap.get(quoteLineObj.Id).Product_Type__c;
                        //quoteObj.Product_Open_Access_Category__c = quoteLineProdMap.get(quoteLineObj.Id).Open_Access_Category__c;
                    }
                    /*
                    quoteObj.Journal__c = quoteLineObj.quoteLineObj.SBQQ__ProductName__c;
                    quoteObj.Product_Code__c = quoteLineObj.quoteLineObj.SBQQ__ProductCode__c;
                    quoteObj.Sales_Organization__c = quoteLineObj.quoteLineObj.Sales_Organization__c;
                    */
					
                    quoteMap.put(quoteLineObj.SBQQ__Quote__c,quoteObj);
                }
            }
			 quoteList = quoteMap.values();
            if(!quoteList.isEmpty()){
                update quoteList;
            }
        }
    }

}