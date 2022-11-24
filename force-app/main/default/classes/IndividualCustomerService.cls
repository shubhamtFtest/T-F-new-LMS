@RestResource(urlMapping='/v1/PersonAccount/*')
global class IndividualCustomerService {
    public class AccountDuplicacyException extends Exception {}
    public class IndividualCustomerOnboardingException extends Exception {}
   global class ContactAddress {
       public String addressLine1 ;
        public String addressLine2 ;
        public String addressLine3 ;
        public String city ;
        public String state ;
        public String postalCode ;
        public String country ;
        public String countryCode; 
        public String addressType ;
        public String taxRegistrationNumber ;
        public String taxNumberCategory ;
        public String bpNumber ;
        public String externalCustomerAddressId;
    }
    
    global class IndividualCustomer {
        public String partyID;
        public String sfdcId;
        public String firstName;
        public String lastName;
        public String email;
        public String phoneNumber;
        public ContactAddress address;
    }
    
    global class IndividualCustomerResponse {
        public Map<String,Object> metadata = new Map<String,Object>();
        public Object data;
        
        public void success(Object data, String message){
            metadata.put('status','success');
            metadata.put('message', message);
            this.data = data;            
        }
        
        public void error(Object customer,Object exceptionDetails){
            metadata.put('status','failure');
            metadata.put('message', exceptionDetails);
            this.data = customer;
        }     
    }
   
    @httpPost
    global static void doPost() {
        
        Boolean ExistingEmail=false;
        RestRequest req = RestContext.request;
        Map<String, Object> bodyData = new Map<String,Object>();
        String jsonStr = req.requestBody != null ? req.requestBody.toString() : null;
        IndividualCustomer request = (IndividualCustomer)JSON.deserialize(jsonStr, IndividualCustomer.class);
        IndividualCustomerResponse response = new IndividualCustomerResponse();
        RestResponse res = RestContext.response;
        try{
        bodyData.put('FirstName', request.firstName);
        bodyData.put('LastName', request.lastName);
        bodyData.put('PersonEmail', request.email);
        bodyData.put('Phone', request.phoneNumber);
        bodyData.put('Customer_Id__c', request.partyID);
        if(request.address != null && (request.address.addressType == 'billing' || request.address.addressType == null || request.address.addressType == '' )) {
            if(request.address.addressLine1 == null){
                request.address.addressLine1 = '';
            }
            if(request.address.addressLine2 == null){
                request.address.addressLine2 = '';
            }
            if(request.address.addressLine3 == null){
                request.address.addressLine3 = '';
            }
            bodyData.put('BillingStreet', request.address.addressLine1 + ' '+request.address.addressLine2 + ' ' + request.address.addressLine3);
            bodyData.put('BillingCity', request.address.city);
            bodyData.put('BillingState', request.address.state);
            bodyData.put('BillingPostalCode', request.address.postalCode);
            System.debug('request'+request);
            System.debug('request'+request.address.country);
            bodyData.put('BillingCountry', request.address.country);
            bodyData.put('Request_BP_Number__c', request.address.bpNumber); 
            bodyData.put('Request_RRAddressId__c', request.address.externalCustomerAddressId);
        }
        IndividualCustomerInterface serviceInterface = new V1IndividualCustomerService();
        system.debug(request.email);
        for(Contact c:[ Select id,email,IsPersonAccount from Contact where email=:request.email and IsPersonAccount=:true]){
            system.debug(c);
            ExistingEmail=True;            
        }
        system.debug('bodyData'+bodyData);
        serviceInterface.validateRequest(bodyData);
        Account personAccount = serviceInterface.create(bodyData);
        
        request.partyID = personAccount.Customer_Id__c;
        request.sfdcId = personAccount.Id;
        
        if(!ExistingEmail){
            response.success(request, 'Individual Customer Created.');
            res.statusCode = 201;
        }
        else{
            response.error(request, 'Person Account already exists with the provided email Id.');
            res.statusCode = 200;
        }
        System.debug('response=> '+JSON.serialize(response));
        res.responseBody = Blob.valueOf(JSON.serialize(response));
        }catch(Exception ex){
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            String emailAddress = (String) orgSpecificProps.get('CustomerOnboardingExceptionEmailAddress__c');
          
            String emailBody = 'CL : SF : IndividualCustomerOnboardingException for below mentioned request.  ';
            System.debug('Email address: ' +emailAddress);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] { emailAddress};
            message.subject = 'CL : SF : IndividualCustomerOnboardingException';
            message.plainTextBody = emailBody + 'Exception : ' + + ex.getMessage()+ 'Request : ' + request;
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            if (results[0].success){
                System.debug('The email was sent successfully.');
            } else{
                System.debug('The email failed to send: ' + results[0].errors[0].message);
            }

            //Update regarding issue of lastname contains special character
            response.error(request,'Bad Request '+ ex.getMessage());
            res.statusCode = 400;
            res.responseBody = Blob.valueOf(JSON.serialize(response));
        }
    } 
    
    @HttpPut
    global static void doPut() {
        String emailID = RestContext.request.requestURI.substringBetween('/PersonAccount/','/Convert');  
        System.debug('Email ID ' + emailID);
        IndividualCustomerInterface serviceInterface = new V1IndividualCustomerService(); 
        Account account = serviceInterface.convert(emailID, null);  
        RestResponse res = RestContext.response; 
        res.statusCode = 201;
        res.responseBody = Blob.valueOf(JSON.serialize(account));        
    }
    
    //@HttpGet
    /*global static String doGet() {
String emailID = RestContext.request.requestURI.substringBetween('/PersonAccount/','/Convert');
System.debug('Email ID ' + emailID);
Contact contactNeedConversion = [SELECT ID,FirstName,LastName, IsPersonAccount,AccountID,OwnerID FROM Contact WHERE Email = :emailID];
Account newPersonAccount = [SELECT id, RecordTypeId from Account where id = :contactNeedConversion.AccountID];
newPersonAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
update newPersonAccount; 
return JSON.serialize(newPersonAccount);
}*/
    
}