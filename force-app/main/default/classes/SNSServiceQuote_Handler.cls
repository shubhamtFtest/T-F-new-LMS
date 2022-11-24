/*Created By: Piyush Jain
 *Description: Used to send SNS message on Quote Updation in SF as part of FSD Project
 *Test Class: SNSServiceFSDTest
**/
public class SNSServiceQuote_Handler  {
    public static TF_AwsRestWrapper  tFAwsRestWrapper = new TF_AwsRestWrapper();
    public static HttpResponse response = new HttpResponse();
    public static SNSServiceQuote_Handler.RequestBody message = new SNSServiceQuote_Handler.RequestBody();
    public static Map<Id,SNSServiceQuote_Handler.RequestBody> messageBodyMap = new Map<Id,SNSServiceQuote_Handler.RequestBody>();
    public static boolean quoteLineFlag = false;
    public static Map<String, List<String>> msgTypeMap = new Map<String, List<String>>();
    public class RequestBody{
        public Header header;
        public Body body;
        public MessageAttribute messageAttribute ;
    } 
    public class Header{
        public String type;
        public DateTime date_time;
        public String product_family;
    }
    public class MessageAttribute{
        public String env;
        public String source;
        public boolean applyPrepayDiscount;
        public String type;
    }
    public class Body{
      //public SBQQ__Quote__c quote; //Quote body should be like getQuote Need to confirm first
      public GenerateQuoteRequestNew quoteData;
    }
    public class GenerateQuoteRequestNew {
        public String quoteNumber;//Shalini
        public String discreationaryWaiverStatus;
        public String invoiceStatus;
        public String csdApprovalStatus;
        public String source;
        public String quoteUniqueId;
        public identifiers identifiers;
        public String status;
        public customer customer;
        public contact contact;
        public billingAddress billingAddress;
        public shippingAddress shippingAddress;
        public discountParam discountParam;
        public List<services> services;
        public List<string> products;
        public leadAuthor leadAuthor;
        public organization organization;
        public List<productDetails> productDetails;
        //public productDetails productDetails;
        public List<attachments> attachments;
        
    }
    public class identifiers {
        public String doi;
        public String manuscriptId;
        public String submissionId;
        public String invoiceNumber;
        public String onboardingRequestId;
        public String purchaseOrderNumber;
        public String ecsUniqueId;
        public String orderId;
        public String requestId;
        public String quoteUniqueId;
    }
    public class status{
        public String invoiceStatus;
    }
    
    public class customer {
        public String partyId;
        public String ringGoldId;
        public String name;
        public String customerType;
        public String typeOfPayer;
        public String campus;
        public String department;
    }
    
    public class contact {
        public String firstName;
        public String lastName;
        public String email;
        public String phoneNumber;
    }
    
    public class billingAddress {
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
     public class shippingAddress {
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
    public class discountParam {
        public String promoCode;
        public boolean applyCountryDiscount;
        public boolean applyPrepayDiscount;
        public additionalDiscountRequest additionalDiscountRequest;
        
    }
    public class additionalDiscountRequest {
        public String percentageDiscount;
        public String type;
        public string reason;
        public priceDiscount priceDiscounts;
        
    }
     public class priceDiscount {
        public Decimal price;
        public string currencyIsoCode;
        
    }
    public class services {
        public String serviceId;
        public String parentProductID;
    }
    
    public class leadAuthor {
        public String name;
        public string email;
        public string phoneNumber;
    }
    
    public class organization {
        public String partyId;
        public String ringGoldId;
        public String name;
        public String campus;
        public String department;
        
    }
    
    public class productDetails {
        public String type;
        public string title;
        public string status;
        public string displayType;
        public string category;
        public string hubid;
        public string parentProductId;
    }
    
    public class attachments {
        public String name;
        public string description;
        public string path;
    } 
    
    public static HttpResponse processRequest(Set<Id> setQuoteIds, Map<Id,SBQQ__Quote__c> oldMapQuote, Map<Id,SBQQ__Quote__c> newMapQuote){
        System.debug('@@@@@Quote old data'+oldMapQuote);
        SNSServiceQuote_Handler.createQuoteData(setQuoteIds,oldMapQuote,newMapQuote);
        //List<SettingInsert.settingInsertWrapper> settingItemInsertList = new List<SettingInsert.settingInsertWrapper>();
        
        for(Id quoteId : setQuoteIds){
            SNSServiceQuote_Handler.RequestBody tempMessageBody = new SNSServiceQuote_Handler.RequestBody();
            tempMessageBody = messageBodyMap.get(quoteId);
            System.debug('@@@@Quote body'+tempMessageBody);
            //tempMessageBody.header.type = eventName;
            //String message = JSON.serialize(tempMessageBody);
            //System.debug('@@@@eventName'+eventName);
             System.debug('@@@@quoteLineFlag '+quoteLineFlag);
             
            if (quoteLineFlag ) {// eventName == 'INSERT' && -Removed by Shalini as we need to handle the update condition as well
                if ( !msgTypeMap.isEmpty() && msgTypeMap.containsKey(quoteId) ) {
                    if ( !msgTypeMap.get(quoteId).isEmpty() ) {
                        for ( String msgType : msgTypeMap.get(quoteId) ) {
                            System.debug('@@@@msgTypeMap.get(quoteId)'+msgTypeMap.get(quoteId));
                            tempMessageBody.header.type = msgType;
                            tempMessageBody.messageAttribute.type = msgType;
                            String message = JSON.serialize(tempMessageBody);
                            map <string,string> MessageAttMap = new map <string,string>();
                             MessageAttMap.put('type',tempMessageBody.messageAttribute.type);
                             MessageAttMap.put('source',tempMessageBody.messageAttribute.source);
                             MessageAttMap.put('env',tempMessageBody.messageAttribute.env);
                             MessageAttMap.put('applyPrepayDiscount',string.valueof(tempMessageBody.messageAttribute.applyPrepayDiscount));
                             System.debug('@@@@messageatt '+MessageAttMap);
                            SNSServiceQuote_Handler.sendRequestToSNS(message,MessageAttMap);
                            
                            
                            System.debug('@@@@newMapQuote.get(quoteId).Is_Create_Quote__c '+newMapQuote.get(quoteId).Is_Create_Quote__c);
                            
                            //Shalini added Is_Create_Quote__c field update logic 
                            if (newMapQuote.get(quoteId).Is_Create_Quote__c) {
                                    try{
                                        List<SBQQ__Quote__c> SBQQQuoteList = new List<SBQQ__Quote__c>();
                                        SBQQQuoteList.add(new SBQQ__Quote__c(Id=quoteId, Is_Create_Quote__c = false));
                                        if ( SBQQQuoteList != Null && !SBQQQuoteList.isEmpty()) {
                                            update SBQQQuoteList;
                                        }
                                        system.debug('@@SBQQQuoteList==> '+SBQQQuoteList);
                                    }
                                    catch(exception ex){
                                        system.debug('******** Exception in SNSServiceQuote Trigger while updating QL : ' +  String.valueOf(' Exception Type :-'+ex.getTypeName()+' ** Message:-'+ex.getMessage()+' ** Line Number:-'+ex.getLineNumber()+' ** Stack Trace :- '+ ex.getStackTraceString()));
                                    }
                                    
                                }
                            //Shalini changes end
                            
                            /*if ( newMapQuote.get(quoteId).Is_Create_Quote__c == true ) {//Shalini- commented this if and added above condition
                                System.debug('@@@@FInalsend'+newMapQuote.get(quoteId).Is_Create_Quote__c);
                                SNSServiceQuote_Handler.sendRequestToSNS(message);
                            }*//* else {
                                SettingInsert.settingInsertWrapper obj = new SettingInsert.settingInsertWrapper();
                                obj.eventType = msgType;
                                obj.jsonBody = message;
                                obj.quoteId = quoteId;
                                settingItemInsertList.add(obj);
                            }*/
                        }
                    }
                }
            }
        }
        
        /*if ( settingItemInsertList != Null ) {
            SettingInsert.insertset(settingItemInsertList);
        }*/
        
        return null;
    }
    
    public static void createQuoteData(Set<Id> setQuoteIds, Map<Id,SBQQ__Quote__c> oldMapQuote, Map<Id,SBQQ__Quote__c> newMapQuote){
        try { 
            for(Id quoteId : setQuoteIds) { 
                //System.debug('@@@@ New value: ' + newMapQuote.get(quoteId) +'. Old value: '+oldMapQuote.get(quoteId)); 
                //System.debug('@@@Status New'+newMapQuote.get(quoteId).Article_Acceptance_Status__c);
                //System.debug('@@@Status old'+oldMapQuote.get(quoteId).Article_Acceptance_Status__c);
            } 
        }
        catch (Exception e) { 
            System.debug('Error: ' + e); 
        } 
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        String env = (String) orgSpecificProps.get('env__c');
        //List<SBQQ__Quote__c> SBQQQuoteList = new List<SBQQ__Quote__c>();
        for(SBQQ__Quote__c quote : [SELECT Id, SBQQ__LastCalculatedOn__c,Name, Business_Partner_Billing_Number__c, Business_Partner_Shipping_Number__c, Customer_Ship_Address_ID__c, 
                                    PayerPartyID__c, Request_ID__c, Reason_for_Discreationary_Waiver__c, Discreationary_Waiver_Flag__c, Website__c, 
                                    Customer_Bill_Address_ID__c, Country_Code__c, SBQQ__ListAmount__c, Total_Discounted_Amount__c, Payer_Contact_Phone_Number__c, 
                                    Primary_Contact_s_Phone_Number__c, Stop_Rejection_Email_to_Author__c, CSD_Approval_Status__c, Stop_Acceptance_Email_to_Author__c, 
                                    Stop_Approval_Request_Email_to_Author__c, Entry_Point__c,Invoice_Number__c, Invoice_Status__c, Disable_PrePay_Manual_Approval_Case__c,
                                    PromoCode__c,ecsuniqueid__c,Manual_Check__c, Payer_Organization_RinGold_ID__c, Lead_Author_Organization_RinGold_ID__c, Total_Discount_Percent__c, 
                                    CurrencyIsoCode, SBQQ__NetAmount__c, Country_Applicable_List__c, Article_Title__c, DOI__c, Manuscript_ID__c, Submission_ID__c, 
                                    Primary_Contact_Name__c,Payer_First_Name__c,Payer_Last_Name__c, Primary_Contact_s_email_id__c, SBQQ__Account__c, Organization_Name__c, 
                                    Payer__c, Payer_Contact_Name__c, Payer_Email__c, Payer_Account__c, Payer_Organization_Name__c,PartyId__c, Payer_Campus__c, 
                                    Payer_Department__c, VAT_Number__c, Tax_Registration_Number__c,Tax_Category__c, Purchase_Order_Number__c, Use_Prepay_Budget__c, 
                                     SBQQ__BillingStreet__c,SBQQ__BillingName__c, SBQQ__BillingCity__c, SBQQ__BillingState__c,Bill_To_State_ISO_Code__c, SBQQ__BillingPostalCode__c, 
                                    SBQQ__BillingCountry__c,Customer_Type__c,  SBQQ__ShippingStreet__c, SBQQ__ShippingCity__c, SBQQ__ShippingState__c, Ship_To_State_ISO_Code__c, 
                                    SBQQ__ShippingPostalCode__c, SBQQ__ShippingCountry__c, SBQQ__Status__c, Same_as_Billing__c, Apply_Country_Discount__c, 
                                    Article_Acceptance_Status__c, Bill_To_Street_2__c, SBQQ__ShippingName__c, Ship_to_Organization__c, Ship_To_Street_2__c, 
                                    Organization_Campus__c, Organization_Department__c, Author_Status__c, randomstring__c,Sales_Deal__c,Is_Create_Quote__c,(SELECT Id, SBQQ__ProductName__c,
                                    Product_Article_Type__c,Discount_Rules_Applied__c, Best_Discount_Rule__c, 
                                    Discount_Display_Name__c, SBQQ__ProductCode__c, Product_Open_Access_Category__c, Author_Facing_Article_Type__c, 
                                    SBQQ__ListPrice__c,SBQQ__ProductFamily__c,SBQQ__NetTotal__c,SBQQ__ListTotal__c,Product_Type__c, SBQQ__Product__c,SBQQ__NetPrice__c,SBQQ__Product__r.Hub_Id__c,Parent_Product__r.Hub_Id__c FROM SBQQ__LineItems__r) FROM SBQQ__Quote__c WHERE Id IN :setQuoteIds])
        {
            SBQQ__Quote__c newQuote = new SBQQ__Quote__c();
            newQuote = newMapQuote.get(quote.Id);
            SBQQ__Quote__c oldQuote = new SBQQ__Quote__c();
            
            if(oldMapQuote != null)
            oldQuote = oldMapQuote.get(quote.Id);
            msgTypeMap.put(quote.Id, new List<String>());
            //List<SBQQ__QuoteLine__c> quoteLineList = new List<SBQQ__QuoteLine__c>();
            //quoteLineList.add(quote.SBQQ__LineItems__r);
            System.debug('@@@@@@Quote'+quote);
            System.debug('@@@@@@SBQQ__LastCalculatedOn__c'+quote.SBQQ__LastCalculatedOn__c);
            SNSServiceQuote_Handler.RequestBody messageBody = new SNSServiceQuote_Handler.RequestBody();
            messageBody.body = new Body();
            messageBody.header = new Header();
            messageBody.messageAttribute = new MessageAttribute();
            messageBody.messageAttribute.env = env;
            messageBody.messageAttribute.source = quote.Entry_Point__c;
            messageBody.messageAttribute.applyPrepayDiscount = quote.Use_Prepay_Budget__c;
            messageBody.body.quoteData = new GenerateQuoteRequestNew();
            //message.header.date_time = System.now();
            
            if(quote.SBQQ__Status__c.containsIgnoreCase('invoice'))
            messageBody.body.quoteData.invoiceStatus = quote.SBQQ__Status__c;
            messageBody.body.quoteData.discreationaryWaiverStatus = quote.Discreationary_Waiver_Flag__c;
            messageBody.body.quoteData.csdApprovalStatus = quote.CSD_Approval_Status__c;
            messageBody.body.quoteData.status = quote.SBQQ__Status__c;
            messageBody.body.quoteData.quoteNumber = quote.Name;//Shalini
            messageBody.body.quoteData.source = quote.Entry_Point__c;
            messageBody.body.quoteData.quoteUniqueId = quote.randomstring__c;
            messageBody.body.quoteData.identifiers = new identifiers();
            messageBody.body.quoteData.identifiers.doi = quote.DOI__c;
            messageBody.body.quoteData.identifiers.ecsUniqueId = quote.ecsuniqueid__c;
            messageBody.body.quoteData.identifiers.submissionId = quote.Submission_ID__c;
            messageBody.body.quoteData.identifiers.manuscriptId = quote.Manuscript_ID__c;
            messageBody.body.quoteData.identifiers.invoiceNumber = quote.Invoice_Number__c; 
            messageBody.body.quoteData.identifiers.purchaseOrderNumber = quote.Purchase_Order_Number__c;
            messageBody.body.quoteData.identifiers.quoteUniqueId = quote.randomstring__c;
            
            System.debug('@@@messageBody'+messageBody);
             
            messageBody.body.quoteData.productDetails = new List<productDetails>();
            for(SBQQ__QuoteLine__c quoteline : quote.SBQQ__LineItems__r){
                quoteLineFlag = true;
                productDetails product= new productDetails();
                product.type=quoteline.Product_Article_Type__c;
                product.title=quote.Article_Title__c ;
                product.status=quote.Article_Acceptance_Status__c;
                System.debug('@@@quoteline.SBQQ__NetPrice__c'+quoteline.SBQQ__NetPrice__c);
                product.displayType=quoteline.Author_Facing_Article_Type__c ;
                product.category=quoteline.Product_Open_Access_Category__c;
                product.hubid=quoteline.SBQQ__Product__r.Hub_Id__c;
                product.parentProductId = quoteline.Parent_Product__r.Hub_Id__c;
                messageBody.body.quoteData.productDetails.add(product);
            }
            //messageBody.body.quoteData.productDetails.additionalDiscountRequest = new TF_QuoteAPIServiceV2.additionalDiscountRequest();
            //messageBody.body.quoteData.productDetails.additionalDiscountRequest.reason = quote.Reason_for_Discreationary_Waiver__c;
            
            //leadAuthor details
            messageBody.body.quoteData.leadAuthor = new leadAuthor();
            messageBody.body.quoteData.leadAuthor.name = quote.Primary_Contact_Name__c;
            messageBody.body.quoteData.leadAuthor.email = quote.Primary_Contact_s_email_id__c;
            messageBody.body.quoteData.leadAuthor.phoneNumber = quote.Primary_Contact_s_Phone_Number__c;
            
            //Organization deatils
            messageBody.body.quoteData.organization = new organization();
            messageBody.body.quoteData.organization.name = quote.Organization_Name__c;
            messageBody.body.quoteData.organization.ringGoldId = quote.Lead_Author_Organization_RinGold_ID__c;
            messageBody.body.quoteData.organization.partyId = quote.PartyId__c;
            messageBody.body.quoteData.organization.campus = quote.Organization_Campus__c;
            messageBody.body.quoteData.organization.department = quote.Organization_Department__c;
            
            // -- Payer Details
            messageBody.body.quoteData.customer = new customer();
            messageBody.body.quoteData.customer.typeOfPayer = quote.Payer__c;
            messageBody.body.quoteData.customer.customerType = quote.Customer_Type__c;
            messageBody.body.quoteData.customer.partyId = quote.PayerPartyID__c;
            messageBody.body.quoteData.customer.campus = quote.Payer_Campus__c;
            messageBody.body.quoteData.customer.department = quote.Payer_Department__c;
            messageBody.body.quoteData.customer.ringGoldId = quote.Payer_Organization_RinGold_ID__c;
            
            //Contact details
            messageBody.body.quoteData.contact = new Contact();
            messageBody.body.quoteData.contact.firstName = quote.Payer_First_Name__c;
            messageBody.body.quoteData.contact.lastName = quote.Payer_Last_Name__c;
            messageBody.body.quoteData.contact.phoneNumber = quote.Payer_Contact_Phone_Number__c;
            messageBody.body.quoteData.contact.email = quote.Payer_Email__c;
            
            // -- Billing Address details
            messageBody.body.quoteData.billingAddress = new BillingAddress();
            messageBody.body.quoteData.billingAddress.name = quote.SBQQ__BillingName__c;
            messageBody.body.quoteData.billingAddress.street1 = quote.SBQQ__BillingStreet__c;
            messageBody.body.quoteData.billingAddress.street2 = quote.Bill_To_Street_2__c;
            messageBody.body.quoteData.billingAddress.city = quote.SBQQ__BillingCity__c;
            messageBody.body.quoteData.billingAddress.state = quote.SBQQ__BillingState__c;
            messageBody.body.quoteData.billingAddress.stateISO = quote.Bill_To_State_ISO_Code__c;
            messageBody.body.quoteData.billingAddress.postalCode = quote.SBQQ__BillingPostalCode__c;
            messageBody.body.quoteData.billingAddress.bpNumber = quote.Business_Partner_Billing_Number__c;
            messageBody.body.quoteData.billingAddress.country = quote.SBQQ__BillingCountry__c;
            messageBody.body.quoteData.billingAddress.countryCode = quote.Country_Code__c;
            
            // -- Tax Details
            messageBody.body.quoteData.billingAddress.taxRegistrationNumber = quote.Tax_Registration_Number__c;
            messageBody.body.quoteData.billingAddress.taxCategory = quote.Tax_Category__c;
            
             // -- Shipping Address details
            messageBody.body.quoteData.shippingAddress = new ShippingAddress();
            messageBody.body.quoteData.shippingAddress.name = quote.SBQQ__ShippingName__c;
            messageBody.body.quoteData.shippingAddress.street1 = quote.SBQQ__ShippingStreet__c;
            messageBody.body.quoteData.shippingAddress.street2 = quote.Ship_To_Street_2__c;
            messageBody.body.quoteData.shippingAddress.city = quote.SBQQ__ShippingCity__c;
            messageBody.body.quoteData.shippingAddress.state = quote.SBQQ__ShippingState__c;
            messageBody.body.quoteData.shippingAddress.stateISO = quote.Ship_To_State_ISO_Code__c;
            messageBody.body.quoteData.shippingAddress.postalCode = quote.SBQQ__ShippingPostalCode__c;
            messageBody.body.quoteData.shippingAddress.bpNumber = quote.Business_Partner_Shipping_Number__c;
            messageBody.body.quoteData.shippingAddress.country = quote.SBQQ__ShippingCountry__c;
            
            //--discount param details
            messageBody.body.quoteData.discountParam = new DiscountParam();
            messageBody.body.quoteData.discountParam.promoCode = quote.PromoCode__c;
            messageBody.body.quoteData.discountParam.applyCountryDiscount = quote.Apply_Country_Discount__c;
            messageBody.body.quoteData.discountParam.applyPrepayDiscount = quote.Use_Prepay_Budget__c;
            //System.debug('@@@NEt amount new'+newQuote.SBQQ__NetAmount__c);
            //System.debug('@@@NEt amount old'+oldQuote.SBQQ__NetAmount__c);
            //messageBody.header.product_family = quote.SBQQ__LineItems__r.SBQQ__ProductFamily__c;
            //if(eventName=='INSERT' && newQuote.Sales_Deal__c != null)
            /*if(eventName=='INSERT'){//Shalini commented this and added below if condition
                System.debug('@@@ Create Quote event');
                /*for(String QuoteId : setQuoteIds){
                    SBQQ__Quote__c QuoteObj = new SBQQ__Quote__c();
                    QuoteObj.id = QuoteId;
                    QuoteObj.Is_Create_Quote__c = false;
                    SBQQQuoteList.add(QuoteObj);
                }*/
                //SBQQQuoteList.add(new SBQQ__Quote__c(Id=quote.id, Is_Create_Quote__c = true));//Shalini removed this and added above logic
                /*messageBody.header.type= 'CREATE_QUOTE,INSERT';
                msgTypeMap.get(quote.Id).add('CREATE_QUOTE,INSERT');
            }*/
            if(newMapQuote.get(quote.id).Is_Create_Quote__c){
                System.debug('@@@ Create Quote event');
                /*for(String QuoteId : setQuoteIds){
                    SBQQ__Quote__c QuoteObj = new SBQQ__Quote__c();
                    QuoteObj.id = QuoteId;
                    QuoteObj.Is_Create_Quote__c = false;
                    SBQQQuoteList.add(QuoteObj);
                }*/
                //SBQQQuoteList.add(new SBQQ__Quote__c(Id=quote.id, Is_Create_Quote__c = true));//Shalini removed this and added above logic
                messageBody.header.type= 'CREATE_QUOTE,INSERT';
                msgTypeMap.get(quote.Id).add('CREATE_QUOTE,INSERT');
            }
            else{
                if ( newQuote.SBQQ__Status__c != oldQuote.SBQQ__Status__c && newQuote.SBQQ__Status__c !='Invoiced') {
                    system.debug('@@newQuote.SBQQ__Status__c '+newQuote.SBQQ__Status__c);
                    system.debug('oldQuote.SBQQ__Status__c!' +oldQuote.SBQQ__Status__c);
                    messageBody.header.type= 'QUOTE_STATUS_UPDATE,UPDATE ';
                    msgTypeMap.get(quote.Id).add('QUOTE_STATUS_UPDATE,UPDATE ');
                }
                   system.debug('@@newQuote.SBQQ__Status__c '+newQuote.Article_Acceptance_Status__c );
                    system.debug('oldQuote.SBQQ__Status__c!' +oldQuote.Article_Acceptance_Status__c);
                if(newQuote.Article_Acceptance_Status__c != oldQuote.Article_Acceptance_Status__c ){
                        //|| newQuote.Author_Status__c != oldQuote.Author_Status__c
                        //|| newQuote.SBQQ__DocumentStatus__c != oldQuote.SBQQ__DocumentStatus__c || newQuote.SBQQ__Status__c != oldQuote.SBQQ__Status__c){
                    system.debug('@@@@@@The status has changed!!!! ');
                    messageBody.header.type= 'ARTICLE_ACCEPTANCE_STATUS,UPDATE,'+ newQuote.Article_Acceptance_Status__c;
                    msgTypeMap.get(quote.Id).add('ARTICLE_ACCEPTANCE_STATUS,UPDATE,'+ newQuote.Article_Acceptance_Status__c);
                }
                if(newQuote.Author_Status__c != oldQuote.Author_Status__c ){
                    system.debug('@@@@@@Customer Acceptance Status Changed!!!! ');
                    messageBody.header.type= 'CUSTOMER_ACCEPTANCE_STATUS,UPDATE,'+ newQuote.Author_Status__c;
					msgTypeMap.get(quote.Id).add('CUSTOMER_ACCEPTANCE_STATUS,UPDATE,'+ newQuote.Author_Status__c);
                }
                if(newQuote.CSD_Approval_Status__c != oldQuote.CSD_Approval_Status__c && newQuote.CSD_Approval_Status__c !='Rejected'){
                    System.debug('@@@@ Payer account changed'); 
                    messageBody.header.type= 'CSD_APPROVAL_STATUS,Accept,'+ newQuote.CSD_Approval_Status__c;
                    msgTypeMap.get(quote.Id).add('CSD_APPROVAL_STATUS,Accept,'+ newQuote.CSD_Approval_Status__c);
                }
                if(newQuote.CSD_Approval_Status__c != oldQuote.CSD_Approval_Status__c && newQuote.CSD_Approval_Status__c =='Rejected'){
                    System.debug('@@@@ Payer account changed'); 
                    messageBody.header.type= 'CSD_APPROVAL_STATUS,Rejected';
                    msgTypeMap.get(quote.Id).add('CSD_APPROVAL_STATUS,Rejected');
                }
                if(newQuote.Use_Prepay_Budget__c != oldQuote.Use_Prepay_Budget__c && newQuote.Use_Prepay_Budget__c == True ){
                    System.debug('@@@ Use Prepay Budget is TRUE');
                    messageBody.header.type= 'PREPAY_QUOTE';
                    msgTypeMap.get(quote.Id).add('PREPAY_QUOTE');
                }
                if(newQuote.Payer_Account__c != newQuote.Payer_Account__c){
                    System.debug('@@@@ Payer account changed'); 
                    messageBody.header.type= 'Payer account Change, UPDATE';
                    msgTypeMap.get(quote.Id).add('Payer account Change, UPDATE');
                }
                if(newQuote.SBQQ__ListAmount__c != oldQuote.SBQQ__ListAmount__c || newQuote.SBQQ__AdditionalDiscountAmount__c != oldQuote.SBQQ__AdditionalDiscountAmount__c
                        || newQuote.SBQQ__CustomerAmount__c != oldQuote.SBQQ__CustomerAmount__c
                        ||newQuote.SBQQ__RegularAmount__c != oldQuote.SBQQ__RegularAmount__c || newQuote.SBQQ__TotalCustomerDiscountAmount__c != oldQuote.SBQQ__TotalCustomerDiscountAmount__c
                       ||  newQuote.SBQQ__PartnerDiscount__c != oldQuote.SBQQ__PartnerDiscount__c 
                        || newQuote.Partner_Discount_Percent__c != oldQuote.Partner_Discount_Percent__c || newQuote.Total_Discount_Percent__c != oldQuote.Total_Discount_Percent__c 
                       || newQuote.CurrencyIsoCode != oldQuote.CurrencyIsoCode){
                    System.debug('@@@@ Currency ,Discount or Amount changed');
                    messageBody.header.type= 'Price, Currency and Discount Change, UPDATE';
                    msgTypeMap.get(quote.Id).add('Price, Currency and Discount Change, UPDATE');
                }
                if(newQuote.SBQQ__NetAmount__c != oldQuote.SBQQ__NetAmount__c || newQuote.Currency__c != oldQuote.Currency__c || newQuote.Total_Discounted_Amount__c != oldQuote.Total_Discounted_Amount__c || newQuote.SBQQ__NetAmount__c != oldQuote.SBQQ__NetAmount__c){
                    System.debug('@@@ RECALCULATE_QUOTE!!');
                    messageBody.header.type= 'UPDATE_QUOTE, UPDATE';
                    msgTypeMap.get(quote.Id).add('UPDATE_QUOTE, UPDATE');
                }
                if(newQuote.SBQQ__BillingCity__c != oldQuote.SBQQ__BillingCity__c || newQuote.SBQQ__BillingCountry__c != oldQuote.SBQQ__BillingCountry__c
                        || newQuote.SBQQ__BillingName__c != oldQuote.SBQQ__BillingName__c || newQuote.SBQQ__BillingPostalCode__c != oldQuote.SBQQ__BillingPostalCode__c 
                        ||newQuote.SBQQ__BillingState__c != oldQuote.SBQQ__BillingState__c || newQuote.Bill_To_State_ISO_Code__c != oldQuote.Bill_To_State_ISO_Code__c 
                        ||newQuote.SBQQ__BillingStreet__c != oldQuote.SBQQ__BillingStreet__c || newQuote.Bill_To_Street_2__c != oldQuote.Bill_To_Street_2__c
                        || newQuote.SBQQ__BillingFrequency__c != oldQuote.SBQQ__BillingFrequency__c || newQuote.Business_Partner_Billing_Number__c != oldQuote.Business_Partner_Billing_Number__c 
                        || newQuote.Customer_Bill_Address_ID__c != oldQuote.Customer_Bill_Address_ID__c || newQuote.Same_as_Billing__c != oldQuote.Same_as_Billing__c
                        || newQuote.Ship_to_Organization__c != oldQuote.Ship_to_Organization__c || newQuote.SBQQ__ShippingPostalCode__c != oldQuote.SBQQ__ShippingPostalCode__c 
                        ||newQuote.SBQQ__ShippingState__c != oldQuote.SBQQ__ShippingState__c || newQuote.Ship_To_State_ISO_Code__c != oldQuote.Ship_To_State_ISO_Code__c
                        ||newQuote.SBQQ__ShippingStreet__c != oldQuote.SBQQ__ShippingStreet__c || newQuote.Ship_To_Street_2__c != oldQuote.Ship_To_Street_2__c){
                            System.debug('@@@ Address Changed');
                            messageBody.header.type= 'Address Change, UPDATE';
                            msgTypeMap.get(quote.Id).add('Address Change, UPDATE');
                        }
                if(newQuote.SBQQ__Status__c != oldQuote.SBQQ__Status__c && newQuote.SBQQ__Status__c =='Invoiced' ){
                    System.debug('@@@ Invoice Status changed!!');
                    messageBody.header.type= 'INVOICE_STATUS_UPDATE, UPDATE';
                    msgTypeMap.get(quote.Id).add('INVOICE_STATUS_UPDATE, UPDATE');
                }
                if(newQuote.Discreationary_Waiver_Flag__c != oldQuote.Discreationary_Waiver_Flag__c && newQuote.Discreationary_Waiver_Flag__c != 'WITHDRAWN'){
                    System.debug('@@@ Discreationary_Waiver_Flag__c Status changed!!');
                    messageBody.header.type= 'DISCREATIONARY_WAIVER_STATUS, UPDATE';
                    msgTypeMap.get(quote.Id).add('DISCREATIONARY_WAIVER_STATUS, UPDATE');
                }
                if(newQuote.SBQQ__NetAmount__c == oldQuote.SBQQ__NetAmount__c){
                    System.debug('@@@ Same amount on quote'+newQuote.SBQQ__NetAmount__c);
                    for(SBQQ__QuoteLine__c quoteLine : quote.SBQQ__LineItems__r){
                        messageBody.header.product_family = quoteLine.SBQQ__ProductFamily__c;
                        System.debug('@@@ quoteline '+quoteLine.SBQQ__NetTotal__c);
                        System.debug('@@@ quoteline '+quoteLine.SBQQ__ListTotal__c);
                        System.debug('@@@ quoteline '+quoteLine.SBQQ__ListTotal__c);
                        //System.debug('@@ old linequoantity'+oldQuoteLineMap.get(quoteLine.Id).SBQQ__Quantity__c);
                        if(quote.SBQQ__LineItems__r.size() == 1 && newQuote.SBQQ__NetAmount__c != quoteLine.SBQQ__NetTotal__c){
                            messageBody.header.type= 'Price, Currency and Discount Change, UPDATE';
                            msgTypeMap.get(quote.Id).add('Price, Currency and Discount Change, UPDATE');
                            System.debug('@@@@quoteline changed!');
                        }
                        else{
                            System.debug('@@@ Update on Quote record');
                        //   messageBody.header.type= 'UPDATE_QUOTE, UPDATE';
                        // msgTypeMap.get(quote.Id).add('UPDATE_QUOTE, UPDATE');
                        }
                    }
                }
                else{
                    messageBody.header.type= 'UPDATE_QUOTE, UPDATE';
                    msgTypeMap.get(quote.Id).add('UPDATE_QUOTE, UPDATE');
                }
            }
            messageBody.header.date_time = System.now();
            System.debug('@@@@Message Body'+messageBody);
            messageBodyMap.put(quote.Id,messageBody);
        }
        
        /*if ( SBQQQuoteList != Null ) {
            update SBQQQuoteList;
        }*///Shalini removed this from here and implemented this after SNS callout logic
    }
    @future(callout=true)
    public static void sendRequestToSNS(String Body,map <string,string> msgAttMap){
        System.debug('@@@ Message Body'+ body);
        
        try{
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            String regionName = (String) orgSpecificProps.get('AWS_Region_Name__c');
            String keyAccessId = (String) orgSpecificProps.get('AWS_Access_Key_Id__c');
            String secretAccessKey = (String) orgSpecificProps.get('AWS_Secret_Access_key__c');
            String hostUrl = (String) orgSpecificProps.get('AWS_SNS_Host_Url__c');
            String topicArn = (String) orgSpecificProps.get('AWS_SNS_TopicArn_Quote__c');
             
            system.debug('topicArn'+topicArn);
            if( String.isNotBlank(regionName) && String.isNotBlank(keyAccessId) && String.isNotBlank(secretAccessKey) && String.isNotBlank(hostUrl) && String.isNotBlank(topicArn) && String.isNotBlank(body)){
                response = tFAwsRestWrapper.postToSNSFsd(body,msgAttMap, 'application/json', regionName, keyAccessId, secretAccessKey, hostUrl, topicArn);
                // response = tFAwsRestWrapper.postToSNS(body, 'application/json', regionName, keyAccessId, secretAccessKey, hostUrl, topicArn);
                System.debug('response:'+response);
                //finalResponse = response;
            }
            else {
                new SFDCCustomException('One or more org specific property for AWS is blank');
            }
        } catch(Exception e){
            System.debug('Error in processing method postNotificationToSNS, Error Message:'+e.getMessage());
        }
        
        response = null;
    }
}