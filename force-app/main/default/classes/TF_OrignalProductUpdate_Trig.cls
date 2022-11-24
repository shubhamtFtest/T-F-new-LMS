/*
 * Created By :Sidhant
 * Created date 9/24/2020
 * Created to Populate Orignal Isbn and Uk Price of an Reprint Product
 * Test class ztest_TF_OrignalProductUpdate_Trig 90%
 * */
public without sharing class TF_OrignalProductUpdate_Trig implements TriggerInterface_OLI.Runnable {
    public void run(TriggerInterface_OLI.Trig trig) {  
        map<String,Id> mapOpplineidIsbnmap=new map<String,Id>();
        map<String,pricebookentry> mapisbnwithId=new map<String,pricebookentry>();
        Id OppIdeId;
        Id devRecordTypeId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('T&F - India Reprint').getRecordTypeId();        
        if (trig.isbefore && trig.isInsert) {
            for(OpportunityLineitem oppObj : trig.newList) {
                mapOpplineidIsbnmap.put(oppObj.Global_ISBN__c,oppObj.Id);
                OppIdeId=oppObj.OpportunityId;
            }
            List<Opportunity> oppList=new list<Opportunity>();
            opplist=[select Id,recordtype.id from opportunity where id=:OppIdeId];
            if(opplist.size()>0){
                if(opplist[0].recordtype.id==devRecordTypeId){
                    if(mapOpplineidIsbnmap.size()>0){
                        for(pricebookentry pbe :[select id,product2Id,product2.productcode,unitprice,currencyisocode,pricebook2Id from pricebookentry 
                                                 where currencyisocode='GBP' and pricebook2Id='01s0Y00000832dD' and product2.productcode
                                                 in:mapOpplineidIsbnmap.keyset()]){
                                                     mapisbnwithId.put(pbe.product2.productcode,pbe);
                                                 }
                    }
                    for(OpportunityLineitem oppObj : trig.newList) {
                        oppObj.UK_ISBN__c=mapisbnwithId.get(oppObj.Global_ISBN__c).product2Id;
                        oppObj.UK_ISBN_Price__c=mapisbnwithId.get(oppObj.Global_ISBN__c).unitprice;
                    }
                }
            }
        }
    }
}