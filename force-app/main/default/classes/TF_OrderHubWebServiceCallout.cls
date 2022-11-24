public class TF_OrderHubWebServiceCallout { 
    private static String orderHubURI = '/v1/orders';
    private static String createOrderURI = orderHubURI + '/';
    private static String taxCalculationApiStatus;
    private static Integer taxCalculationApiStatusCode;
    
    @InvocableMethod
    public static void sendOrderNotification(List<Id> quoteIds){
        for(Id quoteId : quoteIds) {
            sendOrderNotification(quoteId);
        }
    }
    
    @future (callout=true)
    public static void sendOrderNotification(Id quoteID) {
        QuoteDetailResponse quoteRes = quoteDetails(quoteID);
        system.debug('QuoteDetails::'+quoteRes);
        if(quoteRes.isPrePay != true){
            
            SBQQ__Quote__c quoteObj = [SELECT SBQQ__NetAmount__c,Entry_Point__c  
 
                                       FROM SBQQ__Quote__c WHERE Id = :quoteID limit 1];
            
            Decimal tax = 0;
            Boolean isSuccess = false;
            //send request to SAP for tax calculation
             
                ApiResultDetails taxApiRes = callTaxCalculationApi(quoteID);          
                if(taxApiRes.msg == 'Success'){
                    tax = taxApiRes.tax; 
                    isSuccess = true;
                    
                    System.debug('@@@@@'+taxApiRes);
                }else{
                    system.debug('^^^^^^^^^'+taxApiRes);
                    alarmNotificationTaxFailure(quoteID, taxApiRes);
                }
             
            
            
             //send request to order hub
            OrderHubResultDetails orderHubApiRes;
            if(isSuccess){
               System.debug('@@@@@'+isSuccess);
              orderHubApiRes = callOrderHubApi(quoteID, tax, quoteRes.payerType, quoteRes.billingBPNumber ); 
                 //OrderHubResultDetails orderHubApiRes = callOrderHubApi(quoteID, tax, quoteRes.payerType, quoteRes.billingBPNumber );            
                 // OrderHubResultDetails orderHubApiResforshipping = callOrderHubApi(quoteID, tax, quoteRes.payerType, quoteRes.shippingBPNumber  );            
            
            //update tax amount 
            updateTaxAmount(quoteID, tax);            
            
            if(orderHubApiRes.orderNumber != null && orderHubApiRes.msg == 'Success') {
                updateOrderHubID(quoteID, orderHubApiRes.orderNumber);
            } else { 
                System.debug('Order creation has failed for quoteID::'+quoteID);
                alarmNotificationOrderCreationFailure(quoteID);
            }  
                
                System.debug('orderHubApiRes'+orderHubApiRes);
            }
              
        }
    }

     /**
    * Trigger Tax Calculation API
    **/   
    public static ApiResultDetails callTaxCalculationApi(Id quoteID) {
        Decimal OHTax = 0;        
        ApiResultDetails taxDetails = new ApiResultDetails();       
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        String orderHubCalcTaxApiURI = (String) orgSpecificProps.get('OrderHubCalcTaxApi_URL__c');
        
        String mandatoryCountryCodes = (String) orgSpecificProps.get('Order_Hub_Mandatory_Countries__c');
        List<String> countryCodes = mandatoryCountryCodes.split(',');        
        
        getCreateTaxCalRequest taxCalRequest = getCreateTaxCalRequest(quoteID, countryCodes);
        
        if(taxCalRequest != null) {
            String temp = JSON.serializePretty(taxCalRequest);
            String  body = temp.replace('OH_currency', 'currency');
            Map<String, String> headers = new Map<String,String>();
            System.debug('request on OHCalcTax::' + body);
            headers.put('Content-Type', 'application/json');
            try {
                HttpResponse resTaxCal = null;
                resTaxCal = TF_PlatformExecuter.execute(orderHubCalcTaxApiURI,'POST','idtoken', body, headers, false);
                      system.debug('resTaxCal!!!!!!!!!!!!' + resTaxCal.getStatusCode());
                      system.debug('resTaxCal@@@@@@' + resTaxCal.getStatus());
                taxCalculationApiStatusCode = resTaxCal.getStatusCode();
                taxCalculationApiStatus = resTaxCal.getStatus();
                if(String.valueOf(resTaxCal.getStatusCode()).startsWith('2')){    
                    String taxCalResponseBody = resTaxCal.getBody();
                    System.debug('********' + taxCalResponseBody);
                    TaxCalResponse taxCalResponse = (TaxCalResponse)JSON.deserialize(taxCalResponseBody, TaxCalResponse.class);                                                                                                    
                    if(taxCalResponse.data != null){
                        OHTax = Decimal.valueOf(taxCalResponse.data.items[0].tax);
                        taxDetails.tax = OHTax;
                        taxDetails.msg = 'Success';                        
                    } else {                        
                        taxDetails.tax = 0;
                        taxDetails.msg = 'INCORRECT_DATA';
                        return taxDetails;                        
                    }
                    return taxDetails;                    
                }else if(resTaxCal.getStatusCode() == 404){
                    taxDetails.tax = 0;
                    taxDetails.msg = 'DATA_NOT_FOUND';
                    return taxDetails;
                }else{
                    taxDetails.tax = 0;
                    taxDetails.msg = 'There was an issue getting the details, please try later or contact to administrator';
                    return taxDetails;                    
                }        
            } catch (Exception ex) {
                System.debug('Tax Calculation API Exception::' + ex.getMessage());
                taxDetails.tax = 0;
                taxDetails.msg = 'There was an issue getting the details, please try later or contact to administrator';                
            } 
        }
        return taxDetails;
    }

    /**
    * Trigger OrderHub API
    **/
    public static OrderHubResultDetails callOrderHubApi(Id quoteID, Decimal tax, String payerType, String bpNumber) {
        String orderID = null;        
        OrderHubResultDetails ohDetails = new OrderHubResultDetails();       
        
        TF_OrgSpecificProps__c orgSpecificPropsOH = TF_OrgSpecificProps__c.getOrgDefaults();
        String orderHubApiURI = (String) orgSpecificPropsOH.get('OrderHubApi_URL__c'); 
        //orderHubApiURI = (payerType == 'Organization') ? orderHubApiURI + '?isOrganizationalBp=true' : orderHubApiURI + '?isOrganizationalBp=false';
        
        SBQQ__Quote__c quoteObj = [SELECT Id,Business_Partner_Billing_Number__c,  
 SBQQ__NetAmount__c,Country_Applicable_List__c,Entry_Point__c FROM SBQQ__Quote__c WHERE Id = :quoteID limit 1];
        List<SBQQ__QuoteLine__c> quotelineObjList = new List<SBQQ__QuoteLine__c>();
        quotelineObjList = [SELECT Id, Name, SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c = :quoteID AND (SBQQ__ProductCode__c= 'FT' OR SBQQ__ProductCode__c= 'RT') LIMIT 1];      
        Boolean isFTRTQuote = (quotelineObjList.size() > 0) ? true : false;       
        
        if(isFTRTQuote == false){
            //APC quote
            //orderHubApiURI = ((String.isNotBlank(quoteObj.Business_Partner_Billing_Number__c)) || (quoteObj.SBQQ__NetAmount__c == 0)) ? orderHubApiURI : orderHubApiURI + 'orders-without-bp';                    
          orderHubApiURI = ((String.isNotBlank(quoteObj.Business_Partner_Billing_Number__c)) || (quoteObj.SBQQ__NetAmount__c == 0)) ? orderHubApiURI : orderHubApiURI;
        }        
        //orderHubApiURI = ((payerType == 'Organization')|| (payerType == 'Third party Organization')) || ((quoteObj.SBQQ__NetAmount__c == 0 && quoteObj.Entry_Point__c !='Submission Portal') || (quoteObj.SBQQ__NetAmount__c == 0 && quoteObj.Entry_Point__c =='Submission Portal' && quoteObj.Country_Applicable_List__c =='Sanctioned Country')) ? orderHubApiURI : orderHubApiURI + 'orders-without-bp';
        System.debug('OrderHubApiURI::' + orderHubApiURI);
        Boolean isOrderWithoutBP = ((String.isNotBlank(quoteObj.Business_Partner_Billing_Number__c)) || (quoteObj.SBQQ__NetAmount__c == 0)) ? false : true;
        String mandatoryCountryCodes = (String) orgSpecificPropsOH.get('Order_Hub_Mandatory_Countries__c'); 
        List<String> countryCodes = mandatoryCountryCodes.split(',');        
        CreateOrderRequest requestOH = getCreateOrderRequest(quoteID, tax, countryCodes, isOrderWithoutBP,isFTRTQuote);
        if(requestOH != null) {
            String temp = JSON.serializePretty(requestOH);
            String  body = temp.replace('OH_currency', 'currency');
            Map<String, String> headers = new Map<String,String>();
            System.debug('request on OH::' + body);
            headers.put('Content-Type', 'application/json');
            try {
                HttpResponse res = null;
                res = TF_PlatformExecuter.execute(orderHubApiURI,'POST','idtoken', body, headers, false);
                System.debug('res.getStatusCode ' + res.getStatusCode());
                String responseBody1 = res.getBody();
                System.debug('********' + responseBody1);
                if (res.getStatusCode() == 200 || res.getStatusCode() == 201) {
                    String responseBody = res.getBody();
                    System.debug('********' + responseBody);
                    OrderHubResponse orderHubResponse = (OrderHubResponse)JSON.deserialize(responseBody, OrderHubResponse.class);                                                                                                    
                    orderID = orderHubResponse.data.orderNumber; 
                     system.debug('orderHubResponse::'+orderHubResponse);
                    if(orderID != null){
                        ohDetails.orderNumber = orderID;
                        ohDetails.msg = 'Success';                        
                    } else {                        
                        ohDetails.orderNumber = null;
                        ohDetails.msg = 'INCORRECT_DATA';
                        return ohDetails;                        
                    }
                    return ohDetails;                    
                }else if(res.getStatusCode() == 404){
                    ohDetails.orderNumber = null;
                    ohDetails.msg = 'DATA_NOT_FOUND';
                    return ohDetails;
                }else{
                    ohDetails.orderNumber = null;
                    ohDetails.msg = 'There was an issue getting the details, please try later or contact to administrator';
                    return ohDetails;                    
                }        
            } catch (Exception ex) {
                System.debug('Tax Calculation API Exception::' + ex.getMessage());
                ohDetails.orderNumber = null;
                ohDetails.msg = 'Exception:: please try later or contact to administrator';                
            } 
        }
        
        return ohDetails;
    }
    
    /**
    * Constructe a CreateOrderRequest object from Quote object
    **/
    @TestVisible
    private static CreateOrderRequest getCreateOrderRequest(Id quoteID, Decimal tax, List<String> mandatoryCountryCodes, Boolean isOrderWithoutBP,Boolean isFTRTQuote) {
        CreateOrderRequest orderRequest = null;
        
        try {
            
            SBQQ__Quote__c quoteObj = [SELECT Id, Sales_Organization__c, Journal_Code__c, Tax_Registration_Number__c,Country_Applicable_List__c,Entry_Point__c, Tax_Category__c, SBQQ__NetAmount__c, Use_Prepay_Budget__c, No_MPDL_Process__c, DOI__c, Article_Title__c, 
                                       Payer_Account__c, Payer_Organization_Name__c, Primary_Contact_s_email_id__c,SBQQ__Account__c,Name, SBQQ__BillingName__c, Payer_Email__c, 
                                       SBQQ__BillingCountry__c,Payer__c,Organization_Name__c,SBQQ__BillingStreet__c, Bill_To_Street_2__c, SBQQ__BillingCity__c, SBQQ__BillingState__c,
                                       Bill_To_State_ISO_Code__c, SBQQ__BillingPostalCode__c,Purchase_Order_Number__c, Currency__c,VAT_Number__c,Payer_Contact_Name__c,Customer_Ship_Address_ID__c,Customer_Bill_Address_ID__c,
                                       Business_Partner_Billing_Number__c,Business_Partner_Shipping_Number__c,Payer_First_Name__c ,Payer_Last_Name__c,
                                       (SELECT CurrencyIsoCode,Product_Sub_Type__c,Parent_Product_Code__c , SBQQ__TotalDiscountRate__c, Total_Discounted_Amount__c, Best_Discount_Rule__c,Sales_Organization__c,
                                        SBQQ__ListPrice__c, SBQQ__NetTotal__c, SBQQ__Number__c, SBQQ__Quantity__c,SBQQ__ProductCode__c,Tax__c,Parent_Product_UUID__c  FROM SBQQ__LineItems__r)
                                       FROM SBQQ__Quote__c WHERE Id = :quoteID limit 1];
            
            orderRequest = new CreateOrderRequest();
            
            //if(String.isNotBlank(quoteObj.Journal_Code__c)) {
  
            //Product2 prodObj = [SELECT Id, Name, ProductCode, Sales_Organization__c FROM 
            //                    Product2 WHERE ProductCode = :quoteObj.Journal_Code__c 
            //                   AND Family='Journals-Author Side Charges' AND IsActive= true limit 1];                

            //}
            
            if(quoteObj.Purchase_Order_Number__c  != null && !String.isEmpty(quoteObj.Purchase_Order_Number__c)) {
                orderRequest.externalOrderRef = quoteObj.Purchase_Order_Number__c + '-' + quoteObj.DOI__c;
            } else {
                orderRequest.externalOrderRef = quoteObj.DOI__c;
            }
            orderRequest.externalSystemRefId =  quoteObj.Id ;
            
            
             if(quoteObj.Payer__c == 'Self') {
                if(quoteObj.SBQQ__Account__c != null && !String.isEmpty(quoteObj.SBQQ__Account__c)) {
                    orderRequest.customerId = quoteObj.SBQQ__Account__c;
                } else {
                    orderRequest.customerId = quoteObj.Organization_Name__c;
                }
                
            } else if(quoteObj.Payer__c == 'Organization') {
                if(quoteObj.Payer_Account__c != null && !String.isEmpty(quoteObj.Payer_Account__c)) {
                    orderRequest.customerId = quoteObj.Payer_Account__c ;
                } else {
                    orderRequest.customerId = quoteObj.Payer_Organization_Name__c;
                }
            } else if(quoteObj.Payer__c == 'Third party') {
                if(quoteObj.Payer_Organization_Name__c != null && !String.isEmpty(quoteObj.Payer_Organization_Name__c)) {
                    orderRequest.customerId = quoteObj.Payer_Organization_Name__c;
                } else {
                    orderRequest.customerId = quoteObj.Payer_Email__c;
                }
                
            } else if (quoteObj.Payer__c == 'Third party Organization') {
                if(quoteObj.Payer_Account__c != null && !String.isEmpty(quoteObj.Payer_Account__c)) {
                    orderRequest.customerId = quoteObj.Payer_Account__c ;
                } else {
                    orderRequest.customerId = quoteObj.Payer_Organization_Name__c;
                }
            } 
            
            // As customer Id is require filed in OH make sure it has value
            if(orderRequest.customerId == null || String.isEmpty(orderRequest.customerId)) {
                orderRequest.customerId = quoteObj.Payer_Email__c;
            }
            //added by Siddhant Tyagi for SFSD - 1229
            //if(quoteObj.Invoice_Format__c != null){
            //    orderRequest.invoiceFormat =  quoteObj.Invoice_Format__c;
            //}
            orderRequest.invoiceFormat =  'NORMAL';
            
            orderRequest.buyerId = quoteObj.Payer_Email__c;
            orderRequest.quoteNumber = quoteObj.Name;
            orderRequest.orderType = 'SALES'; //replace "sales order" with SALES 
            //orderRequest.channel = (isOrderWithoutBP == true && isFTRTQuote == false) ? 'ASC' : 'TF-SUBMISSION-PLATFORM';
            orderRequest.channel = 'TF-SUBMISSION-PLATFORM';
            orderRequest.seller = 'TANDF';
            orderRequest.orderStatus = 'OPEN';
           Decimal netAmount= quoteObj.SBQQ__NetAmount__c;
            orderRequest.orderPrice = netAmount.setScale(2) + tax;
           // String TaxConvert = String.valueOf(tax);
             orderRequest.totalTax = tax;
           // orderRequest.bpNumber  = quoteObj.Business_Partner_Billing_Number__c;
            List<OrderItem> orderItemList = new List<OrderItem>();
            if(quoteObj.SBQQ__LineItems__r.Size() > 0){
                for(SBQQ__QuoteLine__c quoteLine : quoteObj.SBQQ__LineItems__r){
                    OrderItem itemObj = new OrderItem();
                    itemObj.OH_currency = quoteLine.CurrencyIsoCode;
                    if(quoteLine.Best_Discount_Rule__c == 'CDL'){
                        itemObj.discount = null;
                    }
                    else{
                        itemObj.discount = quoteLine.SBQQ__TotalDiscountRate__c.setScale(2);
                    }
                    itemObj.discountAmount = quoteLine.Total_Discounted_Amount__c;
                    itemObj.discountCode = quoteLine.Best_Discount_Rule__c;
                    itemObj.discountCurrency = quoteObj.Currency__c;
                    itemObj.taxCode = quoteObj.VAT_Number__c;
                    itemObj.taxAmount = tax; //tax amount from tax calculation API
                    
                    System.debug('isOrderWithoutBP == false##> ' + String.valueOf(isOrderWithoutBP == true));
                    /*
                    if(isOrderWithoutBP == true){
                        System.debug('## Inside itemObj.lineItemType = JOURNAL ##');
                        itemObj.lineItemType = 'JOURNAL';
                    }else{
                        System.debug('## Inside itemObj.lineItemType = TF-JOURNAL ##');
                        itemObj.lineItemType = 'TF-JOURNAL';
                    }
                    */
                    itemObj.lineItemType = 'TF-JOURNAL';
                    itemObj.price = quoteLine.SBQQ__ListPrice__c;
                   // itemObj.sellingPrice = quoteLine.SBQQ__NetTotal__c;
                    itemObj.sellingPrice = (quoteLine.SBQQ__ListPrice__c-quoteLine.Total_Discounted_Amount__c + tax) * 1;
                    //if(String.isNotBlank(quoteObj.Journal_Code__c)) {
                    //    itemObj.productId = quoteObj.Journal_Code__c + '_' + quoteObj.DOI__c;  
                    //} else { 
                        itemObj.productId = quoteLine.Parent_Product_Code__c + '_' + quoteObj.DOI__c; 
                    //}  
                                                            
                    itemObj.orderedQuantity = quoteLine.SBQQ__Quantity__c;
                    itemObj.quantity = quoteLine.SBQQ__Quantity__c;
                    // itemObj.salesOrg=quoteLine.Sales_Organization__c;
                    //System.debug('prodObj.Sales_Organization__c##>' + prodObj.Sales_Organization__c);
                    //System.debug('quoteLine.Sales_Organization__c##>' + quoteLine.Sales_Organization__c);
                    //if(String.isNotBlank(quoteObj.Journal_Code__c)) {
                    //    itemObj.salesOrg = prodObj.Sales_Organization__c;  
                    //}else{
                        itemObj.salesOrg = quoteLine.Sales_Organization__c;
                    //}
                    
                    itemObj.description = quoteObj.Article_Title__c;
                    
                    System.debug('isOrderWithoutBP == false##> ' + String.valueOf(isOrderWithoutBP == true));
                    if(quoteLine.Product_Sub_Type__c == 'acceleratedPublishing3'){
                        itemObj.salesType = 'FAST-TRACK-FEE';
                    } else if(quoteLine.Product_Sub_Type__c == 'acceleratedPublishing5') {
                        itemObj.salesType = 'RAPID-TRACK-FEE';
                    //}else if(isOrderWithoutBP == true){
                    //    System.debug('## Inside itemObj.salesType = \'\' ##');
                    //    itemObj.salesType = '';
                    }else{
                        itemObj.salesType = 'APC-FEE';
                    }                     
                    orderItemList.add(itemObj);
                }    
            } 
            orderRequest.orderedItem = orderItemList;
            String countryISO = retrieveContryDeatils(quoteObj.SBQQ__BillingCountry__c);
            system.debug('*******countryISO'+countryISO);
            AddressDetails addressObj = new AddressDetails();
            //addressObj.addressContactName = quoteObj.Payer_Contact_Name__c;
           // addressObj.addressContactFirstName = getFirstName(quoteObj.Payer_Contact_Name__c); 
            //addressObj.addressContactLastName = getLastName(quoteObj.Payer_Contact_Name__c);            
            addressObj.addressContactEmail = quoteObj.Payer_Email__c;
            addressObj.addressOrganisation = quoteObj.Payer_Organization_Name__c;
            
            addressObj.countryCode = retrieveContryDeatils(quoteObj.SBQQ__BillingCountry__c);
            addressObj.externalCustomerAddressId = quoteObj.Id;
            addressObj.addressCountry = quoteObj.SBQQ__BillingCountry__c;
            //addressObj.addressLine2 = quoteObj.Bill_To_Street_2__c;
            if(quoteObj.SBQQ__NetAmount__c == 0){
                TF_OrgSpecificProps__c hierarchySetting = TF_OrgSpecificProps__c.getOrgDefaults();
                addressObj.businessPartnerNo =hierarchySetting.OrderHub_Dummy_businessPartnerNo__c;
                addressObj.addressContactFirstName = hierarchySetting.OrderHub_Dummy_Payer_Contact_Name__c;
                addressObj.addressContactLastName = hierarchySetting.OrderHub_Dummy_Payer_Contact_Name__c;
                //addressObj.addressCountry = hierarchySetting.OrderHub_Dummy_Country__c;
                addressObj.postalCode = hierarchySetting.OrderHub_Dummy_PostalCode__c; 
                addressObj.addressLine1 = hierarchySetting.OrderHub_Dummy_addressLine1__c;
                addressObj.addressLine2=hierarchySetting.OrderHub_Dummy_addressLine2__c;
                addressObj.addressLocality = hierarchySetting.OrderHub_Dummy_City__c;
                addressObj.addressCountry = hierarchySetting.OrderHub_Dummy_Country__c;
                addressObj.countryCode = hierarchySetting.Order_Dummy_Country_Code__c;
                addressObj.addressContactEmail = null;
                addressObj.addressOrganisation = 'Fuppuf Corp.';
                orderRequest.withholdInvoice = true;
            }else{
                addressObj.businessPartnerNo =quoteObj.Business_Partner_Billing_Number__c;
                addressObj.addressContactFirstName = quoteObj.Payer_First_Name__c; 
                addressObj.addressContactLastName = quoteObj.Payer_Last_Name__c;                
                //addressObj.addressContactFirstName = getFirstName(quoteObj.Payer_First_Name__c); 
                //addressObj.addressContactLastName = getLastName(quoteObj.Payer_Last_Name__c);
                
                addressObj.postalCode = quoteObj.SBQQ__BillingPostalCode__c; 
                addressObj.addressLine1 = quoteObj.SBQQ__BillingStreet__c;
                addressObj.addressLine2 = quoteObj.Bill_To_Street_2__c;
                addressObj.addressLocality = quoteObj.SBQQ__BillingCity__c;
                orderRequest.withholdInvoice = false;
            }

            
            //US,CA,BR
            if(mandatoryCountryCodes.contains(countryISO)) { 
                addressObj.addressRegion = quoteObj.Bill_To_State_ISO_Code__c;
            }else{
               //addressObj.addressRegion = '';
               addressObj.addressRegion = quoteObj.SBQQ__BillingState__c;
            }
                           
            addressObj.taxRegistrationNumber = quoteObj.Tax_Registration_Number__c;
            addressObj.taxCategory = quoteObj.Tax_Category__c;
            //addressObj.billingAddressID =quoteObj.Customer_Bill_Address_ID__c;
           // addressObj.shippingAddressID  =quoteObj.Customer_Ship_Address_ID__c;
            
            
            orderRequest.billingAddress = addressObj;                
        } catch (Exception ex) {
            System.debug('--->' + ex.getMessage());
        }
        
        return orderRequest;
    }
   
    /**
    * Constructe a getCreateTaxCalRequest object from Quote object
    **/
    @TestVisible
    private static getCreateTaxCalRequest getCreateTaxCalRequest(Id quoteID, List<String> mandatoryCountryCodes) {
        getCreateTaxCalRequest taxCalRequest = null;
        
        try {
            
            SBQQ__Quote__c quoteObj = [SELECT Id,Sales_Organization__c,Journal_Code__c,SBQQ__NetAmount__c,Country_Applicable_List__c, Entry_Point__c, Primary_Contact_s_Phone_Number__c,Payer_Department__c,Primary_Contact_Name__c,Product_Code__c,DOI__c,Use_Prepay_Budget__c, 
                                       Article_Title__c, Payer_Account__c, Payer_Organization_Name__c, Primary_Contact_s_email_id__c,SBQQ__Account__c,
                                       Name, SBQQ__BillingName__c, Payer_Email__c, Payer__c,Organization_Name__c,SBQQ__BillingCountry__c,
                                       SBQQ__BillingStreet__c, Ship_To_State_ISO_Code__c, Bill_To_Street_2__c, SBQQ__BillingCity__c, SBQQ__BillingState__c, SBQQ__BillingPostalCode__c,
                                       SBQQ__ShippingName__c,Ship_to_Organization__c,SBQQ__ShippingStreet__c,Ship_To_Street_2__c,SBQQ__ShippingCity__c,SBQQ__ShippingState__c,SBQQ__ShippingPostalCode__c,SBQQ__ShippingCountry__c,
                                       Purchase_Order_Number__c, Currency__c,VAT_Number__c,Payer_Contact_Name__c,Customer_Ship_Address_ID__c,Customer_Bill_Address_ID__c,
                                       Business_Partner_Billing_Number__c,Business_Partner_Shipping_Number__c,Bill_To_State_ISO_Code__c,
                                       (SELECT SBQQ__ProductCode__c,Parent_Product_Code__c,Product_Sub_Type__c ,CurrencyIsoCode, SBQQ__TotalDiscountRate__c, Total_Discounted_Amount__c,Parent_Product_UUID__c , Best_Discount_Rule__c,Sales_Organization__c,
                                        SBQQ__ListPrice__c, SBQQ__NetTotal__c, SBQQ__Number__c, SBQQ__Quantity__c FROM SBQQ__LineItems__r)
                                       FROM SBQQ__Quote__c WHERE Id = :quoteID limit 1];
            system.debug('quoteObj---->'+quoteObj);
            taxCalRequest = new getCreateTaxCalRequest();
            String countryISO = retrieveContryDeatils(quoteObj.SBQQ__BillingCountry__c);
            system.debug('*******TaxCountryISO::'+countryISO);            
            taxCalRequest.productType = 'TF-ARTICLE';
            //Product2 prodObj = [SELECT Id, Name, ProductCode, Sales_Organization__c FROM 
            //                    Product2 WHERE ProductCode = :quoteObj.Journal_Code__c 
            //                    AND Family='Journals-Author Side Charges' AND IsActive= true limit 1]; 

            taxCalRequest.salesOrg = quoteObj.Sales_Organization__c; 
            
            List<TaxOrderItem> orderItemList = new List<TaxOrderItem>();
            if(quoteObj.SBQQ__LineItems__r.Size() > 0){
                for(SBQQ__QuoteLine__c quoteLine : quoteObj.SBQQ__LineItems__r){
                    TaxOrderItem itemObj = new TaxOrderItem();
                    itemObj.price = quoteLine.SBQQ__ListPrice__c;
                    //itemObj.productId = quoteLine.SBQQ__ProductCode__c;
                    
                    System.debug('Is Journal_Code__c Blank##>' + String.isBlank(quoteObj.Journal_Code__c));
                    if(String.isNotBlank(quoteObj.Journal_Code__c)) {
                        System.debug('## INSIDE IF itemObj.productId = quoteObj.Journal_Code__c; ##');
                        itemObj.productId = quoteObj.Journal_Code__c;  
                    }else{
                        System.debug('## INSIDE ELSE itemObj.salesOrg = quoteLine.Sales_Organization__c; ##');
                        taxCalRequest.salesOrg = quoteLine.Sales_Organization__c;
                        //itemObj.productId = quoteLine.SBQQ__ProductCode__c;
                        itemObj.productId = quoteLine.Parent_Product_Code__c;
                    }                     
                    itemObj.quantity = 1;
                    itemObj.discount = quoteLine.SBQQ__TotalDiscountRate__c;
                    //itemObj.salesOrg = quoteLine.Sales_Organization__c;
                    //taxCalRequest.salesOrg = quoteLine.Sales_Organization__c;
                    
                    //start SAL-4653
                    itemObj.lineItemType = 'TF-JOURNAL';
                    if(quoteLine.Product_Sub_Type__c == 'acceleratedPublishing3'){
                        itemObj.salesType = 'FAST-TRACK-FEE';
                    } else if(quoteLine.Product_Sub_Type__c == 'acceleratedPublishing5') {
                        itemObj.salesType = 'RAPID-TRACK-FEE';
                    }else{
                        itemObj.salesType = 'APC-FEE';
                    } 
                    //end SAL-4653
                    orderItemList.add(itemObj);
                }    
            } 
            taxCalRequest.items = orderItemList;                                        
            PersonName BillToPersonName = new PersonName();            
            
            TaxAddressDetails BillToAddressDetails = new TaxAddressDetails();
            BillToAddressDetails.organisation = quoteObj.Payer_Account__c; // pull name
            BillToAddressDetails.department = '';
            BillToAddressDetails.phoneNumber = quoteObj.Primary_Contact_s_Phone_Number__c;
            BillToAddressDetails.phoneExtension = '';
            BillToAddressDetails.faxNumber = '';
            
            //US,CA,BR
            if(mandatoryCountryCodes.contains(countryISO)) { 
                BillToAddressDetails.state = quoteObj.Bill_To_State_ISO_Code__c;
            }else{
                BillToAddressDetails.state = quoteObj.SBQQ__BillingState__c;
            }            
            
            //BillToAddressDetails.state = quoteObj.SBQQ__BillingState__c;
            
            BillToAddressDetails.country = retrieveContryDeatils(quoteObj.SBQQ__BillingCountry__c);
            if(quoteObj.SBQQ__NetAmount__c == 0){
            TF_OrgSpecificProps__c hierarchySetting = TF_OrgSpecificProps__c.getOrgDefaults();
            BillToPersonName.firstName = hierarchySetting.OrderHub_Dummy_Payer_Contact_Name__c;
            BillToPersonName.lastName = hierarchySetting.OrderHub_Dummy_Payer_Contact_Name__c;
            BillToAddressDetails.addressLine1 = hierarchySetting.OrderHub_Dummy_addressLine1__c;
            BillToAddressDetails.addressLine2 = hierarchySetting.OrderHub_Dummy_addressLine2__c;
            BillToAddressDetails.city = hierarchySetting.OrderHub_Dummy_City__c;
            BillToAddressDetails.country = hierarchySetting.Order_Dummy_Country_Code__c;
            
            BillToAddressDetails.postalCode =  hierarchySetting.OrderHub_Dummy_PostalCode__c; 
            
            
            BillToAddressDetails.bpNumber = hierarchySetting.OrderHub_Dummy_businessPartnerNo__c;
            
            }
            else{
            BillToPersonName.firstName = getFirstName(quoteObj.Primary_Contact_Name__c);
            BillToPersonName.lastName = getLastName(quoteObj.Primary_Contact_Name__c);
            BillToAddressDetails.addressLine1 = quoteObj.SBQQ__BillingStreet__c;
            BillToAddressDetails.addressLine2 = quoteObj.Bill_To_Street_2__c;
            BillToAddressDetails.city = quoteObj.SBQQ__BillingCity__c;
            BillToAddressDetails.bpNumber = quoteObj.Business_Partner_Billing_Number__c;    
            BillToAddressDetails.postalCode = quoteObj.SBQQ__BillingPostalCode__c;
            }
            
            
            PersonName ShipToPersonName = new PersonName();            
           
            
            TaxAddressDetails ShipToAddressDetails = new TaxAddressDetails();
            ShipToAddressDetails.organisation = quoteObj.Ship_to_Organization__c;
            ShipToAddressDetails.department = quoteObj.Payer_Department__c;
            ShipToAddressDetails.country = retrieveContryDeatils(quoteObj.SBQQ__ShippingCountry__c);
            ShipToAddressDetails.phoneNumber = quoteObj.Primary_Contact_s_Phone_Number__c;
            ShipToAddressDetails.phoneExtension = '';
            ShipToAddressDetails.faxNumber = '';
            
            
            //US,CA,BR
            if(mandatoryCountryCodes.contains(countryISO)) { 
                ShipToAddressDetails.state = quoteObj.Ship_To_State_ISO_Code__c;
            }else{
                ShipToAddressDetails.state = quoteObj.SBQQ__ShippingState__c;
            } 
            
            //ShipToAddressDetails.state = quoteObj.SBQQ__ShippingState__c;
            
            
           if(quoteObj.SBQQ__NetAmount__c == 0){
            TF_OrgSpecificProps__c hierarchySetting = TF_OrgSpecificProps__c.getOrgDefaults();
            ShipToPersonName.firstName = hierarchySetting.OrderHub_Dummy_Payer_Contact_Name__c;
            ShipToPersonName.lastName =  hierarchySetting.OrderHub_Dummy_Payer_Contact_Name__c;
            ShipToAddressDetails.addressLine1 = hierarchySetting.OrderHub_Dummy_addressLine1__c;
            ShipToAddressDetails.addressLine2 = hierarchySetting.OrderHub_Dummy_addressLine2__c;
            ShipToAddressDetails.city = hierarchySetting.OrderHub_Dummy_City__c;
            ShipToAddressDetails.country = hierarchySetting.Order_Dummy_Country_Code__c;
            
            ShipToAddressDetails.postalCode = hierarchySetting.OrderHub_Dummy_PostalCode__c; 
            
            ShipToAddressDetails.bpNumber = hierarchySetting.OrderHub_Dummy_businessPartnerNo__c;
            }
            else{
            ShipToAddressDetails.addressLine1 = quoteObj.SBQQ__ShippingStreet__c;
            ShipToAddressDetails.addressLine2 = quoteObj.Ship_To_Street_2__c;
            ShipToAddressDetails.city = quoteObj.SBQQ__ShippingCity__c;
            ShipToAddressDetails.bpNumber = quoteObj.Business_Partner_Shipping_Number__c;
            ShipToAddressDetails.postalCode = quoteObj.SBQQ__ShippingPostalCode__c;
            ShipToPersonName.firstName = getFirstName(quoteObj.Primary_Contact_Name__c);
            ShipToPersonName.lastName = getLastName(quoteObj.Primary_Contact_Name__c);
            }
            
            AddressType BillingDetails = new AddressType();
            AddressType ShippingDetails = new AddressType();
            
            BillingDetails.personName = BillToPersonName;
            BillingDetails.address = BillToAddressDetails ;
            
            ShippingDetails.personName = ShipToPersonName ;
            ShippingDetails.address = ShipToAddressDetails ;
            
            AddressGroup addressGroupObj = new AddressGroup(); 
            addressGroupObj.billTo = BillingDetails;
            addressGroupObj.shipTo = ShippingDetails;
            
            MyMetaData metaDataObj = new MyMetaData();
            metaDataObj.OH_currency = quoteObj.Currency__c;
            
            MetaDataCustomer customerObj = new MetaDataCustomer();
            customerObj.customerEmail = quoteObj.Primary_Contact_s_email_id__c;
            metaDataObj.customer = customerObj; 
            metaDataObj.addressGroup = addressGroupObj; 
            system.debug('metaDataObj----->'+metaDataObj);
            taxCalRequest.metaData = metaDataObj;
        } catch (Exception ex) {
            System.debug('--->Tax Calculation API exception::' + ex.getMessage());
            System.debug('--->Tax Calculation API exceptionLine::' + ex.getLineNumber());
        }
        
        return taxCalRequest;
    }       

    /**
    * Get quote details
    **/ 
    public static QuoteDetailResponse quoteDetails(Id quoteID) {
        QuoteDetailResponse response = new QuoteDetailResponse();
        List<SBQQ__Quote__c> quoteLst = new List<SBQQ__Quote__c>();
        quoteLst = [SELECT Id, Name, Use_Prepay_Budget__c, SBQQ__NetAmount__c,Country_Applicable_List__c,Payer__c,Customer_Bill_Address_ID__c,Customer_Ship_Address_ID__c,Business_Partner_Billing_Number__c,Business_Partner_Shipping_Number__c   FROM SBQQ__Quote__c WHERE Id = :quoteID limit 1];
        if (quoteLst.size() > 0) {
            response.quoteId = quoteLst[0].Id;
            response.isPrePay = quoteLst[0].Use_Prepay_Budget__c;
            response.payerType = quoteLst[0].Payer__c;
            response.billingAddressID  = quoteLst[0].Customer_Bill_Address_ID__c;
            response.shippingAddressID  = quoteLst[0].Customer_Ship_Address_ID__c;
            response.billingBPNumber  = quoteLst[0].Business_Partner_Billing_Number__c;
            response.shippingBPNumber  = quoteLst[0].Business_Partner_Shipping_Number__c;
           // response.netAmount=quoteLst[0].SBQQ__NetAmount__c;
            response.msg = 'Success';
            return response;
        }else{
            response.isPrePay = false;
            response.msg = 'Failed'; 
            return response;
        }
    }
        /**
    * Send email notification if Tax creation failures
    **/    
    public static void alarmNotificationTaxFailure(Id quoteID, ApiResultDetails taxApiRes) {
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        String emails = (String) orgSpecificProps.get('EmailAddressFoTaxrAlarmNotification__c');
        List<String> lstEmails = emails.split(',');       
        SBQQ__Quote__c quoteObj = [SELECT Id, Name, SBQQ__Status__c  from SBQQ__Quote__c WHERE Id = :quoteID];
        if(quoteObj != null){
            quoteObj.SBQQ__Status__c = 'Order Failure';
            update quoteObj;
        }
        Contact contact = [SELECT Id FROM Contact LIMIT 1];
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'apc@tandf.co.uk'];       
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>(); 
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
        if ( owea.size() > 0 ) {
            email.setOrgWideEmailAddressId(owea[0].Id); //to set FROM email address
            System.debug('owea ID set ' + owea[0].Id);
        }        
        email.setTargetObjectId(contact.Id);
        email.setTreatTargetObjectAsRecipient(false);   
        email.saveAsActivity = false;
        email.setToAddresses(lstEmails);
        email.setWhatId(quoteObj.Id);
        //Id emailTemplateId = [SELECT id from EmailTemplate where Name = 'Alarm Notifications for Tax Failures'].Id;
        //email.setTemplateId(emailTemplateId);
        email.setSubject('Tax Failure for ' + quoteObj.Name);
        email.setHtmlBody(buildEmailBody(taxApiRes));
        emailList.add(email); 
        system.debug('$$$$$$$$$$$$$$$$$$$$$$$$'+emailList);
        Messaging.SendEmailResult [] r = Messaging.sendEmail(emailList); 
        system.debug('############'+r);
        
    }
    
    public static String buildEmailBody(ApiResultDetails taxApiRes){
        string body = '<B>Status: </B>' + taxCalculationApiStatus + ' <BR/>';
        body += '<B>StatusCode: </B> ' +  taxCalculationApiStatusCode + '<BR/>';
        body += '<B>Msg: </B> ' +  taxApiRes.msg + '<BR/>';
        return body;
    }
    
    /**
    * Send email notification if order creation failures
    **/    
    public static void alarmNotificationOrderCreationFailure(Id quoteID) {
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        String emails = (String) orgSpecificProps.get('EmailAddressForOrderHubAlarmNotification__c');
        List<String> lstEmails = emails.split(',');       
        SBQQ__Quote__c quoteObj = [SELECT Id,SBQQ__Status__c from SBQQ__Quote__c WHERE Id = :quoteID];
        if(quoteObj != null){
            quoteObj.SBQQ__Status__c = 'Order Failure';
            update quoteObj;
        }
        Contact contact = [SELECT Id FROM Contact LIMIT 1];
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'apc@tandf.co.uk'];       
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>(); 
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
        if ( owea.size() > 0 ) {
            email.setOrgWideEmailAddressId(owea[0].Id); //to set FROM email address
            System.debug('owea ID set ' + owea[0].Id);
        }        
        email.setTargetObjectId(contact.Id);
        email.setTreatTargetObjectAsRecipient(false);   
        email.saveAsActivity = false;
        email.setToAddresses(lstEmails);
        email.setWhatId(quoteObj.Id);
        Id emailTemplateId = [SELECT id from EmailTemplate where Name = 'Alarm Notifications for Order Creation Failures'].Id;
        email.setTemplateId(emailTemplateId);
        emailList.add(email); 
        Messaging.SendEmailResult [] r = Messaging.sendEmail(emailList); 
        
    }

    /**
    * Update orderNumber in Salesforce
    **/ 
    @TestVisible
    private static String updateOrderHubID(Id quoteID, String orderNumber){           
        If(orderNumber != ''){
            try{     
                system.debug('orderNumber' + ' ' + orderNumber);                   
                SBQQ__Quote__c quoteObj = [SELECT DOI__c,Order_Hub_Number__c FROM SBQQ__Quote__c WHERE Id = :quoteID limit 1];
                quoteObj.Order_Hub_Number__c = orderNumber;              
                update quoteObj;   
                system.debug('update Success');
                return 'Success';
            } catch(exception e){
                system.debug(e.getmessage() + ' '  + 'update failed');
                Return 'Failed';
            }            
        } else{ 
            if (orderNumber == '' || String.isBlank(orderNumber)){
                return 'Failed';
            }           
        }
        return 'Success';
    }   

    /**
    * Get country ISO code of a country 
    **/   
    @TestVisible
    private Static String retrieveContryDeatils(String countryName) {
        String countryISO = ''; 
        try {
            system.debug('countryName::'+countryName);
            Country__c countryObj;
            If(countryName!=null)
            countryObj = [SELECT Id,Name,Country_2__c,Country_3__c FROM Country__c WHERE Name = :countryName];
             If(countryObj!=null)
            countryISO = countryObj.Country_2__c;
        } catch(Exception ex) {
            system.debug('Country name error::'+ex.getMessage());
        }
        return countryISO;
    }

    /**
    * Update tax amount in Salesforce returned from tax calculation API 
    **/ 
    @TestVisible
    private static String updateTaxAmount(Id quoteID, Decimal tax) {
        try {
            system.debug('@@@ inside updateOrderHubTaxAmount');
            SBQQ__QuoteLine__c quoteLineitem = [SELECT Name, Tax__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c = :quoteID LIMIT 1]; 
            quoteLineitem.Tax__c = tax; 
            update quoteLineitem;
            system.debug('update Success-> Tax Amount::' + tax);
            return 'Success';       
        } catch (Exception ex) {
            system.debug(ex.getmessage() + ' '  + 'update failed');
            return 'Failed';
        }
    }

    /**
    * Get first name from full name
    **/   
    @TestVisible
    private static String getFirstName(String name) {
        String[] nameArr     = name.trim().split(' ');
        return nameArr.size() > 1 ? name.substring(0,name.indexOf(' ')) : name;
    }

    /**
    * Get last name from full name 
    **/ 
  @TestVisible    
    private static String getLastName(String name) {
        String[] nameArr     = name.trim().split(' ');
        return nameArr.size() > 1 ? name.substring(name.indexOf(' ')) : name;   
    }
	
	@future (callout=true)
    public static void postingBundleToOrderHub(Id quoteID) {
        //SFAL 330 
        List<String> quoteIdList = new List<String>();
        quoteIdList.add(quoteId);
        Map<string,String> jsonForOrderHub = TF_LMSOrderJson.createLMSOrderJson(quoteIdList);
        //JSON Body for the Bundle & bundle Line Item..(callOrderHubApi)
        String JsonValue = jsonForOrderHub.get(quoteID);    
        system.debug('JsonValue'+JsonValue);
        OrderHubResultDetails ohDetails = new OrderHubResultDetails();       
        TF_OrgSpecificProps__c orgSpecificPropsOH = TF_OrgSpecificProps__c.getOrgDefaults();
        String orderHubApiURI = (String) orgSpecificPropsOH.get('OrderHubApi_URL__c'); 
        orderHubApiURI = orderHubApiURI.replace('v1','v2');
        
        
        if(JsonValue != null) {
            String body = JSON.serializePretty(JsonValue);
            Map<String, String> headers = new Map<String,String>();
            System.debug('request on OH::' + body);
            headers.put('Content-Type', 'application/json');
            try {
                HttpResponse res = null;
                res = TF_PlatformExecuter.execute(orderHubApiURI,'POST','idtoken', body, headers, false);
                if (res.getStatusCode() == 200 || res.getStatusCode() == 201) {
                    String responseBody = res.getBody();
                    System.debug('********' + responseBody);
                    OrderHubResponse orderHubResponse = (OrderHubResponse)JSON.deserialize(responseBody, OrderHubResponse.class);                                                                                                    
                    String orderID = orderHubResponse.data.orderNumber; 
                    system.debug('orderHubResponse::'+orderHubResponse);
                    if(orderID != null){
                        ohDetails.orderNumber = orderID;
                        ohDetails.msg = 'Success';                        
                    } else {                        
                        ohDetails.orderNumber = null;
                        ohDetails.msg = 'INCORRECT_DATA';
                        //return ohDetails;                        
                    }
                    //return ohDetails;                    
                }else if(res.getStatusCode() == 404){
                    ohDetails.orderNumber = null;
                    ohDetails.msg = 'DATA_NOT_FOUND';
                    //return ohDetails;
                }else{
                    ohDetails.orderNumber = null;
                    ohDetails.msg = 'There was an issue getting the details, please try later or contact to administrator';
                    //return ohDetails;                    
                }        
            } catch (Exception ex) {
                System.debug('Tax Calculation API Exception::' + ex.getMessage());
                ohDetails.orderNumber = null;
                ohDetails.msg = 'Exception:: please try later or contact to administrator';                
            } 
        }
        
        //return ohDetails;
    }
    
    public class QuoteDetailResponse {
        private String quoteId; 
        private Boolean isPrePay;
        private String payerType;
        private String shippingBPNumber ;
        private String billingBPNumber  ;
        private String shippingAddressID  ;
        private String billingAddressID ;
        //private Double netAmount ;
        private String msg;      
    }
    
    class AddressDetails {
        //private String addressContactName;
        private String addressContactFirstName;
        private String addressContactLastName;
        private String addressContactEmail;
        private String addressOrganisation;
        private String addressCountry;
        private String countryCode;
        private String externalCustomerAddressId;
        private String addressLine1;
        private String addressLine2;
        private String addressLocality;
        private String addressRegion;
        private String postalCode;
        private String taxRegistrationNumber;
        private String taxCategory;
        //private Boolean withholdInvoice;
       // private String billingAddressID ;
        //private String shippingAddressID ;
        private String businessPartnerNo;
        
    }
    
    class OrderItem {
        private String OH_currency;
        private Decimal discount;
        private Decimal discountAmount;
        private String discountCode;
        private String discountCurrency;
        private String taxCode;
        private Decimal taxAmount;
        private String lineItemType;
        private Decimal price;
        private Decimal sellingPrice;
        private String productId;
        private Decimal orderedQuantity;
        private Decimal quantity;  
        private String salesOrg;
        private String description;
        private String salesType;
    }
    
    class CreateOrderRequest {
        private String externalOrderRef;
        private String externalSystemRefId;
       // private String description;
        private Boolean withholdInvoice;
        private String customerId;
        private String buyerId;
        private String quoteNumber;
        private string orderType; // 'SALES'
        private String channel; //APC
        private String seller; // TANDF
        private String orderStatus; // OPEN (decommission the status PLACED)
        private String invoiceFormat;
        private Decimal orderPrice;
        private Decimal totalTax;
       // private String bpNumber ;
        //private String shippingBPNumber ;
        private AddressDetails billingAddress;
        private List<OrderItem> orderedItem;
    }
    
    class MetaData {
        private String message;
        private Decimal code; 
    }
    
    class Data {
        private String orderNumber;
    }
    
    class OrderHubResponse {
        private MetaData metadata;
        private Data data;
    }

     public class OrderHubResultDetails {        
        private String orderNumber;
        private String msg;      
    }

    //tax start
    class TaxOrderItem {
        private Decimal price;
        private String productId;
        private Decimal quantity;
        //private String salesOrg;  
        private Decimal discount ;
        private String lineItemType;
        private String salesType;        
    } 
    
    class MyMetaData {
        private String OH_currency;
        private MetaDataCustomer customer;
        private AddressGroup addressGroup;
    }
    
    class getCreateTaxCalRequest {
        private String productType;
        private String salesOrg;  
        private MyMetaData metaData; 
        private List<TaxOrderItem> items;
    }  
    
    
    class MetaDataCustomer {
        private String customerEmail;
    }
    
    class AddressGroup {
        private AddressType billTo;
        private AddressType shipTo;
    }
    
    
    class PersonName {
        private String firstName;
        private String lastName;
    }
    
    class TaxAddressDetails {
        private String Organisation;
        private String department;
        private String addressLine1;
        private String addressLine2;
        private String city;
        private String state;
        private String postalCode;
        private String country;
        private String phoneNumber;
        private String phoneExtension;
        private String faxNumber;
        private String bpNumber  ; 
    }    
    
    class AddressType {
        private PersonName personName;
        private TaxAddressDetails address;
    }
    
    class TaxData {
        private String orderNumber;
        private String productType;
        private ResponseItems[] items;
    }
    
    class ResponseItems {
        private String productId;
        private String offerCode;
        private Integer quantity;
        private String priceCode;
        private String price;
        private String tax;
        private TaxRates[] taxRates;
    }  
    
    class TaxRates {
        
    }
    
    class TaxMetaData {
        private String details;
        private Decimal code; 
    }  
    
    class TaxCalResponse {
        private TaxMetaData metadata;
        private TaxData data;
    }

    public class ApiResultDetails {        
        private Decimal tax;
        private String msg;      
    }
    //tax end        
    class CountryNotFoundException extends Exception {}       
}