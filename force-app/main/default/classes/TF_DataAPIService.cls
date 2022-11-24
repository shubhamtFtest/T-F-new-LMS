/************************************************************************************
* Name          :  TF_DataAPIService
* Description   :  Customerised T&F data service
* Service 1
URL : /services/apexrest/dataService/v1.0/createLead
Method : Post
Sample Request :
{
"firstName": "Alex",
"lastName": "Job",
"company": "SRS Univerity",
"leadSource":"Customer Interaction",
"ringgold":12233,
"jobCategory":"ssss",
"leadStatus":"Contacted",
"Phone":"1233456575758",
"email":"alex.job@srsuniveristy.com",
"temperature":"Red",
"promotionName":"SDE0099EDR",
"business":"ebooks",
"address" : {
"street":"1 Street",
"city": "Bangalore",
"state": "KA",
"zip":"123456",
"Country":"India"
},
"product" : {
"salesforceID":"ERDF3434EDRR",
"name":"name of the product"
}
}

Service 2
URL : /services/apexrest/dataService/v1.0/createOpportunity
Method : Post
Sample Request :
{
"opportunityType":"eBooks",
"opportunityName":"Trial - CRCnetBASE",
"type":"New Business",
"leadSource":"Customer Interaction",
"leadSourceDetail":"Inbound customer call/email",
"opportunityCurrency":"USD",
"stage":"Investigating",
"closeDate" :"2013-05-03", 
"productFamily":"netBase",
"productInterestCategory":"eBooks",
"trialStart":"2013-04-03",
"trialEnd":"2013-05-03",
"product" : {
"salesforceID":"01t0Y00000810Dk",
"name":"name of the product",
"salesPrice":1234
},
"account" : {
"salesforceID":"0019E00000g4oug",
"ringgold":1234
},         
"contact":{
"salesforceID":"0039E00000Yf7uh",
"email":"alex.bob@gmail.com",
"role":"Decision Maker",
"LastName":"TestLastName"
}  
}

Modification Log
----------------------------------------------------------------------------------------------------------------
Date             Developer                       Comments
----------------------------------------------------------------------------------------------------------------
16/Sep/2017      Gilbert                         Created 
12/Apr/2017      Gilbert                         Removed unused service and added new service for UBX integration
-----------------------------------------------------------------------------------------------------------------
May/2018      Ashish Purwar                   Made changes for lead assignments 
May/2018      Ashish Purwar                   Made changes for opportunity assignment
June/2018      Ashish Purwar                  Made changes for contact role creation or notes addition to opportunity
October/2018  Ashish Purwar 				  Made changes to email send notification on lead and opportunity creation. Added Line numbers 308,309
-----------------------------------------------------------------------------------------------------------------
*/

@RestResource(urlMapping='/dataService/v1.0/*')
global class  TF_DataAPIService {
    
    Static String eBookOpportunityRecordTypeID = Quote_Service_Settings__c.getAll().get('Informa Plc').TF_Ebook_Opportunity_RecordType__c;
    Static String eBookOpportunityPriceBookID = Quote_Service_Settings__c.getAll().get('Informa Plc').eBook_PriceBook__c;
    Static String standardPriceBookID = Quote_Service_Settings__c.getAll().get('Informa Plc').Standard_PriceBook__c;
    Static String ownerID = Quote_Service_Settings__c.getAll().get('Informa Plc').T_F_Online_User__c;
    
    global class ContactAddress {
        public String street;
        public String city;
        public String zipCode;
        public String zip;
        public String state;
        public String country;
    }
    
    global class ProductDetails {
        public String ID;
        public Id salesforceID;
        public String name;
        public Decimal salesPrice;
        //To validate the Product request
        public void isValid() {
            if ( (salesforceID == null || String.isBlank(salesforceID) ) && 
                (name == null || String.isBlank(name) )
               ) {
                   throw new StringException('Product id or Product name is missing');
               }
        }
    }
    
    global class AccountDetails {
        public Id salesforceID;
        public String ringgold;
        // To validate the Account reqeust
        public void isValid() {
            if ( (salesforceID == null || String.isBlank(salesforceID) ) && 
                (ringgold == null || String.isBlank(ringgold) )
               ) {
                   throw new StringException('Account id or Ringgold Id is missing');
               }
        }
    }
    
    global class ContactDetails {
        public Id salesforceID;
        public String email;
        public String role;
        public string LastName;//Added by Ashish purwar on 21/05/2018 to accomodate last name in API POST
        //To validate the contact request
        public void isValid() {
            if ( (salesforceID == null || String.isBlank(salesforceID) ) && 
                (email == null || String.isBlank(email) )
               ) {
                   throw new StringException('Contact id or Email is missing');
               }
        }        
    }
    
    /*
Request to create a Lead
*/
    
    global class CreateLeadRequest {
        public String firstName;
        public String lastName;
        public String company;
        public String leadSource;
        public String ringgold;
        public String jobCategory;
        public String leadStatus;
        //public String orderType;//Added to specify that lead is of type UBX Trial. We will activate it once this value is setup in orchestration to passed to the API.
        public String phone;
        public String email;
        public String temperature;
        public String promotionName;
        public String business; 
        public ContactAddress address; 
        public ProductDetails product;
        // To validate create leaad request
        public void isValid() {
            if(product != null) {
                product.isValid();
            }
        }
        
    }
    
    /*
Request to create a Opportunity
*/  
    
    global class CreateOpportunityRequest {
        public String opportunityType;
        public String opportunityName;
        public String type;
        public String orderType;
        public String leadSource;
        public String leadSourceDetail;
        public String opportunityCurrency;
        public String stage;
        public Date closeDate;
        public String productFamily;
        public String productInterestCategory;
        public Date trialStart;
        public Date trialEnd;
        public ProductDetails product;
        public AccountDetails account;
        public ContactDetails contact;
        // To Validate the create Opportunity request.
        public void isValid() {
            if(opportunityType == null || String.isBlank(opportunityType)) {
                throw new StringException('OpportunityType can not be null');
            }
            account.isValid();
            if(product != null) {
                product.isValid();
            }
            if(contact != null) {
                contact.isValid();
            }
        }
        
    } 
    
    /*
Response object
*/
    global class TFDataAPIResponse {
        public Boolean success;
        public String errorMessage;
        public String id;
        
        public void setError(String errorMessage) {
            this.success = false;           
            this.errorMessage = errorMessage;
        }
    }
    
    @HttpPost
    global static void doPost() {
        TFDataAPIResponse result    = new TFDataAPIResponse();
        String command              = getCommand(RestContext.request.requestURI);
        String operation            = operationLookup('POST', command);
        String jsonStr              = RestContext.request.requestBody != null ? RestContext.request.requestBody.toString() : null;
        
        if (operation == 'createLead') {
            result = createLead(jsonStr);
        } else if (operation == 'createOpportunity'){
            result = createOpportunity(jsonStr);
        } else {
            result.setError('Invalid Resource');
        }
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(result));
    }
    
    /*
To get a operation name from the url
*/
    private static String operationLookup(String method, String command) {
        String operation = 'unknown';
        if (method.equals('GET')) {
            ////  Delete service
        } else if(method.equals('POST')) {
            if (command.contains('createLead')) {
                operation = 'createLead';
            } else if (command.contains('createOpportunity')) {
                operation = 'createOpportunity';
            }
        } else if (method.equals('DELETE')) {
            //  Delete service
        } else if (method.equals('PUT')) {
            //  put service 
        }
        return operation;
    }
    
    private static String getCommand(String requestedUri) {
        return requestedUri.substring(requestedUri.lastIndexOf('/dataService/v1.0/')+17);
    }
    
    private static TFDataAPIResponse createLead(String jsonStr) {
        CreateLeadRequest request = (CreateLeadRequest)JSON.deserialize(jsonStr, CreateLeadRequest.class);
        TFDataAPIResponse dataAPIResponse = new TFDataAPIResponse();
        Boolean isNotesRequired = false;
        try {
            // Implementation
            request.isValid();
            Lead leadObj = new Lead();
            leadObj.firstName = request.firstName;
            leadObj.lastName = request.lastName;
            leadObj.Company = request.company;
            leadObj.LeadSource = request.leadSource;
            leadObj.Ringgold__c = request.ringgold;
            leadObj.Job_Category__c = request.jobCategory;
            leadObj.Status = request.leadStatus;
            leadObj.Phone = request.Phone;
            leadObj.Email = request.email;
            leadObj.Temperature__c = request.temperature;
            leadObj.Promotion_Name__c = request.promotionName;
            leadObj.Business__c = request.business;
            leadObj.ownerid = ownerID; 
            //leadObj.Order_Type__c = request.orderType;// To be uncommented later once we setup this field in the API request.
            leadObj.Order_Type__c = 'Trial';//As of now we are hardcoding this value but later we will get this value from API call itself.
            if(request.address != null) {              
                leadObj.Street = request.address.street;
                leadObj.City = request.address.city;
                leadObj.State_List__c = request.address.state;
                leadObj.Country_List__c = request.address.Country;
                leadObj.PostalCode = request.address.zip;                                            
            }
            system.debug('request====='+JSON.serialize(request));
            if(request.product != null) {
                Product2 product = null;
                if(String.isNotBlank(request.product.ID)) {
                    product = getProduct(null, request.product.ID); 
                } else if(request.product.salesforceID != null) {
                    product = getProduct(request.product.salesforceID, null); 
                }
                
                if(product != null) {
                    leadObj.Product_Name__c = product.id;
                } else {
                    // if we can't find product Id then please add notes
                    isNotesRequired = true;
                }
            }
            Database.DMLOptions dmo = new Database.DMLOptions();//For activating Lead assignment rule by Ashish Purwar on 15/05/2018
            dmo.assignmentRuleHeader.useDefaultRule = true;//For activating Lead assignment rule by Ashish Purwar on 15/05/2018
			dmo.EmailHeader.triggerAutoResponseEmail = true;//For activating email  notification while Lead assignment rule by Ashish Purwar on 29/10/2018
            dmo.EmailHeader.triggerUserEmail  = true;//For activating email  notification while Lead assignment rule by Ashish Purwar on 29/10/2018
            leadObj.setOptions(dmo);//For activating Lead assignment rule by Ashish Purwar on 15/05/2018  
            insert leadObj;  
            
            if(isNotesRequired) {
                String notes = 'Product Details : <b> ';
                if (request.product.salesforceID != null && String.isNotBlank(request.product.salesforceID)) {
                    notes = notes + request.product.salesforceID + '-' +request.product.name + '</b>';
                } else {
                    notes = notes + request.product.name + '</b>';
                }
                createNote(leadObj.id, notes, 'Lead Request Information');
            }          
            dataAPIResponse.Id = leadObj.Id;
            dataAPIResponse.success = true; 
            
        } catch (Exception ex) {
            dataAPIResponse.setError(ex.getMessage());
        }
        return dataAPIResponse;
    }
    
    private static TFDataAPIResponse createOpportunity(String jsonStr) {
        CreateOpportunityRequest request = (CreateOpportunityRequest)JSON.deserialize(jsonStr, CreateOpportunityRequest.class);
        TFDataAPIResponse dataAPIResponse = new TFDataAPIResponse();
        Boolean isNotesRequired = false;
        try {
                        system.debug('request OPP====='+JSON.serialize(request));

            // Implementation
            request.isValid();
            Opportunity newOpp = new Opportunity(); 
            
            newOpp.Name = request.opportunityName;
            newOpp.Type = request.type;
            newOpp.Order_Type__c = request.orderType;
            newOpp.leadSource = request.leadSource;
            newOpp.Lead_Source_Detail__c = request.leadSourceDetail;
            newOpp.CurrencyIsoCode = request.opportunityCurrency;
            newOpp.StageName = request.stage;
            newOpp.CloseDate = request.closeDate;
            newOpp.Product_Family__c = request.productFamily;
            newOpp.Product_Interest_Category__c = request.productInterestCategory;                   
            newOpp.Trial_Start__c = request.trialStart;
            newOpp.Trial_End__c = request.trialEnd;      
            newOpp.AccountId = request.account.salesforceID;  
            //Opportunity Assignment rules as per Ticket no. 1174. By Ashish Purwar On 16/05/2018
            //**********************************************************************************************************************************************************************
            Account selectedAccount=[select Billing_Country_List__c,Billing_State_List__c,Category__c from account where ID=:request.account.salesforceID]; //Getting rule criteria from corresponding Account           
            Setting_Item__c owner=new Setting_Item__c(); // Fetching object of newly created custom setting having mapping of country and states with users.  
            Integer itemCount=0;
            Boolean isCorporate=false;
            if(selectedAccount.Category__c=='Corporate'){                        
                itemCount=[select count() from Setting_Item__c where Setting__r.name = 'Trial Form Opp Owner Map' AND Text_1__c=:selectedAccount.Billing_Country_List__c AND Checkbox_1__c=true]; 
                isCorporate=true;
            }
            else{                   
                itemCount=[Select count() from Setting_Item__c where Setting__r.name = 'Trial Form Opp Owner Map' AND Text_1__c=:selectedAccount.Billing_Country_List__c AND Checkbox_1__c=false];
            }
            //Assigning opportunity based on sales rep name in custom settings. If there is no sales rep in the settings then it will be assigned to default owner.
            //Setting name is Trial Form Opp Owner Map.
            //It is assumed that duplicate entries will not be their in the settings.
            if(itemCount==0) {    //If country is not available in the settings
                newOpp.ownerid=ownerId;//Assigned to default owner
            }
            else If(itemCount==1){//If country don't have states in the settings
                if(isCorporate==true)
                    owner=[select user_1__c from Setting_Item__c where Setting__r.name = 'Trial Form Opp Owner Map' AND Text_1__c=:selectedAccount.Billing_Country_List__c AND Checkbox_1__c=true]; //Owner retreived from settings
                else
                    owner=[select user_1__c from Setting_Item__c where Setting__r.name = 'Trial Form Opp Owner Map' AND Text_1__c=:selectedAccount.Billing_Country_List__c]; //Owner retreived from settings
                newOpp.ownerid=owner.User_1__c;// Assigned to corresponding user
            }
            else{                 //If country have states in the settings
                if(selectedAccount.Billing_State_List__c!=null){    //If state is selected in corresponding account and also country have states in settings
                    try{ 
                        owner=[select user_1__c from Setting_Item__c where Setting__r.name = 'Trial Form Opp Owner Map' AND Text_1__c=:selectedAccount.Billing_Country_List__c and Text_2__c=:selectedAccount.Billing_State_List__c];
                        newOpp.ownerid=Owner.User_1__c;
                    }
                    catch(exception e){ //If settings have multiple items for country but relevent state is not present
                        System.debug(selectedAccount.Billing_State_List__c + ' State Is missing from settings');                     
                        newOpp.ownerid=ownerId;//Assigned to default owner
                    }
                }
                else  //If state is not present in corresponding account
                {
                    owner=[select user_1__c from Setting_Item__c where Setting__r.name = 'Trial Form Opp Owner Map' AND Text_1__c=:selectedAccount.Billing_Country_List__c Limit 1]; 
                    newOpp.ownerid=owner.User_1__c;
                }
            }
            //*************************************************************************************************************************************************************************
            if(request.opportunityType.equalsIgnoreCase('eBook')) {
                newOpp.RecordTypeId = eBookOpportunityRecordTypeID;
                // If given product has price book entry in T& eBook Price Book then use 'eBook price Book'
                // Otherwise use standard price book
                if(request.product != null) {
                    Product2 prd = null;
                    if(String.isNotBlank(request.product.ID)) {
                        prd = getProduct(null, request.product.ID); 
                    }else if(String.isNotBlank(request.product.salesforceID)) {
                        prd = getProduct(request.product.salesforceID, null); 
                    }                     
                    //if(request.product.salesforceID != null) {
                        if(DoesThisProductHasPriceBookEntry(request.product.salesforceID, eBookOpportunityPriceBookID)) {
                            newOpp.Pricebook2Id = eBookOpportunityPriceBookID;
                        } else {
                            newOpp.Pricebook2Id = standardPriceBookID;
                        }
                    //}
                }
            }             
            
            insert newOpp; // It creates a new opportunity
           
            //Create a new contact and contact role
            
            if(request.contact != null) {
                if(request.contact.salesforceID != null) {//If contact contains salesforce Id
                    insertContactRole(request.contact.salesforceID,newOpp.Id,request.contact.role,true);                  
                }
                else{    //If contact does not contain salesforce Id                     
                    List <Contact> requestedcontact=[select id from Contact where email=:request.contact.email limit 1];//Fetch id of contact 
                    if (requestedcontact.isEmpty())//if contact does not exist with email Id in request
                    {   
                        String OppNotes='Primary contact for this opportunity is : ';
                        OppNotes=OppNotes + request.contact.email;
                        createNote(newOpp.id, OppNotes, 'Primary Contact Information');//As per update from BAs, if contact does not exist in salesforce then only a note need to be added to this opportunity stating that primary contact email id is the one passed in the request.
                        //Contact NewContact= insertContact(request.account.salesforceID,request.contact.LastName,request.contact.email);
                        //insertContactRole(NewContact.Id,newOpp.Id,request.contact.role,true); 
                    }
                    else{//if contact exist with email Id in request                        
                        insertContactRole(requestedcontact[0].id,newOpp.Id,request.contact.role,true); //Create contact role with this contact
                    }
                    
                }
            }             
            
            //Add product item 
            if(request.product != null) {           
                //if(request.product.salesforceID != null) {
                    Product2 product = null;
                    if(String.isNotBlank(request.product.ID)) {
                        product = getProduct(null, request.product.ID); 
                    }else if(String.isNotBlank(request.product.salesforceID)) {
                        product = getProduct(request.product.salesforceID, null); 
                    }
                    if (product != null) {
                        OpportunityLineItem oliiObj = new OpportunityLineItem();  
                        oliiObj.OpportunityId = newOpp.Id; 
                        oliiObj.Product2Id = product.Id;
                        //oliiObj.Product2Id = request.product.salesforceID;  
                        //PriceBookEntry priceBookEntry = getPriceBookEntry(request.product.salesforceID, newOpp.Pricebook2Id, newOpp.CurrencyIsoCode);
                        PriceBookEntry priceBookEntry = getPriceBookEntry(product.Id, newOpp.Pricebook2Id, newOpp.CurrencyIsoCode);
                        if(priceBookEntry != null) {
                            oliiObj.PricebookEntryId = priceBookEntry.id;                            
                            oliiObj.UnitPrice=priceBookEntry.UnitPrice;
                            system.debug(oliiObj);
                        }
                        insert oliiObj;  
                    } else {
                        isNotesRequired = true;
                    }
                    
                //}
            } 
            
            if(isNotesRequired) {
                String notes = 'Product Details : <b> ';
                if (request.product.salesforceID != null && String.isNotBlank(request.product.salesforceID)) {
                    notes = notes + request.product.salesforceID + '-' +request.product.name + '</b>';
                } else {
                    notes = notes + request.product.name + '</b>';
                }
                createNote(newOpp.Id, notes, 'Opportunity Request Information');
            }     
            
            dataAPIResponse.Id = newOpp.Id;
            dataAPIResponse.success = true;
        } catch (Exception ex) {
            dataAPIResponse.setError(ex.getMessage());
        }
        return dataAPIResponse;
    }
    //Function to check if contact exist
    // Created By Ashish Purwar On 21/05/2018
    Private static Boolean DoesContactExist(string EmailId)  
    {
        integer ContactCount=[Select count() from Contact where Email=:EmailId];
        if(ContactCount==0)
            return False;
        else 
            return true;
    }
     // Function to insert contact 
     // Created By Ashish Purwar On 21/05/2018
     // Updated by Ashish Purwar on 12/06/2018
    // No need to insert a new contact as per update on ticket. Only a note is required to be added.
    /*Private static Contact insertContact(Id AccountId, String LastName, String Email){
        Contact NewContact=new Contact();
        NewContact.AccountId=AccountId;
        NewContact.LastName=LastName;
        NewContact.Email=Email;
        insert NewContact;
        return NewContact;
        
    }*/
    // Function to insert contact role
    //Created By Ashish Purwar On 21/05/2018
    Private static Void insertContactRole(Id ContactId, Id OpportunityId, String Role, Boolean IsPrimary){
        OpportunityContactRole newContactRoleList = new OpportunityContactRole();
        newContactRoleList.ContactId = ContactId;
        newContactRoleList.OpportunityId = OpportunityId;
        newContactRoleList.Role = Role;
        newContactRoleList.IsPrimary = IsPrimary;
        insert newContactRoleList;
        
    }
    /**
* Get a product for given Salesforce ID
**/
    private static Product2 getProduct(Id productID, String hubId) {
        Product2 product = null;
        try {
            if(hubId !=null){
                product = [
                    SELECT id, name
                    FROM product2 WHERE Hub_Id__c =:hubId
                ];                
            } else {
                product = [
                    SELECT id, name
                    FROM product2 WHERE Id =:productID
                ];            
            }
        } catch(Exception ex) {
            System.debug(ex.getMessage());
        }
        return product;
    }
    
    /**
* Create a Content Notes and linked to gives Salesforce ID (it can be Lead or Opportunity)
**/
    private static void createNote(Id salesforceID, String body, String title) {
        ContentNote contetNote = new ContentNote();
        contetNote.Title = title;
        contetNote.Content = Blob.valueof(body);      
        insert  contetNote;
        ContentDocumentLink documentLink = new ContentDocumentLink();
        documentLink.ContentDocumentId = contetNote.Id;
        documentLink.LinkedEntityId = salesforceID;
        documentLink.ShareType='V';
        insert documentLink;
    }
    
    /**
* Get Price book entry for given product, pricebook and currency
**/
    private static PriceBookEntry getPriceBookEntry(Id productID, Id priceBookId, String currencyIsoCode) {
        PriceBookEntry priceBookEntry = null;
        try {
            
            priceBookEntry = [SELECT Id,UnitPrice from PriceBookEntry 
                              WHERE Pricebook2Id = :priceBookId AND
                              Product2Id = :productID AND 
                              CurrencyIsoCode = :currencyIsoCode
                             ];           
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }
        
        return priceBookEntry;
    }
    
    /**
* Check whether the product has price book entry in pricebook
**/
    private static Boolean DoesThisProductHasPriceBookEntry(Id productID, id priceBookID) {
        PriceBookEntry priceBookEntry = null ;
        try {
            priceBookEntry = [ SELECT Product2.Id, Product2.Name
                              FROM PriceBookEntry 
                              WHERE Pricebook2Id = :priceBookID and 
                              Product2.Id = :productID limit 1
                             ];
        } catch (Exception ex) {
            System.debug(ex.getMessage()); 
        }
        return priceBookEntry != null;
    }
    
}