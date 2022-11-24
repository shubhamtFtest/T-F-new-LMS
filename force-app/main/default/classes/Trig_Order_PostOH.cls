/**
Author : shashank
Test class :  zTest_Trig_Order_PostOH
Description : This class is being used to create order on order HUb side . order will only get inserted 1 at a time so NO BULKIFICATION is done. The order once created will not get update. 
**/
// TODO:  check check box on order before sending order to OH ,   cosmetic mssges frm oh ? , remove dummy values , check to see if any field is missing 
//

public class Trig_Order_PostOH   {
    // some part of it was running on future so took static variables 
    private static String domain ;
    private  static String orderHubURI = '/v1/orders' + '/';
    private  static String finalOrderURI;
    private static Map<String, String> mapHeader ;
    private  static Direct_sales_order_settings__c directSalesSettings;
    private static Id orderId ;
    private static Decimal sumOrderItemNetTotal = 0; // sum of all oli SBQQ_NetTotal__c
    private static Decimal sumTaxAmt = 0; // sum of all oli SBQQ__TaxAmount__c  
    private static HttpResponse res ;
    private static Boolean successFlag ;
    private static boolean run1 = true;
    private static boolean isFromTaxcalutaionContext; 
    private static boolean isPostOrder; 
    
    private static List<order> orderList = new List<Order>();
    private static List<orderItem> orderItemList = new List<orderItem>();
    public static List<SAP_BP__c> updateSapBpList  = new List<SAP_BP__c>();
    public static Opportunity oppObj= new opportunity();
    
    public  static void  init(){
        // creating Header for API 
        mapHeader = new Map<String, String>();
        mapHeader.put('Content-Type','application/json');
        // fetching domain name from custome seeting 
        directSalesSettings = Direct_sales_order_settings__c.getOrgDefaults();       
        system.debug('directSalesSettings-'+directSalesSettings);                      
        if (directSalesSettings != null) {
            domain = (String) directSalesSettings.get('OrderHub_post_order_domain__c');
            finalOrderURI = domain +  orderHubURI ;
            System.debug('domain-'+domain);
            // && directSalesSettings.get('Send_Email_on_failure__c') && String.isNotBlank(directSalesSettings.get('Alert_Email_Addresses__c'))  
            System.debug('Send_Email_on_failure__c-'+directSalesSettings.get('Send_emails_on_failure__c'));
        }
    }
    /**
* postOrderOnOrderHubMethod description
* @param  listOrder                 listOrder description
* @param  listOrderItem             listOrderItem description : we eill get in in every case (retry and trigger)
* @param  isFromTaxcalutaionContext isFromTaxcalutaionContext description //TODO: if true then update OrderLI & Order
* @param  isFromTaxcalutaionContext isPostOrder description //TODO: if true then post order 
*/ 
    public void postOrderOnOrderHubMethod( List<Order> listOrder ,List<OrderItem> listOrderItem,  boolean isFromTaxcalutaionContext, boolean isPostOrder , opportunity passdOpp , List<SAP_BP__c> passdUpdateSapBpList ){
        isFromTaxcalutaionContext = isFromTaxcalutaionContext;
        isPostOrder = isPostOrder;
        if(listOrder!= NULL && !listOrder.isEmpty()){
            orderList.addAll(listOrder);
            system.debug('orderList.size()-'+orderList.size());
        }
        if(listOrderItem!= NULL && !listOrderItem.isEmpty()){
            orderItemList.addAll(listOrderItem);
            system.debug('orderItemList.size()-'+orderItemList.size());
        }
        if(passdUpdateSapBpList != NULL) updateSapBpList.addAll(passdUpdateSapBpList);
        system.debug('updateSapBpList.size()-'+updateSapBpList.size());
        oppObj = passdOpp;
        try{     
            if(runOnce1()){
                if(isPostOrder == true){  
                    
                    Id orderId ;
                    Boolean flag = false ;
                    Boolean flagNOPending = true ;
                    Boolean flagQuotetype = false ;
                    System.debug('init');
                    System.debug('trigger ');
                    system.debug('listOrder-'+listOrder);
                    init();    
                    if(listOrder!= NULL && !listOrder.isEmpty() && passdOpp!= NULL){
                        String mssgStr = listOrder.get(0).Message__c;
                        if (String.isBlank(mssgStr) ) mssgStr = ' msg'; // to escape null pointer
                        // only 1 order will come Message__c  && listOrder.get(0).Message__c .containsIgnoreCase('Posting order to order hub'
                        if ( !mssgStr.containsIgnoreCase('Posting order to order hub-Success')) {
                            orderId = listOrder.get(0).Id;
                            Id quoteRecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Automated eBook Direct Sales Orders').getRecordTypeId();
                            //Siddhant
                            Id BPCquoteRecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('T&F - BPC Quote Type').getRecordTypeId();
                            Id quoteOARecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('T&F - OA Journal Quote').getRecordTypeId();
                            if(quoteRecordTypeId!=NULL  && !listOrderItem.isEmpty() ) {
                                for(  OrderItem orderItemObj :listOrderItem){
                                    System.debug('orderItemObj.SBQQ_NetTotal__c-'+orderItemObj.SBQQ_NetTotal__c);
                                    sumOrderItemNetTotal = sumOrderItemNetTotal + orderItemObj.SBQQ_NetTotal__c;
                                    sumTaxAmt = sumTaxAmt + orderItemObj.SBQQ__TaxAmount__c;
                                }
                                Order ord = listOrder.get(0);                        
                                List<Opportunity> listName = new List<Opportunity>();
                                // System.debug('ord.Opportunity-'+ord.Opportunity);
                                List<opportunity> listOpp = new List<opportunity>();
                                List<SBQQ__Quote__c> listQuote = new List<SBQQ__Quote__c>();
                                //if(ord.OpportunityId!= NULL) listOpp = [ SELECT id,Sold_to_BP__c,Ship_to_BP__c,Bill_to_BP__c,Payer_BP__c,StageName,AccountId FROM opportunity WHERE  id = :ord.OpportunityId LIMIT 1 ];
                                listOpp.add(passdOpp);
                                //added Invoice_Format__c field as pers SFAL : 33(shubham kumar)
                                if(ord.SBQQ__Quote__c!= NULL) listQuote = [ SELECT Name,DOI__c,SBQQ__Notes__c, RecordTypeId,id,SBQQ__Status__c,SBQQ__Primary__c,Quote_Type__c,Purchase_Order_Number__c,Invoice_Format__c FROM SBQQ__Quote__c WHERE  id = :ord.SBQQ__Quote__c LIMIT 1 ];
                                System.debug('listQuote.get(0).Invoice_Format__c-'+listQuote.get(0).Invoice_Format__c);
                                System.debug('listQuote.get(0).SBQQ__Status__c-'+listQuote.get(0).SBQQ__Status__c);
                                System.debug('listOpp.get(0).StageName-'+listOpp.get(0).StageName);
                                System.debug('listQuote.get(0).SBQQ__Primary__c-'+listQuote.get(0).SBQQ__Primary__c);
                                system.debug('listQuote.get(0).RecordTypeID '+listQuote.get(0).RecordTypeID);
                                if (!listOpp.isEmpty() && !listQuote.isEmpty() && listOpp.get(0).accountId != null) {
                                    //accepted quote  && CW opp 
                                    //Siddhant
                                    if((listOpp.get(0).Order_Status__c == 'Pending' || listOpp.get(0).Order_Status__c == 'Failed') && listQuote.get(0).SBQQ__Primary__c == true && (listQuote.get(0).RecordTypeID == quoteRecordTypeId || listQuote.get(0).RecordTypeID == BPCquoteRecordTypeId || listQuote.get(0).RecordTypeID == quoteOARecordTypeId)) {
                                        flag = true ; 
                                    }
                                    
                                    // No pending records 
                                    Set<Id> setSapbpIds = new Set<Id>();
                                    setSapbpIds.add(listOpp.get(0).Sold_to_BP__c);
                                    setSapbpIds.add(listOpp.get(0).Ship_to_BP__c);
                                    setSapbpIds.add(listOpp.get(0).Bill_to_BP__c);
                                    setSapbpIds.add(listOpp.get(0).Payer_BP__c);
                                    // List<SAP_BP__c> listSapDb = new List<SAP_BP__c>([select id, name ,Email__c, Street__c,Region__c,City__c,State__c,Country__c,ZIP__c  from SAP_BP__c WHERE id In:setSapbpIds]);
                                    for (SAP_BP__c spobj : updateSapBpList) {
                                        // || (spobj.name!= null && spobj.name.containsIgnoreCase('PENDING')
                                        if( spobj.name == 'PENDING'  ){
                                            // can not go ahead 
                                            System.debug('can not do callout ');
                                            flagNOPending = false ;
                                        }
                                    } 
                                    
                                    // if (listQuote.get(0).Quote_Type__c == 'Direct Sale'|| listQuote.get(0).Quote_Type__c == 'Agent eBook orders' ) {
                                    //     flagQuotetype = true ; 
                                    // }
                                    // Siddhant
                                    if (ord.Order_Channel__c == 'EBK DIRECT SALES'|| ord.Order_Channel__c == 'EBK AGENT SALES' || ord.Order_Channel__c == 'OA_EBK_CHARGES' || listQuote.get(0).RecordTypeID == quoteOARecordTypeId) {
                                        flagQuotetype = true ; 
                                    }
                                    System.debug('flag-'+flag);
                                    System.debug('flagNOPending-'+flagNOPending);
                                    System.debug('flagQuotetype-'+flagQuotetype); // TODO: && flagNOPending == true
                                    if (flag == true  && flagQuotetype == true && flagNOPending == true) {                    
                                        HttpResponse resOrderPosted = null;
                                        string body =  initBody(ord  ,listQuote.get(0) ,listOrderItem , listOpp.get(0) );
                                        // call tax calculation also 
                                        if(String.isNotBlank(body) ) callOh(finalOrderURI, body, mapHeader ,orderId , true);
                                        else {
                                            System.debug('No request body found ');
                                        }
                                    }else{
                                        sendEmail(listOrder.get(0).Message__c , ' ' , orderId);
                                        //updateReqObjs(listOrder, listOrderItem, null,oppObj  ,updateSapBpList);
                                    }
                                }                          
                            }
                        } 
                    }                                       
                } // if do not need to call post order update 
                else if( isFromTaxcalutaionContext == True ) {
                    // update the oli & order 
                    //updateReqObjs(listOrder, listOrderItem, null,oppObj  ,updateSapBpList);
                    //sendEmail(listOrder.get(0).Message__c , ' ' , orderId);
                    //Send email if there is any error in tax calculation
                    sendEmail(TF_OrderTaxCalculation_Handler.errorMessageTax, TF_OrderTaxCalculation_Handler.errorHttpResponseTax, orderId); 
                }
            }
        } catch (Exception ex ) {
            System.debug(String.valueOf(' Exception Type :-'+ex.getTypeName()+' ** Message:-'+ex.getMessage()+' ** Line Number:-'+ex.getLineNumber()+' ** Stack Trace :- '+ ex.getStackTraceString()));
            sendEmail('Posting order to order hub-Failed :-'+ex.getMessage(), ' ' , orderId);
            // errorHandling ( ex,NULL );
        }         
        
    }
    
    @TestVisible 
    private String initBody(Order orderObj , SBQQ__Quote__c quot , list<OrderItem> ListOrderItem , Opportunity opp){
        //Siddhant
        Id BPCquoteRecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('T&F - BPC Quote Type').getRecordTypeId();
        Id quoteOARecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('T&F - OA Journal Quote').getRecordTypeId();
        Id orderId = orderObj.id;
        try {                    
            List<Order> listOrderDb = new List<Order>();
            if ( orderObj!= NULL && quot!= NULL) {   
                TF_PostOrderOnOrderHubWrapRequest tF_PostOrderOnOrderHubWrapRequestObj = new TF_PostOrderOnOrderHubWrapRequest();
                // TF_PostOrderOnOrderHubWrapRequest.OrderRequest OrderRequestObj  = new TF_PostOrderOnOrderHubWrapRequest.OrderRequest();
                TF_PostOrderOnOrderHubWrapRequest.billingAddress BillingAddressesObj  = new TF_PostOrderOnOrderHubWrapRequest.billingAddress();
                TF_PostOrderOnOrderHubWrapRequest.shippingAddress ShippingAddressObj  = new TF_PostOrderOnOrderHubWrapRequest.shippingAddress();            
                TF_PostOrderOnOrderHubWrapRequest.fulfillments fulfillmentsObj  = new TF_PostOrderOnOrderHubWrapRequest.fulfillments();            
                List<TF_PostOrderOnOrderHubWrapRequest.fulfillments> listFulfillmentsObj  = new List<TF_PostOrderOnOrderHubWrapRequest.fulfillments>();     
                
                List<TF_PostOrderOnOrderHubWrapRequest.orderedItem> listOrderedItemObj  = new List<TF_PostOrderOnOrderHubWrapRequest.orderedItem>();            
                
                tF_PostOrderOnOrderHubWrapRequestObj.orderType = 'SALES' ;//orderObj.Type ; ^
                if(quot != NULL){
                    // orderObj.Order_Channel__c == 'EBK DIRECT SALES'|| orderObj.Order_Channel__c == 'EBK AGENT SALES'
                    if(orderObj.Order_Channel__c == 'EBK DIRECT SALES' ) tF_PostOrderOnOrderHubWrapRequestObj.channel =  'EBK_DIRECT_SALES' ;
                    if(orderObj.Order_Channel__c == 'EBK AGENT SALES' ) tF_PostOrderOnOrderHubWrapRequestObj.channel =  'EBK_AGENT_SALES' ;
                    //Siddhant
                    if(orderObj.Order_Channel__c == 'OA_EBK_CHARGES' ) tF_PostOrderOnOrderHubWrapRequestObj.channel =  'OA_EBK_CHARGES' ;
                    if(quot.RecordTypeID == quoteOARecordTypeId) tF_PostOrderOnOrderHubWrapRequestObj.channel =  'ASC' ;
                }
                tF_PostOrderOnOrderHubWrapRequestObj.externalOrderRef =  (quot.Purchase_Order_Number__c == NULL ? orderObj.OrderNumber : quot.Purchase_Order_Number__c ); //^
                tF_PostOrderOnOrderHubWrapRequestObj.externalSystemRefId =  orderObj.OpportunityId ; // ^
                //tF_PostOrderOnOrderHubWrapRequestObj.notes = quot.SBQQ__Notes__c;  // orderObj.^
                if(String.isNotBlank(quot.SBQQ__Notes__c) && quot.SBQQ__Notes__c.contains('\n')){
                    List<String> quoteNotesList  = quot.SBQQ__Notes__c.split('\n');
                    String notesListStr = '';
                    if(!quoteNotesList.isEmpty()){
                        for(String item : quoteNotesList ){
                            item = item.replace('\r',' ');
                            notesListStr += item+' ';
                        }
                    }
                    tF_PostOrderOnOrderHubWrapRequestObj.notes = notesListStr;
                }
                else tF_PostOrderOnOrderHubWrapRequestObj.notes = quot.SBQQ__Notes__c;  // orderObj.^
                tF_PostOrderOnOrderHubWrapRequestObj.quoteNumber =  quot.Name  ;
                //added by shubhm kumar story SFAL-33
                tF_PostOrderOnOrderHubWrapRequestObj.invoiceFormat =  quot.Invoice_Format__C;
                
                tF_PostOrderOnOrderHubWrapRequestObj.confirmationNumber =  orderObj.OrderNumber ;
                // fetch customer id from account 
                
                List<Account> listacc = new List<Account>([ SELECT id,Customer_Id__c FROM account WHERE  id =:opp.accountId LIMIT 1 ]);
                tF_PostOrderOnOrderHubWrapRequestObj.customerId = (listacc.get(0).Customer_Id__c == NULL ? '': listacc.get(0).Customer_Id__c );
                System.debug('listacc-'+listacc);
                System.debug('listacc-'+orderObj.accountId);
                
                // tF_PostOrderOnOrderHubWrapRequestObj.shipCustId =  listacc.get(0). ;  
                
                tF_PostOrderOnOrderHubWrapRequestObj.orderDate =  string.valueof(orderObj.CreatedDate) ;
                //tF_PostOrderOnOrderHubWrapRequestObj.invoiceFormat =  string.valueof(orderObj.CreatedDate) ;
                tF_PostOrderOnOrderHubWrapRequestObj.orderPrice =  (sumOrderItemNetTotal == null ? 0 : sumOrderItemNetTotal  ); //orderObj.SBQQ_TotalAmount__c ; ^
                tF_PostOrderOnOrderHubWrapRequestObj.orderStatus = 'OPEN'; //orderObj.Status ; ^
                tF_PostOrderOnOrderHubWrapRequestObj.seller = 'TANDF'; //orderObj.Order_Seller__c ; ^
                // remove dis & discn code 
                tF_PostOrderOnOrderHubWrapRequestObj.subTotalPrice =  orderObj.TotalAmount ;
                tF_PostOrderOnOrderHubWrapRequestObj.totalTax =    (sumTaxAmt ==NULL ? 0 : sumTaxAmt);        
                
                List<SAP_BP__c> listSap = new List<SAP_BP__c>([SELECT name, Region__c,State__c,Street__c,ZIP__c,City__c,Country__c,Status__c,Email__c,First_Name__c,Last_Name__c,Department_Id__c,Account_Id__c,Campus_Id__c,Address_Type__c,Department__c,Tax_Registration_Number__c,Care_of__c,Tax_Number_Category__c FROM SAP_BP__c where id=:opp.Bill_to_BP__c]);
                
                // fetching the bill to  & ship to  sap bp number from the list passed here 
                SAP_BP__c sapBillToUpdatedBpNumber ;
                SAP_BP__c sapShipToUpdatedBpNumber ;
                id oppBillSapId = oppObj.Bill_to_BP__c ;
                id oppShipSapId = oppObj.Ship_to_BP__c ;
                for (SAP_BP__c sapObj  : updateSapBpList) {
                    if (sapObj.id == oppBillSapId  ) {
                        sapBillToUpdatedBpNumber = sapObj;
                    }
                    if (sapObj.id == oppShipSapId  ) {
                        sapShipToUpdatedBpNumber = sapObj;
                    }
                }
                
                System.debug('sapBillToUpdatedBpNumber-'+sapBillToUpdatedBpNumber);  
                System.debug('sapShipToUpdatedBpNumber-'+sapShipToUpdatedBpNumber);
                
                if ( !listSap.isEmpty()) {                    
                    Id reqSobjId ;
                    String addressType = listSap.get(0).Address_Type__c; 
                    String sObjectName ; 
                    String query = 'SELECT id ' ;
                    if(listSap.get(0).Account_Id__c != NULL && String.isNotBlank(addressType) && addressType.containsIgnoreCase('Account')  ) 
                    {
                        reqSobjId =  listSap.get(0).Account_Id__c; 
                        sObjectName = 'Account';
                        query = query + ',Customer_Id__c FROM account WHERE id =:reqSobjId LIMIT 1' ; 
                    }
                    if(listSap.get(0).Department_Id__c != NULL && String.isNotBlank(addressType) && addressType=='Department' ) 
                    {
                        reqSobjId = listSap.get(0).Department_Id__c;
                        sObjectName = 'Department__c';
                        query = query + ',account__c  FROM Department__c WHERE id =:reqSobjId LIMIT 1' ;
                    }
                    if(listSap.get(0).Campus_Id__c != NULL && String.isNotBlank(addressType) && addressType=='Campus' )
                    {
                        reqSobjId = listSap.get(0).Campus_Id__c;
                        sObjectName = 'Campus__c';
                        query = query + ',account__c  FROM Campus__c WHERE id =:reqSobjId LIMIT 1' ;
                    } 
                    List<SObject> listSobj = new List<SObject>();
                    listSobj = Database.query(query);
                    if (reqSobjId != NULL && !listSobj.isEmpty()) {      
                        
                        if ( !listSobj.isEmpty() && String.isNotBlank(addressType) && addressType.containsIgnoreCase('Account') ) {
                            tF_PostOrderOnOrderHubWrapRequestObj.buyerId =String.valueOf( (listSobj.get(0).get('Customer_Id__c') == NULL ? '' : listSobj.get(0).get('Customer_Id__c')) );
                        }    
                        else if ( String.isNotBlank(addressType) && (addressType=='Campus' || addressType=='Department' ) ) {
                            id accountId = (Id)listSobj.get(0).get('account__c');
                            if( accountId != NULL ){                            
                                List<Account> listAccBuyerId  = new List<Account>([SELECT id,Customer_Id__c FROM account WHERE id =:accountId LIMIT 1]);
                                tF_PostOrderOnOrderHubWrapRequestObj.buyerId = (listAccBuyerId.get(0).Customer_Id__c == NULL ? '' : listAccBuyerId.get(0).Customer_Id__c );
                            } 
                        }
                        
                        
                    }
                    
                    //Shalini(ticket SAL-4154)- Doing these steps to pass the address in the same formate as we passed while creating the SAP record
                    sapCreationTimeAddressDetailsWrap sapCreationTimeAddressDetailsWrapObj = new sapCreationTimeAddressDetailsWrap();
                    //Call address formatting method and we are doing these steps because of char limit on invoice
                    sapCreationTimeAddressDetailsWrapObj = mapAddressvalues(listSap.get(0));
                    if(sapCreationTimeAddressDetailsWrapObj != null)
                    {
                        /*BillingAddressesObj.addressLine1 = ( String.isNotBlank(sapCreationTimeAddressDetailsWrapObj.addressLine1) ? sapCreationTimeAddressDetailsWrapObj.addressLine1 : null );
BillingAddressesObj.addressLine2 = ( String.isNotBlank(sapCreationTimeAddressDetailsWrapObj.addressLine2) ? sapCreationTimeAddressDetailsWrapObj.addressLine2 : null );
BillingAddressesObj.addressLine3 = ( String.isNotBlank(sapCreationTimeAddressDetailsWrapObj.addressLine3) ? sapCreationTimeAddressDetailsWrapObj.addressLine3 : null );
*/
                        BillingAddressesObj.addressLine1 = sapCreationTimeAddressDetailsWrapObj.addressLine1;
                        BillingAddressesObj.addressLine2 = sapCreationTimeAddressDetailsWrapObj.addressLine2;
                        BillingAddressesObj.addressLine3 = sapCreationTimeAddressDetailsWrapObj.addressLine3;
                        BillingAddressesObj.addressOrganisation =  sapCreationTimeAddressDetailsWrapObj.addressOrganisation;
                    }
                    BillingAddressesObj.taxRegistrationNumber =  listSap.get(0).Tax_Registration_Number__c;
                    //BillingAddressesObj.taxCategory =  listSap.get(0).Tax_Number_Category__c;
                    if(sapBillToUpdatedBpNumber != NULL) BillingAddressesObj.taxCategory = sapBillToUpdatedBpNumber.Tax_Number_Category__c; 
                    BillingAddressesObj.careOf =  listSap.get(0).Care_of__c;
                    BillingAddressesObj.addressContactFirstName =  listSap.get(0).First_Name__c;
                    BillingAddressesObj.addressContactLastName =  listSap.get(0).Last_Name__c; 
                    //BillingAddressesObj.addressLine1 =  listSap.get(0).Street__c;
                    //Shalini changes end
                    BillingAddressesObj.addressCountry =  listSap.get(0).Country__c;
                    BillingAddressesObj.addressLocality =  listSap.get(0).City__c;
                    BillingAddressesObj.addressRegion =  listSap.get(0).State__c;
                    BillingAddressesObj.addressContactName =  listSap.get(0).First_Name__c + ' '+ listSap.get(0).Last_Name__c ;
                    BillingAddressesObj.addressContactEmail =  listSap.get(0).Email__c;
                    BillingAddressesObj.postalCode =  listSap.get(0).ZIP__c;
                    
                    if(sapBillToUpdatedBpNumber != NULL) BillingAddressesObj.businessPartnerNo = sapBillToUpdatedBpNumber.name;    //listSap.get(0).name; 
                    List<Country__c> listCountry = new List<Country__c>([SELECT Country_2__c, Name FROM Country__c where Name like :listSap.get(0).Country__c limit 1]);
                    if(!listCountry.isEmpty()) BillingAddressesObj.countryCode = listCountry.get(0).Country_2__c; 
                    //Siddhant
                    if(quot.RecordTypeID == quoteOARecordTypeId){
                        BillingAddressesObj.externalCustomerAddressId = quot.Id;
                        if(BillingAddressesObj.countryCode == null){
                            BillingAddressesObj.countryCode = 'AZ';
                        }
                    }
                    // BillingAddressesObj.externalCustomerAddressId =  listSap.get(0).  
                    // tF_PostOrderOnOrderHubWrapRequestObj.channel == 'EBK_AGENT_SALES'
                    if (true) {
                        // populate the shipping address
                        List<SAP_BP__c> listSapShip = new List<SAP_BP__c>([SELECT name, Region__c,State__c,Street__c,ZIP__c,City__c,Country__c,Status__c,Email__c,First_Name__c,Last_Name__c,Department_Id__c,Account_Id__c,Campus_Id__c,Address_Type__c,Department__c,Tax_Registration_Number__c,Care_of__c,Tax_Number_Category__c FROM SAP_BP__c where id=:opp.Ship_to_BP__c]);
                        if ( !listSapShip.isEmpty() ) {      
                            
                            //Shalini(ticket SAL-4154)- Doing these steps to pass the address in the same formate as we passed while creating the SAP record
                            sapCreationTimeAddressDetailsWrap sapCreationTimeAddressDetailsWrapShipObj = new sapCreationTimeAddressDetailsWrap();
                            //Call address formatting method and we are doing these steps because of char limit on invoice
                            sapCreationTimeAddressDetailsWrapShipObj = mapAddressvalues(listSapShip.get(0));
                            if(sapCreationTimeAddressDetailsWrapShipObj != null)
                            {
                                /*ShippingAddressObj.addressLine1 = ( String.isNotBlank(sapCreationTimeAddressDetailsWrapObj.addressLine1) ? sapCreationTimeAddressDetailsWrapObj.addressLine1 : null );
ShippingAddressObj.addressLine2 = ( String.isNotBlank(sapCreationTimeAddressDetailsWrapObj.addressLine2) ? sapCreationTimeAddressDetailsWrapObj.addressLine2 : null );
ShippingAddressObj.addressLine3 = ( String.isNotBlank(sapCreationTimeAddressDetailsWrapObj.addressLine3) ? sapCreationTimeAddressDetailsWrapObj.addressLine3 : null );
*/
                                ShippingAddressObj.addressLine1 = sapCreationTimeAddressDetailsWrapShipObj.addressLine1;
                                ShippingAddressObj.addressLine2 = sapCreationTimeAddressDetailsWrapShipObj.addressLine2;
                                ShippingAddressObj.addressLine3 = sapCreationTimeAddressDetailsWrapShipObj.addressLine3;
                                ShippingAddressObj.addressOrganisation =  sapCreationTimeAddressDetailsWrapShipObj.addressOrganisation;
                            }
                            ShippingAddressObj.taxRegistrationNumber =  listSapShip.get(0).Tax_Registration_Number__c;
                            //ShippingAddressObj.taxCategory =  listSapShip.get(0).Tax_Number_Category__c;
                            if(sapShipToUpdatedBpNumber != NULL) ShippingAddressObj.taxCategory = sapShipToUpdatedBpNumber.Tax_Number_Category__c; 
                            ShippingAddressObj.careOf =  listSapShip.get(0).Care_of__c;
                            ShippingAddressObj.addressContactFirstName =  listSapShip.get(0).First_Name__c;
                            ShippingAddressObj.addressContactLastName =  listSapShip.get(0).Last_Name__c;
                            //ShippingAddressObj.addressLine1 =  listSapShip.get(0).Street__c;
                            //Shalini changes end
                            
                            ShippingAddressObj.addressCountry =  listSapShip.get(0).Country__c;
                            ShippingAddressObj.addressLocality =  listSapShip.get(0).City__c;
                            ShippingAddressObj.addressRegion =  listSapShip.get(0).State__c;
                            ShippingAddressObj.addressContactName =  listSapShip.get(0).First_Name__c + ' '+ listSapShip.get(0).Last_Name__c ;
                            ShippingAddressObj.addressContactEmail =  listSapShip.get(0).Email__c;
                            ShippingAddressObj.postalCode =  listSapShip.get(0).ZIP__c;
                            if(sapShipToUpdatedBpNumber != NULL)ShippingAddressObj.businessPartnerNo = sapShipToUpdatedBpNumber.name; //  ( string.isBlank(listSapShip.get(0).name) ? '' : listSapShip.get(0).name ); //^
                            List<Country__c> listCountryShip = new List<Country__c>([SELECT Country_2__c, Name FROM Country__c where Name like :listSapShip.get(0).Country__c limit 1]);
                            if(!listCountryShip.isEmpty()) ShippingAddressObj.countryCode = listCountryShip.get(0).Country_2__c  ; 
                            // ShippingAddressObj.externalCustomerAddressId =  listSapShip.get(0).
                        }else{    
                            ShippingAddressObj = Null;
                        }
                    }else {
                        ShippingAddressObj = Null;
                    }
                }else {
                    BillingAddressesObj = NUll;
                }
                
                //  fulfillments  orderedItemObj  fulfillmentsObj
                //  Siddhant
                if(quot.RecordTypeID != BPCquoteRecordTypeId && quot.RecordTypeID != quoteOARecordTypeId){
                    fulfillmentsObj.termEndDate = null;
                    fulfillmentsObj.licenseType = 'perpetual';
                    fulfillmentsObj.termStartDate = null;
                    fulfillmentsObj.description = 'UBX Title Purchase';
                    List<String> listStr = new List<String>();
                    listStr.add('viewOnline');
                    listStr.add('download');
                    fulfillmentsObj.grantType = listStr;
                    fulfillmentsObj.name = 'UBX Title Purchase'; 
                    listFulfillmentsObj.add(fulfillmentsObj);
                }
                // orderedItemObj            
                // populating the order Items 
                // ISBN__c SBQQ_NetTotal__c Discount_Amount__c SBQQ__OrderedQuantity__c SBQQ__TaxCode__c SBQQ__OrderedQuantity__c   SBQQ__TaxAmount__c CurrencyIsoCode ListPrice
                for ( OrderItem ordItm : ListOrderItem){
                    //SFAL 51 added by shubham kumar
                    
                    TF_PostOrderOnOrderHubWrapRequest.orderedItem orderedItemObj  = new TF_PostOrderOnOrderHubWrapRequest.orderedItem();
                    /*if(ordItm.SBQQ__QuoteLine__r.SBQQ__Bundled__c == true){
//Api call to get the bundle items corresponding to the bundle id..
List<String> PcmIsbnNumbers = TF_CreateBundle.getproductListfromPCM(ordItm.PCM_UUID__c);
List<OrderItem> orderProductsListfromBundle = new List<OrderItem>([select Id,SBQQ__QuoteLine__r.SBQQ__Bundled__c, SBQQ__QuotedListPrice__c, Total_Discount_Percentage__c, OrderId, OrderItemNumber, Quantity, UnitPrice, Product2Id,PCM_ISBN__c,PCM_DOI__c,PCM_UUID__c,PCM_Type__c,Order.RecordTypeId   FROM OrderItem where PCM_ISBN__c IN : PcmIsbnNumbers]);
integer ItemsInBundle = orderProductsListfromBundle.size();
integer currentitemIndex = 0;
Decimal totalchildListPrice = 0;
for (OrderItem BundledordItm : orderProductsListfromBundle){
currentitemIndex++;
//As of Now no field values for bundle
orderedItemObj.productId = BundledordItm.ISBN__c;
orderedItemObj.salesOrg =  'IN01';
orderedItemObj.price = (BundledordItm.SBQQ__QuotedListPrice__c == NULL ? 0 : BundledordItm.SBQQ__QuotedListPrice__c) ;// ^   // ( ==NULL ? 0 : ) ;    
orderedItemObj.discountCode = NULL; 
//Discount being mapped to bundle discount
orderedItemObj.discount = (ordItm.Total_Discount_Percentage__c ==NULL ? 0 : ordItm.Total_Discount_Percentage__c)  ;               
orderedItemObj.discountCurrency = ordItm.CurrencyIsoCode;   
orderedItemObj.lineItemType = 'DIRECT-EBOOK';  
orderedItemObj.salesType = 'PURCHASE';  
orderedItemObj.discountAmount = (orderedItemObj.price)*(ordItm.Total_Discount_Percentage__c); 
totalchildListPrice = totalchildListPrice + orderedItemObj.sellingPrice;
//avoiding the round off issue by
if (currentitemIndex == ItemsInBundle){
//selling price of orderItemRequired.
orderedItemObj.sellingPrice =  (ordItm.SBQQ__QuotedListPrice__c  -  totalchildListPrice) ;
}else{
orderedItemObj.sellingPrice =  (orderedItemObj.price  -  orderedItemObj.discountAmount) ;
}

//orderedItemObj.sellingPrice =  (orderedItemObj.price  -  orderedItemObj.discountAmount) ;
orderedItemObj.orderedQuantity = ( BundledordItm.SBQQ__OrderedQuantity__c ==NULL ? 0 : BundledordItm.SBQQ__OrderedQuantity__c)  ;
orderedItemObj.taxCode = BundledordItm.SBQQ__TaxCode__c;
orderedItemObj.quantity =  (BundledordItm.SBQQ__OrderedQuantity__c ==NULL ? 0 : BundledordItm.SBQQ__OrderedQuantity__c );
orderedItemObj.taxAmount = (orderedItemObj.sellingPrice)*ordItm.Total_Discount_Percentage__c;
orderedItemObj.currencyy = BundledordItm.CurrencyIsoCode;
orderedItemObj.description = BundledordItm.Line_reference__c;
// ((ordItm.ListPrice == NULL ? 0 : ordItm.ListPrice ) - (ordItm.Discount_Amount__c == NUll ? 0 : ordItm.Discount_Amount__c));
}
}else{}*/
                    orderedItemObj.productId = ordItm.ISBN__c;
                    orderedItemObj.salesOrg =  'IN01';
                    orderedItemObj.price = (ordItm.SBQQ__QuotedListPrice__c == NULL ? 0 : ordItm.SBQQ__QuotedListPrice__c) ;// ^   // ( ==NULL ? 0 : ) ;    
                    orderedItemObj.discountCode = NULL;//^  
                    orderedItemObj.discount = (ordItm.Total_Discount_Percentage__c ==NULL ? 0 : ordItm.Total_Discount_Percentage__c)  ;               
                    orderedItemObj.discountCurrency = ordItm.CurrencyIsoCode;   
                    orderedItemObj.lineItemType = 'DIRECT-EBOOK';  
                    orderedItemObj.salesType = 'PURCHASE';  
                    orderedItemObj.discountAmount = ( ordItm.Total_Discount_Amount__c ==NULL ? 0 :ordItm.Total_Discount_Amount__c ) ;
                    orderedItemObj.orderedQuantity = ( ordItm.SBQQ__OrderedQuantity__c ==NULL ? 0 : ordItm.SBQQ__OrderedQuantity__c)  ;
                    orderedItemObj.taxCode = ordItm.SBQQ__TaxCode__c;
                    orderedItemObj.quantity =  (ordItm.SBQQ__OrderedQuantity__c ==NULL ? 0 : ordItm.SBQQ__OrderedQuantity__c );
                    orderedItemObj.taxAmount = (ordItm.SBQQ__TaxAmount__c == NULL ? 0 :ordItm.SBQQ__TaxAmount__c);
                    orderedItemObj.currencyy = ordItm.CurrencyIsoCode;
                    orderedItemObj.description = ordItm.Line_reference__c;
                    orderedItemObj.sellingPrice =  (ordItm.SBQQ_NetTotal__c == NULL ? 0 : ordItm.SBQQ_NetTotal__c) ; // ((ordItm.ListPrice == NULL ? 0 : ordItm.ListPrice ) - (ordItm.Discount_Amount__c == NUll ? 0 : ordItm.Discount_Amount__c));
                    
                    
                    //Siddhant
                    if(quot.RecordTypeID == BPCquoteRecordTypeId){
                        List<Integer> sponsorRefIdList = new List<Integer>(); 
                        Integer RefId = 1;
                        sponsorRefIdList.add(RefId);
                        //Shalini- changed because according to the contract in productId we have to map UUid and in altProductId we have to map ISBN for book and chapter both
                        /*if(ordItm.PCM_ISBN__c != null){
orderedItemObj.productId = ordItm.PCM_ISBN__c;
orderedItemObj.altProductId = ordItm.PCM_ISBN__c;
orderedItemObj.lineItemType = 'EBOOK'; 
}
else if(ordItm.PCM_DOI__c != null){
orderedItemObj.productId = ordItm.PCM_DOI__c;
orderedItemObj.altProductId = ordItm.PCM_DOI__c;
orderedItemObj.lineItemType = 'EBK-CHAPTER';
}*/
                        /*orderedItemObj.productId = ordItm.PCM_UUID__c;
orderedItemObj.altProductId = ordItm.PCM_ISBN__c;
if(String.isNotBlank(ordItm.PCM_Type__c) && ordItm.PCM_Type__c.containsIgnoreCase('EBK-CHAPTER-FRONTLIST')){
orderedItemObj.lineItemType = 'EBK-CHAPTER-FRONTLIST';
}
else if(String.isNotBlank(ordItm.PCM_Type__c) && ordItm.PCM_Type__c.containsIgnoreCase('book')){
orderedItemObj.lineItemType = 'EBOOK'; 
}
else if(String.isNotBlank(ordItm.PCM_Type__c) && ordItm.PCM_Type__c.containsIgnoreCase('chapter')){
orderedItemObj.lineItemType = 'EBK-CHAPTER';
}*/
                        orderedItemObj.productId = ordItm.PCM_UUID__c;
                        orderedItemObj.altProductId = ordItm.PCM_ISBN__c;
                        
                        //Shalini: changes for frontlist eBook ticket SAL-4328
                        if(String.isNotBlank(orderObj.BPC_Order_Type__c) && orderObj.BPC_Order_Type__c == 'Frontlist eBook')
                        {
                            if(String.isNotBlank(ordItm.PCM_Type__c) && ordItm.PCM_Type__c == 'EBOOK-FRONTLIST')
                                orderedItemObj.lineItemType = 'EBOOK-FRONTLIST';
                            else{
                                sendEmail('Posting order to order hub-Failed :-'+ orderObj.BPC_Order_Type__c +' Type Order contains different type of product.', ' ',orderId );  
                                return null;
                            }
                        }
                        if(String.isNotBlank(orderObj.BPC_Order_Type__c) && orderObj.BPC_Order_Type__c == 'Frontlist Chapter')
                        {
                            if(String.isNotBlank(ordItm.PCM_Type__c) && ordItm.PCM_Type__c == 'EBK-CHAPTER-FRONTLIST')
                                orderedItemObj.lineItemType = 'EBK-CHAPTER-FRONTLIST';
                            else{
                                sendEmail('Posting order to order hub-Failed :-'+ orderObj.BPC_Order_Type__c +' Type Order contains different type of product.', ' ',orderId );  
                                return null;
                            }
                        }
                        else if(String.isNotBlank(orderObj.BPC_Order_Type__c) && orderObj.BPC_Order_Type__c == 'Backlist eBook')
                        {
                            if(String.isNotBlank(ordItm.PCM_Type__c) && ordItm.PCM_Type__c == 'book')
                                orderedItemObj.lineItemType = 'EBOOK'; 
                            else{
                                sendEmail('Posting order to order hub-Failed :-'+ orderObj.BPC_Order_Type__c +' Type Order contains different type of product.', ' ',orderId ); 
                                return null;
                            }
                        }
                        else if(String.isNotBlank(orderObj.BPC_Order_Type__c) && orderObj.BPC_Order_Type__c == 'Backlist Chapter')
                        {
                            if(String.isNotBlank(ordItm.PCM_Type__c) && ordItm.PCM_Type__c == 'chapter')
                                orderedItemObj.lineItemType = 'EBK-CHAPTER';
                            else{
                                sendEmail('Posting order to order hub-Failed :-'+ orderObj.BPC_Order_Type__c +' Type Order contains different type of product.', ' ',orderId ); 
                                return null;
                            }
                        }
                        //Shalini- changes end
                        orderedItemObj.sponsorRefId = sponsorRefIdList;
                        
                        orderedItemObj.salesType = 'OA-FEE';
                    }
                    if(quot.RecordTypeID == quoteOARecordTypeId){
                        if(ordItm.Product2.ProductCode != null && quot.DOI__c != null){
                            orderedItemObj.productId = ordItm.Product2.ProductCode+'_'+quot.DOI__c;  
                        }
                        else{
                            orderedItemObj.productId = 'NONE'; 
                        }
                        
                        orderedItemObj.lineItemType = 'Open Access Fee';
                    }
                    listOrderedItemObj.add(orderedItemObj);
                    System.debug('added oredered items -'+listOrderedItemObj);
                }
                //Siddhant
                
                if(quot.RecordTypeID == BPCquoteRecordTypeId){
                    Opportunity oppRec = new Opportunity();
                    oppRec = [Select id,Licence_Type__c,Funding_statement__c,Funding_program_name__c,Account.Customer_Id__c from Opportunity where Id =: opp.Id];
                    TF_PostOrderOnOrderHubWrapRequest.fundersponsor sponcerInfo = new TF_PostOrderOnOrderHubWrapRequest.fundersponsor();
                    List<TF_PostOrderOnOrderHubWrapRequest.fundersponsor> sponcerInfoList = new List<TF_PostOrderOnOrderHubWrapRequest.fundersponsor>();
                    sponcerInfo.refId = 1;
                    sponcerInfo.fundingStatement = oppRec.Funding_statement__c;
                    TF_PostOrderOnOrderHubWrapRequest.funderdetails detailsInfo = new TF_PostOrderOnOrderHubWrapRequest.funderdetails();
                    detailsInfo.name = oppRec.Funding_program_name__c;
                    detailsInfo.sfCustomerId = oppRec.Account.Customer_Id__c;
                    sponcerInfo.details = detailsInfo;
                    TF_PostOrderOnOrderHubWrapRequest.funderlicense licenseInfo = new TF_PostOrderOnOrderHubWrapRequest.funderlicense();
                    
                    //Shalini commented this existing license type logic and implement new logic of pulling these value from setting record
                    /*licenseInfo.description = 'ABC Test';
licenseInfo.type = 'open-access';
licenseInfo.location = 'http://creativecommons.org/licenses/by/4.0/';*/
                    List<Setting_Item__c> licenseTypeInfo = new List<Setting_Item__c>();
                    if(String.isNotBlank(oppRec.Licence_Type__c))
                    {
                        licenseTypeInfo = [Select id, Text_1__c, Text_2__c, Rich_Text_1__c, Setting__c from Setting_Item__c
                                           where Setting__r.name = 'Licence type for BPC' AND Text_1__c =: String.valueOf(oppRec.Licence_Type__c) Limit 1];
                        system.debug('licenseTypeInfo--> '+licenseTypeInfo);
                        if(licenseTypeInfo != null && !licenseTypeInfo.isEmpty())
                        {
                            licenseInfo.description = licenseTypeInfo.get(0).Rich_Text_1__c;
                            licenseInfo.type = 'open-access';
                            licenseInfo.location = licenseTypeInfo.get(0).Text_2__c;
                            sponcerInfo.license = licenseInfo;
                        }
                    }
                    //Shalini changes end regarding license type
                    sponcerInfoList.add(sponcerInfo);
                    tF_PostOrderOnOrderHubWrapRequestObj.sponsors  = sponcerInfoList;
                }
                
                // populating inner classes    
                tF_PostOrderOnOrderHubWrapRequestObj.billingAddress =  BillingAddressesObj; 
                tF_PostOrderOnOrderHubWrapRequestObj.shippingAddress =   ShippingAddressObj;
                tF_PostOrderOnOrderHubWrapRequestObj.orderedItem =   listOrderedItemObj;
                tF_PostOrderOnOrderHubWrapRequestObj.fulfillments =   listFulfillmentsObj;
                system.debug('tF_PostOrderOnOrderHubWrapRequestObj'+tF_PostOrderOnOrderHubWrapRequestObj);
                if(tF_PostOrderOnOrderHubWrapRequestObj != null) {
                    system.debug('tF_PostOrderOnOrderHubWrapRequestObj'+tF_PostOrderOnOrderHubWrapRequestObj);
                    String bodyReq = JSON.serializePretty(tF_PostOrderOnOrderHubWrapRequestObj);
                    return bodyReq.replace('"currencyy" :','"currency":');
                }
            }
            return null;
        } catch (Exception e) {
            System.debug('error -'+e.getMessage());
            sendEmail('Posting order to order hub-Failed :-'+ e.getMessage(), ' ',orderId );            
        }
        return null;
    }  
    
    /**
* callOh description       to do callout to post order 
* @param  finalOrderURI    finalOrderURI description
* @param  body             body description
* @param  mapHeader        mapHeader description
* @param  orderId          orderId description
*/ 
    public static void callOh(String finalOrderURI,String body, Map<String,String> mapHeader , Id orderId ,  boolean isFromTaxcalutaionContext){
        try {
            System.debug('calling Oh with body -'+ body);
            res = TF_PlatformExecuter.execute(finalOrderURI,'POST','idtoken', body, mapHeader, false);
            if (res.getStatusCode() == 201 || res.getStatusCode() == 200)
            {
                System.debug('****responseBody****!' + res.getBody());
                // deserialize here
                TF_CallOhResponse TF_CallOhResponseObj =(TF_CallOhResponse) System.JSON.deserialize(res.getBody(), TF_CallOhResponse.class);
                system.debug('TF_CallOhResponseObj.data.orderNumber-'+TF_CallOhResponseObj.data);
                system.debug('TF_CallOhResponseObj.metadata-'+TF_CallOhResponseObj.metadata);
                // populate order reference number 
                orderList.get(0).OrderReferenceNumber =  TF_CallOhResponseObj.data.orderNumber;   
                
                //TODO: if the succes update the message field , dont send email         
                updateReqObjs(orderList, orderItemList, 'Posting order to order hub-Success :-'+TF_CallOhResponseObj.metadata.message ,oppObj  ,updateSapBpList );
                //sendEmail(String.valueOf('Posting order to order hub-Success :-'+TF_CallOhResponseObj.metadata.message) , body, orderId);
                
                
            }
            else{
                System.debug('bad response-'+ res.getStatus());
                System.debug('bad res.getBody()-'+ res.getBody());
                TF_CallOhResponse TF_CallOhResponseObj =(TF_CallOhResponse) System.JSON.deserialize(res.getBody(), TF_CallOhResponse.class);
                successFlag = false ;
                sendEmail('Posting order to order hub-Failed :-'+ TF_CallOhResponseObj.metadata.message,body, orderId);
            }     
            
        } catch (Exception e) {
            System.debug('error -'+e.getMessage()+'----'+e.getLineNumber());
            successFlag = false ;
            sendEmail('Posting order to order hub-Failed :-'+ e.getMessage(), ' ',orderId);
            // errorHandling ( e, String.valueOf( res ));
        }           
    }
    
    //SFAL-330 / 25Oct2022 / Shubham Kumar / Initial Version
    //@description : This method will be used to post order based on the quote type to order hub
    public static void sendOrderToOH(List<String> QuoteIds){
        //Body = '{"totalTax":0.26,"subTotalPrice":2,"shippingAddress":null,"seller":"TANDF","orderType":"SALES","orderStatus":"OPEN","orderPrice":2.26,"orderedItem":[{"productId":"HSS-AFRICAN-2018","altProductId":"25ba4095-c726-453b-9ae0-79f6fbd2f5e4","price":2,"sellingPrice":2.26,"currency":"USD","quantity":1,"orderedQuantity":1,"lineItemType":"EBOOK-COLLECTION-DYNAMIC","salesType":"PURCHASE","discount":0,"taxAmount":0.26,"salesOrg":"IN01","externalProductRefId":"externalProductRefId","fulfillmentRequest":{"requestType":"EBOOK_CONTENT_ACCESS","productType":"COLLECTION","productId":"25ba4095-c726-453b-9ae0-79f6fbd2f5e4","licenseType":"Perpetual","licenseUpdateType":"Static","accessScope":"Global","policies":{"drm":false,"concurrency":"0","grantType":["ViewOnline","Download"],"copyCount":"0","printCount":"0"}}}],"orderDate":"2022-07-08","notes":"","fulfillments":[{"name":"Collection Order Fulfillment","description":"Collection Order Fulfillment Description","licenseType":"perpetual","grantType":["viewOnline","download"]}],"fulfillmentRequest":null,"externalSystemRefId":"4334745589","externalOrderRef":"","customerId":"100","channel":"UBX","buyerId":"100","billingAddress":{"addressContactEmail":"zeeshan.informa@informa.com","addressCountry":"Canada","addressLine1":"290 Bremner Blvd","addressLine2":"901, Canada","addressLine3":"P.o.Box 111","addressLocality":"TORONTO","addressOrganisation":"Taylor & Francis Group","addressRegion":"ON","businessPartnerNo":"0005464153","careOf":"Informa","countryCode":"CA","externalCustomerAddressId":"1661269025497USY","postalCode":"M5V 3L9","taxCategory":null,"taxRegistrationNumber":null,"telephoneNo":"9810212534"}}';
        try{
            Id quoteRecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Automated eBook Direct Sales Orders').getRecordTypeId();
            Id BPCquoteRecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('T&F - BPC Quote Type').getRecordTypeId();
            
            map<String,String> JSONBodyByQuoteID = new map<String,String>();
            mapHeader = new Map<String, String>();
            mapHeader.put('Content-Type','application/json');
            
            //ORDER HUB URI : will be added in custom setting
            finalOrderURI = 'https://api-uat.taylorandfrancis.com/v1/orders/v2';
            
            List<SBQQ__Quote__c>  quoteRecords = [Select Id,recordTypeId from SBQQ__Quote__c  where id In :QuoteIds];
            JSONBodyByQuoteID = TF_LMSOrderJson.createLMSOrderJson(QuoteIds);
            
            for(SBQQ__Quote__c quoteRec : quoteRecords){
                if(quoteRec.recordTypeId == quoteRecordTypeId && JSONBodyByQuoteID.ContainsKey(quoteRec.Id)){
                    res = TF_PlatformExecuter.execute(finalOrderURI,'POST','idtoken', JSONBodyByQuoteID.get(quoteRec.Id), mapHeader, false);
                    if(res != NULL && res.getStatusCode() == 200){
                        TF_CallOhResponse TF_CallOhResponseObj =(TF_CallOhResponse) System.JSON.deserialize(res.getBody(), TF_CallOhResponse.class);
                        system.debug('TF_CallOhResponseObj=====>'+res.getBody());    
                    }else{
                        system.debug('TF_CallOhResponseObj=====>'+res.getBody());   
                    }
                }  
            }
           }catch(exception e) {
               if(e!= NULL) System.debug(' ******** Exception : ' + e.getMessage());
           }
    }
    
    /**
* sendEmail description
* @param  errorMessage      errorMessage description
* @param  errorHttpResponse : this arg only passed from this class as JSON is availble from here only
*/
    public static void sendEmail( String errorMessage,String errorHttpResponse , Id orderId )
    {
        system.debug('inside sendEmail method');        
        init();
        //system.debug('errorHttpResponse '+errorHttpResponse);
        system.debug('directSalesSettings-'+directSalesSettings);
        system.debug('directSalesSettings.Send_emails_on_failure__c-'+directSalesSettings.Send_emails_on_failure__c);
        system.debug('directSalesSettings.Alert_Email_Addresses__c-'+directSalesSettings.Alert_Email_Addresses__c);
        
        updateReqObjs(orderList, orderItemList, errorMessage ,oppObj  ,updateSapBpList );
        if ( directSalesSettings!= NULL && directSalesSettings.Send_emails_on_failure__c == true  && String.isNotBlank( directSalesSettings.Alert_Email_Addresses__c ) ) {
            System.debug('sending email errorMessage'+errorMessage);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> lstEmail = directSalesSettings.Alert_Email_Addresses__c.split(',');
            mail.setToAddresses(lstEmail);
            //mail.setCcAddresses(ccAddresses);
            mail.setSenderDisplayName('Direct Sales Process Error');
            String sub = ''+String.valueOf(UserInfo.getUserName().substringAfterLast('.')) + ' ' ;
            Datetime myDT = Datetime.now();
            mail.setSubject(sub.toUpperCase()+'Direct Sales Process Error : '+ String.valueOf(myDT)  );
            mail.setBccSender(false);
            mail.setUseSignature(false);
            // Create the email attachment
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName('JSON Response');
            If( String.isBlank(errorHttpResponse) ) errorHttpResponse = 'No response data available';
            efa.setBody(Blob.valueOf((errorHttpResponse)));
            // Attach file using setFileAttachments function
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            mail.setHtmlBody(' Hello, <br/>  Direct Sales process has failed. For more Information, please refer to the response  provided  in attachment <br/> <br/> Error :- '+ errorMessage );
            
            // write onto message field
            try{
                
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                //updateReqObjs(orderList, orderItemList, errorMessage ,oppObj  ,updateSapBpList );
                
            }catch(exception e) {
                if(e!= NULL) System.debug(' ******** Exception : ' + e.getMessage());
                System.debug('sendEmail() ****'+e);
            }
        }
    }
    
    public static void updateReqObjs(List<Order> listOrder ,List<OrderItem> listOrderItem, String errorMessageField , opportunity passdOpp , List<SAP_BP__c> passdUpdateSapBpList ){
        try {
            system.debug('Inside updateReqObjs method');
            if(!listOrder.isEmpty()){
                system.debug('listOrder Message '+listOrder.get(0).Message__c);
                system.debug('errorMessageField '+ errorMessageField);
                if(string.isNotBlank(errorMessageField) && errorMessageField.containsIgnoreCase('Posting order to order hub')){
                    String messageStr = listOrder.get(0).Message__c;
                    if ( messageStr != NULL && String.isNotBlank(messageStr) ) {
                        Map<integer,String> mapIndexValue = new Map<integer,String>();
                        List<String> listStr = messageStr.split('~msg~');
                        integer k = 0 ;
                        for (String msgStr : listStr) {
                            System.debug('msgStr-'+msgStr);
                            if (msgStr!=NULL && msgStr.containsIgnoreCase('Posting order to order hub') ) {
                                system.debug('Inside'+msgStr);
                                // overwrite string , it can be success or failure mssg 
                                mapIndexValue.put( k , errorMessageField + ' ' );
                            }
                            k++;
                        }
                        if(!messageStr.containsIgnoreCase('Posting order to order hub')){
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
                            listOrder.get(0).Message__c = finalStr ;
                        }
                    }
                    else if(String.isBlank(messageStr)){
                        listOrder.get(0).Message__c = errorMessageField ;
                    }
                }
                
                if(passdUpdateSapBpList!=NULL && !passdUpdateSapBpList.isEmpty()){
                    system.debug('SAP BP update');
                    update passdUpdateSapBpList;
                }
                /*if(passdUpdateSapBpList!=NULL && !passdUpdateSapBpList.isEmpty()){
system.debug('SAP BP update');
List<SAP_BP__c> pendingSapBpList = new List<SAP_BP__c>();
for (SAP_BP__c sapObj  : passdUpdateSapBpList) {
if (sapObj.Name.containsIgnoreCase('PENDING')) {
pendingSapBpList.add(sapObj);
}
}
system.debug('pendingSapBpList '+pendingSapBpList);
if(pendingSapBpList != NULL && !pendingSapBpList.isEmpty())
update pendingSapBpList;
}*/
                
                if(passdOpp!= NULL && listOrder!=NULL && !listOrder.isEmpty()) {
                    //Get error message from SAP BP's error message field and update value in opportunity's error message field
                    String errorMessageOnOpp = '';
                    Opportunity oppUpdate = [Select id, Order_Status__c, Message__c, Bill_to_BP__r.Message__c, Ship_to_BP__r.Message__c, RecordTypeId,Sold_to_BP__c,Ship_to_BP__c,Payer_BP__c,StageName,AccountId,Bill_to_BP__r.Email__c, Name, Bill_to_BP__r.First_Name__c, Bill_to_BP__r.Last_Name__c, Bill_to_BP__r.Country__c, Bill_to_BP__r.Region__c, Bill_to_BP__r.State__c, Bill_to_BP__r.Street__c, Bill_to_BP__r.ZIP__c, Bill_to_BP__c, Bill_to_BP__r.City__c from Opportunity where id =: passdOpp.id];
                    system.debug('Before '+oppUpdate.Message__c);
                    if(oppUpdate.Bill_to_BP__c !=NULL && String.isNotBlank(oppUpdate.Bill_to_BP__r.Message__c)) 
                    {
                        if(oppUpdate.Bill_to_BP__r.Message__c.containsIgnoreCase('Ship to')){
                            errorMessageOnOpp += oppUpdate.Bill_to_BP__r.Message__c.replace('Ship to', 'Bill to') + ' ~msg~ ';
                        }
                        else errorMessageOnOpp += oppUpdate.Bill_to_BP__r.Message__c + ' ~msg~ ';
                    }
                    if(oppUpdate.Ship_to_BP__c !=NULL && String.isNotBlank(oppUpdate.Ship_to_BP__r.Message__c))
                    {
                        if(oppUpdate.Ship_to_BP__r.Message__c.containsIgnoreCase('Bill to')){
                            errorMessageOnOpp += oppUpdate.Ship_to_BP__r.Message__c.replace('Bill to', 'Ship to') + ' ~msg~ ';
                        }
                        else errorMessageOnOpp += oppUpdate.Ship_to_BP__r.Message__c + ' ~msg~ ';
                    }
                    
                    errorMessageOnOpp = errorMessageOnOpp.removeEnd(' ~msg~ ');
                    Integer maxSize = 65536;
                    if(errorMessageOnOpp.length() > maxSize ){
                        errorMessageOnOpp = errorMessageOnOpp.substring(0, maxSize);
                        oppUpdate.Message__c = errorMessageOnOpp;
                    }else{
                        oppUpdate.Message__c = errorMessageOnOpp;
                    }
                    system.debug('After '+oppUpdate.Message__c);
                    
                    /********************** SFAL-317 START **********************/
                    //SFAL-158 Vikas Varshney
                    //SFAL-317 Vikas Varshney, Adding condition for Bespoke collection before opportunity closed won bespoke collection should be submitted to PCM successfully.
                    String productBespokeRT = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - BespokeCollection').getRecordTypeId();
                    Boolean isBespokeFulfillFlag = true;
                    List<SBQQ__QuoteLine__c> bespokeQLI = new List<SBQQ__QuoteLine__c>();
                    bespokeQLI = [  SELECT id, SBQQ__Product__c, SBQQ__Product__r.RecordTypeId, SBQQ__Product__r.Product_Type_Author_Facing__c, SBQQ__Quote__r.SBQQ__Opportunity2__r.Name, SBQQ__Product__r.IsActive FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__r.SBQQ__Opportunity2__c =:oppUpdate.id AND SBQQ__Quote__r.SBQQ__Primary__c = true AND SBQQ__Product__r.RecordTypeId =:productBespokeRT LIMIT 1 ];
                    
                    if ( !bespokeQLI.isEmpty() ) {
                        isBespokeFulfillFlag = false;
                        if ( bespokeQLI[0].SBQQ__Product__r.IsActive == true && bespokeQLI[0].SBQQ__Product__r.APIStatus__c == 'Submit To PCM Success' ) {
                            isBespokeFulfillFlag = true;
                            System.debug('***** Inside Trig_Order_PostOH Success Check Bespoke *****');
                        }
                    }
                    System.debug('isBespokeFulfillFlag =====>' + isBespokeFulfillFlag);
                    /********************** SFAL-317 END **********************/
                    
                    //For updating order status field on opportunity successful  and stageName as closed won
                    if(String.isNotBlank(oppUpdate.Message__c) && !oppUpdate.Message__c.containsIgnoreCase('Address Not Verified') && string.isNotBlank(errorMessageField) && errorMessageField.containsIgnoreCase('Posting order to order hub-Success') && listOrder.get(0).Message__c.contains('Tax Calculation-Success') && isBespokeFulfillFlag){  
                        oppUpdate.Order_Status__c = 'Successful';  
                        oppUpdate.StageName = 'Closed Won';  
                    }    
                    else oppUpdate.Order_Status__c = 'Failed';
                    update oppUpdate;
                }
                if(listOrder!=NULL && !listOrder.isEmpty()){
                    listOrder.get(0).IsRecursion__c = false ;
                    update listOrder;
                }
                if(listOrderItem!=NULL && !listOrderItem.isEmpty()){
                    update listOrderItem;
                }
            }
        } catch ( Exception ex ) {
            System.debug('************** Trig_Order_PostOH.updateReqObjs() Failure**************' + ex.getMessage());
        }
    }
    
    public static boolean runOnce1(){
        if(run1){
            run1=false;
            return true;
        }
        else{
            return run1;
        }
    }
    
    //Shalini- because of new validation at OH end now we have to change our mapping accordingly of billing and shipping addresses
    Public static sapCreationTimeAddressDetailsWrap mapAddressvalues(SAP_BP__c sapBp)
    {
        system.debug('Inside mapAddressvalues');
        sapCreationTimeAddressDetailsWrap sapCreationTimeAddressDetailsWrapObj = new sapCreationTimeAddressDetailsWrap();
        String customerName = ''; 
        String deptCampName = '';
        String deptName = '';
        
        if (String.isNotBlank( sapBp.Address_Type__c) ) {
            //Shalini Changes
            if (String.isNotBlank(sapBp.Department__c)){    
                deptName = sapBp.Department__c; 
            }
            //End Shalini Changes
            if (sapBp.Address_Type__c.containsIgnoreCase('account') &&  sapBp.Account_Id__c!=NULL ) {
                List<account> listAccBp = new List<account>([select id ,name from Account where id=:sapBp.Account_Id__c]);
                if(!listAccBp.isEmpty()) customerName = listAccBp.get(0).Name;    
            }             
            else if ( sapBp.Address_Type__c.equalsIgnoreCase('Campus')  && sapBp.Campus_Id__c!=NULL ) {
                List<Campus__c> listCampBp = new List<Campus__c>([select id ,name, Account__r.name from Campus__c where id=:sapBp.Campus_Id__c]);
                if(!listCampBp.isEmpty()) {
                    deptCampName  = listCampBp.get(0).Name;
                    if(listCampBp.get(0).Account__r != NULL)customerName = listCampBp.get(0).Account__r.name;
                }    
            }
            else if ( sapBp.Address_Type__c.equalsIgnoreCase('Department') && sapBp.Department_Id__c!=NULL) {
                List<Department__c> listDeptBp = new List<Department__c>([select id ,name, Account__r.name from Department__c where id=:sapBp.Department_Id__c]);
                if(!listDeptBp.isEmpty()){
                    deptCampName  = listDeptBp.get(0).Name;
                    if(listDeptBp.get(0).Account__r != NULL) customerName = listDeptBp.get(0).Account__r.name;
                }
            }
        }
        
        Map<String,String> mapApiMapg = new Map<String,String>();
        for(integer i =1 ; i < 8 ; i++){
            mapApiMapg.put('dynamicVar'+i, '');
        }
        List<String> listStr = new List<String>();
        // When its a account we do not need the dept fieeld in api 
        if( (String.isNotBlank( sapBp.Address_Type__c) && sapBp.Address_Type__c.containsIgnoreCase('account') && (String.isBlank(sapBp.Department__c) || sapBp.Department__c.length() <= 35 ))
           || (String.isNotBlank( sapBp.Address_Type__c) && 
               (sapBp.Address_Type__c.containsIgnoreCase('Department') ||
                sapBp.Address_Type__c.containsIgnoreCase('Campus') ) && deptCampName.length() <= 35 ) 
          ) 
        {
            system.debug('deptCampName-'+deptCampName);
            system.debug('sapBp.Address_Type__c-'+sapBp.Address_Type__c);
            if(String.isNotBlank(deptCampName) && (sapBp.Address_Type__c.containsIgnoreCase('Department') ||sapBp.Address_Type__c.containsIgnoreCase('Campus') ) ) mapApiMapg.put('dynamicVar1', deptCampName);
            if( String.isNotBlank(customerName) ){                    
                listStr = TF_SAP_BP_Creation_Handler.splitStringBySpace(customerName,35);
                if(!listStr.isEmpty() ){
                    integer i =2 ;
                    for(String str : listStr ){
                        mapApiMapg.put('dynamicVar'+i, str);
                        i++;
                    }
                    listStr.clear();
                }
            }
            
            if(String.isNotBlank(sapBp.Street__c) ){                   
                listStr = TF_SAP_BP_Creation_Handler.splitStringBySpace(sapBp.Street__c,35);
                if(!listStr.isEmpty() ){
                    integer i =5 ;
                    for(String str : listStr ){
                        mapApiMapg.put('dynamicVar'+i, str);
                        i++;
                    }
                    listStr.clear();
                }
            }                               
        }
        listStr.clear();
        // when its a campus or dept & dept name > 35 char
        if (String.isNotBlank( sapBp.Address_Type__c) && 
            (sapBp.Address_Type__c.containsIgnoreCase('Department') ||
             sapBp.Address_Type__c.containsIgnoreCase('Campus') ) && deptCampName.length() > 35 ) 
        {               
            system.debug('more char than 35');
            if( String.isNotBlank(deptCampName) )  listStr.addAll( TF_SAP_BP_Creation_Handler.splitStringBySpace(deptCampName,35));
            if( String.isNotBlank(customerName) )  listStr.addAll( TF_SAP_BP_Creation_Handler.splitStringBySpace(customerName,35));                                
            if(String.isNotBlank(sapBp.Street__c)) listStr.addAll( TF_SAP_BP_Creation_Handler.splitStringBySpace(sapBp.Street__c,35));
            if(!listStr.isEmpty() ){
                system.debug('listStr-'+listStr);
                integer i = 1 ;
                for( String str : listStr ){
                    if(String.isNotBlank(str)){
                        if(listStr.size()>7 && i ==7 ){
                            str = str.substring(0,str.length()-3) + '...';
                        }
                        mapApiMapg.put('dynamicVar'+i, str);
                        i++;
                    }                        
                }
            }       
        }
        system.debug('mapApiMapg-'+mapApiMapg);
        
        
        
        
        //Shalini- Changes according to new sap component
        if( String.isNotBlank( sapBp.Address_Type__c) && (String.isBlank(deptName) || deptName.length() <= 35 ))
        {
            system.debug('less char than 35');
            if(String.isNotBlank(deptName)) mapApiMapg.put('dynamicVar1', deptName);
            
        }
        listStr.clear();
        // when dept name > 35 char
        if (String.isNotBlank( sapBp.Address_Type__c) && deptName.length() > 35 ) 
        {               
            system.debug('more char than 35');
            if( String.isNotBlank(deptName) )  listStr.addAll( TF_SAP_BP_Creation_Handler.splitStringBySpace(deptName,35));
            if( String.isNotBlank(customerName) )  listStr.addAll( TF_SAP_BP_Creation_Handler.splitStringBySpace(customerName,35));                                
            if(String.isNotBlank(sapBp.Street__c)) listStr.addAll( TF_SAP_BP_Creation_Handler.splitStringBySpace(sapBp.Street__c,35));
            if(!listStr.isEmpty() ){
                system.debug('listStr-'+listStr);
                integer i = 1 ;
                for( String str : listStr ){
                    if(String.isNotBlank(str)){
                        if(listStr.size()>7 && i ==7 ){
                            str = str.substring(0,str.length()-3) + '...';
                        }
                        mapApiMapg.put('dynamicVar'+i, str);
                        i++;
                    }                        
                }
            }       
        }
        
        if(mapApiMapg != Null)
        {
            system.debug('mapApiMapg--> '+mapApiMapg);
            sapCreationTimeAddressDetailsWrapObj.addressLine1 = mapApiMapg.get('dynamicVar5');
            sapCreationTimeAddressDetailsWrapObj.addressLine2 = mapApiMapg.get('dynamicVar6');
            sapCreationTimeAddressDetailsWrapObj.addressLine3 = mapApiMapg.get('dynamicVar7');  
            String addressOrganisation = '';
            //addressOrganisation = mapApiMapg.get('dynamicVar2') +' '+ mapApiMapg.get('dynamicVar3') +' '+ mapApiMapg.get('dynamicVar4');
            if(String.isNotBlank(mapApiMapg.get('dynamicVar2'))) addressOrganisation += mapApiMapg.get('dynamicVar2');
            if(String.isNotBlank(mapApiMapg.get('dynamicVar3'))) addressOrganisation += ' '+ mapApiMapg.get('dynamicVar3');
            if(String.isNotBlank(mapApiMapg.get('dynamicVar4'))) addressOrganisation += ' '+ mapApiMapg.get('dynamicVar4');
            sapCreationTimeAddressDetailsWrapObj.addressOrganisation = addressOrganisation;
            system.debug('addressOrganisation.length '+addressOrganisation.length());
            system.debug('sapCreationTimeAddressDetailsWrapObj--> '+sapCreationTimeAddressDetailsWrapObj);
        }
        
        
        return sapCreationTimeAddressDetailsWrapObj;
    }
    
    public class sapCreationTimeAddressDetailsWrap{
        public String addressOrganisation;
        public String addressRegion;
        public String externalCustomerAddressId;
        public String addressLine3;
        public String addressLine2;
        public String addressLine1;
    }
    
    
}



// public void retryPostOrder_TaxCal( List<Order> listOrder ,  boolean isFromTaxcalutaionContext ,boolean isCallPostOrderOh ){
//     if (isCallPostOrderOh == true) {
//         // TODO: query olis in case of retry , but not when it's coming via tax calculatn
//         // List<OrderItem> listOrderItem = new List<OrderItem>([select ISBN__c, OrderId, ListPrice, Discount_Amount__c, SBQQ__OrderedQuantity__c, SBQQ__TaxCode__c, SBQQ__TaxAmount__c, CurrencyIsoCode,SBQQ_NetTotal__c,TotalPrice FROM OrderItem where OrderId =: orderId]);  
//         postOrderOnOrderHubMethod(  listOrder , null ,   isFromTaxcalutaionContext);
//     }


// }

/**
* run description: it's not calling now from triger but from TF_OrderTaxCalculation_HandlerClone. 
* @param  trig trig description
*/ 
// public void run(TriggerInterface_Order.Trig trig) {

//     // // 1 order will be inserted at a time so absolute bulkification is NOT done. 
//     // if(trig.isAfter && trig.isUpdate  && trig.newList != NULL ){
//     //     postOrderOnOrderHubMethod( trig.newList , null,true , true);        
//     // }
// }

// List<OrderItem> listOrderItem = new List<OrderItem>([select ISBN__c, OrderId, ListPrice, Discount_Amount__c, SBQQ__OrderedQuantity__c, SBQQ__TaxCode__c, SBQQ__TaxAmount__c, CurrencyIsoCode,SBQQ_NetTotal__c,TotalPrice FROM OrderItem where OrderId =: orderId]);
// 
// 
//   //TODO:  update message on order for tax & post order 
//   public static void updateMessageField( String errorMessageField , Id orderId ){

// if(orderId != NULL && isFromTaxcalutaionContext == false){  

//         //  will called from future method so fetch order again 
//         List<Order> listOrderDB = new List<Order>([SELECT id,Message__c FROM Order where id=:orderId LIMIT 1]);
//         if (!listOrderDB.isEmpty()) {
//             String messageStr = listOrderDB.get(0).Message__c;    Message__c  .containsIgnoreCase('Posting order to order hub'
//             if ( messageStr != NULL && String.isNotBlank(messageStr) ) {
//                 Map<integer,String> mapIndexValue = new Map<integer,String>();
//                 List<String> listStr = messageStr.split('~msg~');
//                 integer j = 0 ;
//                 for (String msgStr : listStr) {
//                     System.debug('msgStr-'+msgStr);
//                     if (msgStr!=NULL && msgStr.containsIgnoreCase('Posting order to order hub') ) {
//                         // overwrite string , it can be success or failure mssg 
//                         mapIndexValue.put( j , errorMessageField + ' ' );
//                     }
//                     j++;
//                 }
//                 System.debug('mapIndexValue_'+mapIndexValue);
//                 for (integer i  : mapIndexValue.keySet()) {
//                     listStr.remove(i);
//                     System.debug('listStr.size()'+listStr.size());
//                     listStr.add(mapIndexValue.get(i));
//                 }

//                 system.debug('listStr-'+listStr);                    
//                 // combine the string 
//                 String finalStr;
//                 for (Integer i = 0; i < listStr.size(); i++) {                        
//                     if(i==0) finalStr = listStr.get(0) +' ';
//                     else finalStr = finalStr  + '~msg~' + listStr.get(i) +' ';                        
//                 }
//                 if ( String.isNotBlank( finalStr)) {
//                     listOrderDB.get(0).Message__c = finalStr ;
//                 }
//             }
//             else if(String.isBlank(messageStr)){
//                 listOrderDB.get(0).Message__c = errorMessageField ;
//             }
//             update listOrderDB;
//             System.debug('listOrderDB.get(0).Message__c-'+listOrderDB.get(0).Message__c);

//         } 

//     }
// }
//}