public class TF_IRPCreateOLIHistory {
    @InvocableMethod
    public static void sendCreateOLIHistoryNotification(List<Id> oliIds){
        for(Id oliId : oliIds) {
            sendCreateOLIHistoryNotification(oliId);
        }
    }
    
    @future (callout=true)
    public static void sendCreateOLIHistoryNotification(Id oliId) {
        system.debug('oliIdoliId::'+oliId);
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
                                                 MRP__c, Customer_Quote__c, Gross_Margin__c, Quantity, Global_ISBN__c, Extras__c, Insert__c,
                                                 Indian_Isbn__c, Reprint_Eligibility__c, Required_Version_Type__c, Product2.Name 
                                                 From OpportunityLineItem Where Id =:oliId LIMIT 1];        
            if(oliList.size() > 0) {
                OpportunityLineItem oliObj = oliList[0];            
                OLIHistory__c olihistoryObj = new OLIHistory__c(
                    OpportunityId__c = oliObj.OpportunityId,
                    OpportunityLineItemId__c = oliObj.Id, 
                    Popular_Formats__c	= oliObj.Popular_Format__c,
                    Format_Height_mm__c	= oliObj.Format_Height_mm__c,
                    Format_Width_mm__c	= oliObj.Format_Width_mm__c,                
                    Version_Type__c	= oliObj.Version_Type__c,
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
                    Quantity__c	= oliObj.Quantity,
                    Is_Approved_UMC__c	= true
                );
                system.debug('olihistoryObj::'+olihistoryObj);
                insert olihistoryObj;  // Insert oli histroy record                         
            }  
        }        
    }
}