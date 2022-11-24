/***************************************************************************
* Created by: Tom Reed, 2019.12.20
* Tested By: zTest_SAP_BP_Service @ 98%
* **************************************************************************/

@RestResource(urlMapping='/*/generateBP/*')
global class SAP_BP_Service implements ReprocessErrors_Interface {
    
    public class Bad_Request_Exception extends Exception {}
    public static final String ERROR_PARTYID_NOT_RECOGNISED = 'PartyId missing from request/not recognised';
    public static final String ERROR_SFDC_UNABLE_TO_SUBMIT_CREATE_BP = 'An unexpected exception has occurred, Salesforce has been unable to process your request';
    public static final String SUCCESS_BP_PRESENT = 'SAP_BP__c is already present in SFDC';
    public static final String SUCCESS_BP_CREATION_SUBMITTED = 'New SAP BP Creation Submitted';
    public static final String ERROR_ADDRESS_VALIDATION = 'Address Validation Error';
    public static String uniqueRecordKey;
    
    // Variables to be used with the error reprocessing logic.
    public static Error_Log_Items__c errorLogItemRecord; //Error_Log_Items__c being processed.
    public static Boolean isSuccess; //Variable is used to pass back to the batch class if the processing was successful.
    
    //Method to handle the automated reprocessing or errors.
    public Boolean reprocessAPIErrors(Error_Log_Items__c errorLogItemRecord){
        errorLogItemRecord = errorLogItemRecord;
        
        //Call to the processing class, passing any paramters to be used in the processing.
        SAP_BP_Service.processRequest(errorLogItemRecord.JSON_Body__c, errorLogItemRecord.RequestURI__c);
       
        //If the process ran successfully pass back true, else false.
        return isSuccess;
        
    }    
    
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
    
    //ENDPOINT: https://taylorandfrancis--devsid.my.salesforce.com/services/apexrest/12345/generateBP/doPost
    @HttpPost
    global static void doPost(){ 
        
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
        
        isSuccess = false;
        try{
            //Parse the JSON.     
            SAP_BP_utl.addressWrapper addressData = (SAP_BP_utl.addressWrapper)JSON.deserialize(jsonString, SAP_BP_utl.addressWrapper.Class);
            addressData.PartyId = URI.substringBetween('/','/generateBP');
            SAP_BP_utl.validateRequest(addressData);
            uniqueRecordKey = addressData.houseNumber+addressData.addressLine1+addressData.city+addressData.state+addressData.postalCode;
            System.debug('addressData'+addressData);
            //Try to locate the SFDC Account Id. If not found throw an error.
            try{
                addressData.accountId = [SELECT Id FROM Account WHERE Customer_Id__c =: addressData.PartyId].Id;
            } catch (exception e) {
                isSuccess = false;
            //In the lines below we will return an error if the partyId has not been found.
        }
        if(addressData.accountId == null || addressData.accountId == ''){
            isSuccess = false;
            apiResponse = new Response('Error', ERROR_PARTYID_NOT_RECOGNISED, new SAP_BP_utl.BPResponseObject());
            //Create the error log item to be processed later.
            //Update the latest error information if an error is being reprocessed.
                ReprocessErrors_utl.createErrorLogItem(
                    uniqueRecordKey, //errorLogUniqueKey
                    jsonString, //jsonBody
                    RestContext.request.requestURI, //RequestURI
                    system.now(), //errorDateTime
                    ERROR_PARTYID_NOT_RECOGNISED, //errorDetails
                    'SAP BP Service Error', //errorType
                    'api', //typeOfError
                    errorLogItemRecord //existingErrorLogItemRecord
                );       
        }
        
        //Don't continue if there is not a PartyId in the request.
        
        if(addressData.accountId != null && addressData.accountId != ''){        
            //First try to match an existing SAP_BP__c record.
            Boolean sapBPRecordIsMatched = false;
            SAP_BP__c sapBPRecord;
            //Try to match an existing SAP_BP__c record.
            for(SAP_BP__c sbpRecord: [SELECT Id,Name,
                                      Account_Id__c,
                                      Street__c,
                                      address_line1__c,
                                      address_line2__c,
                                      address_line3__c,
                                      City__c,
                                      State__c,
                                      Country__c,
                                      ZIP__c,
                                      Status__c,
                                      Source__c,
                                      Telephone__c,
                                      Email__c,
                                      First_Name__c,
                                      Last_Name__c,
                                      Address_Type__c ,
                                      Care_of__c,
                                      Department__c,
                                      Tax_Registration_Number__c,
                                      Tax_Number_Category__c,
                                      Category__c FROM SAP_BP__c WHERE Account_Id__r.Customer_Id__c =: addressData.PartyId 
                                      AND Account_Id__r.Customer_Id__c != null AND Status__c = true]){
                                          
                                          //Run a check on the SAP_BP__c address.
                                          SAP_BP_utl.addressWrapper addressTempForChecking = SAP_BP_utl.mapAddressForSAP_BP(sbpRecord);
                                          if(SAP_BP_utl.addressMatcher(addressTempForChecking, addressData)){
                                              sapBPRecord=sbpRecord; 
                                              sapBPRecordIsMatched = true;             
                                          }
                                          
                                          
                                      }
            //If we have a match pass it back.
            if(sapBPRecordIsMatched){
                isSuccess = true;
                apiResponse = new Response('Success', SUCCESS_BP_PRESENT, new SAP_BP_utl.BPResponseObject(
                    sapBPRecord.Id, //salesforceRecordId
                    '', //houseNumber
                    sapBPRecord.Street__c, //addressLine1
                    '', //addressLine2
                    '', //addressLine3
                    sapBPRecord.City__c, //city
                    sapBPRecord.State__c, //state
                    sapBPRecord.Country__c, //country
                    '', //countryCode
                    sapBPRecord.ZIP__c, //postalCode
                    sapBPRecord.Address_Type__c, //addressType
                    '', //contactType
                    sapBPRecord.First_Name__c, //firstName
                    sapBPRecord.Last_Name__c, //lastName
                    '', //title
                    '', //emailAddress
                    '', //telephone
                    sapBPRecord.Name, //bpNumber
                    '', //bpPartnerFunction
                    '', //bpBusinessPartnerCategory
                    sapBPRecord.Tax_Registration_Number__c, //taxRegistrationNumber
                    sapBPRecord.Tax_Number_Category__c, //taxNumberCategory
                    sapBPRecord.Source__c, //source
                    sapBPRecord.Address_Type__c //addressUseType.                   
                ));
            } else { //Create a new SAP_BP__c record.
                
                
                try{     
                    System.debug('create SAP'+addressData);
                    //Call the method to handle the creation of the SAP_BP__c record and make the callout to SAP.
                    List<SAP_BP__c> sbpRecordList = new List<SAP_BP__c>{SAP_BP_utl.noInsertCreateSAPBPRecord(addressData)};                        
                        isSuccess = true;
                    if(sbpRecordList != null && sbpRecordList.size() > 0){
                        sbpRecordList[0].Status__c  = true;
                        if(addressData.bpNumber != null && addressData.bpNumber != 'null' && addressData.bpNumber != ''){
                            String accSrc = [SELECT Id,Source_of_Account__c  FROM Account WHERE Customer_Id__c =: addressData.PartyId].Source_of_Account__c ;
                            if(accSrc == 'ebook-intermediaries'){
                                sbpRecordList[0].Name = addressData.bpNumber;
                            }
                            else {
                                if(addressData.rrAddressId != null){
                                    sbpRecordList[0].Name = addressData.bpNumber;
                                    sbpRecordList[0].RR_Address_ID__c  = addressData.rrAddressId;
                                }
                            }
                        }
                        System.debug('sbpRecordList'+sbpRecordList);
                        //Commit the SAP_BP__c record 
                        Insert sbpRecordList;
                        System.debug('sbpRecordList 1'+sbpRecordList);
                    }
                    apiResponse = new Response('Success', SUCCESS_BP_CREATION_SUBMITTED, 
                                               new SAP_BP_utl.BPResponseObject(
                                                   sbpRecordList[0].Id, //salesforceRecordId
                                                   '', //houseNumber
                                                   sbpRecordList[0].Street__c, //addressLine1
                                                   '', //addressLine2
                                                   '', //addressLine3
                                                   sbpRecordList[0].City__c, //city
                                                   sbpRecordList[0].State__c, //state
                                                   sbpRecordList[0].Country__c, //country
                                                   '', //countryCode
                                                   sbpRecordList[0].ZIP__c, //postalCode
                                                   sbpRecordList[0].Address_Type__c, //addressType
                                                   '', //contactType
                                                   sbpRecordList[0].First_Name__c, //firstName
                                                   sbpRecordList[0].Last_Name__c, //lastName
                                                   '', //title
                                                   sbpRecordList[0].Email__c, //emailAddress
                                                   '', //telephone
                                                   sbpRecordList[0].Name, //bpNumber
                                                   '', //bpPartnerFunction
                                                   '', //bpBusinessPartnerCategory
                                                   sbpRecordList[0].Tax_Registration_Number__c, //taxRegistrationNumber
                                                   sbpRecordList[0].Tax_Number_Category__c, //taxNumberCategory   
                                                   sbpRecordList[0].Source__c, //source
                                                   sbpRecordList[0].Address_Type__c //addressUseType.  
                                               )           
                                              );
                    
                       
                        
                    if(!(addressData.bpNumber != null && addressData.bpNumber != 'null' && addressData.bpNumber != '')){
                        List<Id> sapBPIds = new List<Id>();
                        for(SAP_BP__c sbp: sbpRecordList){
                            sapBPIds.add(sbp.Id);
                        }
                        //Only make the callout if the request is not running in a test.
                        if(!test.isRunningTest()){
                            System.debug('Call BP API');
                            TF_CreateBusinessPartnerCallout.getSAPBPNumberCallout(sapBPIds,uniqueRecordKey, jsonString,URI); 
                   
                        }   
                    }
                } catch (exception e) {
                    isSuccess = false;
                    apiResponse = new Response('Error', ERROR_SFDC_UNABLE_TO_SUBMIT_CREATE_BP, new SAP_BP_utl.BPResponseObject());  
                    //Create the error log item to be processed later.
                    //Update the latest error information if an error is being reprocessed.
                        ReprocessErrors_utl.createErrorLogItem(
                            uniqueRecordKey, //errorLogUniqueKey
                            jsonString, //jsonBody
                            RestContext.request.requestURI, //RequestURI
                            system.now(), //errorDateTime
                            ERROR_SFDC_UNABLE_TO_SUBMIT_CREATE_BP+': '+e.getmessage(), //errorDetails
                            'SAP BP Service Error', //errorType
                            'api', //typeOfError
                            errorLogItemRecord //existingErrorLogItemRecord
                        ); 
                }
                
            }   
        }        
        //If a subsequent request has been successful remove any error logs relating to that request.
        if(errorLogItemRecord == null && isSuccess){
            ReprocessErrors_utl.removeErrorsIfresolved(
                new List<String>{uniqueRecordKey},
                'SAP BP Service Error'
            );
        }
        }catch(Exception ex){
            apiResponse = new Response('Error', ex.getMessage() , new SAP_BP_utl.BPResponseObject()); 
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            String emailAddress = (String) orgSpecificProps.get('CustomerOnboardingExceptionEmailAddress__c');
          
            String emailBody = 'CL : SF : SAPBPSeviceException for below SAP BP Creation Request :  ';
            System.debug('Email address: ' +emailAddress);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] { emailAddress};
            message.subject = 'CL : SF : IndividualCustomerOnboardingException';
            message.plainTextBody = emailBody +  ex.getMessage() + jsonString;
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            if (results[0].success){
                System.debug('The email was sent successfully.');
            } else{
                System.debug('The email failed to send: ' + results[0].errors[0].message);
            }

        }
        return JSON.serialize(apiResponse);       
    }
}