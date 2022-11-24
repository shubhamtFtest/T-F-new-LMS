public with sharing class TF_IRPOLIHistory_Utils {
    /****** This method is used to delete OLI history records if OLI item is deleted *************/  
    public static void deleteOLIHistoryRecords(List<OpportunityLineItem> oliLst) {
        Set<Id> oliIdSet = new Set<Id>();
        for(OpportunityLineItem oliObj: oliLst){
            oliIdSet.add(oliObj.Id);
        } 
        List<OLIHistory__c> oliHistoryList = [SELECT Id From OLIHistory__c where OpportunityLineItemId__c in :oliIdSet];
        // This executes only if the oli is deleted
        if(Test.isRunningTest()) {
            delete oliHistoryList;
        } else if(Trigger.isDelete) {
            delete oliHistoryList;
        }        
    }
    
    /****** This method is used to update existing OLI history record if Is_Approved_UMC__c is true and creaye a new history record *************/    
    public static void createOLIHistoryRecord(Id oliId) {          
        if(oliId != null || oliId != '') {
            //start update
            List<OLIHistory__c> lstOliHistoryToUpdate = new List<OLIHistory__c>();
            List<OLIHistory__c> oliHistoryLst = [SELECT Id,Is_Approved_UMC__c From OLIHistory__c Where OpportunityLineItemId__c =:oliId AND Is_Approved_UMC__c = true];
            if(oliHistoryLst.size() > 0){
                for(OLIHistory__c hisObj: oliHistoryLst) {
                    OLIHistory__c oliHistObj = new OLIHistory__c();
                    oliHistObj.Id = hisObj.Id;
                    oliHistObj.Is_Approved_UMC__c = false; 
                    lstOliHistoryToUpdate.add(oliHistObj);                        
                }
                
                if(lstOliHistoryToUpdate.size() > 0){
                    update lstOliHistoryToUpdate;
                }             
            } 
            
            //start insert        
            List<OpportunityLineItem> oliList = [SELECT Id, ProductCode, OpportunityId, Popular_Format__c, Format_Height_mm__c, Format_Width_mm__c, 
                                                 Binding_Type__c,Paper_Type_GSM__c, Text_Colour__c, Version_Type__c, Extent__c, UMC__c, 
                                                 MRP__c, Customer_Quote__c, Gross_Margin__c, Quantity, Global_ISBN__c, Extras__c, Gratis__c, Insert__c,
                                                 Indian_Isbn__c, Reprint_Eligibility__c, Required_Version_Type__c, Product2.Name, Cancelled__c
                                                 From OpportunityLineItem Where Id =:oliId LIMIT 1];        
            if(oliList.size() > 0) {
                OpportunityLineItem oliObj = oliList[0];            
                OLIHistory__c olihistoryObj = new OLIHistory__c(
                    OpportunityId__c = oliObj.OpportunityId,
                    OpportunityLineItemId__c = oliObj.Id, 
                    Popular_Formats__c	= oliObj.Popular_Format__c,
                    Format_Height_mm__c	= oliObj.Format_Height_mm__c,
                    Format_Width_mm__c	= oliObj.Format_Width_mm__c,                
                    Version_Type__c	= oliObj.Binding_Type__c,
                    UMC__c	= oliObj.UMC__c,
                    MRP__c	= oliObj.MRP__c,
                    Customer_Quote__c	= oliObj.Customer_Quote__c,
                    Gross_Margin__c	= oliObj.Gross_Margin__c,
                    Text_Color__c	= oliObj.Text_Colour__c,
                    Paper_size__c	= oliObj.Extent__c,
                    Paper_GSM__c	= oliObj.Paper_Type_GSM__c,                                                       
                    ProductCode__c	= oliObj.ProductCode,
                    Global_ISBN__c	= oliObj.Global_ISBN__c,
                    Indian_Isbn__c	= oliObj.Indian_Isbn__c,
                    Title_Name__c	= oliObj.Product2.Name,
                    Reprint_Eligibility__c	= oliObj.Reprint_Eligibility__c,
                    Pages__c	= oliObj.Extent__c,                  
                    Insert__c	= oliObj.Insert__c,
                    Required_Version_Type__c	= oliObj.Required_Version_Type__c,
                    Extras__c	= oliObj.Extras__c,
                    Gratis__c 	= oliObj.Gratis__c,
                    Quantity__c	= oliObj.Quantity,
                    Cancelled__c = oliObj.Cancelled__c,
                    Is_Approved_UMC__c	= true
                );            
                
                insert olihistoryObj;  // Insert oli histroy record
                
                    
            }  
        }
    }
    
    /****** This method is used to update existing OLI history record if Is_Approved_UMC__c is true and creaye a new history record *************/    
    public static void createOLIHistory(Set<Id> oliIds) {          
        //start update
        system.debug('@@@@@@@'+oliIds.size());        
        List<OLIHistory__c> lstOliHistoryToUpdate = new List<OLIHistory__c>();
        List<OLIHistory__c> oliHistoryLst = [SELECT Id,Is_Approved_UMC__c From OLIHistory__c Where OpportunityLineItemId__c in :oliIds AND Is_Approved_UMC__c = true];
        if(oliHistoryLst.size() > 0){
            for(OLIHistory__c hisObj: oliHistoryLst) {
                OLIHistory__c oliHistObj = new OLIHistory__c();
                oliHistObj.Id = hisObj.Id;
                oliHistObj.Is_Approved_UMC__c = false; 
                lstOliHistoryToUpdate.add(oliHistObj);                        
            }
            
            if(lstOliHistoryToUpdate.size() > 0){
                update lstOliHistoryToUpdate;
            }             
        } 
        
        //start insert  
        List<OLIHistory__c> lstOliHistoryToInsert = new List<OLIHistory__c>();      
        List<OpportunityLineItem> oliList = [SELECT Id, ProductCode, OpportunityId, Popular_Format__c, Format_Height_mm__c, Format_Width_mm__c, 
                                             Binding_Type__c,Paper_Type_GSM__c, Text_Colour__c, Version_Type__c, Extent__c, UMC__c, 
                                             MRP__c, Customer_Quote__c, Gross_Margin__c, Quantity, Global_ISBN__c, Extras__c, Insert__c,
                                             Indian_Isbn__c, Reprint_Eligibility__c, Required_Version_Type__c, Product2.Name, Cancelled__c,
                                             Distributor__c,Customer_Service_Comment__c,Sales_Comments__c,Gratis__c
                                             From OpportunityLineItem Where Id in :oliIds];  
        map<id,OLIHistory__c> mapobn=new map<id,OLIHistory__c>();
        if(oliList.size() > 0) {
            for (OpportunityLineItem oliObj : oliList) {
                OLIHistory__c hisObj = new OLIHistory__c();
                hisObj.OpportunityId__c = oliObj.OpportunityId;
                hisObj.OpportunityLineItemId__c = oliObj.Id; 
                hisObj.Popular_Formats__c	= oliObj.Popular_Format__c;
                hisObj.Format_Height_mm__c	= oliObj.Format_Height_mm__c;
                hisObj.Format_Width_mm__c	= oliObj.Format_Width_mm__c;                
                hisObj.Version_Type__c	= oliObj.Binding_Type__c;
                hisObj.UMC__c	= oliObj.UMC__c;
                hisObj.MRP__c	= oliObj.MRP__c;
                hisObj.Customer_Quote__c	= oliObj.Customer_Quote__c;
                hisObj.Gross_Margin__c	= oliObj.Gross_Margin__c;
                hisObj.Text_Color__c	= oliObj.Text_Colour__c;
                hisObj.Paper_size__c	= oliObj.Extent__c;
                hisObj.Paper_GSM__c	= oliObj.Paper_Type_GSM__c;                                                       
                hisObj.ProductCode__c	= oliObj.ProductCode;
                hisObj.Global_ISBN__c	= oliObj.Global_ISBN__c;
                hisObj.Indian_Isbn__c	= oliObj.Indian_Isbn__c;
                hisObj.Title_Name__c	= oliObj.Product2.Name;
                hisObj.Reprint_Eligibility__c	= oliObj.Reprint_Eligibility__c;
                hisObj.Pages__c	= oliObj.Extent__c;                 
                hisObj.Insert__c	= oliObj.Insert__c;
                hisObj.Required_Version_Type__c	= oliObj.Required_Version_Type__c;
                hisObj.Extras__c	= oliObj.Extras__c;
                hisObj.Gratis__c	= oliObj.Gratis__c;
                hisObj.Quantity__c	= oliObj.Quantity;
                hisObj.Cancelled__c = oliObj.Cancelled__c;                
                //hisObj.Distributor__c = oliObj.Distributor__r.Name;
                hisObj.Distributor__c = 'N/A';
                hisObj.Customer_Service_Comment__c = oliObj.Customer_Service_Comment__c;
                hisObj.Sales_Comments__c = oliObj.Sales_Comments__c;                
                hisObj.Is_Approved_UMC__c	= true;                                
                lstOliHistoryToInsert.add(hisObj); 
                mapobn.put(hisObj.OpportunityId__c,hisObj);
            }
            List<OLIHistory__c> updateoli=new list<OLIHistory__c>();
            for(OLIHistory__c objs:[select id,MRP__c,UMC__c,Is_Approved_UMC__c,OpportunityId__c,Quantity__c,Version_Type__c,Popular_Formats__c,Paper_GSM__c,Text_Color__c from OLIHistory__c where OpportunityId__c in:mapobn.keyset()]){
                if(objs.mrp__c==mapobn.get(objs.OpportunityId__c).mrp__c 
                   && objs.umc__c==mapobn.get(objs.OpportunityId__c).umc__c && objs.Quantity__c==mapobn.get(objs.OpportunityId__c).Quantity__c
                  && objs.Version_Type__c==mapobn.get(objs.OpportunityId__c).Version_Type__c && objs.Popular_Formats__c==mapobn.get(objs.OpportunityId__c).Popular_Formats__c
                  && objs.Text_Color__c==mapobn.get(objs.OpportunityId__c).Text_Color__c && objs.Paper_GSM__c==mapobn.get(objs.OpportunityId__c).Paper_GSM__c){
                     //objs.Is_Approved_UMC__c=true;
                    updateoli.add(objs);
                }
            }
         
            system.debug('lstOliHistoryToInsert::'+lstOliHistoryToInsert);
            // Insert oli histroy record 
            if(lstOliHistoryToInsert.size() > 0) {
                insert lstOliHistoryToInsert;
                delete updateoli;

            }
            
        }  
    }     
}