/*
* Created by - Piyush Jain
* Create on - 11-12-2020
* Description - This class handles backend functionality of lightning component related to order Hub external channel order cancellation functionality .

* Test Class - OrderHubCustomerDetailCancelCntrl_Test
* Modified By - Shalini Singh(13-07-2021) to show credit Note story(ticket SAL-3501)
*/
public class OrderHubCustomerDetailCancelCntrl {
    private static String orderHubURI = '/v1/orders/';
    private static String fetchSpecificOrderURI = '/v1/orders/';
    private static String createOrderURI = orderHubURI;
    private static string hostname='';
    
    private static void init() {
        if(hostname != null && String.isNotBlank(hostname)) {
            // no strings attached
        }else {
            
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            
            if (orgSpecificProps != null) {
                hostname = (String) orgSpecificProps.get('UBX_Order_Platform_uri__c');
                System.debug('hostname-'+hostname);
            }
            
        }
    }
    
    @AuraEnabled
    Public static TF_OrderHubIntJSONResp  getOrdersForCustomer(String accountId,String channel, String pagesize, String pageno)
    {
        System.debug('accountId'+accountId);
        System.debug('channel'+channel);
        System.debug('pagesize'+pagesize);
        System.debug('pageno'+pageno);
        init();
        System.debug('getOrdersForCustomer');
        if (accountId != NULL && String.isNotBlank(accountId) )
        {
            List<account> listAccountDb = new List<account>([SELECT id,Customer_ID__c FROM account WHERE id =: accountId LIMIT 1  ]);
            if (listAccountDb!=NULL && listAccountDb.size() > 0 && listAccountDb.get(0).Customer_ID__c != NULL && String.isNotBlank(listAccountDb.get(0).Customer_ID__c) )
            {
                createOrderURI = hostname + createOrderURI + '?customerId=' + listAccountDb.get(0).Customer_ID__c + '&channel=' + channel.toUpperCase() +'&pagesize=' +pagesize +'&pageno='+pageno;
                System.debug('createOrderURI-'+createOrderURI);
                Map<String, String> headers = new Map<String,String>();
                headers.put('Content-Type', 'application/json');
                
                try {
                    HttpResponse res = null;
                    if( false) {
                        // To mock the result
                        //res = createMockResponse();
                        
                    } else {
                        res = TF_PlatformExecuter.execute(createOrderURI,'GET','idtoken', null, headers, false);
                        system.debug('res-'+String.valueof(res));
                    }
                    if (res.getStatusCode() == 201 || res.getStatusCode() == 200) {
                        String responseBody = res.getBody();
                        //res.getHeader(key) TF_OrderHubIntJSONResp
                        System.debug('****ResponseCode****!' + res.getStatusCode());
                        System.debug('****responseBody****!' + res.getBody());
                        TF_OrderHubIntJSONResp TF_OrderHubIntJSONRespObj =(TF_OrderHubIntJSONResp) System.JSON.deserialize(mogrifyJSON(res.getBody()), TF_OrderHubIntJSONResp.class);
                        TF_OrderHubIntJSONRespObj.metadata.totalPagesize = Integer.valueOf(res.getHeader('total_pages'));
                        // setting addresMappg on wrapper acc to setting obj to use either billing address or shipping address
                        if (TF_OrderHubIntJSONRespObj!= NULL && TF_OrderHubIntJSONRespObj.metadata !=NULL)  {
                            // order detail mapping also used on order lightning tab 
                            List<Setting__c> ListOrderDetailPageMapping  = [SELECT Id,Name FROM Setting__c WHERE Name = 'Order Detail Page Mapping' limit 1];
                            List<Setting_Item__c>  listPageMappingSetgItem = [SELECT Checkbox_1__c,Checkbox_2__c,
                                                                              Text_1__c, Setting__c FROM Setting_Item__c where Setting__c = :ListOrderDetailPageMapping.get(0).Id ];
                            
                            for (Setting_Item__c settgObj : listPageMappingSetgItem) {
                                String chnlJSON =channel;
                                if(String.isNotBlank(chnlJSON) && chnlJSON.equalsIgnoreCase(settgObj.Text_1__c) )
                                {
                                    if(settgObj.Checkbox_1__c == true  ){
                                        TF_OrderHubIntJSONRespObj.metadata.addresMappg = 'shippingAddress' ;
                                    }
                                    else if(settgObj.Checkbox_2__c == true ){
                                        TF_OrderHubIntJSONRespObj.metadata.addresMappg = 'billingAddress' ;
                                    }
                                    
                                }
                            }
                            //
                        }
                        system.debug('TF_OrderHubIntJSONRespObj-'+TF_OrderHubIntJSONRespObj);
                        return TF_OrderHubIntJSONRespObj;
                    }
                    else
                    {
                        system.debug('#####!DEBUG'+ '' + res);
                        //system.debug('#####!DEBUG'+ '' + Id);
                        return null;
                    }
                }
                catch (Exception ex) {
                    System.debug('******** Exception : ' + ex.getMessage());
                    return null;
                }
            }
        }
        return NULL;
    }
    
    
    
    
    // method to fetch specific orders  // orderNum fetchSpecificOrder()
    @AuraEnabled
    public Static TF_SingleOrderDetailJsonResponse fetchSpecificOrder( String orderNum, string AccountId ){
        init();
        
        String AccountNameStr;
        if (AccountId != null && String.isNotBlank(AccountId)) {
            Account acc = [SELECT id, Name FROM account WHERE id = :AccountId ];
            if (acc != null) {
                AccountNameStr = acc.Name;
            }
        }
        
        
        fetchSpecificOrderURI = hostname + fetchSpecificOrderURI  + orderNum;
        system.debug('fetchSpecificOrderURI-'+fetchSpecificOrderURI);
        Map<String, String> headers = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        
        // try {
        HttpResponse res = null;
        if( false) {
            // To mock the result
            //res = createMockResponse();
            
        } else {
            res = TF_PlatformExecuter.execute(fetchSpecificOrderURI,'GET','idtoken', null, headers, false);
            system.debug('res-'+res);
        }
        if (res.getStatusCode() == 201 || res.getStatusCode() == 200) {
            String responseBody = res.getBody();
            System.debug('********!' + responseBody);
            System.debug('****ResponseCode****!' + res.getStatusCode());
            // System.debug('****responseBody****!' + res.getBody());
            TF_SingleOrderDetailJsonResponse TF_SingleOrderDetailJsonResponseObj =(TF_SingleOrderDetailJsonResponse) System.JSON.deserialize(mogrifyJSON(res.getBody()), TF_SingleOrderDetailJsonResponse.class);
            if (TF_SingleOrderDetailJsonResponseObj!= Null && TF_SingleOrderDetailJsonResponseObj.order!= NULL && TF_SingleOrderDetailJsonResponseObj.order.orderedItem!= NULL ) {
                
                List<Setting__c> ListOrderDetailPageMapping  = [SELECT Id,Name FROM Setting__c WHERE Name = 'Order Detail Page Mapping' limit 1];
                List<Setting_Item__c>  listPageMappingSetgItem = [SELECT Checkbox_1__c,Checkbox_2__c,
                                                                  Text_1__c, Setting__c FROM Setting_Item__c where Setting__c = :ListOrderDetailPageMapping.get(0).Id ];
                
                
                list<TF_SingleOrderDetailJsonResponse.orderedItem> listOrderItem =TF_SingleOrderDetailJsonResponseObj.order.orderedItem;
                TF_SingleOrderDetailJsonResponseObj.order.AccountName = AccountNameStr;
                // System.debug('listOrderItem-'+listOrderItem);
                if (listOrderItem!= null && listOrderItem.size() >0  ) {
                    Set<String> setProdId = new Set<String>(); // basically these are ProductCode returning in JSON
                    for (TF_SingleOrderDetailJsonResponse.orderedItem obj  : listOrderItem) {
                        setProdId.add(obj.productId);
                        
                    }
                    //    System.debug('setProdId'+setProdId);
                    Map<String, Product2> mapPcodeProd = new Map<String, Product2>();
                    Map<Id, Product2> mapProduct = new Map<Id, Product2>([SELECT id,Name,Lead_Author_Editor__c,ProductCode FROM product2 WHERE ProductCode IN: setProdId AND IsActive = true AND ProductCode != null]);
                    for(Product2 prod : [SELECT id,Name,Lead_Author_Editor__c,ProductCode,Version_Type__c FROM product2 WHERE ProductCode IN:setProdId AND IsActive = true AND ProductCode != null ] ) {
                        mapPcodeProd.put(prod.ProductCode,prod );
                    }
                    for (TF_SingleOrderDetailJsonResponse.orderedItem obj  : TF_SingleOrderDetailJsonResponseObj.order.orderedItem) {
                        if ( mapPcodeProd.containsKey(String.valueOf( obj.productId ) ) ) {
                            obj.prodName = mapPcodeProd.get(obj.productId).Name;
                            obj.prodAuthor = mapPcodeProd.get(obj.productId).Lead_Author_Editor__c;
                            obj.versionType = mapPcodeProd.get(obj.productId).Version_Type__c;
                        }
                    }
                }
            }
            
            //Shalini: Start changes regarding credit note(ticket SAL-3501) to fetch originl current order from salesforce if exists 
            if(String.isNotBlank(orderNum))
            {
                system.debug('orderNum to find order in SF--> '+orderNum);
                List<Order> originalOrderSF = new List<Order>([Select id, OrderReferenceNumber from Order where OrderReferenceNumber =: orderNum Limit 1]);
                if(originalOrderSF != Null && !originalOrderSF.isEmpty())
                {
                    TF_SingleOrderDetailJsonResponseObj.originalOrdId = originalOrderSF.get(0).id;
                }
                
            }
            //Shalini: Changes end regarding credit note(ticket SAL-3501) 
            
            
            return TF_SingleOrderDetailJsonResponseObj;
            
        }
        else
        {
            system.debug('#####!DEBUG'+ '' + res);
            //system.debug('#####!DEBUG'+ '' + Id);
            return null;
        }
        // }
        // catch (Exception ex) {
        //     System.debug('******** Exception : ' + ex.getMessage()+' at line no.-'+ ex.getLineNumber() +' getTypeName-' +ex.getTypeName());
        //     return null;
        // }
    }
    
    @AuraEnabled
    public static String searchDB(String objectName, String fld_API_Text, String fld_API_Val,  Integer lim,String fld_API_Search,String searchText ){
        
        searchText='\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';
        String query;
        
        query = 'SELECT '+fld_API_Text+' ,'+fld_API_Val+
            ' FROM '+objectName+
            ' WHERE '+fld_API_Search+' LIKE '+searchText+
            ' LIMIT '+lim;
        
        List<sObject> sobjList = Database.query(query);
        List<ResultWrapper> lstRet = new List<ResultWrapper>();
        
        for(SObject s : sobjList) {
            ResultWrapper obj = new ResultWrapper();
            obj.objName = objectName;
            obj.text = String.valueOf(s.get(fld_API_Text));
            obj.val = String.valueOf(s.get(fld_API_Val));
            lstRet.add(obj);
        }
        return JSON.serialize(lstRet);
    }
    
    //Method to fetch sales type from settings to sow list of channels
    @AuraEnabled
    public static List<Setting_Item__c> getSalesType() {
        List<Setting_Item__c> salesTypeList = new List<Setting_Item__c>([select id, Setting__c, Text_1__c,Text_2__c from Setting_Item__c  where Setting__r.Name  = 'Order Detail Page Mapping' and Checkbox_1__c = true and Checkbox_4__c = true ]);	
        system.debug('salesTypeList '+salesTypeList);
        return salesTypeList;
    }
    
    
    
    public class ResultWrapper {
        public String objName {get; set;}
        public String text {get; set;}
        public String val {get; set;}
    }
    // Also used in class TF_ubxSelfServiceOrderSchduled
    public static String mogrifyJSON(String data) {
        // Regex to match the start of the line and the key
        // surrounded by quotes and ending with a colon
        String regexFormat = '(?m)^\\s*"{0}"\\s*:';
        
        // Replacement format of the new key surrounded by
        // quotes and ending with a colon
        String replacementFormat = '"{0}" :';
        
        // A map of existing key to replacement key
        Map<String, String> replacements = new Map<String, String> {
            'currency' => 'currencyy'
                };
                    
                    // Since our JSON can come in formatted however the
                    // endpoint wants, we need to format it to a standard
                    // we know and can handle
                    String formattedJSON = JSON.serializePretty(JSON.deserializeUntyped(data));
        
        // Iterate over all the keys we want to replace
        for (String key : replacements.keySet()) {
            // Generate our regex based on the key
            String regex = String.format(
                regexFormat,
                new List<String> {key}
            );
            
            // Generate our replacement
            String replacement = String.format(
                replacementFormat,
                new List<String> {replacements.get(key)}
            );
            
            // Find all and replace
            formattedJSON = formattedJSON.replaceAll(regex, replacement);
            // System.debug('formattedJSON-'+formattedJSON);
        }
        
        return formattedJSON;
    }
    
    @AuraEnabled
    public Static cancelOrderWrap cancelSelectedOrder(String orderNum, List<TF_SingleOrderDetailJsonResponse.orderedItem> orderedItems, TF_SingleOrderDetailJsonResponse.order originalOrderDetails, String cancelReason)
    {
        system.debug('originalOrderDetails '+originalOrderDetails);
        cancelOrderWrap cancelOrderWrapObj = new cancelOrderWrap();
        
        //Shalini: Start changes regarding credit note(ticket SAL-3501)    
        //Here we are only inserting this original order in salesforce and on insertion of this partucular recodType(Credit Note Order) order we have writtern an 
        //after insert trigger(Trig_cancelNonSFOrder) to cancel this particular order from OH using API and we are using a trigger to cancel this order because after insertion we can't do callout in a single transection    
        if(originalOrderDetails != Null) 
        {
            //Inserting this particular order in Salesforce 
            Id CreditNoteRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Credit Note Order').getRecordTypeId();
            Order originalOrd = new Order();
            List<Account> accList = new List<Account>();
            if(originalOrderDetails.customerId != Null)
                accList = [select id, Customer_Id__c from Account where (Customer_Id__c =: originalOrderDetails.customerId OR
                                                                         Id =: originalOrderDetails.customerId OR
                                                                         Name =: originalOrderDetails.customerId) Limit 1];
            
            if(accList != null && !accList.isEmpty()) originalOrd.AccountId = accList.get(0).id;//Reuired to insert an order 
            if(originalOrderDetails.orderDate != Null) originalOrd.EffectiveDate = originalOrderDetails.orderDate;//Reuired to insert an order 
            if(originalOrderDetails.orderStatus != Null) originalOrd.Status = originalOrderDetails.orderStatus;//Reuired to insert an order 
            if(originalOrderDetails.orderNumber != Null) originalOrd.OrderReferenceNumber = originalOrderDetails.orderNumber;
            if(originalOrderDetails.channel != Null) originalOrd.Channel__c = originalOrderDetails.channel;//originalOrd.Order_Channel__c;
            if(originalOrderDetails.id != Null) originalOrd.Order_Hub_Id__c = originalOrderDetails.id;
            if(originalOrderDetails.orderType != Null) originalOrd.Type = originalOrderDetails.orderType;//For reporting
            if(originalOrderDetails.subTotalPrice != Null) originalOrd.Total_Price__c = originalOrderDetails.orderPrice; //originalOrd.Total_Amount__c;//For reporting
            if(originalOrderDetails.invoices != null && !originalOrderDetails.invoices.isEmpty() 
               && originalOrderDetails.invoices[0].currencyy != null) originalOrd.CurrencyIsoCode = originalOrderDetails.invoices[0].currencyy;//For reporting
            if(originalOrderDetails.invoices != null && !originalOrderDetails.invoices.isEmpty() 
               && originalOrderDetails.invoices[0].externalInvoiceRef != null) originalOrd.External_Invoice_Ref__c = originalOrderDetails.invoices[0].externalInvoiceRef;
            if(CreditNoteRecordTypeId != Null) originalOrd.RecordTypeId = CreditNoteRecordTypeId;
            if(String.isNotBlank(cancelReason)) originalOrd.Cancellation_Reason__c = cancelReason;
            
            system.debug('originalOrd--> '+originalOrd);
            try{
                if(originalOrd != null)
                {
                    insert originalOrd;
                    cancelOrderWrapObj.originalOrdId = originalOrd.id; 
                    cancelOrderWrapObj.orderCancellatioStatus = 'Order insertion in SF-Success';
                } 
            }
            Catch(exception ex){
                System.debug(' ******** Exception : ' +  String.valueOf(' Exception Type :-'+ex.getTypeName()+' ** Message:-'+ex.getMessage()+' ** Line Number:-'+ex.getLineNumber()+' ** Stack Trace :- '+ ex.getStackTraceString()));
                String emailErrorMessage;
                if(ex.getMessage().containsIgnoreCase('REQUIRED_FIELD_MISSING'))
                {
                    if(ex.getMessage().containsIgnoreCase('Account Name:You must enter a value: []')) emailErrorMessage = 'Account is missing or not present in Salesforce.';
                    else if(ex.getMessage().containsIgnoreCase('Required fields are missing: [Order Start Date]')) emailErrorMessage = 'Order Start Date is missing.';
                    else if(ex.getMessage().containsIgnoreCase('Required fields are missing: [Status]')) emailErrorMessage = 'Status is missing.';
                    else emailErrorMessage = ex.getMessage();//'Required fields are missing or invalid to insert an order in Salesforce';
                }
                else emailErrorMessage = ex.getMessage();
                //Call send email and create error log method
                sendEmail(emailErrorMessage, String.valueOf(' Exception Type:- '+ex.getTypeName()+' ** Message:-'+ex.getMessage()+' ** Line Number:-'+ex.getLineNumber()+' ** Stack Trace :- '+ ex.getStackTraceString()), json.serialize(originalOrd), originalOrd.OrderReferenceNumber, true);
                cancelOrderWrapObj.orderCancellatioStatus = 'Order insertion in SF-Failed'; 
                cancelOrderWrapObj.orderCancellationMessage = 'Order insertion in SF-Failed, '+emailErrorMessage; 
                return cancelOrderWrapObj;
            }
            
        }
        system.debug('cancelOrderWrapObj--> '+cancelOrderWrapObj);
        return cancelOrderWrapObj;
    }
    
    /**
* sendEmail description
* @param  emailErrorMessage : error message that we are sending in the email
* @param  settingObjErrorMessage : error message that we are storing in our setting obj
* @param  errorHttpResponse : pass JSON
* @param  OrdReferenceNumber: Original Order reference number
* @param  createErrorLog: If you want to create error log then true else false
*/
    public static string sendEmail(String emailErrorMessage, String settingObjErrorMessage, String errorHttpResponse, String OrdReferenceNumber, Boolean createErrorLog)
    {
        Datetime myDT = Datetime.now();
        String myDate = myDT.format('h:mm a');
        system.debug('inside credit note sendEmail method');
        
        Credit_Note_Order__c creditNoteOrdCustomSetting = Credit_Note_Order__c.getOrgDefaults();
        
        if(creditNoteOrdCustomSetting != NULL)
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            if(creditNoteOrdCustomSetting.Send_emails_on_failure__c == true && String.isNotBlank(creditNoteOrdCustomSetting.Alert_Email_Addresses__c))
            {
                System.debug('sending email emailErrorMessage'+emailErrorMessage);
                List<String> lstEmail = creditNoteOrdCustomSetting.Alert_Email_Addresses__c.split(',');
                
                mail.setToAddresses(lstEmail);
                mail.setSenderDisplayName('Show Credit Note Process Error');
                String sub = ''+String.valueOf(UserInfo.getUserName().substringAfterLast('.')) + ' ';
                if( String.isNotBlank(OrdReferenceNumber)) sub = sub+'- ' + OrdReferenceNumber;
                if( String.isNotBlank(OrdReferenceNumber) && String.isNotBlank(sub) ) sub = sub.toUpperCase();
                mail.setSubject(sub+' Show Credit Note Process - Failed : '+ String.valueOf(myDT)  );
                mail.setBccSender(false);
                mail.setUseSignature(false);
                // Create the email attachment
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName('JSON Response');
                If( String.isBlank(errorHttpResponse) ) errorHttpResponse = 'No response data available';
                efa.setBody(Blob.valueOf((errorHttpResponse)));
                // Attach file using setFileAttachments function
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                
                mail.setHtmlBody(' Hello, <br/>  Show Credit Note Process has failed. For more Information, please refer to the JSON response provided either in attachment or in setting object. <br/> <br/> Error :- '+ emailErrorMessage );
                try{
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }catch(exception e) {
                    if(e!= NULL) System.debug(' ******** Exception : ' + e.getMessage());
                    System.debug('sendEmail() ****'+e);
                }
            }
        }
        
        if(createErrorLog)
        {
            Setting_Item__c siObj = new Setting_Item__c();
            if (errorHttpResponse != NULL && String.isNotBlank(errorHttpResponse) )
            {
                if (errorHttpResponse.length() > 32762)
                {
                    siObj.Long_Text_1__c = errorHttpResponse.substring(0,32762) + '...';
                }else
                {
                    siObj.Long_Text_1__c = errorHttpResponse;
                }
            }
            
            if(String.isNotBlank(OrdReferenceNumber)) siObj.Text_1__c = OrdReferenceNumber;
            
            siObj.Text_2__c = String.valueOf(myDT);   // Date time Show Credit Note Process Failed
            if (settingObjErrorMessage != NULL && settingObjErrorMessage.length()> 255) {
                siObj.Text_3__c = settingObjErrorMessage.substring(0,255); 
                if(settingObjErrorMessage.length()< 508) siObj.Text_4__c = settingObjErrorMessage.substring(256,settingObjErrorMessage.length()); // sfdc error
                if(settingObjErrorMessage.length()> 508) siObj.Text_4__c = settingObjErrorMessage.substring(256,508);
            }else
            {
                siObj.Text_3__c = settingObjErrorMessage;
            }
            
            for(Setting_Item__c si: [SELECT Text_1__c FROM Setting_Item__c WHERE Text_1__c =: OrdReferenceNumber AND Text_1__c != ''
                                     AND Setting__r.Name = 'Show Credit Note Process Error Logs' FOR UPDATE])
            {    
                //If the error is already stored, update it with the latest error message.
                siObj.id = si.id;
                if(siObj != NULL){
                    upsert siObj;
                    return null;
                }
            }  
            
            Setting__c settObj  = [SELECT Id,Name FROM Setting__c WHERE Name = 'Show Credit Note Process Error Logs' limit 1 ];
            if(settObj != NULL)
            {
                siObj.Setting__c  = settObj.Id;
                if(siObj != NULL) upsert siObj;
            }
        }
        return null;
    }
    
    //Fetch list of cancellation reason from setting record
    @AuraEnabled
    public static List<String> getOrdCancellationReason() {
        List<String> orderCancellationReasonList = new List<String>();
        List<Setting_Item__c> orderCancellation = new List<Setting_Item__c>([select id, Setting__c, Text_1__c from Setting_Item__c  where Setting__r.Name  = 'Order Cancellation Reason']);  
        
        if(orderCancellation != null && !orderCancellation.isEmpty()) {
            for(Setting_Item__c ordCancelReason : orderCancellation){
                orderCancellationReasonList.add(ordCancelReason.Text_1__c);
            }
        }
        system.debug('orderCancellationReasonList '+orderCancellationReasonList);
        return orderCancellationReasonList;
    }
    
    public class cancelOrderWrap
    {
        @AuraEnabled
        public string orderCancellatioStatus{get;set;}
        @AuraEnabled
        public string originalOrdId{get;set;}
        @AuraEnabled
        public string orderCancellationMessage{get;set;}
    }
    //Shalini: Changes end regarding credit note(ticket SAL-3501) 
    
    @AuraEnabled
    Public static orderCancelJSONResp  getSingleOrderForCustomer(String orderRefNo, String pagesize, String pageno)
    {
        System.debug('orderRefNo'+orderRefNo);
        System.debug('pagesize'+pagesize);
        System.debug('pageno'+pageno);
        init();
        System.debug('getSingleOrderForCustomer');
        
        if (orderRefNo != NULL && String.isNotBlank(orderRefNo) )
        {
            //Get details of original Order from order hub using get url
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            String getOrderHubDetailsUri = (String) orgSpecificProps.get('Order_Cancellation__c')+ orderRefNo;
            system.debug('getOrderHubDetailsUri '+getOrderHubDetailsUri);
            String methodType = 'GET'; 
            Map<String, String> headers = new Map<String,String>();
            headers.put('Content-Type', 'application/json');
            try 
            {
                HttpResponse res = new HttpResponse();
                res = TF_PlatformExecuter.execute(getOrderHubDetailsUri, methodType, 'idtoken', NULL, headers, false);//Calling platform execute class for callout
                system.debug('res '+res);
                system.debug('getStatusCode '+res.getStatusCode()); 
                system.debug('getbody '+res.getbody());
                if (res.getStatusCode() == 201 || res.getStatusCode() == 200) 
                {
                    String responseBody = res.getBody();
                    //res.getHeader(key) TF_OrderHubIntJSONResp
                    System.debug('****ResponseCode****!' + res.getStatusCode());
                    System.debug('****responseBody****!' + res.getBody());
                    orderCancelJSONResp orderCancelJSONRespObj = (orderCancelJSONResp)JSON.deserialize(res.getBody(), orderCancelJSONResp.class);
                    orderCancelJSONRespObj.metadata.totalPagesize = 1;
                    orderCancelJSONRespObj.metadata.addresMappg = 'shippingAddress';
                    return orderCancelJSONRespObj;
                }
            }
            catch (Exception ex) 
            {
                System.debug('******** Exception : ' + ex.getMessage());
                return null;
            }
        }
        return NULL;
    }
}