public class TF_LMS_OMS_Revenue_JSONCreation {
    
    public static String LMS_RevenueCalculation(String assetId){
        String RevenueJsonStr ='';
        
        List<Asset> assetDataList = new List<Asset>();
        assetDataList = [Select id,TF_Business_Model__c,TF_License_Type__c,TF_Subscription_End_Date__c,UsageEndDate,Product2Id,TF_Product_Type__c, AccountId,Account.Customer_Id__c, TF_OMS_Order_Id__c,InstallDate from Asset where id=:assetId];
        List<Order> orderDataList = new List<Order>();
        orderDataList = [Select Id, EffectiveDate, Total_Price__c from Order where Id =: assetDataList[0].TF_OMS_Order_Id__c];
        if(!assetDataList.isEmpty()){
            String ordEffDate = '';
            String OrdTotalPrice = '';
            
            if(!orderDataList.isEmpty()){
                ordEffDate = string.valueOf(orderDataList[0].EffectiveDate);
                OrdTotalPrice = string.valueOf(orderDataList[0].Total_Price__c);
            }
            RevenueJsonStr = '{ "orderType": "SALES", "channel": "UBX", "customerId": "'+assetDataList[0].Account.Customer_Id__c+'", "orderNumber": "'+assetDataList[0].TF_OMS_Order_Id__c+'", "orderDate": "'+ordEffDate+'", "orderPrice":"'+OrdTotalPrice+'", "productId": "'+assetDataList[0].Product2Id+'", "productType" : "'+assetDataList[0].TF_Product_Type__c+'", "startDate": "'+assetDataList[0].InstallDate+'", "endDate": "'+assetDataList[0].UsageEndDate+'", "licenseId": "'+assetDataList[0].Id+'", "licenseType": "'+assetDataList[0].TF_Business_Model__c+'", "licenseUpdateType": "'+assetDataList[0].TF_License_Type__c+'", "licenseUpdateEndDate": "'+assetDataList[0].TF_Subscription_End_Date__c+'" }';
        	system.debug('*****'+RevenueJsonStr);
        }
        return RevenueJsonStr;
    }
}