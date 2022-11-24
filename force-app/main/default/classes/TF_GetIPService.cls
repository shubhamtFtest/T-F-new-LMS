@RestResource(urlMapping='/v1/ips/*')
global class TF_GetIPService {
    
    // ------ Response object definition ----
    
    global class IPResponse {
        public Map<String,Object> metadata = new Map<String,Object>();
        public List<End_User_Access__c> data;
        
        public void success(List<End_User_Access__c> data, String message){
            metadata.put('status','success');
            metadata.put('message', message);
            this.data = data;            
        }
        
        public void error(List<End_User_Access__c> data,Object exceptionDetails){
            metadata.put('status','failure');
            metadata.put('message', exceptionDetails);
            this.data = data;
        } 
        
        public void clear(){
            metadata.clear();
        }        
    }
    
    @HttpGet
    global static void doGet() {
        Object result;
        String uri = String.valueOf(RestContext.request.requestURI); 
        String partyid = uri.substring(uri.lastIndexOf('/')+1);
        result = getIPInfoByPartyID(partyId);    
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(result));
        system.debug(JSON.serialize(result));
    }
    
    
    public static Object getIPInfoByPartyID(String partyId) {
        system.debug(partyId);
        List<End_User_Access__c> ipListResponse = new List<End_User_Access__c>();
        IPResponse response = new IPResponse();
        try {
            if(partyId != null) {
                Account account = [SELECT ID, NAME FROM ACCOUNT WHERE Customer_Id__c =: partyId ];
                if(account != null){
                    List<End_User_Access__c>  ipList = [SELECT Id, Name, Account__c,Description__c, Status__c, IP_Range__c, Type__c  FROM End_User_Access__c WHERE Account__c =: account.Id];            
                    if(ipList != null && ipList.size() > 0){
                    	for(End_User_Access__c thisIP : ipList){
                        	if(thisIP.IP_Range__c != null){
								String ipStart = (thisIP.IP_Range__c).substringBefore(':');
								String ipEnd = 	(thisIP.IP_Range__c).substringAfter(':');
								if(ipEnd == null || ipEnd == ''){
									ipEnd = ipStart;
                    			}
                                thisIP.IP_Range__c = ipStart + ':' + ipEnd;
                            }
                            ipListResponse.add(thisIP);
                    	}
                    	response.success(ipListResponse, 'SUCCSESS');   
                    }else{
                        response.error(null, 'No Ip associated found with provided partyId');
                    }
                    
                }else{
                    response.error(null, 'No account found with provided partyId');
                }
                
            }  else {
                response.error(null, 'Request does not have valid patyId');
            }            
        } catch(Exception ex){
            response.error(null,ex.getMessage());
            system.debug(ex.getMessage());
        }
        return response;        
    
	}
}