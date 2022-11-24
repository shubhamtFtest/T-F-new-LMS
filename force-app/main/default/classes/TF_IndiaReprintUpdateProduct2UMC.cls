global without sharing class TF_IndiaReprintUpdateProduct2UMC {
    
    @InvocableMethod
    public static void updateProductUMC(List<Id> lstId) {
        system.debug('lstId::'+lstId);      
        List<Product2> listProductToUpdate = new List<Product2>();
        if(null != lstId){
            List<OpportunityLineItem> olis = [Select Id, Product2Id, UMC__c, Date_of_Last_UMC__c, Popular_Format__c,
                                              Format_Width_mm__c, Format_Height_mm__c, Quantity, Version_Type__c,
                                              Text_Colour__c, Paper_Type_GSM__c, Customer_Quote__c From OpportunityLineItem where Id in :lstId];            
            for(OpportunityLineItem oliObj : olis) {
                Product2 productObj = new Product2();
                productObj.Id = oliObj.Product2Id;
                productObj.UMC__c = oliObj.UMC__c;
                productObj.Date_of_Last_UMC__c = oliObj.Date_of_Last_UMC__c;                
                productObj.Last_UMC_Popular_Formats__c = oliObj.Popular_Format__c;
                productObj.Last_UMC_Format_Width_mm__c = oliObj.Format_Width_mm__c;
                productObj.Last_UMC_Format_Height_mm__c = oliObj.Format_Height_mm__c;
                productObj.Last_UMC_Version_Type__c = oliObj.Version_Type__c;
                productObj.Last_UMC_Text_Colour__c = oliObj.Text_Colour__c;
                productObj.Last_UMC_Paper_Type__c = oliObj.Paper_Type_GSM__c;
                productObj.Last_UMC_Customer_Quote__c = oliObj.Customer_Quote__c;
                //productObj.Last_UMC_Quantity__c = oliObj.Quantity;               
                listProductToUpdate.add(productObj);
            }
            if(!listProductToUpdate.isEmpty()) {
                update listProductToUpdate;
            }            
        }
    }  
}