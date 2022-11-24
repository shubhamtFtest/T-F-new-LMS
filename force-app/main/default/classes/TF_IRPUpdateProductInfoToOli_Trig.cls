/*
** Tested by: zTEST_TF_IRPUpdateProductInfoToOli_Trig.cls
**
** Modified by Amit Kumar 21/10/2019
*/
public without sharing class TF_IRPUpdateProductInfoToOli_Trig implements TriggerInterface_OLI.Runnable {
    public void run(TriggerInterface_OLI.Trig trig) {
        if (trig.isAfter && trig.isInsert) {
            system.debug('inside TF_IRPUpdateProductInfoToOli_Trig trigger');            
            Set<ID> oliIds = new Set<ID>();
            Set<ID> productIds = new Set<ID>();
            map<id,id> mappordoli=new map<id,id>();
            map<id,product2> mapidprod=new map<id,product2>();
            map<id,product2> prodidProd=new map<id,product2>();

            String IRProductType;
            system.debug('trig.newList::'+trig.newList);
            for (Integer i=0;i<trig.newList.size();i++) {         
                if (trig.newList[i].UMC__c == null) {                 
                    productIds.add(trig.newList[i].Product2Id);
                    IRProductType = trig.newList[i].IR_Product_Type__c;
                    oliIds.add(trig.newList[i].Id);
                    mappordoli.put(trig.newList[i].Id,trig.newList[i].Product2Id);
                }
            }
            
            List<OpportunityLineItem> listOliToUpdate = new List<OpportunityLineItem>();
            Map<Id, List <OpportunityLineItem>> mapOli = new Map<Id, List <OpportunityLineItem>>();                        
        	List<Product2> productLst = [Select Id, UMC__c, Date_of_Last_UMC__c,Version_Type__c,Last_UMC_Popular_Formats__c,
                                         Last_UMC_Format_Width_mm__c,Last_UMC_Format_Height_mm__c,Last_UMC_Quantity__c,
                                         Last_UMC_Version_Type__c,Last_UMC_Text_Colour__c,Last_UMC_Paper_Type__c, 
                                         Last_UMC_Customer_Quote__c, Printed_Pages__c,Insert__c,Cover_color__c,Insert_Color__c,
                                         Insert_Paper__c, Last_Print_Pages__c,Cover_Paper__c, Extras__c, Printer_Name__c, Supply_Date__c, Lamination__c,
                                         Year_of_Print__c 
                                         FROM Product2 where Id in :productIds];
            for(product2 objp:productLst){
                prodidProd.put(objp.Id,objp);
                }
            for(opportunitylineitem oppli:[select id,product2Id from opportunitylineitem where id in: mappordoli.keyset()]){
                mapidprod.put(oppli.id,prodidProd.get(oppli.product2Id));
            }
            for(Id oliId : oliIds) {
                    OpportunityLineItem oliObj = new OpportunityLineItem();
                    oliObj.Id = oliId;
                    oliObj.UMC__c = mapidprod.get(oliObj.Id).UMC__c;
                    oliObj.Date_of_Last_UMC__c = mapidprod.get(oliObj.Id).Date_of_Last_UMC__c;                    
                    oliObj.Popular_Format__c = mapidprod.get(oliObj.Id).Last_UMC_Popular_Formats__c;
                    oliObj.Format_Width_mm__c = mapidprod.get(oliObj.Id).Last_UMC_Format_Width_mm__c;
                    oliObj.Format_Height_mm__c = mapidprod.get(oliObj.Id).Last_UMC_Format_Height_mm__c;                    
                    oliObj.Version_Type__c = mapidprod.get(oliObj.Id).Last_UMC_Version_Type__c;
                    oliObj.Text_Colour__c = mapidprod.get(oliObj.Id).Last_UMC_Text_Colour__c;
                    oliObj.Paper_Type_GSM__c = mapidprod.get(oliObj.Id).Last_UMC_Paper_Type__c;
                    oliObj.Extent__c = mapidprod.get(oliObj.Id).Last_Print_Pages__c;                   
                    oliObj.Insert__c = mapidprod.get(oliObj.Id).Insert__c;
                    oliObj.Cover_color__c = mapidprod.get(oliObj.Id).Cover_color__c;
                    oliObj.Insert_Color__c = mapidprod.get(oliObj.Id).Insert_Color__c;
                    oliObj.Insert_Paper__c = mapidprod.get(oliObj.Id).Insert_Paper__c;
                    oliObj.Cover_Paper__c = mapidprod.get(oliObj.Id).Cover_Paper__c;
                    oliObj.Extras__c = mapidprod.get(oliObj.Id).Extras__c; 
                    
                    oliObj.Printer_Name__c = mapidprod.get(oliObj.Id).Printer_Name__c;
                    oliObj.Supply_Date__c = mapidprod.get(oliObj.Id).Supply_Date__c;
                    oliObj.Lamination__c = mapidprod.get(oliObj.Id).Lamination__c;
                    oliObj.Year_of_Print__c = mapidprod.get(oliObj.Id).Year_of_Print__c;
                    
                    //if(IRProductType == 'Rerun'){
                    oliObj.Customer_Quote__c = mapidprod.get(oliObj.Id).Last_UMC_Customer_Quote__c;
                    //}
                    List <OpportunityLineItem> lstcnts = new List <OpportunityLineItem>();
                    lstcnts.add(oliObj);
                    if (!mapOli.containsKey(oliId)) {
                    	mapOli.put(oliId, lstcnts);
                    }
            }
            
            List<OpportunityLineItem> oliToUpdate = new List<OpportunityLineItem>();
            for (List<OpportunityLineItem> oliList : mapOli.values()) {
              oliToUpdate.addAll(oliList);
            }
            
            system.debug('list of OLIs To Update::'+oliToUpdate);
            if (oliToUpdate.size() > 0) {
                update oliToUpdate;  
            }                        
        }
    }
}