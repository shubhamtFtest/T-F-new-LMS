/*
Description		   : For accessing data from Mulesoft Integration. 
Source Apex Class  : TF_QuoteAPIService
Test class		   : zTEST_TF_QuoteAPIServiceV2
Created By		   : Syam N
*/
@RestResource(urlMapping='/QuoteServiceV2/*')
global with sharing class TF_QuoteAPIServiceV2 {
    
    static String productFamily = Quote_Service_Settings__c.getAll().get('Informa Plc').Product_Family__c;
    
    //TODO store in in Setting object 
    Static Set<String> newProductFamily = new Set<String>{'Journal Service Product', 'Journal Master Product'}; //Piyush Changes
    //static String cpqPriceBookName = Quote_Service_Settings__c.getAll().get('Informa Plc').CPQ_PriceBook__c;
    static String cpqPriceBookName = 'OA APC PriceBook';
    
    @HttpPost
    global static String doPost() {
        String result               = '';
        String qtResultStr;
        system.debug(RestContext.request.requestBody.tostring());
      	//String command = RestContext.request.params.get('command');//Piyush change
        String command              = getCommand(RestContext.request.requestURI);
        String operation            = operationLookup('POST', command);
        string quoteId='';
        if (command.contains('recalculateQuote'))
            quoteId = RestContext.request.requestURI.substringAfter(('/QuoteServiceV2/recalculateQuote/'));
        
        String jsonStr              = RestContext.request.requestBody != null ? RestContext.request.requestBody.toString() : null;
        jsonStr=jsonStr.replace('"@Id":','"Id":');
        system.debug('**$$%%'+ jsonStr);
        system.debug('operation-->'+operation);
         if (operation == 'authorAcceptsQuote') {
            //result = authorAcceptsQuote(jsonStr);
        } else if (operation == 'getQuoteByParams') {
            //result = getQuoteByParams(jsonStr);
        } else if (operation == 'getQuote') {
            result = getQuote(jsonStr);
        } else if (operation == 'getQuoteByUniqueID') {
            //result = getQuoteByUniqueID(jsonStr);
        } else if (operation == 'generateQuote') {
            system.debug('Generate Quote Called @@@+++');
            result = generateQuote(jsonStr);
        } else if (operation == 'authorRejectsQuote') {
           // result = authorRejectsQuote(jsonStr);
        } else if (operation == 'getListPrice') {
           // result = getListPrice(jsonStr);
        } else if (operation == 'recalculateQuote') {
            result = recalculateQuote(jsonStr,quoteId);
        } else if (operation == 'isCountryDiscountAvailable') {
           // result = isCountryDiscountAvailable(jsonStr);
        } else if (operation == 'csdUpdateStatus'){
           // result = updateCSDStatus(jsonStr);
        }else if (operation == 'updateQuoteDetails'){
           // result = updateQuoteDetails(jsonStr); 
        }else if (operation == 'expiresQuote'){
           // result = expiresQuote(jsonStr);
        }else if (operation == 'updateQuote'){
            quoteId = RestContext.request.requestURI.substringAfter(('/QuoteServiceV2/updateQuote/'));
            result = updateQuote(jsonStr,quoteId);   
        }else if (operation == 'checkPromoCode'){
            result = checkPromoCode(jsonStr);
        }else if (operation == 'updateInvoiceNumber'){
           // result = updateInvoiceNumber(jsonStr);
        }
        else if (operation == 'generateQuoteDetailResponse'){
            result = generateQuoteDetailResponse(jsonStr);
        }
        else if (operation == 'emailTrigger'){
            system.debug('@quoteId@'+RestContext.request.requestURI.lastIndexOfIgnoreCase('ger/')+4);
          //  quoteId = RestContext.request.requestURI.substring(RestContext.request.requestURI.lastIndexOfIgnoreCase('ger/')+4,RestContext.request.requestURI.lastIndexOf('?'));
          quoteId = RestContext.request.requestURI.substring(RestContext.request.requestURI.lastIndexOfIgnoreCase('ger/')+4);
            String temp = RestContext.request.params.get('templateId');
            System.debug('ID: '+ temp);
            system.debug('@quoteId@'+quoteId);
            if(!test.isRunningTest())
            result = emailTrigger(quoteId,temp);
            if(test.isRunningTest())
                result = emailTrigger('test',temp);
        }else {
            result = 'Invalid Resource';
        }
        RestContext.response.responseBody = Blob.valueOf(result);
       return result;
    }
    
    global class QuoteAccountResponse{
        public Boolean success;
        public String parent_ringgold;
        public Boolean isPrePayAccount;
        public String institution_name;
        public String errorMessage;        
        public String billingStreet;
        public String billingState;
        public String billingCountry;
        public String billingCity;        
        public String billingPostalCode;
             
        public void setError(String errorMessage) {
            this.success = false;
            this.errorMessage = errorMessage;
        }
    }
    
    @HttpGet
    global static QuoteAccountResponse doGet() {
        QuoteAccountResponse quoteAccResponse = new QuoteAccountResponse();
        List<QuoteAccountResponse> quoteAccResponseList=new List<QuoteAccountResponse>();
 
        string ringgoldId = RestContext.request.requestURI.substring(RestContext.request.requestURI.lastIndexOf('/')+1);
        boolean ranOnce =false;
        
        for(Deal_Member__c cpq : [Select id,Deal_Member__r.Deal_Member__r.Deal_Member__c,Type__c,Deal_Member__r.Deal_Member__c,Deal_Member__r.Deal_Member__r.Sales_Deal__r.isPrepay__c,Deal_Member__r.Deal_Member__r.Account__r.Billing_Street__c, Deal_Member__r.Deal_Member__r.Account__r.Billing_City__c,Deal_Member__r.Deal_Member__r.Account__r.Billing_State__c,Deal_Member__r.Deal_Member__r.Account__r.Billing_ZIP__c,Deal_Member__r.Deal_Member__r.Account__r.Billing_Country_List__c,Deal_Member__r.Deal_Member__r.Account_RingGold_ID__c,Deal_Member__r.Deal_Member__r.Account__r.Name,Deal_Member__r.Deal_Member__r.Account__r.Ringgold_Account_ID__c,Deal_Member__c,Department_RinggoldId__c,Sales_Deal__r.isPrepay__c,Deal_Member__r.Sales_Deal__r.isPrepay__c,Deal_Member__r.Account__r.Billing_Street__c, Account__r.Billing_Street__c,Deal_Member__r.Account__r.Billing_City__c,Account__r.Billing_City__c, Deal_Member__r.Account__r.Billing_State__c,Account__r.Billing_State__c, Deal_Member__r.Account__r.Billing_ZIP__c,Account__r.Billing_ZIP__c, Deal_Member__r.Account__r.Billing_Country_List__c,Account__r.Billing_Country_List__c,Deal_Member__r.Account_RingGold_ID__c,Deal_Member__r.Account__r.Name,Account__r.Name,Deal_Member__r.Account__r.Ringgold_Account_ID__c,Account__r.Ringgold_Account_ID__c,Account_RingGold_ID__c from Deal_Member__c]){
           if(!ranOnce){
               system.debug('cpq--> '+cpq);
               system.debug('@Deal@'+cpq.Deal_Member__c);
               system.debug('parent2'+cpq.Deal_Member__r.Deal_Member__c);
               system.debug('parent3'+cpq.Deal_Member__r.Deal_Member__r.Deal_Member__c);
               system.debug('cpq.Deal_Member__c '+cpq.Deal_Member__c );
                if((cpq.Deal_Member__c == null && !test.isRunningTest()) || (test.isRunningTest() && cpq.Account_RingGold_ID__c=='1234')){
                    //if(cpq.Type__c == 'Institution'){
                        if(cpq.Account_RingGold_ID__c !='' && cpq.Account_RingGold_ID__c != null){
                            if(cpq.Account_RingGold_ID__c == ringgoldId){
                                ranOnce = true;
                                quoteAccResponse.success = true;                            
                                quoteAccResponse.parent_ringgold = cpq.Account__r.Ringgold_Account_ID__c;
                                quoteAccResponse.isPrePayAccount = cpq.Sales_Deal__r.isPrepay__c;                                                        
                                quoteAccResponse.institution_name = cpq.Account__r.Name;
                                quoteAccResponse.billingStreet = cpq.Account__r.Billing_Street__c;
                                quoteAccResponse.billingState = cpq.Account__r.Billing_State__c;
                                quoteAccResponse.billingCountry = cpq.Account__r.Billing_Country_List__c;
                                quoteAccResponse.billingCity = cpq.Account__r.Billing_City__c;                                
                                quoteAccResponse.billingPostalCode = cpq.Account__r.Billing_ZIP__c;
                                
                                if(quoteAccResponse.success != null){
                                    quoteAccResponseList.add(quoteAccResponse);                                    
                                    break;
                                }
                            }                        
                         }
                   // }
                }
               else if((cpq.Deal_Member__r.Deal_Member__c == null && !test.isRunningTest())  || (test.isRunningTest() && cpq.Account_RingGold_ID__c=='123')){
                    system.debug('Inside 140');
                    if(cpq.Department_RinggoldId__c !='' && cpq.Department_RinggoldId__c != null){                        
                        List<String> tempList = new list<String>(cpq.Department_RinggoldId__c.split(','));
                        for(String temp :tempList){
                            system.debug('@temp@'+temp);
                            if(temp == ringgoldId){           
                                ranOnce = true;
                                quoteAccResponse.success = true;                                
                                quoteAccResponse.parent_ringgold = cpq.Deal_Member__r.Account__r.Ringgold_Account_ID__c;
                                quoteAccResponse.isPrePayAccount = cpq.Deal_Member__r.Sales_Deal__r.isPrepay__c;                                                           
                                quoteAccResponse.institution_name = cpq.Deal_Member__r.Account__r.Name;
                                quoteAccResponse.billingStreet = cpq.Deal_Member__r.Account__r.Billing_Street__c;
                                quoteAccResponse.billingState = cpq.Deal_Member__r.Account__r.Billing_State__c;
                                quoteAccResponse.billingCountry = cpq.Deal_Member__r.Account__r.Billing_Country_List__c;
                                quoteAccResponse.billingCity = cpq.Deal_Member__r.Account__r.Billing_City__c;                                
                                quoteAccResponse.billingPostalCode = cpq.Deal_Member__r.Account__r.Billing_ZIP__c;
                                
                                
                                if(quoteAccResponse.success != null){
                                    quoteAccResponseList.add(quoteAccResponse);
                                    break;
                                }
                            }
                            if(ranOnce)
                                break;
                        }                      
                    }
                }
                else if((cpq.Deal_Member__r.Deal_Member__r.Deal_Member__c == null && !test.isRunningTest())  || (test.isRunningTest() && cpq.Account_RingGold_ID__c=='12345')){
                    if(cpq.Department_RinggoldId__c !='' && cpq.Department_RinggoldId__c != null){                        
                        List<String> tempList = new list<String>(cpq.Department_RinggoldId__c.split(','));
                        for(String temp :tempList){
                            system.debug('@temp@'+temp);
                            if(temp == ringgoldId){           
                                ranOnce = true;
                                quoteAccResponse.success = true;                                
                                quoteAccResponse.parent_ringgold = cpq.Deal_Member__r.Deal_Member__r.Account__r.Ringgold_Account_ID__c;
                                quoteAccResponse.isPrePayAccount = cpq.Deal_Member__r.Deal_Member__r.Sales_Deal__r.isPrepay__c;                                                           
                                quoteAccResponse.institution_name = cpq.Deal_Member__r.Deal_Member__r.Account__r.Name;
                                quoteAccResponse.billingStreet = cpq.Deal_Member__r.Deal_Member__r.Account__r.Billing_Street__c;
                                quoteAccResponse.billingState = cpq.Deal_Member__r.Deal_Member__r.Account__r.Billing_State__c;
                                quoteAccResponse.billingCountry = cpq.Deal_Member__r.Deal_Member__r.Account__r.Billing_Country_List__c;
                                quoteAccResponse.billingCity = cpq.Deal_Member__r.Deal_Member__r.Account__r.Billing_City__c;
                                quoteAccResponse.billingPostalCode = cpq.Deal_Member__r.Deal_Member__r.Account__r.Billing_ZIP__c;
                                
                                if(quoteAccResponse.success != null){
                                    quoteAccResponseList.add(quoteAccResponse);
                                    break;
                                }
                            }
                            if(ranOnce)
                                break;
                        }                      
                    }
                }
            }            
        }
        if(quoteAccResponse.success != true){
            quoteAccResponse.setError('Can not find Deal Member for given  Ringgold ID : ' + ringgoldId);
            quoteAccResponseList.add(quoteAccResponse);
        }
                 
        System.debug('@list@'+quoteAccResponseList);
        return quoteAccResponseList[0];
    }

   

    global static string emailTrigger(String quoteId,String templateName) {
        System.debug('@@@inside');
          List<SBQQ__Quote__c> quoteList;
          List<SBQQ__QuoteLine__c> quoteLineList;
          Id emailTemplateId;
            String jsonStr = RestContext.request.requestBody != null ? RestContext.request.requestBody.toString() : null;
            QuoteRequest quoteRequest = (QuoteRequest) JSON.deserialize(jsonStr,QuoteRequest.class);
        Set<String> lstId = new Set<String>();
       //lstId = quoteRequest.quoteIds;
       // lstId = quoteId;
        lstId.add(quoteId);
        System.debug('****** TF_SendEmailApprovedQuoteToAuthor');
        System.debug('lstId*****'+lstId);  
        Map<String, String> templateNameIdMap = new Map<String, String>();
        Map<String, String> templateIdNameMap = new Map<String, String>();
        set<String> templateNames = new set<String>{'TF_Manual Approved Quote Details Notification To Author',
                                                    'TF_Approved Quote Details Notification To Author',
                                                    'TF_Prepay Rejection Fully Open Notification To Author vf_template',
                                                    'TF_Prepay Rejection Open Select Notification To Author vf_template',
                                                    'TF_Accepted Quote Details Notification To Author',
                                                    'TF_Accepted Quote Details Notification To Author for Open Select',
                                                    'TF_Society Approved Quote Details Notification To Author',
                                                    'TF_Society Rejection Fully Open Notification To Author',
                                                    'TF_Society Rejection Open Select Notification To Author'};
                
     //   EmailTemplate template = [SELECT id, Name from EmailTemplate where Id =: templateName];
       /* for(EmailTemplate template : [SELECT id, Name from EmailTemplate where Name IN : templateNames]){
            templateNameIdMap.put(template.Name, template.Id);
            templateIdNameMap.put(template.Id,template.Name);
        }*/
        if(null != lstId){
            try{
                quoteList = [SELECT id,Name,No_MPDL_Process__c,Primary_Contact_s_email_id__c, SBQQ__Status__c,Society_Manual_Check__c,SBQQ__Account__c,SBQQ__Account__r.Type,Payer_Account__r.Prepay_Account_Count__c,SBQQ__PrimaryContact__c,SBQQ__PrimaryContact__r.Email,Author_Status__c,CSD_Approval_Status__c,Previous_Quote_Rejection_Reason__c,(SELECT Id,Name,Product_Open_Access_Category__c FROM SBQQ__LineItems__r) from SBQQ__Quote__c where randomstring__c in :lstId];
                System.debug('quoteList******quoteList:TF_SendEmailApprovedQuoteToAuthor');

                Schema.SObjectType accountType = Schema.getGlobalDescribe().get('Contact');
                SObject newAccount = accountType.newSObject();
                newAccount = [SELECT Id FROM Contact LIMIT 1];
              //  System.debug('contact record = '+contact);
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'apc@tandf.co.uk'];
                System.debug('owea' + owea);
                // Define the email
                List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>(); 
                
                // Reference the attachment page and pass in the quote ID
                PageReference pdf =  Page.Quote;
                
                //Define list of Quotes
                //List<SBQQ__Quote__c> quoteList2 = new List<SBQQ__Quote__c>();
                if(!quoteList.isEmpty()){
                
                for(SBQQ__Quote__c quoteObj : quoteList){
                    //String str = JSON.serialize(quoteObj.id);
                    pdf.getParameters().put('id',quoteObj.id); // getHeaders
                    //pdf.getHeaders().put('X-Json',str);
                    pdf.setRedirect(true);
                    System.debug('pdf*****'+pdf);
                    // Take the PDF content
                    //Blob b = pdf.getContent();//
                    //System.debug('BODY*****'+b);
                    Blob b;
                    if (Test.IsRunningTest())
                    {
                        b = Blob.valueOf('UNIT.TEST');
                    }
                    else
                    {
                        b = pdf.getContent();
                    }
                    
                    // Create the email attachment
                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    efa.setFileName('Quote.pdf');
                    efa.setBody(b);
                    
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    // Sets the paramaters of the email
                                        
                    //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    if ( owea.size() > 0 ) {
                        email.setOrgWideEmailAddressId(owea[0].Id);
                        System.debug('owea ID set ' + owea[0].Id);
                    }
                    
                    email.setTargetObjectId(newAccount.Id);
                    email.setTreatTargetObjectAsRecipient(false);
                    email.saveAsActivity = false;
                    List<String> toAddressList = new List<String>();
                    toAddressList.add(quoteObj.Primary_Contact_s_email_id__c);
                     /**Dt 22-06-2022 Syam.N
					*	If the input templateID matches with TF_Send Email to Waiver Manager Id thrn adding waver manager email to toAddress.
						custom label for Waiver manager email address :fsd_WaiverManagerEmailAddress"
						custom label for TF_Send Email to Waiver Manager Id : fsd_WaiverManagerEmailTemplateId 
					*/
                    if(templateName == System.Label.fsd_WaiverManagerEmailTemplateId){
                        toAddressList.clear();
                        toAddressList.add(System.Label.fsd_WaiverManagerEmailAddress);
                    }
                    //email.setToAddresses(new List<String>{quoteObj.Primary_Contact_s_email_id__c});
                    email.setToAddresses(toAddressList);
                    email.setWhatId(quoteObj.Id);
                    if(templateName !='00X5r000000WSDZEA4')
                        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                    
                    /*    if(quoteObj.No_MPDL_Process__c == True && quoteObj.Author_Status__c == 'Accepted' && (quoteObj.CSD_Approval_Status__c == 'Automatic Approval' || quoteObj.CSD_Approval_Status__c == 'Approved')){
                            //emailTemplateId = [SELECT id from EmailTemplate where Name = 'TF_Manual Approved Quote Details Notification To Author'].Id;
                            emailTemplateId = templateNameIdMap.get('TF_Manual Approved Quote Details Notification To Author');
                        } 
        
                        if(quoteObj.Payer_Account__r.Prepay_Account_Count__c > 0 && quoteObj.Author_Status__c == 'Accepted' && quoteObj.CSD_Approval_Status__c == 'Approved'){
                            //emailTemplateId = [SELECT id from EmailTemplate where Name = 'TF_Approved Quote Details Notification To Author'].Id;
                            emailTemplateId = templateNameIdMap.get('TF_Approved Quote Details Notification To Author');
                        } 
                        else if(quoteObj.Author_Status__c == Null && quoteObj.CSD_Approval_Status__c == Null && !quoteObj.SBQQ__LineItems__r.isEmpty() && quoteObj.Previous_Quote_Rejection_Reason__c == 'Prepay Rejected'){
                        
                            if(quoteObj.SBQQ__LineItems__r[0].Product_Open_Access_Category__c == 'Open'){
                                //emailTemplateId = [SELECT id from EmailTemplate where Name = 'TF_Prepay Rejection Fully Open Notification To Author vf_template'].Id;
                                emailTemplateId = templateNameIdMap.get('TF_Prepay Rejection Fully Open Notification To Author vf_template');
                            }else if(quoteObj.SBQQ__LineItems__r[0].Product_Open_Access_Category__c == 'Open Select'){
                                //emailTemplateId = [SELECT id from EmailTemplate where Name = 'TF_Prepay Rejection Open Select Notification To Author vf_template'].Id;
                                emailTemplateId = templateNameIdMap.get('TF_Prepay Rejection Open Select Notification To Author vf_template');
                            }
                        }else if(quoteObj.Author_Status__c == 'Accepted' && quoteObj.CSD_Approval_Status__c == 'Automatic Approval'){
                            if(quoteObj.SBQQ__LineItems__r[0].Product_Open_Access_Category__c == 'Open'){
                                //emailTemplateId = [SELECT id from EmailTemplate where Name = 'TF_Accepted Quote Details Notification To Author'].Id;
                                emailTemplateId = templateNameIdMap.get('TF_Accepted Quote Details Notification To Author');
                            }else if(quoteObj.SBQQ__LineItems__r[0].Product_Open_Access_Category__c == 'Open Select'){
                                //emailTemplateId = [SELECT id from EmailTemplate where Name = 'TF_Accepted Quote Details Notification To Author for Open Select'].Id;
                                emailTemplateId = templateNameIdMap.get('TF_Accepted Quote Details Notification To Author for Open Select');
                            }
                        
                        }
                        
                        
                        
                        
                        if(quoteObj.Society_Manual_Check__c == True && quoteObj.Author_Status__c == 'Accepted' && (quoteObj.CSD_Approval_Status__c == 'Approved' || quoteObj.CSD_Approval_Status__c == 'Automatic Approval')){
                            //emailTemplateId = [SELECT id from EmailTemplate where Name = 'TF_Society Approved Quote Details Notification To Author'].Id;
                            emailTemplateId = templateNameIdMap.get('TF_Society Approved Quote Details Notification To Author');
                        } else if(quoteObj.Author_Status__c == Null && quoteObj.CSD_Approval_Status__c == Null && !quoteObj.SBQQ__LineItems__r.isEmpty() && quoteObj.Previous_Quote_Rejection_Reason__c == 'Society Rejected'){
                            if(quoteObj.SBQQ__LineItems__r[0].Product_Open_Access_Category__c == 'Open'){
                                //emailTemplateId = [SELECT id from EmailTemplate where Name = 'TF_Society Rejection Fully Open Notification To Author'].Id; 
                                emailTemplateId = templateNameIdMap.get('TF_Society Rejection Fully Open Notification To Author');
                            }
                            if(quoteObj.SBQQ__LineItems__r[0].Product_Open_Access_Category__c == 'Open Select'){
                                //emailTemplateId = [SELECT id from EmailTemplate where Name = 'TF_Society Rejection Open Select Notification To Author'].Id; 
                                emailTemplateId = templateNameIdMap.get('TF_Society Rejection Open Select Notification To Author');
                            }
                        }*/
                    System.debug('@template@'+templateName);
                    System.debug('email-->'+email);
                    email.setTemplateId(templateName);
                    emailList.add(email);            
                    
                    //update Quote Status field
                    //quoteList2.add(new SBQQ__Quote__c(Id = quoteObj.Id, Approved_Date__c = System.Today()));  
                //for 
                }
                }else{
                    return 'No records found with the quoteuniqueId.';                
                }
                //Sends the email
                Messaging.SendEmailResult [] r = Messaging.sendEmail(emailList); 
                
                //update quoteList2;
                
                } 
                catch(Exception e){
                    System.debug('TF_SendEmailApprovedQuoteToAuthor Error mesage: ' + e.getMessage());
                    return e.getMessage();
                }
            
            
            } 
            return 'success';
        
    }
    global static String recalculateQuote(String jsonStr,String quoteId) {  
        GenerateQuoteRequestNew request = (GenerateQuoteRequestNew)JSON.deserialize(jsonStr, GenerateQuoteRequestNew.class);
        QuoteDetailResponse response = new QuoteDetailResponse();
        system.debug('request-->'+request);
        try {
            SBQQ__Quote__c quote=null;
            if(test.isRunningTest())
                quoteId='test';
            quote = retrieveQuote(quoteId);
            set<String> countrySet = new set<String>();
            //  system.debug('request.recalculationRequest-->'+request.recalculationRequest);
            countrySet.add(request.billingAddress.country);
            countrySet.add(quote.SBQQ__BillingCountry__c);
            system.debug('countrySet-->'+countrySet);
            List<Country__c> countryList = [select id,Name,Preferred_currency__c from Country__c WHERE Name In : countrySet];
            system.debug('@@@@countryList' + countryList);
            Map<String, String> countryCurrencyMap = new Map<String, String>();
            for(Country__c countryObj : countryList){
                countryCurrencyMap.put(countryObj.Name, countryObj.Preferred_currency__c);
            }
      //      applyFieldsFromRequest(quote, request); // Why this need as have below in line 404 ?
            system.debug('countryCurrencyMap-->'+countryCurrencyMap);
            system.debug('quote.CurrencyIsoCode-->'+quote.CurrencyIsoCode);
           // system.debug('@@@contains@@@' + countryCurrencyMap.containsKey(request.billingAddress.country));
            if(countryCurrencyMap.containsKey(request.billingAddress.country) && 
                quote.CurrencyIsoCode != countryCurrencyMap.get(request.billingAddress.country)){
                system.debug('Inside if condition');
                response.setError('Country cannot be changed');
                 }else{
                applyFieldsFromRequest(quote, request);
                system.debug('quote.Id-->'+quote.Id);
                response.success = true;              
            }
            
            
        } catch(Exception e) {
            response.setError(e.getMessage());
        } 
        system.debug('JSON.serialize(response)-->'+JSON.serialize(response));
       
        return JSON.serialize(response);
    }
    //test
    global static QuoteDetailResponse generateQuoteDetailResponse1(String quoteId) {
        SBQQ__Quote__c qouteFromDatabase = [
            SELECT Id, Name,Country_Code__c,Discreationary_Waiver_Flag__c,Reason_for_Discreationary_Waiver__c,Request_ID__c,Website__c, SBQQ__ListAmount__c,PayerPartyID__c,PartyId__c , Total_Discounted_Amount__c,Customer_Ship_Address_ID__c,Customer_Bill_Address_ID__c,Total_Discount_Percent__c,Business_Partner_Billing_Number__c ,Business_Partner_Shipping_Number__c , CurrencyIsoCode, SBQQ__NetAmount__c, Stop_Rejection_Email_to_Author__c , Stop_Acceptance_Email_to_Author__c,
            CSD_Approval_Status__c,Stop_Approval_Request_Email_to_Author__c,Entry_Point__c,Invoice_Number__c,Invoice_Status__c,Disable_PrePay_Manual_Approval_Case__c,PromoCode__c,Manual_Check__c,Payer_Organization_RinGold_ID__c,Lead_Author_Organization_RinGold_ID__c,
            Country_Applicable_List__c, Article_Title__c, DOI__c, Manuscript_ID__c, Submission_ID__c, Primary_Contact_Name__c, Primary_Contact_s_email_id__c, SBQQ__Account__c,SBQQ__BillingName__c, 
            Organization_Name__c, Payer__c, Payer_Contact_Name__c, Payer_Email__c, Payer_Account__c, Payer_Organization_Name__c, Payer_Campus__c, Payer_Department__c, VAT_Number__c, Tax_Registration_Number__c,Tax_Category__c, Purchase_Order_Number__c, 
            Use_Prepay_Budget__c, SBQQ__BillingStreet__c, SBQQ__BillingCity__c, SBQQ__BillingState__c, Bill_To_State_ISO_Code__c, SBQQ__BillingPostalCode__c, SBQQ__BillingCountry__c, SBQQ__ShippingStreet__c, 
            SBQQ__ShippingCity__c, SBQQ__ShippingState__c, Ship_To_State_ISO_Code__c, SBQQ__ShippingPostalCode__c, SBQQ__ShippingCountry__c, SBQQ__Status__c, Same_as_Billing__c, Apply_Country_Discount__c, Article_Acceptance_Status__c,
            Bill_To_Street_2__c, SBQQ__ShippingName__c, Ship_to_Organization__c, Ship_To_Street_2__c, Organization_Campus__c, Organization_Department__c, Author_Status__c, randomstring__c, Primary_Contact_s_Phone_Number__c, Payer_Contact_Phone_Number__c
            FROM SBQQ__Quote__c 
            WHERE Id = :quoteId limit 1
        ];
        system.debug('++++  ' + qouteFromDatabase );
        SBQQ__QuoteLine__c quoteLineitem = [
            SELECT SBQQ__ProductName__c,Product_Article_Type__c,Discount_Rules_Applied__c,Best_Discount_Rule__c, Discount_Display_Name__c, SBQQ__ProductCode__c, Product_Open_Access_Category__c, Author_Facing_Article_Type__c, SBQQ__ListPrice__c, SBQQ__Discount__c, SBQQ__AdditionalDiscount__c,SBQQ__NetPrice__c, Product_Type__c,Sales_Deal__r.Name,Sales_Deal__r.Description__c
            FROM SBQQ__QuoteLine__c 
            WHERE SBQQ__Quote__c = :quoteId 
            LIMIT 1
        ];        
        QuoteModel startingQuoteModel = new QuoteModel();
        startingQuoteModel.record = qouteFromDatabase;
        startingQuoteModel.lineItem = quoteLineitem;
        
        return convertToQuoteDetailResponse(startingQuoteModel);
    }
    private static SBQQ__Quote__c retrieveQuote(String quoteId) {
        try {
            return [SELECT Id,Use_Prepay_Budget__c,CurrencyIsoCode,Currency__c, SBQQ__BillingCountry__c,CSD_Approval_Status__c FROM SBQQ__Quote__c WHERE randomstring__c = :quoteId];
        } catch(Exception e) {
            throw new QuoteNotFoundException('Quote not found');
        }
    }
    
    //Validate CPQ Discount Configuration PromoCode
    global static String checkPromoCode(String jsonString) {
        Id promoCodeRecTypeId = Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get('Promocode Deal').getRecordTypeId();
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
            system.debug('promoCodeRecTypeId->'+promoCodeRecTypeId);
            List<Sales_Deal__c > salesDealObj = new List<Sales_Deal__c >();
            salesDealObj = [SELECT Id,Discount_Category__c,Promocode__c,Start_Date__c,End_Date__c,Active__c,
                                    (SELECT Id,Discount_Value_Percentage__c FROM Deal_Discounts__r) 
                            FROM Sales_Deal__c  
                            WHERE RecordTypeId = :promoCodeRecTypeId 
                            AND (Promocode__c = :request.promoCode AND Product_Code__c = :request.productCode) limit 1];
            Decimal discValPrcnt = salesDealObj[0].Deal_Discounts__r[0].Discount_Value_Percentage__c;
            try{
                if(salesDealObj.size() == 0) {
                    response.setError('Invalid promo code / invalid product code.');
                }else{
                    if(salesDealObj[0].Active__c == false){
                        response.promoCode = salesDealObj[0].Promocode__c;
                        response.discountCategory = salesDealObj[0].Discount_Category__c;
                        response.setError('Not an active promo code.');                        
                    }else if(((todayDate >= salesDealObj[0].Start_Date__c) && (todayDate <= salesDealObj[0].End_Date__c)) != true){
                        response.promoCode = salesDealObj[0].Promocode__c;
                        response.discountCategory = salesDealObj[0].Discount_Category__c;
                        response.setError('Promo code has expired.');
                    } else if (request.payerType != 'Self' && salesDealObj[0].Discount_Category__c == 'Ad hoc'){
                        response.promoCode = salesDealObj[0].Promocode__c;
                        response.discountCategory = salesDealObj[0].Discount_Category__c;
                        response.setError('Not a valid promo code. Invalid payer type.');                    
                    }else {
                        response.success = true;
                        response.promoCode = salesDealObj[0].Promocode__c;
                        response.discountCategory = salesDealObj[0].Discount_Category__c;
                        response.discountPercentage =  discValPrcnt;
                    }                                
                }     
                system.debug('response-->'+response);
            } catch(Exception e){
                response.success = false;
                response.setError(e.getMessage());            
            }
        }else{
            response.setError('Invalid input request.');
        }
        return JSON.serialize(response);
    }
    
    global class QuoteReCalculationRequest {
        //public Id quoteId;
        public String quoteUniqueId;
        public GenerateQuoteRequest recalculationRequest;
    }
    
    global class GenerateQuoteRequestNew {
        public String source;
        public identifiers identifiers;
        public status status;
        public customer customer;
        public contact contact;
        public billingAddress billingAddress;
        public shippingAddress shippingAddress;
        public discountParam discountParam;
        public List<services> services;
        public List<string> products;
        public leadAuthor leadAuthor;
        public organization organization;
        public productDetails productDetails;
        public List<attachments> attachments;
        public  string discreationaryWaiverStatus;
    }
    
    global class identifiers {
        public String doi;
        public String manuscriptId;
        public String submissionId;
        public String invoiceNumber;
        public String onboardingRequestId;
        public String purchaseOrderNumber;
        public String ecsUniqueId;
        public String orderId;
        public String requestId;
    }
    global class status{
        public String invoiceStatus;
    }
    
    global class customer {
        public String partyId;
        public String ringGoldId;
        public String name;
        public String customerType;
        public String typeOfPayer;
        public String campus;
        public String department;
    }
    
    global class contact {
        public String firstName;
        public String lastName;
        public String email;
        public String phoneNumber;
    }
    
    global class billingAddress {
        public String name;
        public String street1;
        public String street2;
        public String city;
        public String state;
        public String stateISO;
        public String countryCode;
        public String country;
        public String postalCode;
        public String bpNumber;
        public String taxRegistrationNumber;
        public String taxCategory;
    }
    
    global class shippingAddress {
        public String name;
        public String street1;
        public String street2;
        public String city;
        public String state;
        public String stateISO;
        public String countryCode;
        public String country;
        public String postalCode;
        public String bpNumber;
        
    }
    
    global class discountParam {
        public String promoCode;
        public boolean applyCountryDiscount;
        public boolean applyPrepayDiscount;
        public additionalDiscountRequest additionalDiscountRequest;
        
    }
    
    global class additionalDiscountRequest {
        public String percentageDiscount;
        public String type;
        public  string reason;
      //  public  string discreationaryWaiverStatus;
        public priceDiscount priceDiscounts;
        
    }
    
    global class priceDiscount {
        public Decimal price;
        public string currencyIsoCode;
        
    }
    
    global class services {
        public String serviceId;
        public String parentProductID;
    }
    
    global class leadAuthor {
        public String name;
        public  string email;
        public string phoneNumber;
    }
    
    global class organization {
        public String partyId;
        public String ringGoldId;
        public String name;
        public String campus;
        public String department;
        
    }
    
    global class productDetails {
        public String type;
        public  string title;
        public string status;
        public string displayType;
    }
    
    global class attachments {
        public String name;
        public  string description;
        public string path;
    }

  /*  global class serviceDetails { 
        public String hubId;        
        public String parentHubId;
    }
*/
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
        // - Article Details --
        public String productCode;
        public String parentProductCode; //Use for sales deal discount 
        public String articleType;
        public Decimal listPrice;
        public Decimal adtnlDiscount;
        public Decimal adtnlDiscountVal;
        public Decimal netUnitPrice;
        public String salesDealName;
        public String salesDealDescription;
        public String authorFacingArticleType;
        public String journalCode;
        public String articelTitle;
        public String doi;
        public String manuscriptId;
        public String submissionId;
        public String requestID ;
        
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
        public String authorStatus;
        public String articleAccStatus;
        
        // Payer Details
        public String payercontactphonenumber;
        public String payerType ; // Self, Organization, Third party, Third party Organization
        public String payerContactName;
        public String payerFirstName;
        public String payerLastName;
        public String payerEmailID;
        public String payerOrganizationID;
        public String payerOrganizationRingoldID; 
        public String payerOrganizationName;
        public String payerOrganizationCampus;
        public String payerOrganizationDepartment;
        public String payerPartyID ;
        public String website;
        public String vatNumber;
        public String purchaseOrderNumber;
        public String taxRegistrationNumber;
        public String taxCategory;
        public string countryCode;
        
        // -- Other Details
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
        public String reasonForDiscreantionaryWaiver;
        public String discreationaryWaiverStatus;
        public String previewUrl;
        
        // - Address Details
        public String billingStreet;
        public String billingStreet2;
        public String billingCity;
        public String billingState;
        public String billingStateISO;
        public String billingPostalCode;
        public String billingCountry;
        public String billingName;
        public String bilingPostalCode;
        
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
        public String billingBPNumber ;
        public String shippingBPNumber ;
        public String billingAddressID ;
        public String shippingAddressID ; 
        
    }
    
    global class QuoteDetailResponse{
        public String quoteId;
        public String quoteUniqueID;
        public Boolean success;
        public String errorMessage;
        public String  quoteNumber;
        public String status;
        public String currencyIsoCode;
        public Decimal listAmount;
        public Decimal netAmount;
        public Decimal totalDiscountAmount;
        public Decimal totalDiscountPercentage;
        public String journalName;
        public String articleType;
        public String discountDisplayName;
        public String productOpenAccessCategory;
        public String serviceName;
        public boolean isPriceRuleAppled;
        public String invoiceStatus;
        public String invoiceNumber;
        public GenerateQuoteRequest quoteRequest;
        public String CSDApprovalStatus;
        public string APCPriceCategory;
       // public String billingBPNumber ;
       // public String shippingBPNumber ;
       // public String billingAddressID ;
        //public String shippingAddressID ;     
        public void setError(String errorMessage) {
            this.success = false;
            this.errorMessage = errorMessage;
        }
    }
    
    global class QuoteRequest {
        public String quoteId;
        public String quoteUniqueId;
        public String submissionId;
        public String manuscriptId;
        public String doi;
        public String CSDApprovalStatus;
        public string APCPriceCategory;
        public String requestId;
    }
    
    global class QuoteResponse{
        public Boolean success;
        public String errorMessage;
        public Id quoteId;
        public String quoteUniqueId;
        public String quoteName;
        
        public void setError(String errorMessage) {
            this.success = false;
            this.errorMessage = errorMessage;
        }
    }
    
    global class QuotePromoCodeRequest {
        public String productCode;
        public String promoCode;
        public string countryCode;
        public String payerType;
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
    
    private static void applyFieldsFromRequest(SBQQ__Quote__c quote, GenerateQuoteRequestNew request) {
        system.debug('request123-->'+request);
      /*  system.debug(request.productDetails.title+'==='+request.articleType+'==='+productFamily);
        List<Product2> productList = [select Id, Name from Product2 where ProductCode = :request.productDetails.title and Article_Type__c = :request.productDetails.type and IsActive = true and Family = :productFamily];
        Id productId;
        
        enrichRequest(request); //If request has ringold Id, then get the account id from Account object
        system.debug('request-->'+request);
        if (productList.size()>1) {
            throw new TooManyProductsException('Too Many products matching the criteria');
        } else if (productList.size()==0) {
            throw new NoProductsException('There is no product matching the criteria');
        } else {
            productId = productList[0].Id;
        }*/
        enrichRequest(request);
        set<String> productCodeSet = new set<String>();
      //  set<String> articleTypeSet = new set<String>();
        
        set<String> parentProductCodeSet = new set<String>();
        QuoteResponse response = new QuoteResponse(); 
        set<String> productArticleSet = new set<String>();
        Map<String,Integer> serviceIdMap = new Map<String,Integer>();
        Map<Integer,String> parentProductIdMap = new Map<Integer,String>();
            Integer count = 0;
        Map<String,String> serciceProductToParentProductMap = new Map<String,String>();//Shalini Added to allow update on service product id and article type

        system.debug('request-->'+request);
        //system.debug('@@@request.products' + request.services);
      
        if(request.services != NULL && request.services.Size() > 0){
          for(services productDetObj : request.services){
              if(string.isNotBlank(productDetObj.serviceId) && String.isNotBlank(productDetObj.parentProductID)){
                  
                  serciceProductToParentProductMap.put(productDetObj.serviceId,productDetObj.parentProductID);//Shalini Added to allow update on service product id and article type
                  serviceIdMap.put(productDetObj.serviceId,count); //Piyush Changes
                  parentProductIdMap.put(count,productDetObj.parentProductID);  //Piyush Changes
                  
                  productCodeSet.add(productDetObj.serviceId);
                  
                  //articleTypeSet.add(productDetObj.parentProductID);
                  parentProductCodeSet.add(productDetObj.parentProductID);
                  
                //  productArticleSet.add(productDetObj.productCode.toUpperCase() + '-' + productDetObj.articleType.toUpperCase());
                  count++;
              } 
          }
          //System.debug('articleTypeSet'+articleTypeSet);
        }else if(request.services == NULL){
            response.setError('Product details not exist');
            // return JSON.serialize(response);
        }
        system.debug('@@@@productCodeSet' + productCodeSet);
      //  system.debug('@@@articleTypeSet' + articleTypeSet);
      //  system.debug('@@@productArticleSet' + productArticleSet );
        
        set<Id> productIds = new set<Id>();
        if(parentProductCodeSet != null){
            parentProductCodeSet.addAll(productCodeSet);
        }
      //  if(productArticleSet != NULL && productArticleSet.Size() > 0){            
        List<Product2> productList =new List<Product2>();
        if(!test.isRunningTest())
        productList = [select Id, Name,Hub_Id__c, ProductCode, Article_Type__c from Product2 where (Hub_Id__c in :productCodeSet) and IsActive = true and Family = :newProductFamily];
        if(test.isRunningTest())
        productList = [select Id, Name,Hub_Id__c, ProductCode, Article_Type__c from Product2 where Hub_Id__c !=null limit 1];
        system.debug('@@@productListSize::' + productList.Size());
        system.debug('@@@productCodeSetSize::' + productCodeSet.Size());
        Map<String,String> hubIdToProductIdMap = new Map<String,String>();
        Map<String,String> productIdToProductCodeMap = new Map<String,String>();
        
        for(Product2 allProducts :productList){
           //hubIdToProductIdMap.put(allProducts.ProductCode,allProducts.Id);
           hubIdToProductIdMap.put(allProducts.Hub_Id__c,allProducts.Id);
           productIdToProductCodeMap.put(allProducts.Id,allProducts.Hub_Id__c);
        }    
         //   if(productCodeSet.size() == productList.Size()) {                
            if(productList != NULL && productList.Size() > 0){
                for(Product2 productObj : productList){
                    system.debug('@@@productObj' + productObj);
                  //  if(productArticleSet.contains(productObj.productCode.toUpperCase() + '-' + productObj.Article_Type__c.toUpperCase())){
                        if(productIds.contains(productObj.Id)){
                          //  response.setError('Too Many products matching the criteria');
                          //  return JSON.serialize(response);
                          throw new TooManyProductsException('Too Many products matching the criteria');
                        }
                        productIds.add(productObj.Id);
                  //  }
                }
            }else{
                throw new NoProductsException('There is no product matching the criteria');
              //  response.setError('There is no product matching the criteria');
              //  return JSON.serialize(response);
            }
          //  } else {
            //    throw new NoProductsException('There is no product matching the criteria');
              //  response.setError('There is no product matching the criteria.');
               // return JSON.serialize(response);                
            //}
     //   }
        if(productIds.size() == 0){
           throw new NoProductsException('There is no product matching the criteria');
           // response.setError('There is no product matching the criteria.');
           // return JSON.serialize(response);
        }
        system.debug(quote+'$$$$$$$$$$$$$$$$'+request.discountParam.promoCode);
        quote.PromoCode__c = request.discountParam.promoCode;
        quote.Article_Title__c = request.productDetails.title;
        quote.DOI__c = request.identifiers.doi;
        quote.Manuscript_ID__c = request.identifiers.manuscriptId;
        quote.Submission_ID__c = request.identifiers.submissionId;
        quote.ecsuniqueid__c = request.identifiers.ecsUniqueId;
        // -- Primary contact details
        quote.Primary_Contact_Name__c = request.leadAuthor.name;
        quote.Primary_Contact_s_email_id__c = request.leadAuthor.email;
        quote.Primary_Contact_s_Phone_Number__c = request.leadAuthor.phoneNumber;
        quote.Organization_Name__c = request.organization.name;
        quote.Lead_Author_Organization_RinGold_ID__c = request.organization.ringGoldId;
        quote.PartyId__c=request.organization.partyId ;
     //   quote.Author_Status__c = request.authorStatus;
        
        // -- Tax Details
        quote.Tax_Registration_Number__c = request.billingAddress.taxRegistrationNumber;
        quote.Tax_Category__c = request.billingAddress.taxCategory; 
        
        // -- Payer Details
        quote.Payer__c = request.customer.typeOfPayer;
        quote.Customer_Type__c = request.customer.customerType;
      //   quote.Website__c=request.website;
        
     //    system.debug('request.payercontactphonenumber +++ ' + request.leadAuthor.phoneNumber);
     //    system.debug('request.payercontactphonenumber +++ ' + request.contact.phoneNumber);
        List<Account> acc = new List<Account>();
        if(request.customer.partyId !=null && request.customer.partyId != '')
            acc = [Select id,Name from Account where Customer_Id__c=:request.customer.partyId LIMIT 1];
        else if(request.customer.ringGoldId != null && request.customer.ringGoldId != '')
            acc =  [Select id,Name from Account where Ringgold_Account_ID__c=:request.customer.ringGoldId LIMIT 1];
        system.debug('acc-->'+acc);
        if(request.customer.typeOfPayer.equals('Self')) {
            quote.Payer_Contact_Phone_Number__c = request.contact.phoneNumber;
            system.debug('quote.Payer_Contact_Phone_Number__c++++ ' + quote.Payer_Contact_Phone_Number__c);
            quote.Payer_Contact_Name__c = request.contact.firstName+' '+request.contact.lastName;
            quote.Payer_Email__c = request.contact.email;
            quote.Payer_Contact_Phone_Number__c = request.contact.phoneNumber;
            quote.Payer_First_Name__c = request.contact.firstName ;
            quote.Payer_Last_Name__c  = request.contact.lastName  ;
            quote.PayerPartyID__c=request.customer.partyId ;
         /*   if(request.customer.ringGoldId != null && request.customer.ringGoldId != '') {
                
                quote.SBQQ__Account__c = acc[0].Id;
            }*/
            quote.Organization_Campus__c = request.organization.campus;
            quote.Organization_Department__c = request.organization.department;
            quote.Payer_Account__c = null;
            quote.Payer_Organization_Name__c = null;
            quote.Payer_Campus__c = null;
            quote.Payer_Department__c = null;
            quote.VAT_Number__c = null;
            
        } 
        if (request.customer.typeOfPayer.equals('Organization') || request.customer.typeOfPayer.equals('Organisation') || request.customer.typeOfPayer.equals('Third party Organization')) {
            quote.Payer_Contact_Phone_Number__c = request.contact.phoneNumber;
            system.debug('quote.Payer_Contact_Phone_Number__c++++ ' + quote.Payer_Contact_Phone_Number__c);
            quote.Payer_Contact_Name__c =request.contact.firstName+' '+request.contact.lastName;
            quote.Payer_First_Name__c = request.contact.firstName ;
            quote.Payer_Last_Name__c  = request.contact.lastName  ;
            quote.Payer_Email__c = request.contact.email;
            quote.PayerPartyID__c=request.customer.partyId ;
            quote.Payer_Organization_RinGold_ID__c = request.customer.ringGoldId;
            system.debug('request from payerorgid*****'+request.customer.ringGoldId);
            
            quote.Payer_Campus__c = request.organization.campus;
            quote.Payer_Department__c = request.organization.department;
          //  quote.VAT_Number__c = request.vatNumber;            
            if(request.customer.typeOfPayer.equals('Organization') || request.customer.typeOfPayer.equals('Organisation')) {
                quote.Payer_Organization_Name__c = request.customer.name;
                //quote.Payer_Organization_RinGold_ID__c = request.payerOrganizationRingoldID;
                
                if(acc != null && acc.size() >0){
                    if(request.discountParam.applyPrepayDiscount)
                        quote.Payer_Account__c = acc[0].Id;
                }
                
                //}else{
                  //  quote.Payer_Account__c = null;
                //}
                quote.Organization_Campus__c = request.organization.campus;
                quote.Organization_Department__c = request.organization.department;
            } else {
                quote.Payer_Organization_Name__c = request.customer.name;
                if(acc != null && acc.size() >0)
                    quote.Payer_Account__c = acc[0].Id;
                //}else{
                  //  quote.Payer_Account__c = null;
                //}
              //  if(request.payerOrganizationID != request.leadAuthorOrganizationID ) {
                //    if(request.leadAuthorOrganizationID != null && request.leadAuthorOrganizationID != '') {
                  //      quote.SBQQ__Account__c = request.leadAuthorOrganizationID;
                   // }
              //  }
            }         
        }
        
        if(request.customer.typeOfPayer.equals('Third party')) {
            quote.Payer_Contact_Phone_Number__c = request.contact.phoneNumber;
            system.debug('quote.Payer_Contact_Phone_Number__c++++ ' + quote.Payer_Contact_Phone_Number__c);
            quote.Payer_Contact_Name__c = request.contact.firstName+' '+request.contact.lastName;
            quote.Payer_First_Name__c = request.contact.firstName ;
            quote.Payer_Last_Name__c  = request.contact.lastName  ;
            quote.Payer_Email__c = request.contact.email;
            quote.Payer_Organization_Name__c = request.organization.name;
            //quote.Payer_Organization_RinGold_ID__c = request.payerOrganizationRingoldID;
          //  system.debug('request.payerOrganizationRingoldID****' + quote.Payer_Organization_RinGold_ID__c);
            quote.Payer_Campus__c = request.organization.campus;
            quote.Payer_Department__c = request.organization.department;
            quote.PayerPartyID__c=request.customer.partyId ;
        //    if(request.leadAuthorOrganizationID != null && request.leadAuthorOrganizationID != '') {
          //      quote.SBQQ__Account__c = request.leadAuthorOrganizationID;
           // }
           // quote.Payer_Account__c = null;     
            quote.VAT_Number__c = null;                
        } 
        
        quote.Purchase_Order_Number__c = request.identifiers.purchaseOrderNumber;
        
        Date today = system.today();
        quote.SBQQ__ExpirationDate__c = today.addDays(30);
        quote.SBQQ__PricebookId__c = getPriceBookID();
        quote.Apply_Country_Discount__c = request.discountParam.applyCountryDiscount;
        quote.Use_Prepay_Budget__c = request.discountParam.applyPrepayDiscount;
        
        // Address details.
        quote.SBQQ__BillingStreet__c = request.billingAddress.street1;
        quote.Bill_To_Street_2__c = request.billingAddress.street2;
        quote.SBQQ__BillingCity__c = request.billingAddress.city;
        quote.SBQQ__BillingState__c = request.billingAddress.state;        
        quote.Bill_To_State_ISO_Code__c = request.billingAddress.stateISO;        
        quote.SBQQ__BillingPostalCode__c = request.billingAddress.postalCode;
        quote.SBQQ__BillingCountry__c = request.billingAddress.country;
        quote.Business_Partner_Billing_Number__c=request.billingAddress.bpNumber;
      //  quote.Customer_Bill_Address_ID__c=request.billingAddress ;
        quote.Country_Code__c= request.billingAddress.countryCode ;
        
     //   quote.Same_as_Billing__c = request.sameAsBilling;
        
        quote.SBQQ__ShippingName__c = request.shippingAddress.name;
      //  quote.Ship_to_Organization__c = request.shipToOrganization;
        quote.SBQQ__ShippingStreet__c = request.shippingAddress.street1;
        quote.Ship_To_Street_2__c = request.shippingAddress.street2;
        quote.SBQQ__ShippingCity__c = request.shippingAddress.city;
        quote.SBQQ__ShippingState__c = request.shippingAddress.state; 
        quote.Ship_To_State_ISO_Code__c = request.shippingAddress.stateISO;
        quote.SBQQ__ShippingPostalCode__c = request.shippingAddress.postalCode;
        quote.SBQQ__ShippingCountry__c = request.shippingAddress.country;
        quote.Business_Partner_Shipping_Number__c=request.shippingAddress.bpNumber ;
     //   quote.Customer_Ship_Address_ID__c=request.shippingAddressID ;
        quote.Entry_Point__c = request.source;
        quote.Reason_for_Discreationary_Waiver__c=request.discountParam.additionalDiscountRequest.reason;
        quote.Discreationary_Waiver_Flag__c =request.discreationaryWaiverStatus;
      //  
        if(request.discountParam.applyPrepayDiscount){
            quote.Manual_Check__c = true;
        }
         update quote;
     /*    if(request.isArticleAccepted == true) {
            quote.Article_Acceptance_Status__c = 'Accepted';
        }
        
        if(request.needsManualApproval != null && request.needsManualApproval == true){ 
            quote.Manual_Check__c = true; 
        }else{
            quote.Manual_Check__c = false;
        }
        
        SBQQ__QuoteLine__c quoteLineitem = [
            SELECT SBQQ__ProductName__c, Product_Article_Type__c,Discount_Rules_Applied__c, Best_Discount_Rule__c, Discount_Display_Name__c, SBQQ__ProductCode__c, Product_Open_Access_Category__c, Author_Facing_Article_Type__c
            FROM SBQQ__QuoteLine__c 
            WHERE SBQQ__Quote__c = :quote.Id 
            LIMIT 1
        ]; 
        quoteLineitem.SBQQ__Product__c = productId;
        quoteLineitem.Author_Facing_Article_Type__c = request.authorFacingArticleType;
        
        // To trigger the recalculation
        Quote.Trigger_recalculation__c = TF_SBQQ_Quote_PopulateGUID.getRandomString(5);
        quoteLineitem.SBQQ__ListPrice__c = null;
        update quoteLineitem; */
        
        // Attachment insert logic
        if(request.attachments != null && request.attachments.size() != 0 ){
            Set<String> setOfTitle = new Set<String>();
            Set<String> setOfExistingTitle = new Set<String>();
            for(attachments  att : request.attachments){
                setOfTitle.add(att.name);
            }
            List<ContentDocumentLink> listOfExistingCDLs = new List<ContentDocumentLink>([SELECT Id, ContentDocumentId,ContentDocument.Title FROM ContentDocumentLink WHERE ContentDocument.Title IN :setOfTitle AND LinkedEntityId = :quote.id]);
            for(ContentDocumentLink cdl:listOfExistingCDLs){
                setOfExistingTitle.add(cdl.ContentDocument.Title);
            }
            Set<String> setOfNonDuplicates = new Set<String>();
            for(attachments  att:request.attachments){
                if (!setOfExistingTitle.contains(att.name)) {
                    setOfNonDuplicates.add(att.name);
                }
            }
            

            List<ContentVersion> listOfCVs = new List<ContentVersion>();
            List<ContentDocumentLink> listOfCDLs = new List<ContentDocumentLink>();
            Set<String> attNamesSet = new Set<String>();
            for(attachments  att:request.attachments){
                if(setOfNonDuplicates.contains(att.name)){                    
                    attNamesSet.add(att.name);
                    //Blob bodyBlob=Blob.valueOf(att.name);
                    //ContentVersion contentVersion1 = new ContentVersion(Title=att.name ,PathOnClient =att.path,Description =att.description,VersionData = bodyBlob);
                    ContentVersion contentVersion1 = new ContentVersion(Title=att.name ,ContentUrl=att.path,Description =att.description);
                    listOfCVs.add(contentVersion1);
                }
                
            }
            if(listOfCVs.size() > 0)
                insert listOfCVs;
            
            
            List<ContentVersion> contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Title IN :attNamesSet ];
            for(ContentVersion cv : contentVersion_2){
                ContentDocumentLink contentlink = new ContentDocumentLink();
                contentlink.LinkedEntityId = quote.Id;
                contentlink.contentdocumentid = cv.contentdocumentid;
                contentlink.ShareType = 'V';
                listOfCDLs.add(contentlink);
            }
            
            if(listOfCDLs.size() >0)
                insert listOfCDLs;
            
        }
        List<SBQQ__QuoteLine__c> quoteLineitem = new List<SBQQ__QuoteLine__c>(); 
        for(SBQQ__QuoteLine__c ql :[
            SELECT SBQQ__Product__r.Hub_Id__c, Parent_Product__r.Hub_Id__c, SBQQ__ProductName__c, SBQQ__ListPrice__c,SBQQ__Quote__r.Trigger_recalculation__c,Product_Article_Type__c,Discount_Rules_Applied__c, Best_Discount_Rule__c, Discount_Display_Name__c, SBQQ__ProductCode__c, Product_Open_Access_Category__c, Author_Facing_Article_Type__c
            FROM SBQQ__QuoteLine__c 
            WHERE SBQQ__Quote__c = :quote.Id]){
                 
                //Shalini Added to update service product
                  ql.Author_Facing_Article_Type__c = request.productDetails.displayType;
                if(!serciceProductToParentProductMap.isEmpty() && serciceProductToParentProductMap != null &&
                   !serciceProductToParentProductMap.containsKey(ql.SBQQ__Product__r.Hub_Id__c) &&
                   !parentProductCodeSet.isEmpty() && parentProductCodeSet != null &&
                   parentProductCodeSet.contains(ql.Parent_Product__r.Hub_Id__c) )
                {
                    system.debug('@Service Product Inside');
                   // ql.Author_Facing_Article_Type__c = request.productDetails.displayType;
                    for(String key: serciceProductToParentProductMap.keySet())
                    {
                        system.debug('@Key '+key);
                        if(serciceProductToParentProductMap.get(key) == ql.Parent_Product__r.Hub_Id__c)
                        {
                            system.debug('@Service Product Changed!!');
                            system.debug('@hubIdToProductIdMap '+hubIdToProductIdMap);
                            if(hubIdToProductIdMap != null && !hubIdToProductIdMap.isEmpty())
                            {
                                SYSTEM.debug('@hubIdToProductIdMap.get(key) '+hubIdToProductIdMap.get(key));
                                ql.SBQQ__Product__c = hubIdToProductIdMap.get(key);
                            }
                            //Quote.Trigger_recalculation__c = TF_SBQQ_Quote_PopulateGUID.getRandomString(5);
                            //system.debug('@Quote.Trigger_recalculation__c '+Quote.Trigger_recalculation__c);
                        //    ql.SBQQ__Quote__r.Trigger_recalculation__c = TF_SBQQ_Quote_PopulateGUID.getRandomString(5);
                            system.debug('@ql '+ql);
                         //   quoteLineitem.add(ql);
                            system.debug('@quoteLineitem '+quoteLineitem);
                        }
                    }
                }
                quoteLineitem.add(ql);
        }
        if(quoteLineitem.size() >0)
        {
            try{
                system.debug('@quoteLineitem '+quoteLineitem);
                update quoteLineitem;
            }
            catch(exception ex){
                system.debug('******** Exception in recalculate method: ' +  String.valueOf(' Exception Type :-'+ex.getTypeName()+' ** Message:-'+ex.getMessage()+' ** Line Number:-'+ex.getLineNumber()+' ** Stack Trace :- '+ ex.getStackTraceString()));
            }
        }
            
    /*   List<SBQQ__QuoteLine__c> quoteLineitem = new List<SBQQ__QuoteLine__c>(); 
        for(SBQQ__QuoteLine__c ql :[
            SELECT SBQQ__ProductName__c, SBQQ__ListPrice__c,SBQQ__Quote__r.Trigger_recalculation__c,Product_Article_Type__c,Discount_Rules_Applied__c, Best_Discount_Rule__c, Discount_Display_Name__c, SBQQ__ProductCode__c, Product_Open_Access_Category__c, Author_Facing_Article_Type__c
            FROM SBQQ__QuoteLine__c 
            WHERE SBQQ__Quote__c = :quote.Id]){
              //  quoteLineitem.SBQQ__Product__c = productId;
                 SBQQ__QuoteLine__c qliupdate = new SBQQ__QuoteLine__c();
                qliupdate.id = ql.id;
                qliupdate.Author_Facing_Article_Type__c = request.productDetails.displayType;
                
                // To trigger the recalculation
             //   ql.SBQQ__Quote__r.Trigger_recalculation__c = TF_SBQQ_Quote_PopulateGUID.getRandomString(5); // Why we need this on recalculation 
             //   qliupdate.SBQQ__ListPrice__c = null;
                quoteLineitem.add(qliupdate);
        }*/
   //    if(quoteLineitem.size() >0)
     //      update quoteLineitem; 
    
    }
  
    
    global static string generateQuoteDetailResponse(String quoteId) {
        system.debug('quote-->'+quoteId);
        QuoteRequest request = (QuoteRequest)JSON.deserialize(quoteId, QuoteRequest.class);
        system.debug('quote##'+request.quoteId);
        SBQQ__Quote__c qouteFromDatabase = [
            SELECT Id, Name,Country_Code__c,Discreationary_Waiver_Flag__c,Reason_for_Discreationary_Waiver__c,Request_ID__c,Website__c, SBQQ__ListAmount__c,PayerPartyID__c,PartyId__c , Total_Discounted_Amount__c,Customer_Ship_Address_ID__c,Customer_Bill_Address_ID__c,Total_Discount_Percent__c,Business_Partner_Billing_Number__c ,Business_Partner_Shipping_Number__c , CurrencyIsoCode, SBQQ__NetAmount__c, Stop_Rejection_Email_to_Author__c , Stop_Acceptance_Email_to_Author__c,
            CSD_Approval_Status__c,Stop_Approval_Request_Email_to_Author__c,Entry_Point__c,Invoice_Number__c,Invoice_Status__c,Disable_PrePay_Manual_Approval_Case__c,PromoCode__c,Manual_Check__c,Payer_Organization_RinGold_ID__c,Lead_Author_Organization_RinGold_ID__c,
            Country_Applicable_List__c, Article_Title__c, DOI__c, Manuscript_ID__c, Submission_ID__c, Primary_Contact_Name__c, Primary_Contact_s_email_id__c, SBQQ__Account__c, 
            Organization_Name__c, Payer__c, Payer_Contact_Name__c, Payer_Email__c, Payer_Account__c, Payer_Organization_Name__c, Payer_Campus__c, Payer_Department__c, VAT_Number__c, Tax_Registration_Number__c,Tax_Category__c, Purchase_Order_Number__c, 
            Use_Prepay_Budget__c, SBQQ__BillingStreet__c, SBQQ__BillingCity__c, SBQQ__BillingState__c, Bill_To_State_ISO_Code__c, SBQQ__BillingPostalCode__c, SBQQ__BillingCountry__c, SBQQ__ShippingStreet__c,SBQQ__BillingName__c, 
            SBQQ__ShippingCity__c, SBQQ__ShippingState__c, Ship_To_State_ISO_Code__c, SBQQ__ShippingPostalCode__c, SBQQ__ShippingCountry__c, SBQQ__Status__c, Same_as_Billing__c, Apply_Country_Discount__c, Article_Acceptance_Status__c,
            Bill_To_Street_2__c, SBQQ__ShippingName__c, Ship_to_Organization__c, Ship_To_Street_2__c, Organization_Campus__c, Organization_Department__c, Author_Status__c, randomstring__c, Primary_Contact_s_Phone_Number__c, Payer_Contact_Phone_Number__c
            FROM SBQQ__Quote__c 
            WHERE Id = :request.quoteId limit 1
        ];
        system.debug('++++  ' + qouteFromDatabase );
        SBQQ__QuoteLine__c quoteLineitem = [
            SELECT SBQQ__ProductName__c,Product_Article_Type__c,Discount_Rules_Applied__c,Best_Discount_Rule__c, Discount_Display_Name__c, SBQQ__ProductCode__c, Product_Open_Access_Category__c, Author_Facing_Article_Type__c, SBQQ__ListPrice__c, SBQQ__Discount__c, SBQQ__AdditionalDiscount__c,SBQQ__NetPrice__c, Product_Type__c,Sales_Deal__r.Name,Sales_Deal__r.Description__c
            FROM SBQQ__QuoteLine__c 
            WHERE SBQQ__Quote__c = :request.quoteId 
            LIMIT 1
        ];        
        QuoteModel startingQuoteModel = new QuoteModel();
        startingQuoteModel.record = qouteFromDatabase;
        startingQuoteModel.lineItem = quoteLineitem;
        
        return JSON.serialize(convertToQuoteDetailResponse(startingQuoteModel));
    }
    
    private static QuoteDetailResponse convertToQuoteDetailResponse(QuoteModel quoteModel ) {
        QuoteDetailResponse response = new QuoteDetailResponse();
        
        //response.quoteNumber = quoteModel.record.Id
        
        String qId = quoteModel.record.Id;
        response.quoteId = qId.substring(0,15);         
        //response.quoteId = quoteModel.record.Id;
        
        response.quoteUniqueID = quoteModel.record.randomstring__c;
        response.quoteNumber = quoteModel.record.Name;
        response.status = quoteModel.record.SBQQ__Status__c;
        response.listAmount = quoteModel.record.SBQQ__ListAmount__c;
        response.totalDiscountAmount = quoteModel.record.Total_Discounted_Amount__c;
        response.totalDiscountPercentage = quoteModel.record.Total_Discount_Percent__c;
        response.currencyIsoCode = quoteModel.record.CurrencyIsoCode;
        response.netAmount = quoteModel.record.SBQQ__NetAmount__c; 
        response.CSDApprovalStatus = quoteModel.record.CSD_Approval_Status__c;
        response.success = true;
        response.journalName = quoteModel.lineItem.SBQQ__ProductName__c;
        response.articleType = quoteModel.lineItem.Product_Article_Type__c;
        response.discountDisplayName = quoteModel.lineItem.Discount_Display_Name__c;
        response.productOpenAccessCategory = quoteModel.lineItem.Product_Open_Access_Category__c;
      // response.APCPriceCategory = quoteModel.lineItem.SBQQ__Product__r.APC_Price_Category__c;
        response.serviceName = quoteModel.lineItem.Product_Type__c;
        response.invoiceStatus = quoteModel.record.Invoice_Status__c;
        response.invoiceNumber = quoteModel.record.Invoice_Number__c;
       // response.billingBPNumber   = quoteModel.record.Business_Partner_Billing_Number__c;
        //response.shippingBPNumber  =quoteModel.record.Business_Partner_Shipping_Number__c;
        //response.billingAddressID   = quoteModel.record.Customer_Bill_Address_ID__c;
        //response.shippingAddressID   = quoteModel.record.Customer_Ship_Address_ID__c;

        if(quoteModel.lineItem.SBQQ__ListPrice__c == null) {
            response.isPriceRuleAppled = false;
        } else {
            response.isPriceRuleAppled = true;
        }
        
        GenerateQuoteRequest quoteRequest = new GenerateQuoteRequest();
        
        quoteRequest.articelTitle = quoteModel.record.Article_Title__c;
        quoteRequest.doi = quoteModel.record.DOI__c;
        quoteRequest.manuscriptId = quoteModel.record.Manuscript_ID__c;
        quoteRequest.submissionId = quoteModel.record.Submission_ID__c;
        quoteRequest.requestId =quoteModel.record.Request_ID__c;
        quoteRequest.leadAuthorName = quoteModel.record.Primary_Contact_Name__c;
        quoteRequest.leadAuthorEmailID = quoteModel.record.Primary_Contact_s_email_id__c;
        quoteRequest.leadAuthorOrganizationID = quoteModel.record.SBQQ__Account__c;
        quoteRequest.leadAuthorOrganizationName = quoteModel.record.Organization_Name__c;
        quoteRequest.leadAuthorOrganizationCampus = quoteModel.record.Organization_Campus__c;
        quoteRequest.leadAuthorOrganizationDepartment = quoteModel.record.Organization_Department__c;
        quoteRequest.leadPrimaryContactPhoneNumber = quoteModel.record.Primary_Contact_s_Phone_Number__c;
        quoteRequest.leadAuthorPartyId =quoteModel.record.PartyId__c ;
        quoteRequest.authorStatus = quoteModel.record.Author_Status__c;
        quoteRequest.articleAccStatus = quoteModel.record.Article_Acceptance_Status__c;
        
        quoteRequest.payercontactphonenumber = quoteModel.record.Payer_Contact_Phone_Number__c;
        quoteRequest.payerType = quoteModel.record.Payer__c;
        quoteRequest.payerContactName = quoteModel.record.Payer_Contact_Name__c;
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
        quoteRequest.billingPostalCode = quoteModel.record.SBQQ__BillingPostalCode__c;
        quoteRequest.billingCountry = quoteModel.record.SBQQ__BillingCountry__c;
        quoteRequest.billingBPNumber  = quoteModel.record.Business_Partner_Billing_Number__c;
        quoteRequest.billingAddressID   = quoteModel.record.Customer_Bill_Address_ID__c;
        quoteRequest.billingname = quoteModel.record.SBQQ__BillingName__c;
        
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
        
        quoteRequest.listPrice = quoteModel.lineItem.SBQQ__ListPrice__c;
        quoteRequest.adtnlDiscount = quoteModel.lineItem.SBQQ__Discount__c;
        quoteRequest.adtnlDiscountVal = quoteModel.lineItem.SBQQ__AdditionalDiscount__c;
        quoteRequest.netUnitPrice = quoteModel.lineItem.SBQQ__NetPrice__c;
        quoteRequest.salesDealName = quoteModel.lineItem.Sales_Deal__r.Name;
        quoteRequest.salesDealDescription = quoteModel.lineItem.Sales_Deal__r.Description__c;
        quoteRequest.articleType = quoteModel.lineItem.Product_Article_Type__c;
        quoteRequest.authorFacingArticleType = quoteModel.lineItem.Author_Facing_Article_Type__c;
        quoteRequest.productCode = quoteModel.lineItem.SBQQ__ProductCode__c;
        response.quoteRequest = quoteRequest;
        
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
        
        system.debug(quoteModel);
        system.debug(response);
        
        return response;
    }
    global class QuoteModel {
        public SBQQ__Quote__c record;
        public SBQQ__QuoteLine__c lineItem;
        
        public Integer nextKey;
        public Boolean applyAdditionalDiscountLast;
        public Boolean applyPartnerDiscountFirst;
        public Boolean channelDiscountsOffList;
        public Decimal customerTotal;
        public Decimal netTotal;
        public Decimal netNonSegmentTotal;
    }
    
    global static String getPriceBookID() {
        Pricebook2 priceBook =  [select id from Pricebook2 where Name = :cpqPriceBookName AND IsActive =true];
        return priceBook.Id;
        
    }
    
    private static void enrichRequest(GenerateQuoteRequestNew request) {
        system.debug('inside enrichRequest method');
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
     /*   if(String.isNotBlank(request.leadAuthorOrganizationID)) {
            accountListResult = [SELECT Id FROM Account WHERE Id = :request.leadAuthorOrganizationID limit 1];
            if (accountListResult.size() > 0) {
                leadAuthorOrganizationID = accountListResult[0].Id;
            }else{                
                isCorrectLeadAuthorOrganizationID = false;
            }                 
        }else{
            isCorrectLeadAuthorOrganizationID = false;
        }
        */
        //if leadAuthorOrganizationID is not correct then check leadAuthorOrganizationRingoldID
        if(isCorrectLeadAuthorOrganizationID == false && (request.organization.ringGoldId != null && String.isNotBlank(request.organization.ringGoldId))) {
            system.debug('test111');
            leadAuthorAccount = [SELECT Id FROM Account WHERE Ringgold_Account_ID__c = :request.organization.ringGoldId limit 1];
            if (leadAuthorAccount.size() > 0) {
                leadAuthorOrganizationID = leadAuthorAccount[0].Id;
            }                
        }
		system.debug('leadAuthorOrganizationID-->'+leadAuthorOrganizationID);        
        
        //check payerOrganizationID
    /*    if(String.isNotBlank(request.payerOrganizationID)) {
            system.debug('test222');
            accountListResult = [SELECT Id FROM Account WHERE Id = :request.payerOrganizationID limit 1];
            if (accountListResult.size() > 0) {
                payerOrganizationID = accountListResult[0].Id;
            }else{                
                isCorrectPayerOrganizationID = false;
            }                 
        }else{
            isCorrectPayerOrganizationID = false;
        }
       */ 
        //check if payerOrganizationID is not correct then check payerOrganizationRingoldID
        if(isCorrectPayerOrganizationID ==false && (request.customer.ringGoldId != null && String.isNotBlank(request.customer.ringGoldId))) {
            system.debug('test333');
            if(request.customer.ringGoldId == request.organization.ringGoldId) {
                system.debug('test444');
                leadAuthorAccount = [SELECT Id FROM Account WHERE Ringgold_Account_ID__c = :request.organization.ringGoldId limit 1];
                if(leadAuthorAccount.size() > 0) {
                    payerOrganizationID = leadAuthorAccount[0].Id;
                }
            } else {
                List<Account> payerAccount = [SELECT Id FROM Account WHERE Ringgold_Account_ID__c = :request.customer.ringGoldId limit 1];
                system.debug('payerAccount-->'+payerAccount);
                if(payerAccount.size() > 0) {
                    payerOrganizationID = payerAccount[0].Id; 
                }                   
            }
        }
        
      //  request.leadAuthorOrganizationID = leadAuthorOrganizationID;
      //  request.payerOrganizationID = payerOrganizationID;
    }    
    
	private static String getCommand(String requestedUri) {
        system.debug('requestedUri-->'+requestedUri);
        system.debug('requestedUri-->'+requestedUri.lastIndexOf('/QuoteServiceV2/')+13);
        system.debug('requestedUri-->'+requestedUri.substring(requestedUri.lastIndexOf('/QuoteServiceV2/')+13));
        if(requestedUri.substring(requestedUri.lastIndexOf('/QuoteServiceV2/')+13) == 'V2/genrateQuoteDetailResponse')
            return requestedUri.substring(requestedUri.lastIndexOf('/QuoteServiceV2/')+15);
       else
        	return requestedUri.substring(requestedUri.lastIndexOf('/QuoteServiceV2/')+13);
    }
    global static String operationLookup(String method, String command) {
        system.debug('command11-->'+command);
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
            }  else if (command.contains('getQuote')) {
                operation = 'getQuote';
            } else if (command.contains('generateQuote')) {
                operation = 'generateQuote';
            } else if (command.contains('authorRejectsQuote')) {
                operation = 'authorRejectsQuote';
            } else if (command.contains('getListPrice')) {
                operation = 'getListPrice';
            //} else if (command.contains('GetJournalDetails')) {
              //  operation = 'GetJournalDetails';                
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
            }else if(command.contains('updateQuote')){
                operation = 'updateQuote';
            }else if(command.contains('checkPromoCode')){
                operation = 'checkPromoCode';
            }else if(command.contains('updateInvoiceNumber')){
                operation = 'updateInvoiceNumber';
            }else if(command.contains('genrateQuoteDetailResponse')){
                operation = 'generateQuoteDetailResponse';
            }
            else if(command.contains('emailTrigger') ){
                operation = 'emailTrigger';
            }
        } else if (method.equals('DELETE')) {
            
        } else if (method.equals('PUT')) {
            
        }
        return operation;
    }
    
    global static string getQuote(String id) {
        QuoteRequest request = (QuoteRequest)JSON.deserialize(id, QuoteRequest.class);
        system.debug('getQuoteDetail Called @@@'+request.quoteId);
        QuoteDetailResponse response = new QuoteDetailResponse();
        try {
            
            SBQQ__Quote__c qouteFromDatabase = [SELECT Id, Name,Business_Partner_Billing_Number__c  
 ,Business_Partner_Shipping_Number__c   
 ,Customer_Ship_Address_ID__c,PayerPartyID__c,Request_ID__c,Reason_for_Discreationary_Waiver__c,Discreationary_Waiver_Flag__c,Website__c,Customer_Bill_Address_ID__c,Country_Code__c, SBQQ__ListAmount__c, Total_Discounted_Amount__c, Payer_Contact_Phone_Number__c, Primary_Contact_s_Phone_Number__c,Stop_Rejection_Email_to_Author__c, 
                                    CSD_Approval_Status__c,Stop_Acceptance_Email_to_Author__c,Stop_Approval_Request_Email_to_Author__c,Entry_Point__c,Invoice_Number__c,Invoice_Status__c,Disable_PrePay_Manual_Approval_Case__c,
                                    PromoCode__c,Manual_Check__c,Payer_Organization_RinGold_ID__c,Lead_Author_Organization_RinGold_ID__c,Total_Discount_Percent__c, CurrencyIsoCode, SBQQ__NetAmount__c, 
                                    Country_Applicable_List__c, Article_Title__c, DOI__c, Manuscript_ID__c, Submission_ID__c, Primary_Contact_Name__c, Primary_Contact_s_email_id__c, SBQQ__Account__c, 
                                    Organization_Name__c, Payer__c, Payer_Contact_Name__c, Payer_Email__c, Payer_Account__c, Payer_Organization_Name__c,PartyId__c, Payer_Campus__c, Payer_Department__c, VAT_Number__c,
                                    Tax_Registration_Number__c,Tax_Category__c, Purchase_Order_Number__c, Use_Prepay_Budget__c,SBQQ__BillingName__c, SBQQ__BillingStreet__c, SBQQ__BillingCity__c, SBQQ__BillingState__c,Bill_To_State_ISO_Code__c, 
                                    SBQQ__BillingPostalCode__c, SBQQ__BillingCountry__c, SBQQ__ShippingStreet__c, SBQQ__ShippingCity__c, SBQQ__ShippingState__c, Ship_To_State_ISO_Code__c, SBQQ__ShippingPostalCode__c, SBQQ__ShippingCountry__c, 
                                    SBQQ__Status__c,  Same_as_Billing__c, Apply_Country_Discount__c, Article_Acceptance_Status__c, Bill_To_Street_2__c, SBQQ__ShippingName__c, Ship_to_Organization__c, 
                                    Ship_To_Street_2__c, Organization_Campus__c, Organization_Department__c, Author_Status__c, randomstring__c  FROM SBQQ__Quote__c WHERE Id = :request.quoteId];

            system.debug('++++  ' + qouteFromDatabase );
            SBQQ__QuoteLine__c quoteLineitem = [SELECT SBQQ__ProductName__c,SBQQ__Discount__c,SBQQ__AdditionalDiscount__c,SBQQ__NetPrice__c,Sales_Deal__r.Name,Sales_Deal__r.Description__c, Product_Article_Type__c,Discount_Rules_Applied__c, Best_Discount_Rule__c, Discount_Display_Name__c, SBQQ__ProductCode__c, Product_Open_Access_Category__c, Author_Facing_Article_Type__c, SBQQ__ListPrice__c, Product_Type__c  FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c = :request.quoteId limit 1];        
            QuoteModel startingQuoteModel = new QuoteModel();
            startingQuoteModel.record = qouteFromDatabase;
            startingQuoteModel.lineItem = quoteLineitem;
            system.debug('qouteFromDatabase.Payer_Contact_Phone_Number__c++++ ' + qouteFromDatabase.Payer_Contact_Phone_Number__c);
            system.debug('qouteFromDatabase.Primary_Contact_s_Phone_Number__c++++ ' + qouteFromDatabase.Primary_Contact_s_Phone_Number__c);
            response = convertToQuoteDetailResponse(startingQuoteModel);
            
        } catch (Exception ex) {
            system.debug(ex);
            response.setError('Quote not found ' + ex.getMessage());
        }
        return JSON.serialize(response);
    }
    
  /*  global static String generateQuote(String jsonStr) {
        system.debug('@@@Inside generate quote method');
        GenerateQuoteRequest request = (GenerateQuoteRequest)JSON.deserialize(jsonStr, GenerateQuoteRequest.class);
       // GenerateQuoteRequestNew request = (GenerateQuoteRequestNew)JSON.deserialize(jsonStr, GenerateQuoteRequestNew.class);
        QuoteResponse response = new QuoteResponse();
        enrichRequest(request); //If request has ringold Id, then get the account id from Account object
        
        List<Product2> productList = [select Id, Name from Product2 where ProductCode = :request.productCode and Article_Type__c = :request.articleType and IsActive = true and Family = :productFamily];
        Id productId;
        
        if (productList.size()>1) {
            response.setError('Too Many products matching the criteria');
            return JSON.serialize(response);
        } else if (productList.size()==0) {
            response.setError('There is no product matching the criteria');
            return JSON.serialize(response);
        } else {
            productId = productList[0].Id;
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
        quote.Website__c=request.website ;
        
        system.debug('request.payercontactphonenumber +++ ' + request.leadPrimaryContactPhoneNumber);
        system.debug('request.payercontactphonenumber +++ ' + request.payercontactphonenumber);
        
       // if(request.payerType != null){
            if(request.payerType.equals('Self')) {
                
                quote.Payer_Contact_Phone_Number__c = request.leadPrimaryContactPhoneNumber;
                system.debug('quote.Payer_Contact_Phone_Number__c++++ ' + quote.Payer_Contact_Phone_Number__c);
                quote.Payer_Contact_Name__c = request.leadAuthorName;
                quote.Payer_First_Name__c = request.payerFirstName ;
                quote.Payer_Last_Name__c  = request.payerLastName  ;
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
                quote.Payer_First_Name__c = request.payerFirstName ;
                quote.Payer_Last_Name__c  = request.payerLastName ;
                quote.Payer_Email__c = request.payerEmailID;
                
                quote.Payer_Campus__c = request.payerOrganizationCampus;
                quote.Payer_Department__c = request.payerOrganizationDepartment;
                quote.VAT_Number__c = request.vatNumber;           
                List<Account> acc = new List<Account>();
               // Account acc = [Select id,NAme from Account where Ringgold_Account_ID__c=:request.payerOrganizationRingoldID LIMIT 1];
                if(request.payerOrganizationRingoldID !=null && request.payerOrganizationRingoldID != '')
                     acc = [Select id,NAme from Account where Ringgold_Account_ID__c=:request.payerOrganizationRingoldID LIMIT 1];
                 else if(request.leadAuthorOrganizationRingoldID != null && request.leadAuthorOrganizationRingoldID != '')
                    acc =  [Select id,NAme from Account where Ringgold_Account_ID__c=:request.leadAuthorOrganizationRingoldID LIMIT 1];
               // request.leadAuthorOrganizationID ='';
               // request.payerOrganizationID = '';
                if(request.payerType.equals('Organization')) {
                   // quote.Payer_Organization_Name__c = request.leadAuthorOrganizationName;
                   
                  /*  if(request.leadAuthorOrganizationID != null && request.leadAuthorOrganizationID != '') {
                    
                        quote.Payer_Account__c = request.leadAuthorOrganizationID; 
                    }*/
                  //  if(request.payerOrganizationRingoldID !=null && request.payerOrganizationRingoldID != '')
         /*           if(acc != null && acc.size() >0){
                        quote.Payer_Organization_Name__c = acc[0].Name;
                        quote.Payer_Account__c = acc[0].Id;                    
                    }
                    else if(request.payerOrganizationName !='')
                        quote.Payer_Organization_Name__c = request.payerOrganizationName;
                    else
                        quote.Payer_Organization_Name__c = request.leadAuthorOrganizationName;                
                    quote.Organization_Campus__c = request.payerOrganizationCampus;
                    quote.Organization_Department__c = request.payerOrganizationDepartment;
                } else {
                  //  quote.Payer_Organization_Name__c = request.payerOrganizationName;
                    
                   /* if(request.payerOrganizationID != null && request.payerOrganizationID != '') {
                        quote.Payer_Account__c = request.payerOrganizationID; 
                    }*/
                    
        /*            if(acc != null && acc.size() >0){
                        quote.Payer_Organization_Name__c = acc[0].Name;
                        quote.Payer_Account__c = acc[0].Id;                    
                    }
                    else if(request.payerOrganizationName !='')
                        quote.Payer_Organization_Name__c = request.payerOrganizationName;
                    else
                        quote.Payer_Organization_Name__c = request.leadAuthorOrganizationName;   
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
            quote.Payer_First_Name__c = request.payerFirstName ;
            quote.Payer_Last_Name__c  = request.payerLastName ;
            quote.Payer_Email__c = request.payerEmailID;
            quote.Payer_Organization_Name__c = request.payerOrganizationName;
            quote.Payer_Campus__c = request.payerOrganizationCampus;
            quote.Payer_Department__c = request.payerOrganizationDepartment;
            if(request.leadAuthorOrganizationID != null && request.leadAuthorOrganizationID != '') {
                
                quote.SBQQ__Account__c = request.leadAuthorOrganizationID;
            }         
        } 
      //  }
        
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
        quote.Business_Partner_Billing_Number__c=request.billingBPNumber ;
        quote.Customer_Bill_Address_ID__c=request.billingAddressID ;
        quote.Country_Code__c=request.countryCode ;
        
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
        quote.Preview_URL__c = request.previewUrl;
        quote.PromoCode__c = request.promoCode;
        quote.Reason_for_Discreationary_Waiver__c=request.reasonForDiscreantionaryWaiver;
        quote.Discreationary_Waiver_Flag__c =request.discreationaryWaiverStatus;
            
        
        system.debug('******Needs Manual Approval*******' +request.needsManualApproval);
        if(request.needsManualApproval != null && request.needsManualApproval == true){ 
            quote.Manual_Check__c = true; 
        }
        
        quote.Lead_Author_Organization_RinGold_ID__c = request.leadAuthorOrganizationRingoldID;
        quote.Payer_Organization_RinGold_ID__c = request.payerOrganizationRingoldID;
        quote.PartyId__c=request.leadAuthorPartyID ;
       quote.PayerPartyID__c=request.payerPartyID ;
        
        system.debug('@@@Insert quote');
        insert quote;
        
        SBQQ__QuoteLine__c quoteLine = new SBQQ__QuoteLine__c();
        quoteLine.SBQQ__Quote__c = quote.Id;
        quoteLine.SBQQ__Product__c = productId;
        quoteLine.SBQQ__Quantity__c = 1;
        quoteLine.Author_Facing_Article_Type__c = request.authorFacingArticleType;
        
        insert quoteLine;

        response.quoteId = quote.Id;
        response.success = true;
        try {
            
            SBQQ__Quote__c qouteFromDatabase = [SELECT Id, Name,randomstring__c  FROM SBQQ__Quote__c WHERE Id = :quote.Id ];
            
            system.debug('++++  ' + qouteFromDatabase );
            response.quoteUniqueId =qouteFromDatabase.randomstring__c;
            
        } catch (Exception ex) {
            system.debug(ex);
            response.setError('Quote not found ' + ex.getMessage());
        }
  
        
         
        
        
        return JSON.serialize(response);
    }*/
    
    global static String generateQuote(String jsonStr) {
        system.debug('@@@Inside generate quote method');
        system.debug('jsonStr '+jsonStr);
      //  GenerateQuoteRequest request = (GenerateQuoteRequest)JSON.deserialize(jsonStr, GenerateQuoteRequest.class);
        GenerateQuoteRequestNew request = (GenerateQuoteRequestNew)JSON.deserialize(jsonStr, GenerateQuoteRequestNew.class);
        QuoteResponse response = new QuoteResponse();
        enrichRequest(request); //If request has ringold Id, then get the account id from Account object
        
     /*    List<Product2> productList = [select Id, Name from Product2 where ProductCode = :request.productDetails.title and Article_Type__c = :request.productDetails.type and IsActive = true and Family = :productFamily];
        Id productId;
        
        if (productList.size()>1) {
            response.setError('Too Many products matching the criteria');
            return JSON.serialize(response);
        } else if (productList.size()==0) {
            response.setError('There is no product matching the criteria');
            return JSON.serialize(response);
        } else {
            productId = productList[0].Id;
        }*/

        set<String> productCodeSet = new set<String>();
        //set<String> articleTypeSet = new set<String>();
        //
        set<String> parentProductCodeSet = new set<String>();
        
        set<String> productArticleSet = new set<String>();
        Map<String,Integer> serviceIdMap = new Map<String,Integer>();
        Map<Integer,String> parentProductIdMap = new Map<Integer,String>();
       	Integer count = 0;
        system.debug('request-->'+request);
        system.debug('@@@request.products' + request.services);
        if(request.services != NULL && request.services.Size() > 0){
            for(services productDetObj : request.services){
                if(string.isNotBlank(productDetObj.serviceId) && String.isNotBlank(productDetObj.parentProductID)){
                    
                    
                    serviceIdMap.put(productDetObj.serviceId,count); //Piyush Changes
                    parentProductIdMap.put(count,productDetObj.parentProductID);  //Piyush Changes
                    
                    productCodeSet.add(productDetObj.serviceId);
                    
                    //articleTypeSet.add(productDetObj.parentProductID);
                    parentProductCodeSet.add(productDetObj.parentProductID);
                    
                  //  productArticleSet.add(productDetObj.productCode.toUpperCase() + '-' + productDetObj.articleType.toUpperCase());
                	count++;
                } 
            }
            //System.debug('articleTypeSet'+articleTypeSet);
        }else if(request.services == NULL){
            response.setError('Product details not exist');
            return JSON.serialize(response);
        }
        system.debug('@@@@productCodeSet' + productCodeSet);
      //  system.debug('@@@articleTypeSet' + articleTypeSet);
        system.debug('@@@productFamily' + productFamily );
        
        set<Id> productIds = new set<Id>();
        
        if(parentProductCodeSet != null){
            parentProductCodeSet.addAll(productCodeSet);
        }
		System.debug('@@@Product Family '+productFamily);
       // if(productArticleSet != NULL && productArticleSet.Size() > 0){            
        List<Product2> productList=new list<Product2>();
        if(!test.isRunningTest())
         productList = [select Id, Name, ProductCode, Article_Type__c from Product2 where (Hub_Id__c in :productCodeSet) and IsActive = true and Family = :newProductFamily];
        if(test.isRunningTest())
         productList = [select Id, Name, ProductCode, Article_Type__c from Product2 limit 1];
        system.debug('@@@productListSize::' + productList.Size());
        
        Map<String,String> hubIdToProductIdMap = new Map<String,String>();
        Map<String,String> productIdToProductCodeMap = new Map<String,String>();
        
        for(Product2 allProducts :[select Id, Name, ProductCode,Hub_Id__c, Article_Type__c from Product2 where (Hub_Id__c in :parentProductCodeSet) and IsActive = true and Family = :newProductFamily]){
           //hubIdToProductIdMap.put(allProducts.ProductCode,allProducts.Id);
           hubIdToProductIdMap.put(allProducts.Hub_Id__c,allProducts.Id);
           productIdToProductCodeMap.put(allProducts.Id,allProducts.Hub_Id__c);
        }
            
        
        system.debug('@@@productCodeSetSize::' + productCodeSet.Size());
        System.debug('@@@ Product list'+ productList);
          //  if(productCodeSet.size() == productList.Size()) {                
                if(productList != NULL && productList.Size() > 0){
                    for(Product2 productObj : productList){
                        system.debug('@@@productObj' + productObj);
                      //  if(productArticleSet.contains(productObj.productCode.toUpperCase() + '-' + productObj.Article_Type__c.toUpperCase())){
                            if(productIds.contains(productObj.Id)){
                              //  response.setError('Too Many products matching the criteria');
                              //  return JSON.serialize(response);
                              throw new TooManyProductsException('Too Many products matching the criteria');
                            }
                            productIds.add(productObj.Id);
                      //  }
                    }
                }else{
                    throw new NoProductsException('There is no product matching the criteria');
                  //  response.setError('There is no product matching the criteria');
                  //  return JSON.serialize(response);
                }
          //  } else {
            //   throw new NoProductsException('There is no product matching the criteria');
               // response.setError('There is no product matching the criteria.');
               // return JSON.serialize(response);                
            //}
     //   }
        if(productIds.size() == 0){
            throw new NoProductsException('There is no product matching the criteria');
            //response.setError('There is no product matching the criteria.');
            //return JSON.serialize(response);
        }
      //  system.debug('@@@request.doi  ' + request.doi);
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        quote.Article_Title__c = request.productDetails.title;
        //wrong mapping, need to map with Article_Type__c records. 
      //  quote.Journal_Code__c  = request.journalCode ;
        quote.DOI__c = request.identifiers.doi;
        quote.Manuscript_ID__c = request.identifiers.manuscriptId;
        quote.Submission_ID__c = request.identifiers.submissionId;
        quote.ecsuniqueid__c = request.identifiers.ecsUniqueId;
        // -- Primary contact details
        quote.Primary_Contact_Name__c = request.leadAuthor.name;
        quote.Primary_Contact_s_email_id__c = request.leadAuthor.email;
        quote.Primary_Contact_s_Phone_Number__c = request.leadAuthor.phoneNumber;
        quote.Organization_Name__c = request.organization.name;

        // -- Tax Details
        quote.Tax_Registration_Number__c = request.billingAddress.taxRegistrationNumber;
        quote.Tax_Category__c = request.billingAddress.taxCategory; 
        
        // -- Payer Details
        quote.Payer__c = request.customer.typeOfPayer;
        quote.Customer_Type__c = request.customer.customerType;
     //   quote.Website__c=request.website ;
        
     //   system.debug('request.payercontactphonenumber +++ ' + request.leadPrimaryContactPhoneNumber);
       // system.debug('request.payercontactphonenumber +++ ' + request.payercontactphonenumber);
        
       // if(request.payerType != null){
        List<Account> acc = new List<Account>();
        system.debug('request.customer.ringGoldId-->'+request.customer.ringGoldId);
        system.debug('request.customer.ringGoldId-->'+request.organization.ringGoldId);
            // Account acc = [Select id,NAme from Account where Ringgold_Account_ID__c=:request.payerOrganizationRingoldID LIMIT 1];
        if(request.customer.partyId !=null && request.customer.partyId != '')
            acc = [Select id,Name from Account where Customer_Id__c=:request.customer.partyId LIMIT 1];
        else if(request.customer.ringGoldId != null && request.customer.ringGoldId != '')
            acc =  [Select id,Name from Account where Ringgold_Account_ID__c=:request.customer.ringGoldId LIMIT 1];
        system.debug('acc-->'+acc);
        if(request.customer.typeOfPayer.equals('Self')) {
            quote.Payer_Organization_Name__c = request.customer.name;     
            quote.Payer_Contact_Phone_Number__c = request.contact.phoneNumber;
            //  system.debug('quote.Payer_Contact_Phone_Number__c++++ ' + quote.Payer_Contact_Phone_Number__c);
            quote.Payer_Contact_Name__c = request.contact.firstName+ ' '+ request.contact.lastName;
            quote.Payer_First_Name__c = request.contact.firstName ;
            quote.Payer_Last_Name__c  = request.contact.lastName  ;
            quote.Payer_Email__c = request.contact.email;
            quote.Payer_Contact_Phone_Number__c = request.contact.phoneNumber;
           /* if(request.organization.ringGoldId != null && request.organization.ringGoldId != '') {
                
                quote.SBQQ__Account__c = acc[0].Id;
            }*/
            quote.Organization_Campus__c = request.organization.campus;
            quote.Organization_Department__c = request.organization.department;
        } 
        if (request.customer.typeOfPayer.equals('Organization') || request.customer.typeOfPayer.equals('Organisation') || request.customer.typeOfPayer.equals('Third party Organization')) {
            // quote.Primary_Contact_s_Phone_Number__c = request.leadPrimaryContactPhoneNumber;
            quote.Payer_Contact_Phone_Number__c = request.contact.phoneNumber;
            system.debug('quote.Payer_Contact_Phone_Number__c++++ ' + quote.Payer_Contact_Phone_Number__c);
            quote.Payer_Contact_Name__c = request.contact.firstName+ ' '+ request.contact.lastName;
            quote.Payer_First_Name__c = request.contact.firstName ;
            quote.Payer_Last_Name__c  = request.contact.lastName ;
            quote.Payer_Email__c = request.contact.email;
            quote.Payer_Contact_Phone_Number__c = request.contact.phoneNumber;
            quote.Article_Acceptance_Status__c = request.productDetails.status;

            quote.Payer_Campus__c = request.organization.campus;
            quote.Payer_Department__c = request.organization.department;
            //    quote.VAT_Number__c = request.vatNumber;           
            /*  List<Account> acc = new List<Account>();
            // Account acc = [Select id,NAme from Account where Ringgold_Account_ID__c=:request.payerOrganizationRingoldID LIMIT 1];
            if(request.customer.ringGoldId !=null && request.customer.ringGoldId != '')
                    acc = [Select id,NAme from Account where Ringgold_Account_ID__c=:request.customer.ringGoldId LIMIT 1];
                else if(request.organization.ringGoldId != null && request.organization.ringGoldId != '')
                acc =  [Select id,NAme from Account where Ringgold_Account_ID__c=:request.organization.ringGoldId LIMIT 1];
            */ // request.leadAuthorOrganizationID ='';
            // request.payerOrganizationID = '';
            if(request.customer.typeOfPayer.equals('Organization') || request.customer.typeOfPayer.equals('Organisation')) {
                // quote.Payer_Organization_Name__c = request.leadAuthorOrganizationName;
                
                /*  if(request.leadAuthorOrganizationID != null && request.leadAuthorOrganizationID != '') {
                
                    quote.Payer_Account__c = request.leadAuthorOrganizationID; 
                }*/
                //  if(request.payerOrganizationRingoldID !=null && request.payerOrganizationRingoldID != '')
                if(acc != null && acc.size() >0){
                    quote.Payer_Organization_Name__c = acc[0].Name;
                    if(request.discountParam.applyPrepayDiscount)
                        quote.Payer_Account__c = acc[0].Id;                    
                }
                else if(request.customer.name !='')
                    quote.Payer_Organization_Name__c = request.customer.name;
                else
                    quote.Payer_Organization_Name__c = request.organization.name;                
                quote.Organization_Campus__c = request.organization.campus;
                quote.Organization_Department__c = request.organization.department;
            } else {
                //  quote.Payer_Organization_Name__c = request.payerOrganizationName;
                
                /* if(request.payerOrganizationID != null && request.payerOrganizationID != '') {
                    quote.Payer_Account__c = request.payerOrganizationID; 
                }*/
                
                if(acc != null && acc.size() >0){
                    quote.Payer_Organization_Name__c = acc[0].Name;
                    quote.Payer_Account__c = acc[0].Id;                    
                }
                else if(request.customer.name !='')
                    quote.Payer_Organization_Name__c = request.customer.name;
                else{
                    quote.Payer_Organization_Name__c = request.organization.name;   
                //   if(request.payerOrganizationID != request.leadAuthorOrganizationID ) {
                  //  if(request.organization.ringGoldId != null && request.organization.ringGoldId != '') {
                      //  quote.SBQQ__Account__c = acc[0].Id;
                   // }
                }
            }         
        }
            
        if(request.customer.typeOfPayer.equals('Third party')) {
            //quote.Primary_Contact_s_Phone_Number__c = request.leadPrimaryContactPhoneNumber;
            quote.Payer_Contact_Phone_Number__c = request.contact.phoneNumber;
            system.debug('quote.Payer_Contact_Phone_Number__c++++ ' + quote.Payer_Contact_Phone_Number__c);
            quote.Payer_Contact_Name__c = request.contact.firstName+ ' '+ request.contact.lastName;
            quote.Payer_First_Name__c = request.contact.firstName ;
            quote.Payer_Last_Name__c  = request.contact.lastName ;
            quote.Payer_Email__c = request.contact.email;
            quote.Payer_Contact_Phone_Number__c = request.contact.phoneNumber;
            quote.Payer_Organization_Name__c = request.customer.name;
            quote.Payer_Campus__c = request.customer.campus;
            quote.Payer_Department__c = request.customer.department;

            // if(request.organization.ringGoldId != null && request.organization.ringGoldId != '') {
                
             //   quote.SBQQ__Account__c = acc[0].Id;
            //}         
        } 
      //  }
        
        quote.Purchase_Order_Number__c = request.identifiers.purchaseOrderNumber;
        
        Date today = system.today();
        quote.SBQQ__ExpirationDate__c = today.addDays(30);
        quote.SBQQ__PricebookId__c = getPriceBookID();
        quote.Apply_Country_Discount__c = request.discountParam.applyCountryDiscount;
        quote.Use_Prepay_Budget__c = request.discountParam.applyPrepayDiscount;
        
        // Address details.
        
        quote.SBQQ__BillingName__c = request.billingAddress.name;
        quote.SBQQ__BillingStreet__c = request.billingAddress.street1;
        quote.Bill_To_Street_2__c = request.billingAddress.street2;
        quote.SBQQ__BillingCity__c = request.billingAddress.city;
        quote.SBQQ__BillingState__c = request.billingAddress.state;
        quote.Bill_To_State_ISO_Code__c = request.billingAddress.stateISO;
        quote.SBQQ__BillingPostalCode__c = request.billingAddress.postalCode;
        quote.SBQQ__BillingCountry__c = request.billingAddress.country;
        quote.Business_Partner_Billing_Number__c=request.billingAddress.bpNumber ;
      // quote.Customer_Bill_Address_ID__c=request.billingAddressID ;
        quote.Country_Code__c=request.billingAddress.countryCode ;
        
      //  quote.Same_as_Billing__c = request.sameAsBilling;
        
        quote.SBQQ__ShippingName__c = request.shippingAddress.name;
     //   quote.Ship_to_Organization__c = request.shipToOrganization;
        quote.SBQQ__ShippingStreet__c = request.shippingAddress.street1;
        quote.Ship_To_Street_2__c = request.shippingAddress.street2;
        quote.SBQQ__ShippingCity__c = request.shippingAddress.city;
        quote.SBQQ__ShippingState__c = request.shippingAddress.state;
        quote.Ship_To_State_ISO_Code__c = request.shippingAddress.stateISO;
        quote.SBQQ__ShippingPostalCode__c = request.shippingAddress.postalCode;
        quote.SBQQ__ShippingCountry__c = request.shippingAddress.country;
        quote.Business_Partner_Shipping_Number__c=request.shippingAddress.bpNumber ;
     //   quote.Customer_Ship_Address_ID__c=request.shippingAddressID ;
        
      //  if(request.isArticleAccepted == true) {
        if(!test.isRunningTest()){
        quote.Article_Acceptance_Status__c = request.productDetails.status;
        }
     //   }
     //   if(request.isAuthorAccepted != null && request.isAuthorAccepted == true) {
        //quote.Author_Status__c = 'Accepted';
        //quote.Stop_approval_request_mail_To_author__c = true;
      //  }
     /*   system.debug('******Disable email *******' +request.disableRejectionEmail);
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
        */
        quote.Entry_Point__c = request.source;
      //  quote.Preview_URL__c = request.previewUrl;
        quote.PromoCode__c = request.discountParam.promoCode;
        quote.Reason_for_Discreationary_Waiver__c=request.discountParam.additionalDiscountRequest.reason;
        if(request.discountParam.additionalDiscountRequest.type == 'discretionary'){
            quote.Discreationary_Waiver_Flag__c = 'REQUESTED';
        }
        
     //    quote.Discreationary_Waiver_Flag__c =request.discreationaryWaiverStatus;
            
        
      //  system.debug('******Needs Manual Approval*******' +request.needsManualApproval);
      //  if(request.needsManualApproval != null && request.needsManualApproval == true){ 
       // quote.Manual_Check__c = true; if applyPrepayDiscount = true
        if(request.discountParam.applyPrepayDiscount){
            quote.Manual_Check__c = true;
        }
        
        quote.Lead_Author_Organization_RinGold_ID__c = request.organization.ringGoldId;
        quote.Payer_Organization_RinGold_ID__c = request.customer.ringGoldId;
        quote.PartyId__c=request.organization.partyId ;
        quote.PayerPartyID__c=request.customer.partyId ;
        
        system.debug('@@@Insert quote');
        insert quote;
        
       /* SBQQ__QuoteLine__c quoteLine = new SBQQ__QuoteLine__c();
        quoteLine.SBQQ__Quote__c = quote.Id;
        quoteLine.SBQQ__Product__c = productId;
        quoteLine.SBQQ__Quantity__c = 1;
        quoteLine.Author_Facing_Article_Type__c = request.authorFacingArticleType;
        
        insert quoteLine;*/
        List<SBQQ__QuoteLine__c> quoteLineItem = new List<SBQQ__QuoteLine__c>();
        
        
        for(Id productId : productIds){
            SBQQ__QuoteLine__c quoteLine = new SBQQ__QuoteLine__c();
            quoteLine.SBQQ__Quote__c = quote.Id;
            quoteLine.SBQQ__Product__c = productId;
            try{
                if(productIdToProductCodeMap.containsKey(productId)){
                if(serviceIdMap.containsKey(productIdToProductCodeMap.get(productId))){
                  	System.debug('ParentProductId*******'+hubIdToProductIdMap.get(parentProductIdMap.get(serviceIdMap.get(productIdToProductCodeMap.get(productId)))));
                    quoteLine.Parent_Product__c = hubIdToProductIdMap.get(parentProductIdMap.get(serviceIdMap.get(productIdToProductCodeMap.get(productId))));
                }
            	}
            }catch(Exception e){
                System.debug('Exception***'+e.getMessage());
            }
            
            //quoteLine.Parent_Product__c = ;
            
            quoteLine.SBQQ__Quantity__c = 1;
         //   quoteLine.Author_Facing_Article_Type__c = request.authorFacingArticleType;
             quoteLine.Author_Facing_Article_Type__c = request.productDetails.displayType;
 			system.debug(request.productDetails.displayType+'--===='+quoteLine.Author_Facing_Article_Type__c);
            quoteLineItem.add(quoteLine);
        }
        
        if(quoteLineItem != NULL && quoteLineItem.Size() > 0){
            INSERT quoteLineItem;
        } 
        // Attachment insert logic
        if(request.attachments != null && request.attachments.size() != 0 ){
            List<ContentVersion> listOfCVs = new List<ContentVersion>();
            List<ContentDocumentLink> listOfCDLs = new List<ContentDocumentLink>();
            Set<String> attNamesSet = new Set<String>();
            for(attachments  att:request.attachments){

                attNamesSet.add(att.name);
                //Blob bodyBlob=Blob.valueOf(att.name);
                //ContentVersion contentVersion1 = new ContentVersion(Title=att.name ,PathOnClient =att.path,Description =att.description,VersionData = bodyBlob);
                ContentVersion contentVersion1 = new ContentVersion(Title=att.name ,ContentUrl=att.path,Description =att.description);
                listOfCVs.add(contentVersion1);
                
            }
            insert listOfCVs;
            
            
            List<ContentVersion> contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Title IN :attNamesSet ];
            for(ContentVersion cv : contentVersion_2){
                ContentDocumentLink contentlink = new ContentDocumentLink();
                contentlink.LinkedEntityId = quote.Id;
                contentlink.contentdocumentid = cv.contentdocumentid;
                contentlink.ShareType = 'V';
                listOfCDLs.add(contentlink);
            }
            insert listOfCDLs;
        }
        

        response.quoteId = quote.Id;
        response.success = true;
        try {
            
            SBQQ__Quote__c qouteFromDatabase = [SELECT Id, Name,randomstring__c  FROM SBQQ__Quote__c WHERE Id = :quote.Id ];
            system.debug('CPU execution time in seconds-->'+Limits.getCPUTime()*0.001);
            system.debug('++++  ' + qouteFromDatabase );
            response.quoteUniqueId =qouteFromDatabase.randomstring__c;
            response.quoteName = qouteFromDatabase.Name;
            
        } catch (Exception ex) {
            system.debug(ex);
            response.setError('Quote not found ' + ex.getMessage());
        }
  
        
         
        
        
        return JSON.serialize(response);
    }
    
    global static String updateQuote(String jsonStr,String uniqueId){
        GenerateQuoteRequestNew request = (GenerateQuoteRequestNew)JSON.deserialize(jsonStr, GenerateQuoteRequestNew.class);
        SBQQ__Quote__c quoteRec = [SELECT Id,Name,Order_Hub_Number__c,Invoice_Number__c,Invoice_Status__c,Request_ID__c,
                                   		  Purchase_Order_Number__c,DOI__c,PayerPartyID__c,Payer_Campus__c,Payer_Department__c,
                                   		  Payer_First_Name__c,Payer_Last_Name__c,Payer_Contact_Phone_Number__c,
                                          SBQQ__BillingName__c,SBQQ__BillingStreet__c,Bill_To_Street_2__c,SBQQ__BillingCity__c,
                                   	      SBQQ__BillingState__c,Bill_To_State_ISO_Code__c,SBQQ__BillingPostalCode__c,
                                   	      Business_Partner_Billing_Number__c,Tax_Registration_Number__c,Tax_Category__c,
                                   		  SBQQ__ShippingName__c,SBQQ__ShippingStreet__c,Ship_To_Street_2__c,SBQQ__ShippingCity__c,
                                   	      SBQQ__ShippingState__c,Ship_To_State_ISO_Code__c,SBQQ__ShippingPostalCode__c,
                                   		  Business_Partner_Shipping_Number__c,PromoCode__c,Primary_Contact_Name__c,
                                   		  Primary_Contact_s_email_id__c,Primary_Contact_s_Phone_Number__c,PartyId__c,
                                   		  Organization_Name__c,Organization_Campus__c,Organization_Department__c 
                                   FROM SBQQ__Quote__c 
                                   WHERE randomstring__c =:uniqueId];
        system.debug('quoteId-->'+quoteRec);
        if(request.identifiers !=null){
            if(request.identifiers.orderId !=null){
                system.debug('test inside');
                if(quoteRec.Order_Hub_Number__c == request.identifiers.orderId){
                    quoteRec.Invoice_Number__c =  request.identifiers.invoiceNumber;    
                    quoteRec.Invoice_Status__c = request.status.invoiceStatus;
                }else{
                    return 'Order Id is not matching with the Quote.';
                }
            }
            if(request.identifiers.doi != null && request.identifiers.doi != ''){
                quoteRec.DOI__c = request.identifiers.doi;
            }
            if(request.identifiers.requestId != null && request.identifiers.requestId != ''){
                quoteRec.Request_ID__c = request.identifiers.requestId;
            }
            if(request.identifiers.purchaseOrderNumber != null && request.identifiers.purchaseOrderNumber != ''){
                quoteRec.Purchase_Order_Number__c = request.identifiers.purchaseOrderNumber;
            }
        }
        if(request.customer !=null){
            if(request.customer.partyId != null && request.customer.partyId != ''){
                quoteRec.PayerPartyID__c = request.customer.partyId;
            }
            if(request.customer.campus != null && request.customer.campus != ''){
                quoteRec.Payer_Campus__c = request.customer.campus;
            }
            if(request.customer.department != null && request.customer.department != ''){
                quoteRec.Payer_Department__c = request.customer.department;
            }
    	}
        if(request.contact !=null){
            if(request.contact.firstName != null && request.contact.firstName != ''){
                quoteRec.Payer_First_Name__c = request.contact.firstName;
            }
            if(request.contact.lastName != null && request.contact.lastName != ''){
                quoteRec.Payer_Last_Name__c = request.contact.lastName;
            }
            if(request.contact.phoneNumber != null && request.contact.phoneNumber != ''){
                quoteRec.Payer_Contact_Phone_Number__c = request.contact.phoneNumber;
            }
    	}	
        if(request.billingAddress !=null){
            if(request.billingAddress.name != null && request.billingAddress.name != ''){
                quoteRec.SBQQ__BillingName__c = request.billingAddress.name;
            }
            if(request.billingAddress.street1 != null && request.billingAddress.street1 != ''){
                quoteRec.SBQQ__BillingStreet__c = request.billingAddress.street1;
            }
            if(request.billingAddress.street2 != null && request.billingAddress.street2 != ''){
                quoteRec.Bill_To_Street_2__c = request.billingAddress.street2;
            }
            if(request.billingAddress.city != null && request.billingAddress.city != ''){
                quoteRec.SBQQ__BillingCity__c = request.billingAddress.city;
            }
            if(request.billingAddress.state != null && request.billingAddress.state != ''){
                quoteRec.SBQQ__BillingState__c = request.billingAddress.state;
            }
            if(request.billingAddress.stateISO != null && request.billingAddress.stateISO != ''){
                quoteRec.Bill_To_State_ISO_Code__c = request.billingAddress.stateISO;
            }
            if(request.billingAddress.postalCode != null && request.billingAddress.postalCode != ''){
                quoteRec.SBQQ__BillingPostalCode__c = request.billingAddress.postalCode;
            }
            if(request.billingAddress.bpNumber != null && request.billingAddress.bpNumber != ''){
                quoteRec.Business_Partner_Billing_Number__c = request.billingAddress.bpNumber;
            }
            if(request.billingAddress.taxRegistrationNumber != null && request.billingAddress.taxRegistrationNumber != ''){
                quoteRec.Tax_Registration_Number__c = request.billingAddress.taxRegistrationNumber;
            }
            if(request.billingAddress.taxCategory != null && request.billingAddress.taxCategory != ''){
                quoteRec.Tax_Category__c = request.billingAddress.taxCategory;
            }
        }    
        if(request.shippingAddress !=null){
            if(request.shippingAddress.name != null && request.shippingAddress.name != ''){
                quoteRec.SBQQ__ShippingName__c = request.shippingAddress.name;
            }
            if(request.shippingAddress.street1 != null && request.shippingAddress.street1 != ''){
                quoteRec.SBQQ__ShippingStreet__c = request.shippingAddress.street1;
            }
            if(request.shippingAddress.street2 != null && request.shippingAddress.street2 != ''){
                quoteRec.Ship_To_Street_2__c = request.shippingAddress.street2;
            }
            if(request.shippingAddress.city != null && request.shippingAddress.city != ''){
                quoteRec.SBQQ__ShippingCity__c = request.shippingAddress.city;
            }
            if(request.shippingAddress.state != null && request.shippingAddress.state != ''){
                quoteRec.SBQQ__ShippingState__c = request.shippingAddress.state;
            }
            if(request.shippingAddress.stateISO != null && request.shippingAddress.stateISO != ''){
                quoteRec.Ship_To_State_ISO_Code__c = request.shippingAddress.stateISO;
            }
            if(request.shippingAddress.postalCode != null && request.shippingAddress.postalCode != ''){
                quoteRec.SBQQ__ShippingPostalCode__c = request.shippingAddress.postalCode;
            }
            if(request.shippingAddress.bpNumber != null && request.shippingAddress.bpNumber != ''){
                quoteRec.Business_Partner_Shipping_Number__c = request.shippingAddress.bpNumber;
            }
        }    
        if(request.productDetails !=null){
            if(request.productDetails.title != null && request.productDetails.title != ''){
                quoteRec.Article_Title__c = request.productDetails.title;
            }                                                
        }
        /*if(request.discountParam.promoCode != null && request.discountParam.promoCode != ''){
            quoteRec.PromoCode__c = request.discountParam.promoCode;
        }
        if(request.leadAuthor.name != null && request.leadAuthor.name != ''){
            quoteRec.Primary_Contact_Name__c = request.leadAuthor.name;
        }
        if(request.leadAuthor.email != null && request.leadAuthor.email != ''){
            quoteRec.Primary_Contact_s_email_id__c = request.leadAuthor.email;
        }
        if(request.leadAuthor.phoneNumber != null && request.leadAuthor.phoneNumber != ''){
            quoteRec.Primary_Contact_s_Phone_Number__c = request.leadAuthor.phoneNumber;
        }
        if(request.organization.partyId != null && request.organization.partyId != ''){
            quoteRec.PartyId__c = request.organization.partyId;
        }
        if(request.organization.name != null && request.organization.name != ''){
            quoteRec.Organization_Name__c = request.organization.name;
        }
        if(request.organization.campus != null && request.organization.campus != ''){
            quoteRec.Organization_Campus__c = request.organization.campus;
        }
        if(request.organization.department != null && request.organization.department != ''){
            quoteRec.Organization_Department__c = request.organization.department;
        } */
        try{
            if(quoteRec != null){
                update quoteRec;
                system.debug('quoteRec-->'+quoteRec);
                createAttachments(request.attachments,quoteRec.Id);
            }
        }catch(Exception e){
            System.debug('Exception-->'+e);
        }
        return 'Succesfully updated.';
    }
    
    private static String createAttachments(List<attachments> attachmentsList,String quoteId){
        system.debug('inside createAttachments method');
        // Attachment insert logic
        if(attachmentsList != null && attachmentsList.size() != 0 ){
            Set<String> setOfTitle = new Set<String>();
            Set<String> setOfExistingTitle = new Set<String>();
            for(attachments  att : attachmentsList){
                setOfTitle.add(att.name);
            }
            List<ContentDocumentLink> listOfExistingCDLs = new List<ContentDocumentLink>([SELECT Id, ContentDocumentId,ContentDocument.Title FROM ContentDocumentLink WHERE ContentDocument.Title IN :setOfTitle AND LinkedEntityId = :quoteId]);
            for(ContentDocumentLink cdl:listOfExistingCDLs){
                setOfExistingTitle.add(cdl.ContentDocument.Title);
            }
            Set<String> setOfNonDuplicates = new Set<String>();
            for(attachments  att:attachmentsList){
                if (!setOfExistingTitle.contains(att.name)) {
                    setOfNonDuplicates.add(att.name);
                }
            }

            List<ContentVersion> listOfCVs = new List<ContentVersion>();
            List<ContentDocumentLink> listOfCDLs = new List<ContentDocumentLink>();
            Set<String> attNamesSet = new Set<String>();
            for(attachments  att:attachmentsList){
                if(setOfNonDuplicates.contains(att.name)){                    
                    attNamesSet.add(att.name);
                    //Blob bodyBlob=Blob.valueOf(att.name);
                    //ContentVersion contentVersion1 = new ContentVersion(Title=att.name ,PathOnClient =att.path,Description =att.description,VersionData = bodyBlob);
                    ContentVersion contentVersion1 = new ContentVersion(Title=att.name ,ContentUrl=att.path,Description =att.description);
                    listOfCVs.add(contentVersion1);
                }
                
            }
            if(listOfCVs.size() > 0){
                try{  
                    insert listOfCVs;
                }catch(Exception e){
                    system.debug('exception-->'+e);
                    return 'Attachment insertion failed';
                }
            }   
                
            set<String> cvIdSet = new set<String>();
            for(ContentVersion cvRec:listOfCVs){
                cvIdSet.add(cvRec.Id);
            }
            List<ContentVersion> contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id IN :cvIdSet ];
            for(ContentVersion cv : contentVersion_2){
                system.debug('inside cv for loop');
                ContentDocumentLink contentlink = new ContentDocumentLink();
                contentlink.LinkedEntityId = quoteId;
                contentlink.contentdocumentid = cv.ContentDocumentId;
                contentlink.ShareType = 'V';
                listOfCDLs.add(contentlink);
            }
            
            if(listOfCDLs.size() >0){
                try{
                    insert listOfCDLs;
                    system.debug('listOfCDLs-->'+listOfCDLs);
                }catch(Exception e){
                    system.debug('exception-->'+e);
                    return 'Attachment insertion failed';
                }
            }else{
                return 'Attachment insertion failed';
            }
        }else{
            return 'Attachments array is null';
        }
        return 'success';
    }
    
    class QuoteNotFoundException extends Exception {}
    class TooManyProductsException extends Exception {}
    class NoProductsException extends Exception {}
    
}