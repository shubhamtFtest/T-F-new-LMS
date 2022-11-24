public class TF_AG_OrderHistorySearchCtl {
    
    @AuraEnabled
    public static TF_AG_OrderHistorySearchJsonPush getOrderDataFromAPI(String selectedpage) {
        //User usr = [Select id,Username from User where Id = :UserInfo.getUserId()];
        //String username=usr.Username;
        String pageNumber=selectedpage;
        TF_PlatformExecuter  TAG = new TF_PlatformExecuter();
        String gettoken=TF_PlatformExecuter.generateAccessToken();
        system.debug('user info'+gettoken);
        User u=[Select BMIS_Account_Number__c From User Where user.profile.name='Agent Extranet Community User' and isActive=true and Id=:UserInfo.getUserId()];
        String accountID=u.BMIS_Account_Number__c;
        System.debug(accountID);
        TF_AG_OrderHistorySearchJsonPush bmisOrders= new TF_AG_OrderHistorySearchJsonPush();
        String jsonStr;
        String endpoint = 'https://api-uat.taylorandfrancis.com/v1/bmis/salesforce/ordersAndDues/'+accountID+'/us/'+pageNumber;
        HttpRequest bmisCallout = new HttpRequest();
        bmisCallout.setEndpoint(endpoint);
        bmisCallout.setMethod('GET'); 
        bmisCallout.setHeader('X-Bmis-Api-Version', '5');
        bmisCallout.setHeader('Authorization', 'idtoken '+getToken);
        Http httpCall = new Http();
        HttpResponse response;
        response = httpCall.send(bmisCallout);
        if(response.getStatusCode() == 200 && response.getStatus() == 'OK'){
            bmisOrders= (TF_AG_OrderHistorySearchJsonPush) System.JSON.deserialize(String.ValueOf(response.getBody()), TF_AG_OrderHistorySearchJsonPush.class);
            jsonStr=response.getBody();
        }
        System.debug('response='+response.getBody());
        return bmisOrders;
    }
    @AuraEnabled
    public static TF_AG_OrderHistorySearchJsonPush getOrderDetailData(String accountId,String orderId,String selectedpage){
       TF_AG_OrderHistorySearchJsonPush bmisOrders= new TF_AG_OrderHistorySearchJsonPush();
        try{
            TF_PlatformExecuter  TAG = new TF_PlatformExecuter();
            String gettoken=TF_PlatformExecuter.generateAccessToken();
            
            //https://api-uat.taylorandfrancis.com/v1/bmis/salesforce/ordersAndDuesDetail/C-S00086/TJ069959/us/1
            String endpoint = 'https://api-uat.taylorandfrancis.com/v1/bmis/salesforce/ordersAndDuesDetail/'+accountID+'/'+orderId+'/us/'+selectedpage;
            HttpRequest bmisCallout = new HttpRequest();
            bmisCallout.setEndpoint(endpoint);
            bmisCallout.setMethod('GET');
            bmisCallout.setHeader('X-Bmis-Api-Version', '5');
            bmisCallout.setHeader('Authorization', 'idtoken '+getToken);
            Http httpCall = new Http();
            HttpResponse response;
            response = httpCall.send(bmisCallout);
            if(response.getStatusCode() == 200 && response.getStatus() == 'OK'){
                bmisOrders= (TF_AG_OrderHistorySearchJsonPush) System.JSON.deserialize(String.ValueOf(response.getBody()), TF_AG_OrderHistorySearchJsonPush.class);
            }
            System.debug('body:='+response.getBody());
           
        }
        catch(Exception e){
            
        }
         return bmisOrders;
        
    }
}