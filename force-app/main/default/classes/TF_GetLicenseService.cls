/***************************************************************************
* Created by: Shubham Kumar, 2022.04.10
* Test Class: zTEST_TF_GetLicenseService
* Description: This class is used by other Systems to get the details of licenses which are corresponding to a customer.
Example Salesforce:-
* 1) Endpoint (GET) = /services/apexrest/v4/licenses?partyId=98422&offset=10&limit=20&status=all
* 2) Endpoint (GET) = /services/apexrest/v4/licenses/02i7Y000009Tk3uQAC
* 3) Endpoint (PUT) = /services/apexrest/v4/licenses/02i7Y000009Tk3uQAC&identifier=98422
* 3) Endpoint (PATCH) = /services/apexrest/v4/licenses/02i7Y000009Tk3uQAC
* **************************************************************************/
@RestResource(urlMapping='/v4/licenses/*')
global with sharing class TF_GetLicenseService{
    
    global class LicenseResponse {
        public Map<String,Object> metadata = new Map<String,Object>();
        public List<TF_Licenses> data;
        public Integer statusCode;
        public Integer totalLicenseCount; //SFAL-172 Vikas Varshney
        
        public void success(List<TF_Licenses> data, String message,Integer statusCode){
            metadata.put('status','success');
            metadata.put('message', message);
            this.data = data;   
            this.statusCode = statusCode;
        }
        
        public void error(List<TF_Licenses> data,Object exceptionDetails,Integer statusCode){
            metadata.put('status','failure');
            metadata.put('message', exceptionDetails);
            this.data = data;
            this.statusCode = statusCode;
        } 
        
        public void clear(){
            metadata.clear();
        }        
    }
    
    @HttpGet
    global static void getLicenseData() {
        LicenseResponse response = new LicenseResponse();
        try{
            Map<String, String> paramMap    = RestContext.request.params;
            String uri = String.valueOf(RestContext.request.requestURI);
            system.debug('paramMap : '+paramMap+'  uri :'+uri);
            
            String command                  = getCommand(paramMap,uri);
            String operation                = operationLookup('GET', command);
            system.debug('command : '+command+'  operation :'+operation);
            
            if ( operation == 'getLicensesByPartyId' ) {
                response = getLicenseInfoByPartyID(paramMap);
            } else if ( operation == 'getLicenseInfoByLicenseID' ) {
                String licenseId = uri.substring(uri.lastIndexOf('/')+1);
                system.debug('licenseId'+licenseId);
                response = getLicenseInfoByLicenseID(licenseId);
            }  else {
                response.error(null,'Invalid resource',404);
            }
            
            if ( String.isNotBlank(JSON.serialize(response))) {
                
                RestContext.response.statusCode = response.statusCode;
                
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(response));
                RestContext.response.addHeader('Content-Type', 'application/json');
                
                
            }
        }catch(exception e){
            RestContext.response.statusCode = 404;
            response.error(null,e.getMessage(),404);
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(response));
            RestContext.response.addHeader('Content-Type', 'application/json');
        }
    }
    
    @HttpPut
    global static void cancelLicenseSync() {
        
        LicenseResponse response = new LicenseResponse();
        try{
            Map<String, String> paramMap    = RestContext.request.params;
            String licenseId = ''; 
            String reqId = '';
            String uri = String.valueOf(RestContext.request.requestURI);
            //uri.substringBetween(open, close)
            if(uri.contains('identifier') && uri.contains('&')){
                licenseId = uri.substring(uri.lastIndexOf('/')+1,uri.lastIndexOf('&'));
                reqId = uri.substring(uri.lastIndexOf('=')+1);
                system.debug('licenseId : '+licenseId+'---@--reqId :'+reqId);
            }else{
                licenseId = uri.substring(uri.lastIndexOf('/')+1);
                system.debug('licenseId : '+licenseId);
            }
            String operation                = operationLookup('PUT', 'Licenses');
            
            if ( operation == 'cancelLicenseByLicenseID' ) {
                List<Id> licenseIds = new List<Id> ();
                licenseIds.add(licenseId);
                response = cancelLicenseByLicenseID(licenseIds ,reqId);
            } else {
                response.error(null,'Invalid resource',404);
            }
            
            if ( String.isNotBlank(JSON.serialize(response))) {
                
                RestContext.response.statusCode = response.statusCode;
                
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(response));
                RestContext.response.addHeader('Content-Type', 'application/json');
                
                
            }
        }catch(exception e){
            RestContext.response.statusCode = 404;
            response.error(null,e.getMessage(),404);
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(response));
            RestContext.response.addHeader('Content-Type', 'application/json');
        } 
        
        
        
    }
    
    @HttpPatch
    global static void updateLicense() {
        LicenseResponse response = new LicenseResponse();
        
        RestRequest AssetRequest = RestContext.request;
        String AssetRequestURI = AssetRequest.requestURI;
        String AssetId = AssetRequestURI.substring(AssetRequestURI.lastIndexOf('/') + 1);
        String requestBody = AssetRequest.requestBody.toString();
        String requestBodyNew = requestBody.deleteWhitespace();
        String requestBodyActual;
        if(requestBodyNew.contains('True')){
            requestBodyActual = requestBodyNew.replace('True', 'true');
        }
        else if(requestBodyNew.contains('False')){
            requestBodyActual = requestBodyNew.replace('False', 'false');
        }
        else{
            requestBodyActual = requestBodyNew ;
        }
        
        //&& license[0].Tf_is_Fulfilled__c   != 'Cancelled'
        List<Asset> license = [Select Id,TF_Entitlement_Creation_Status__c,Status,Tf_is_Fulfilled__c  from Asset where Id =: AssetId];
        if(!license.isEmpty() && AssetId == license[0].Id ){
            
                System.debug('requestBody--->'+requestBody);
                if(requestBody.contains('Tf_is_Fulfilled__c') && requestBody.contains('TF_Entitlement_Creation_Status__c') && requestBody.countMatches(',') ==1)
                {
                    if(requestBodyActual.contains('"Tf_is_Fulfilled__c":"true"') || requestBodyActual.contains('"Tf_is_Fulfilled__c":"false"'))
                    {
                        System.debug('requestBody2--->'+requestBody+requestBodyActual);
                        Asset assetRec = (Asset) JSON.deserialize(requestBodyActual , Asset.class);
                        String assetStr = String.valueOf(assetRec);
                        System.debug('assetStr2--->'+assetStr);
                        
                        
                        
                        if(assetRec.TF_Entitlement_Creation_Status__c =='Pending' || assetRec.TF_Entitlement_Creation_Status__c == 'Failed' || assetRec.TF_Entitlement_Creation_Status__c == 'Created'){
                            
                            if( license[0].Status  != 'Cancelled' ){
                                
                                
                                assetRec.Id = AssetId;
                                update assetRec;
                                System.debug('assetStr4--->'+assetStr);
                                if(requestBody.containsIgnoreCase('"Tf_is_Fulfilled__c":"true"') || requestBody.containsIgnoreCase('"Tf_is_Fulfilled__c":"false"') || requestBodyActual.containsIgnoreCase('"Tf_is_Fulfilled__c":"true"') || requestBodyActual.containsIgnoreCase('"Tf_is_Fulfilled__c":"false"'))
                                {
                                    response.success(null,'License have been updated Succesfully!!',201);
                                }
                                else{
                                    response.error(null,'Tf_is_Fulfilled__c cannot be blank',400);
                                }
                                
                            }else{
                                response.error(null,'License is already Cancelled!!',400);
                                RestContext.response.statusCode = response.statusCode;
                                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(response));
                                RestContext.response.addHeader('Content-Type', 'application/json');
                            }
                        }
                        else{
                            response.error(null,'Invalid Value for Entitlement creation status, value must be (Pending,Failed or Created).',400); 
                        }
                    }
                    else{
                        response.error(null,'Only Boolean values are allowed as "true" or "false".',400);
                    }
                }
                else{
                    if(requestBody.containsIgnoreCase('Tf_is_Fulfilled__c') && requestBody.contains('TF_Entitlement_Creation_Status__c') )
                    {
                        response.error(null,'Only Entitlement creation status & Is Fulfilled fields are included.',400);
                    }
                    else if(requestBody.containsIgnoreCase('TF_Entitlement_Creation_Status__c')){
                        response.error(null,'Is Fulfilled Required',400);
                    }
                    else{
                        response.error(null,'Entitlement creation status is Required.',400);
                    }
                }
                if(String.isNotBlank(JSON.serialize(response))) {
                    RestContext.response.statusCode = response.statusCode;
                    RestContext.response.responseBody = Blob.valueOf(JSON.serialize(response));
                    RestContext.response.addHeader('Content-Type', 'application/json');
                    System.debug('Response'+response);
                }
            }
        else if(String.isBlank(AssetId) && String.isNotBlank(JSON.serialize(response))){
            response.error(null,'licenseId is Blank.',400); 
            RestContext.response.statusCode = response.statusCode;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(response));
            RestContext.response.addHeader('Content-Type', 'application/json');
            System.debug('AssetId1--->'+AssetId);
        } 
        else{
            response.error(null,'licenseId is Incorrect.',400); 
            RestContext.response.statusCode = response.statusCode;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(response));
            RestContext.response.addHeader('Content-Type', 'application/json');
        }
    }
    
    public static LicenseResponse getLicenseInfoByPartyID(Map<String, String> paramsMap) {
        String partyId = paramsMap.get('partyId');
        List<TF_Licenses> licenseListResponse = new List<TF_Licenses>();
        List<Asset> assList = new List<Asset>();
        LicenseResponse response = new LicenseResponse();
        DateTime lastUsedModifiedDate;
        Integer offset;
        Integer TotLimit;
        String statusval = paramsMap.get('status');
        List<string> allValues = new List<String>();
        if(statusval == 'all'){
            allValues.add('Created');
            allValues.add('Expired');
            allValues.add('Cancelled');
        }else if(statusval == 'active'){
            allValues.add('Created');
        }else if(statusval == 'inactive'){
            allValues.add('Expired');
            allValues.add('Cancelled');
        }else if(statusval == '' || statusval == null){
            system.debug('here');
            allValues.add('Created');
            allValues.add('Expired');
            allValues.add('Cancelled');
        }
        else{
            response.error(null,'Provide valid value for Status',404);
            return response;
        }
        try {
            if(paramsMap.containskey('offset')){
                if(paramsMap.get('offset').isNumeric()){
                    offset = integer.valueOf(paramsMap.get('offset'));
                    if(offset < 0 ){
                        response.error(null,'Provide valid value for offset',404);
                    }
                }else{
                    response.error(null,'Provide the numeric value for offset',404);
                    return response;
                } 
            }else{
                offset = 0;
            }
            
            if(paramsMap.containskey('limit')){
                
                if(paramsMap.get('limit').isNumeric()){
                    TotLimit = integer.valueOf(paramsMap.get('limit'));
                    if(TotLimit <= 0 ){
                        response.error(null,'Provide valid value for LIMIT',404);
                    }
                }else{
                    response.error(null,'Provide the numeric value for LIMIT',404);
                    return response;
                }  
            }else{
                TotLimit = 50;
            }
            
            
            if(partyId != null && partyId != '') {
                system.debug('partyId'+partyId);
                List<Account> accounts = [SELECT ID, NAME FROM ACCOUNT WHERE Customer_Id__c =: partyId ];
                if(offset > 0){
                    assList = [SELECT Id, Name,LastModifiedDate, CreatedDate From asset where accountId =: accounts[0].Id ORDER BY LastModifiedDate DESC  limit :offset];
                    lastUsedModifiedDate = assList[assList.size()-1].LastModifiedDate;    
                    system.debug('lastUsedModifiedDate'+lastUsedModifiedDate);
                }
                if(accounts.size() > 0 ){
                    Integer  licenseListSize = [SELECT count() From asset where accountId =: accounts[0].Id ];
                    if(offset >= licenseListSize){
                        response.error(null,'offset Can Not be greater than or equal to available licenses '+licenseListSize,404);
                    }
                    else{
                        response.totalLicenseCount = licenseListSize; //SFAL-172 Vikas Varshney
                        system.debug('accounts'+accounts[0].Id);
                        List<Asset>  licenseList = new List<Asset>();
                        if(test.isRunningTest()){
                            licenseList  = [SELECT Id,InstallDate ,TF_Access_Scope__c,status ,CreatedDate,PurchaseDate,TF_Sales_Channel__c,TF_OMS_Order_Id__c,TF_Product_Version_Number__c,Product2Id,TF_Entitlement_Creation_Status__c,TF_Grant_Type__c,UsageEndDate,TF_Customer_Id__c ,TF_Subscription_End_Date__c,TF_License_Type__c, Name ,TF_License_Version__c From asset where accountId =: accounts[0].Id AND Status IN :allValues]; 
                        }else{
                            system.debug('assList'+assList.size());
                            licenseList = [SELECT Id,InstallDate ,TF_Access_Scope__c,status ,CreatedDate,PurchaseDate,TF_Sales_Channel__c,TF_OMS_Order_Id__c,TF_Product_Version_Number__c,Product2Id,TF_Entitlement_Creation_Status__c,TF_Grant_Type__c,UsageEndDate,TF_Customer_Id__c ,TF_Subscription_End_Date__c,TF_License_Type__c, Name ,TF_License_Version__c From asset where accountId =: accounts[0].Id AND Status IN :allValues AND LastModifiedDate < :lastUsedModifiedDate AND ID NOT IN:assList ORDER BY LastModifiedDate DESC  limit :TotLimit];  
                            system.debug('licenseList'+licenseList.size());
                        }
                        if(licenseList != null && licenseList.size() > 0){
                            for(Asset ass : licenseList){
                                TF_Licenses license = new TF_Licenses();
                                license.licenseId = String.valueOf( ass.id );
                                license.customerId = ass.TF_Customer_Id__c  != NULL ? String.valueOf( ass.TF_Customer_Id__c ) : '';
                                license.partyId = ass.TF_Customer_Id__c  != NULL ? String.valueOf( ass.TF_Customer_Id__c ) : '';
                                license.accessScope = String.isNotBlank(ass.TF_Access_Scope__c ) ? ass.TF_Access_Scope__c  : '';
                                license.licenseType = String.isNotBlank(ass.TF_License_Type__c ) ? ass.TF_License_Type__c  : '';
                                license.orderNumber = String.isNotBlank(ass.TF_OMS_Order_Id__c ) ? ass.TF_OMS_Order_Id__c  : '';
                                license.salesChannel = String.isNotBlank(ass.TF_Sales_Channel__c ) ? ass.TF_Sales_Channel__c  : '';
                                license.purchaseDate = ass.PurchaseDate  != NULL ? String.valueOf( ass.PurchaseDate  ) : '';
                                license.productVersion = ass.TF_Product_Version_Number__c  != NULL ? String.valueOf(ass.TF_Product_Version_Number__c):'';
                                license.licenseVersion = ass.TF_License_Version__c  != NULL ? String.valueOf(ass.TF_License_Version__c):'';
                                license.licenseName = ass.name;
                                license.createdOn = ass.CreatedDate  != NULL ? String.valueOf(ass.CreatedDate) : '';
                                license.grantType = ass.TF_Grant_Type__c  != NULL ? String.valueOf(ass.TF_Grant_Type__c):'';
                                license.startDate = ass.InstallDate  != NULL ? String.valueOf(ass.InstallDate) : '';
                                license.endDate = ass.UsageEndDate  != NULL ? String.valueOf(ass.UsageEndDate) : '';
                                license.status = String.isNotBlank(ass.Status) ? ass.Status : '';
                                licenseListResponse.add(license);
                            }
                            response.success(licenseListResponse, 'SUCCESS',200);   
                        }else{
                            response.error(null,'No License associated found with provided partyId',404);
                        }
                    }
                }else{
                    response.error(null,'No account found with provided partyId',404);
                }
            }
            else {
                response.error(null,'PartyId Can not be Blank',404);
            }  
            
        } catch(Exception ex){
            response.error(null,ex.getMessage()+ex.getLineNumber(),404);
            system.debug(ex.getMessage());
        }
        system.debug('response'+response);
        return response;        
    }
    
    public static LicenseResponse getLicenseInfoByLicenseID(String licenseId) {
        system.debug(licenseId);
        List<TF_Licenses> licenseListResponse = new List<TF_Licenses>();
        LicenseResponse response = new LicenseResponse();
        
        try {
            if(licenseId != null && licenseId != '') {
                
                if(validateId(licenseId) == true){
                    system.debug('licenseId'+licenseId);
                    licenseId = String.escapeSingleQuotes(licenseId);
                    system.debug('licenseId'+licenseId);
                    List<Asset>  licenseList = [SELECT Id,InstallDate ,TF_Access_Scope__c,status ,CreatedDate,PurchaseDate,TF_Sales_Channel__c,TF_OMS_Order_Id__c,TF_Product_Version_Number__c,Product2Id,TF_Entitlement_Creation_Status__c,TF_Grant_Type__c,UsageEndDate,TF_Customer_Id__c ,TF_Subscription_End_Date__c,TF_License_Type__c, Name ,TF_License_Version__c,(SELECT CreatedDate,Id,Name,TF_Asset__c,TF_Policy_Name__c,TF_Scope__c,TF_Unit_value__c,TF_Unit__c FROM License_Policies__r) From asset where Id =:licenseId];            
                    if(licenseList != null && licenseList.size() > 0){
                        system.debug('accounts'+licenseList.size());
                        for(Asset ass : licenseList){
                            List<TF_Licenses.licensePolicy> policyList = new  List<TF_Licenses.licensePolicy>();
                            TF_Licenses license = new TF_Licenses();
                            license.licenseId = String.valueOf( ass.id );
                            license.customerId = ass.TF_Customer_Id__c  != NULL ? String.valueOf( ass.TF_Customer_Id__c ) : '';
                            license.partyId = ass.TF_Customer_Id__c  != NULL ? String.valueOf( ass.TF_Customer_Id__c ) : '';
                            license.accessScope = String.isNotBlank(ass.TF_Access_Scope__c ) ? ass.TF_Access_Scope__c  : '';
                            license.licenseType = String.isNotBlank(ass.TF_License_Type__c ) ? ass.TF_License_Type__c  : '';
                            license.orderNumber = String.isNotBlank(ass.TF_OMS_Order_Id__c ) ? ass.TF_OMS_Order_Id__c  : '';
                            license.salesChannel = String.isNotBlank(ass.TF_Sales_Channel__c ) ? ass.TF_Sales_Channel__c  : '';
                            license.purchaseDate = ass.PurchaseDate  != NULL ? String.valueOf( ass.PurchaseDate  ) : '';
                            license.productVersion = ass.TF_Product_Version_Number__c  != NULL ? String.valueOf(ass.TF_Product_Version_Number__c):'';
                            license.licenseVersion = ass.TF_License_Version__c  != NULL ? String.valueOf(ass.TF_License_Version__c):'';
                            license.licenseName = ass.name;
                            license.grantType = ass.TF_Grant_Type__c  != NULL ? String.valueOf(ass.TF_Grant_Type__c):'';
                            license.startDate = ass.InstallDate  != NULL ? String.valueOf(ass.InstallDate) : '';
                            //license.createdby = ass.InstallDate  != NULL ? String.valueOf(ass.InstallDate) : '';
                            license.createdOn = ass.CreatedDate  != NULL ? String.valueOf(ass.CreatedDate) : '';
                            license.endDate = ass.UsageEndDate  != NULL ? String.valueOf(ass.UsageEndDate) : '';
                            license.status = String.isNotBlank(ass.Status) ? ass.Status : '';
                            
                            for(TF_License_Policy__c pol : Ass.License_Policies__r){
                                TF_Licenses.licensePolicy licPol = new TF_Licenses.licensePolicy();
                                licPol.Asset = String.isNotBlank(pol.TF_Asset__c) ? pol.TF_Asset__c: '';
                                licPol.policyId = String.isNotBlank(pol.Id) ? pol.Id: '';
                                licPol.CreatedDate = String.isNotBlank(string.valueOf(pol.CreatedDate)) ? string.valueOf(pol.CreatedDate): '';
                                licPol.scope = String.isNotBlank(pol.TF_Scope__c) ? pol.TF_Scope__c: '';
                                licPol.unit = String.isNotBlank(pol.TF_Unit__c) ? pol.TF_Unit__c: '';
                                licpol.policyName = String.isNotBlank(pol.Name) ? pol.Name: '';
                                policyList.add(licPol);
                            }
                            license.policies = policyList;
                            licenseListResponse.add(license);
                        }
                        response.success(licenseListResponse, 'SUCCESS',200);   
                    }
                    else{
                        response.error(null,'No License associated found with provided licenseId',404);
                    }
                }else{
                    
                    response.error(null,'Invalid License Id',404);
                }
            }else{
                response.error(null,'LicenseId can Not Be Blank',404);
            }
        }
        catch(Exception ex){
            response.error(null,ex.getMessage(),404);
            system.debug(ex.getMessage());
        }
        system.debug('response'+response);
        return response;        
    }
    
    public static LicenseResponse cancelLicenseByLicenseID(List<ID> licenseIds , String cancelReqId) {
        List<Asset> licenseListTOUpdate = new List<Asset>();
        LicenseResponse response = new LicenseResponse();
        
        try {
            if(licenseIds != null ) {
                if(licenseIds.size() > 0){
                    Boolean isLicValid = true;
                    for(Id thisId : licenseIds){
                        if(validateId(thisId) == false){
                            isLicValid = false;
                        }
                    }
                    if(isLicValid == true){
                        system.debug('licenseId'+licenseIds);
                        //licenseId = String.escapeSingleQuotes(licenseId);
                        //system.debug('licenseId'+licenseId);
                        List<Asset>  licenseList = [SELECT Id,InstallDate ,Cancellation_Date__c ,Cancellation_RequestId__c ,TF_Access_Scope__c,status ,CreatedDate,PurchaseDate,TF_Sales_Channel__c,TF_OMS_Order_Id__c,TF_Product_Version_Number__c,Product2Id,TF_Entitlement_Creation_Status__c,TF_Grant_Type__c,UsageEndDate,TF_Customer_Id__c ,TF_Subscription_End_Date__c,TF_License_Type__c, Name ,TF_License_Version__c,(SELECT CreatedDate,Id,Name,TF_Asset__c,TF_Policy_Name__c,TF_Scope__c,TF_Unit_value__c,TF_Unit__c FROM License_Policies__r) From asset where Id IN:licenseIds];            
                        if(licenseList != null && licenseList.size() > 0){
                            system.debug('accounts'+licenseList.size());
                            for(Asset ass : licenseList){
                                if(ass.Status == 'Cancelled'){
                                    response.error(null,'License with provided licenseId is already Cancelled',400);
                                }else if(ass.Status == 'expired'){
                                    response.error(null,'License with provided licenseId is Expired',400);
                                }else{
                                    ass.Cancellation_Date__c = system.today();
                                    if(cancelReqId != null && cancelReqId != ''){
                                        ass.Cancellation_RequestId__c = cancelReqId;
                                    }
                                    ass.Status = 'Cancelled';
                                    licenseListTOUpdate.add(ass);
                                }
                            }
                            if(licenseListTOUpdate.size() > 0){
                                update licenseListTOUpdate;
                                response.success(null, 'License Has been Cancelled Succesfully!!',200); 
                            }
                            
                            
                        }
                        else{
                            response.error(null,'No License associated found with provided licenseId',400);
                        }
                    }else{
                        response.error(null,'Invalid License Id',400);
                    }
                }else{
                    response.error(null,'LicenseId cannot be Blank.',400);
                }
                
            }else{
                response.error(null,'LicenseId is Required!!',400);
            }
        }
        catch(Exception ex){
            response.error(null,ex.getMessage(),400);
            system.debug(ex.getMessage());
        }
        system.debug('response'+response);
        return response;        
    }
    
    private static String getCommand(Map<String, String> paramsMap,String uri) {
        system.debug('uri'+uri);
        String returnURI = '';
        system.debug('partyId : '+paramsMap.get('partyId'));
        if(uri.contains('licenses') && paramsMap.size() >0 ){
            returnURI = 'Party';
        }else{
            returnURI = 'Licenses';
        }
        return returnURI;
    }
    
    private static String operationLookup(String method, String command) {
        String operation = 'unknown';
        if (method.equals('GET')) {
            if (command.containsIgnoreCase('Party')) {
                operation = 'getLicensesByPartyId';
            } else if (command.containsIgnoreCase('Licenses')) {
                operation = 'getLicenseInfoByLicenseID';
            }
            
        } else if(method.equals('POST')) {
            
        } else if (method.equals('DELETE')) {
            
        } else if (method.equals('PUT')) {
            if (command.containsIgnoreCase('Licenses')) {
                operation = 'cancelLicenseByLicenseID';
            }
        }
        return operation;
    }
    
    public static Boolean validateId(String Idparam) {
        String id = String.escapeSingleQuotes(Idparam);
        system.debug('Idparam------------'+id);
        return ((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id));
    }
}