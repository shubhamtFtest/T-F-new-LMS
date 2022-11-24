/** Created By: Shalini Singh 
    Test Class: Trig_cancelNonSFOrderTest
	Description: Using this we are cancelling external channel order on hub from SF
**/
public class Trig_cancelNonSFOrder implements TriggerInterface_Order.Runnable{
	
    public class cancelOrderApiWrap
    {
        @AuraEnabled
        public string orderCancellatioStatus{get;set;}
        @AuraEnabled
        public string messageOnOrder{get;set;}
        @AuraEnabled
        public boolean isCancelled{get;set;}
        
    }
    
    //Deserialize json response returning from order cancellation
    public class cancelOrdFromOrdHub_Response{
        public CancelOrdMetadata metadata;
        public CancelOrdData data;
    }
    public class CancelOrdMetadata {
        public String message;
        public Integer code;
    }
    public class CancelOrdData {
        public String previousOrderNumber;
        public String reversalOrderNumber;
        public String revisedOrderNumber;
    }
    
    public void run(TriggerInterface_Order.Trig trig)
    {
        Id ordRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Credit Note Order').getRecordTypeId();
        if(trig.isAfter && trig.isInsert && trig.newList != NULL )
        {
            Set<String> orderIdSet = new Set<String>();
            
            for(Order ord : trig.newList){
                if(ord.RecordTypeId == ordRecordTypeId && String.isBlank(ord.Message__c) && String.isNotBlank(ord.Status) && !ord.Status.containsIgnoreCase('CANCELLED'))
                orderIdSet.add(ord.Id);
            }
            
            if(orderIdSet != null && !orderIdSet.isEmpty())
            {
                cancelSelectedOrder(orderIdSet);
            }
        }
    }
    
    @future(callout=true)
    public static void cancelSelectedOrder(Set<String> orderIdSet)
    {
        system.debug('cancelSelectedOrder CALL!!');
        Map<String, Order> mapOrdIdToOrder = new Map<String, Order>();
        for(Order ord: [Select id, OrderReferenceNumber, Message__c, Cancelled_Order_Reference_Number__c, Cancellation_Reason__c, Status  from Order where Id IN :orderIdSet FOR UPDATE])
        {
            mapOrdIdToOrder.put(ord.id, ord);
        }
        
        if(mapOrdIdToOrder != null && !mapOrdIdToOrder.isEmpty()) callCancelOrderApi(mapOrdIdToOrder);
    }
    
    //Writing a seperate method because auraEnabled method doesn't supporte type of set
    @AuraEnabled
    public static List<cancelOrderApiWrap> retryCancelSelectedOrder(Id orderId)
    {
        system.debug('cancelSelectedOrder RETRY CALL!! '+ orderId);
        Map<String, Order> mapOrdIdToOrder = new Map<String, Order>();
        for(Order ord: [Select id, OrderReferenceNumber, Message__c, Cancelled_Order_Reference_Number__c, Cancellation_Reason__c, Status  from Order where Id =: orderId FOR UPDATE])
        {
            mapOrdIdToOrder.put(ord.id, ord);
        }
        
        if(mapOrdIdToOrder != null && !mapOrdIdToOrder.isEmpty()) 
            return callCancelOrderApi(mapOrdIdToOrder);
        return null;//Need to check this case
    }
    
    //In this method we are cancelling the order from hub using the OH API
    public static List<cancelOrderApiWrap> callCancelOrderApi(map<String, Order> mapOrdIdToOrder)
    {
        List<cancelOrderApiWrap> cancelOrderApiWrapList = new List<cancelOrderApiWrap>();
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        Map<String, String> headers = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        
        for(Order ord: mapOrdIdToOrder.Values())
        {
            cancelOrderApiWrap cancelOrderApiWrapObj = new cancelOrderApiWrap();
            if(String.isNotBlank(ord.OrderReferenceNumber))
            {
                String sendCancelReqToOrdHubUri = (String) orgSpecificProps.get('Order_Cancellation__c') +ord.OrderReferenceNumber+'/cancel';//Create uri for cancellation
                try {
                    HttpResponse response = new HttpResponse();
                    String body = '{"cancelReason":"'+ord.Cancellation_Reason__c+'"}';//body required for order cancellation on hub
                    system.debug('body '+body);
                    
                    response = TF_PlatformExecuter.execute(sendCancelReqToOrdHubUri, 'POST', 'idtoken', body, headers, false);//Calling platform execute class for callout
                    
                    system.debug('Cancel API Response '+response);
                    if(response != NULL && response.getStatusCode() == 201){
                        system.debug('Cancel API getStatusCode '+response.getStatusCode()); 
                        system.debug('Cancel API getbody '+response.getbody());
                        
                        cancelOrdFromOrdHub_Response cancelOrdHubRes = (cancelOrdFromOrdHub_Response)JSON.deserialize(response.getBody(), cancelOrdFromOrdHub_Response.class);
                        system.debug('cancelOrdHubRes--> '+cancelOrdHubRes);
                        if(cancelOrdHubRes != null)
                        {
                            if(cancelOrdHubRes.data != null) ord.Cancelled_Order_Reference_Number__c = cancelOrdHubRes.data.reversalOrderNumber;
                            ord.Status = 'Cancelled';
                            //Update correct message value on order object
                            updateOrderObject('Order cancellation from order hub-Success, '+cancelOrdHubRes.metadata.message, ord);
                            
                            cancelOrderApiWrapObj.orderCancellatioStatus = 'Order cancellation from order hub-Success';
                            cancelOrderApiWrapObj.messageOnOrder = ord.Message__c;
                            if(String.isNotBlank(ord.Status) && ord.Status.containsIgnoreCase('Cancelled'))
                                cancelOrderApiWrapObj.isCancelled = true;
                            else cancelOrderApiWrapObj.isCancelled = false;
                        }
                    }
                    else{//If status is not success then update the message field on order with the respective error message
                        cancelOrdFromOrdHub_Response cancelOrdHubRes = (cancelOrdFromOrdHub_Response)JSON.deserialize(response.getBody(), cancelOrdFromOrdHub_Response.class);
                        system.debug('cancelOrdHubErrorRes--> '+cancelOrdHubRes);
                        if(cancelOrdHubRes != null && cancelOrdHubRes.metadata != null && cancelOrdHubRes.metadata.message != null)
                        {
                            updateOrderObject('Order cancellation from order hub-Failed, '+cancelOrdHubRes.metadata.message, ord);
                            OrderHubCustomerDetailCancelCntrl.sendEmail('Order cancellation from order hub-Failed, '+cancelOrdHubRes.metadata.message, 'Order cancellation from order hub-Failed, '+cancelOrdHubRes.metadata.message, json.serialize(ord), ord.OrderReferenceNumber, false);
                        }
                        cancelOrderApiWrapObj.orderCancellatioStatus = 'Order cancellation from order hub-Failed'; 
                        cancelOrderApiWrapObj.messageOnOrder = ord.Message__c;
                        if(String.isNotBlank(ord.Status) && ord.Status.containsIgnoreCase('Cancelled'))
                            cancelOrderApiWrapObj.isCancelled = true;
                        else cancelOrderApiWrapObj.isCancelled = false;
                    }
                }
                catch(Exception ex){
                    System.debug(' ******** Exception : ' +  String.valueOf(' Exception Type :-'+ex.getTypeName()+' ** Message:-'+ex.getMessage()+' ** Line Number:-'+ex.getLineNumber()+' ** Stack Trace :- '+ ex.getStackTraceString()));
                    updateOrderObject('Order cancellation from order hub-Failed, '+ex.getMessage(), ord);
                    OrderHubCustomerDetailCancelCntrl.sendEmail('Order cancellation from order hub-Failed, '+ex.getMessage(), String.valueOf(' Exception Type:- '+ex.getTypeName()+' ** Message:-'+ex.getMessage()+' ** Line Number:-'+ex.getLineNumber()+' ** Stack Trace :- '+ ex.getStackTraceString()), json.serialize(ord), ord.OrderReferenceNumber, false);
                    
                    cancelOrderApiWrapObj.orderCancellatioStatus = 'Order cancellation from order hub-Failed'; 
                    cancelOrderApiWrapObj.messageOnOrder = ord.Message__c;
                    if(String.isNotBlank(ord.Status) && ord.Status.containsIgnoreCase('Cancelled'))
                        cancelOrderApiWrapObj.isCancelled = true;
                    else cancelOrderApiWrapObj.isCancelled = false;
                }
            }
            //If OrderReferenceNumber is not present on order then update message field on order with an error message
            else{
                updateOrderObject('Order cancellation from order hub-Failed, OrderReferenceNumber is not present', ord);//update message field with an error msg like orderReferenceNumber is not present
                cancelOrderApiWrapObj.orderCancellatioStatus = 'Order cancellation from order hub-Failed'; 
                cancelOrderApiWrapObj.messageOnOrder = ord.Message__c;
                if(String.isNotBlank(ord.Status) && ord.Status.containsIgnoreCase('Cancelled'))
                    cancelOrderApiWrapObj.isCancelled = true;
                else cancelOrderApiWrapObj.isCancelled = false;
            }
            cancelOrderApiWrapList.add(cancelOrderApiWrapObj);
        }
        system.debug('cancelOrderApiWrapList--> ' +cancelOrderApiWrapList);
        return cancelOrderApiWrapList;
    }
    
    //Update message field on order
    @AuraEnabled
    public static void updateOrderObject(String errorMessageField, Order ord){
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
            
            try{
                if(ord != null) update ord;
            }
            Catch(exception ex){
                System.debug(' ******** Exception : ' +  String.valueOf(' Exception Type :-'+ex.getTypeName()+' ** Message:-'+ex.getMessage()+' ** Line Number:-'+ex.getLineNumber()+' ** Stack Trace :- '+ ex.getStackTraceString()));
                OrderHubCustomerDetailCancelCntrl.sendEmail(ex.getMessage(), String.valueOf(' Exception Type:- '+ex.getTypeName()+' ** Message:-'+ex.getMessage()+' ** Line Number:-'+ex.getLineNumber()+' ** Stack Trace :- '+ ex.getStackTraceString()), json.serialize(ord), ord.OrderReferenceNumber, true);
            }
        }
    }
    
    //Get current order details for retry functionality
    @AuraEnabled
    public static cancelOrderApiWrap getOrderDetails(String orderId){
        cancelOrderApiWrap cancelOrderApiWrapObj = new cancelOrderApiWrap();
        List<Order> ordList = new List<Order>();
        
        ordList = [Select id, Message__c, Status from Order where id =: orderId];
        if(ordList != null && !ordList.isEmpty())
        {
            if(String.isNotBlank(ordList.get(0).Message__c))
                cancelOrderApiWrapObj.messageOnOrder = ordList.get(0).Message__c;
            else cancelOrderApiWrapObj.messageOnOrder = 'This functionality has not been attempted once.';
            
            if(String.isNotBlank(ordList.get(0).Status) && ordList.get(0).Status.containsIgnoreCase('Cancelled'))
                cancelOrderApiWrapObj.isCancelled = true;
            else cancelOrderApiWrapObj.isCancelled = false;
        }
        return cancelOrderApiWrapObj;
    }
    
}