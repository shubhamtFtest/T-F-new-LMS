public class TF_AddIPRangesCallout{
    public class AddIPResponse {        
        public Metadata metadata ;
        public Data data ;
    }
    public class Metadata {        
        public String status ;
        public String message ;
    }
    public class Data {        
        public Integer validIPCounts ;
        public Integer inValidIPCounts ;
        public Range[] inValidIPRanges;
        public Range[] validIPRanges;
        public Integer existingIpRangesCount ;
        public Range[] existingIpRanges;
    }
    public class  Range{  
        public String ip_access_control_id ; 
        public String ip_start;
        public String ip_end ;  
        public String access_type ;
        public Integer ip_type_id ;     
        public String party_id ;
        public String description ; 
    }
    
    public static void getCalloutResponseContents(String partyId, String accId) {
        List<End_User_Access__c> ipList = [Select Account__c,Description__c,Id,Status__c,Name,IP_Range__c FROM End_User_Access__c WHERE Account__c =: accId ];
        if(ipList != null && ipList.size() > 0){
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            String uri = (String) orgSpecificProps.get('Add_IP_List_URL__c');
            String methodType = 'POST';
            Map<String, String> headers = new Map<String,String>();
            headers.put('Content-Type', 'application/json');
            try {
                String body = getRequestBody(partyId, ipList);
                System.debug('RequestBody :'+body);
                if(body != null){
                    HttpResponse response = new HttpResponse();
                    if ( String.isNotBlank(uri) ) {
                        response = TF_PlatformExecuter.execute(uri+partyId+'/ips', methodType, 'idtoken', body, headers, false);
                    }
                    System.debug('response =====>' + response + 'body--->'+response.getBody() + 'header : '+response.getHeader('Location'));            
                    if(response.getStatusCode() == 200 && Test.isRunningTest()){
                        AddIPResponse addIPResponse = (AddIPResponse) JSON.deserialize(response.getBody(), AddIPResponse.class);
                        if(addIPResponse.data.existingIpRanges != null && (addIPResponse.data.existingIpRanges).size() > 0){
                            String emailBody;
                            for(Range inValidRange : addIPResponse.data.existingIpRanges){
                                emailBody = 'ip_start : ' + inValidRange.ip_start + ' ip_end : ' + inValidRange.ip_end + ' This ip is already associated with an organisation having party id :' + inValidRange.party_id;
                            }
                            String emailAddress = UserInfo.getUserEmail();
                            System.debug('Email address: ' +emailAddress);
                            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                            message.toAddresses = new String[] { emailAddress};
                            //message.optOutPolicy = 'FILTER';
                            message.subject = 'Add IP Error';
                            message.plainTextBody = 'The following IP was not added to IPMS due to an error : ' + emailBody;
                            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                            if (results[0].success){
                                System.debug('The email was sent successfully.');
                            } else{
                                System.debug('The email failed to send: ' + results[0].errors[0].message);
                            }
                        }
                	}
                }
            }catch ( Exception ex ) {
                System.debug('*********** Exception :' + ex.getMessage());
            }   
        } 
    }
    
    public static String getRequestBody(String partyId,List<End_User_Access__c> ipList){ 
        String requestBody = '{"party_id": '+ partyId +',"country_code": "string","created_by": "string","ips": [';
        for(End_User_Access__c thisIP : ipList){
            String ipStart = (thisIP.IP_Range__c).substringBefore(':');
            String ipEnd = (thisIP.IP_Range__c).substringAfter(':');
            if(ipStart != null){
                String description = null;
                if(thisIP.Description__c != null){
                    description = thisIP.Description__c;
                }
                requestBody = requestBody + '{"access_type": "allow","description": "'+description+'","ip_start": "' + ipStart;
            }
            if(ipEnd != null && String.isNotBlank(ipEnd)){
                requestBody = requestBody + '","ip_end": "' + ipEnd + '","ip_type_id": "1"},';
            }else{
                requestBody = requestBody + '","ip_end": "' + ipStart + '","ip_type_id": "1"},';
            }

        }
        requestBody = requestBody.substring(0,requestBody.length()-1) + ']}';
        return requestBody;
    }
}