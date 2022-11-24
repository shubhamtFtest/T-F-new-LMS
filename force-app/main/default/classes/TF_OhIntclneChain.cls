/**
Author : shashank
Test class :  zTestTF_OrderHubIntegrationSchduled
Description : This class is scheduled to process opportunities & opportunity line items coming from order Hub for different channels. also create ocr annd contacts if needed. 
Changes :  self chaining new approach  

*/
public class TF_OhIntclneChain {
    private  string hostname='';
    private Integer pageNo;
    private Integer pagesize=50;//Shalini: Earlier it was 70 but according to the new validation in OH API we have modified it 
    private  Id reqRecTypeId;
    private  Map<String, String> mapHeader ;
    private  List<Order_Hub_Integration_Setting__mdt> listUbxSelfServiceOrderSetting;
    private  HttpResponse errorLogRes = NULL;
    Private  string channelPassed;
    Private  string productIdAccChannel;
    Private  string emptyInvoiceOrderNum;
    Private  Boolean downTime;
    Private Integer currentPageNo, totalPages ;
    Private Date fromOrderDateCloseDate ;
    List<User> u = new List<User>();
   
    // system.debug(CountrywiseOppMap);
    
    public TF_OhIntclneChain(){
        
    }
    
    // values coming from queable class total pages not used 
    public TF_OhIntclneChain(String channel, String prodId,integer currentPageNo, integer totalPages ,Boolean downTime)
    {
        if(channel!= NULL && String.isNotBlank(channel) )  {
            channelPassed = channel.trim();
            channelPassed = channelPassed.toUpperCase();
        }
        this.currentPageNo= currentPageNo;
        this.totalPages= totalPages;
        this.downTime= downTime;
        
        if(prodId!= NULL && String.isNotBlank(prodId)  ) productIdAccChannel = prodId.trim();
        listUbxSelfServiceOrderSetting = new List<Order_Hub_Integration_Setting__mdt>([SELECT id,Start_Date__c,End_Date__c,Email_Addresses__c,Number_of_past_days__c,Send_Email__c,Pricebook2Id__c FROM Order_Hub_Integration_Setting__mdt WHERE DeveloperName ='Order_Hub_Integration_Setting' Limit 1]);
        reqRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F - eBooks Opportunity').getRecordTypeId();
        
        System.debug('reqRecTypeId-'+reqRecTypeId);
        System.debug('channelPassed-'+channelPassed);
        System.debug('currentPageNo-'+currentPageNo);
        System.debug('totalPages-'+totalPages);
        System.debug('downTime-'+downTime);
    }
    
    // fetch hostaname from CS
    private  void init()
    {
        
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
    
    public void execute( )
    {
        try
        {
            // System.debug('productIdAccChannel-'+productIdAccChannel);
            if(channelPassed!= NULL && String.isNotBlank(channelPassed) &&  productIdAccChannel!= NULL && String.isNotBlank(productIdAccChannel) ) {
                syncOrders();
            }else {
                String errMsg = '';
                if(channelPassed == NULL || String.isBlank(channelPassed) ) errMsg ='Channel is not mentioned.';
                if ( productIdAccChannel== NULL || String.isBlank(productIdAccChannel)) errMsg = errMsg + 'ProductId is not mentioned';
                
                sendEmail(errMsg,true, null);
            }
        } catch (Exception ex)
        {   System.debug('#32-sendEmail');
         if(ex!= NULL) System.debug(' ******** Exception : ' +  String.valueOf(' Exception Type :-'+ex.getTypeName()+' ** Message:-'+ex.getMessage()+' ** Line Number:-'+ex.getLineNumber()+' ** Stack Trace :- '+ ex.getStackTraceString()));
         sendEmail( String.valueOf(' Exception Type :-'+ex.getTypeName()+' ** Message:-'+ex.getMessage()+' ** Line Number:-'+ex.getLineNumber()+' ** Stack Trace :- '+ ex.getStackTraceString()),true, null);
        }
        
    }
    
    
    // Main logic starts from here
    public void syncOrders()
    {
        List<TF_OrderHubIntJSONResp> listCstmOdrResp = new List<TF_OrderHubIntJSONResp>();
        try 
        {
            init();
            List<TF_OrderHubIntJSONResp> listCstmOdrRespPastDay = new List<TF_OrderHubIntJSONResp>();
            List<TF_OrderHubIntJSONResp> listCstmOdrRespDateRange = new List<TF_OrderHubIntJSONResp>();
            String endpointPastDays;
            String endpointDaterange;
            String fullEndpoint;
            mapHeader = new Map<String, String>();
            mapHeader.put('Content-Type','application/json');
            
            if (listUbxSelfServiceOrderSetting != NULL && listUbxSelfServiceOrderSetting.size()>0)
            {
                Order_Hub_Integration_Setting__mdt metaDatasettingObj = listUbxSelfServiceOrderSetting.get(0);
                String endpoint = hostname + '/v1/orders/?channel='+ channelPassed +'&pagesize='+ pagesize ;
                String fromOrderDate;
                String toOrderDate;
                
                // ideally ,it will run daily. paginate and fetch all data in a list. tehn loop through the list. If it's not DOWNTIME
                if(downTime == false &&  metaDatasettingObj!= NULL && metaDatasettingObj.Number_of_past_days__c != NULL && metaDatasettingObj.Number_of_past_days__c != 0  ) 
                {
                    toOrderDate = String.valueOf(Date.Today());
                    fromOrderDate= String.valueOf(Date.Today().addDays(-Integer.valueOf(metaDatasettingObj.Number_of_past_days__c)));
                    fromOrderDateCloseDate = Date.Today().addDays(-Integer.valueOf(metaDatasettingObj.Number_of_past_days__c));
                    // System.debug('Date.Today()-'+String.valueOf(Date.Today()));
                    fullEndpoint = endpoint + '&fromOrderDate=' + fromOrderDate +'&toOrderDate=' + toOrderDate;
                    System.debug('fullEndpoint-'+fullEndpoint);
                }
                
                // in case of Down time
                if(downTime == true && metaDatasettingObj!= NULL && metaDatasettingObj.Start_Date__c != NULL && metaDatasettingObj.End_Date__c != NULL  ) 
                {
                    toOrderDate = String.valueOf(metaDatasettingObj.End_Date__c);
                    fromOrderDate= String.valueOf(metaDatasettingObj.Start_Date__c);
                    fromOrderDateCloseDate = metaDatasettingObj.Start_Date__c;
                    // System.debug('Date.Today()-'+String.valueOf(Date.Today()));
                    fullEndpoint = endpoint + '&fromOrderDate=' + fromOrderDate +'&toOrderDate=' + toOrderDate;
                    System.debug('downtime fullEndpoint-'+fullEndpoint);
                }
                integer limitIterator = currentPageNo + 5 ;
                System.debug('limitIterator-'+limitIterator);
                if(String.isNotBlank(fullEndpoint))
                {
                    do {
                        // call here only - 1 , 2 till 5 pages
                        currentPageNo++ ;
                        TF_OrderHubIntJSONResp tF_OrderHubIntJSONRespObj = callOrderhub(fullEndpoint,currentPageNo);
                        if(tF_OrderHubIntJSONRespObj != null) {
                            listCstmOdrResp.add(tF_OrderHubIntJSONRespObj);
                            if (tF_OrderHubIntJSONRespObj.metadata != NULL && tF_OrderHubIntJSONRespObj.metadata.totalPagesize != null) {
                                totalPages = tF_OrderHubIntJSONRespObj.metadata.totalPagesize;
                                System.debug('totalPages-'+totalPages);
                            }
                        }
                    } while ((currentPageNo < totalPages  ) &&  currentPageNo!= limitIterator );
                }
                
                //  both 1st callout done before DML
                if (listCstmOdrResp != NULL && listCstmOdrResp.size() > 0 ) {
                    processList(listCstmOdrResp);
                }
                
                // if more than 5 total pages dn enqueue job again                    
                if(  totalPages!= NUll && totalPages > limitIterator && currentPageNo != totalPages && currentPageNo < totalPages ) 
                {
                    if (Limits.getLimitQueueableJobs() >0 ) 
                    {
                        System.enqueueJob( new TF_OhIntQueueableChain(channelPassed,productIdAccChannel,currentPageNo,totalPages,downTime ));
                    }
                    else 
                    {
                        sendEmail( 'Queueable jobs limit exceeded ,can not process orders for further pages ', true,'No data' );
                    }
                }
                // enque job here for DOWN TIME . totalPages
                else if((downTime == false && currentPageNo == totalPages && metaDatasettingObj!= NULL && metaDatasettingObj.Start_Date__c != NULL && metaDatasettingObj.End_Date__c != NULL) || (downTime == false && (totalPages==0 || totalPages==NULL) && metaDatasettingObj!= NULL && metaDatasettingObj.Start_Date__c != NULL && metaDatasettingObj.End_Date__c != NULL) ) 
                {
                    System.debug('more qu totalPages'+totalPages);
                    downTime = true;
                    toOrderDate = String.valueOf(metaDatasettingObj.End_Date__c);
                    fromOrderDate= String.valueOf(metaDatasettingObj.Start_Date__c);
                    fromOrderDateCloseDate = metaDatasettingObj.Start_Date__c;
                    if (Limits.getLimitQueueableJobs() >0 ) 
                    {
                        System.enqueueJob( new TF_OhIntQueueableChain(channelPassed,productIdAccChannel,0,NULL,downTime ) );
                    }
                    else 
                    {
                        sendEmail( 'Queueable jobs limit exceeded ,can not process orders for downtime', true,'No data' );
                    }
                }
            }
        }
        catch(Exception ex) 
        {
            // System.debug('syncOrders() ******** Exception : ' +  String.valueOf(' Exception Type :-'+ex.getTypeName()+' ** Message:-'+ex.getMessage()+' ** Line Number:-'+ex.getLineNumber()+' ** Stack Trace :- '+ ex.getStackTraceString()));  
            // System.debug('#168-sendEmail');
            sendEmail( String.valueOf(' Exception Type :-'+ex.getTypeName()+' ** Message:-'+ex.getMessage()+' ** Line Number:-'+ex.getLineNumber()+' ** Stack Trace :- '+ ex.getStackTraceString()), true,JSON.serialize(listCstmOdrResp) );
        }
    }
    
    
    // it is for callout generic method
    public TF_OrderHubIntJSONResp callOrderhub( String endpoint , Integer pageNo){
        HttpResponse errorHttpResponse;
        try {
            
            HttpResponse res = NULL;
            endpoint = endpoint + '&pageno=' + pageNo; System.debug('endpoint-'+endpoint);
            // res = TF_OrderHubPlatformExecutor.execute(endpoint,'GET','idtoken', null, mapHeader, false);
            res = TF_PlatformExecuter.execute(endpoint,'GET','idtoken', null, mapHeader, false);
            errorLogRes = res;
            errorHttpResponse = res;
            if (res.getStatusCode() == 201 || res.getStatusCode() == 200)
            {
                // System.debug('****responseBody****!' + res.getBody());
                // deserialize here
                TF_OrderHubIntJSONResp tF_OrderHubIntJSONRespObj =(TF_OrderHubIntJSONResp) System.JSON.deserialize(res.getBody().replace('"currency":','"currencyy":'), TF_OrderHubIntJSONResp.class);
                tF_OrderHubIntJSONRespObj.metadata.totalPagesize = Integer.valueOf(res.getHeader('total_pages'));
                // system.debug('tF_OrderHubIntJSONRespObj-'+tF_OrderHubIntJSONRespObj);
                return tF_OrderHubIntJSONRespObj;
            }
            else{
                System.debug('bad response-'+ res.getStatus());
                System.debug('bad response-'+ res.getBody());
                sendEmail( String.valueOf( res.getBody() ) ,true, 'No response found');
                return null;
            }
        } catch (Exception ex) {
            // System.debug('callOrderhub() ******** Exception : ' +  String.valueOf(' Exception Type :-'+ex.getTypeName()+' ** Message:-'+ex.getMessage()+' ** Line Number:-'+ex.getLineNumber()+' ** Stack Trace :- '+ ex.getStackTraceString()));     System.debug('#175-sendEmail');
            
            String msgEr = 'No error message found'; 
            String resbody ='No response body found';
            if(ex!= null){
                msgEr = String.valueOf(' Exception Type :-'+ex.getTypeName()+' ** Message:-'+ex.getMessage()+' ** Line Number:-'+ex.getLineNumber()+' ** Stack Trace :- '+ ex.getStackTraceString()) ;
            } 
            if(errorHttpResponse!= NULL){
                resbody = errorHttpResponse.getBody();
            }
            
            sendEmail( msgEr , true,resbody);
            return null;
        }
    }
    
    // loop through the list to insert or update opps [don't put this in loop]
    public  void processList(List<TF_OrderHubIntJSONResp> listToprocess )
    {
        List<opportunity> listOppInsert = new List<opportunity>();
        List<OpportunityLineItem> listOliInsert = new List<OpportunityLineItem>();
        List<opportunity> listOppUpdate = new List<opportunity>();
        List<OpportunityLineItem> listOliUpdate = new List<OpportunityLineItem>();
        Set<Id> setOppUpdateId = new Set<Id>();
        Map<String,TF_OrderHubIntJSONResp.data> mapCustidData = new Map<String,TF_OrderHubIntJSONResp.data>();
        Map<String,TF_OrderHubIntJSONResp.data> mapAccidData = new Map<String,TF_OrderHubIntJSONResp.data>();
        Map<String,List<TF_OrderHubIntJSONResp.data> > mapCustidListData = new Map<String,List<TF_OrderHubIntJSONResp.data> >();
        Map<id, String> mapAccIdPartyId = new Map<id, String>();
        Map< String,id> mapPartyidAccId = new Map< String,id>();
        Map<String,List<id> > mapCustomeridListAccId = new Map< String,List<id>>();
        
        Map<String,TF_OrderHubIntJSONResp.data> mapInvoiceNoData = new Map<String,TF_OrderHubIntJSONResp.data>();
        Set<String> accPartId = new Set<String>();
        Map<String, Id> mapRespCurnPbeId = new Map<String, Id>();
        Set<Id> setOppUpdateDoneOli = new Set<Id>();
        Set<String> setInvoiceOppUpdteDone = new Set<String>();
        Set<String> oppNameInsert = new Set<String>();
        Set<String> oliNameInsert = new Set<String>();
        Set<string> setInvoiceNo = new Set<string>();
        
        /* Code changes for assigning opportunity owners accoring to countries. Line Number 271-292
        Author -- Sourabh Goyal*/
        
        //User Id where name is Joe Tagg
        Id UserJoeTagg=[select id,name from user where name ='Joe Tagg'].id;

        List<CountryWiseOppOwner__c> userNameNotUS =[select Name,Country__c,State__c,User__c,User_Id__c from CountryWiseOppOwner__c where country__c!='United States'];
        // List<CountryWiseOppOwner__c> tempListnotUS = new List<CountryWiseOppOwner__c>();
        Map<String,String> CountrywiseOppMapNotUS = new Map<String,String>();
        
        for(CountryWiseOppOwner__c mapnotUS : userNameNotUS){
            //tempListnotUS.add(mapnotUS);
            CountrywiseOppMapNotUS.put(mapnotUS.Country__c,mapnotUS.User_Id__c);
        }
        
        List<CountryWiseOppOwner__c> userNameUS =[select Name,State__c,User__c,User_Id__c from CountryWiseOppOwner__c where country__c='United States'];
        // List<CountryWiseOppOwner__c> tempList = new List<CountryWiseOppOwner__c>();
        Map<String,String> CountrywiseOppMapUS = new Map<String,String>();
        
        for(CountryWiseOppOwner__c mapUS : userNameUS){
            //   tempList.add(mapUS);
            //stateName.add(mapUS.State_Name__c);
            CountrywiseOppMapUS.put(mapUS.State__c,mapUS.User_Id__c);
        }
        system.debug('===>'+CountrywiseOppMapUS);
        
        /* End of Map creation */
        
        
        if (listUbxSelfServiceOrderSetting== NULL)
        {
            listUbxSelfServiceOrderSetting = new List<Order_Hub_Integration_Setting__mdt>([SELECT id,Start_Date__c,End_Date__c,Email_Addresses__c,Number_of_past_days__c,Send_Email__c,Pricebook2Id__c FROM Order_Hub_Integration_Setting__mdt WHERE DeveloperName ='Order_Hub_Integration_Setting' Limit 1]);
        }
        if (listUbxSelfServiceOrderSetting != NULL && listUbxSelfServiceOrderSetting.size() > 0 && listUbxSelfServiceOrderSetting.get(0).Pricebook2Id__c!=NULL   )
        {
            for (PricebookEntry pbe : [SELECT CurrencyIsoCode,Id,IsActive,Name,Pricebook2Id FROM PricebookEntry WHERE Product2Id = :productIdAccChannel AND Pricebook2Id = :listUbxSelfServiceOrderSetting.get(0).Pricebook2Id__c AND CurrencyIsoCode!=NULL] )
            {
                mapRespCurnPbeId.put(pbe.CurrencyIsoCode, pbe.Id);
                // System.debug('mapRespCurnPbeId-'+mapRespCurnPbeId);
            }
        }
        String emptyInvoiceOrderNum='';
        for (TF_OrderHubIntJSONResp tF_OrderHubIntJSONRespObj : listToprocess)
        { 
            
            System.debug('tF_OrderHubIntJSONRespObj-'+ tF_OrderHubIntJSONRespObj);
            if(tF_OrderHubIntJSONRespObj.paginatedOrderResult != null && tF_OrderHubIntJSONRespObj.paginatedOrderResult.data!= null)
            {
                List<TF_OrderHubIntJSONResp.data> listData = new List<TF_OrderHubIntJSONResp.data>();
                listData = tF_OrderHubIntJSONRespObj.paginatedOrderResult.data;
                for (TF_OrderHubIntJSONResp.data dt  : listData)
                {
                    String invoiceNo ='';
                    // using to fetch currency
                    if(dt.customerId != NULL) mapCustidData.put(dt.customerId,dt);
                    // if its in map
                    if (dt.customerId!=NULL && mapCustidListData.containskey(dt.customerId)) {
                        List<TF_OrderHubIntJSONResp.data> listDt= mapCustidListData.get(dt.customerId);
                        listDt.add(dt);
                        mapCustidListData.put(dt.customerId, listDt);
                    }else {
                        // not in the map
                        if(dt.customerId != NULL ) mapCustidListData.put(dt.customerId, new List<TF_OrderHubIntJSONResp.data> {dt});
                        
                    }
                    // collect invoices number here
                    if (dt!= NULL && dt.invoices != NULL && dt.invoices.size() >0 ) {
                        invoiceNo ='';
                        for (TF_OrderHubIntJSONResp.invoices invoiceObj : dt.invoices ) {
                            // System.debug('coming invoice-'+invoiceObj.externalInvoiceRef);
                            if(invoiceObj.externalInvoiceRef !=NULL && String.isNotBlank(invoiceObj.externalInvoiceRef) ) invoiceNo = invoiceNo + invoiceObj.externalInvoiceRef + ',';
                        }
                        // System.debug('invoiceNo-'+ invoiceNo);
                        if( invoiceNo != NULL && invoiceNo.endsWith(',')) invoiceNo = invoiceNo.removeEnd(',');
                        // System.debug('invoiceNo-'+ invoiceNo);
                        
                        if(invoiceNo!= NULL && String.isNotBlank(invoiceNo)) mapInvoiceNoData.put(invoiceNo,dt);
                    }
                    // create error if invoices number is blank
                    if( String.isBlank(invoiceNo) ) {
                        emptyInvoiceOrderNum= emptyInvoiceOrderNum + dt.orderNumber + ',';
                        // System.debug('#454-sendEmail'+ emptyInvoiceOrderNum);
                        
                    }
                    
                }
            }
        }
        
        
        system.debug(' data-'+ mapCustidListData.keyset());
        string oppName;
        if(channelPassed != NULL && channelPassed.equalsIgnoreCase('UBX') )
        {
            oppName = 'UBX self service eBooks – '+ String.valueOf(System.Today().year());
        }
        else if(channelPassed != NULL && channelPassed.equalsIgnoreCase('Rialto') )
        {
            oppName = 'Rialto ' + String.valueOf(System.Today().year());
        }        
        else if(channelPassed != NULL && channelPassed.equalsIgnoreCase('GOBI') )
        {
            oppName = 'GOBI ' + String.valueOf(System.Today().year());
        }        
        /* Case Number : 01383315 - changes  */
        else if(channelPassed != NULL && channelPassed.equalsIgnoreCase('OASIS') )
        {
            oppName = 'OASIS ' + String.valueOf(System.Today().year());
        }        
        else {
            return;
        }
        list<opportunity> listAssociatedOpp = new list<opportunity>();
        // 1 account can have 1 opp of this year
        for (account acc  : [SELECT id,Customer_ID__c,Shipping_State_List__c,Shipping_Country_List__c,(select id,name,Start_Date__c,OwnerId,Regional_Only__c FROM Opportunities where name =:oppName) FROM account where Customer_ID__c!= null AND Customer_ID__c IN: mapCustidListData.keyset()   ])
        {
            // populate mapCustomeridListAccId to email if one customerid/partyid is associated with more than 1 account
            if(mapCustomeridListAccId.containsKey(acc.Customer_ID__c  ) ) mapCustomeridListAccId.get(acc.Customer_ID__c ).add(acc.id);
            else mapCustomeridListAccId.put( acc.Customer_ID__c , new List<id> {acc.id} );
            
            // other main logic
            mapAccIdPartyId.put(acc.id,acc.Customer_ID__c);
            mapPartyidAccId.put(acc.Customer_ID__c , acc.id);            
            // list<opportunity> listAssociatedOpp = new list<opportunity>();
            listAssociatedOpp = acc.Opportunities;
            
            
            // if opp is present , update it & OLI
            if (listAssociatedOpp != NULL && listAssociatedOpp.size()>0 ) {
                opportunity opp = newOpps(true, listAssociatedOpp.get(0), oppName );
                opp.accountId = acc.id;
                
                /* Assigning owner to opportunities while updation.. Author -- Sourabh Goyal ... Line Number 397-407*/
                if(acc.Shipping_Country_List__c!=null){
                    if(acc.Shipping_Country_List__c=='United States' && CountrywiseOppMapUS.containskey(acc.Shipping_State_List__c)){
                        opp.OwnerId= CountrywiseOppMapUS.get(acc.Shipping_State_List__c);
                    }
                    else if(acc.Shipping_Country_List__c!='United States' && CountrywiseOppMapNotUS.containskey(acc.Shipping_Country_List__c) && opp.OwnerId!=UserJoeTagg){
                        opp.OwnerId=CountrywiseOppMapNotUS.get(acc.Shipping_Country_List__c);
                    }
                    else if(acc.Shipping_Country_List__c=='United Kingdom' && opp.OwnerId==UserJoeTagg)  {
                        opp.OwnerId=UserJoeTagg;
                    }
                }
                /* Assignment done in updation */
                
                listOppUpdate.add(opp);
                // collect opp ID here
                setOppUpdateId.add(opp.Id);
            }else {
                // create an opp
                opportunity opp = newOpps(false, NULL, oppName);
                opp.accountId = acc.id;
                
                /* Assigning owner to opportunities while insertion.. Author -- Sourabh Goyal Line Number 419-426*/
                if(acc.Shipping_Country_List__c!=null){
                    if(acc.Shipping_Country_List__c=='United States' && CountrywiseOppMapUS.containskey(acc.Shipping_State_List__c)){
                        opp.OwnerId= CountrywiseOppMapUS.get(acc.Shipping_State_List__c);
                    }
                    else if(acc.Shipping_Country_List__c!='United States' && CountrywiseOppMapNotUS.containskey(acc.Shipping_Country_List__c)){
                        opp.OwnerId=CountrywiseOppMapNotUS.get(acc.Shipping_Country_List__c);
                    }
                }
                /* Assignment done in insertion */
                
                if (acc.Customer_ID__c!=NULL && mapCustidData.containskey(acc.Customer_ID__c)  && mapCustidData.get(acc.Customer_ID__c)!= NULL && mapCustidData.get(acc.Customer_ID__c).invoices[0] != NULL &&  mapCustidData.get(acc.Customer_ID__c).invoices[0].currencyy != NULL
                   )
                {
                    opp.CurrencyIsoCode = mapCustidData.get(acc.Customer_ID__c).invoices[0].currencyy;
                }
                mapAccidData.put(acc.id, mapCustidData.get(acc.Customer_ID__c) );
                listOppInsert.add(opp);
            }
        }
        
        
        
        System.debug('listOppInsert-'+listOppInsert);
        System.debug('listOppInsert.size()-'+listOppInsert.size());
        System.debug('listOppUpdate-'+listOppUpdate);
        System.debug('listOppUpdate.size()-'+listOppUpdate.size());
        
        
        if (listOppInsert!= null && listOppInsert.size()>0)
        {
            for (opportunity oppObj  : listOppInsert) {
                
            }   
            // Insert listOppInsert;
            Database.SaveResult[] srList = Database.insert(listOppInsert, false);
            dataBaseSaveresult(srList, listToprocess,'OppInsert',listOppInsert);    
            newOppConRole(listOppInsert, mapAccidData);
            
            if (listUbxSelfServiceOrderSetting!=NULL && listUbxSelfServiceOrderSetting.size() >0 && mapRespCurnPbeId.size()>0 )
            {
                //  insertion of OLI
                for (opportunity oppObj  : listOppInsert)
                {   
                    if (oppObj.accountId!= NULL && mapAccIdPartyId.containskey(oppObj.accountId) && mapAccIdPartyId.get(oppObj.accountId) != NULL )
                    {
                        List<TF_OrderHubIntJSONResp.data> listPartyIDData =  mapCustidListData.get(mapAccIdPartyId.get(oppObj.accountId));
                        for (TF_OrderHubIntJSONResp.data dtObj : listPartyIDData)
                        {
                            String invoiceNo;
                            // collect invoices number here
                            if (dtObj!= NULL && dtObj.invoices != NULL && dtObj.invoices.size() >0 ) {
                                invoiceNo ='';
                                for (TF_OrderHubIntJSONResp.invoices invoiceObj : dtObj.invoices ) {
                                    if(invoiceObj.externalInvoiceRef !=NULL && String.isNotBlank(invoiceObj.externalInvoiceRef) ) invoiceNo = invoiceNo + invoiceObj.externalInvoiceRef +',';
                                }
                                
                                if( String.isNotBlank(invoiceNo) && invoiceNo.endsWith(',')) invoiceNo =  invoiceNo.removeEnd(',');
                                // System.debug('invoiceNo-'+ invoiceNo);
                            }
                            
                            if (dtObj.invoices[0]!=NULL && dtObj.invoices[0].currencyy!=NULL  && invoiceNo!=NULL && String.isNotBlank(invoiceNo) && (!setInvoiceNo.contains(invoiceNo)) && mapRespCurnPbeId.get(dtObj.invoices[0].currencyy)!=NULL )
                            {
                                setInvoiceNo.add(invoiceNo);
                                // call newOLi
                                OpportunityLineItem oliInsert = newOLi(false, NULL, dtObj,  invoiceNo,oppObj.Id,mapRespCurnPbeId.get(dtObj.invoices[0].currencyy) );
                                listOliInsert.add(oliInsert);
                            }
                        }
                    }
                }
                
            }
            
        }
        if (listOppUpdate!= null && listOppUpdate.size()>0)
        {
            for (opportunity oppObj  : listOppUpdate) {
                
            }
            // update listOppUpdate;
            Database.SaveResult[] srList = Database.update(listOppUpdate, false);
            dataBaseSaveresult(srList, listToprocess,'OppUpdate',listOppUpdate);    
            
            // fetch all OLI with invoiceNumb & Opp Id
            for (OpportunityLineItem oli : [SELECT Name,Invoice_Number__c,OpportunityId FROM OpportunityLineItem WHERE OpportunityId IN:setOppUpdateId AND Invoice_Number__c IN:mapInvoiceNoData.keyset() AND OpportunityId!= NULL AND Invoice_Number__c!=NULL ])
            {
                // have OLI with invoice no so updating it
                if ( oli.Invoice_Number__c!=NULL && mapInvoiceNoData.containskey(oli.Invoice_Number__c) )
                {
                    setOppUpdateDoneOli.add(oli.OpportunityId);
                    TF_OrderHubIntJSONResp.data dataObj = mapInvoiceNoData.get(oli.Invoice_Number__c);
                    oli = newOli(true,oli,dataObj,null, NULL,NULL );
                    //oli.Product2Id = listUbxSelfServiceOrderSetting.get(0).Product_Id__c;     // Field is not writeable
                    // oli.Seats_Users__c = -1;
                    // oli.Invoice_Date__c =  date.valueOf(dataObj.orderDate);
                    // oli.UnitPrice = dataObj.subTotalPrice; // 
                    // oli.Description = 'UBX self service';
                    //oli.PricebookEntryId = mapRespCurnPbeId.get(dataObj.invoice.currencyy);    // Field is not writeable
                    listOliUpdate.add(oli);
                    setInvoiceNo.add(oli.Invoice_Number__c);
                }
                
            }
            
            //Update opp dont have OLI with invoice no so creating it
            if (listUbxSelfServiceOrderSetting!=NULL && listUbxSelfServiceOrderSetting.size() >0 && mapRespCurnPbeId.size()>0 )
            {
                //  insertion of OLI for update OPP list
                for (opportunity oppObj  : listOppUpdate)
                {
                    if (oppObj.id!=NULL  && oppObj.accountId!= NULL && mapAccIdPartyId.containskey(oppObj.accountId) && mapAccIdPartyId.get(oppObj.accountId) != NULL )
                    {
                        List<TF_OrderHubIntJSONResp.data> listPartyIDData =  mapCustidListData.get(mapAccIdPartyId.get(oppObj.accountId));
                        // create a set to compare the invoice number
                        
                        for (TF_OrderHubIntJSONResp.data dtObj : listPartyIDData)
                        {
                            String invoiceNo;
                            // collect invoices number here
                            if (dtObj!= NULL && dtObj.invoices != NULL && dtObj.invoices.size() >0 ) {
                                invoiceNo ='';
                                for (TF_OrderHubIntJSONResp.invoices invoiceObj : dtObj.invoices ) {
                                    if(invoiceObj.externalInvoiceRef !=NULL && String.isNotBlank(invoiceObj.externalInvoiceRef) ) invoiceNo = invoiceNo + invoiceObj.externalInvoiceRef +',';
                                }
                                if( String.isNotBlank(invoiceNo) && invoiceNo.endsWith(',')) invoiceNo =  invoiceNo.removeEnd(',');
                                // System.debug('invoiceNo-'+ invoiceNo);
                            }
                            
                            if (dtObj.invoices[0]!=NULL && invoiceNo!=NULL && String.isNotBlank(invoiceNo) && dtObj.invoices[0].currencyy!=NULL  && (!setInvoiceNo.contains(invoiceNo)) && mapRespCurnPbeId.get(dtObj.invoices[0].currencyy)!= NULL )
                            {
                                setInvoiceNo.add(invoiceNo);
                                // call newOli
                                OpportunityLineItem oliInsert = newOLi(false, NULL, dtObj, invoiceNo,oppObj.Id, mapRespCurnPbeId.get(dtObj.invoices[0].currencyy) );
                                listOliInsert.add(oliInsert);
                            }
                        }
                    }
                }
                
            }
            
            
        }
        if (listOliUpdate!=NULL && listOliUpdate.size() >0 )
        {
            for(OpportunityLineItem oli : listOliUpdate) {
                system.debug('oli.Invoice_Number__c-'+oli.Invoice_Number__c);
            }
            System.debug('listOliUpdate.size()-'+listOliUpdate.size());
            //update listOliUpdate;
            Database.SaveResult[] srList = Database.update(listOliUpdate, false);
            dataBaseSaveresult(srList, listToprocess,'OliUpdate',listOliUpdate);
        }
        if (listOliInsert!=NULL && listOliInsert.size()>0)
        {
            for(OpportunityLineItem oli : listOliInsert) {
                system.debug('oli.Invoice_Number__c-'+oli.Invoice_Number__c);
            }
            System.debug('listOliInsert.size()-'+listOliInsert.size());
            //Insert listOliInsert;
            Database.SaveResult[] srList = Database.insert(listOliInsert, false);
            dataBaseSaveresult(srList, listToprocess,'oliInsert',listOliInsert);
        }
        if (String.isNotBlank(emptyInvoiceOrderNum )) {
            emptyInvoiceOrderNum = emptyInvoiceOrderNum.removeEnd(',');
            sendEmail('invoice number blank for orderNumber :'+ emptyInvoiceOrderNum, true, JSON.serialize(listToprocess)  );
        }
        
        /* https://taylorfrancis.atlassian.net/browse/SAL-834 */ 
        // if any customerid does not have account then send email 
        String custIdwithNoAcc ='';
        for(String custid :  mapCustidListData.keyset())
        {
            if ( !mapPartyidAccId.containskey(custid) ) {
                System.debug('custid dont have accnt -'+custid);
                custIdwithNoAcc = custid + ',' +  custIdwithNoAcc ;
                // sendemail --- about cistomer not found  
            }
        }
        if( custIdwithNoAcc != NULL && custIdwithNoAcc.endsWith(',')) custIdwithNoAcc = custIdwithNoAcc.removeEnd(',');
        if( String.isNotBlank(custIdwithNoAcc) ){
            sendEmail( 'No account have following customerid:-'+custIdwithNoAcc ,true, JSON.serialize(listToprocess));  
        }
        
        // Error email required for when 1 partyid returns more than 1 Salesforce account
        String custIdwithMultipleAcc ='';
        for ( String accCustId : mapCustomeridListAccId.keySet()) {
            if (mapCustomeridListAccId.get(accCustId)!=NULL && mapCustomeridListAccId.get(accCustId).size() > 1 ) {
                custIdwithMultipleAcc = accCustId + ',' + custIdwithMultipleAcc   ; 
            }
        }
        if( custIdwithMultipleAcc != NULL && custIdwithMultipleAcc.endsWith(',')) custIdwithMultipleAcc = custIdwithMultipleAcc.removeEnd(',');
        if( String.isNotBlank(custIdwithMultipleAcc) ){
            sendEmail( 'customerid have multiple accounts :-'+custIdwithMultipleAcc ,true, JSON.serialize(listToprocess));  
        }
        /* https://taylorfrancis.atlassian.net/browse/SAL-834 */ 
        
    }
    
    /**
*
question : what if no email address is present ? 
newOppConRole description : new opps is created addressContactEmail email-seartch- contact for Accountid for Oppid , If existing Contact found then make it the primary Contact for the Opp 
ELSE create new Contact to make primary for the Opp. Last Name=Order JSON "billingAddress": "addressContactName" •  If Last Name is null then use first part of email up to the @  Email=Order JSON "billingAddress": addressContactEmail  Status=Active  Mailing Country List="billingAddress": "addressCountry"  Business=eBooks  Lead Source=Other
* @param  listOppInsert listOppInsert description
* @param  mapAccidData  mapAccidData description
* @return               return OpportunityContactRole created in the method
*/
    private  OpportunityContactRole newOppConRole( List<Opportunity> listOppInsert, Map<String,TF_OrderHubIntJSONResp.data> mapAccidData )
    {           
        Map<Id, String> mapOppidContemail = new Map<Id, String>();
        List<String> listContemail = new List<String>();
        List<String> listLeftContemail = new List<String>();
        List<oppAccEmailWrap> listoppAccEmailWrapInsert = new List<oppAccEmailWrap>();
        Map<Id, Id> mapAccidOppid = new Map<Id, Id>();
        Map<Id,oppAccEmailWrap> mapAccidOppAccEmailWrap = new Map<Id,oppAccEmailWrap>();
        Map<Id,oppAccEmailWrap> mapAccidLeftEmailid = new Map<Id,oppAccEmailWrap>();
        List<OpportunityContactRole> listOcrInsert = new List<OpportunityContactRole>();
        // 1 ACC can have 1 opp 
        // loop through list fetch data via accid craete OCR
        // System.debug('listOppInsert.size()-'+listOppInsert.size());
        for (opportunity opp : listOppInsert ) 
        {
            mapAccidOppid.put(  opp.accountId ,opp.Id );
            // System.debug('mapAccidOppid.keySet()-'+mapAccidOppid.keyset());
            // System.debug('mapAccidOppid email-'+mapAccidData.get(opp.accountId).billingAddress.addressContactEmail);
            TF_OrderHubIntJSONResp.data dataAccid =  mapAccidData.get(opp.accountId);
            /* Case Number : 01383315 - changes  */
            if(mapAccidData.containsKey(opp.accountId) && dataAccid != NULL  && channelPassed != NULL && ( (channelPassed.equalsIgnoreCase('UBX') && dataAccid.billingAddress != NULL) || ( (channelPassed.equalsIgnoreCase('GOBI') || channelPassed.equalsIgnoreCase('OASIS') || channelPassed.equalsIgnoreCase('Rialto') ) && dataAccid.shippingAddress !=NULL) ) )
            {
                System.debug('dataAccid.orderNumber-'+dataAccid.orderNumber); 
                if(channelPassed != NULL && channelPassed.equalsIgnoreCase('UBX') && String.isNotBlank(dataAccid.billingAddress.addressContactEmail)) 
                {
                    listContemail.add(dataAccid.billingAddress.addressContactEmail);
                } /* Case Number : 01383315 - changes  */
                else if (channelPassed != NULL && (channelPassed.equalsIgnoreCase('GOBI') || channelPassed.equalsIgnoreCase('OASIS') || channelPassed.equalsIgnoreCase('Rialto') ) && String.isNotBlank(dataAccid.shippingAddress.addressContactEmail) )  
                {
                    listContemail.add(dataAccid.shippingAddress.addressContactEmail);
                }
                else 
                {
                    System.debug('email blank for order no.-'+dataAccid.orderNumber);              
                }
                OppAccEmailWrap oppAccEmailWrapObj ;
                // make these con primary 
                if(channelPassed != NULL && channelPassed.equalsIgnoreCase('UBX')){  
                    oppAccEmailWrapObj = new OppAccEmailWrap(opp.Id, opp.accountId,NULL ,dataAccid.billingAddress.addressContactEmail);
                } /* Case Number : 01383315 - changes  */
                else if (channelPassed != NULL && ( channelPassed.equalsIgnoreCase('GOBI') || channelPassed.equalsIgnoreCase('OASIS') || channelPassed.equalsIgnoreCase('Rialto')) ){
                    oppAccEmailWrapObj = new OppAccEmailWrap(opp.Id, opp.accountId,NULL ,dataAccid.shippingAddress.addressContactEmail);
                }
                mapAccidOppAccEmailWrap.put(opp.accountId,oppAccEmailWrapObj);
                if ( channelPassed.equalsIgnoreCase('UBX') && String.isBlank(  dataAccid.billingAddress.addressContactEmail ) ) {
                    System.debug('email id not found for dataAccid.orderNumber-'+dataAccid.orderNumber);
                } /* Case Number : 01383315 - changes  */
                if ( (channelPassed.equalsIgnoreCase('GOBI') || channelPassed.equalsIgnoreCase('OASIS') || channelPassed.equalsIgnoreCase('Rialto') )&& String.isBlank(  dataAccid.shippingAddress.addressContactEmail ) ) {
                    System.debug('email id not found for dataAccid.orderNumber-'+dataAccid.orderNumber);
                }
            }
            else
            {
                
                
                System.debug('billingAddress or shippingAddress obj containg email : not found for dataAccid.orderNumber-'+dataAccid.orderNumber+' channelPassed -'+channelPassed);
            }
        }
        Map<Id, String> mapOppidCont = new Map<Id, String>();
        List<String> listCont = new List<String>();
        List<String> listContEml = new List<String>();
        System.debug('listContemail-'+listContemail);
        System.debug('mapAccidOppAccEmailWrap-'+mapAccidOppAccEmailWrap); // all wraps to have ocr inserted according  to accId
        System.debug('mapAccidOppAccEmailWrap.keySet()-'+mapAccidOppAccEmailWrap.keySet());
        
        //first check if the email address exists as a contact for the Account that you are creating the Opp for, if not then just search for Contact using email address and if more than one then just use first
        for (contact con : [SELECT id,Email,accountId FROM Contact WHERE Email IN: listContemail AND AccountId IN:mapAccidOppid.keySet() AND Email!= NULL AND AccountId != NULL ]) 
        {
            System.debug('con fetched : acconts-'+con);
            if ( mapAccidOppAccEmailWrap.containsKey(con.accountId) ) 
            {
                oppAccEmailWrap oppAccEmailWrapObj = mapAccidOppAccEmailWrap.get(con.accountId);
                
                if( oppAccEmailWrapObj !=NULL && String.isNotBlank(oppAccEmailWrapObj.email) && oppAccEmailWrapObj.email.equals(con.Email ) ) 
                {        
                    oppAccEmailWrapObj.conId = con.Id ;
                    oppAccEmailWrapObj.isPrimary = true ;
                    listoppAccEmailWrapInsert.add(oppAccEmailWrapObj);
                    System.debug(' con matched with json email-'+oppAccEmailWrapObj);
                }
                else {
                    
                    System.debug('email not found in specific account -'+oppAccEmailWrapObj.oppId );
                }
            }
        }
        List<String> listLeftEmail = new List<String>();
        
        //     
        // search for Contact using email address and if more than one then just use first
        for ( oppAccEmailWrap oppAccEmailWrapObj : mapAccidOppAccEmailWrap.values() ) {
            // wrap have no contact id but have email so search it in query 
            if ( oppAccEmailWrapObj.conId == NULL && oppAccEmailWrapObj.email != NULL ) {
                listLeftEmail.add(oppAccEmailWrapObj.email);      
            }
        }
        
        // only for NULL contact
        for (contact con : [SELECT id,Email,accountId FROM Contact WHERE Email IN:listLeftEmail ]) 
        { 
            for ( oppAccEmailWrap oppAccEmailWrapObj : mapAccidOppAccEmailWrap.values() ) {
                // only for NULL conId 
                if (oppAccEmailWrapObj.conId == NULL &&  String.isNotBlank( oppAccEmailWrapObj.email)  &&  oppAccEmailWrapObj.email.equalsIgnoreCase(con.Email )  ) 
                {
                    oppAccEmailWrapObj.conId = con.Id;
                }
                if (oppAccEmailWrapObj.conId == NULL &&  oppAccEmailWrapObj.email == NULL) 
                {
                    //  craete conatct for them                 
                }
                System.debug('con.Email = '+con.Email );      
            }
        }    
        
        //  create Contacts whose email not found and dont have con
        String accIdStr;
        List<contact> listconInsert = new List<contact>();
        Map<String,contact> mapEmailNewConInsert = new Map<String,contact>();
        List<oppAccEmailWrap> listNewconOppaccemailwrap = new List<oppAccEmailWrap>();
        for (oppAccEmailWrap oppAccEmailWrapObj : mapAccidOppAccEmailWrap.values()) 
        {
            accIdStr =  oppAccEmailWrapObj.accId;
            // create Contacts whose contact not found email not found 
            if ( oppAccEmailWrapObj.conId == NULL  && String.isNotBlank(accIdStr) || String.isBlank(oppAccEmailWrapObj.email) ) 
            {
                if (mapEmailNewConInsert.containsKey(oppAccEmailWrapObj.email)) {
                    oppAccEmailWrapObj.con = mapEmailNewConInsert.get(oppAccEmailWrapObj.email );
                }
                else if(mapAccidData.get(accIdStr) !=NULL )
                {
                    contact con = new contact();
                    if ( channelPassed.equalsIgnoreCase('UBX') && mapAccidData.get(accIdStr).billingAddress != NULL) {
                        if (mapAccidData.get(accIdStr).billingAddress.addressContactName != NULL )   con.lastname = mapAccidData.get(accIdStr).billingAddress.addressContactName;
                        else if (mapAccidData.get(accIdStr).billingAddress.addressContactEmail !=NULL )  con.lastname =  mapAccidData.get(accIdStr).billingAddress.addressContactEmail.substringBefore('@');          
                        con.Email = mapAccidData.get(accIdStr).billingAddress.addressContactEmail;
                        con.Mailing_Country_List__c = mapAccidData.get(accIdStr).billingAddress.addressCountry;
                    } /* Case Number : 01383315 - changes  */
                    else if( (channelPassed.equalsIgnoreCase('GOBI') || channelPassed.equalsIgnoreCase('OASIS') || channelPassed.equalsIgnoreCase('Rialto') ) && mapAccidData.get(accIdStr).shippingAddress != NULL) {
                        if (mapAccidData.get(accIdStr).shippingAddress.addressContactName != NULL )   con.lastname = mapAccidData.get(accIdStr).shippingAddress.addressContactName;
                        else if (mapAccidData.get(accIdStr).shippingAddress.addressContactEmail !=NULL )  con.lastname =  mapAccidData.get(accIdStr).shippingAddress.addressContactEmail.substringBefore('@');          
                        con.Email = mapAccidData.get(accIdStr).shippingAddress.addressContactEmail;
                        con.Mailing_Country_List__c = mapAccidData.get(accIdStr).shippingAddress.addressCountry;
                    }
                    con.Status__c = 'Active';
                    con.Business__c = 'eBooks';
                    con.LeadSource = 'Other';
                    oppAccEmailWrapObj.con = con;
                    listconInsert.add(con);
                    if ( channelPassed.equalsIgnoreCase('UBX') ) {
                        mapEmailNewConInsert.put(mapAccidData.get(accIdStr).billingAddress.addressContactEmail , con );
                    } /* Case Number : 01383315 - changes  */
                    else if (channelPassed.equalsIgnoreCase('GOBI') || channelPassed.equalsIgnoreCase('OASIS') || channelPassed.equalsIgnoreCase('Rialto') ) {
                        mapEmailNewConInsert.put(mapAccidData.get(accIdStr).shippingAddress.addressContactEmail , con );
                    }
                }                
            }
        }  
        
        if (listconInsert != NULL && listconInsert.size() > 0 ) 
        {
            // insert listconInsert;
            database.insert(listconInsert,false);
            Database.SaveResult[] srList = Database.insert(listconInsert, false);
            dataBaseSaveresult(srList, NULL,'conInsert',listconInsert);    
        }
        for (contact con : listconInsert) 
        {
            System.debug('con-'+con);
        }
        
        // after con inserted then putg value in wrap - conId
        for (oppAccEmailWrap oppAccEmailWrapObj : mapAccidOppAccEmailWrap.values() ) {
            System.debug('oppAccEmailWrapObj-'+oppAccEmailWrapObj);
            // for newly created contacts 
            if(oppAccEmailWrapObj.con != NULL && oppAccEmailWrapObj.conId == NULL )
            {
                OpportunityContactRole OpportunityContactRoleObj = new OpportunityContactRole( ContactId=oppAccEmailWrapObj.con.Id  ,OpportunityId=oppAccEmailWrapObj.oppId,Role='Decision Maker',IsPrimary=true);
                listOcrInsert.add(OpportunityContactRoleObj);
            }
            // for contacts fetched from DB 
            else
            {
                OpportunityContactRole OpportunityContactRoleObj = new OpportunityContactRole( ContactId=oppAccEmailWrapObj.conId ,OpportunityId=oppAccEmailWrapObj.oppId,Role='Decision Maker',IsPrimary=true);
                listOcrInsert.add(OpportunityContactRoleObj);
            }
            if (oppAccEmailWrapObj.conId == NULL ) {
                System.debug('contact not found till end -'+oppAccEmailWrapObj);
            }
        }
        
        for (OpportunityContactRole OpportunityContactRoleObj : listOcrInsert) 
        {
            System.debug('OpportunityContactRoleObj-'+OpportunityContactRoleObj);
        }
        if (listOcrInsert!= NULL && listOcrInsert.size() > 0 ) {
            // Insert listOcrInsert;
            Database.SaveResult[] srList = Database.insert(listOcrInsert, false);
            dataBaseSaveresult(srList, NULL,'OcrInsert',listOcrInsert);
        }
        
        // check which opp inserted does not have the OCR
        for (Opportunity opp : listOppInsert) 
        {      
            Boolean found = false; 
            for (OpportunityContactRole OpportunityContactRoleObj : listOcrInsert) {
                if (OpportunityContactRoleObj.OpportunityId == opp.Id ) {
                    found = true;
                }        
            }
            if (found == false) {
                System.debug('opp dont have ocr -'+ opp);
                System.debug(' mapAccidOppAccEmailWrap -'+ mapAccidOppAccEmailWrap.get(opp.accountId));
            }
        }
        return Null;
        
    }
    
    
    
    public  OpportunityLineItem newOli(Boolean isPresent, OpportunityLineItem oli,TF_OrderHubIntJSONResp.data dtObj,String invoiceNo, Id oppObjId,Id PricebookEntryId )
    {
        OpportunityLineItem oliObj;
        if (isPresent==false) {
            oliObj = new OpportunityLineItem();
            oliObj.Product2Id = productIdAccChannel;
            oliObj.PricebookEntryId = PricebookEntryId;
            oliObj.OpportunityId = oppObjId;
            oliObj.Invoice_Number__c = invoiceNo;
        }
        else {
            oliObj = oli;
        }
        oliObj.Seats_Users__c = -1;
        oliObj.Invoice_Date__c = date.valueOf(dtObj.orderDate);
        oliObj.UnitPrice = dtObj.subTotalPrice;
        if ('UBX'.equalsIgnoreCase(channelPassed)) {
            oliObj.Description = 'UBX self service';
        }
        else if('GOBI'.equalsIgnoreCase(channelPassed)) {
            oliObj.Description = 'GOBI Order';
        }  /* Case Number : 01383315 - changes  */
        else if ( 'OASIS'.equalsIgnoreCase(channelPassed) ) {
            oliObj.Description = 'OASIS Order';
        }
        else if ( 'Rialto'.equalsIgnoreCase(channelPassed) ) {
            oliObj.Description = 'RIALTO Order';
        }
        return oliObj;
    }
    
    // code to create new opps
    public  opportunity newOpps(Boolean isPresent, opportunity oppo, String oppName)
    {
        /* List<CountryWiseOppOwner__c> userName = new List<CountryWiseOppOwner__c>();
if(shipCountry!=null){
if(shipCountry!='United States'){
userName=[select user__c from CountryWiseOppOwner__c where country__c =: shipcountry];
system.debug('accCountry'+shipcountry);
system.debug('username'+userName);
if(!userName.isEmpty())
u =[select id from user  where name=:userName[0].user__c];
}
if(shipCountry=='United States'){
userName=[select user__c from CountryWiseOppOwner__c where country__c =: shipcountry and state__c=: shipState];
system.debug('accCountry'+shipcountry);
system.debug('username'+userName);
if(!userName.isEmpty())
u =[select id from user  where name=:userName[0].user__c];
}

}*/
        
        String currentYear = String.valueOf(System.Today().year());
        Opportunity opp;
        if (isPresent==false ) {
            opp = new Opportunity();
            opp.RecordTypeId = reqRecTypeId;
            opp.Start_Date__c = System.today();
            opp.CloseDate=fromOrderDateCloseDate; 
        }else {
            opp = oppo;
        }
        // fields that are different in channels
        if('UBX'.equalsIgnoreCase(channelPassed) ) {
            opp.LeadSource = 'Organic';
            opp.Lead_Source_Detail__c ='UBX self service';
            opp.Renewal_Method__c = 'Direct';
        } /* Case Number : 01383315 - changes  */
        if( 'GOBI'.equalsIgnoreCase(channelPassed) || 'OASIS'.equalsIgnoreCase(channelPassed) || 'Rialto'.equalsIgnoreCase(channelPassed) ) {
            opp.LeadSource = 'Customer Interaction';
            opp.Lead_Source_Detail__c ='Inbound customer call/email';
            opp.Renewal_Method__c = 'Agent';
        }
        /*SAL-3914:Dt 01-04-2021, Updated by Syam N */
        //If the Opportunity name string contains GOBI/OASIS/Rialto then update Regional_Only__c to true on Opp.
        if(oppName.contains('GOBI') || oppName.contains('OASIS') || (oppName.contains('Rialto') || oppName.contains('RIALTO')) ){
            opp.Regional_Only__c = true;
            system.debug('opp-->'+opp);
        }
        /**/
        opp.Name = oppName;
        opp.Type ='New Business';
        opp.Order_Type__c = 'One-Time Purchase';
        opp.Don_t_Send__c = true;
        opp.Reason_No_Renewal__c = 'Perpetual';
        
        opp.StageName = 'Closed Won';
        opp.Probability = 100;
        opp.Product_Family__c = 'eBooks';
        opp.Product_Interest_Category__c = 'eBooks';
        System.debug('opp-'+opp);
        return opp;
        //opp.End_Date__c = date.newinstance(System.Today().year(), 12, 31); can be left blank
    }
    
    @testvisible
    private  void dataBaseSaveresult( Database.SaveResult[] srList,List<TF_OrderHubIntJSONResp> listToprocess, String hintevent, List<sObject> listSobj)
    {
        String sobjectStr = '  ### ERROR IN SOBJECT ### :- ';
        System.debug('listSobj-'+listSobj);
        System.debug('srList.size()-'+srList.size());
        string errMsg= hintevent+' : ';
        boolean errOccured = false;
        Integer i=0; 
        // Iterate through each returned result
        for (Database.SaveResult sr : srList)
        {
            System.debug('sr-'+sr);
            System.debug('i-'+i);            
            if (sr.isSuccess())
            {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully operated sobject ID: ' + sr.getId());
            }
            else
            {
                errOccured = true;
                // Operation failed, so get all errors
                for(Database.Error err : sr.getErrors())
                {
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    if (errMsg!=NUll && !errMsg.contains(err.getMessage()))
                    {
                        errMsg = errMsg + err.getMessage() + ',';
                    }
                }
                
                sobjectStr = sobjectStr + String.valueOf(listSobj.get(i)) + ',';
            }
            i++;
        }
        if(errOccured== true)
        {   System.debug('#454-sendEmail');
         if (listToprocess!= NULL ) 
         {
             sendEmail(errMsg + ' '+ sobjectStr, true, JSON.serialize(listToprocess)  );
         } 
        }
    }
    
    
    
    /**
* sendEmail description
* @param  errorMessage      errorMessage description
* @param  isLimitError      its used in every case now , usage has been changed
* @param  errorHttpResponse : this arg only passed from this class as JSON is availble from here only
*/
    public  void sendEmail( String errorMessage, boolean isLimitError,String errorHttpResponse )
    {
        Datetime myDT = Datetime.now();
        String myDate = myDT.format('h:mm a');
        system.debug('inside sendEmail method');
        if (listUbxSelfServiceOrderSetting== NULL) {
            listUbxSelfServiceOrderSetting = new List<Order_Hub_Integration_Setting__mdt>([SELECT id,Start_Date__c,End_Date__c,Email_Addresses__c,Number_of_past_days__c,Send_Email__c,Pricebook2Id__c FROM Order_Hub_Integration_Setting__mdt WHERE DeveloperName ='Order_Hub_Integration_Setting' Limit 1]);
        }
        if (listUbxSelfServiceOrderSetting != NULL && listUbxSelfServiceOrderSetting.size() > 0  )
        {
            Order_Hub_Integration_Setting__mdt metaDatasettingObj = listUbxSelfServiceOrderSetting.get(0);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            // System.debug('metaDatasettingObj-'+metaDatasettingObj);
            if(metaDatasettingObj.Email_Addresses__c != NULL && String.isNotBlank(metaDatasettingObj.Email_Addresses__c) && metaDatasettingObj.Send_Email__c == true)
            {
                System.debug('sending email errorMessage'+errorMessage);
                List<String> lstEmail = metaDatasettingObj.Email_Addresses__c.split(',');
                //String[] ccAddresses = new String[] {''};
                mail.setToAddresses(lstEmail);
                //mail.setCcAddresses(ccAddresses);
                mail.setSenderDisplayName('Order Hub Integration Error');
                String sub = ''+String.valueOf(UserInfo.getUserName().substringAfterLast('.')) + ' ';
                if( String.isNotBlank(channelPassed)) sub = sub+'- ' + channelPassed;
                if( String.isNotBlank(channelPassed) && String.isNotBlank(sub) ) sub = sub.toUpperCase();
                mail.setSubject(sub+' Order Hub Integration - Failed : '+ String.valueOf(myDT)  );
                mail.setBccSender(false);
                mail.setUseSignature(false);
                // Create the email attachment
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName('JSON Response');
                If( String.isBlank(errorHttpResponse) ) errorHttpResponse = 'No response data available';
                efa.setBody(Blob.valueOf((errorHttpResponse)));
                // Attach file using setFileAttachments function
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                
                mail.setHtmlBody(' Hello, <br/>  Order Hub Integration process has failed. For more Information, please refer to the JSON response in provided either in attachment or in setting object. <br/> <br/> Error :- '+ errorMessage );
                try{
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }catch(exception e) {
                    if(e!= NULL) System.debug(' ******** Exception : ' + e.getMessage());
                    System.debug('sendEmail() ****'+e);
                }
            }
        }
        if(isLimitError == true )
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
            
            siObj.Text_2__c = String.valueOf(myDT);   // Date time OrderHubIntegrationErrorLogs
            if (errorMessage != NULL && errorMessage.length()> 255) {
                siObj.Text_3__c = errorMessage.substring(0,255); // sfdc error
                if(errorMessage.length()< 508) siObj.Text_4__c = errorMessage.substring(256,errorMessage.length()); // sfdc error
                if(errorMessage.length()> 508) siObj.Text_4__c = errorMessage.substring(256,508);
            }else
            {
                siObj.Text_3__c = errorMessage;
            }
            
            Setting__c settObj  = [SELECT Id,Name FROM Setting__c WHERE Name = 'OrderHubIntegrationErrorLogs' limit 1 FOR UPDATE ];
            if (settObj != NULL)
            {
                id settingObjID = settObj.Id;
                system.debug('settingObjID- '+settingObjID);
                
                siObj.Setting__c  = settingObjID;
                insert siObj;
            }
        }
    }
    
    public class OppAccEmailWrap {
        Id oppId {set; get;}
        Id accId {set; get;}
        Id conId {set; get;}
        String email {set; get;} //  email returned from JSON
        Boolean isPrimary{set;get;}  
        contact con{set;get;}
        /**
* OppAccEmailWrap description : constructor to initailize data `   
* @return   return null
*/
        public OppAccEmailWrap(Id oppId,Id accId,Id conId,String email ){
            this.oppId = oppId;
            this.accId = accId;
            this.conId = conId;
            this.email = email;
        }
    }
    
}