public class TF_IndiaRePrintServiceCallout { 
    
    class CreateReprintEligibilityRequest {
        public String Opportunityid { get;set; } 
        public String ProposalType { get;set; } 
        public String CustomerName { get;set; } 
        public String CustomerSalesRep { get;set; }
        public List<IsbnList> Products;
    }
    
    public class ReprintEligibilityResponse {
        public Boolean IsSucceeded;
        public String Message;
        public Integer StatusCode;
        public ResponseData Data;
    }
    
	public class ResponseData {
		public String OpportunityId;
		public String RunStatus;
		public List<ResponseLineItems> LineItems;
	}
    
	public class ResponseLineItems {
		public String Productid;
		public String Isbn;
		public String Status;
		public String Remarks;
	}
    
    class IsbnList {
        public String ProductId { get;set; }
        public String ISBN { get;set; } 
        public Integer Quantity { get;set; }
    }
    
    private static AuthSetting authSetting;
    private static String tokenURI;
    private static String apiURI;

    public class Data {
        private String Token;
        private String SecretKey;
    }    
    
    class TokenDetails {       
        private Boolean IsSucceeded;
        private String message;
        private Integer StatusCode;
        public Data data;
    }
    
    class AuthSetting {
        private String userName;
        private String password;
        private String secretKey;
        private Integer domainId;
    }

    /** To get the Auth details from Customer Meta data API. **/
    private static void init() {
        if(authSetting == null) {
            authSetting = new AuthSetting();            
            IndiaReprintSettings__c indiaReprintSettings = IndiaReprintSettings__c.getOrgDefaults();
            Decimal domainId = (Decimal) indiaReprintSettings.get('DomainId__c');
            authSetting.userName = (String) indiaReprintSettings.get('User_Name__c');
            authSetting.password = (String) indiaReprintSettings.get('Password__c');
            authSetting.secretKey = (String) indiaReprintSettings.get('Client_Secret__c');
            authSetting.domainId = Integer.valueOf(domainId);           
            tokenURI = (String) indiaReprintSettings.get('Token_URL__c');
            apiURI = (String) indiaReprintSettings.get('Reprint_Eligibility_API_URL__c');            
        }
    }
    
    /** To generate a new OAuth token **/
    private static TokenDetails getToken() {
        init();
        HttpRequest req = new HttpRequest();
        String body = JSON.serializePretty(authSetting);
        req.setEndpoint(tokenURI);
        req.setHeader('Content-Type','application/json');
        req.setMethod('POST');
        req.setBody(body);
        Http http = new Http();
        system.debug('request::'+req);
        HTTPResponse res = http.send(req);
        String responseBody = res.getBody();
        system.debug('responseBody==='+ responseBody.replaceAll('\n', ''));
        TokenDetails response = (TokenDetails)JSON.deserialize(responseBody, TokenDetails.class);
        system.debug('tokenResponse::'+response);
        //return response.data.Token;
        return response;
    }
    
    public static String checkEligibility(String opportunityId, List<OpportunityLineItem> lstId) { 
        String msg = '';
        String errorMsg;
        ReprintEligibilityResponse reDetail = new ReprintEligibilityResponse();
                
        CreateReprintEligibilityRequest eligibilityRequest = getCreateReprintEligibilityRequest(opportunityId, lstId); 
        String body = JSON.serializePretty(eligibilityRequest);
        Map<String, String> headers = new Map<String,String>();
        System.debug('eligibilityRequestBody::' + body);

        IndiaReprintSettings__c indiaReprintSettings = IndiaReprintSettings__c.getOrgDefaults();
        String reprintEligibilityApiURI = (String) indiaReprintSettings.get('Reprint_Eligibility_API_URL__c');        
        
        TokenDetails authToken = getToken();
        headers.put('Content-Type', 'application/json'); 

        try {           
            HttpRequest req = new HttpRequest();
            Http http = new Http();            
            req.setEndpoint(reprintEligibilityApiURI);
            req.SetBody(body);            
            req.setHeader('Content-Type','application/json');
            req.setHeader('Authorization', 'Bearer ' + authToken.data.Token);
            req.setHeader('SecretKey', authToken.data.SecretKey);
            req.setMethod('POST');
            req.settimeout(120000);
            HTTPResponse res = http.send(req);  
            String responseBody = res.getBody();
            System.debug('responseBody::' + responseBody);
            
            //if status code is 200 OR 201
            if(String.valueOf(res.getStatusCode()).startsWith('2')) { 
                List<opportunity> oppList = [SELECT Id, Overall_Reprint_Eligibility__c, Is_Reprint_Eligibility_Request_Sent__c FROM opportunity WHERE Id =:opportunityId LIMIT 1];
                ReprintEligibilityResponse response = (ReprintEligibilityResponse)JSON.deserialize(responseBody, ReprintEligibilityResponse.class); 
                Integer status = response.StatusCode; 
                //if request items are less than or equal to 10
                if (response.IsSucceeded == true && response.Data != null) { 
                    Id oppId = response.Data.OpportunityId;
                    String runStatus = response.Data.RunStatus;
                    List<OpportunityLineItem> olisToBeUpdated = new List<OpportunityLineItem>();                    
                    for(ResponseLineItems item: response.Data.LineItems) {
                        OpportunityLineItem oli = new OpportunityLineItem(); 
                        oli.Id = item.Productid;           
                        oli.Reprint_Eligibility__c = item.Status;
                        oli.Remarks__c = item.Remarks;
                        olisToBeUpdated.add(oli);                        
                    }
                    //update opportunity                         
                    if(oppList.size() > 0){
                        oppList[0].Is_Reprint_Eligibility_Request_Sent__c = true;
                        oppList[0].Is_Reprint_Eligibility_Checked__c = true;
                        oppList[0].Overall_Reprint_Eligibility__c = runStatus;
                        update oppList;
                    }                                           
                    //update line items
                    if(!olisToBeUpdated.isEmpty()) {
                        update olisToBeUpdated;
                    }
                    msg = 'SUCCESS_WITH_RESPONSE_DATA';
                } else if(response.IsSucceeded == true && response.Data == null) {
                    //update opportunity
                    if(oppList.size() > 0){
                        oppList[0].Is_Reprint_Eligibility_Request_Sent__c = true;
                        update oppList;
                    }
                    msg = 'SUCCESS_WITHOUT_RESPONSE_DATA';                    
                } else if(response.IsSucceeded == false && response.Data == null) {
					//msg = 'EXCEPTION_FOUND';
                    msg = response.Message;
                }                 
                return msg;  
            }else if(res.getStatusCode() == 404){
                msg = 'NOT_FOUND';
                return msg;   
            }else if(res.getStatusCode() == 400){
                msg = 'NOT_FOUND';
                return msg;   
            }else{
                msg = 'There was an issue getting the response from callout.';
                return msg;                  
            }
        }catch(Exception ex){
            msg = 'There was an issue getting the details, contact SFDC system admin';
            system.debug('Exception Message::'+msg);            
        }  
             
        return msg; 
    }
    
	/** Get a user for given Salesforce User Id **/
    private static User getUser(Id userID) {
        User userObj = null;
        try {
            userObj = [SELECT Id, Name FROM User WHERE Id =:userID];            
        } catch(Exception ex) {
            System.debug('User exception--->' + ex.getMessage());
        }
        return userObj;
    }
    
    private static CreateReprintEligibilityRequest getCreateReprintEligibilityRequest(String opportunityId, List<OpportunityLineItem> lstId) {
        User usr = null;
        String customerSalesRep = 'SALESREP_DOES_NOT_EXIST';
        CreateReprintEligibilityRequest eligibilityRequest = null;
        try {
            Opportunity oppObj = [Select Id,Name,Proposal_Type__c, Account.Name, Account.Sales_Contact_Person__c From Opportunity WHERE Id=:opportunityId LIMIT 1];         
            eligibilityRequest = new CreateReprintEligibilityRequest();            
            if(oppObj.Account.Sales_Contact_Person__c != null){
            	usr = getUser(oppObj.Account.Sales_Contact_Person__c);
                customerSalesRep = usr.Name;
            }
            eligibilityRequest.Opportunityid = oppObj.Id;
            eligibilityRequest.ProposalType = oppObj.Proposal_Type__c;
            eligibilityRequest.CustomerName = oppObj.Account.Name;
            eligibilityRequest.CustomerSalesRep = customerSalesRep;
            list<OpportunityLineItem> olis = new list<OpportunityLineItem>([select Id, Global_ISBN__c, ProductName__c, ProductCode, Quantity from OpportunityLineItem WHERE Id in :lstId ORDER BY Name DESC]);            
            List<IsbnList> isbnItemList = new List<IsbnList>();
            for (OpportunityLineItem oli : olis) {
                IsbnList itemObj = new IsbnList();
                itemObj.ProductId = oli.Id;
                itemObj.Quantity = Integer.valueOf(oli.Quantity);
                itemObj.ISBN = oli.Global_ISBN__c;
                isbnItemList.add(itemObj);
            }
            eligibilityRequest.Products = isbnItemList;
            
        } catch (Exception ex) {
            System.debug('--->' + ex.getMessage());
        }
        
        return eligibilityRequest;
    } 
    
    public static String updateOpportunityEligibilityRequest(String oppoptunityId) {
        String msg = 'RECORD_NOT_FOUND';
        if(String.isNotBlank(oppoptunityId)){
            List<opportunity> oppObj = [select id,Is_Reprint_Eligibility_Request_Sent__c from opportunity where Id =:oppoptunityId LIMIT 1];
            if(oppObj.size() > 0){
                oppObj[0].Is_Reprint_Eligibility_Request_Sent__c = true;               
                update oppObj;
            }
            msg = 'RECORD_UPDATED';                       
        }
        return msg;        
    }
    
    /**
* Method to send send reprint eligibility email notification 
*/    
    public static void sendReprintEligibilityEmailNotification(Id oppoptunityId){
        try{
            List<Opportunity> oppList = [SELECT id from Opportunity where Id =:oppoptunityId];
            System.debug('opportunityList******opportunityList');            
            Contact contact = [SELECT Id FROM Contact LIMIT 1];
            String toEmailaddress = [SELECT Owner.Email FROM Opportunity WHERE Id = :oppoptunityId].Owner.Email;
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'apc@tandf.co.uk'];
            List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
            for(Opportunity opportunityObj : oppList){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                if ( owea.size() > 0 ) {
                    email.setOrgWideEmailAddressId(owea[0].Id);
                }
                email.setTargetObjectId(contact.Id);
                email.setTreatTargetObjectAsRecipient(false);
                email.saveAsActivity = false;
                email.setToAddresses(new List<String>{toEmailaddress});
                email.setWhatId(opportunityObj.Id);
                Id emailTemplateId = [SELECT id from EmailTemplate where Name = 'IRP override approval request notification'].Id;
                email.setTemplateId(emailTemplateId);
                emailList.add(email);                
            }                        
            Messaging.SendEmailResult [] r = Messaging.sendEmail(emailList);
        } 
        catch(Exception e){
            System.debug('Error'+e.getMessage());
        }
    }
    
}