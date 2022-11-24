public class TF_AG_OrderSearchCtr {
    
        public static string userId{get;set;}
        public static string BmisAccountNumber{get;set;}
        public TF_AG_OrderSearchCtr(){
            
        }
        @AuraEnabled  
        public static String getDetails() {
            String runningUserId='';
            system.debug('@@@'+userinfo.getUserId());
            Profile pfile = [Select id,Name from Profile where Id =: userinfo.getProfileid()];
            if(pfile.Name == 'Agent Extranet Community User'){
                runningUserId= UserInfo.getUserId(); 
            }
            return runningUserId;
        }
        @AuraEnabled
        public static TF_AG_OrderSearchDataWrapper getOrderDetails(String ToDate,String FromDate,String orderDirection,String orderBy){
            
            userId = getDetails();
            if(String.isBlank(userId)){
                system.debug(userId);
                return null;
            }
            
            String BmisAccountNumber = getBMISAccountNumber(userId);
           
            String endpoint = '';
            BMIS_Setting__c BMISsetting = BMIS_Setting__c.getOrgDefaults();
              String getToken;
                TF_PlatformExecuter  TAG = new TF_PlatformExecuter();
                getToken=TF_PlatformExecuter.generateAccessToken();
                
                if (BMISsetting != null) { 
                    endpoint = (String) BMISsetting.get('Order_Search_EndPoint__c');
                }
                endpoint += BmisAccountNumber+'/us/1?';
                if(string.isNotBlank(FromDate)||string.isNotBlank(ToDate))
                {  
                    if(string.isNotBlank(FromDate))
                    {
                     endpoint +='orderDateFrom=';
                     endpoint +=FromDate;
                    }
                    if(string.isNotBlank(ToDate))
                    {
                     endpoint +='&orderDateTo=';
                     endpoint +=ToDate;
                    }
                }
                endpoint +='&orderBy=';
                endpoint +=orderBy;
                endpoint +='&orderDirection=';
                endpoint += orderDirection;
                HttpRequest orderCallout = new HttpRequest();
                orderCallout.setEndpoint(endpoint);
                orderCallout.setMethod('GET');
                orderCallout.setHeader('X-Bmis-Api-Version', '5');
                orderCallout.setHeader('Authorization', 'idtoken '+getToken);
                Http httpCall = new Http();
                HttpResponse response;
                response = httpCall.send(orderCallout);
                system.debug(response.getStatusCode());
                system.debug('@@@'+endpoint);
                TF_AG_OrderSearchDataWrapper OrderSearchDataWrapper;
                if(response.getStatusCode() == 200 && response.getStatus() == 'OK'){
                    OrderSearchDataWrapper = (TF_AG_OrderSearchDataWrapper)JSON.deserialize(response.getBody(), TF_AG_OrderSearchDataWrapper.class);
                    return OrderSearchDataWrapper;
                }
                return null;
         }
        public static string getBMISAccountNumber(string userid){
            try
            {
                if(String.isNotBlank(userId)){
                    User usr=[Select Id,email,contact.email,user.profile.name,BMIS_Account_Number__c From User Where Id=:userId];
                    BmisAccountNumber=usr.BMIS_Account_Number__c;
                    return BmisAccountNumber;
                }
            }
            catch(Exception e){
                system.debug(e.getMessage());
            }
            return null;
        }
        @AuraEnabled
        public static TF_AG_OrdersWrapper getOrderData(String OrderId){
              userId = getDetails();
            if(String.isBlank(userId)){
                system.debug(userId);
                return null;
            }
            String Order = OrderId;
            BmisAccountNumber = getBMISAccountNumber(userId);
            BMIS_Setting__c BMISsetting = BMIS_Setting__c.getOrgDefaults();
            String endpoint = (String) BMISsetting.get('order_data_endpoint__c');
            endpoint +=BmisAccountNumber+'/';
            endpoint +=Order+'/us/1';
            String getToken;
            TF_PlatformExecuter  TAG = new TF_PlatformExecuter();
            getToken=TF_PlatformExecuter.generateAccessToken();
            HttpRequest orderCallout = new HttpRequest();
            system.debug('@@@'+endpoint);
            orderCallout.setEndpoint(endpoint);
            orderCallout.setMethod('GET');
            orderCallout.setHeader('X-Bmis-Api-Version', '5');
            orderCallout.setHeader('Authorization', 'idtoken '+getToken);
            Http httpCall = new Http();
            HttpResponse response;
            response = httpCall.send(orderCallout);
            TF_AG_OrdersWrapper OrderDetailsDataWrapper = new TF_AG_OrdersWrapper();
            if(response.getStatusCode() == 200 && response.getStatus() == 'OK'){
            OrderDetailsDataWrapper=(TF_AG_OrdersWrapper)JSON.deserialize(response.getBody(),TF_AG_OrdersWrapper.class);
                system.debug('@@@@@@'+OrderDetailsDataWrapper);
            return OrderDetailsDataWrapper;
            }    
            return null;
        }
    }