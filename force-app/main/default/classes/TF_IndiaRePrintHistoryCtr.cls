public class TF_IndiaRePrintHistoryCtr {
    
    public class PagedResult {               
        @AuraEnabled
        public Integer total { get;set; }       
        @AuraEnabled
        public List<OLIHistory__c> products { get;set; }
    }  
    
    @AuraEnabled
    public static PagedResult getOLIHistories(String oppId) { 
        List<OLIHistory__c> prdLst = new List<OLIHistory__c>();
        PagedResult r =  new PagedResult();
        r.total = database.countQuery('SELECT count() FROM OLIHistory__c WHERE OpportunityLineItemId__c = \'%' + oppId + '%\'');       
        String qry = 'Select Id, OpportunityId__c, OpportunityLineItemId__c, UMC__c, Date_of_Last_UMC__c, MRP__c,CreatedDate,';
        qry+= 'Customer_Quote__c, Gross_Margin__c, Text_Color__c, Paper_size__c, Paper_GSM__c, Version_Type__c, Quantity__c, Is_Approved_UMC__c';
        qry+= ' From OLIHistory__c where OpportunityLineItemId__c = \'' + oppId + '\'';
        qry+= ' ORDER BY Id ASC';
        prdLst = Database.query(qry); 
        r.products = prdLst ;
        return r;
    }


    @AuraEnabled
    public static String updateOpportunityLineItemUMC(String historyId) {
        String msg = 'RECORD_NOT_FOUND';       
        if(String.isNotBlank(historyId)){
            List<OLIHistory__c> historyObj = [Select Id, OpportunityLineItemId__c, UMC__c, Date_of_Last_UMC__c, Is_Approved_UMC__c, 
                                              Text_Color__c, Paper_size__c, Paper_GSM__c, Version_Type__c, Quantity__c, Popular_Formats__c, 
                                              Format_Height_mm__c, Format_Width_mm__c
                                              From OLIHistory__c Where Id =:historyId LIMIT 1];
            if(historyObj.size() > 0){
                String oliId = historyObj[0].OpportunityLineItemId__c;                
                changeApprovalStatus(oliId, historyId);                
                //update opportunity line item object
                List<OpportunityLineItem> olis = [select Id,UMC__c,Popular_Format__c,Format_Height_mm__c,Format_Width_mm__c,Extent__c,Quantity,Version_Type__c,Text_Colour__c,Paper_Type_GSM__c from OpportunityLineItem where Id =:oliId LIMIT 1];
                if(olis.size() > 0){
                    olis[0].UMC__c = historyObj[0].UMC__c;                                        
                    olis[0].Popular_Format__c = historyObj[0].Popular_Formats__c;
                    olis[0].Format_Height_mm__c = historyObj[0].Format_Height_mm__c;
                    olis[0].Format_Width_mm__c = historyObj[0].Format_Width_mm__c;
                    olis[0].Version_Type__c = historyObj[0].Version_Type__c;
                    olis[0].Text_Colour__c = historyObj[0].Text_Color__c;
                    olis[0].Paper_Type_GSM__c = historyObj[0].Paper_GSM__c;
                    olis[0].Extent__c = historyObj[0].Paper_size__c;
					//olis[0].Quantity = historyObj[0].Quantity__c;                    
                    update olis;
                    msg = 'UPDATE_DONE';
                }
            }                        
        }
        return msg;
    } 
     @AuraEnabled
    public static String deleteOlihistory(String historyId) {
        String msg = 'UPDATE_DONE';       
        if(String.isNotBlank(historyId)){
            List<OLIHistory__c> historyObj = [Select Id, OpportunityLineItemId__c, UMC__c, Date_of_Last_UMC__c, Is_Approved_UMC__c, 
                                              Text_Color__c, Paper_size__c, Paper_GSM__c, Version_Type__c, Quantity__c, Popular_Formats__c, 
                                              Format_Height_mm__c, Format_Width_mm__c
                                              From OLIHistory__c Where Id =:historyId LIMIT 1];
            delete historyObj;
        }                        
        return msg;
    } 
    @AuraEnabled
    public static void changeApprovalStatus(Id oliId, Id historyId){
        if(String.isNotBlank(oliId) && String.isNotBlank(historyId)) {
            List<OLIHistory__c> lstToMakeTrue = new List<OLIHistory__c>();
            List<OLIHistory__c> lstToMakeFalse = new List<OLIHistory__c>();
            
            //change status as FALSE
            List<OLIHistory__c> olis = [select Id, Is_Approved_UMC__c from OLIHistory__c where OpportunityLineItemId__c =:oliId AND Is_Approved_UMC__c = true];
            for(OLIHistory__c hisObj: olis) {
                OLIHistory__c oliHistObjFalse = new OLIHistory__c();
                oliHistObjFalse.Id = hisObj.Id;
                oliHistObjFalse.Is_Approved_UMC__c = false; 
                lstToMakeFalse.add(oliHistObjFalse);                     
            }
            if(lstToMakeFalse.size() > 0){
                update lstToMakeFalse;                    
            }
            
            //change status as TRUE
            List<OLIHistory__c> oliLst = [select Id, Is_Approved_UMC__c from OLIHistory__c where Id =:historyId LIMIT 1];
            for(OLIHistory__c hisObj: oliLst) {
                OLIHistory__c oliHistObjTrue = new OLIHistory__c();
                oliHistObjTrue.Id = hisObj.Id;
                oliHistObjTrue.Is_Approved_UMC__c = true; 
                lstToMakeTrue.add(oliHistObjTrue);                     
            }
            if(lstToMakeTrue.size() > 0){
                update lstToMakeTrue;                    
            }            
        }
    }
    
    @AuraEnabled
    public static String updateOLIUMC(String oliId, Decimal umc) {
        String msg = 'RECORD_NOT_FOUND';       
        if(String.isNotBlank(oliId)){
            List<OpportunityLineItem> olis = [select id,UMC__c from OpportunityLineItem where Id =:oliId LIMIT 1];
            if(olis.size() > 0){
                olis[0].UMC__c = umc;
                update olis;
                msg = 'UMC_UPDATE_DONE';
            }
        }                       
        return msg;
    }    
}