/*
* QuoteService version 1
*/

@RestResource(urlMapping='/QuoteService/v1/*')
global class  TF_QuoteAPIServiceV1 {
    
    static String productFamily = Quote_Service_Settings__c.getAll().get('Informa Plc').Product_Family__c;
    static String cpqPriceBookName = Quote_Service_Settings__c.getAll().get('Informa Plc').CPQ_PriceBook__c;
    
    // -----  Request object definition ------
    global class ListPriceRequest {
        public String productCode;
        public String articleType;
        public string countryCode;
        public string APCPriceCategory;
    }
    
   
    global class QuoteRequest {
        public Id quoteId;
        public String quoteUniqueId;
        public String submissionId;
        public String manuscriptId;
        public String doi;
        public String CSDApprovalStatus;
        public string APCPriceCategory;
        public String requestId;
    }
    
    global class QuoteUpdateRequest {
        public String doi;
        public Boolean canInvoice;
        public Boolean isArticleAccepted;
        public String requestId;
        
        // Payer Details
        public String payercontactphonenumber;
        public String payerContactName;
        public String payerFirstName;
        public String payerLastName;        
        public String payerOrganizationDepartment;
        public String payerOrganizationCampus;
        public String vatNumber;
        public String purchaseOrderNumber;
        public String payerPartyID ;
        
        // Billing Address Details
        public String billingStreet;
        public String billingStreet2;
        public String billingCity;
        public String billingState;
        public String billingStateISO;
        public String billingPostalCode;
        // Shipping Address Details
        public Boolean sameAsBilling;
        public String shipToContact;
        public String shipToOrganization;
        public String shipToStreet;
        public String shipToStreet2;
        public String shipToCity;
        public String shipToState;
        public String shipToStateISO;
        public String shipToPostalCode;
        public String shipToCountry;  
        // Tax info
        public String taxRegistrationNumber;
        public String taxCategory;
        //others
        public String billingBPNumber ;
        public String shippingBPNumber ;
        public String billingAddressID ;
        public String shippingAddressID ;
        public String reasonForDiscreantionaryWaiver;
        public String discreationaryWaiverStatus;        
    }
    
    global class QuoteExpireRequest {
        public String quoteUniqueId;
    }
    global class UpdateQuoteStatusRequest {
        public String quoteUniqueId;
        public String status;
    }
    global class QuotePromoCodeRequest {
        public String productCode;
        public String promoCode;
        public string countryCode;
        public String payerType;
    }
    
    global class UpdateInvoiceNumberRequest {
        public String orderHubNumber;
        public String invoiceNumber;
        public String invoiceStatus;
    }
    
    global class UpdateCSDApprovalStatusRequest{
        public String quoteUniqueId;
        public String CSDApprovalStatus;       
    }
    
    global class QuoteReCalculationRequest {
        public String quoteUniqueId;
        public GenerateQuoteRequest recalculationRequest;
    }
    
    global class lineItemDetails { 
        public String productCode;
        public String articleType;        
        public String journalName;
        public String discountDisplayName;
        public String productOpenAccessCategory;
        public String APCPriceCategory;
        public String serviceName; 
        //public Boolean isPriceRuleAppled;
        public String authorFacingArticleType;
        public Decimal listAmount;
        public Decimal netAmount;
        public Decimal discountAmount;
        public Decimal discountPercentage ;
        
    }
    

    global class GenerateQuoteRequest {
        public List<lineItemDetails> products; 
         //- Article Details --  
        public String productCode;
        public String journalCode;
        public String articleType;
        public String authorFacingArticleType;       
        public String articelTitle;
        public String doi;
        public String manuscriptID;
        public String submissionID;
		public String requestID;        
        // Lead Auther Details
        public String leadAuthorName;
        public String leadAuthorEmailID;
        public String leadAuthorOrganizationID;
        public String leadAuthorOrganizationRingoldID;
        public String leadAuthorOrganizationName;
        public String leadAuthorOrganizationCampus;
        public String leadAuthorOrganizationDepartment;
        public String leadPrimaryContactPhoneNumber;
        public String leadAuthorPartyID;
		// Payer Details
        public String payercontactphonenumber;
        public String payerType ; // Self, Organization, Third party, Third party Organization
        public String payerContactName; 
        public String payerFirstName;
        public String payerLastName;        
		public String payerPartyID;
		public String website;
        public String payerEmailID;
        public String payerOrganizationID;
        public String payerOrganizationRingoldID; 
        public String payerOrganizationName;
        public String payerOrganizationCampus;
        public String payerOrganizationDepartment;  
        public String vatNumber;
        public String purchaseOrderNumber;
        public String taxRegistrationNumber;
        public String taxCategory;
        
        // -- Other Details
		public string countryCode;
        public Boolean disableRejectionEmail;
        public Boolean canApplyCountryDiscount;
        public Boolean canUsePrepayBudget;
        public Boolean isArticleAccepted;
        public Boolean isAuthorAccepted;
        public Boolean disableQuoteCreationNotificationEmailToAuthor;
        public Boolean disablePrePayApprovalNotificationEmailToAuthor; // Case Number 01050760
        public String entryPoint; // Case Number 01066544 (Submission Portal/ASC/OAD)
        public Boolean disablePrePayManualApprovalCase; // Case Number 01066553
        public String promoCode;
        public Boolean needsManualApproval;
        public String discreationaryWaiverStatus;
        public String reasonForDiscreantionaryWaiver;
        public String previewUrl;
        // - Address Details
        public String billingStreet;
        public String billingStreet2;
        public String billingCity;
        public String billingState;
        public String billingStateISO;
        public String bilingPostalCode;
        public String billingCountry;        
        public Boolean sameAsBilling;        
        public String shipToContact;
        public String shipToOrganization;
        public String shipToStreet;
        public String shipToStreet2;
        public String shipToCity;
        public String shipToState;
        public String shipToStateISO;
        public String shipToPostalCode;
        public String shipToCountry; 
        public String billingBPNumber;
        public String billingAddressID;
		public String shippingBPNumber;       
        public String shippingAddressID;		
    }    

    global class isCountryDiscountAvailableRequest {
        public String country;
        public String productCode;
    }
    
    global class isCountryDiscountAvaialbeResponse {
        public Decimal discountPercentage = 0;
        public String country;
        public String productCode;
        public Boolean isEIFL;
        public String countryApplicableBand;
        public Boolean isCountryDiscountAvailable;
        public Boolean success;
        public String errorMessage;        
        public void setError(String errorMessage) {
            this.success = false;
            this.errorMessage = errorMessage;
        }
    }
    
    // ----- Response object definition ------
    
    global class ListPriceResponse {
        public Boolean success;
        public String errorMessage;
        public String currencyIsoCode;
        public Decimal value;
        public String productOpenAccessCategory;
       public string APCPriceCategory;
        
        public void setError(String errorMessage) {
            this.success = false;
            this.errorMessage = errorMessage;
        }
    }
    
 
    global class QuoteResponse{
        public Boolean success;
        public String errorMessage;
        public Id quoteId;
        public String quoteUniqueId;
        
        public void setError(String errorMessage) {
            this.success = false;
            this.errorMessage = errorMessage;
        }
    }
    
    global class QuoteAccountResponse{
        public Boolean success;
        public String errorMessage;
        public Boolean isPrePayAccount;
        public String billingStreet;
        public String billingCity;
        public String billingState;
        public String bilingPostalCode;
        public String billingCountry;
        public Boolean isVSNUMembership;
        
        public void setError(String errorMessage) {
            this.success = false;
            this.errorMessage = errorMessage;
        }
    }
    
    global class QuotePromoCodeResponse{
        public String promoCode;
        public String discountCategory;
        public Decimal discountPercentage = 0;
        public Boolean success;
        public String errorMessage;
        public void setError(String errorMessage) {
            this.success = false;
            this.errorMessage = errorMessage;
        }
    }    
    global class QuoteDetailResponse{
        public List<lineItemDetails> lineItems;
        public boolean isPriceRuleAppled;
        public String quoteId;
        public String quoteUniqueID;
        public Boolean success;
        public String errorMessage;
        public String  quoteNumber;
        public String status;
        public String currencyIsoCode;
        public Decimal listAmount;
        public Decimal netAmount;
        //public Decimal totalDiscountAmount;
        //public Decimal totalDiscountPercentage;
        public Decimal discountAmount;
        public Decimal discountPercentage;        
        public String invoiceStatus;
        public String invoiceNumber;
        public GenerateQuoteRequest quoteRequest;
        public String CSDApprovalStatus;            
        public void setError(String errorMessage) {
            this.success = false;
            this.errorMessage = errorMessage;
        }
    }
    
    
    // ----- Model definition ----------
    
    
    global class QuoteModel {
        public SBQQ__Quote__c record;
        public list<SBQQ__QuoteLine__c> lineItem;
        
        public Integer nextKey;
        public Boolean applyAdditionalDiscountLast;
        public Boolean applyPartnerDiscountFirst;
        public Boolean channelDiscountsOffList;
        public Decimal customerTotal;
        public Decimal netTotal;
        public Decimal netNonSegmentTotal;
    }    
    
    @HttpPost
    global static void doPost() {
        String result               = '';
        String command              = getCommand(RestContext.request.requestURI);
        String operation            = operationLookup('POST', command);
        String jsonStr              = RestContext.request.requestBody != null ? RestContext.request.requestBody.toString() : null;
        
        if (operation == 'authorAcceptsQuote') {
            result = authorAcceptsQuote(jsonStr);
        } else if (operation == 'getQuoteByParams') {
            result = getQuoteByParams(jsonStr);
        } else if (operation == 'getQuote') {
            result = getQuote(jsonStr);
        } else if (operation == 'getQuoteByUniqueID') {
            result = getQuoteByUniqueID(jsonStr);
        } else if (operation == 'generateQuote') {
            system.debug('Generate Quote Called @@@+++');
            result = generateQuote(jsonStr);
        } else if (operation == 'authorRejectsQuote') {
            result = authorRejectsQuote(jsonStr);
        } else if (operation == 'getListPrice') {
            result = getListPrice(jsonStr);
        } else if (operation == 'recalculateQuote') {
            result = recalculateQuote(jsonStr);
        } else if (operation == 'isCountryDiscountAvailable') {
            result = isCountryDiscountAvailable(jsonStr);
        } else if (operation == 'csdUpdateStatus'){
            result = updateCSDStatus(jsonStr);
        }else if (operation == 'updateQuoteDetails'){
            result = updateQuoteDetails(jsonStr);
        }else if (operation == 'expiresQuote'){
            result = expiresQuote(jsonStr);
        }else if (operation == 'updateQuoteStatus'){
            result = updateQuoteStatus(jsonStr);   
        }else if (operation == 'checkPromoCode'){
            result = checkPromoCode(jsonStr);
        }else if (operation == 'updateInvoiceNumber'){
            result = updateInvoiceNumber(jsonStr);
        }else {
            result = 'Invalid Resource';
        }
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(result);
    }

    private static String getCommand(String requestedUri) {
        return requestedUri.substring(requestedUri.lastIndexOf('/QuoteService/')+13);
    }
    
    private static String operationLookup(String method, String command) {
        String operation = 'unknown';
        if (method.equals('GET')) {
            if(command.contains('isPrePayAccount')) {
                operation = 'isPrePayAccount';
            }
        } else if(method.equals('POST')) {
            if (command.contains('authorAcceptsQuote')) {
                operation = 'authorAcceptsQuote';
            } else if (command.contains('getQuoteByParams')) {
                operation = 'getQuoteByParams';
            } else if (command.contains('getQuoteByUniqueID')) {
                operation = 'getQuoteByUniqueID';
            } else if (command.contains('getQuote')) {
                operation = 'getQuote';
            } else if (command.contains('generateQuote')) {
                operation = 'generateQuote';
            } else if (command.contains('authorRejectsQuote')) {
                operation = 'authorRejectsQuote';
            } else if (command.contains('getListPrice')) {
                operation = 'getListPrice';               
            } else if (command.contains('recalculateQuote')) {
                operation = 'recalculateQuote';
            } else if (command.contains('isCountryDiscountAvailable')) {
                operation = 'isCountryDiscountAvailable';
            }else if (command.contains('csdUpdateStatus')){
                operation = 'csdUpdateStatus';
            }else if (command.contains('updateQuoteDetails')){
                operation = 'updateQuoteDetails'; 
            }else if(command.contains('expiresQuote')){
                operation = 'expiresQuote';
            }else if(command.contains('updateQuoteStatus')){
                operation = 'updateQuoteStatus';
            }else if(command.contains('checkPromoCode')){
                operation = 'checkPromoCode';
            }else if(command.contains('updateInvoiceNumber')){
                operation = 'updateInvoiceNumber';
            }
        } else if (method.equals('DELETE')) {
            
        } else if (method.equals('PUT')) {
            
        }
        return operation;
    }    

    @HttpGet
    global static QuoteAccountResponse doGet() {
        QuoteAccountResponse quoteAccResponse = new QuoteAccountResponse(); 
        String command              = getCommand(RestContext.request.requestURI);
        String operation            = operationLookup('GET', command);
        if(operation == 'isPrePayAccount') {
            String accountID = command.substring(command.lastIndexOf('/')+1);
            List<Account> accounts = new List<Account>();
            accounts = [SELECT Prepay_Account_Count__c, Billing_Street__c, Billing_City__c, Billing_State__c, Billing_ZIP__c, Billing_Country_List__c,VSNU_Membership__c  FROM Account WHERE Id = :accountID];
            if(accounts.size() == 0) {
                quoteAccResponse.setError('Can not find Account for given  ID : ' + accountID);
            } else {
                if(accounts[0].Prepay_Account_Count__c > 0) {
                    quoteAccResponse.isPrePayAccount = true;
                    quoteAccResponse.success = true;
                } else {
                    quoteAccResponse.isPrePayAccount = false;
                    quoteAccResponse.success = true;
                }
                quoteAccResponse.billingStreet = accounts[0].Billing_Street__c;
                quoteAccResponse.billingCity = accounts[0].Billing_City__c;
                quoteAccResponse.billingState = accounts[0].Billing_State__c;
                quoteAccResponse.bilingPostalCode = accounts[0].Billing_ZIP__c;
                quoteAccResponse.billingCountry = accounts[0].Billing_Country_List__c;
                quoteAccResponse.isVSNUMembership  = accounts[0].VSNU_Membership__c == 0?false:true;
                
            }
        }
        return quoteAccResponse;
    }

    global static String generateQuote(String jsonStr) {
        system.debug('@@@Inside generate quote method'); 
        GenerateQuoteRequest request = (GenerateQuoteRequest)JSON.deserialize(jsonStr, GenerateQuoteRequest.class);
        QuoteResponse response = new QuoteResponse();
        enrichRequest(request); //If request has ringold Id, then get the account id from Account object
        set<String> productCodeSet = new set<String>();
        set<String> articleTypeSet = new set<String>();
        
        set<String> productArticleSet = new set<String>();
       
        system.debug('@@@request.products' + request.products);
        if(request.products != NULL && request.products.Size() > 0){
            for(lineItemDetails productDetObj : request.products){
                if(string.isNotBlank(productDetObj.productCode) && String.isNotBlank(productDetObj.articleType)){
                    productCodeSet.add(productDetObj.productCode);
                    articleTypeSet.add(productDetObj.articleType);
                    productArticleSet.add(productDetObj.productCode.toUpperCase() + '-' + productDetObj.articleType.toUpperCase());
                }
            }
        }else if(request.products == NULL){
            response.setError('Product details not exist');
            return JSON.serialize(response);
        }
        system.debug('@@@@productCodeSet' + productCodeSet);
        system.debug('@@@articleTypeSet' + articleTypeSet);
        system.debug('@@@productArticleSet' + productArticleSet );
        
        set<Id> productIds = new set<Id>();

        if(productArticleSet != NULL && productArticleSet.Size() > 0){            
            List<Product2> productList = [select Id, Name, ProductCode, Article_Type__c from Product2 where ProductCode in :productCodeSet and Article_Type__c in :articleTypeSet and IsActive = true and Family = :productFamily];
            system.debug('@@@productListSize::' + productList.Size());
            system.debug('@@@productCodeSetSize::' + productCodeSet.Size());
            
            if(productCodeSet.size() == productList.Size()) {                
                if(productList != NULL && productList.Size() > 0){
                    for(Product2 productObj : productList){
                        system.debug('@@@productObj' + productObj);
                        if(productArticleSet.contains(productObj.productCode.toUpperCase() + '-' + productObj.Article_Type__c.toUpperCase())){
                            if(productIds.contains(productObj.Id)){
                                response.setError('Too Many products matching the criteria');
                                return JSON.serialize(response);
                            }
                            productIds.add(productObj.Id);
                        }
                    }
                }else{
                    response.setError('There is no product matching the criteria');
                    return JSON.serialize(response);
                }
            } else {
                response.setError('There is no product matching the criteria.');
                return JSON.serialize(response);                
            }
        }
        if(productIds.size() == 0){
            response.setError('There is no product matching the criteria.');
            return JSON.serialize(response);
        }

        system.debug('@@@request.doi  ' + request.doi);
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        quote.Article_Title__c = request.articelTitle;
        quote.Journal_Code__c  = request.journalCode ;
        quote.DOI__c = request.doi;
        quote.Manuscript_ID__c = request.manuscriptID;
        quote.Submission_ID__c = request.submissionID;
        
        // -- Primary contact details
        quote.Primary_Contact_Name__c = request.leadAuthorName;
        quote.Primary_Contact_s_email_id__c = request.leadAuthorEmailID;
        quote.Primary_Contact_s_Phone_Number__c = request.leadPrimaryContactPhoneNumber;
        quote.Organization_Name__c = request.leadAuthorOrganizationName;

        // -- Tax Details
        quote.Tax_Registration_Number__c = request.taxRegistrationNumber;
        quote.Tax_Category__c = request.taxCategory; 
        
        // -- Payer Details
        quote.Payer__c = request.payerType;
        
        system.debug('request.payercontactphonenumber +++ ' + request.leadPrimaryContactPhoneNumber);
        system.debug('request.payercontactphonenumber +++ ' + request.payercontactphonenumber);
        
        if(request.payerType.equals('Self')) {
            
            quote.Payer_Contact_Phone_Number__c = request.leadPrimaryContactPhoneNumber;
            system.debug('quote.Payer_Contact_Phone_Number__c++++ ' + quote.Payer_Contact_Phone_Number__c);
            quote.Payer_Contact_Name__c = request.leadAuthorName;
            quote.Payer_First_Name__c = request.payerFirstName;
            quote.Payer_Last_Name__c  = request.payerLastName;            
            quote.Payer_Email__c = request.leadAuthorEmailID;
            if(request.leadAuthorOrganizationID != null && request.leadAuthorOrganizationID != '') {
                
                quote.SBQQ__Account__c = request.leadAuthorOrganizationID;
            }
            quote.Organization_Campus__c = request.payerOrganizationCampus;
            quote.Organization_Department__c = request.payerOrganizationDepartment;
        } 
        if (request.payerType.equals('Organization') || request.payerType.equals('Third party Organization')) {
            // quote.Primary_Contact_s_Phone_Number__c = request.leadPrimaryContactPhoneNumber;
            quote.Payer_Contact_Phone_Number__c = request.payercontactphonenumber;
            system.debug('quote.Payer_Contact_Phone_Number__c++++ ' + quote.Payer_Contact_Phone_Number__c);
            quote.Payer_Contact_Name__c = request.payerContactName;
            quote.Payer_First_Name__c = request.payerFirstName;
            quote.Payer_Last_Name__c  = request.payerLastName;            
            quote.Payer_Email__c = request.payerEmailID;
            
            quote.Payer_Campus__c = request.payerOrganizationCampus;
            quote.Payer_Department__c = request.payerOrganizationDepartment;
            quote.VAT_Number__c = request.vatNumber;           
            
            if(request.payerType.equals('Organization')) {
                quote.Payer_Organization_Name__c = request.leadAuthorOrganizationName;
                if(request.leadAuthorOrganizationID != null && request.leadAuthorOrganizationID != '') {
                
                    quote.Payer_Account__c = request.leadAuthorOrganizationID; 
                }
                quote.Organization_Campus__c = request.payerOrganizationCampus;
                quote.Organization_Department__c = request.payerOrganizationDepartment;
            } else {
                quote.Payer_Organization_Name__c = request.payerOrganizationName;
                if(request.payerOrganizationID != null && request.payerOrganizationID != '') {
                    quote.Payer_Account__c = request.payerOrganizationID; 
                }
                if(request.payerOrganizationID != request.leadAuthorOrganizationID ) {
                    if(request.leadAuthorOrganizationID != null && request.leadAuthorOrganizationID != '') {
                        quote.SBQQ__Account__c = request.leadAuthorOrganizationID;
                    }
                }
            }         
        }
        
        if(request.payerType.equals('Third party')) {
            //quote.Primary_Contact_s_Phone_Number__c = request.leadPrimaryContactPhoneNumber;
            quote.Payer_Contact_Phone_Number__c = request.payercontactphonenumber;
            system.debug('quote.Payer_Contact_Phone_Number__c++++ ' + quote.Payer_Contact_Phone_Number__c);
            quote.Payer_Contact_Name__c = request.payerContactName;
            quote.Payer_First_Name__c = request.payerFirstName;
            quote.Payer_Last_Name__c  = request.payerLastName;            
            quote.Payer_Email__c = request.payerEmailID;
            quote.Payer_Organization_Name__c = request.payerOrganizationName;
            quote.Payer_Campus__c = request.payerOrganizationCampus;
            quote.Payer_Department__c = request.payerOrganizationDepartment;
            if(request.leadAuthorOrganizationID != null && request.leadAuthorOrganizationID != '') {
                
                quote.SBQQ__Account__c = request.leadAuthorOrganizationID;
            }         
        } 
        
        quote.Purchase_Order_Number__c = request.purchaseOrderNumber;
        
        Date today = system.today();
        quote.SBQQ__ExpirationDate__c = today.addDays(30);
        quote.SBQQ__PricebookId__c = getPriceBookID();
        quote.Apply_Country_Discount__c = request.canApplyCountryDiscount;
        quote.Use_Prepay_Budget__c = request.canUsePrepayBudget;
        
        // Address details.
        quote.SBQQ__BillingStreet__c = request.billingStreet;
        quote.Bill_To_Street_2__c = request.billingStreet2;
        quote.SBQQ__BillingCity__c = request.billingCity;
        quote.SBQQ__BillingState__c = request.billingState;
        quote.Bill_To_State_ISO_Code__c = request.billingStateISO;
        quote.SBQQ__BillingPostalCode__c = request.bilingPostalCode;
        quote.SBQQ__BillingCountry__c = request.billingCountry;
         quote.Country_Code__c=request.countryCode;
        
        quote.Same_as_Billing__c = request.sameAsBilling;
        
        quote.SBQQ__ShippingName__c = request.shipToContact;
        quote.Ship_to_Organization__c = request.shipToOrganization;
        quote.SBQQ__ShippingStreet__c = request.shipToStreet;
        quote.Ship_To_Street_2__c = request.shipToStreet2;
        quote.SBQQ__ShippingCity__c = request.shipToCity;
        quote.SBQQ__ShippingState__c = request.shipToState;
        quote.Ship_To_State_ISO_Code__c = request.shipToStateISO;
        quote.SBQQ__ShippingPostalCode__c = request.shipToPostalCode;
        quote.SBQQ__ShippingCountry__c = request.shipToCountry;
        
        if(request.isArticleAccepted == true) {
            quote.Article_Acceptance_Status__c = 'Accepted';
        }
        if(request.isAuthorAccepted != null && request.isAuthorAccepted == true) {
            quote.Author_Status__c = 'Accepted';
            quote.Stop_approval_request_mail_To_author__c = true;
        }
        system.debug('******Disable email *******' +request.disableRejectionEmail);
        if(request.disableRejectionEmail != null && request.disableRejectionEmail == true){
            quote.Stop_Rejection_Email_to_Author__c = true;
        }
        
        system.debug('******Disable email *******' +request.disableQuoteCreationNotificationEmailToAuthor);
        if(request.disableQuoteCreationNotificationEmailToAuthor != null && request.disableQuoteCreationNotificationEmailToAuthor == true){
            quote.Stop_Acceptance_Email_to_Author__c = true; 
        }
        
        system.debug('******Disable PrePay Approval Notification Email to Author*******' +request.disablePrePayApprovalNotificationEmailToAuthor);
        if(request.disablePrePayApprovalNotificationEmailToAuthor != null && request.disablePrePayApprovalNotificationEmailToAuthor == true){ 
            quote.Stop_Approval_Request_Email_to_Author__c = true; 
        }
        
        system.debug('******Can Create PrePay Manual Approval Case*******' +request.disablePrePayManualApprovalCase);
        if(request.disablePrePayManualApprovalCase != null && request.disablePrePayManualApprovalCase == true){ 
            quote.Disable_PrePay_Manual_Approval_Case__c = true; 
        }
        
        quote.Entry_Point__c = request.entryPoint;
        quote.PromoCode__c = request.promoCode;
        quote.Preview_URL__c = request.previewUrl;

        
        system.debug('******Needs Manual Approval*******' +request.needsManualApproval);
        if(request.needsManualApproval != null && request.needsManualApproval == true){ 
            quote.Manual_Check__c = true; 
        }
        
        quote.Lead_Author_Organization_RinGold_ID__c = request.leadAuthorOrganizationRingoldID;
        quote.Payer_Organization_RinGold_ID__c = request.payerOrganizationRingoldID;
        quote.PayerPartyID__c=request.payerPartyID ;
        
        system.debug('@@@Insert quote');
        insert quote;
        
        List<SBQQ__QuoteLine__c> quoteLineItem = new List<SBQQ__QuoteLine__c>();
        
        for(Id productId : productIds){
            SBQQ__QuoteLine__c quoteLine = new SBQQ__QuoteLine__c();
            quoteLine.SBQQ__Quote__c = quote.Id;
            quoteLine.SBQQ__Product__c = productId;
            quoteLine.SBQQ__Quantity__c = 1;
            quoteLine.Author_Facing_Article_Type__c = request.authorFacingArticleType;
 
            quoteLineItem.add(quoteLine);
        }
        
        if(quoteLineItem != NULL && quoteLineItem.Size() > 0){
            INSERT quoteLineItem;
        } 

        response.quoteId = quote.Id;
        response.success = true;
        //response.quoteUniqueId = quote.randomstring__c;
        //response.quoteUniqueId = '1212124fgf';
        try {
            
            SBQQ__Quote__c qouteFromDatabase = [SELECT Id, Name,randomstring__c  FROM SBQQ__Quote__c WHERE Id = :quote.Id ];
            
            system.debug('++++  ' + qouteFromDatabase );
            response.quoteUniqueId =qouteFromDatabase.randomstring__c;
            
        } catch (Exception ex) {
            system.debug(ex);
            response.setError('Quote not found ' + ex.getMessage());
        }
        return JSON.serialize(response);
    }

    private static QuoteDetailResponse generateQuoteDetailResponse(String quoteId) {
        SBQQ__Quote__c qouteFromDatabase = [
            SELECT Id, Name,Preview_URL__c,Journal_Code__c,Payer_First_Name__c,Payer_Last_Name__c,Country_Code__c,Discreationary_Waiver_Flag__c,Reason_for_Discreationary_Waiver__c,Request_ID__c,Website__c, SBQQ__ListAmount__c,PayerPartyID__c,PartyId__c , Total_Discounted_Amount__c,Customer_Ship_Address_ID__c,Customer_Bill_Address_ID__c,Total_Discount_Percent__c,Business_Partner_Billing_Number__c ,Business_Partner_Shipping_Number__c , CurrencyIsoCode, SBQQ__NetAmount__c, Stop_Rejection_Email_to_Author__c , Stop_Acceptance_Email_to_Author__c,
            CSD_Approval_Status__c,Stop_Approval_Request_Email_to_Author__c,Entry_Point__c,Invoice_Number__c,Invoice_Status__c,Disable_PrePay_Manual_Approval_Case__c,PromoCode__c,Manual_Check__c,Payer_Organization_RinGold_ID__c,Lead_Author_Organization_RinGold_ID__c,
            Country_Applicable_List__c, Article_Title__c, DOI__c, Manuscript_ID__c, Submission_ID__c, Primary_Contact_Name__c, Primary_Contact_s_email_id__c, SBQQ__Account__c, 
            Organization_Name__c, Payer__c, Payer_Contact_Name__c, Payer_Email__c, Payer_Account__c, Payer_Organization_Name__c, Payer_Campus__c, Payer_Department__c, VAT_Number__c, Tax_Registration_Number__c,Tax_Category__c, Purchase_Order_Number__c, 
            Use_Prepay_Budget__c, SBQQ__BillingStreet__c, SBQQ__BillingCity__c, SBQQ__BillingState__c, Bill_To_State_ISO_Code__c, SBQQ__BillingPostalCode__c, SBQQ__BillingCountry__c, SBQQ__ShippingStreet__c, 
            SBQQ__ShippingCity__c, SBQQ__ShippingState__c, Ship_To_State_ISO_Code__c, SBQQ__ShippingPostalCode__c, SBQQ__ShippingCountry__c, SBQQ__Status__c, Same_as_Billing__c, Apply_Country_Discount__c, Article_Acceptance_Status__c,
            Bill_To_Street_2__c, SBQQ__ShippingName__c, Ship_to_Organization__c, Ship_To_Street_2__c, Organization_Campus__c, Organization_Department__c, Author_Status__c, randomstring__c, Primary_Contact_s_Phone_Number__c, Payer_Contact_Phone_Number__c
            FROM SBQQ__Quote__c 
            WHERE Id = :quoteId limit 1
        ];
        system.debug('++++  ' + qouteFromDatabase );
        list<SBQQ__QuoteLine__c> quoteLineitem = [
            SELECT SBQQ__ProductName__c,SBQQ__Product__r.APC_Price_Category__c,SBQQ__TotalDiscountAmount__c,SBQQ__TotalDiscountRate__c,Final_Net_Amount__c ,Product_Article_Type__c,Discount_Rules_Applied__c,Best_Discount_Rule__c, Discount_Display_Name__c, SBQQ__ProductCode__c, Product_Open_Access_Category__c, Author_Facing_Article_Type__c, SBQQ__ListPrice__c, Product_Type__c
            FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c = :quoteId LIMIT 10];        
        QuoteModel startingQuoteModel = new QuoteModel();
        startingQuoteModel.record = qouteFromDatabase;
        startingQuoteModel.lineItem = quoteLineitem;
        
        return convertToQuoteDetailResponse(startingQuoteModel);
    }
    
    global static String getQuoteByUniqueID(String jsonStr) {
        QuoteRequest request = (QuoteRequest) JSON.deserialize(jsonStr, QuoteRequest.class);
        QuoteDetailResponse response = new QuoteDetailResponse();
        try { 
            
            SBQQ__Quote__c quoteFromDatabase = [SELECT Id, Name,Preview_URL__c,Payer_First_Name__c,Journal_Code__c,Payer_Last_Name__c,Business_Partner_Shipping_Number__c ,Business_Partner_Billing_Number__c ,PartyId__c,PayerPartyID__c,Customer_Ship_Address_ID__c,Discreationary_Waiver_Flag__c,Reason_for_Discreationary_Waiver__c,Request_ID__c,Country_Code__c,Website__c,Customer_Bill_Address_ID__c, SBQQ__ListAmount__c, Total_Discounted_Amount__c, Payer_Contact_Phone_Number__c, Primary_Contact_s_Phone_Number__c,Stop_Rejection_Email_to_Author__c , 
                                                Stop_Acceptance_Email_to_Author__c,Stop_Approval_Request_Email_to_Author__c,Entry_Point__c,Invoice_Number__c,Invoice_Status__c,Disable_PrePay_Manual_Approval_Case__c,
                                                PromoCode__c,Manual_Check__c,Payer_Organization_RinGold_ID__c,Lead_Author_Organization_RinGold_ID__c,Total_Discount_Percent__c, CurrencyIsoCode, SBQQ__NetAmount__c,CSD_Approval_Status__c,
                                                Country_Applicable_List__c, Article_Title__c, DOI__c, Manuscript_ID__c, Submission_ID__c, Primary_Contact_Name__c, Primary_Contact_s_email_id__c, SBQQ__Account__c, 
                                                Organization_Name__c, Payer__c, Payer_Contact_Name__c, Payer_Email__c, Payer_Account__c, Payer_Organization_Name__c, Payer_Campus__c, Payer_Department__c, VAT_Number__c, 
                                                Tax_Registration_Number__c,Tax_Category__c, Purchase_Order_Number__c, Use_Prepay_Budget__c, SBQQ__BillingStreet__c, SBQQ__BillingCity__c, SBQQ__BillingState__c, Bill_To_State_ISO_Code__c, 
                                                SBQQ__BillingPostalCode__c, SBQQ__BillingCountry__c, SBQQ__ShippingStreet__c, SBQQ__ShippingCity__c, SBQQ__ShippingState__c, Ship_To_State_ISO_Code__c, SBQQ__ShippingPostalCode__c, 
                                                SBQQ__ShippingCountry__c, SBQQ__Status__c,  Same_as_Billing__c, Apply_Country_Discount__c, Article_Acceptance_Status__c, Bill_To_Street_2__c, SBQQ__ShippingName__c, Ship_to_Organization__c, 
                                                Ship_To_Street_2__c, Organization_Campus__c, Organization_Department__c, Author_Status__c,  randomstring__c  FROM SBQQ__Quote__c WHERE randomstring__c = :request.quoteUniqueID];
            
            system.debug('++++  ' + quoteFromDatabase );
            list<SBQQ__QuoteLine__c> quoteLineitem = [SELECT SBQQ__ProductName__c,Final_Net_Amount__c ,SBQQ__TotalDiscountAmount__c,SBQQ__TotalDiscountRate__c,SBQQ__Product__r.APC_Price_Category__c,Product_Article_Type__c,Discount_Rules_Applied__c, Best_Discount_Rule__c, Discount_Display_Name__c, SBQQ__ProductCode__c, Product_Open_Access_Category__c, Author_Facing_Article_Type__c, SBQQ__ListPrice__c, Product_Type__c  FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c = :quoteFromDatabase.id limit 10];        
            QuoteModel startingQuoteModel = new QuoteModel();
            startingQuoteModel.record = quoteFromDatabase;
            startingQuoteModel.lineItem = quoteLineitem;
            
            response = convertToQuoteDetailResponse(startingQuoteModel);
            
        } catch (Exception ex) {
            system.debug(ex);
            response.setError('Quote not found ' + ex.getMessage() + ' ** ' + request.quoteUniqueID);
        } 
        return JSON.serialize(response);       
    }
    
    global static String getQuote(String jsonStr) {
        system.debug('getQuote Called @@@');
        QuoteRequest request = (QuoteRequest) JSON.deserialize(jsonStr, QuoteRequest.class);
        return JSON.serialize(getQuote(request.quoteId));
    }
    
    private static QuoteDetailResponse getQuote(Id id) {
        system.debug('getQuoteDetail Called @@@');
        QuoteDetailResponse response = new QuoteDetailResponse();
        try {            
            SBQQ__Quote__c qouteFromDatabase = [SELECT Id, Name,Preview_URL__c,Payer_First_Name__c,Journal_Code__c,Payer_Last_Name__c,Business_Partner_Billing_Number__c  ,Business_Partner_Shipping_Number__c   ,Customer_Ship_Address_ID__c,PayerPartyID__c,Request_ID__c,Reason_for_Discreationary_Waiver__c,Discreationary_Waiver_Flag__c,Website__c,Customer_Bill_Address_ID__c,Country_Code__c, SBQQ__ListAmount__c, Total_Discounted_Amount__c, Payer_Contact_Phone_Number__c, Primary_Contact_s_Phone_Number__c,Stop_Rejection_Email_to_Author__c, 
                                    CSD_Approval_Status__c,Stop_Acceptance_Email_to_Author__c,Stop_Approval_Request_Email_to_Author__c,Entry_Point__c,Invoice_Number__c,Invoice_Status__c,Disable_PrePay_Manual_Approval_Case__c,
                                    PromoCode__c,Manual_Check__c,Payer_Organization_RinGold_ID__c,Lead_Author_Organization_RinGold_ID__c,Total_Discount_Percent__c, CurrencyIsoCode, SBQQ__NetAmount__c, 
                                    Country_Applicable_List__c, Article_Title__c, DOI__c, Manuscript_ID__c, Submission_ID__c, Primary_Contact_Name__c, Primary_Contact_s_email_id__c, SBQQ__Account__c, 
                                    Organization_Name__c, Payer__c, Payer_Contact_Name__c, Payer_Email__c, Payer_Account__c, Payer_Organization_Name__c,PartyId__c, Payer_Campus__c, Payer_Department__c, VAT_Number__c,
                                    Tax_Registration_Number__c,Tax_Category__c, Purchase_Order_Number__c, Use_Prepay_Budget__c, SBQQ__BillingStreet__c, SBQQ__BillingCity__c, SBQQ__BillingState__c,Bill_To_State_ISO_Code__c, 
                                    SBQQ__BillingPostalCode__c, SBQQ__BillingCountry__c, SBQQ__ShippingStreet__c, SBQQ__ShippingCity__c, SBQQ__ShippingState__c, Ship_To_State_ISO_Code__c, SBQQ__ShippingPostalCode__c, SBQQ__ShippingCountry__c, 
                                    SBQQ__Status__c,  Same_as_Billing__c, Apply_Country_Discount__c, Article_Acceptance_Status__c, Bill_To_Street_2__c, SBQQ__ShippingName__c, Ship_to_Organization__c, 
                                    Ship_To_Street_2__c, Organization_Campus__c, Organization_Department__c, Author_Status__c, randomstring__c  FROM SBQQ__Quote__c WHERE Id = :id];

            system.debug('++++  ' + qouteFromDatabase );
            list<SBQQ__QuoteLine__c> quoteLineitem = [SELECT SBQQ__ProductName__c,SBQQ__Product__r.APC_Price_Category__c, Final_Net_Amount__c ,SBQQ__TotalDiscountAmount__c ,SBQQ__TotalDiscountRate__c ,Product_Article_Type__c,Discount_Rules_Applied__c, Best_Discount_Rule__c, Discount_Display_Name__c, SBQQ__ProductCode__c, Product_Open_Access_Category__c, Author_Facing_Article_Type__c, SBQQ__ListPrice__c, Product_Type__c  
                                                FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c = :id limit 10];        
            
            QuoteModel startingQuoteModel = new QuoteModel();
            startingQuoteModel.record = qouteFromDatabase;
            startingQuoteModel.lineItem = quoteLineitem;            
            response = convertToQuoteDetailResponse(startingQuoteModel);
            
        } catch (Exception ex) {
            system.debug(ex);
            response.setError('Quote not found ' + ex.getMessage());
        }
        return response;
    }
    
    global static String getQuoteByParams(String jsonStr) {
       // Id Quoterecid = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'T&F - CPQ Quote');        
        list<QuoteDetailResponse> responseLst = new list<QuoteDetailResponse>();
        
        try {
            QuoteRequest request = (QuoteRequest) JSON.deserialize(jsonStr, QuoteRequest.class);
            
            if (String.isBlank(request.manuscriptId) && String.isBlank(request.doi) && String.isBlank(request.submissionId) && String.isBlank(request.requestID)) {
                responseLst.add(new QuoteDetailResponse());
                responseLst[0].setError('At least one parameter is mandatory');
                return JSON.serialize(responseLst);
            }
            
            List<SBQQ__Quote__c> qouteFromDatabaseList = [SELECT Id,Preview_URL__c,Journal_Code__c,Payer_First_Name__c,Payer_Last_Name__c,Request_ID__c,Website__c,Discreationary_Waiver_Flag__c ,Reason_for_Discreationary_Waiver__c,Name,Business_Partner_Billing_Number__c,Business_Partner_Shipping_Number__c    ,PartyId__c,PayerPartyID__c,Customer_Ship_Address_ID__c,Country_Code__c,Customer_Bill_Address_ID__c, CreatedDate, SBQQ__ListAmount__c, Total_Discounted_Amount__c, Payer_Contact_Phone_Number__c, Primary_Contact_s_Phone_Number__c,
                                                          CSD_Approval_Status__c,Stop_Rejection_Email_to_Author__c , Stop_Acceptance_Email_to_Author__c,Stop_Approval_Request_Email_to_Author__c,Entry_Point__c,Invoice_Number__c,
                                                          Invoice_Status__c,Disable_PrePay_Manual_Approval_Case__c,PromoCode__c, Total_Discount_Percent__c, CurrencyIsoCode, SBQQ__NetAmount__c, Submission_ID__c, 
                                                          Manuscript_ID__c, DOI__c,Country_Applicable_List__c, Article_Title__c, Primary_Contact_Name__c, Primary_Contact_s_email_id__c, SBQQ__Account__c, 
                                                          Organization_Name__c, Payer__c, Payer_Contact_Name__c, Payer_Email__c, Payer_Account__c, Payer_Organization_Name__c, Payer_Campus__c, Payer_Department__c, 
                                                          VAT_Number__c, Tax_Registration_Number__c,Tax_Category__c, Purchase_Order_Number__c, Use_Prepay_Budget__c, SBQQ__BillingStreet__c, SBQQ__BillingCity__c, 
                                                          SBQQ__BillingState__c, Bill_To_State_ISO_Code__c, SBQQ__BillingPostalCode__c, SBQQ__BillingCountry__c, SBQQ__ShippingStreet__c, SBQQ__ShippingCity__c, 
                                                          SBQQ__ShippingState__c, Ship_To_State_ISO_Code__c, SBQQ__ShippingPostalCode__c, SBQQ__ShippingCountry__c, Author_Status__c,  Same_as_Billing__c, 
                                                          Apply_Country_Discount__c, Article_Acceptance_Status__c, SBQQ__Status__c, Bill_To_Street_2__c, SBQQ__ShippingName__c, Ship_to_Organization__c, 
                                                          Ship_To_Street_2__c, Organization_Campus__c, Organization_Department__c, randomstring__c,Manual_Check__c,Payer_Organization_RinGold_ID__c,
                                                          Lead_Author_Organization_RinGold_ID__c
                                                          FROM SBQQ__Quote__c 
                                                          WHERE (Submission_ID__c = :request.submissionId AND Submission_ID__c != null)
                                                          OR (Manuscript_ID__c = :request.manuscriptId AND Manuscript_ID__c != null)
                                                          OR (DOI__c = :request.doi AND DOI__c != null) OR (Request_ID__c =:request.requestID AND Request_ID__c != null) order by Name ASC
    ]; 
            system.debug('qouteFromDatabaseListSIZE::'+qouteFromDatabaseList.size());
            system.debug('qouteFromDatabaseList::'+qouteFromDatabaseList);
            QuoteModel startingQuoteModel = new QuoteModel();
            if(qouteFromDatabaseList != NULL && qouteFromDatabaseList.Size() > 0){
                set<String> quoteIds = new set<String>();
                for(SBQQ__Quote__c quoteObj : qouteFromDatabaseList){
                    quoteIds.add(quoteObj.Id);
                }
                
                map<Id, SBQQ__QuoteLine__c> quoteToQuoteLineItemMap = new map<Id, SBQQ__QuoteLine__c>();
                list<SBQQ__QuoteLine__c> quoteLineitem = [SELECT SBQQ__Quote__c,SBQQ__ProductName__c, Product_Article_Type__c,
                                                          Discount_Rules_Applied__c,SBQQ__Product__r.APC_Price_Category__c,SBQQ__NetPrice__c ,Final_Net_Amount__c ,SBQQ__TotalDiscountRate__c ,SBQQ__TotalDiscountAmount__c , Best_Discount_Rule__c, Discount_Display_Name__c, 
                                                          SBQQ__ProductCode__c, Product_Open_Access_Category__c, Author_Facing_Article_Type__c, 
                                                          SBQQ__ListPrice__c, Product_Type__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c IN : quoteIds];        
                
                for(SBQQ__QuoteLine__c LineItem : quoteLineitem){ 
                    quoteToQuoteLineItemMap.put(LineItem.SBQQ__Quote__c,LineItem);
                }
                
                for (SBQQ__Quote__c Quote:qouteFromDatabaseList){ 
                    if (quoteToQuoteLineItemMap.containsKey(Quote.Id)){                   
                        Id QuoteId = Id.valueOf(Quote.Id);
                        startingQuoteModel.record = Quote;
                        startingQuoteModel.lineItem =  quoteLineitem;
                        responseLst.add(convertToQuoteDetailResponse(startingQuoteModel));
                    }
                }
                return JSON.serialize(responseLst);
            }
            else{  
                return JSON.serialize(responseLst);               
            }  
        } 
        catch (Exception ex) {  
            QuoteDetailResponse response = new QuoteDetailResponse();
            response.setError('Quote not found ' + ex.getMessage());
            return JSON.serialize(response);
        }    
    }
    
    private static QuoteDetailResponse convertToQuoteDetailResponse(QuoteModel quoteModel ) {
        QuoteDetailResponse response = new QuoteDetailResponse();
        
        response.success = true; 
        String qId = quoteModel.record.Id;
        response.quoteId = qId.substring(0,15);         
        response.quoteUniqueID = quoteModel.record.randomstring__c;
        response.quoteNumber = quoteModel.record.Name;
        response.status = quoteModel.record.SBQQ__Status__c;
        response.listAmount = quoteModel.record.SBQQ__ListAmount__c;
        response.discountAmount = quoteModel.record.Total_Discounted_Amount__c;
        response.discountPercentage = quoteModel.record.Total_Discount_Percent__c;
        response.currencyIsoCode = quoteModel.record.CurrencyIsoCode;
        response.netAmount = quoteModel.record.SBQQ__NetAmount__c;
        
        response.CSDApprovalStatus = quoteModel.record.CSD_Approval_Status__c;             
        response.invoiceStatus = quoteModel.record.Invoice_Status__c;
        response.invoiceNumber = quoteModel.record.Invoice_Number__c;      
        
        /* start quoteRequest var */
        GenerateQuoteRequest quoteRequest = new GenerateQuoteRequest(); 
        quoteRequest.previewURL = quoteModel.record.Preview_URL__c;
        quoteRequest.articelTitle = quoteModel.record.Article_Title__c;
        quoteRequest.journalCode = quoteModel.record.Journal_Code__c;
        quoteRequest.doi = quoteModel.record.DOI__c;
        quoteRequest.manuscriptID = quoteModel.record.Manuscript_ID__c;
        quoteRequest.submissionID = quoteModel.record.Submission_ID__c;
        quoteRequest.requestId =quoteModel.record.Request_ID__c;
        quoteRequest.leadAuthorName = quoteModel.record.Primary_Contact_Name__c;
        quoteRequest.leadAuthorEmailID = quoteModel.record.Primary_Contact_s_email_id__c;
        quoteRequest.leadAuthorOrganizationID = quoteModel.record.SBQQ__Account__c;
        quoteRequest.leadAuthorOrganizationName = quoteModel.record.Organization_Name__c;
        quoteRequest.leadAuthorOrganizationCampus = quoteModel.record.Organization_Campus__c;
        quoteRequest.leadAuthorOrganizationDepartment = quoteModel.record.Organization_Department__c;
        quoteRequest.leadPrimaryContactPhoneNumber = quoteModel.record.Primary_Contact_s_Phone_Number__c;
        quoteRequest.leadAuthorPartyId =quoteModel.record.PartyId__c ;       
        quoteRequest.payercontactphonenumber = quoteModel.record.Payer_Contact_Phone_Number__c;
        quoteRequest.payerType = quoteModel.record.Payer__c;
        quoteRequest.payerContactName = quoteModel.record.Payer_Contact_Name__c;
        
        quoteRequest.payerFirstName  = quoteModel.record.Payer_First_Name__c ;
        quoteRequest.payerLastName  = quoteModel.record.Payer_Last_Name__c ;
        
        quoteRequest.payerEmailID = quoteModel.record.Payer_Email__c;
        quoteRequest.payerPartyID =quoteModel.record.PayerPartyID__c;
        quoteRequest.website = quoteModel.record.Website__c;        
        if(quoteModel.record.Payer_Account__c != null){
            String payerOrganizationID = quoteModel.record.Payer_Account__c;
            quoteRequest.payerOrganizationID = payerOrganizationID.substring(0,15);
        }else{
            quoteRequest.payerOrganizationID = quoteModel.record.Payer_Account__c;
        }       
        quoteRequest.payerOrganizationName = quoteModel.record.Payer_Organization_Name__c;
        quoteRequest.payerOrganizationCampus = quoteModel.record.Payer_Campus__c;
        quoteRequest.payerOrganizationDepartment = quoteModel.record.Payer_Department__c;
        quoteRequest.countryCode = quoteModel.record.Country_Code__c;        
        quoteRequest.vatNumber = quoteModel.record.VAT_Number__c;       
        quoteRequest.taxRegistrationNumber = quoteModel.record.Tax_Registration_Number__c;
        quoteRequest.taxCategory = quoteModel.record.Tax_Category__c;       
        quoteRequest.purchaseOrderNumber = quoteModel.record.Purchase_Order_Number__c;
        quoteRequest.canUsePrepayBudget = quoteModel.record.Use_Prepay_Budget__c;
        quoteRequest.billingStreet = quoteModel.record.SBQQ__BillingStreet__c;
        quoteRequest.billingStreet2 = quoteModel.record.Bill_To_Street_2__c;
        quoteRequest.billingCity = quoteModel.record.SBQQ__BillingCity__c;
        quoteRequest.billingState = quoteModel.record.SBQQ__BillingState__c;
        quoteRequest.billingStateISO = quoteModel.record.Bill_To_State_ISO_Code__c;
        quoteRequest.bilingPostalCode = quoteModel.record.SBQQ__BillingPostalCode__c;
        quoteRequest.billingCountry = quoteModel.record.SBQQ__BillingCountry__c;
        quoteRequest.billingBPNumber  = quoteModel.record.Business_Partner_Billing_Number__c;
        quoteRequest.billingAddressID   = quoteModel.record.Customer_Bill_Address_ID__c;
        quoteRequest.sameAsBilling = quoteModel.record.Same_as_Billing__c;       
        quoteRequest.shipToContact = quoteModel.record.SBQQ__ShippingName__c;
        quoteRequest.shipToOrganization = quoteModel.record.Ship_to_Organization__c;        
        quoteRequest.shipToStreet = quoteModel.record.SBQQ__ShippingStreet__c;
        quoteRequest.shipToStreet2 = quoteModel.record.Ship_To_Street_2__c;
        quoteRequest.shipToCity = quoteModel.record.SBQQ__ShippingCity__c;
        quoteRequest.shipToState = quoteModel.record.SBQQ__ShippingState__c;
        quoteRequest.shipToStateISO = quoteModel.record.Ship_To_State_ISO_Code__c;
        quoteRequest.shipToPostalCode = quoteModel.record.SBQQ__ShippingPostalCode__c;
        quoteRequest.shipToCountry = quoteModel.record.SBQQ__ShippingCountry__c;
        quoteRequest.shippingBPNumber  = quoteModel.record.Business_Partner_Shipping_Number__c;
        quoteRequest.shippingAddressID  = quoteModel.record.Customer_Ship_Address_ID__c;       
        quoteRequest.canApplyCountryDiscount = quoteModel.record.Apply_Country_Discount__c;
        quoteRequest.disableRejectionEmail = quoteModel.record.Stop_Rejection_Email_to_Author__c;
        quoteRequest.disableQuoteCreationNotificationEmailToAuthor = quoteModel.record.Stop_Acceptance_Email_to_Author__c;        
        quoteRequest.disablePrePayApprovalNotificationEmailToAuthor = quoteModel.record.Stop_Approval_Request_Email_to_Author__c;
        quoteRequest.disablePrePayManualApprovalCase = quoteModel.record.Disable_PrePay_Manual_Approval_Case__c;
        quoteRequest.entryPoint = quoteModel.record.Entry_Point__c;
        quoteRequest.promoCode = quoteModel.record.PromoCode__c;
        quoteRequest.needsManualApproval = quoteModel.record.Manual_Check__c;
        quoteRequest.discreationaryWaiverStatus= quoteModel.record.Discreationary_Waiver_Flag__c;
        quoteRequest.reasonForDiscreantionaryWaiver=quoteModel.record.Reason_for_Discreationary_Waiver__c;        
        if(quoteModel.record.Article_Acceptance_Status__c != null && quoteModel.record.Article_Acceptance_Status__c.equals('Accepted')) {
            quoteRequest.isArticleAccepted = true;
        } else {
            quoteRequest.isArticleAccepted = false;
        }        
        if(quoteModel.record.Author_Status__c != null && quoteModel.record.Author_Status__c.equals('Accepted')) {
            quoteRequest.isAuthorAccepted = true;
        } else {
            quoteRequest.isAuthorAccepted = false;
        }
        
        if(quoteModel.record.Payer__c != null && quoteModel.record.Payer__c.equals('Organization')) {
            String leadAuthorOrganizationID = quoteModel.record.Payer_Account__c;
            if(String.isEmpty(leadAuthorOrganizationID)){
                quoteRequest.leadAuthorOrganizationID = quoteModel.record.Payer_Account__c;
            }else{
                quoteRequest.leadAuthorOrganizationID = leadAuthorOrganizationID.substring(0,15);
            } 
        }        
        quoteRequest.payerOrganizationRingoldID = quoteModel.record.Payer_Organization_RinGold_ID__c; 
        quoteRequest.leadAuthorOrganizationRingoldID = quoteModel.record.Lead_Author_Organization_RinGold_ID__c;
        quoteRequest.leadAuthorPartyID =quoteModel.record.PartyId__c;
        quoteRequest.payerPartyID =quoteModel.record.PayerPartyID__c;
        
        response.quoteRequest = quoteRequest;
        /* end quoteRequest var */
        
        List<lineItemDetails> lineItemList = new list<lineItemDetails>();        
        for(SBQQ__QuoteLine__c lineItemObj : quoteModel.lineItem){
            lineItemDetails lineItems = new lineItemDetails();
            lineItems.articleType = lineItemObj.Product_Article_Type__c;            
            lineItems.productCode = lineItemObj.SBQQ__ProductCode__c;            
            if(lineItemObj.SBQQ__ListPrice__c == null) {
                //lineItems.isPriceRuleAppled = false;
                response.isPriceRuleAppled = false;
            } else {
               //lineItems.isPriceRuleAppled = true;
               response.isPriceRuleAppled = true;
            }           
            lineItems.journalName = lineItemObj.SBQQ__ProductName__c;
            lineItems.discountDisplayName = lineItemObj.Discount_Display_Name__c;
            lineItems.productOpenAccessCategory = lineItemObj.Product_Open_Access_Category__c;
            lineItems.APCPriceCategory = lineItemObj.SBQQ__Product__r.APC_Price_Category__c;
            lineItems.serviceName = lineItemObj.Product_Type__c;
            lineItems.authorFacingArticleType = lineItemObj.Author_Facing_Article_Type__c;
            lineItems.listAmount = lineItemObj.SBQQ__ListPrice__c;
            lineItems.netAmount = lineItemObj.Final_Net_Amount__c;
            lineItems.discountAmount  = lineItemObj.SBQQ__TotalDiscountAmount__c;
            lineItems.discountPercentage  = lineItemObj.SBQQ__TotalDiscountRate__c;          
            lineItemList.add(lineItems);
        }          
		response.lineItems = lineItemList;
        
        system.debug(quoteModel);
        system.debug(response);
        
        return response;
    }
    
    private static String updateInvoiceNumber(String jsonString) {
        system.debug('@@@Inside update invoice number method.');
        UpdateInvoiceNumberRequest request = (UpdateInvoiceNumberRequest)JSON.deserialize(jsonString, UpdateInvoiceNumberRequest.class);
        QuoteResponse response = new QuoteResponse();      
         if(String.isNotBlank(request.orderHubNumber) && String.isNotBlank(request.invoiceNumber) && Pattern.compile('[a-zA-Z0-9]*').matcher(request.orderHubNumber).matches()) {
            List<SBQQ__Quote__c> quoteObj = new List<SBQQ__Quote__c>();       
            quoteObj = [SELECT Id, Name, randomstring__c,Invoice_Number__c, Invoice_Status__c,CSD_Approval_Status__c FROM SBQQ__Quote__c WHERE Order_Hub_Number__c = :request.orderHubNumber];               
            if(quoteObj.size() == 0) {
                response.setError('Can not find quote for given order bub number.');
            }else{
                try{
                    quoteObj[0].Invoice_Number__c = request.invoiceNumber;
                    quoteObj[0].Invoice_Status__c = request.invoiceStatus;
                    update quoteObj;
                    response.quoteId = quoteObj[0].Id;                  
                    response.success = true;                    
                } catch(Exception e){
                    response.success = false;
                    response.setError(e.getMessage());            
                }                
            }            
        }else{
            response.setError('Invalid input value.');
        } 
        return JSON.serialize(response);        
    }
        
    //Validate CPQ Discount Configuration PromoCode
    private static String checkPromoCode(String jsonString) {
        Id promoCodeRecTypeId = Schema.SObjectType.CPQ_Discount_Configuration__c.getRecordTypeInfosByName().get('T&F - PromoCode').getRecordTypeId();
        QuotePromoCodeRequest request = (QuotePromoCodeRequest)JSON.deserialize(jsonString, QuotePromoCodeRequest.class);
        QuotePromoCodeResponse response = new QuotePromoCodeResponse();        
        DateTime todayDateTime = System.now();
        Date todayDate = date.newinstance(todayDateTime.year(), todayDateTime.month(), todayDateTime.day());
        Set<String> payerTypeList = new Set<String>{'Self', 'Organization', 'Third party', 'Third party Organization'};
        //The promo code and product code both are mandatory
        if ( (request.promoCode != null || String.isNotBlank(request.promoCode) ) && 
            (request.productCode != null || String.isNotBlank(request.productCode) ) && (payerTypeList.contains(request.payerType))
            //(request.payerType != null || String.isNotBlank(request.payerType) )
           ) 
        {
            List<CPQ_Discount_Configuration__c> cpqDiscountConfigObj = new List<CPQ_Discount_Configuration__c>();
            cpqDiscountConfigObj = [SELECT Id,Discount_Category__c,Discount_Value_Percentage__c,Promocode__c,Start_Date__c,End_Date__c,Active__c FROM CPQ_Discount_Configuration__c WHERE RecordTypeId = :promoCodeRecTypeId AND (Promocode__c = :request.promoCode AND Product_Code__c = :request.productCode) limit 1];
            try{
                if(cpqDiscountConfigObj.size() == 0) {
                    response.setError('Invalid promo code / invalid product code.');
                }else{
                    if(cpqDiscountConfigObj[0].Active__c == false){
                        response.promoCode = cpqDiscountConfigObj[0].Promocode__c;
                        response.discountCategory = cpqDiscountConfigObj[0].Discount_Category__c;
                        response.setError('Not an active promo code.');                        
                    }else if(((todayDate >= cpqDiscountConfigObj[0].Start_Date__c) && (todayDate <= cpqDiscountConfigObj[0].End_Date__c)) != true){
                        response.promoCode = cpqDiscountConfigObj[0].Promocode__c;
                        response.discountCategory = cpqDiscountConfigObj[0].Discount_Category__c;
                        response.setError('Promo code has expired.');
                    } else if (request.payerType != 'Self' && cpqDiscountConfigObj[0].Discount_Category__c == 'Ad hoc'){
                        response.promoCode = cpqDiscountConfigObj[0].Promocode__c;
                        response.discountCategory = cpqDiscountConfigObj[0].Discount_Category__c;
                        response.setError('Not a valid promo code. Invalid payer type.');                    
                    }else {
                        response.success = true;
                        response.promoCode = cpqDiscountConfigObj[0].Promocode__c;
                        response.discountCategory = cpqDiscountConfigObj[0].Discount_Category__c;
                        response.discountPercentage =  cpqDiscountConfigObj[0].Discount_Value_Percentage__c;
                    }                                
                }            
            } catch(Exception e){
                response.success = false;
                response.setError(e.getMessage());            
            }
        }else{
            response.setError('Invalid input request.');
        }
        return JSON.serialize(response);
    }
    
    //expiring an existing quote if it not already invoiced/expired
    private static String expiresQuote(String jsonString){
        Set<string> notAllowedStatus = new Set<string>{'Invoiced','Expired'};
            QuoteExpireRequest request = (QuoteExpireRequest)JSON.deserialize(jsonString, QuoteExpireRequest.class);
        QuoteDetailResponse response = new QuoteDetailResponse();        
        if(request.quoteUniqueId != NULL && String.isNotBlank(request.quoteUniqueId)){
            List<SBQQ__Quote__c> quoteObj = new List<SBQQ__Quote__c>();       
            quoteObj = [SELECT Id,SBQQ__Status__c,CSD_Approval_Status__c FROM SBQQ__Quote__c WHERE randomstring__c = :request.quoteUniqueId];
            if(quoteObj.size() == 0) {
                response.setError('Can not find quote for given quoteUniqueId : ' + request.quoteUniqueId);
            } else {
                try {
                    if(!JSON.serialize(notAllowedStatus).contains(quoteObj[0].SBQQ__Status__c)){               
                        quoteObj[0].SBQQ__Status__c = 'Expired';
                        update quoteObj;
                        response = generateQuoteDetailResponse(quoteObj[0].Id);
                        response.success = true;
                    }else{
                        response.setError('The requested quote has already been invoiced or expired.');
                    }
                } catch(Exception e) {
                    response.setError(e.getMessage());
                } 
            }
        }else{
            response.setError('Invalid input request.');
        }                            
        return JSON.serialize(response);
    }
    
    private static String updateQuoteStatus(String jsonString){
        Set<string> notAllowedStatus = new Set<string>{'Submission Withdrawn','Submission Rejected'};
            UpdateQuoteStatusRequest request = (UpdateQuoteStatusRequest)JSON.deserialize(jsonString, UpdateQuoteStatusRequest.class);
        QuoteDetailResponse response = new QuoteDetailResponse();        
        if(request.quoteUniqueId != NULL && String.isNotBlank(request.quoteUniqueId)){
            List<SBQQ__Quote__c> quoteObj = new List<SBQQ__Quote__c>();       
            quoteObj = [SELECT Id,SBQQ__Status__c,CSD_Approval_Status__c FROM SBQQ__Quote__c WHERE randomstring__c = :request.quoteUniqueId];
            if(quoteObj.size() == 0) {
                response.setError('Can not find quote for given quoteUniqueId : ' + request.quoteUniqueId);
            } else {
                try {
                    if(JSON.serialize(notAllowedStatus).contains(request.status) && quoteObj[0].SBQQ__Status__c == request.status){
                        response.setError('The requested quote has already been submission withdraw or submission rejected.');
                    }                    
                     else if(request.status == 'Submission Withdrawn' || request.status == 'Submission Rejected'){               
                        quoteObj[0].SBQQ__Status__c = request.status;
                        //quoteObj[0].SBQQ__Status__c = '';
                        update quoteObj;
                        response = generateQuoteDetailResponse(quoteObj[0].Id);
                        response.success = true;
                    }
                } catch(Exception e) {
                    response.setError(e.getMessage());
                } 
            }
        }else{
            response.setError('Invalid input request.');
        }                            
        return JSON.serialize(response);
    }
    
    
    private static String updateQuoteDetails(String jsonString){
        String command              = getCommand(RestContext.request.requestURI);
        String quoteUniqueId = command.substring(command.lastIndexOf('/')+1);
        QuoteUpdateRequest request = (QuoteUpdateRequest)JSON.deserialize(jsonString, QuoteUpdateRequest.class);
        QuoteDetailResponse response = new QuoteDetailResponse();
        if(quoteUniqueId != null && String.isNotBlank(quoteUniqueId)){           
            try {
                SBQQ__Quote__c quoteObj = [SELECT Id,DOI__c,Request_ID__c,Country_Code__c,Submission_ID__c,CanInvoice__c,SBQQ__BillingStreet__c,CSD_Approval_Status__c,Payer__c,Business_Partner_Billing_Number__c from SBQQ__Quote__c WHERE randomstring__c = :quoteUniqueId];
                if (String.isNotBlank(quoteObj.Id)) {   
                     if(request.canInvoice != null && request.canInvoice == true){ 
                        quoteObj.CanInvoice__c = true; 
                    }
                    
                      if(request.isArticleAccepted != null && request.isArticleAccepted == true) {
                        quoteObj.Article_Acceptance_Status__c = 'Accepted';
                    }
                    
                    if(request.doi != null && String.isNotBlank(request.doi)){ 
                        quoteObj.DOI__c = request.doi;
                        
                            
                       }
                    
                     if(request.requestID  != null && String.isNotBlank(request.requestID)){
                     quoteObj.Request_ID__c = request.requestID;
                     }   
            
                    //Billing address
                    
                    if(request.billingStreet != NULL) { quoteObj.SBQQ__BillingStreet__c = request.billingStreet; } 
                    if(request.billingStreet2 != NULL) { quoteObj.Bill_To_Street_2__c = request.billingStreet2; }
                    if(request.billingCity != NULL) { quoteObj.SBQQ__BillingCity__c = request.billingCity; }
                    if(request.billingState != NULL) { quoteObj.SBQQ__BillingState__c = request.billingState; } 
                    if(request.billingStateISO != NULL) { quoteObj.Bill_To_State_ISO_Code__c = request.billingStateISO; }
                    if(request.billingPostalCode != NULL) { quoteObj.SBQQ__BillingPostalCode__c = request.billingPostalCode; } 
                    
                    //Shipping address
                    if(request.sameAsBilling != NULL) { quoteObj.Same_as_Billing__c = request.sameAsBilling; }
                    if(request.shipToContact != NULL) { quoteObj.SBQQ__ShippingName__c = request.shipToContact; }
                    if(request.shipToOrganization != NULL) { quoteObj.Ship_to_Organization__c = request.shipToOrganization; }
                    if(request.shipToStreet != NULL) { quoteObj.SBQQ__ShippingStreet__c = request.shipToStreet; }
                    if(request.shipToStreet2 != NULL) { quoteObj.Ship_To_Street_2__c = request.shipToStreet2; }
                    if(request.shipToCity != NULL) { quoteObj.SBQQ__ShippingCity__c = request.shipToCity; }
                    if(request.shipToState != NULL) { quoteObj.SBQQ__ShippingState__c = request.shipToState; }
                    if(request.shipToStateISO != NULL) { quoteObj.Ship_To_State_ISO_Code__c = request.shipToStateISO; }
                    if(request.shipToPostalCode != NULL) { quoteObj.SBQQ__ShippingPostalCode__c = request.shipToPostalCode; }
                    if(request.shipToCountry != NULL) { quoteObj.SBQQ__ShippingCountry__c = request.shipToCountry; }                                              
                    
                    if(request.vatNumber != NULL) { quoteObj.VAT_Number__c = request.vatNumber; }
                    if(request.purchaseOrderNumber != NULL) { quoteObj.Purchase_Order_Number__c = request.purchaseOrderNumber; }
                    if(request.payercontactphonenumber != NULL) { quoteObj.Payer_Contact_Phone_Number__c = request.payercontactphonenumber; }
                    if(request.payerContactName != NULL) { quoteObj.Payer_Contact_Name__c = request.payerContactName; }       
                    if(request.payerFirstName != NULL) { quoteObj.Payer_First_Name__c = request.payerFirstName; }
                    if(request.payerLastName != NULL) { quoteObj.Payer_Last_Name__c= request.payerLastName ; }                    
                    if(request.payerOrganizationDepartment != NULL) { quoteObj.Payer_Department__c = request.payerOrganizationDepartment; } //Third party Organization or Third party
                    if(request.payerOrganizationCampus != NULL) { quoteObj.Payer_Campus__c = request.payerOrganizationCampus; } //Third party Organization or Third party
                    if(request.payerPartyID != NULL) { quoteObj.PayerPartyID__c  = request.payerPartyID; }
                    if(request.taxRegistrationNumber != NULL) { quoteObj.Tax_Registration_Number__c = request.taxRegistrationNumber; }
                    if(request.taxCategory != NULL) { quoteObj.Tax_Category__c = request.taxCategory; }
                    
                    //update others
                   if(request.billingBPNumber  != NULL) { quoteObj.Business_Partner_Billing_Number__c = request.billingBPNumber ; }
                   if(request.shippingBPNumber  != NULL) { quoteObj.Business_Partner_Shipping_Number__c = request.shippingBPNumber ; }
                   if(request.billingAddressID  != NULL) { quoteObj.Customer_Bill_Address_ID__c = request.billingAddressID ; }
                   if(request.shippingAddressID  != NULL) { quoteObj.Customer_Ship_Address_ID__c = request.shippingAddressID ; }
                  // if(request.reasonForDiscreantionaryWaiver   != NULL) { quoteObj.Reason_for_Discreationary_Waiver__c    = request.reasonForDiscreantionaryWaiver  ; }
                   if(request.discreationaryWaiverStatus != NULL) { quoteObj.Discreationary_Waiver_Flag__c = request.discreationaryWaiverStatus  ; }
                    
                    update quoteObj; // Update records
                    response = generateQuoteDetailResponse(quoteObj.Id);
                    response.success = true;
                }else{
                    response.setError('Invalid Unique Quote Id.');
                }
            } catch(Exception e) {
                response.setError(e.getMessage());
            }
        }else{
            response.setError('QuoteId in query parameter is mandatory as /updateQuoteDetails/QuoteId.');  
        }
        return JSON.serialize(response);
    }
    
    private static String updateCSDStatus(String jsonString){
        UpdateCSDApprovalStatusRequest request = (UpdateCSDApprovalStatusRequest)JSON.deserialize(jsonString, UpdateCSDApprovalStatusRequest.class);
        QuoteResponse response = new QuoteResponse();
        if(request.quoteUniqueId != NULL && request.CSDApprovalStatus != NULL &&
           String.isNotBlank(request.quoteUniqueId) && String.isNotBlank(request.CSDApprovalStatus)){
               
               try {
                   SBQQ__Quote__c quoteObj = [SELECT Id, Name,randomstring__c , Author_Status__c,CSD_Approval_Status__c from SBQQ__Quote__c WHERE randomstring__c = :request.quoteUniqueId];
                   
                   if(String.isNotBlank(quoteObj.Author_Status__c) && quoteObj.Author_Status__c == 'Accepted'){
                       List<Quote_Approval__c> quoteApprovalList = [SELECT Id, Name, Approval_Type__c, Approved_Rejected_Date__c, Quote__c, Quote_Approval_Status__c, quote__r.Author_Status__c 
                                                                    FROM Quote_Approval__c 
                                                                    Where Quote__r.Name = :quoteObj.Name];
                       List<Quote_Approval__c> updatequoteApprovalList = new List<Quote_Approval__c>();
                       
                       if(quoteApprovalList != NULL && quoteApprovalList.Size() > 0){
                           for(Quote_Approval__c quoteApprovalObj : quoteApprovalList){
                               updatequoteApprovalList.add(new Quote_Approval__c(id = quoteApprovalObj.Id, Quote_Approval_Status__c = request.CSDApprovalStatus));
                           }
                           UPDATE updatequoteApprovalList;
                           response.quoteId = quoteApprovalList[0].Quote__c;
                           
                           response.success = true;
                       }else{
                           response.setError('This is not the prepay quote');
                       }
                   }else{
                       response.setError('Author should accept the quote');
                   }
               } catch(Exception e) {
                   response.setError(e.getMessage());
               }
           } else {
               response.setError('Invalid quote number or quote status');
           }
        return JSON.serialize(response);
    }
 
    
    global static String recalculateQuote(String jsonStr) {
        QuoteReCalculationRequest request = (QuoteReCalculationRequest)JSON.deserialize(jsonStr, QuoteReCalculationRequest.class);
        QuoteDetailResponse response = new QuoteDetailResponse();
        
        try {
            SBQQ__Quote__c quote = retrieveQuote(request.quoteUniqueId);
            set<String> countrySet = new set<String>();
            System.debug('request.recalculationRequest##>');
            countrySet.add(request.recalculationRequest.BillingCountry);
            countrySet.add(quote.SBQQ__BillingCountry__c);
            List<Country__c> countryList = [select id,Name,Preferred_currency__c from Country__c WHERE Name In : countrySet];
            system.debug('@@@@countryList' + countryList);
            Map<String, String> countryCurrencyMap = new Map<String, String>();
            for(Country__c countryObj : countryList){
                countryCurrencyMap.put(countryObj.Name, countryObj.Preferred_currency__c);
            }
            system.debug('@@@contains@@@' + countryCurrencyMap.containsKey(request.recalculationRequest.BillingCountry));
            if(countryCurrencyMap.containsKey(request.recalculationRequest.BillingCountry) && 
                quote.CurrencyIsoCode != countryCurrencyMap.get(request.recalculationRequest.BillingCountry)){
                system.debug('Inside if condition');
                response.setError('Country cannot be changed');
            }else{
                System.debug('request.recalculationRequest.products##>' + request.recalculationRequest.products);
                applyFieldsFromRequest(quote, request.recalculationRequest);
                //update quote;
                response = generateQuoteDetailResponse(quote.Id);
            }          
        } catch(Exception e) {
            System.debug('ERROR#>' + e.getMessage());
            response.setError(e.getMessage());
        } finally {
            return JSON.serialize(response);
        }        
        return JSON.serialize(response);
    }
    
    private static SBQQ__Quote__c retrieveQuote(String quoteId) {
        try {
            return [SELECT Id,CurrencyIsoCode,Currency__c, SBQQ__BillingCountry__c,CSD_Approval_Status__c FROM SBQQ__Quote__c WHERE randomstring__c = :quoteId];
        } catch(Exception e) {
            throw new QuoteNotFoundException('Quote not found');
        }
    }
    
    
    private static void applyFieldsFromRequest(SBQQ__Quote__c quote, GenerateQuoteRequest request) {
        set<String> productCodeSet = new set<String>();
        set<String> articleTypeSet = new set<String>();
        set<String> productArticleSet = new set<String>();
        if(request.products != NULL && request.products.Size() > 0){
            for(lineItemDetails productDetObj : request.products){
                if(string.isNotBlank(productDetObj.productCode) && String.isNotBlank(productDetObj.articleType)){
                    productCodeSet.add(productDetObj.productCode);
                    articleTypeSet.add(productDetObj.articleType);
                    productArticleSet.add(productDetObj.productCode.toUpperCase() + '-' + productDetObj.articleType.toUpperCase());
                }
            }
        }
        String productId;        
        enrichRequest(request); //If request has ringold Id, then get the account id from Account object
                
        set<String> productIds = new set<String>();
        if(productArticleSet != NULL && productArticleSet.Size() > 0){
            
            List<Product2> productList = [select Id, Name, ProductCode, Article_Type__c from Product2 where ProductCode in :productCodeSet and Article_Type__c in :articleTypeSet and IsActive = true and Family = :productFamily];
            system.debug('@@@productCodeSet:' + productCodeSet);
            system.debug('@@@articleTypeSet:' + articleTypeSet);
            system.debug('@@@productFamily:' + productFamily);
            system.debug('@@@productList' + productList);
            if(productList != NULL && productList.Size() > 0){
                for(Product2 productObj : productList){
                    system.debug('@@@productObj' + productObj);
                    if(productArticleSet.contains(productObj.productCode.toUpperCase() + '-' + productObj.Article_Type__c.toUpperCase())){
                        if(productIds.contains(productObj.Id)){
                            throw new TooManyProductsException('Too Many products matching the criteria');
                        }
                        productIds.add(productObj.Id);
                    }
                }
            }else{
                throw new NoProductsException('There is no product matching the criteria');
            }
            
        }
        if(productIds.size() == 0){
            throw new NoProductsException('There is no product matching the criteria');
        }        
        
        quote.PromoCode__c = request.promoCode;
        quote.Article_Title__c = request.articelTitle;
        quote.Journal_Code__c = request.journalcode;
        quote.DOI__c = request.doi;
        quote.Manuscript_ID__c = request.manuscriptID;
        quote.Submission_ID__c = request.submissionID;
        
        // -- Primary contact details
        quote.Primary_Contact_Name__c = request.leadAuthorName;
        quote.Primary_Contact_s_email_id__c = request.leadAuthorEmailID;
        quote.Primary_Contact_s_Phone_Number__c = request.leadPrimaryContactPhoneNumber;
        quote.Organization_Name__c = request.leadAuthorOrganizationName;
        quote.Lead_Author_Organization_RinGold_ID__c = request.leadAuthorOrganizationRingoldID;
        quote.PartyId__c=request.leadAuthorPartyID ;
        
        // -- Tax Details
        quote.Tax_Registration_Number__c = request.taxRegistrationNumber;
        quote.Tax_Category__c = request.taxCategory; 
        
        // -- Payer Details
        quote.Payer__c = request.payerType;
        quote.Website__c=request.website;
        
        system.debug('request.payercontactphonenumber +++ ' + request.leadPrimaryContactPhoneNumber);
        system.debug('request.payercontactphonenumber +++ ' + request.payercontactphonenumber);
        
        if(request.payerType.equals('Self')) {
            quote.Payer_Contact_Phone_Number__c = request.leadPrimaryContactPhoneNumber;
            system.debug('quote.Payer_Contact_Phone_Number__c++++ ' + quote.Payer_Contact_Phone_Number__c);
            quote.Payer_Contact_Name__c = request.leadAuthorName;
            quote.Payer_First_Name__c = request.payerFirstName;
            quote.Payer_Last_Name__c  = request.payerLastName;            
            quote.Payer_Email__c = request.leadAuthorEmailID;
            quote.PayerPartyID__c=request.payerPartyID ;
            if(request.leadAuthorOrganizationID != null && request.leadAuthorOrganizationID != '') {
                quote.SBQQ__Account__c = request.leadAuthorOrganizationID;
            }
            quote.Organization_Campus__c = request.payerOrganizationCampus;
            quote.Organization_Department__c = request.payerOrganizationDepartment;
            quote.Payer_Account__c = null;
            quote.Payer_Organization_Name__c = null;
            quote.Payer_Campus__c = null;
            quote.Payer_Department__c = null;
            quote.VAT_Number__c = null;
            
        } 
        if (request.payerType.equals('Organization') || request.payerType.equals('Third party Organization')) {
            quote.Payer_Contact_Phone_Number__c = request.payercontactphonenumber;
            system.debug('quote.Payer_Contact_Phone_Number__c++++ ' + quote.Payer_Contact_Phone_Number__c);
            quote.Payer_Contact_Name__c = request.payerContactName;
            quote.Payer_First_Name__c = request.payerFirstName;
            quote.Payer_Last_Name__c  = request.payerLastName;            
            quote.Payer_Email__c = request.payerEmailID;
            quote.PayerPartyID__c=request.payerPartyID ;
            quote.Payer_Organization_RinGold_ID__c = request.payerOrganizationRingoldID;
            system.debug('request from payerorgid*****'+request.payerOrganizationRingoldID);
            
            quote.Payer_Campus__c = request.payerOrganizationCampus;
            quote.Payer_Department__c = request.payerOrganizationDepartment;
            quote.VAT_Number__c = request.vatNumber;            
            if(request.payerType.equals('Organization')) {
                quote.Payer_Organization_Name__c = request.leadAuthorOrganizationName;
                if(String.isNotBlank(request.leadAuthorOrganizationID)){
                    quote.Payer_Account__c = request.leadAuthorOrganizationID;
                }else{
                    quote.Payer_Account__c = null;
                }
                quote.Organization_Campus__c = request.payerOrganizationCampus;
                quote.Organization_Department__c = request.payerOrganizationDepartment;
            } else {
                quote.Payer_Organization_Name__c = request.payerOrganizationName;
                if(String.isNotBlank(request.payerOrganizationID)){
                    quote.Payer_Account__c = request.payerOrganizationID; 
                }else{
                    quote.Payer_Account__c = null;
                }
                if(request.payerOrganizationID != request.leadAuthorOrganizationID ) {
                    if(request.leadAuthorOrganizationID != null && request.leadAuthorOrganizationID != '') {
                        quote.SBQQ__Account__c = request.leadAuthorOrganizationID;
                    }
                }
            }         
        }
        
        if(request.payerType.equals('Third party')) {
            quote.Payer_Contact_Phone_Number__c = request.payercontactphonenumber;
            system.debug('quote.Payer_Contact_Phone_Number__c++++ ' + quote.Payer_Contact_Phone_Number__c);
            quote.Payer_Contact_Name__c = request.payerContactName;
            quote.Payer_First_Name__c = request.payerFirstName;
            quote.Payer_Last_Name__c  = request.payerLastName;            
            quote.Payer_Email__c = request.payerEmailID;
            quote.Payer_Organization_Name__c = request.payerOrganizationName;
            system.debug('request.payerOrganizationRingoldID****' + quote.Payer_Organization_RinGold_ID__c);
            quote.Payer_Campus__c = request.payerOrganizationCampus;
            quote.Payer_Department__c = request.payerOrganizationDepartment;
            quote.PayerPartyID__c=request.payerPartyID ;
            if(request.leadAuthorOrganizationID != null && request.leadAuthorOrganizationID != '') {
                quote.SBQQ__Account__c = request.leadAuthorOrganizationID;
            }
            quote.Payer_Account__c = null;     
            quote.VAT_Number__c = null;                
        } 
        
        quote.Purchase_Order_Number__c = request.purchaseOrderNumber;
        
        Date today = system.today();
        quote.SBQQ__ExpirationDate__c = today.addDays(30);
        quote.SBQQ__PricebookId__c = getPriceBookID();
        quote.Apply_Country_Discount__c = request.canApplyCountryDiscount;
        quote.Use_Prepay_Budget__c = request.canUsePrepayBudget;
        
        // Address details.
        quote.SBQQ__BillingStreet__c = request.billingStreet;
        quote.Bill_To_Street_2__c = request.billingStreet2;
        quote.SBQQ__BillingCity__c = request.billingCity;
        quote.SBQQ__BillingState__c = request.billingState;        
        quote.Bill_To_State_ISO_Code__c = request.billingStateISO;        
        quote.SBQQ__BillingPostalCode__c = request.bilingPostalCode;
        quote.SBQQ__BillingCountry__c = request.billingCountry;
        quote.Business_Partner_Billing_Number__c=request.billingBPNumber;
        quote.Customer_Bill_Address_ID__c=request.billingAddressID ;
        quote.Country_Code__c= request.countryCode ;
        
        quote.Same_as_Billing__c = request.sameAsBilling;
        
        quote.SBQQ__ShippingName__c = request.shipToContact;
        quote.Ship_to_Organization__c = request.shipToOrganization;
        quote.SBQQ__ShippingStreet__c = request.shipToStreet;
        quote.Ship_To_Street_2__c = request.shipToStreet2;
        quote.SBQQ__ShippingCity__c = request.shipToCity;
        quote.SBQQ__ShippingState__c = request.shipToState; 
        quote.Ship_To_State_ISO_Code__c = request.shipToStateISO;
        quote.SBQQ__ShippingPostalCode__c = request.shipToPostalCode;
        quote.SBQQ__ShippingCountry__c = request.shipToCountry;
        quote.Business_Partner_Shipping_Number__c=request.shippingBPNumber ;
        quote.Customer_Ship_Address_ID__c=request.shippingAddressID ;
        quote.Entry_Point__c = request.entryPoint;
        quote.Preview_URL__c = request.previewUrl;
        quote.Reason_for_Discreationary_Waiver__c=request.reasonForDiscreantionaryWaiver;
        quote.Discreationary_Waiver_Flag__c =request.discreationaryWaiverStatus;
        
        if(request.isArticleAccepted == true) {
            quote.Article_Acceptance_Status__c = 'Accepted';
        }
        
        if(request.needsManualApproval != null && request.needsManualApproval == true){ 
            quote.Manual_Check__c = true; 
        }else{
            quote.Manual_Check__c = false;
        }
        
        update quote;
        
        List<SBQQ__QuoteLine__c> quoteLineitemList = [
            SELECT SBQQ__ProductName__c, Product_Article_Type__c,SBQQ__ListPrice__c ,Final_Net_Amount__c ,Discount_Rules_Applied__c, Best_Discount_Rule__c, Discount_Display_Name__c, SBQQ__ProductCode__c, Product_Open_Access_Category__c, Author_Facing_Article_Type__c
            FROM SBQQ__QuoteLine__c 
            WHERE SBQQ__Quote__c = :quote.Id 
        ]; 
        List<String> productString = new List<String>(productIds);
        for(Integer i = 0; i < quoteLineItemList.size(); i++){
            quoteLineitemList[i].SBQQ__Product__c = productString[i];
            quoteLineitemList[i].Author_Facing_Article_Type__c = request.authorFacingArticleType;
            Quote.Trigger_recalculation__c = TF_SBQQ_Quote_PopulateGUID.getRandomString(5);
            quoteLineitemList[i].SBQQ__ListPrice__c = null;
        }
        update quoteLineitemList; 
     
    }
    
    global static String isCountryDiscountAvailable(String jsonStr) {
        isCountryDiscountAvailableRequest request = (isCountryDiscountAvailableRequest)JSON.deserialize(jsonStr, isCountryDiscountAvailableRequest.class);
        isCountryDiscountAvaialbeResponse response = new isCountryDiscountAvaialbeResponse();
        if(request.country != NULL && request.productCode != NULL && String.isNotBlank(request.country) && String.isNotBlank(request.productCode)){
            try{
                response.isCountryDiscountAvailable = false;                
                Country__c selectedCountry = [SELECT Name,Applicable_List__c,EIFL__c,EIFL_Type__c FROM Country__c WHERE Name = :request.country LIMIT 1];
                List<CPQ_Discount_Configuration__c> cpqDiscounts = new List<CPQ_Discount_Configuration__c>();
                if(selectedCountry.EIFL__c != false || (String.isNotBlank(selectedCountry.Applicable_List__c) && selectedCountry.Applicable_List__c != null)) {
                    response.success = true;                    
                    response.isEIFL = selectedCountry.EIFL__c ;
                    response.countryApplicableBand = selectedCountry.Applicable_List__c;
                    response.country = selectedCountry.Name;                                                
                    response.productCode = request.productCode;
                    response.isCountryDiscountAvailable = isDiscountConfiguredInCPQDiscountConfiguration(selectedCountry.EIFL__c, selectedCountry.Applicable_List__c, request.productCode);                                       
                    List<Decimal> discountList = new List<Decimal>();
                    String recordType = 'T&F - Country Waiver';
                    String Query = 'Select Product_Code__c,Discount_Value_Percentage__c From CPQ_Discount_Configuration__c ';                   
                    
                    if(selectedCountry.EIFL__c == true && (selectedCountry.Applicable_List__c =='' || selectedCountry.Applicable_List__c == null)){
                        Query+='WHERE (EIFL__c = '+selectedCountry.EIFL__c+' AND  EIFL_Type__c  = \''+selectedCountry.EIFL_Type__c+'\') AND Product_Code__c = \''+request.productCode+'\' AND RecordType_Name__c = \''+recordType+'\' ORDER BY Discount_Value_Percentage__c DESC LIMIT 1';                      
                    } else if(selectedCountry.EIFL__c == true && (selectedCountry.Applicable_List__c !='' && selectedCountry.Applicable_List__c != null)){                        
                        Query+='WHERE ((EIFL__c = '+selectedCountry.EIFL__c+' AND EIFL_Type__c  = \''+selectedCountry.EIFL_Type__c+'\') OR Country_Applicable_List__c  = \''+selectedCountry.Applicable_List__c+'\') AND Product_Code__c = \''+request.productCode+'\' AND RecordType_Name__c = \''+recordType+'\' ORDER BY Discount_Value_Percentage__c DESC LIMIT 1';
                    } else if(selectedCountry.EIFL__c == false && (selectedCountry.Applicable_List__c !='' && selectedCountry.Applicable_List__c != null)){
                        Query+='WHERE EIFL__c = '+selectedCountry.EIFL__c+' AND EIFL_Type__c  = '+selectedCountry.EIFL_Type__c+' AND Country_Applicable_List__c = \''+selectedCountry.Applicable_List__c+'\' AND Product_Code__c = \''+request.productCode+'\' AND RecordType_Name__c = \''+recordType+'\' ORDER BY Discount_Value_Percentage__c DESC LIMIT 1';
                    }
                    
                    CPQ_Discount_Configuration__c cpqDiscountItem = Database.query(Query);
                    response.discountPercentage = cpqDiscountItem.Discount_Value_Percentage__c;
                }else{
                    response.success = false;
                    response.isEIFL = selectedCountry.EIFL__c ;
                    response.countryApplicableBand = selectedCountry.Applicable_List__c;
                    response.country = selectedCountry.Name;                                                
                    response.productCode = request.productCode;
                    response.setError('Discount Not Available.');                    
                }
            }catch(Exception e){
                response.setError(e.getMessage());
            }
        }else{
            response.setError('Invalid country name or product code.');
        }
        return JSON.serialize(response);
    }
    
    global static Boolean isDiscountConfiguredInCPQDiscountConfiguration(Boolean isEIFL, String countryApplicableList, String productCode) {
        List<CPQ_Discount_Configuration__c> discounts = new List<CPQ_Discount_Configuration__c>();
        if(isEIFL) {
            discounts = [SELECT Name FROM CPQ_Discount_Configuration__c WHERE  EIFL__c = true AND Product_Code__c = :productCode];
            if (discounts.size() > 0) {
                return true;
            } 
        }
        
        if(countryApplicableList != '' && countryApplicableList != null) {
            discounts = [SELECT Name FROM CPQ_Discount_Configuration__c WHERE  Country_Applicable_List__c = :countryApplicableList AND Product_Code__c = :productCode];
            if (discounts.size() > 0) {
                return true;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }    
    
    global static String authorAcceptsQuote(String jsonStr) {
        QuoteRequest request = (QuoteRequest)JSON.deserialize(jsonStr, QuoteRequest.class);
        QuoteDetailResponse response = changeQuoteStatus(request, 'Accepted');
        
        return JSON.serialize(response);
    }
    
    global static String authorRejectsQuote(String jsonStr) {
        QuoteRequest request = (QuoteRequest)JSON.deserialize(jsonStr, QuoteRequest.class);
        QuoteDetailResponse response = changeQuoteStatus(request, 'Rejected');
        
        return JSON.serialize(response);
    }
    
  
    /**
	* This method is used to send a list price for given product code and article type
	*/
    global static String getListPrice(String jsonStr) {
        ListPriceResponse response = new ListPriceResponse();
        ListPriceRequest request = (ListPriceRequest)JSON.deserialize(jsonStr, ListPriceRequest.class);
        
        List<PriceBookEntry> pricebookentryList = new List<PriceBookEntry>();
        String preferedCurrency = getPreferredCurrency(request.countryCode);
        String priceBookID = getPriceBookID();
        try {
            pricebookentryList = [
                SELECT
                Id,
                Name,
                ProductCode,
                Article_Type__c,
                Open_Access_Category__c,
                APC_Price_Category__c,
           
                (select id,Product2Id,
                 CurrencyIsoCode,
                 product2.APC_Price_Category__c,
                 
                 UnitPrice
                 from
                 PricebookEntries
                 where
                 CurrencyIsoCode = :preferedCurrency AND
                 Pricebook2Id = :priceBookID AND
                 IsActive =true)
                FROM Product2
                where ProductCode = :request.productCode AND
                Article_Type__c = :request.articleType and
                //APC_Price_Category__c = :request.APCPriceCategory and
                IsActive = true AND
                Family = :productFamily limit 1].PricebookEntries;
            
            if(!pricebookentryList.isEmpty()) {
                response.success = true;
                response.currencyIsoCode = pricebookentryList[0].CurrencyIsoCode;
                response.value = pricebookentryList[0].UnitPrice;
                response.productOpenAccessCategory = getProductCategory(pricebookentryList[0].Product2Id);
                response.APCPriceCategory = pricebookentryList[0].product2.APC_Price_Category__c;
            } else {
                setInvalidRequest();
                response.setError('There is no product matching for given Journal and Article Type');
            }
        } catch (Exception ex) {
            setInvalidRequest();
            response.setError('There is no product matching for given Journal and Article Type');
        }
        return JSON.serialize(response);
    }
   
    @TestVisible
    private static void setInvalidRequest() {
        RestResponse res = RestContext.response;
        res.statusCode = 400;
    }
    
    
    private static QuoteDetailResponse changeQuoteStatus(QuoteRequest request, String status) {
        QuoteDetailResponse response = new QuoteDetailResponse();
        
        SBQQ__Quote__c quote = [select Id, Author_Status__c,CSD_Approval_Status__c from SBQQ__Quote__c where randomstring__c = :request.quoteUniqueId limit 1];
        if (quote != null) {
            quote.Author_Status__c = status;
           // quote.CSD_Approval_Status__c  = status;
            system.debug('CSD status%%%%%%'+quote.CSD_Approval_Status__c);
            update quote;
            response = getQuote(quote.id);
            
        } else {
            response.setError('No such quote exists');
        }
        return response;
    }

    
    private static String getPreferredCurrency(String CountryCode) {
        String preferedCurrency = 'USD';
        List<Country__c> countryList = [SELECT Preferred_currency__c FROM Country__c WHERE Country_2__c = :CountryCode];
        if(!countryList.isEmpty())  {
            preferedCurrency =  countryList[0].Preferred_currency__c;
        }
        return preferedCurrency;
    }
    
    
    private static String getPriceBookID() {
        Pricebook2 priceBook =  [select id from Pricebook2 where Name = :cpqPriceBookName AND IsActive =true];
        return priceBook.Id;
        
    }
    
    private static String getProductCategory(Id productId){
        if(String.isNotBlank(productId)){
            List<Product2> productLst = new List<Product2>();
            productLst = [Select Open_Access_Category__c,APC_Price_Category__c from Product2 where Id =: productId];            
            if(productLst.size() > 0){
                Product2 productObj = productLst[0];
                return productObj.Open_Access_Category__c; 
            }else{
                return null;
            }                        
        }else{
            return null; 
        }
    }
      
    private static void enrichRequest(GenerateQuoteRequest request) {
        List<Account> leadAuthorAccount = null;
        List<Account> accountListResult = null;
        
        String leadAuthorOrganizationID = null;
        String payerOrganizationID = null;
        
        Boolean isCorrectLeadAuthorOrganizationID = true;
        Boolean isCorrectPayerOrganizationID = true;
        
        /*
        * Salesforce to check if it didn't find Organisation Id then check with Ring gold Id, 
        * if Salesforce couldn't find either by Organisation id and Ring gold id then create Quote without any organisation details (without Organisation Id) 
        */
        
        //check leadAuthorOrganizationID 
        if(String.isNotBlank(request.leadAuthorOrganizationID)) {
            accountListResult = [SELECT Id FROM Account WHERE Id = :request.leadAuthorOrganizationID limit 1];
            if (accountListResult.size() > 0) {
                leadAuthorOrganizationID = accountListResult[0].Id;
            }else{                
                isCorrectLeadAuthorOrganizationID = false;
            }                 
        }else{
            isCorrectLeadAuthorOrganizationID = false;
        }
        
        //if leadAuthorOrganizationID is not correct then check leadAuthorOrganizationRingoldID
        if(isCorrectLeadAuthorOrganizationID == false && (request.leadAuthorOrganizationRingoldID != null && String.isNotBlank(request.leadAuthorOrganizationRingoldID))) {
            leadAuthorAccount = [SELECT Id FROM Account WHERE Ringgold_Account_ID__c = :request.leadAuthorOrganizationRingoldID limit 1];
            if (leadAuthorAccount.size() > 0) {
                leadAuthorOrganizationID = leadAuthorAccount[0].Id;
            }                
        }        
        
        //check payerOrganizationID
        if(String.isNotBlank(request.payerOrganizationID)) {
            accountListResult = [SELECT Id FROM Account WHERE Id = :request.payerOrganizationID limit 1];
            if (accountListResult.size() > 0) {
                payerOrganizationID = accountListResult[0].Id;
            }else{                
                isCorrectPayerOrganizationID = false;
            }                 
        }else{
            isCorrectPayerOrganizationID = false;
        }
        
        //check if payerOrganizationID is not correct then check payerOrganizationRingoldID
        if(isCorrectPayerOrganizationID ==false && (request.payerOrganizationRingoldID != null && String.isNotBlank(request.payerOrganizationRingoldID))) {
            if(request.payerOrganizationRingoldID == request.leadAuthorOrganizationRingoldID) {
                leadAuthorAccount = [SELECT Id FROM Account WHERE Ringgold_Account_ID__c = :request.leadAuthorOrganizationRingoldID limit 1];
                if(leadAuthorAccount.size() > 0) {
                    payerOrganizationID = leadAuthorAccount[0].Id;
                }
            } else {
                List<Account> payerAccount = [SELECT Id FROM Account WHERE Ringgold_Account_ID__c = :request.payerOrganizationRingoldID limit 1];
                if(payerAccount.size() > 0) {
                    payerOrganizationID = payerAccount[0].Id; 
                }                   
            }
        }
        
        request.leadAuthorOrganizationID = leadAuthorOrganizationID;
        request.payerOrganizationID = payerOrganizationID;
    }       
    
    
    class QuoteNotFoundException extends Exception {}
    class TooManyProductsException extends Exception {}
    class NoProductsException extends Exception {}
}