@RestResource(urlMapping='/*/updateBP/*')
global class SAP_BP_Update_Service {
    
    global class Response{
        public String status;
        public String message;
        public SAP_BP_utl.BPResponseObject objectData;
        
        public Response(String status, String message, SAP_BP_utl.BPResponseObject objectData){
            this.status=status;
            this.message=message;
            this.objectData=objectData;
        }
    }    
    public static Response apiResponse;
    public static Boolean isSuccess;
    
    @HttpPut
    global static void doPut(){ 
        
        String responseData = processRequest(RestContext.request.requestBody != null ? RestContext.request.requestBody.toString() : null
                                                                        , RestContext.request.requestURI);
        apiResponse = (Response)JSON.deserialize(responseData, Response.Class);
        if(apiResponse != null && apiResponse.status == 'Error'){
            RestContext.response.statusCode = 400;
        }else{
            RestContext.response.statusCode = 200;
        }
        //Use the payload to run the method and pass the response back to the requestor. 
        RestContext.response.responseBody = Blob.valueOf(responseData);    
    }
    
    public static String processRequest(String jsonString, String URI){
        SAP_BP__c exRecord = new SAP_BP__c();
        System.debug('URI'+URI);
        try{
        	//Parse the JSON.     
        	SAP_BP_utl.addressWrapper addressData = (SAP_BP_utl.addressWrapper)JSON.deserialize(jsonString, SAP_BP_utl.addressWrapper.Class);
        	String bpNumber = URI.substringBetween('/','/updateBP');
        
        	
        	try{
                System.debug('exRecord'+bpNumber);
            	exRecord = [SELECT Id, Name FROM SAP_BP__c WHERE Name =: bpNumber];
                System.debug('exRecord'+exRecord);
        	} catch (exception ex) {
				apiResponse = new Response('Error : SAP BP Record not found ', ex.getMessage() , new SAP_BP_utl.BPResponseObject());         	
            }
            try{  
                if(addressData.accountId != null || addressData.accountId == ''){
                    exRecord.Account_Id__c = addressData.accountId;
                }
                if(addressData.addressLine1 != null || addressData.addressLine1 == ''){
                    exRecord.address_line1__c = addressData.addressLine1;
                }
                if(addressData.addressLine2 != null || addressData.addressLine2 == ''){
                    exRecord.address_line2__c = addressData.addressLine2;
                }
                if(addressData.addressLine3 != null || addressData.addressLine3 == ''){
                    exRecord.address_line3__c = addressData.addressLine3;
                }
                if(addressData.city != null || addressData.city == ''){
                    exRecord.City__c = addressData.city;
                }
                if(addressData.state != null || addressData.state == ''){
                    exRecord.State__c = addressData.state;
                }
                if(addressData.country != null || addressData.country == ''){
                    exRecord.Country__c = addressData.country;
                }
                if(addressData.postalCode != null || addressData.postalCode == ''){
                    exRecord.ZIP__c = addressData.postalCode;
                }
                if(addressData.status != null ){
                    exRecord.Status__c = addressData.status;
                }
                if(addressData.source != null || addressData.source == ''){
                   exRecord.Source__c = addressData.source;
                }
                if(addressData.emailAddress != null || addressData.emailAddress == ''){
                    exRecord.Email__c = addressData.emailAddress;
                }
                if(addressData.firstName != null || addressData.firstName == ''){
                    exRecord.First_Name__c = addressData.firstName;
                }
                if(addressData.lastName != null || addressData.lastName == ''){
                    exRecord.Last_Name__c = addressData.lastName;
                }
                if(addressData.addressUseType != null || addressData.addressUseType == ''){
                    exRecord.Address_Type__c = addressData.addressUseType;
                }
                if(addressData.bpBusinessPartnerCategory != null || addressData.bpBusinessPartnerCategory == ''){
                    exRecord.Category__c = addressData.bpBusinessPartnerCategory;
                }
                if(addressData.taxNumberCategory != null || addressData.taxNumberCategory == ''){
                    exRecord.Tax_Number_Category__c = addressData.taxNumberCategory;
                }
                if(addressData.taxRegistrationNumber != null || addressData.taxRegistrationNumber == ''){
                    exRecord.Tax_Registration_Number__c = addressData.taxRegistrationNumber;
                }
                if(addressData.telephone != null || addressData.telephone == ''){
                    exRecord.Telephone__c = addressData.telephone;
                }
            	update exRecord;
                System.debug('rec updated');
                 List<SAP_BP__c> sbpRecordList = [SELECT Id, Street__c,Source__c,Tax_Number_Category__c,Email__c,Tax_Registration_Number__c,Last_Name__c,City__c,State__c,Status__c,Country__c,ZIP__c,First_Name__c,Address_Type__c,Name FROM SAP_BP__c where Name=: bpNumber];
                
                apiResponse = new Response('Success', 'BP_RECORD_UPDATED', 
                                               new SAP_BP_utl.BPResponseObject(
                                                   sbpRecordList[0].Id, '', sbpRecordList[0].Street__c, '', '', sbpRecordList[0].City__c,sbpRecordList[0].State__c,sbpRecordList[0].Country__c,
                                                   '', sbpRecordList[0].ZIP__c, sbpRecordList[0].Address_Type__c, '',sbpRecordList[0].First_Name__c, sbpRecordList[0].Last_Name__c, //lastName
                                                   '', sbpRecordList[0].Email__c,'', sbpRecordList[0].Name,'', '', sbpRecordList[0].Tax_Registration_Number__c, sbpRecordList[0].Tax_Number_Category__c, sbpRecordList[0].Source__c, sbpRecordList[0].Address_Type__c //addressUseType. 
                                               )
                                              );
                } catch (exception e) {
                    apiResponse = new Response('Error', e.getMessage() , new SAP_BP_utl.BPResponseObject()); 
                }
                
            }catch(Exception ex){
    		apiResponse = new Response('Error', ex.getMessage() , new SAP_BP_utl.BPResponseObject());  

    	}
        return JSON.serialize(apiResponse);
        } 
}