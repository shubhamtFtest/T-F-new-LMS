public class TF_CreateBusinessPartnerCallout {
    public static Error_Log_Items__c errorLogItemRecord;
    public class TF_CreateBusinessPartnerResponse {        
        public Metadata metadata ;
        public Data[] data ;
    }
    public class Metadata {        
        public Integer code ;
        public String timestamp ;
        public String details ;
    }
    public class Data {  
        public String externalCustomerAddressId ;
        public String businessPartnerNumber;
    }
    
    @future(callout=true)
    public static void getSAPBPNumberCallout(List<ID> newSAPBPIDList, String uniqueRecordKey, String jsonString, String reqURI){
		System.debug('testgetSAPBPNumberCallout');
    	List<SAP_BP__c> newSAPBPList = [Select Id, name,Street__c,address_line1__c,address_line2__c,address_line3__c,Telephone__c,Address_ID__c, Country__c,ZIP__c,City__c,Email__c,First_Name__c,Last_Name__c,Tax_Number_Category__c,Tax_Registration_Number__c,State__c, Account_Id__r.Name  from SAP_BP__c where Id IN:newSAPBPIDList];
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        String uri = (String)orgSpecificProps.get('BPNumber_Generation_Endpoint__c');
        Boolean isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        if(!isSandbox){
            uri = 'https://secure.taylorandfrancis.com/createbusinesspartner';
        }else{
            uri = 'https://secure-uat.taylorandfrancis.com/createbusinesspartner';
        }
        System.debug('newSAPBPList'+newSAPBPList);
        String methodType = 'POST';
        Map<String, String> headers = new Map<String,String>();
        Map<String, String> resultMap = new Map<String,String>();
        List<SAP_BP__c> sapBPWithBPNumberList = new List<SAP_BP__c>();
        
        headers.put('Content-Type', 'application/json');
        try{
            String body = getRequestBody(newSAPBPList);
            System.debug('RequestBody :'+body);
            if(body != null){
                HttpResponse response = new HttpResponse();
                if ( String.isNotBlank(uri) ) {
                    response = TF_PlatformExecuter.execute(uri, methodType, 'idtoken', body, headers, false);
                }
                System.debug('response =====>' + response + 'body--->'+response.getBody());            
                
                if ( response != null && response.getStatusCode() == 201 ) {
                    TF_CreateBusinessPartnerResponse createBPResponse = (TF_CreateBusinessPartnerResponse) JSON.deserialize(response.getBody(), TF_CreateBusinessPartnerResponse.class);
                    for(Data data : createBPResponse.data){
                        resultMap.put(data.externalCustomerAddressId, data.businessPartnerNumber);
                    }
                }else{
                    throw new SAP_BP_Service.Bad_Request_Exception(SAP_BP_Service.ERROR_SFDC_UNABLE_TO_SUBMIT_CREATE_BP);
                }
                if(resultMap != null &&  resultMap.size() > 0){
                    for(SAP_BP__c sapBP : newSAPBPList){
                        for(String addressID : resultMap.keySet()){
                            if(sapBP.Address_ID__c == addressID){
                                sapBP.Name = resultMap.get(addressID);
                                sapBPWithBPNumberList.add(sapBP);
                            }
                        }
                        
                    }
                    if(sapBPWithBPNumberList != null && sapBPWithBPNumberList.size() > 0){
                        update sapBPWithBPNumberList;
                    }
                }
            }
        }catch(Exception ex){
            ReprocessErrors_utl.createErrorLogItem(
                            uniqueRecordKey, //errorLogUniqueKey
                            jsonString, //jsonBody
                            reqURI, //RequestURI
                            system.now(), //errorDateTime
                            SAP_BP_Service.ERROR_SFDC_UNABLE_TO_SUBMIT_CREATE_BP + ' : '+ex.getmessage(), //errorDetails
                            'SAP BP Service Error', //errorType
                            'api', //typeOfError
                            errorLogItemRecord //existingErrorLogItemRecord
              ); 
        }
    }
    
    public static String getRequestBody(List<SAP_BP__c> newSAPBPList){
        String countryCode;
        Set<String> countryList = new Set<String>();
        String requestBody = '{"customers": [';
        if (newSAPBPList != null ){
            for(SAP_BP__c sapRec : newSAPBPList){
                countryList.add(sapRec.Country__c);
            }
            
            Country__c[] countryCodeList = [SELECT Country_2__c, Name FROM Country__c where Name IN:countryList];
            Map<String,String> countryCodeMap = new Map<String,String>();
            
            for(Country__c country : countryCodeList){
                countryCodeMap.put(country.name, country.Country_2__c);
            }
            
            for(SAP_BP__c thisSAPBP : newSAPBPList){
                if(thisSAPBP.address_line1__c  == null){
                    thisSAPBP.address_line1__c = '';
                }
                if(thisSAPBP.address_line2__c == null){
                    thisSAPBP.address_line2__c = '';
                }
                if(thisSAPBP.address_line3__c == null){
                    thisSAPBP.address_line3__c = '';
                }
                if(thisSAPBP.Country__c == null){
                    thisSAPBP.Country__c= '';
                }
                if(thisSAPBP.ZIP__c == null){
                    thisSAPBP.ZIP__c= '';
                }
                if(thisSAPBP.City__c == null){
                    thisSAPBP.City__c = '';
                }
                if(thisSAPBP.State__c == null){
                    thisSAPBP.State__c = '';
                }
                if(thisSAPBP.Telephone__c == null){
                    thisSAPBP.Telephone__c = '';
                }
                
                if(thisSAPBP.Tax_Registration_Number__c == null){
                    thisSAPBP.Tax_Registration_Number__c = '';
                }
                if(thisSAPBP.Tax_Number_Category__c == null){
                    thisSAPBP.Tax_Number_Category__c = '';
                }
                
                String body = '{"businessPartner": {"type": "ORGANIZATION"},"contactDetail": {"addressLine1": "'+thisSAPBP.address_line1__c+'","addressLine2": "'+thisSAPBP.address_line2__c+'","addressLine3": "'+thisSAPBP.address_line3__c+'","addressType": "billing","city": "'+thisSAPBP.City__c+'","state": "'+thisSAPBP.State__c+'","postalCode": "'+thisSAPBP.ZIP__c+'","country": "'+countryCodeMap.get(thisSAPBP.Country__c)+'","emailAddress": "'+thisSAPBP.Email__c+'","title": "","firstName": "'+thisSAPBP.First_Name__c+'","telephone":"'+thisSAPBP.Telephone__c +'","lastName": "'+thisSAPBP.Last_Name__c+'","location": "","organizationName1": "'+thisSAPBP.Account_Id__r.Name +'", "organizationName2": "","organizationName3": "","phoneNumber": "","region": "'+thisSAPBP.State__c+'"},"externalCustomerAddressId": "'+thisSAPBP.Address_ID__c+'","sourceSystemId": "TF-EBOOK","taxRegistrationNumber": "'+thisSAPBP.Tax_Registration_Number__c +'","taxType": "'+thisSAPBP.Tax_Number_Category__c +'"},';
                requestBody = requestBody + body;
                system.debug(requestBody); 
            }
            requestBody = requestBody.substring(0,requestBody.length()-1);
            
        } 
        requestBody = requestBody + ']}';
        return requestBody;
    }
}