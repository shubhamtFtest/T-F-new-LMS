/*
* Test Class: zTEST_OrderCancellationCtrl
* Description: Used by OrderCancellation lightning component for cancel order
* Created by Piyush Jain
*/
public class OrderCancellationCtrl {
    
    //Deserialize json response returning from get url, status 200
    public class getOrdFormOrdHub_Response{
        public Metadata metadata;
        public Orders order;
    }
    public class Orders {
        public List<OrderedItem> orderedItem;
    }  
    public class OrderedItem {
        public Integer id; 
        public String productId;
        public string altProductId;
    }
    public class Metadata {
        public String message; 
        public Integer code;
    } 
    //Deserialize json response returning from get url, status other than 200
    public class getOrdFormOrdHub_ErrorResponse{
        public ErrorMetadata metadata;
        public Object order;
    }
  public class ErrorMetadata {
    public String message;
    public Integer code;
  }

    //Deserialize json response returning from order cancellation status code other than 201
    public class cancelOrdFromOrdHubError_Response{
        public CancelOrdMetadata metadata;
    }
    public class CancelOrdMetadata {
    public String message;
    public Integer code;
  }
  //Deserialize json response returning from order cancellation status code 201
    public class cancelOrdFromOrdHubSuccess_Response{
        public CancelOrdSuccessMetadata metadata;
        public CancelOrdSuccessData data;
    }
    public class CancelOrdSuccessMetadata {
        public String message;
        public Integer code;
    }
    public class CancelOrdSuccessData {
        public String previousOrderNumber;
        public String reversalOrderNumber;
        public String revisedOrderNumber;
    }
    
    /**
     *Get order item on load 
     **/
    @AuraEnabled
    public Static List<wrapOrderItem> getOrderItems(String inputOrderId){
        System.debug('inputOrderId-->'+inputOrderId);
        List<wrapOrderItem> wrapList = new List<wrapOrderItem>();
        List<OrderItem> ordItmsList = reusableOrderItemQuery(inputOrderId);
        for(OrderItem od:ordItmsList){
            wrapOrderItem wrapObj = new wrapOrderItem();
            wrapObj.oliId = od.Id;
            wrapObj.qtyToReduce = null;
            wrapObj.ordItem = od;
            wrapList.add(wrapObj);
        }
        system.debug('wrapList-->'+wrapList);
        return wrapList;
    }
    
    /**
     *Querying on order item 
     **/
    public static List<OrderItem> reusableOrderItemQuery(String orderId){
        return [SELECT Id,PCM_ISBN__c,PCM_UUID__c,Product2Id,ISBN__c,Product2.ISBN__c,Product2.ProductCode,Product2.Name,Quantity,UnitPrice,PricebookEntryId,Order.Type FROM OrderItem WHERE OrderId=:orderId];
    }
    
    /**
     *Order item wrapper class
     **/
    public class wrapOrderItem{
        @AuraEnabled
        public String oliId{get;set;}
        @AuraEnabled
        public Integer qtyToReduce{get;set;}
        @AuraEnabled
        public OrderItem ordItem{get;set;}
    }
    
    /**
     *Order wraper class
     **/
    public class wrapOrder{
        @AuraEnabled
        public Boolean isOrdTypeNotExists{get;set;}
        @AuraEnabled
        public Boolean isOrdStatusCancelled{get;set;}
        @AuraEnabled
        public Boolean isOrdOppNotClosedWon{get;set;}
    }
    
    /**
     *Cancel order from salesforce and order hub
     **/
    @AuraEnabled
    public Static String cancelSelectedOLIs(List<wrapOrderItem> selOliList, String cancelReason, String currOrderId){
        system.debug('test inside cancelSelectedOLIs method');
        system.debug('cancelReason '+cancelReason);
        system.debug('selOliList-->'+selOliList.size()+'----'+selOliList);
        system.debug('currOrderId--> '+currOrderId);
        
        Integer totOlis = selOliList.size();// total olis from the input list.
        Integer selOlis = 0;
        Map<String,Integer> ordItmIdQtyMap = new Map<String,Integer>();//map contains reduced oli qty value wrt oli.
        Set<String> sfOrdItmIsbnSet = new Set<String>();//Set contains ISBN of order item
        Map<String,Integer> hubIsbnToOrdItmIdmap = new Map<String,Integer>();//Map contains hub ISBN value wrt hub item id
        Set<Integer> qtyToReducePresentSet = new Set<Integer>();//Set contains all qtyToReduce
        String status;
        
        //Fetch BPC order recordTypeId
        Id BPCOrderRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('TF OA BPC Order').getRecordTypeId();
        Id APCOrderRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('TF OA Journal Order').getRecordTypeId();
        Order OrdObj = [SELECT Id,Name,RecordTypeId from Order where id =:currOrderId];
        
        for(wrapOrderItem wrpRec:selOliList){
            system.debug('qtyToReduce '+wrpRec.qtyToReduce);
            if(wrpRec.qtyToReduce>0){
                selOlis++;// here we are getting the selected olis.
                
                //Shalini- Apply this if condition for BPC order cancellation because in BPC flow we store UUID in PCM_UUID__c field and we are using this field because ISBN is not unique in case of chapters
                if(OrdObj != null && String.isNotBlank(OrdObj.RecordTypeId) && OrdObj.RecordTypeId ==BPCOrderRecordTypeId)
                    sfOrdItmIsbnSet.add(wrpRec.ordItem.PCM_UUID__c);
                //Shalini- Apply this if condition for APC order cancellation because in APC flow we store use ProductCode to fetch the ProductId
                else if(OrdObj != null && String.isNotBlank(OrdObj.RecordTypeId) && OrdObj.RecordTypeId ==APCOrderRecordTypeId)
                {
                    sfOrdItmIsbnSet.add(wrpRec.ordItem.Product2.ProductCode);
                }
                    
                else sfOrdItmIsbnSet.add(wrpRec.ordItem.ISBN__c);
            }
            if(wrpRec.qtyToReduce == null) wrpRec.qtyToReduce =0;
            ordItmIdQtyMap.put(wrpRec.ordItem.Id,wrpRec.qtyToReduce);//Now OLIs are inserting in case of revised order but need to test it more
            qtyToReducePresentSet.add(wrpRec.qtyToReduce);
        }
        if(!qtyToReducePresentSet.contains(1)) return 'Select atleast 1 quantity to reduce';  
        
        system.debug('selOlis-->'+selOlis); 
        system.debug('ordItmIdQtyMap-->'+ordItmIdQtyMap);
        system.debug('sfOrdItmIsbnSet-->'+sfOrdItmIsbnSet);  
        List<OrderItem> originalOrdItmListToUpdate = new List<OrderItem>();//List will contains oli of current order
        Integer countqtyOli = 0;
        Set<String> currOrderIdSet = new Set<String>();
        for(OrderItem odItmRec:[SELECT Id,OrderId,PricebookEntryId,UnitPrice,Quantity,Order.Name,Order.OpportunityId,Order.AccountId,
                                Product2Id,Order.Pricebook2Id,Order.CurrencyIsoCode,Order.EffectiveDate,Order.Status 
                                FROM OrderItem WHERE Id IN:ordItmIdQtyMap.keyset()]){
                                    odItmRec.Quantity = odItmRec.Quantity-ordItmIdQtyMap.get(odItmRec.Id); //updating the current record quantity with remaining qty.
                                    if(odItmRec.Quantity == 0){
                                        //delOliList.add(odItmRec);// to delete the oli where qty is 0.
                                        countqtyOli++;
                                    }else{
                                        originalOrdItmListToUpdate.add(odItmRec);
                                    }
                                    currOrderIdSet.add(odItmRec.OrderId);
                                }
        
        //creating Cancelled Order by cloning the current order
        system.debug('currOrderIdSet-->'+currOrderIdSet);
        Order ord = [SELECT Id,Name,SBQQ__Quote__c,Type,AccountId,RecordTypeId,RecordType.Name,Pricebook2Id,CurrencyIsoCode,EffectiveDate,Status,OpportunityId,orderReferenceNumber,Message__c
                     FROM Order 
                     WHERE Id IN:currOrderIdSet LIMIT 1];
        
        //Get details of original Order from order hub using get url
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        String getOrderHubDetailsUri = (String) orgSpecificProps.get('Order_Cancellation__c')+ ord.orderReferenceNumber;
        system.debug('getOrderHubDetailsUri '+getOrderHubDetailsUri);
        
        if(String.isNotBlank(ord.orderReferenceNumber)){
            String methodType = 'GET'; 
            Map<String, String> headers = new Map<String,String>();
            headers.put('Content-Type', 'application/json');
            try {
                HttpResponse res = new HttpResponse();
                res = TF_PlatformExecuter.execute(getOrderHubDetailsUri, methodType, 'idtoken', NULL, headers, false);//Calling platform execute class for callout
                system.debug('res '+res);
                system.debug('getStatusCode '+res.getStatusCode()); 
                system.debug('getbody '+res.getbody());
                if(res != NULL && res.getStatusCode() == 200){
                    //Deserialize response
                    getOrdFormOrdHub_Response getOrdHubRes = (getOrdFormOrdHub_Response)JSON.deserialize(res.getBody(), getOrdFormOrdHub_Response.class);
                    system.debug('getOrdHubRes--> '+getOrdHubRes);
                    if(getOrdHubRes != NULL){
                        for(OrderedItem oli: getOrdHubRes.order.orderedItem){
                            
                            //Shalini- Apply this if condition for BPC order cancellation 
                            if(ord.RecordTypeId == BPCOrderRecordTypeId)
                                hubIsbnToOrdItmIdmap.put(oli.productId, oli.id);//Mapping hub UUID to hub oli id
                            //Shalini- Apply this if condition for APC order cancellation
                            else if(ord.RecordTypeId == APCOrderRecordTypeId)
                            {
                                List<SBQQ__Quote__c> quote = new List<SBQQ__Quote__c>([SELECT Id, DOI__c FROM SBQQ__Quote__c where id =:ord.SBQQ__Quote__c Limit 1]);
                                if(String.isNotBlank(oli.productId) && quote != null && !quote.isEmpty() && oli.productId.containsIgnoreCase(quote.get(0).DOI__c)){
                                    oli.productId = oli.productId.remove('_'+quote.get(0).DOI__c);
                                    system.debug('obj.productId without doi--> '+oli.productId);
                                }
                                hubIsbnToOrdItmIdmap.put(oli.ProductId, oli.id);//Mapping hub ISBN to hub oli id
                            }
                            else hubIsbnToOrdItmIdmap.put(oli.productId, oli.id);//Mapping hub ISBN to hub oli id
                        }
                    }
                    system.debug('hubIsbnToOrdItmIdmap--> '+hubIsbnToOrdItmIdmap);
                }else{
                    getOrdFormOrdHub_ErrorResponse getOrdHubRes = (getOrdFormOrdHub_ErrorResponse)JSON.deserialize(res.getBody(), getOrdFormOrdHub_ErrorResponse.class);
                    updateOrderMessageField('Order cancellation from order hub-Failed, '+getOrdHubRes.metadata.message, ord);//update message field with an error msg 
                    return 'Order cancellation from order hub-Failed';
                }
            }
            Catch(Exception e){
                system.debug('exception '+e.getMessage()+'----'+e.getLineNumber());
                updateOrderMessageField('Order cancellation from order hub-Failed, '+e.getMessage(), ord);//update message field with an error msg
                return 'Order cancellation from order hub-Failed';
            }
        }
        //If OrderReferenceNumber is not present on order then update message field on order with an error message
        else{
            updateOrderMessageField('Order cancellation from order hub-Failed, OrderReferenceNumber is not present', ord);//update message field with an error msg like orderReferenceNumber is not present
            return 'Order cancellation from order hub-Failed';
        }
        //End of code for get details of original Order from order hub using get url
        
        //Cancel Order from Order hub
        String revisedOrderReferenceNumber;
        String cancelOrderReferenceNumber;
        List<Integer> orderHubItemIdIntValList = new List<Integer>();//List will contains oli hub item id(integer) on which we have to update quantity or delete oli from hub
        String orderHubItemIdStringVal = '';//This will contains oli hub item id(string) value because we have to send oli hub id in form of string for order cancellation fro hub
        String sendCancelReqToOrdHubUri = (String) orgSpecificProps.get('Order_Cancellation__c') +ord.orderReferenceNumber+'/cancel';//Create uri for cancellation
        system.debug('sendCancelReqToOrdHubUri '+sendCancelReqToOrdHubUri);
        
        if(String.isNotBlank(ord.orderReferenceNumber)){
            String methodType = 'POST';
            Map<String, String> headers = new Map<String,String>();
            headers.put('Content-Type', 'application/json');
            try {
                HttpResponse response = new HttpResponse();
                system.debug('hubIsbnToOrdItmIdmap-->'+hubIsbnToOrdItmIdmap);
                if(!hubIsbnToOrdItmIdmap.isEmpty()){
                    for(String isbn: hubIsbnToOrdItmIdmap.keySet()){
                        if(sfOrdItmIsbnSet.contains(isbn) && hubIsbnToOrdItmIdmap.containsKey(isbn)){
                            orderHubItemIdIntValList.add(hubIsbnToOrdItmIdmap.get(isbn));//Adding those oli hub ids which we have to send on hub while cancellation
                        }
                        //Shalini- commented this because above I have implemented logic for APC full and partial both cancellation logic regarding APC
                        /*else if(ord.RecordType.Name == 'TF OA Journal Order'){
                            orderHubItemIdIntValList.add(hubIsbnToOrdItmIdmap.get(isbn));
                        }*/
                    }
                    system.debug('orderHubItemIdIntValList--> '+orderHubItemIdIntValList);
                    if(!orderHubItemIdIntValList.isEmpty()){
                        for(Integer ordItemHubId: orderHubItemIdIntValList){
                            orderHubItemIdStringVal += '"'+ ordItemHubId +'",';//Converting from integer to string values as required in body
                        }
                        //We are doing this here because we need to send values in body in the form of string not integer 
                        orderHubItemIdStringVal = orderHubItemIdStringVal.removeEnd(',');
                        system.debug('orderHubItemIdStringVal--> '+orderHubItemIdStringVal);
                        
                        String body = '{"cancelReason":"'+cancelReason+'","orderItemIds":['+orderHubItemIdStringVal+']}';//body required for order cancellation on hub
                        system.debug('body--> '+body);
                        
                        response = TF_PlatformExecuter.execute(sendCancelReqToOrdHubUri, methodType, 'idtoken', body, headers, false);//Calling executer class to do callout
                        system.debug('response '+response);
                        system.debug('getStatusCode '+response.getStatusCode());
                        system.debug('getbody '+response.getbody());
                        if(response != NULL && response.getStatusCode() == 201){
                            //Deserialize response 
                            cancelOrdFromOrdHubSuccess_Response cancelOrdHubRes = (cancelOrdFromOrdHubSuccess_Response)JSON.deserialize(response.getBody(), cancelOrdFromOrdHubSuccess_Response.class);
                            system.debug('cancelOrdHubRes--> '+cancelOrdHubRes);
                            if(cancelOrdHubRes != null){
                                //If cancellation successfull, Update the current Order Status cancelled
                                ord.Status = 'Cancelled';
                                status = 'Order cancellation from order hub-Success';
                                //Update message field on order with a success message
                                updateOrderMessageField('Order cancellation from order hub-Success, '+cancelOrdHubRes.metadata.message, ord);
                            }
                        }else{//Update message field on order with an error message 
                            //Deserialize response 
                            cancelOrdFromOrdHubError_Response cancelOrdHubRes = (cancelOrdFromOrdHubError_Response)JSON.deserialize(response.getBody(), cancelOrdFromOrdHubError_Response.class);
                            system.debug('cancelOrdHubRes--> '+cancelOrdHubRes);
                            if(cancelOrdHubRes != null && cancelOrdHubRes.metadata.message.containsIgnoreCase('Order is already Cancelled'))
                            updateOrderMessageField('Order cancellation from order hub-Success, '+cancelOrdHubRes.metadata.message, ord);//Here we are updating the message field on Order
                            else updateOrderMessageField('Order cancellation from order hub-Failed, '+cancelOrdHubRes.metadata.message, ord);
                            return 'Order cancellation from order hub-Failed';//If order is not cancelled or already cancelled from order hub then do not perform any operation in salesforce
                        }
                    }
                } 
            }
            Catch(Exception e){
                system.debug('exception '+e.getMessage()+'----'+e.getLineNumber());
                updateOrderMessageField('Order cancellation from order hub-Failed '+e.getMessage(), ord);
                return 'Order cancellation from order hub-Failed';
            }
        }
        //End of code for Cancel Order from Order hub
        
        //updating the current Order Item.
        if(!originalOrdItmListToUpdate.isEmpty()){
            system.debug('originalOrdItmListToUpdate-->'+originalOrdItmListToUpdate);
            update originalOrdItmListToUpdate; 
        }
        system.debug('after update originalOrdItmListToUpdate-->'+originalOrdItmListToUpdate);
        // end of code for updating current Order Items
        
        //code for full cancellation order
        system.debug('totOlis->'+totOlis+'selOlis->'+selOlis+'countqtyOli->'+countqtyOli);
        Boolean isFullCancelOrder = false;
        if(totOlis == selOlis && selOlis == countqtyOli){
            system.debug('inside full cancellation cond.');
            isFullCancelOrder = true;
        }else{
            isFullCancelOrder = false;
        }
        system.debug('isFullCancelOrd-->'+isFullCancelOrder);
        //end of code for full cancellation order
        
        if(isFullCancelOrder){
            //If there is full cancellation then update the stage of opportunity to closed lost, order status cancelled and lost reason 
            if(ord.OpportunityId != null){
                Opportunity opp = new Opportunity();
                opp.id = ord.OpportunityId;
                opp.StageName = 'Closed Lost';
                opp.Order_Status__c = 'Cancelled';
                opp.Reason_Lost__c  = cancelReason;
                update opp;
            }
        }
        system.debug('status '+status);
        return status;
    }
    
    /**
     *Check current order type and status
     **/
    @AuraEnabled
    public Static wrapOrder checkCurrentOrderDetails(String inputOrderId){
        system.debug('inside check current order type and status method-->'+inputOrderId);
        wrapOrder wrapObj = new wrapOrder();
        Boolean isOrdTypeNotExists = false;
        List<String> ordTypeList = new List<String>{'New Revised Order','Credit Note','RETURN','REVISED_SALES_RETURN','REVISED_SALES'};
        List<Order> ordList = new List<Order>([SELECT Id,Type,Status,OpportunityId FROM Order WHERE Id =:inputOrderId LIMIT 1]);
        if(!ordList.isEmpty() && ordList != NULL){
            if(ordTypeList.contains(ordList.get(0).Type)) wrapObj.isOrdTypeNotExists = true;//If type matched with ordTypeList then we are showing an error message(This is not an original order) on UI    
            if(ordList.get(0).Status == 'Cancelled') wrapObj.isOrdStatusCancelled = true;//If status is cancelled then we are showing an error message(This Order is already cancelled) on UI 
        
            //If opportunity stage is not closed won ie. this order is not posted on order hub so, we can not cancel it
      List<Opportunity> ordOpportunity= new List<Opportunity>([SELECT Id,StageName FROM Opportunity WHERE Id =:ordList.get(0).OpportunityId LIMIT 1]); 
            if(!ordOpportunity.isEmpty() && ordOpportunity != NULL){
                if(ordOpportunity.get(0).StageName != 'Closed Won' && ordOpportunity.get(0).StageName != 'Closed Lost') wrapObj.isOrdOppNotClosedWon = true;//If opportunity of Order is not closed won then we are showing an error message(Order is not present on Order Hub.) on UI
            }
        }
        system.debug('wrapObj-->'+wrapObj);
        return wrapObj;
    }
    
    /**
     *Update message field on order
     **/
    @AuraEnabled
    public static void updateOrderMessageField(String errorMessageField, Order ord){
        if(string.isNotBlank(errorMessageField) && errorMessageField.containsIgnoreCase('Order cancellation from order hub')){
            String messageStr = ord.Message__c;
            if ( messageStr != NULL && String.isNotBlank(messageStr) ) {
                Map<integer,String> mapIndexValue = new Map<integer,String>();
                List<String> listStr = messageStr.split('~msg~');
                integer k = 0 ;
                for (String msgStr : listStr) {
                    System.debug('msgStr-'+msgStr);
                    if (msgStr!=NULL && msgStr.containsIgnoreCase('Order cancellation from order hub') ) {
                        system.debug('Inside'+msgStr);
                        // overwrite string , it can be success or failure mssg 
                        mapIndexValue.put( k , errorMessageField + ' ' );
                    }
                    k++;
                }
                if(!messageStr.containsIgnoreCase('Order cancellation from order hub')){
                    listStr.add(errorMessageField);
                } 
                System.debug('mapIndexValue_'+mapIndexValue);
                for (integer i  : mapIndexValue.keySet()) {
                    listStr.remove(i);
                    System.debug('listStr.size()'+listStr.size());
                    listStr.add(mapIndexValue.get(i));
                }
                system.debug('listStr-'+listStr);                    
                // combine the string 
                String finalStr; 
                for (Integer i = 0; i < listStr.size(); i++) {                        
                    if(i==0) finalStr = listStr.get(0) +' ';
                    else finalStr = finalStr  + '~msg~' + listStr.get(i) +' ';                        
                }
                if ( String.isNotBlank( finalStr)) {
                    ord.Message__c = finalStr ;
                }
            }
            else if(String.isBlank(messageStr)){
                ord.Message__c = errorMessageField ;
            }
            Update ord;
        }
    }
    
    @AuraEnabled
    public static List<String> getOrdCancellationReason() {
        List<String> orderCancellationReasonList = new List<String>();
        List<Setting_Item__c> orderCancellation = new List<Setting_Item__c>([select id, Setting__c, Text_1__c from Setting_Item__c  where Setting__r.Name  = 'Order Cancellation Reason']);  
        
        if(!orderCancellation.isEmpty()) {
            for(Setting_Item__c ordCancelReason : orderCancellation){
                 orderCancellationReasonList.add(ordCancelReason.Text_1__c);
            }
        }
        system.debug('orderCancellationReasonList '+orderCancellationReasonList);
        return orderCancellationReasonList;
    }
    
}