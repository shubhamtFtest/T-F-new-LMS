/**Auther: Shalini Singh
   Test Class: OrderAPI_OaEbkChargesChannel_BpcFlowTest
   Description: Receive inbound order from OrderHub for BPC flow and OA_EBK_CHARGES channel
**/
public class OrderAPI_OaEbkChargesChannel_BpcFlow {
    
    public static string salesforceOrderSyncOaEbkChargesChannel(OrderAPI.OrderRequest request, String jsonString, String PricebookID, SBQQ__Quote__c quote)
    {
        OrderAPI.OrderResponse response = new OrderAPI.OrderResponse();
        String orderHubId;
        Id accountId;
        Id contactId;
        Id existingOrderId;
        String currentOrderId;
        List<Opportunity> existingOpportunity = new list<Opportunity>();
        Boolean isOppExistsInSF = false;
        Map<String, OrderItem> pcmIsbnToOliMap = new Map<String, OrderItem>();
        Map<String, OrderItem> pcmDoiToOliMap = new Map<String, OrderItem>();
        Map<String, OrderItem> pcmUuidToOliMap = new Map<String, OrderItem>();
        List<Order> existingOrder = new List<Order>();
        
        try{
            //Fetching channel supported by Salesforce else throwing exception
            List<Setting_Item__c> orderChannelList = new List<Setting_Item__c>([select id, Setting__c, Text_1__c, Checkbox_3__c from Setting_Item__c  where Setting__r.Name  = 'Order Detail Page Mapping']);   
            system.debug('orderChannelList '+orderChannelList);
            if(String.isNotBlank(request.channel)){
                system.debug('request.channel '+request.channel);
                if(!orderChannelList.isEmpty() && orderChannelList != null){
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
                throw new OrderAPI.OrderException('Status: '+RestContext.response.statusCode+' Order channel missing.');
            }
            
            //Fetch accountId from the customerId
            if(String.isNotBlank(request.customerId)){
                accountId = [select ID,customer_id__c from Account where customer_id__c =: request.customerId Limit 1].Id;
                system.debug('accountId '+accountId);
            }
            else if(String.isBlank(accountId)){
                RestContext.response.statusCode = 400;
                throw new OrderAPI.OrderException('Status: '+RestContext.response.statusCode+' Customer does not exist in Salesforce.');
            }
            else{
                RestContext.response.statusCode = 400;
                throw new OrderAPI.OrderException('Status: '+RestContext.response.statusCode+' Customer does not exist in Salesforce.');
            }
            
            //Fetch contactId from contact email available in addresses
            String conEmail = '';
            if (request.shippingAddress != null && String.isNotBlank(request.shippingAddress.addressContactEmail) ) {
                conEmail = request.shippingAddress.addressContactEmail;
            } else if (request.billingAddress != null && String.isNotBlank(request.billingAddress.addressContactEmail) ) {
                conEmail = request.billingAddress.addressContactEmail;
            }
            try {
                system.debug('conEmail '+conEmail);
                if(String.isNotBlank(conEmail))
                contactId = [SELECT Id, createddate FROM Contact WHERE email =: conEmail Limit 1].Id;
            } catch (Exception ex) {}  
            
            //Fetch opportunityId exists in Salesforce or not, If not then through exception
            if(String.isNotBlank(request.externalSystemRefId)){
                existingOpportunity = [Select id, Name from Opportunity where id =: request.externalSystemRefId Limit 1];
                if(existingOpportunity != null && !existingOpportunity.isEmpty()) isOppExistsInSF = true;
                else{
                    RestContext.response.statusCode = 400;
                    throw new OrderAPI.OrderException('Status: '+RestContext.response.statusCode+' OpportunityId does not exist in Salesforce.');
                }
            }
                        
            //Start mapping in order object
            Order orderObj = new Order();
            
            if(request.id != null)
            {
                existingOrder = [ SELECT id, Order_Hub_Id__c, OpportunityId FROM Order WHERE Order_Hub_Id__c =:request.id LIMIT 1 ];
                system.debug('existingOrder through hub id--> '+existingOrder);
                if(existingOrder.size() > 0) orderObj.Id = existingOrder.get(0).id;
                else if(String.isNotBlank(request.orderStatus) && request.orderStatus == 'OPEN' && request.originalOrderRef == null && request.externalSystemRefId != null)
                {
                    existingOrder = [ SELECT id, Order_Hub_Id__c, OpportunityId FROM Order WHERE OpportunityId =:request.externalSystemRefId LIMIT 1 ];
                    if(existingOrder.size() > 0) orderObj.Id = existingOrder.get(0).id;
                    system.debug('existingOrder through opportunityId and status--> '+existingOrder);
                }
                
                orderObj.Order_Hub_Id__c = request.id;
            }
            
            String currencyCode = 'USD'; //Set currency as per default in Org
            //Set currency that received from orderHub to records
            if ( !request.orderedItem.isEmpty() && request.orderedItem !=null && String.isNotBlank(request.orderedItem[0].currencyy) )
                currencyCode = request.orderedItem[0].currencyy;
            orderObj.currencyISOcode = currencyCode;  
            if(String.isNotBlank(PricebookID)) orderObj.Pricebook2Id = PricebookID;
            if(String.isNotBlank(request.orderType)) orderObj.Type = request.orderType; 
            if(String.isNotBlank(request.channel)) orderObj.Channel__c = request.channel;
            if(String.isNotBlank(request.externalSystemRefId)) orderObj.OpportunityId = request.externalSystemRefId;
            if(quote != null && quote.id != null) orderObj.SBQQ__Quote__c = quote.id;
            if(String.isNotBlank(request.orderNumber)) orderObj.OrderReferenceNumber = request.orderNumber;
            if(String.isNotBlank(request.confirmationNumber)) orderObj.Confirmation_Number__c = request.confirmationNumber;
            if(String.isNotBlank(accountId))  orderObj.AccountId = accountId;
            if(String.isNotBlank(contactId)) orderObj.BillToContactId = contactId;
            if(request.discount != null) orderObj.Discount__c = request.discount;
            if(String.isNotBlank(request.discountCode)) orderObj.Discount_Code__c = request.discountCode;
            if(request.discountCurrency != null) orderObj.Discount_Currency__c = request.discountCurrency;
            if(request.discountAmount != null) orderObj.Discount_Amount__c = request.discountAmount;
            if(request.orderDate != null) orderObj.EffectiveDate = request.orderDate;
            if(request.orderPrice != null) orderObj.Total_Amount__c = request.orderPrice;
            if(String.isNotBlank(request.orderStatus)) orderObj.Status = request.orderStatus;
            if(String.isNotBlank(request.seller)) orderObj.Seller__c = request.seller;
            if(!request.invoices.isEmpty() && request.invoices !=null && request.invoices.get(0).externalInvoiceRef !=null) orderObj.External_Invoice_Ref__c = request.invoices.get(0).externalInvoiceRef;
            
            //Map invoice status for BPC reporting
            if(request.invoices != null && !request.invoices.isEmpty() && request.invoices.get(0).paymentStatus != null)
            orderObj.Invoice_Status__c = request.invoices.get(0).paymentStatus;
            
            if(orderObj != null && String.isNotBlank(request.originalOrderRef))
            {
                List<Order> originalOrderSF = new List<Order>([Select id, OrderReferenceNumber,Parent_Order__c from Order where OrderReferenceNumber=:request.originalOrderRef]);
                if(!originalOrderSF.isEmpty() && originalOrderSF !=null)
                {
                    orderObj.Parent_Order__c = originalOrderSF.get(0).id;
                    for(orderItem ordItemObj: [Select id, Order_Hub_Line_Item_Id__c, Product2Id, Product2.ProductCode, OrderId, PricebookEntryId, PCM_ISBN__c, PCM_DOI__c, PCM_UUID__c
                                               from OrderItem where orderId =: originalOrderSF.get(0).id])
                    {
                        if(String.isNotBlank(ordItemObj.PCM_ISBN__c)) pcmIsbnToOliMap.put(ordItemObj.PCM_ISBN__c, ordItemObj);//Required for cancelled and revised order
                        if(String.isNotBlank(ordItemObj.PCM_DOI__c)) pcmDoiToOliMap.put(ordItemObj.PCM_DOI__c, ordItemObj);
                        if(String.isNotBlank(ordItemObj.PCM_UUID__c)) pcmUuidToOliMap.put(ordItemObj.PCM_UUID__c, ordItemObj);
                    }
                }
            }
            
            if(request.billingAddress != null)
            {
                String billingAddress='';
                if(request.billingAddress.addressLine1 != null ) billingAddress = request.billingAddress.addressLine1; 
                if(request.billingAddress.addressLine2 != null ) billingAddress = billingAddress+','+request.billingAddress.addressLine2;
                if(request.billingAddress.addressLine3 != null ) billingAddress = billingAddress+','+request.billingAddress.addressLine3;
                if(billingAddress != null) orderObj.BillingStreet = billingAddress;
                if(request.billingAddress.addressCountry != null) orderObj.BillingCountry = request.billingAddress.addressCountry;
                if(request.billingAddress.addressLocality != null) orderObj.BillingCity =  request.billingAddress.addressLocality;
                if(request.billingAddress.addressRegion != null) orderObj.BillingState =  request.billingAddress.addressRegion;
                if(request.billingAddress.postalCode != null) orderObj.BillingPostalCode =  request.billingAddress.postalCode;
            }
            
            if(request.shippingAddress != null)
            {
                String shippingAddress='';
                if(request.shippingAddress.addressLine1 != null ) shippingAddress = request.shippingAddress.addressLine1; 
                if(request.shippingAddress.addressLine2 != null ) shippingAddress = shippingAddress+','+request.shippingAddress.addressLine2;
                if(request.shippingAddress.addressLine3 != null ) shippingAddress = shippingAddress+','+request.shippingAddress.addressLine3;
                if(shippingAddress != null) orderObj.ShippingStreet = shippingAddress;
                if(request.shippingAddress.addressCountry != null) orderObj.ShippingCountry = request.shippingAddress.addressCountry;
                if(request.shippingAddress.addressLocality != null) orderObj.ShippingCity =  request.shippingAddress.addressLocality;
                if(request.shippingAddress.addressRegion != null) orderObj.ShippingState =  request.shippingAddress.addressRegion;
                if(request.shippingAddress.postalCode != null) orderObj.ShippingPostalCode =  request.shippingAddress.postalCode;
            }
            //End mapping in order object
            
            system.debug('orderObj--> '+orderObj);
            if(orderObj !=null) upsert orderObj;
            
            currentOrderId = orderObj.Id;
            system.debug('currentOrderId--> '+currentOrderId);
            
            //Start mapping for orderItem object
            list<OrderItem> lstOrderItem = new list<OrderItem>();
            Map<String, OrderItem> oliHubIdToSfOliMap = new map<String, OrderItem>();
            Map<String, OrderItem> olipcmIsbnToSfOliMap = new map<String, OrderItem>();
            Map<String, OrderItem> olipcmDoiToSfOliMap = new map<String, OrderItem>();
            Map<String, OrderItem> olipcmUuidToSfOliMap = new map<String, OrderItem>();
            
            //Start doing this here to avoide query in a for loop
            for(orderItem ordItemObj: [Select id, Order_Hub_Line_Item_Id__c, Product2Id, Product2.ProductCode, OrderId,PCM_ISBN__c,PCM_DOI__c,PCM_UUID__c 
                                       from OrderItem where orderId =: currentOrderId])
            {
                if(String.isNotBlank(ordItemObj.Order_Hub_Line_Item_Id__c)) oliHubIdToSfOliMap.put(ordItemObj.Order_Hub_Line_Item_Id__c, ordItemObj);
                if(String.isNotBlank(ordItemObj.PCM_ISBN__c)) olipcmIsbnToSfOliMap.put(ordItemObj.PCM_ISBN__c, ordItemObj);
                if(String.isNotBlank(ordItemObj.PCM_DOI__c)) olipcmDoiToSfOliMap.put(ordItemObj.PCM_DOI__c, ordItemObj);
                if(String.isNotBlank(ordItemObj.PCM_UUID__c)) olipcmUuidToSfOliMap.put(ordItemObj.PCM_UUID__c, ordItemObj);
            }
            system.debug('oliHubIdToSfOliMap ** Will be needed for cancelled/Revised order--> '+oliHubIdToSfOliMap);//Will be needed for cancelled order
            system.debug('olipcmIsbnToSfOliMap--> '+olipcmIsbnToSfOliMap);//either olipcmIsbnToSfOliMap or pcmIsbnToOliMap map contains values
            system.debug('pcmIsbnToOliMap--> '+pcmIsbnToOliMap);
            system.debug('olipcmDoiToSfOliMap--> '+olipcmDoiToSfOliMap);
            system.debug('pcmDoiToOliMap--> '+pcmDoiToOliMap);
            system.debug('olipcmUuidToSfOliMap--> '+olipcmUuidToSfOliMap);
            system.debug('pcmUuidToOliMap--> '+pcmUuidToOliMap);
            
            //End avoide query in a for loop
            Set<String> oliProductId= new Set<String>();
            
            for(OrderAPI.OrderedItems obj : request.orderedItem)
            { 
                OrderItem orderLineItemObj = new OrderItem();
                //Using this set to update the price on opportunity according to revised order
                if(obj.productId != null) oliProductId.add(obj.productId);
                
                if(String.isNotBlank(currentOrderId)) orderLineItemObj.OrderId = currentOrderId;
                if(obj.id != null)
                {
                    orderLineItemObj.Order_Hub_Line_Item_Id__c = obj.id;
                    //If existing oli available with the current order
                    if(!oliHubIdToSfOliMap.isEmpty() && oliHubIdToSfOliMap != null && oliHubIdToSfOliMap.containsKey(obj.id))
                    {
                        orderLineItemObj.Id = oliHubIdToSfOliMap.get(obj.id).id;
                        //orderLineItemObj.Product2Id = oliHubIdToSfOliMap.get(obj.id).Product2Id;//No need to map this as if order is already created in SF it should be availble when we receive order from hub
                    }
                    //Use this olipcmUuidToSfOliMap
                    //If hub id is not available on oli
                    else if(!olipcmUuidToSfOliMap.isEmpty() && olipcmUuidToSfOliMap != null && (oliHubIdToSfOliMap.isEmpty() || oliHubIdToSfOliMap == null) &&
                       String.isNotBlank(obj.productId) && olipcmUuidToSfOliMap.containsKey(obj.productId))
                    {
                        orderLineItemObj.Id = olipcmUuidToSfOliMap.get(obj.productId).id;
                        system.debug('orderLineItemObj.Id '+orderLineItemObj.Id);
                        if(olipcmUuidToSfOliMap.get(obj.productId).PCM_UUID__c != null) orderLineItemObj.PCM_UUID__c = olipcmUuidToSfOliMap.get(obj.productId).PCM_UUID__c;
                        //orderLineItemObj.Product2Id = oliProdCodeToSfOliMap.get(obj.productId).Product2Id;//No need to map this as if order is already created in SF it should be availble when we receive order from hub
                    }
                    /*else if(!olipcmIsbnToSfOliMap.isEmpty() && olipcmIsbnToSfOliMap != null && (oliHubIdToSfOliMap.isEmpty() || oliHubIdToSfOliMap == null) &&
                       String.isNotBlank(obj.altProductId) && olipcmIsbnToSfOliMap.containsKey(obj.altProductId))
                    {
                        orderLineItemObj.Id = olipcmIsbnToSfOliMap.get(obj.altProductId).id;
                        if(olipcmIsbnToSfOliMap.get(obj.altProductId).PCM_ISBN__c != null) orderLineItemObj.PCM_ISBN__c = olipcmIsbnToSfOliMap.get(obj.altProductId).PCM_ISBN__c;
                        //orderLineItemObj.Product2Id = oliProdCodeToSfOliMap.get(obj.altProductId).Product2Id;//No need to map this as if order is already created in SF it should be availble when we receive order from hub
                    }
                    //If PCM isbn is not available then use PCM doi
                    else if(!olipcmDoiToSfOliMap.isEmpty() && olipcmDoiToSfOliMap != null && (oliHubIdToSfOliMap.isEmpty() || oliHubIdToSfOliMap == null) &&
                       String.isNotBlank(obj.altProductId) && olipcmDoiToSfOliMap.containsKey(obj.altProductId))
                    {
                        orderLineItemObj.Id = olipcmDoiToSfOliMap.get(obj.altProductId).id;
                        if(olipcmDoiToSfOliMap.get(obj.altProductId).PCM_DOI__c != null) orderLineItemObj.PCM_DOI__c = olipcmDoiToSfOliMap.get(obj.altProductId).PCM_DOI__c;
                        //orderLineItemObj.Product2Id = oliProdCodeToSfOliMap.get(obj.altProductId).Product2Id;//No need to map this as if order is already created in SF it should be availble when we receive order from hub
                    }*/
                    //pcmUuidToOliMap use this for revised and cancelled order to define the uniqueness
                    else if(String.isNotBlank(obj.productId) && !pcmUuidToOliMap.isEmpty() && pcmUuidToOliMap != null && pcmUuidToOliMap.containsKey(obj.productId)){
                        orderLineItemObj.Product2Id = pcmUuidToOliMap.get(obj.productId).Product2Id;
                        orderLineItemObj.PricebookEntryId = pcmUuidToOliMap.get(obj.productId).PricebookEntryId;
                        if(pcmUuidToOliMap.get(obj.productId).PCM_UUID__c != null) orderLineItemObj.PCM_UUID__c = pcmUuidToOliMap.get(obj.productId).PCM_UUID__c;
                        
                        if(pcmUuidToOliMap.get(obj.productId).PCM_DOI__c != null) orderLineItemObj.PCM_DOI__c = pcmUuidToOliMap.get(obj.productId).PCM_DOI__c;
                    }
                    /*else if(String.isNotBlank(obj.altProductId) && !pcmIsbnToOliMap.isEmpty() && pcmIsbnToOliMap != null && pcmIsbnToOliMap.containsKey(obj.altProductId)){
                        orderLineItemObj.Product2Id = pcmIsbnToOliMap.get(obj.altProductId).Product2Id;
                        orderLineItemObj.PricebookEntryId = pcmIsbnToOliMap.get(obj.altProductId).PricebookEntryId;
                        if(pcmIsbnToOliMap.get(obj.altProductId).PCM_ISBN__c != null) orderLineItemObj.PCM_ISBN__c = pcmIsbnToOliMap.get(obj.altProductId).PCM_ISBN__c;
                    }
                    else if(String.isNotBlank(obj.altProductId) && !pcmDoiToOliMap.isEmpty() && pcmDoiToOliMap != null && pcmDoiToOliMap.containsKey(obj.altProductId)){
                        orderLineItemObj.Product2Id = pcmDoiToOliMap.get(obj.altProductId).Product2Id;
                        orderLineItemObj.PricebookEntryId = pcmDoiToOliMap.get(obj.altProductId).PricebookEntryId;
                        if(pcmDoiToOliMap.get(obj.altProductId).PCM_DOI__c != null) orderLineItemObj.PCM_DOI__c = pcmDoiToOliMap.get(obj.altProductId).PCM_DOI__c;
                    }*/
                }
                if(String.isNotBlank(obj.description)) orderLineItemObj.Line_reference__c = obj.description;
                if(obj.sellingPrice != null)
                {
                    orderLineItemObj.SBQQ_NetTotal__c = obj.sellingPrice;
                }
                if(obj.Price != null)
                {
                    orderLineItemObj.SBQQ__QuotedListPrice__c = obj.Price;
                    orderLineItemObj.UnitPrice = obj.Price;//Required for cancelled/Revised order mapping 
                    
                }
                if(obj.quantity != null) orderLineItemObj.Quantity = obj.quantity;//Reqired for cancel order
                if(obj.orderedQuantity != null) orderLineItemObj.SBQQ__OrderedQuantity__c = obj.orderedQuantity;
                if(String.isNotBlank(obj.status)) orderLineItemObj.Order_Item_Status__c = obj.status;
                if(obj.discount != null) orderLineItemObj.Discount_Rate__c = obj.discount;
                if(String.isNotBlank(obj.discountCode)) orderLineItemObj.Discount_Code__c = obj.discountCode;
                if(String.isNotBlank(obj.discountAmount)) orderLineItemObj.Discount__c = obj.discountAmount;
                if(String.isNotBlank(obj.taxCode)) orderLineItemObj.SBQQ__TaxCode__c = obj.taxCode;
                if(obj.taxAmount != null) orderLineItemObj.SBQQ__TaxAmount__c = obj.taxAmount;
                if(String.isNotBlank(obj.altProductId)) orderLineItemObj.PCM_ISBN__c = obj.altProductId;
                if(String.isNotBlank(obj.lineItemType) && obj.lineItemType == 'EBOOK') orderLineItemObj.PCM_Type__c = 'book';
                else if(String.isNotBlank(obj.lineItemType) && obj.lineItemType == 'EBK-CHAPTER') orderLineItemObj.PCM_Type__c = 'chapter';
                //else if(String.isNotBlank(obj.lineItemType) && obj.lineItemType == 'EBK-CHAPTER-FRONTLIST') orderLineItemObj.PCM_Type__c = 'EBK-CHAPTER-FRONTLIST';
                else if(String.isNotBlank(obj.lineItemType)) orderLineItemObj.PCM_Type__c = obj.lineItemType;
                system.debug('orderLineItemObj--> '+orderLineItemObj);
                lstOrderItem.add(orderLineItemObj);
            }
            //End mapping for orderItem object
            System.debug('lstOrderItem--> ' + lstOrderItem);
            if(!lstOrderItem.isEmpty() && lstOrderItem != null) upsert lstOrderItem;                         
            
            if(request.externalSystemRefId != null){
                List<Opportunity> oppRecord = new List<Opportunity>();
                List<opportunityLineItem > oppLineItems = new List<opportunityLineItem >();
                List<opportunityLineItem > updateOppLineItems = new List<opportunityLineItem >();
                List<opportunityLineItem > deleteOppLineItems = new List<opportunityLineItem >();
                
                //Invoice_Date__c and Invoice_Number__c mappings are required for report
                oppRecord = [Select Id, Name,(Select id,Invoice_Date__c,Invoice_Number__c,OpportunityId, PCM_UUID__c From OpportunityLineItems) From Opportunity where id =: request.externalSystemRefId Limit 1];
                if(oppRecord != null && !oppRecord.isEmpty() && oppRecord.get(0).OpportunityLineItems.size()>0)
                {
                    for(opportunityLineItem oppLine: oppRecord.get(0).OpportunityLineItems)
                    {
                        //If revised order comes then check if any line item deleted from order line item then delete the same from opp line item
                        if(request.orderType == 'REVISED_SALES')
                        {
                            if(!oliProductId.Contains(oppLine.PCM_UUID__c))
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
            
            //return response as success if there is no exception
            response.success = true;
            
        }
        catch(Exception ex){
            System.debug(' ******** Exception : ' +  String.valueOf(' Exception Type :-'+ex.getTypeName()+' ** Message:-'+ex.getMessage()+' ** Line Number:-'+ex.getLineNumber()+' ** Stack Trace :- '+ ex.getStackTraceString()));
            try{
                if(ex.getMessage().containsIgnoreCase('You can\'t edit the order currency when the order has order products.')){
                    RestContext.response.statusCode = 400;
                    response.setError('ERROR: Status: '+RestContext.response.statusCode+' You can\'t edit the order currency when the order has order products.' ); 
                    throw new OrderAPI.OrderException('Status: '+RestContext.response.statusCode+' You can\'t edit the order currency when the order has order products.');
                }
                else if(String.isBlank(jsonString)){
                    RestContext.response.statusCode = 400;
                    response.setError('ERROR: Status: '+RestContext.response.statusCode+' '+'No body found!!'); 
                    throw new OrderAPI.OrderException('Status: '+RestContext.response.statusCode+' '+'No body found!!');
                }
                else if(ex.getMessage().containsIgnoreCase('Malformed JSON')||ex.getMessage().containsIgnoreCase('Unexpected character') || ex.getMessage().containsIgnoreCase('Unexpected end-of-input') || ex.getMessage().containsIgnoreCase('Unrecognized token')||ex.getMessage().containsIgnoreCase('Invalid numeric value: Leading zeroes not allowed')) {           
                    RestContext.response.statusCode = 400;
                    response.setError('ERROR: Status: '+RestContext.response.statusCode+' '+'JSON is invalid.'); 
                    throw new OrderAPI.OrderException('Status: '+RestContext.response.statusCode+' '+'JSON is invalid.');
                }
                else if(ex.getMessage().containsIgnoreCase('Illegal') || ex.getMessage().containsIgnoreCase('Invalid id:') || ex.getMessage().containsIgnoreCase('REQUIRED_FIELD_MISSING') || ex.getMessage().containsIgnoreCase('FAILED_ACTIVATION') || ex.getMessage().containsIgnoreCase('INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST') || ex.getMessage().containsIgnoreCase('FIELD_CUSTOM_VALIDATION_EXCEPTION') ||  ex.getMessage().containsIgnoreCase('Attempt to de-reference a null object')){
                    RestContext.response.statusCode = 400;
                    response.setError('ERROR: Status: '+RestContext.response.statusCode+' '+'Required field missing or invalid.'); 
                    throw new OrderAPI.OrderException('Status: '+RestContext.response.statusCode+' '+'Required field missing or invalid.');
                }
                else if(ex.getMessage().containsIgnoreCase('DUPLICATE_VALUE')) {           
                    RestContext.response.statusCode = 400;
                    response.setError('ERROR: Status: '+RestContext.response.statusCode+' '+'This record is already in process in salesforce'); 
                    throw new OrderAPI.OrderException('Status: '+RestContext.response.statusCode+' '+'This record is already in process in salesforce');
                }
                else if(ex.getMessage().containsIgnoreCase('UNABLE_TO_LOCK_ROW')) {           
                    RestContext.response.statusCode = 400;
                    response.setError('ERROR: Status: '+RestContext.response.statusCode+' '+'The record you are attempting to edit, or one of its related records, is currently being modified by another user. Please try again.'); 
                    throw new OrderAPI.OrderException('Status: '+RestContext.response.statusCode+' '+'The record you are attempting to edit, or one of its related records, is currently being modified by another user. Please try again.');
                }
                else if(ex.getMessage().containsIgnoreCase('Upsert failed') || ex.getMessage().containsIgnoreCase('INVALID_CROSS_REFERENCE_KEY')){
                    RestContext.response.statusCode = 400;
                    response.setError('ERROR: Status: '+RestContext.response.statusCode+' '+'Values are not present in Salesforce.'); 
                    throw new OrderAPI.OrderException('Status: '+RestContext.response.statusCode+' '+'Values are not present in Salesforce.');
                }
                else{
                    RestContext.response.statusCode = 400;
                    response.setError('ERROR: '+ex.getMessage()+' '); 
                    throw new OrderAPI.OrderException(ex.getMessage()+' ');
                }
            }catch(Exception e){
                system.debug('Modified Exception as we are returning to hub--> '+e.getMessage());
                OrderAPI.errorHandling( request, e, jsonString );
            }
        }
        system.debug('JSON.serialize(response)-->'+JSON.serialize(response));
        return JSON.serialize(response);
        
    }
}