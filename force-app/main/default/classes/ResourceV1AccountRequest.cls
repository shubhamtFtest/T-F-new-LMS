@RestResource(urlMapping='/v1/accountRequests/*')
global with sharing class ResourceV1AccountRequest {
    global class EmailIdCannotBeNullException extends Exception {}
    global class FieldCannotBeNullException extends Exception {}
    global class CustomerOnboadingException extends Exception {}
    global class AccountRequest {
        public String name;
        public String ringGoldId;
        public String website;
        public String source;
        public List<Address> address;
        public List<IPs> ips;
        public List<ContactDetails> contact;
        public String createBP;
        
    }
    
    global class Address {
        public String addressLine1 ;
        public String addressLine2 ;
        public String addressLine3 ;
        public String city ;
        public String state ;
        public String postalCode ;
        public String country ;
        public String addressType ;
        public String taxRegistrationNumber ;
        public String taxNumberCategory ;
        public String bpNumber;
    }
    
    global class IPs {
        public String description;
        public String iplist;
        public String type;
    }
    
    global class ContactDetails {
        public String firstname;
        public String lastname;
        public String email;
    }
    
    global class AccountResponse {
        public Metadata metadata ;
        public Data data ;
    }
    public class Metadata {
        public String requestId;
        public String message;
        public String status;
    }
    public class Data {
        public AccountRequest accountrequest ;
    }
    
    @httpPost
    global static void doPost() {
        String jsonStr = RestContext.request.requestBody != null ? RestContext.request.requestBody.toString() : null;
    	AccountRequest request = (AccountRequest)JSON.deserialize(jsonStr, AccountRequest.class);
        AccountRequestInterface accountRequest = new V1AccountRequestService();
        Account result;
        String errorMsg = '';
        try{
            accountRequest.validateRequest(request);
            System.debug('Validation done.');
            result = accountRequest.create(request);
            System.debug('result : ');
        }catch(Exception ex){
            System.debug('In catch');
            errorMsg = ex.getMessage();
        }
        System.debug('errorMsg'+errorMsg);
        AccountResponse accountResponse = new AccountResponse();
        if(result != null && result.id != null){
            Metadata responseMetadata = new Metadata();
            responseMetadata.status = 'Success';
            responseMetadata.message = 'Account creation successful';
            responseMetadata.requestId = result.id;
            accountResponse.Metadata = responseMetadata;
            Data responseData = new Data();
            responseData.accountrequest = request;
            accountResponse.Data = responseData;
            Restcontext.response.statuscode = 201;
        }else{
            Metadata responseMetadata = new Metadata();
            responseMetadata.status = 'Failure';
            responseMetadata.message = 'Account could not be created. '+errorMsg;
            responseMetadata.requestId = '';
            accountResponse.Metadata = responseMetadata;
            Data responseData = new Data();
            responseData.accountrequest = request;
            accountResponse.Data = responseData;
            Restcontext.response.statuscode = 400;
        }
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(accountResponse));
    }
}