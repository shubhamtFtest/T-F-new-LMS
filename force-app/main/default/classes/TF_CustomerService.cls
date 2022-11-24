@RestResource(urlMapping='/v1/customers/*')
global class TF_CustomerService {
    public class CustomerServiceException extends Exception {}
    public enum ContactType {primary,alternate}
    public enum AddressType {billing,shipping,mailing,primary,alternate}
    public enum IdentifierType {ringGoldId,name,domain,id,sfid}
    public enum RelationshipType {super_admin, librarian, internal_admin, 
        admin, librarian_admin, customer_service,
        customer_service_admin, anonymous, undefined,
        Ebook_Librarian, sales_admin, researcher,reader, agent, censorship_admin, system_admin  }
    public enum PreferenceName {opt_in, opt_out}
    public enum ReferenceName {OPENATHENS,SAML,SHIBBOLETH,ORCID}    
    public enum BpPartnerFunction {SP,BP,PY,SH} 
    // -----  Request object definition ------
    global class Customer {
        public ContactDetails contact;
        public String source;
        public List<Organisations> organisations;
    }
    global class Organisations{} 
    global class ContactDetails {
        public String partyId;
        public String partySfdcId;
        public String lastName;
        public String orcid;
        public Address[] addressList;
        public ContactList[] contactList;
        public String dob;
        public String firstName;
        public String fullName;
        public Relationship[] relationships;
        public Preference[] preferences;
        public Boolean mFAEnabled;
        public Boolean consentGiven;
        public References[] references;
        
        public String getEmail(ContactType contactType) {
            if(contactList != null && !contactList.isEmpty()) {
                for(ContactList contacts : contactList) {
                    if(contacts.contactType == contactType) {
                        System.debug('getEmail returns '+contacts.email);
                        return contacts.email;
                    }
                }
            }
            return null;
        }
    }
    
    global class References {
        private String orgId;
        public ReferenceName name;
        public String id;
    }
    
    global class Preference {
        public PreferenceName preferenceName;
        public String preferenceValue;
    }
    
    global class Relationship {
        public IdentifierType identifierType;
        public String identifierValue;
        public RelationshipType relationshipType;
    }
    
    global class ContactList {
        public String contactNumber;
        public String email;
        public ContactType contactType;
    }
    
    global class Address {
        public ContactType contactType;
        public String addressLine1;
        public String addressLine2;
        public String addressLine3;
        public String postalCode;
        public String state;
        public String city;
        public String country;
        public String province;
        public AddressType addressType;
        public String bpNumber;
        public BpPartnerFunction bpPartnerFunction;          
        public String bpBusinessPartnerCategory;   
        public String countryCode;                 
        public String usStateCode;
        public String emailAddress;    
        public String title;
        public String firstName;
        public String lastName;
        public String telephone;
        public String taxRegistrationNumber;
        public String taxNumberCategory;
        public String houseNumber;
    }
    
    global class BpDetails{
        public BpPartnerFunction bpPartnerFunction;          
        public String bpBusinessPartnerCategory;   
        public String countryCode;                 
        public String usStateCode;
        public String emailAddress;    
        public String title;
        public String firstName;
        public String lastName;
        public String telephone;
        public String taxRegistrationNumber;
        public String taxNumberCategory;
        public String houseNumber;
    }
    
    // ------ Response object definition ----
    
    global class CustomerResponse {
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
        
        public void setAdditionField(String key, Object val ){
            metadata.put(key, val);
        }  
        
        public void clear(){
            metadata.clear();
        }        
    }
    
    global class ChangeEventHeader {
        public Boolean isTransactionEnd = true;
        public String entityName;
        public String changeType;
    }
    
    global class PayLoad {
        public Contact contact;
        public ChangeEventHeader changeEventHeader;
    }
    
    
    @HttpPost
    global static void doPost() {
        Object result;
        String command = getCommand(RestContext.request.requestURI);      
        String operation = operationLookup('POST', command);        
        String jsonStr = RestContext.request.requestBody != null ? RestContext.request.requestBody.toString() : null;
        
        if (operation == 'addCustomer') {
            result = addCustomer(jsonStr);
            system.debug('result===>'+result);
        }
        if (operation == 'AccountSettings') {
            String partyid = command.substring(command.lastIndexOf('/', command.lastIndexOf('/') - 1) + 1, command.lastIndexOf('/'));
            result = AccountSettings(jsonStr, partyid);
        }
        if (operation == 'addCustomerAddress') {
            String partyId = command.substring(command.lastIndexOf('/', command.lastIndexOf('/') - 1) + 1, command.lastIndexOf('/'));
            result = addCustomerAddress(jsonStr, partyId);
        } 
       
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(result));
        system.debug(JSON.serialize(result));
    }
    
    @HttpPut
    global static void doPut() {
        Object result;
        String command = getCommand(RestContext.request.requestURI);     
        String operation = operationLookup('PUT', command);        
        String jsonStr = RestContext.request.requestBody != null ? RestContext.request.requestBody.toString() : null;
        
        if (operation == 'updateCustomer') {
            result = updateCustomer(jsonStr);
        } 
        
        system.debug(result);
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(result));
    }
    
    @HttpPatch
    global static void doPatch() {
        Object result;
        String command = getCommand(RestContext.request.requestURI);     
        String operation = operationLookup('PATCH', command);        
        String jsonStr = RestContext.request.requestBody != null ? RestContext.request.requestBody.toString() : null;
        
        if (operation == 'updateCustomerAddress') {
            String partyId = command.substring(command.lastIndexOf('/', command.lastIndexOf('/') - 1) + 1, command.lastIndexOf('/'));
            result = updateCustomerAddress(jsonStr, partyId);
        } 
        system.debug(result);
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(result));
    }
    /**
    * Add Customer Serivce Implementation
    **/
    public static Object addCustomer(String jsonStr) {
        Customer addCustomerRequest = (Customer)JSON.deserialize(jsonStr, Customer.class);
        CustomerResponse response = new CustomerResponse();
        String accountId;
        try {
            TF_AddCustomerImpl.validateContactDetails(addCustomerRequest.contact);
            if(isValidContactRequest(addCustomerRequest.contact)) {
                addCustomerRequest = TF_AddCustomerImpl.initializeDefaultValue(addCustomerRequest);
                if(hasContactList(addCustomerRequest.contact)) {
                    accountId = TF_AddCustomerImpl.addOrUpdateContact(addCustomerRequest.contact);
                }
                
                if (hasExternalReference(addCustomerRequest.contact)) {
                    if(addCustomerRequest.contact.getEmail(TF_CustomerService.ContactType.primary) == null) {
                        TF_AddCustomerImpl.notifyReferenceContact(addCustomerRequest.contact);
                    }
                }
                String getPartyId = addCustomerRequest.contact.partyId;
                String getpartySfdcId = addCustomerRequest.contact.partySfdcId;
                Boolean bucketAccCreated = TF_AddCustomerImpl.bucketVar;
                
                if(!jsonStr.contains('relationships')){
                    
                    if(jsonStr.contains('"contactlist"')){
                       jsonStr = jsonStr.substring(0, jsonStr.indexOf('"contactlist"')) +'"relationships":[{"identifierType": "sfid","identifierValue":"'+accountId+'","relationshipType": "undefined"}],'+ jsonStr.substring(jsonStr.indexOf('"contactlist"'), jsonStr.length());                       
                    }
                    if(jsonStr.contains('"contactList"')){
                       jsonStr = jsonStr.substring(0, jsonStr.indexOf('"contactList"')) +'"relationships":[{"identifierType": "sfid","identifierValue":"'+accountId+'","relationshipType": "undefined"}],'+ jsonStr.substring(jsonStr.indexOf('"contactList"'), jsonStr.length());                       
                    }
                    addCustomerRequest = (Customer)JSON.deserialize(jsonStr, Customer.class);
                }else{
                    
                    if(addCustomerRequest.contact.relationships != null && !(addCustomerRequest.contact.relationships).isEmpty()){
                        for(integer i=0; i<addCustomerRequest.contact.relationships.size(); i++){
                            if(bucketAccCreated == true){
                                addCustomerRequest.contact.relationships[i].identifierType = TF_CustomerService.IdentifierType.sfid;
                                addCustomerRequest.contact.relationships[i].identifierValue = accountId;
                                addCustomerRequest.contact.relationships[i].RelationshipType = TF_CustomerService.RelationshipType.undefined;
                            }
                        }
                    }else{
                        if(jsonStr.contains('"relationships": []')){
                            jsonStr = jsonStr.replace('"relationships": []', '"relationships":[{"identifierType": "sfid","identifierValue":"'+accountId+'","relationshipType": "undefined"}]');
                            addCustomerRequest = (Customer)JSON.deserialize(jsonStr, Customer.class);
                        }
                    }
                    
                }
                addCustomerRequest.contact.partyId = getPartyId;
                addCustomerRequest.contact.partySfdcId = getpartySfdcId;
                
                response.success(addCustomerRequest, 'SUCCSESS');
            } else {
                response.error(addCustomerRequest, 'Request does not have valid Contact details');
            }
            if(addCustomerRequest.organisations!=null&&!addCustomerRequest.organisations.isEmpty()){
                system.debug('TF_CustomerService');
                TF_addAccountImpl.addOrUpdateAccount(jsonStr);
            }
        } catch(Exception ex){
            response.error(addCustomerRequest,ex.getMessage());
            system.debug(ex.getMessage()+'***'+ex.getLineNumber());
        }
        return response;
    }
    
    /**
    * Update Account Settings Implementation
    **/
    public static Object AccountSettings(String jsonStr, string partyId) {
        system.debug(partyId);
        CustomerResponse response = new CustomerResponse();
        try {
            if(String.isNotBlank(jsonStr)) {
                List<Account> existingAccountList = updateAccountByAccountSettings(jsonStr,partyId);                
                response.success(jsonStr, 'SUCCSESS');
            }  else {
                response.error(jsonStr, 'Request does not have valid account-settings details');
            }            
        } catch(Exception ex){
            response.error(jsonStr,ex.getMessage());
            system.debug(ex.getMessage());
        }
        return response;        
    }
    
    /**
    * Add Customer Serivce Implementation
    **/
    public static Object addCustomerAddress(String jsonStr, String partyId) {
        Address addCustomerAddressRequest = (Address)JSON.deserialize(jsonStr, Address.class);
        BpDetails bpdetailsFromRequest = (BpDetails)JSON.deserialize(jsonStr, BpDetails.class);system.debug(bpdetailsFromRequest);
        CustomerResponse response = new CustomerResponse();
        try {
            if(addCustomerAddressRequest != null && partyId != null){
                TF_AddCustomerImpl.validateAddressRequest(addCustomerAddressRequest);
                TF_AddCustomerImpl.addCustomerAddress(addCustomerAddressRequest, partyId, bpdetailsFromRequest);
                response.success(addCustomerAddressRequest, 'SUCCSESS');
            }else{
                throw new CustomerServiceException('PartyId or Address cannot be null ');
            }
        } catch(Exception ex){
            response.error(addCustomerAddressRequest, ex.getMessage());
            system.debug(ex.getMessage());
        }
        return response;
    }
    
    /**
    * Update Customer Service Implementation
    **/
    private static Object updateCustomer(String jsonStr) {
        Customer updateCustomerRequest = (Customer)JSON.deserialize(jsonStr, Customer.class);
        CustomerResponse response = new CustomerResponse();
        try {
            List<Contact> existingContactList = getContactByPartyId(updateCustomerRequest.contact);
            TF_AddCustomerImpl.validateContactDetails(updateCustomerRequest.contact);
            if(isValidContactRequest(updateCustomerRequest.contact)) {
                if(hasContactList(updateCustomerRequest.contact)) {
                    TF_AddCustomerImpl.updateContact(updateCustomerRequest.contact,existingContactList[0]);
                }
                if (hasExternalReference(updateCustomerRequest.contact)) {
                    TF_AddCustomerImpl.notifyReferenceContact(updateCustomerRequest.contact);
                } 
                response.success(updateCustomerRequest, 'SUCCSESS');
            } else {
                response.error(updateCustomerRequest, 'Request does not have valid Contact details');
            }
        } catch(Exception ex){
            response.error(updateCustomerRequest,ex.getMessage());
            system.debug(ex.getMessage());
        }
        return response;
    }  
    
    /**
    * Update Customer Address Serivce Implementation
    **/
    public static Object updateCustomerAddress(String jsonStr, String partyId) {
        Address updateCustomerAddressRequest = (Address)JSON.deserialize(jsonStr, Address.class);
        BpDetails bpdetailsFromRequest = (BpDetails)JSON.deserialize(jsonStr, BpDetails.class);
        CustomerResponse response = new CustomerResponse();
        try {
            if(updateCustomerAddressRequest != null && partyId != null){
                TF_AddCustomerImpl.validateAddressRequest(updateCustomerAddressRequest);
                TF_AddCustomerImpl.updateCustomerAddress(updateCustomerAddressRequest, partyId, bpdetailsFromRequest);
                response.success(updateCustomerAddressRequest, 'SUCCSESS');
            }else{
                throw new CustomerServiceException('PartyId or Address cannot be null ');
            }
        } catch(Exception ex){
            response.error(updateCustomerAddressRequest, ex.getMessage());
            system.debug(ex.getMessage());
        }
        return response;
    }
    
    
    /**
    * is it a valid Contact creation/update request
    **/
    private static boolean isValidContactRequest(ContactDetails contact) {
        return (contact != null && (hasContactList(contact) || hasExternalReference(contact)));
    }
    
    /**
    * Does it has atleast one Contact List in the requests
    **/
    private static boolean hasContactList(ContactDetails contact) {
        return (contact.contactList != null && !contact.contactList.isEmpty());
    }
    
    /**
    * Does it has any external reference
    **/
    private static boolean hasExternalReference(ContactDetails contact) {
        return (contact.references != null && !contact.references.isEmpty());
    }   
    
    /**
    * get existing contact by party id 
    **/    
    private static List<Contact> getContactByPartyId(ContactDetails contact) {
        if(contact.partyId != null && String.isNotBlank(contact.partyId)){
            List<Contact> existingContactList = [SELECT id, Email,AccountId, Party_Id__c FROM Contact WHERE Party_Id__c = : contact.partyId limit 1];
            if(existingContactList != null && existingContactList.size() > 0){
                return existingContactList;
            }else{
                throw new CustomerServiceException('Contact not found with this party Id');
            }
        } else{
            throw new CustomerServiceException('Party Id cannot be null');
        }
    }
    
    /**
    * Update existing account by party id, if party id present then update account-settings field else throw an error 'Account not found with this party Id' 
    **/    
    private static List<Account> updateAccountByAccountSettings(string jsonStr, string partyId){
        if(partyId != null && String.isNotBlank(partyId)){
            List<Account> existingAccountList = [Select id, Account_Settings__c, Customer_Id__c from Account where Customer_Id__c =:partyId ]; 
            if(existingAccountList != null && existingAccountList.size() > 0){
                existingAccountList[0].Account_Settings__c = jsonStr;        
                update existingAccountList;
                return existingAccountList;
            }else{
                throw new CustomerServiceException('Account not found with this party Id');
            }            
        } else{
            throw new CustomerServiceException('Party Id cannot be null');
        }
    }    
    
    // -------------------------------------------------------------------------------------- 
    private static String getCommand(String requestedUri) {
        return requestedUri.substring(requestedUri.lastIndexOf('/v1/customers/')+13);
    }
    
    private static String operationLookup(String method, String command) {
        String operation = 'unknown';
        if (method.equals('GET')) {
            ////  get service
        } else if(method.equals('POST')) {
            if (command.contains('addCustomer')) {
                operation = 'addCustomer';
            }
            if (command.contains('account-settings')) {              
                operation = 'AccountSettings';                
            }
            if (command.contains('addCustomerAddress')) {              
                operation = 'addCustomerAddress';                
            }
        } else if (method.equals('DELETE')) {
            //  Delete service
        } else if (method.equals('PUT')) {
            if (command.contains('updateCustomer')) {
                operation = 'updateCustomer';
            } 
        } else if (method.equals('PATCH')){
            if (command.contains('updateCustomerAddress')) {              
                operation = 'updateCustomerAddress';                
            }
        }
        
        return operation;
    }
    
}