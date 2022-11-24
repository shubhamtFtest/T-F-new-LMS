public without sharing class TF_IndiaReprintOne_Trig implements TriggerInterface_OLI.Runnable {
    public void run(TriggerInterface_OLI.Trig trig) {        
        system.debug('@@@@Inside TF_IndiaReprintOne_Trig');
        Id id1 = UserInfo.getProfileId();
        profile prodprofilechek=[select name from profile where id=:id1];
        IndiaReprintSettings__c IRSettings = IndiaReprintSettings__c.getOrgDefaults();
        Decimal CSDCoversionRate =(Decimal) IRSettings.get('Customer_Quote_Conversion_Rate__c');                            
        Decimal MRPConversionRate =(Decimal) IRSettings.get('MRP_Conversion_Rate__c');   
        List<OpportunityLineItem> oliToUpdateLst = new List<OpportunityLineItem>(); 
        List<OpportunityLineItem> oliToInsertLst = new List<OpportunityLineItem>();
        List<Id> oliIds = new List<Id>();
        for(integer i=0; i < trig.triggerSize; i++) {
            if (trig.isAfter) {
                //after OLI insert
                if (trig.isInsert) {
                    if((trig.newList[i].IR_Product_Type__c == 'Rerun')) {
                        oliToInsertLst.add(new OpportunityLineItem(Id = trig.newList[i].Id, MRP__c = trig.newList[i].UnitPrice));
                    }                
                }
                
                //after OLI update
                if (trig.isUpdate) {
                    
                    //if UMC is changed
                    if((trig.oldList[i].UMC__c > 0 || trig.newList[i].UMC__c > 0) && (trig.oldList[i].UMC__c != trig.newList[i].UMC__c) ) {
                        system.debug(trig.newList[i].UMC__c+'UMC is changed'+trig.oldList[i].UMC__c);
                        OpportunityLineItem oliObj = new OpportunityLineItem();
                        oliObj.Id = trig.newList[i].Id;
                        oliObj.Date_of_Last_UMC__c = Date.today();
                        if(prodprofilechek.Name=='India Reprint Production'){
                        oliObj.Status__c = 'UMC Entered';          
                        }
                        if(trig.newList[i].IR_Product_Type__c == 'New') { 
                            Decimal mrp = trig.newList[i].UMC__c*6*MRPConversionRate;
                            Decimal customerQuote = (mrp*0.4)/CSDCoversionRate;                             
                            oliObj.Customer_Quote__c = customerQuote;
                            Decimal gm = customerQuote/trig.newList[i].UMC__c;                         
                            Decimal roundedMrp = TF_IndiaReprintRoundOfMRP.getRoundOfMRP(mrp, gm);
                            oliObj.MRP__c = roundedMrp;                           
                        }                        
                        oliToUpdateLst.add(oliObj); 
                    }
                    
                    //if MRP is changed
                    if((trig.oldList[i].MRP__c > 0) && (trig.oldList[i].MRP__c != trig.newList[i].MRP__c)) {
                        OpportunityLineItem oliObj = new OpportunityLineItem();
                        oliObj.Id = trig.newList[i].Id;
                        oliObj.Status__c = 'Pricing Entered';                        
                        if(trig.newList[i].Do_Not_Update_Customer_Quote__c == false){                                                        
                            oliObj.Customer_Quote__c = (trig.newList[i].MRP__c *0.4)/CSDCoversionRate;                           
                        }                        
                        oliToUpdateLst.add(oliObj); 
                    }                 
                }
            }
        }

        if(oliToInsertLst.size() > 0) {
            update oliToInsertLst;
            
        }
        
        if(oliToUpdateLst.size() > 0) {
            update oliToUpdateLst;            
        }  
        
        Set<Id> Ids = new Set<Id>();
        for (OpportunityLineItem oliobj : oliToUpdateLst) {
            Ids.add(oliobj.Id);  
        }
        
        //system.debug('oliToInsertLst::'+oliToInsertLst);
        //system.debug('oliToUpdateLst::'+oliToUpdateLst);
        
        if(Ids.size() > 0){
            TF_IRPOLIHistory_Utils.createOLIHistory(Ids); 
        }
    }
}