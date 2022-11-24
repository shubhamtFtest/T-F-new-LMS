/***************************************************************************
* Created by: Piyush Jain, 2019.06.12
* Tested By:
* Description: Order API Call class which is called by the Order hub whenever an Order is created or updated.
* NOTE: Although bulkified in most places this class is designed as per Order hub and Order Item is created with ISBN for product
* Extensive testing is needed if the code is to be completely bulkified in future.
* **************************************************************************/

@RestResource(urlMapping='/OrderAPI/*')
global class OrderAPI {
    
    public class OrderException extends Exception {}
    
    // ----- Order hub mapping with Request object definition ------
    global class OrderRequest {
        public String id; 
        public String orderType;
        public String channel;
        public String externalOrderRef;
        public String externalSystemRefId;
        public String notes;
        public String quoteNumber;
        public String orderNumber;
        public String confirmationNumber;
        public String customerId;
        public String buyerId;    
        public Decimal discount;
        public String discountCode;
        public Decimal discountCurrency;
        public Decimal discountAmount;
        public Date orderDate;
        public Double orderPrice;
        public String orderStatus;
        public List<Invoice> invoices;
        public String seller;
        public BillingAddresses billingAddress;
        public ShippingAddress shippingAddress;
        public List<OrderedItems> orderedItem;
        public List<Fulfillment> fulfillments;
        public String description;
        public String docDate;
        public String release;
        public String webId;
        public String shipCustId;
        public String orderSource;
        public String rateOfExchange;
        public String subTotalPrice;
        public String totalTax;
        public String originalOrderRef;
        
        public void validate() {
            if (string.isBlank(id)) {
                throw new OrderException('Id cannot be empty');
            }
        }
    }
    global class Invoice {
        public List<invoiceLineItem> invoiceLineItems; 
        public String invoicePaymentPastDue;
        public String id;
        public String externalInvoiceRef;
        public String broker;
        public String freightCharge;
        public String freightTax;
        public String currencyy;
        public string paymentStatus;
        public string paymentDueDate;
        public string paymentTerm;
        public string paymentUrl;
        public string salesOrg;
        public string readyForDownload;
        public List<payment> payments;
        
    }
    global class invoiceLineItem {    
        public String orderItemId;
        public Integer quantity;
        public String productId;       
    }
    global class ShippingAddress {
        public String id;
        public String addressLine1;
        public String addressLine2;
        public String addressLine3;
        public String addressCountry;
        public String addressLocality;
        public String addressRegion;
        public String addressContactName;
        public String addressContactEmail;
        public String addressOrganisation;
        public String postalCode;
        public String streetAddress;
        public String businessPartnerNo;
        public String countryCode;
        public String telephoneNo;
        public String externalCustomerAddressId;
        public String addressType;
        public String houseNumber;
        public String taxRegistrationNumber;
        public String taxCategory;
        public String addressContactFirstName;
        public String addressContactLastName;
        
        
    }
    
    global class BillingAddresses {
        public String id;
        public String addressId;
        public String addressLine1;
        public String addressLine2;
        public String addressLine3;
        public String addressCountry;
        public String addressLocality;
        public String addressRegion;
        public String addressContactName;
        public String addressContactEmail;
        public String addressOrganisation;
        public String postalCode;
        public String streetAddress;
        public String businessPartnerNo;
        public String countryCode;
        public String telephoneNo;
        public String externalCustomerAddressId;
        public string addressType;
        public string houseNumber;
        public string taxRegistrationNumber;
        public string taxCategory;
        public string addressContactFirstName;
        public string addressContactLastName;
        
    }
    
    global class OrderedItems {
        public String id;
        public String productId;
        public Double price; 
        public Decimal sellingPrice;
        public String currencyy;
        public String sellingCurrency;
        public Decimal quantity;
        public Integer orderedQuantity;
        public String lineItemType;
        public Decimal discount;
        public String discountCode;
        public String discountCurrency;
        public String discountAmount;
        public String taxCode;
        public double taxAmount;
        public String description;
        public string status;
        public string salesOrg;
        public string altProductId; 
        
    }
    
    global class Fulfillment {
        public List<FulfillmentLineItem> fulfillmentLineItems;
        public String id;
        public String name;
        public String description;
        public String licenseType;
        public String termStartDate;
        public String termEndDate;
        public List<String> grantType;
        public String bundle;
        public String printOnDemand;
        public String catalogueNumber;
        public String shipmentStatus;
        public String status;
        
    }
    global class FulfillmentLineItem{
        public String orderItemId;
        public String productId;
        public String fulfillmentStatus;
        public String fulfillmentQuantity;
    }
    
    global class Payment {}
    
    //----Re Execute OrderApi by batch class to create order which has error logs with json body.-----
    public static void  reOrderApiResponse(List<Setting_Item__c> scope){
        List<Setting_Item__c> lstTobeDeleteSucceedOrder = new List<Setting_Item__c>();
        for(Setting_Item__c settingItemObj : scope){
            String response ;
            String jsonBody = settingItemObj.Long_Text_1__c;
            if(jsonBody != null){
                response = salesforceOrderSync(jsonBody);       
                if(response.contains('true')){
                    lstTobeDeleteSucceedOrder.add(settingItemObj);
                }            
            }
        }
        
        if(!lstTobeDeleteSucceedOrder.isEmpty()){
            try{
                delete lstTobeDeleteSucceedOrder;
            }catch(Exception e){
                System.debug('Error===>'+ e.getMessage());
            }  
        }        
    }
    
    // ----- Salesforce Response in case of Error to Order hub ------
    global class OrderResponse {
        public Boolean success;
        public String errorMessage;
        
        public void setError(String errorMessage) {
            this.success = false;
            this.errorMessage = errorMessage;
        }
    }
    // ----- Authentication check in salesforce and response goes to order hub ------
    @HttpGet
    global static String orderSyncTest(){
        return 'Authentication Successful';
    }
    // ----- Call Post method for get the JSON ------
    @HttpPost
    global static void orderSync() {
        
        String result               = '';
        String command              = getCommand(RestContext.request.requestURI);
        String operation            = operationLookup('POST', command);
        String jsonStr              = RestContext.request.requestBody != null ? RestContext.request.requestBody.toString() : null;
        
        System.debug('command =====>' + command);
        System.debug('operation =====>' + operation);
        System.debug('jsonStr =====>' + jsonStr);
        if(jsonStr!=null){
            
        } else{
            RestContext.response.statusCode = 400;
            throw new OrderException('Status: '+RestContext.response.statusCode+' Json' );
        }
        if (operation == 'salesforceOrderSync') {
            result = salesforceOrderSync(jsonStr);
        } else {
            result = 'Invalid Resource';
        }
        if (result != NULL)
        {
            RestContext.response.responseBody = Blob.valueOf(result);
            RestContext.response.addHeader('Content-Type', 'application/json');
        }
    }
    
    // ----- Assign the values from Order hub to Salesforce ------
    private static String salesforceOrderSync ( String jsonString ) {
        jsonString = jsonString.replace('"currency"', '"currencyy"');
        system.debug('jsonString'+jsonString);
        OrderRequest request;
        OrderResponse response = new OrderResponse();
        String orderHubId;
        Id accountId;
        Id contactId;
        Id quoteNumber;
        Id existingOrderId;
        List<SBQQ__Quote__c> quoteNumberList = new List<SBQQ__Quote__c>();
        if(jsonString!=null){
            try {
                system.debug('=====>>>>'+jsonString); 
                
                request = (OrderRequest)JSON.deserialize(jsonString, OrderRequest.class);
                if(request!=null)
                    request.validate();  
                
                List<OrderApiSetting__c> mcs = OrderApiSetting__c.getall().values();
                String PricebookID = mcs[0].PrickeBookId__c;
                //String PricebookEntryOrder =[SELECT PrickeBookId__c FROM OrderApiSetting__c WHERE Name = 'Single Setting Record' LIMIT 1]
                if(request!=null){
                    //Doing this here to fetch the quote recordTypeId for APC flow if recordType of quote doesn't match then retrurning 200
                    Id quoteOARecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('T&F - OA Journal Quote').getRecordTypeId();
                    Id quoteDSRecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Automated eBook Direct Sales Orders').getRecordTypeId();
                    Id BPCquoteRecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('T&F - BPC Quote Type').getRecordTypeId();
                    String quoteDoi;
                    
                    if(request.quoteNumber != null){
                        quoteNumberList = [SELECT Id, Purchase_Order_Number__c, SBQQ__Notes__c, OwnerId,name,DOI__c,RecordTypeID FROM SBQQ__Quote__c where name = :request.quoteNumber Limit 1];
                        if(!quoteNumberList.isEmpty() && quoteNumberList != NULL){
                            quoteNumber = quoteNumberList.get(0).id;
                            system.debug('quoteNumberList '+quoteNumberList);
                            if(String.isNotBlank(quoteNumberList.get(0).RecordTypeID)){
                                if(quoteNumberList.get(0).RecordTypeID == quoteDSRecordTypeId){
                                    system.debug('quoteNumberList.get(0).RecordTypeID '+quoteNumberList.get(0).RecordTypeID);
                                }
                                else if(quoteNumberList.get(0).RecordTypeID == quoteOARecordTypeId )
                                {
                                    //Accepting APC quotes here with ASC channel
                                    system.debug('quoteNumberList.get(0).RecordTypeID '+quoteNumberList.get(0).RecordTypeID);
                                    PricebookID = mcs[0].PrickeBookId_ASC_channel__c;
                                    quoteDoi = quoteNumberList.get(0).DOI__c;
                                    //Call this class to receive APC inbound order
                                    return OrderAPI_AscChannel_ApcFlow.salesforceOrderSyncAscChannel(request, jsonString, PricebookID, quoteNumberList.get(0));
                                }
                                else if(quoteNumberList.get(0).RecordTypeID == BPCquoteRecordTypeId )
                                {
                                    //Accepting BPC quotes here with OA_EBK_CHARGES channel
                                    system.debug('quoteNumberList.get(0).RecordTypeID '+quoteNumberList.get(0).RecordTypeID);
                                    PricebookID = mcs[0].PrickeBookId_BPC_Flow__c;
                                    //Call this class to receive BPC inbound order
                                    return OrderAPI_OaEbkChargesChannel_BpcFlow.salesforceOrderSyncOaEbkChargesChannel(request, jsonString, PricebookID, quoteNumberList.get(0));
                                }else{
                                    RestContext.response.statusCode = 200;
                                    response.setError('Order hasn\'t been synced');
                                    response.success = true;
                                    return JSON.serialize(response);
                                }
                            }else{
                                RestContext.response.statusCode = 200;
                                response.setError('Order hasn\'t been synced');
                                response.success = true;
                                return JSON.serialize(response);
                            }
                        }
                    }else{
                        RestContext.response.statusCode = 200;
                        response.setError('Order hasn\'t been synced');
                        response.success = true;
                        return JSON.serialize(response);
                    } 
                    
                    //Fetching channel supported by Salesforce else throwing exception
                    List<Setting_Item__c> orderChannelList = new List<Setting_Item__c>([select id, Setting__c, Text_1__c, Checkbox_3__c from Setting_Item__c  where Setting__r.Name  = 'Order Detail Page Mapping']);   
                    system.debug('orderChannelList '+orderChannelList);
                    if(String.isNotBlank(request.channel)){
                        system.debug('request.channel '+request.channel);
                        if(!orderChannelList.isEmpty()){
                            List<String> channel = new List<String>();
                            for(integer i=0; i<orderChannelList.size(); i++){
                                if(!orderChannelList[i].Checkbox_3__c) channel.add(orderChannelList[i].Text_1__c);
                            }
                            if(!channel.toString().containsIgnoreCase(request.channel)){
                                RestContext.response.statusCode = 200;
                                response.setError('Order hasn\'t been synced');
                                response.success = true;
                                return JSON.serialize(response);
                            }
                        }
                    }else{
                        RestContext.response.statusCode = 400;
                        throw new OrderException('Status: '+RestContext.response.statusCode+' Order channel missing.');
                    }
                    
                    try {
                        accountId = [select ID,createddate from account where customer_id__c =: request.customerId Limit 1].Id;
                        system.debug('accountId '+accountId);
                    } catch (Exception ex) {
                        RestContext.response.statusCode = 400;
                        throw new OrderException('Status: '+RestContext.response.statusCode+' Customer does not exist in Salesforce.');
                    }
                    
                    if ( accountId == NULL )
                    {
                        RestContext.response.statusCode = 400;
                        throw new OrderException('Status: '+RestContext.response.statusCode+' Customer does not exist in Salesforce.');
                    }
                    
                    String conEmail = '';
                    /*if ( String.isNotBlank(request.channel) && 'GOBI'.equalsIgnoreCase(request.channel) && String.isNotBlank(request.shippingAddress.addressContactEmail) ) {
                        conEmail = request.shippingAddress.addressContactEmail;
                    } else if ( String.isNotBlank(request.channel) && 'UBX'.equalsIgnoreCase(request.channel) &&  String.isNotBlank(request.billingAddress.addressContactEmail) ) {
                        conEmail = request.billingAddress.addressContactEmail;
                    }*/   
                    if (request.shippingAddress != null && String.isNotBlank(request.shippingAddress.addressContactEmail) ) {
                        conEmail = request.shippingAddress.addressContactEmail;
                    } else if (request.billingAddress != null && String.isNotBlank(request.billingAddress.addressContactEmail) ) {
                        conEmail = request.billingAddress.addressContactEmail;
                    }
                    
                    try {
                        system.debug('conEmail '+conEmail);
                        contactId = [SELECT Id, createddate FROM Contact WHERE email =: conEmail Limit 1].Id;
                    } catch (Exception ex) {}                   
                    /*try {
                        //quoteNumber = [SELECT Id, OwnerId,name FROM SBQQ__Quote__c where name = :request.quoteNumber].Id;
                        quoteNumberList = [SELECT Id, Purchase_Order_Number__c, SBQQ__Notes__c, OwnerId,name FROM SBQQ__Quote__c where name = :request.quoteNumber Limit 1];
                        if(!quoteNumberList.isEmpty() && quoteNumberList != NULL){
                            quoteNumber = quoteNumberList.get(0).id;
                            quoteNumberList.get(0).Purchase_Order_Number__c = request.externalOrderRef;
                            quoteNumberList.get(0).SBQQ__Notes__c = request.notes;
                            //Quote is already present, no need to upsert this
                            //upsert quoteNumberList;
                        }
                    } catch (Exception ex) {}*/
                    Id orderRecordId;
                    Order orderObj = new Order();
                    String currencyCode = 'USD'; //Set currency as per default in Org
                    //Set currency that get from orderHub to records
                    if ( !request.orderedItem.isEmpty() && String.isNotBlank(request.orderedItem[0].currencyy) )
                    {
                        system.debug('Test'+currencyCode);
                        currencyCode = request.orderedItem[0].currencyy;
                        
                    }
                    
                    system.debug('currencyCode'+currencyCode);
                    orderObj.currencyISOcode = currencyCode;  
                    //Fetch product from ISBN that we get from OrderHub
                    Set<String> setOfProductISBN = new Set<String>();
                    Set<String> setOfOrderItemIds = new Set<String>();
                    Map<String,String> oliOldmapToProductHub =new Map<String,String>(); //map to check exisitng oli's from Order Hub
                    Map<String,String> oliOldISBNmapToProductHub =new Map<String,String>();
					
                    for(OrderedItems obj : request.orderedItem){
                        setOfProductISBN.add(obj.productId);
                        setOfOrderItemIds.add( obj.id );
                        oliOldmapToProductHub.put( obj.id, obj.productId );
						oliOldISBNmapToProductHub.put(obj.productId, obj.id);
                    }
                    System.debug('setOfProductISBN =====>' + setOfProductISBN);
                    System.debug('setOfOrderItemIds =====>' + setOfOrderItemIds);
					System.debug('oliOldISBNmapToProductHub =====>' + oliOldISBNmapToProductHub);
                    //For OrderItemHub ID to OrderITem salesforce records map
                    Map<String, OrderItem> oliHubIdToOLIMap = new Map<String, OrderItem>();
					Map<String, OrderItem> oliIsbnToOLIMap = new Map<String, OrderItem>();
                    Map<String,String> oliOldmapToProduct =new Map<String,String>();
                    Set<String> setOfOliOldIsbn = new Set<String>();
                    
                    //Id existingOrderId = [SELECT id, Order_Hub_Id__c, OpportunityId FROM Order WHERE Order_Hub_Id__c =:request.id OR OpportunityId =:request.opportunityId LIMIT 1].id;
                    List<Order> existingOrderList = new List<Order>([SELECT id, Order_Hub_Id__c, OpportunityId FROM Order WHERE Order_Hub_Id__c =:request.id OR OpportunityId =:request.externalSystemRefId LIMIT 1]);
                    if(!existingOrderList.isEmpty()) existingOrderId = existingOrderList.get(0).id;
                    system.debug('existingOrderId '+existingOrderId);
                    
                    if ( !setOfOrderItemIds.isEmpty() ) {
                        try {
                            for ( OrderItem oli : [ SELECT id, Product2Id,Order_Hub_Line_Item_Id__c, Product2.ISBN__c, OrderId FROM OrderItem WHERE Order_Hub_Line_Item_Id__c IN:setOfOrderItemIds OR OrderId =:existingOrderId] ) {
                                if(String.isNotBlank(oli.Order_Hub_Line_Item_Id__c)){
									oliHubIdToOLIMap.put( oli.Order_Hub_Line_Item_Id__c, oli );
									oliOldmapToProduct.put(Oli.Order_Hub_Line_Item_Id__c,oli.Product2.ISBN__c); //initializing existing oli map
								}else{
									oliIsbnToOLIMap.put( oli.Product2.ISBN__c, oli );
                                    setOfOliOldIsbn.add(oli.Product2.ISBN__c);
								}
								
                            }
                        } catch ( Exception ex ) {
                            System.debug('Exception =====>' + ex);
                        }
                    }
					System.debug('oliHubIdToOLIMap =====>' + oliHubIdToOLIMap);
                    system.debug('oliOldmapToProduct =====>' + oliOldmapToProduct);
                    System.debug('oliIsbnToOLIMap =====>' + oliIsbnToOLIMap);
                    System.debug('setOfOliOldIsbn =====>' + setOfOliOldIsbn);
                    // Setting Boolean value for update of OrderItem in case of same record get from OrderHub
                    Map<String, Boolean> oliHubIdToBooleanMap = new Map<String, Boolean>();
					Map<String, Boolean> oliIsbnToBooleanMap = new Map<String, Boolean>();
                    
                    if ( !oliOldmapToProductHub.isEmpty() && !oliOldmapToProduct.isEmpty()) { 
                        for ( String oliHubId : oliOldmapToProductHub.keySet() ) {
                            if (oliOldmapToProduct.containsKey(oliHubId) && oliOldmapToProductHub.containsKey(oliHubId) && oliOldmapToProduct.get(oliHubId) == oliOldmapToProductHub.get(oliHubId) ) {
                                oliHubIdToBooleanMap.put( oliHubId, true );
                            } 
							else {
                                oliHubIdToBooleanMap.put( oliHubId, false );
                            }
                        }
                    }
					else if ( !oliOldISBNmapToProductHub.isEmpty() && !oliIsbnToOLIMap.isEmpty()) { 
                        for ( String oliHubISBN : oliOldISBNmapToProductHub.keySet() ) {
                            if (setOfOliOldIsbn.contains(oliHubISBN) && oliOldISBNmapToProductHub.containsKey(oliHubISBN) ) {
                                oliIsbnToBooleanMap.put( oliHubISBN, true );
                            } 
							else {
                                oliIsbnToBooleanMap.put( oliHubISBN, false );
                            }
                        }
                    }
                    System.debug('oliHubIdToBooleanMap =====>' + oliHubIdToBooleanMap);
					System.debug('oliIsbnToBooleanMap =====>' + oliIsbnToBooleanMap);
                    //For ISBN and product to assign in Order and OrderItem
                    Set<String> setOfProductID = new Set<String>();
                    Map<String,String> mapOfIsbnAndProductId = new Map<String,String>();
                    for(Product2 productId : [SELECT Id, ISBN__c, IsActive FROM Product2 where ISBN__c IN: setOfProductISBN AND IsActive = true]){
                        if(!mapOfIsbnAndProductId.containsKey(productId.ISBN__c)){
                            setOfProductID.add(productId.Id);
                            mapOfIsbnAndProductId.put(productId.ISBN__c, productId.Id);
                        }
                    }
                    system.debug('setOfProductID'+setOfProductID);
                    system.debug('mapOfIsbnAndProductId'+mapOfIsbnAndProductId);
                    //For product and PricebookEntry ID assignment 
                    Map<String,PricebookEntry> mapOfProductIdAndPricebookEntry = new Map<String,PricebookEntry>();
                    List<PricebookEntry> pbeList = new List<PricebookEntry>();
                    pbeList = [SELECT Id,Pricebook2Id,Product2Id,UnitPrice, CurrencyIsoCode, IsActive FROM PricebookEntry where Product2Id IN: setOfProductID AND Pricebook2Id=:PricebookID AND IsActive = true AND CurrencyIsoCode =:currencyCode];
                    
                    if ( !pbeList.isEmpty() ) {                                            
                        for(PricebookEntry pricebookEntryId : pbeList){
                            if(!mapOfIsbnAndProductId.containsKey(pricebookEntryId.Product2Id)){
                                
                                //     orderObj.Pricebook2Id = pricebookEntryId.Pricebook2Id;
                                mapOfProductIdAndPricebookEntry.put(pricebookEntryId.Product2Id, pricebookEntryId);
                            } 
                        }
                    }
                    orderObj.Pricebook2Id = PricebookID;
                    System.debug('orderObj.Pricebook2Id =====>' + orderObj.Pricebook2Id);
                    system.debug('mapOfProductIdAndPricebookEntry'+mapOfProductIdAndPricebookEntry);    
                    // Order Insert and update            
                    if(request.id != null) {
                        List<Order> existingOrder = new List<Order>();
                        
                        //originalOrderRef will only be present on revised or cancelled order and when we post any order to hub then they return status open
                        //So, this if condition will work only for those orders whome we first create in salesforce and then post on hub
                        if(request.originalOrderRef == null && request.orderStatus == 'OPEN'){
                            existingOrder = [ SELECT id, Order_Hub_Id__c, OpportunityId FROM Order WHERE Order_Hub_Id__c =:request.id OR OpportunityId =:request.externalSystemRefId
                                             LIMIT 1 ];
                            system.debug('existingOrder '+existingOrder);
                            if ( existingOrder.size() > 0)
                            {
                                orderObj.id = existingOrder[0].id;
                                orderObj.Order_Hub_Id__c = request.id;
                            }
                            else orderObj.Order_Hub_Id__c = request.id;
                        }else{
                            //If revised and cancelled order will come then we are finding existing order from their hub id only not with opportunity id
                            existingOrder = [ SELECT id, Order_Hub_Id__c, OpportunityId FROM Order WHERE Order_Hub_Id__c =:request.id
                                             LIMIT 1 ];
                            system.debug('existingOrder '+existingOrder);
                            if ( existingOrder.size() > 0)
                            {
                                orderObj.id = existingOrder[0].id;
                                orderObj.Order_Hub_Id__c = request.id;
                            }
                            else orderObj.Order_Hub_Id__c = request.id;
                        }
                        /*existingOrder = [ SELECT id, Order_Hub_Id__c, OpportunityId FROM Order WHERE Order_Hub_Id__c =:request.id OR OpportunityId =:request.opportunityId
                                         LIMIT 1 ];
                        system.debug('existingOrder '+existingOrder);
                        if ( existingOrder.size() > 0)
                        {
                            orderObj.id = existingOrder[0].id;
                            orderObj.Order_Hub_Id__c = request.id;
                        }
                        else
                        {
                            orderObj.Order_Hub_Id__c = request.id;
                        }*/
                    }
                    orderObj.Type = request.orderType; 
                    orderObj.Channel__c = request.channel;
                    //orderObj.PoNumber = request.externalOrderRef;
                    if(request.externalSystemRefId != null)
                        orderObj.OpportunityId = request.externalSystemRefId;
                    /*if(request.opportunityId != null){
                        orderObj.OpportunityId = request.opportunityId;
                        List<opportunityLineItem > oppLineItems = new List<opportunityLineItem >();
                        List<opportunityLineItem > updateOppLineItems = new List<opportunityLineItem >();
                        //These mappings are required for report
                        oppLineItems = [Select id,Invoice_Date__c,Invoice_Number__c,OpportunityId from opportunityLineItem where OpportunityId=: request.opportunityId];
                        for(opportunityLineItem oppLine: oppLineItems){
                            if(request.orderDate != null)
                            oppLine.Invoice_Date__c = request.orderDate;
                            
                            if(request.invoices[0].externalInvoiceRef != null)
                            oppLine.Invoice_Number__c = request.invoices[0].externalInvoiceRef;
                            
                            updateOppLineItems.add(oppLine);
                        }
                        system.debug('updateOppLineItems '+updateOppLineItems);
                        update updateOppLineItems;
                    }*/
                        
                    //orderObj.Description = request.notes;
                    if(quoteNumber != null){
                        system.debug('quoteNumber'+quoteNumber);
                        orderObj.SBQQ__Quote__c = quoteNumber;
                    }
                    orderObj.OrderReferenceNumber = request.orderNumber;
                    orderObj.Confirmation_Number__c=request.confirmationNumber;
                    if(accountId != null){
                        orderObj.AccountId =accountId;
                    }
                    if(contactId != null){
                        system.debug('contactId '+contactId);
                        orderObj.BillToContactId = contactId;
                    }
                    orderObj.Discount__c = request.discount;
                    orderObj.Discount_Code__c = request.discountCode;
                    orderObj.Discount_Currency__c = request.discountCurrency;
                    orderObj.Discount_Amount__c = request.discountAmount;
                    orderObj.EffectiveDate = request.orderDate;
                    orderObj.Total_Amount__c = request.orderPrice;
                    orderObj.Status = request.orderStatus;
                    
                    String billingAddress='';
                    if(request.billingAddress.addressLine1 != null ){
                        billingAddress = request.billingAddress.addressLine1; 
                    }
                    if(request.billingAddress.addressLine2 != null ){
                        billingAddress = billingAddress+','+request.billingAddress.addressLine2;
                    }
                    if(request.billingAddress.addressLine3 != null ){
                        billingAddress = billingAddress+','+request.billingAddress.addressLine3;
                    }
                    if(billingAddress != null)
                        orderObj.BillingStreet = billingAddress;
                    if(request.billingAddress.addressCountry != null)
                        orderObj.BillingCountry = request.billingAddress.addressCountry;
                    if(request.billingAddress.addressLocality != null)
                        orderObj.BillingCity =  request.billingAddress.addressLocality;
                    if(request.billingAddress.addressRegion != null)
                        orderObj.BillingState =  request.billingAddress.addressRegion;
                    if(request.billingAddress.postalCode != null)
                        orderObj.BillingPostalCode =  request.billingAddress.postalCode;
					
                    if(request.shippingAddress != null){
                        String shippingAddress='';
                        if(request.shippingAddress.addressLine1 != null ){
                            shippingAddress = request.shippingAddress.addressLine1; 
                        }
                        if(request.shippingAddress.addressLine2 != null ){
                            shippingAddress = shippingAddress+','+request.shippingAddress.addressLine2;
                        }
                        if(request.shippingAddress.addressLine3 != null ){
                            shippingAddress = shippingAddress+','+request.shippingAddress.addressLine3;
                        }
                        if(shippingAddress != null)
                            orderObj.ShippingStreet = shippingAddress;
                        if(request.shippingAddress.addressCountry != null)
                            orderObj.ShippingCountry = request.shippingAddress.addressCountry;
                        if(request.shippingAddress.addressLocality != null)
                            orderObj.ShippingCity =  request.shippingAddress.addressLocality;
                        if(request.shippingAddress.addressRegion != null)
                            orderObj.ShippingState =  request.shippingAddress.addressRegion;
                        if(request.shippingAddress.postalCode != null)
                            orderObj.ShippingPostalCode =  request.shippingAddress.postalCode;
                    }
						
                    orderObj.Seller__c = request.seller;
                    System.debug('request.invoices[0].externalInvoiceRef-->'+request.invoices[0].externalInvoiceRef);
                    if(request.invoices[0].externalInvoiceRef !=null){
                        orderObj.External_Invoice_Ref__c = request.invoices[0].externalInvoiceRef;
                    }
                    //orderObj.Pricebook2Id = '01s0Y0000082FixQAE';
                    
                    //If this is revised or cancelled order then we are finding it's parant order
                    if(orderObj !=null && request.originalOrderRef != null){
                        List<Order> originalOrderList = new List<Order>([Select id, OrderReferenceNumber,Parent_Order__c from Order where OrderReferenceNumber=:request.originalOrderRef]);
                        if(!originalOrderList.isEmpty()){
                            system.debug('originalOrderList '+originalOrderList);
                            orderObj.Parent_Order__c = originalOrderList.get(0).id;
                        }
                    }
                    
                    system.debug('orderObj =====>'+orderObj);
                    if(orderObj !=null)
                    {
                        upsert orderObj;
                    }
                    
                    orderRecordId = orderObj.Id;
                    system.debug('orderRecordId'+orderRecordId);                        
                    //OrderItem Insert and update
                    list<OrderItem> lstOrderItem = new list<OrderItem>();
                    Set<String> oliProductId= new Set<String>(); 
                    Id product2Id;
                    for(OrderedItems obj : request.orderedItem){
                        //Shalini- Using this set to update the price on opportunity for revised order
                        if(obj.productId != null) oliProductId.add(obj.productId);
                        
                        OrderItem orderLineItemObj = new OrderItem();
                        if(orderRecordId != null)
                            orderLineItemObj.OrderId = orderRecordId;
                        System.debug('orderLineItemObj.OrderId =====>' + orderLineItemObj.OrderId);
                        if(obj.id != null) {
                            orderLineItemObj.Order_Hub_Line_Item_Id__c = obj.id;
                            System.debug('orderLineItemObj.Order_Hub_Line_Item_Id__c =====>' + orderLineItemObj.Order_Hub_Line_Item_Id__c);
                            
                            if ( !oliHubIdToOLIMap.isEmpty() && !oliHubIdToBooleanMap.isEmpty() && oliHubIdToOLIMap.containsKey(obj.id) && oliHubIdToBooleanMap.containsKey(obj.id) && oliHubIdToBooleanMap.get(obj.id) == true ) {
                                orderLineItemObj.id = oliHubIdToOLIMap.get(obj.id).id;
                                System.debug('OrderLineItem Id=====>' + oliHubIdToOLIMap.get(obj.id).id);
                            }
							else if (obj.productId != null && !oliIsbnToOLIMap.isEmpty() && !oliIsbnToBooleanMap.isEmpty() && oliIsbnToOLIMap.containsKey(obj.productId) && oliIsbnToBooleanMap.containsKey(obj.productId) && oliIsbnToBooleanMap.get(obj.productId) == true ) {
                                orderLineItemObj.id = oliIsbnToOLIMap.get(obj.productId).id;
                                System.debug('OrderLineItem Id=====>' + oliIsbnToOLIMap.get(obj.productId).id);
                            }
                        }
                        //orderLineItemObj.Description = obj.description;
                        orderLineItemObj.Line_reference__c = obj.description;
                        System.debug('productId =====>' + obj.productId);
                        System.debug('mapOfIsbnAndProductId =====>' + mapOfIsbnAndProductId);
                        System.debug('ContainsKey =====>' + mapOfIsbnAndProductId.containsKey(obj.productId));
                        System.debug('oliHubIdToBooleanMap.isEmpty() =====>' + oliHubIdToBooleanMap.isEmpty());
                        System.debug('!oliHubIdToBooleanMap.containsKey(obj.id) ====>' + !oliHubIdToBooleanMap.containsKey(obj.id));
                        System.debug('oliHubIdToBooleanMap.get(obj.id) == false =====>' + oliHubIdToBooleanMap.get(obj.id));
                        if( obj.productId != null && (!oliHubIdToBooleanMap.isEmpty() && oliHubIdToBooleanMap.containsKey(obj.id) && oliHubIdToBooleanMap.get(obj.id) == false) || (!oliIsbnToBooleanMap.isEmpty() && oliIsbnToBooleanMap.containsKey(obj.productId) && oliIsbnToBooleanMap.get(obj.productId) == false)){
                            system.debug('ISBN'+obj.productId);
                            system.debug('Product2Id =====>'+mapOfIsbnAndProductId.get(obj.productId));
                            orderLineItemObj.Product2Id = mapOfIsbnAndProductId.get(obj.productId);
                            //product2Id = mapOfIsbnAndProductId.get(obj.productId);
                        }
                        if( obj.productId != null && (!oliHubIdToBooleanMap.isEmpty() && oliHubIdToBooleanMap.containsKey(obj.id) && oliHubIdToBooleanMap.get(obj.id) == false) || (!oliIsbnToBooleanMap.isEmpty() && oliIsbnToBooleanMap.containsKey(obj.productId) && oliIsbnToBooleanMap.get(obj.productId) == false)){
                            //system.debug('***'+mapOfProductIdAndPricebookEntry.get(mapOfIsbnAndProductId.get(obj.productId)).Id);
                            if(mapOfProductIdAndPricebookEntry.get(mapOfIsbnAndProductId.get(obj.productId))!=null){
                                orderLineItemObj.PricebookEntryId = mapOfProductIdAndPricebookEntry.get(mapOfIsbnAndProductId.get(obj.productId)).Id;
                            }
                            else{
                                RestContext.response.statusCode = 400;
                                throw new OrderException('Status: '+RestContext.response.statusCode+' Required field Missing PricebookEntryId.' );
                            }
                        }
                        if( obj.sellingPrice != null ){
                            //orderLineItemObj.UnitPrice = mapOfProductIdAndPricebookEntry.get(product2Id).UnitPrice;
                            orderLineItemObj.UnitPrice = obj.sellingPrice;//Needed for cancel order
                            orderLineItemObj.SBQQ_NetTotal__c = obj.sellingPrice;
                        }
                        if(obj.Price != null){
                            orderLineItemObj.SBQQ__QuotedListPrice__c = obj.Price;
                        }
                        if(obj.quantity != null){
                            orderLineItemObj.Quantity = obj.quantity;//Needed for cancel order
                        }
                        if(obj.orderedQuantity != null){
                            orderLineItemObj.SBQQ__OrderedQuantity__c = obj.orderedQuantity;
                        }      
                        if(obj.status != null)
                            orderLineItemObj.Order_Item_Status__c = obj.status;
                        if(obj.discount != null)
                            orderLineItemObj.Discount_Rate__c = obj.discount;
                        if(obj.discountCode != null)
                            orderLineItemObj.Discount_Code__c = obj.discountCode;
                        if(obj.discountAmount != null)
                            orderLineItemObj.Discount__c = obj.discountAmount;
                        if(obj.taxCode != null)
                            orderLineItemObj.SBQQ__TaxCode__c = obj.taxCode;
                        if(obj.taxAmount != null)
                            orderLineItemObj.SBQQ__TaxAmount__c = obj.taxAmount;
                        lstOrderItem.add(orderLineItemObj);
                        
                    }            
                    if ( !lstOrderItem.isEmpty() ) {
                        System.debug('lstOrderItem =====>' + lstOrderItem);
                        upsert  lstOrderItem;                         
                    }            
                    
                    
                    //Shalini- Modified this method to update the price on opportunity according to revised order
                    if(request.externalSystemRefId != null){
                        List<Opportunity> oppRecord = new List<Opportunity>();
                        List<opportunityLineItem > oppLineItems = new List<opportunityLineItem >();
                        List<opportunityLineItem > updateOppLineItems = new List<opportunityLineItem >();
                        List<opportunityLineItem > deleteOppLineItems = new List<opportunityLineItem >();
                        
                        //Invoice_Date__c and Invoice_Number__c mappings are required for report
                        oppRecord = [Select Id, Name,(Select id,Invoice_Date__c,Invoice_Number__c, ProductCode From OpportunityLineItems) From Opportunity where id =: request.externalSystemRefId Limit 1];
                        if(oppRecord != null && !oppRecord.isEmpty() && oppRecord.get(0).OpportunityLineItems.size()>0)
                        {
                            for(opportunityLineItem oppLine: oppRecord.get(0).OpportunityLineItems)
                            {
                                //If revised order comes then check if any line item deleted from order line item then delete the same from opp line item
                                if(request.orderType == 'REVISED_SALES')
                                {
                                    if(!oliProductId.Contains(oppLine.ProductCode))
                                    {
                                        deleteOppLineItems.add(oppLine);
                                    }
                                }
                                //If original order comes then only update the invoice date and invoice number on OLIs
                                else if(request.orderType != 'REVISED_SALES_RETURN' && request.orderType != 'RETURN'){
                                    if(request.orderDate != null)
                                        oppLine.Invoice_Date__c = request.orderDate;
                                    
                                    if(request.invoices != null && !request.invoices.isEmpty() && request.invoices[0].externalInvoiceRef != null)
                                        oppLine.Invoice_Number__c = request.invoices[0].externalInvoiceRef;
                                    
                                    updateOppLineItems.add(oppLine);
                                }
                            }
                            system.debug('updateOppLineItems '+updateOppLineItems.size()+' '+updateOppLineItems);
                            system.debug('deleteOppLineItems '+deleteOppLineItems.size()+' '+deleteOppLineItems);
                            if(deleteOppLineItems != null && !deleteOppLineItems.isEmpty()) delete deleteOppLineItems;
                            if(updateOppLineItems != null && !updateOppLineItems.isEmpty()) update updateOppLineItems;
                        }
                        
                    }
                    //Shalini- changes end regarding update opportunity price according to revised order
                    
                    
                    
                    System.debug('Deserialized Request =====>' + request);
                    System.debug('Request Id =====>' + request.id); 
                    response.success = true;
                }
                else{
                    RestContext.response.statusCode = 400;
                    //response.setError('ERROR: Status: '+RestContext.response.statusCode+' '+'No body found!!'); 
                    throw new OrderException('Status: '+RestContext.response.statusCode+' '+'No body found!!');
                }
            }  
            
            
            catch ( Exception ex )
            {
                try{
                    system.debug('ex.getMessage() '+ex.getMessage());
                    system.debug('exception2----getLineNumber'+ex.getLineNumber());
                    //errorHandling( request, ex, jsonString );
                    if(ex.getMessage().containsIgnoreCase('You can\'t edit the order currency when the order has order products.')){
                        RestContext.response.statusCode = 400;
                        response.setError('ERROR: Status: '+RestContext.response.statusCode+' You can\'t edit the order currency when the order has order products.' ); 
                        throw new OrderException('Status: '+RestContext.response.statusCode+' You can\'t edit the order currency when the order has order products.');
                    }
                    else if(String.isBlank(jsonString)){
                        RestContext.response.statusCode = 400;
                        response.setError('ERROR: Status: '+RestContext.response.statusCode+' '+'No body found!!'); 
                        throw new OrderException('Status: '+RestContext.response.statusCode+' '+'No body found!!');
                    }
                    else if(ex.getMessage().containsIgnoreCase('Malformed JSON')||ex.getMessage().containsIgnoreCase('Unexpected character') || ex.getMessage().containsIgnoreCase('Unexpected end-of-input') || ex.getMessage().containsIgnoreCase('Unrecognized token')||ex.getMessage().containsIgnoreCase('Invalid numeric value: Leading zeroes not allowed')) {           
                        RestContext.response.statusCode = 400;
                        response.setError('ERROR: Status: '+RestContext.response.statusCode+' '+'JSON is invalid.'); 
                        throw new OrderException('Status: '+RestContext.response.statusCode+' '+'JSON is invalid.');
                    }
                    else if(ex.getMessage().containsIgnoreCase('Illegal') || ex.getMessage().containsIgnoreCase('Invalid id:') || ex.getMessage().containsIgnoreCase('REQUIRED_FIELD_MISSING') || ex.getMessage().containsIgnoreCase('FAILED_ACTIVATION') || ex.getMessage().containsIgnoreCase('INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST') || ex.getMessage().containsIgnoreCase('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                        RestContext.response.statusCode = 400;
                        response.setError('ERROR: Status: '+RestContext.response.statusCode+' '+'Required field missing or invalid.'); 
                        throw new OrderException('Status: '+RestContext.response.statusCode+' '+'Required field missing or invalid.');
                    }
                    else if(ex.getMessage().containsIgnoreCase('DUPLICATE_VALUE')) {           
                        RestContext.response.statusCode = 400;
                        response.setError('ERROR: Status: '+RestContext.response.statusCode+' '+'This record is already present in salesforce'); 
                        throw new OrderException('Status: '+RestContext.response.statusCode+' '+'This record is already present in salesforce');
                    }
                    else if(ex.getMessage().containsIgnoreCase('Upsert failed') || ex.getMessage().containsIgnoreCase('INVALID_CROSS_REFERENCE_KEY')){
                        RestContext.response.statusCode = 400;
                        response.setError('ERROR: Status: '+RestContext.response.statusCode+' '+'Values are not present in Salesforce.'); 
                        throw new OrderException('Status: '+RestContext.response.statusCode+' '+'Values are not present in Salesforce.');
                    }
                    else{
                        RestContext.response.statusCode = 400;
                        response.setError('ERROR: '+ex.getMessage()+' '); 
                        throw new OrderException(ex.getMessage()+' ');
                    }
                }catch(Exception e){
                    system.debug('Exception3 '+e.getMessage());
                    errorHandling( request, e, jsonString );
                    
                }
            }
        }
        
        return JSON.serialize(response);
    }
    
    // ----- Private method definition ------
    private static String getCommand(String requestedUri) {
        return requestedUri.substring(requestedUri.lastIndexOf('/OrderAPI/'));
    }
    
    private static String operationLookup ( String method, String command ) {
        String operation = 'unknown';
        if(method.equals('POST')) {
            if (command.contains('salesforceOrderSync')) {
                operation = 'salesforceOrderSync';
            }
        } else if (method.equals('DELETE')) {
            
        } else if (method.equals('PUT')) {
            
        }
        return operation;
    }
    
    public static void errorHandling ( OrderRequest request, Exception ex, String jsonString ) {
        system.debug('inside errorHandling method');
        String messageKey = '';
        If ( request != NULL ) { messageKey = request.id+':'+request.orderDate; }
        String myString = 'Something went wrong, Following Error Details during OrderApi callOut:- '+ ex.getMessage() + +' '+'</br>';
        String responseBody = 'ERROR: '+ ex.getMessage()+'';
        //Locate the email addresses which the error should be sent to.
        boolean createErrorLog = false;
        boolean sendErrorEmail = false;
        List<String> toAddressList = new List<String>();
        
        for( OrderApiSetting__c os: [SELECT Error_Recipient_Email_Address__c, Send_Error_Emails__c, Create_Setting_Item_Error_Logs__c FROM OrderApiSetting__c WHERE Name = 'Single Setting Record' LIMIT 1] ) 
        {
            toAddressList = os.Error_Recipient_Email_Address__c.Split(',');
            if ( os.Create_Setting_Item_Error_Logs__c == true ) { createErrorLog = true; }
            if ( os.Send_Error_Emails__c == true ) { sendErrorEmail = true; }
        }
        
        //If the JSON string is too long to store in a setting item. 
        jsonString = jsonString.length() > 32768 ? jsonString.substring(0, 32768) : jsonString;
        
        //If the error message is too long to store in a setting item.
        responseBody = responseBody.length() > 255 ? responseBody.substring(0, 255) : responseBody;
        List<Setting_Item__c> errorList = new List<Setting_Item__c>();
        if ( createErrorLog == True ) 
        {
            Id settingRecordId = [SELECT Id FROM Setting__c WHERE Name = 'OrderApi_Error_Logs'].Id;
            Setting_Item__c newErrorLog = new Setting_Item__c();
            newErrorLog.Setting__c = settingRecordId;
            newErrorLog.Text_1__c = String.ValueOf(system.now());
            newErrorLog.Text_2__c = responseBody;
            newErrorLog.Text_3__c = messageKey;
            newErrorLog.Long_Text_1__c = jsonString;
             
            for(Setting_Item__c si: [SELECT Text_3__c, Text_2__c 
                                     FROM Setting_Item__c WHERE Text_3__c =: newErrorLog.Text_3__c
                                     AND Text_3__c != ''
                                     AND Setting__r.Name = 'OrderApi_Error_Logs'])
            {    
                //If the error is already stored update it with the latest error message.
                si.Text_2__c = responseBody;
                errorList.add(si);
            } 
             
            //If an existing error hasn't been added add the new one we've just created.
            if(errorList.size()==0){errorList.add(newErrorLog);}
            
            if(errorList.size()>0){upsert errorList;}
        }
        
        if(toAddressList.size()>0 && sendErrorEmail == true){     
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = toAddressList;
            mail.setSubject('OrderAPI Exception');
            mail.setHtmlBody(myString);
            mail.setToAddresses(toAddresses);
            //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}