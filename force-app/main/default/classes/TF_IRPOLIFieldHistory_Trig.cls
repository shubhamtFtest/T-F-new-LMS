/*
* This class changes create OLI history when umc,pric and customer quote will changed
* When setup in Trigger_Recordtype__c, it should be configured to only run for CAS
* 
* Created by Amit Kumar - 2020.02.20
** Tested by: zTEST_TF_IRPOLIFieldHistory_Trig.cls      100%
*/

public without sharing class TF_IRPOLIFieldHistory_Trig implements TriggerInterface_OLI.Runnable {
    public void run(TriggerInterface_OLI.Trig trig) {
        if (trig.isBefore && trig.IsUpdate) {
            if (trig.triggerSize == 1) {
                Id userId =UserInfo.getUserId();
                DateTime todayDate = datetime.now();
                List<OpportunityLineItem> oli = [SELECT Id, Quantity, UMC__c,MRP__c,Extent__c,Text_Colour__c,Customer_Quote__c,Version_Type__c,
                                                 QTY_Updated_By__c, QTY_Updated_Date__c,QTY_Previous_Value__c,
                                                 Extent_Updated_By__c, Extent_Updated_Date__c,Extent_Previous_Value__c,	
                                                 Color_Updated_By__c,Color_Updated_Date__c, Color_Previous_Value__c,	
                                                 UMC_Updated_By__c,UMC_Updated_Date__c,UMC_Previous_Value__c,	
                                                 MRP_Updated_By__c,MRP_Updated_Date__c,MRP_Previous_Value__c,	
                                                 Customer_Quote_Updated_By__c,Customer_Quote_Updated_Date__c,Customer_Quote_Previous_Value__c,	
                                                 Version_Type_Updated_By__c,Version_Type_Updated_Date__c, Version_Type_Previous_Value__c 
                                                 FROM OpportunityLineItem WHERE Id  =:trig.newList[0].Id];
                
                if (oli.size() > 0) {
                    if(trig.oldList[0].Quantity != trig.newList[0].Quantity){
                        trig.newList[0].QTY_Updated_By__c = userId;
                        trig.newList[0].QTY_Updated_Date__c = todayDate;
                        trig.newList[0].QTY_Previous_Value__c = oli[0].Quantity;                        
                    }
                    if(trig.oldList[0].Extent__c != trig.newList[0].Extent__c){
                        trig.newList[0].Extent_Updated_By__c = userId;	
                        trig.newList[0].Extent_Updated_Date__c = todayDate;	
                        trig.newList[0].Extent_Previous_Value__c = oli[0].Extent__c;                        
                    }
                    if(trig.oldList[0].Text_Colour__c != trig.newList[0].Text_Colour__c){
                        trig.newList[0].Color_Updated_By__c = userId;
                        trig.newList[0].Color_Updated_Date__c = todayDate;
                        trig.newList[0].Color_Previous_Value__c	= oli[0].Text_Colour__c;                        
                    }
                    if(trig.oldList[0].UMC__c != trig.newList[0].UMC__c){
                        trig.newList[0].UMC_Updated_By__c = userId;
                        trig.newList[0].UMC_Updated_Date__c = todayDate;
                        trig.newList[0].UMC_Previous_Value__c = oli[0].UMC__c;                        
                    }
                    if(trig.oldList[0].MRP__c != trig.newList[0].MRP__c){
                        trig.newList[0].MRP_Updated_By__c = userId;
                        trig.newList[0].MRP_Updated_Date__c = todayDate;
                        trig.newList[0].MRP_Previous_Value__c = oli[0].MRP__c;                        
                    }
                    if(trig.oldList[0].Customer_Quote__c != trig.newList[0].Customer_Quote__c){
                        trig.newList[0].Customer_Quote_Updated_By__c = userId;	
                        trig.newList[0].Customer_Quote_Updated_Date__c = todayDate;
                        trig.newList[0].Customer_Quote_Previous_Value__c = oli[0].Customer_Quote__c;                        
                    }
                    if(trig.oldList[0].Version_Type__c != trig.newList[0].Version_Type__c){
                        trig.newList[0].Version_Type_Updated_By__c = userId;
                        trig.newList[0].Version_Type_Updated_Date__c = todayDate;
                        trig.newList[0].Version_Type_Previous_Value__c = oli[0].Version_Type__c;                        
                    }   
                }                                
            }        	
        }        
    }   
}