/*
Created by		: Syam Nukilla
Created Date	: 2020.03.12
Description		: Whenever a product is inserted or updated on the opportunity then check whether the incoming product family 
				  is in specified family list, if it is in specified family then update Opportunity fields Multi_year_deal__c = No,
				  Multi_Year_Deal_Start_Year__c = '', Multi_Year_Deal_End_Year__c =''
Test Class		: zTEST_Journals_Multi_Year_Deal_Product

Modified By Matthew Smith - 2022.01.20 (GRQ0253085) - Updating Non Renewal Products
*/
public class Journals_Multi_Year_Deal_Product_Trig implements TriggerInterface_OLI.Runnable {
    public void run(TriggerInterface_OLI.Trig trig) {
        if (trig.isAfter) {
            if(trig.isInsert || trigger.isUpdate || trig.isDelete){
                Set<String> oppIdSet = new Set<String>();
                Map<String,String> prodIdToOppIdMap = new Map<String,String>();
                List<String> specifiedProdFmlyList = new List<String>{'Classic Archive','Modern Archive','Digital products',
                    													'Article Pass','Classic Archive Upgrade','Modern Archive Upgrade'};
                // for differentiating either it is insert/update or delete context
                List<OpportunityLineItem> inputOLIlist = new List<OpportunityLineItem>(); 
                if(trig.isInsert || trigger.isUpdate){
                    inputOLIlist = trig.newList;// if the trigger context is insert/update then trig.newList will load into for loop. 
                }else{
                    inputOLIlist = trig.oldList;// if the trigger context is delete then trig.oldList will load into for loop.         
                }
                for(OpportunityLineItem oli:inputOLIlist){
                    prodIdToOppIdMap.put(oli.Product2Id,oli.OpportunityId); //mapping productId and opportunityId
                }
                //fetching products from prodIdToOppIdMap keys & specified family list and get OppId into oppIdSet.
                for(Product2 prod:[SELECT Id,Name,Family FROM Product2 
                                   WHERE Id IN :prodIdToOppIdMap.KeySet() AND Family IN :specifiedProdFmlyList AND Name != 'DATA MINING SERVICE FEE']){
                                       oppIdSet.add(prodIdToOppIdMap.get(prod.Id));
                }
                List<Opportunity> oppListToUpdate = new List<Opportunity>();
                //fetching the opportunities from oppIdSet and update Multi_year_deal__c field to 'No'.
                for(Opportunity opp:[SELECT Id,Multi_year_deal__c,Multi_Year_Deal_Start_Year__c,Multi_Year_Deal_End_Year__c,
                                             (SELECT Id from OpportunityLineItems
                                              WHERE Product2.Family IN:specifiedProdFmlyList) 
                                      FROM Opportunity WHERE Id IN : oppIdSet]){
                                         if(trig.isInsert || trig.isUpdate){
                                             opp.Multi_year_deal__c = 'No';
                                             opp.Multi_Year_Deal_Start_Year__c = '';
                                             opp.Multi_Year_Deal_End_Year__c ='';                     
                                             oppListToUpdate.add(opp);
                                         }
                                         else if(trig.isDelete){
                                             system.debug('opp.OpportunityLineItems.size'+opp.OpportunityLineItems.size());
                                             if(opp.OpportunityLineItems.size() == 0){ //this checks if any other oli exists with in specified prod family
												//if no oli exists with specified prod family update Multi_year_deal__c = 'No'
                                                 system.debug('no oli exists');
                                                 opp.Multi_year_deal__c = 'No';                    
                                                 oppListToUpdate.add(opp);
                                             }
                                         }
                }
                //updating the fields on Opportunity
                if(!oppListToUpdate.isEmpty()){
                    update oppListToUpdate;
                }
            }//end of insert/update or delete if 
        }// end of after trigger if
    } //end of run method
    
}