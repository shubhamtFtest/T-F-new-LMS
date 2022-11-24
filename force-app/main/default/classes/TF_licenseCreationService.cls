/**
Author : shubham kumar
Test class :  TF_licenseCreationServiceTest 
Description : This class is being used to create the Asset & Record Creation Request & License policies Corresponding to the request from OMS or directly from salesforce.
**/
public class TF_licenseCreationService {
     
    private static map<String,Account> accByPartyId = new map<String,Account>();
    private static map<String,product2> productDetailByHubId = new map<String,product2>();
    private static map<String, List<TF_License_Policy__c>> licensePoliciesByUUID = new  map<String,List<TF_License_Policy__c>>();
    List<Asset> LicensesToBeInserted = new List<Asset>();
    List<TF_License_Policy__c> licensePoliciesToBeInserted = new List<TF_License_Policy__c>();
    private integer numberOfLicenses = 0;
    
    public TF_LicenseCreateRequestWrapper.LicenseCreateResponse create(TF_LicenseCreateRequestWrapper req) {
        
        try{  
            String Response = '';
            String OrderId = '';
            List<String> productUUIds = new List<String>();
            for(TF_LicenseCreateRequestWrapper.LicensedProduct product : req.requestPayload.products) {
                if(product.productUUID != null && product.productUUID != ''){ 
                    productUUIds.add(product.productUUID);
                }
            }
            
            List<Product2> prodlists = [SELECT id,Hub_Id__c, name from product2 where Hub_Id__c IN: productUUIds];
            
            if(prodlists.size() > 0){
                for(Product2 prod : prodlists){
                    productDetailByHubId.put(prod.Hub_Id__c,prod);
                }
            }
            
            TF_LicenseCreateRequestWrapper.LicenseCreateResponse CreationReqRes = createLicenseRequestObject(req);
            
            TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
            
            if(CreationReqRes.requestId != null && (CreationReqRes.requestId.length() == 18 || CreationReqRes.requestId.length() == 15)){
                List<String> accIds = new List<String>();
                if(req.requestPayload.customer.members != null && req.requestPayload.customer.members.size() > 0){
                    for(String memberId : req.requestPayload.customer.members) {
                        accIds.add(memberId);
                    }
                }
                accIds.add(req.requestPayload.Customer.partyId);
                List<account> accList= [SELECT id,name,Customer_Id__c from Account where Customer_Id__c IN:accIds];
                for(account acc:accList){
                    accByPartyId.put(acc.Customer_Id__c,acc);     
                }
                for(TF_LicenseCreateRequestWrapper.LicensedProduct product : req.requestPayload.products) {
                    //createLicense(CreationReqRes.requestId,req.requestPayload.orderId, req.requestPayload.customer, product);
                    
                    if(req.requestPayload.customer.type == 'INSTITUTION' || req.requestPayload.customer.type == 'CONSORTIUM') {
                        OrderId = req.requestPayload.orderId;
                        createAsset(null,CreationReqRes.requestId,req.requestPayload.orderId,req.requestPayload.customer.partyId,product);
                    }
                }
                if(licensePoliciesByUUID.size() > 0 ){
                    system.debug('licensePoliciesByUUID'+licensePoliciesByUUID);
                    insert LicensesToBeInserted;
                    numberOfLicenses = LicensesToBeInserted.size();
                    List<Asset> assList = [select id,Name,Product2.Hub_Id__c from Asset where ID IN:LicensesToBeInserted];
                    system.debug('assList'+assList);
                    for(Asset ass : assList){
                        for(TF_License_Policy__c Tf_Pol: licensePoliciesByUUID.get(ass.Product2.Hub_Id__c)){
                            Tf_Pol.TF_Asset__c = ass.Id;
                            licensePoliciesToBeInserted.add(Tf_Pol);
                        }
                    }
                    Insert licensePoliciesToBeInserted;
                }
                
                if(Licenseresponse.statuscode != 400 && Licenseresponse.statuscode != 404){
                    TF_LicenseCreateRequestWrapper.LicenseCreateResponse objWrapper = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
                    List<TF_LicenseCreateRequestWrapper.licensesWrapper> licenseList = new  List<TF_LicenseCreateRequestWrapper.licensesWrapper>();
                    objWrapper.statusCode = 201;
                    for(Asset assetsData : [select id,name,TF_OMS_Order_Id__c,Status,TF_License_Version__c from Asset where TF_License_Creation_Request__c=:CreationReqRes.requestId ]) {
                        TF_LicenseCreateRequestWrapper.licensesWrapper obj = new TF_LicenseCreateRequestWrapper.licensesWrapper();
                        obj.orderLineItemId = assetsData.TF_OMS_Order_Id__c;
                        obj.licenseId = assetsData.Id;
                        obj.licenseVersion = String.valueOf(assetsData.TF_License_Version__c);
                        obj.status = assetsData.status;
                        licenseList.add(obj);
                    }
                    Licenseresponse.requestId = CreationReqRes.requestId;
                    Licenseresponse.numberOfLicenses = numberOfLicenses;
                    Licenseresponse.statuscode = 201;
                    Licenseresponse.orderId = integer.valueOf(OrderId);
                    Licenseresponse.licenses = licenseList;
                    Licenseresponse.statusMessage = 'Licenses Have been Created Succesfully!!';
                }
            }else{
                Licenseresponse.requestId = null;
                Licenseresponse.numberOfLicenses = 0;
                Licenseresponse.statuscode = CreationReqRes.statusCode;
                Licenseresponse.statusMessage = CreationReqRes.statusMessage;
            }
            
            return Licenseresponse;    
        }
        catch(Exception e){
            system.debug('Exception'+e.getMessage()+'-@-'+e.getLineNumber());
            TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
            Licenseresponse.statuscode = 404;
            Licenseresponse.statusMessage = e.getMessage();
            return Licenseresponse;
        }
    }
    
    private void createAsset(Id parentAsserID, Id requestId,String orderId, String partyID,TF_LicenseCreateRequestWrapper.LicensedProduct product) {
        try{
            Asset newAsset = new Asset();
            Id PRODUCTRECORDTYPEID = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('T&F-License').getRecordTypeId();
            
            newAsset.RecordTypeId = PRODUCTRECORDTYPEID;
            newAsset.TF_Access_Scope__c = product.licenseDetails.accessScope;
            newAsset.AccountId = accByPartyId.get(partyID).Id;
            newAsset.TF_Sales_Channel__c = product.licenseDetails.channel;
            newAsset.TF_Entitlement_Creation_Status__c = 'Pending';
            newAsset.Status = 'Created';
            if(product.licenseDetails.startDate != null){
                newAsset.InstallDate = date.valueOf(product.licenseDetails.startDate);
            }
            
            if( product.licenseDetails.licenseUpdateType == 'dynamic') {
                if(product.licenseDetails.licenseType == 'Subscription'){
                    if(product.licenseDetails.endDate != null){
                        newAsset.UsageEndDate = date.valueOf(product.licenseDetails.endDate);  
                    }    
                }
                if(product.licenseDetails.licenseUpdateEndDate != null){
                    newAsset.TF_Subscription_End_Date__c = date.valueOf(product.licenseDetails.licenseUpdateEndDate);
                }
            }
            newAsset.TF_Grant_Type__c = product.licenseDetails.policies.grantType[0];
            newAsset.TF_License_Creation_Request__c  = requestId;
            newAsset.TF_License_Type__c = product.licenseDetails.licenseUpdateType;
            newAsset.TF_Business_Model__c   = product.licenseDetails.licenseType;
            newAsset.TF_License_Version__c = decimal.valueOf(product.version);
            
            if(parentAsserID != null) {
                newAsset.ParentId = parentAsserID;  
                newAsset.Name = productDetailByHubId.get(product.productUUID).Name  + '-' + accByPartyId.get(partyID).Name;
            } else {
                newAsset.Name = productDetailByHubId.get(product.productUUID).Name;        
            }
            newAsset.TF_OMS_Order_Id__c = product.orderLineItemId;
            newAsset.TF_Product_Version_Number__c = product.version;
            newAsset.Product2Id = productDetailByHubId.get(product.productUUID).Id;
            newAsset.TF_Product_Type__c = product.productType;
            newAsset.PurchaseDate = Date.today();
            LicensesToBeInserted.add(newAsset);
            
            List<TF_License_Policy__c> licensePoliciesList = new List<TF_License_Policy__c>();
            system.debug('asset has been inserted succesfully!!!'+newAsset.Id);
            // To create License Policy
            if(product.licenseDetails.policies != null && product.licenseDetails.policies.drm == true) {
                if(product.licenseDetails.policies.concurrency != null && integer.valueOf(product.licenseDetails.policies.concurrency) > 0 ) {
                    TF_License_Policy__c policy1 = new TF_License_Policy__c();
                    policy1.TF_Asset__c = newAsset.Id;                
                    policy1.TF_Policy_Name__c = 'Concurrency'; 
                    policy1.TF_Scope__c = product.licenseDetails.accessScope;
                    policy1.TF_Unit__c = 'Count';
                    policy1.TF_Unit_value__c = product.licenseDetails.policies.concurrency;
                    licensePoliciesList.add(policy1);
                }
                
                if(product.licenseDetails.policies.printCount != null && integer.valueOf(product.licenseDetails.policies.printCount) > 0 ) {
                    TF_License_Policy__c policy2 = new TF_License_Policy__c();
                    policy2.TF_Asset__c = newAsset.Id;                
                    policy2.TF_Policy_Name__c = 'Print'; 
                    policy2.TF_Scope__c = product.licenseDetails.accessScope;
                    policy2.TF_Unit__c = 'Count';
                    policy2.TF_Unit_value__c = product.licenseDetails.policies.printCount;
                    licensePoliciesList.add(policy2);
                }
                if( product.licenseDetails.policies.copyCount != null && integer.valueOf(product.licenseDetails.policies.copyCount) > 0) {
                    TF_License_Policy__c policy3 = new TF_License_Policy__c();
                    policy3.TF_Asset__c = newAsset.Id;                
                    policy3.TF_Policy_Name__c = 'Copy'; 
                    policy3.TF_Scope__c = product.licenseDetails.accessScope;
                    policy3.TF_Unit__c = 'Count';
                    policy3.TF_Unit_value__c = product.licenseDetails.policies.copyCount;
                    licensePoliciesList.add(policy3);
                }            
            }
            licensePoliciesByUUID.put(product.productUUID,licensePoliciesList);
            
        }
        catch(Exception e){
            system.debug('Exception'+e.getMessage()+'-@-'+e.getLineNumber());
            TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
            Licenseresponse.statuscode = 404;
            Licenseresponse.statusMessage = 'Invalid Party ID';
            
        }
    }
    
    private TF_LicenseCreateRequestWrapper.LicenseCreateResponse createLicenseRequestObject(TF_LicenseCreateRequestWrapper req) {
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse response = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        try{
            Record_Creation_Request__c recordRequest = new Record_Creation_Request__c();
            recordRequest.TF_Request_JSON__c = JSON.serialize(req);
            recordRequest.TF_Response_Payload__c = JSON.serialize(req.requestPayload);
            
            //ordernumber validation
            response = isNotNullorEmpty('orderNumber',req.orderNumber,null,false,false);
            if(response.statuscode == 400 || response.statuscode == 404){
                return response;
            }
            //callback Url validation
            response = isNotNullorEmpty('callBackurl',req.callBackurl,null,false,false);
            if(response.statuscode == 400 || response.statuscode == 404){
                return response;
            }
            //RequestType validation
            response = isNotNullorEmpty('requestType',req.requestType,new list<String> {'Create'},false,false);
            if(response.statuscode == 400 || response.statuscode == 404){
                return response;
            }
            if(req.requestPayload != null){
                
                //source validation
                response = isNotNullorEmpty('source',req.requestPayload.source,new list<String> { 'OMS' },false,false);
                if(response.statuscode == 400 || response.statuscode == 404){
                    return response;
                }
                
                //salesChannel validation
                response = isNotNullorEmpty('salesChannel',req.requestPayload.salesChannel,new list<String> { 'UBX' },false,false);
                if(response.statuscode == 400 || response.statuscode == 404){
                    return response;
                }
                
                
                //orderId validation
                response = isNotNullorEmpty('orderId',req.requestPayload.orderId,null,false,false);
                if(response.statuscode == 400 || response.statuscode == 404){
                    return response;
                }
                
                //Customer , Customer Type ,PartyId, Members Validation
                if( req.requestPayload.customer != null ){
                    //Party Id validation
                    response = isNotNullorEmpty('partyId',req.requestPayload.Customer.partyId,null,false,false);
                    if(response.statuscode == 400 || response.statuscode == 404){
                        return response;
                    }
                    List<account> accList = [SELECT id,name from Account where Customer_Id__c = :req.requestPayload.Customer.partyId];     
                    if(accList.size() > 0){
                        recordRequest.Customer_Id__c = decimal.valueOf(req.requestPayload.Customer.partyId);
                    }else{
                        response.statusMessage = 'Party Id is Invalid.';
                        response.statuscode = 400;
                        return response;
                    }
                    
                    //Customer Type validation
                    response = isNotNullorEmpty('Customertype',req.requestPayload.Customer.type,new list<String> { 'CONSORTIUM','INSTITUTION'},false,false);
                    if(response.statuscode == 400 || response.statuscode == 404){
                        return response;
                    }
                    if( req.requestPayload.customer.type == 'CONSORTIUM'){
                        //Members Validation
                        if(req.requestPayload.Customer.members != null){
                            response = isNotNullorEmpty('MemberId',req.requestPayload.Customer.members[0],null,false,false);
                            if(response.statuscode == 400 || response.statuscode == 404){
                                return response;
                            }
                            list<account> acclists= [SELECT id,name from Account where Customer_Id__c = :req.requestPayload.Customer.members[0]];
                            
                            if(acclists.size() == 0){
                                response.statusMessage = 'Invalid Member Id';
                                response.statuscode = 404;
                                return response;
                            }
                        }else{
                            response.statusMessage = 'Members Parameter is Required for type CONSORTIUM';
                            response.statuscode = 400;
                            return response;
                        }
                        
                    }else if(req.requestPayload.customer.type == 'INSTITUTION'){
                        if(req.requestPayload.customer.members != null ){
                            response.statusMessage = 'Members Parameter is Not Required.';
                            response.statuscode = 400;
                        }
                    }
                }else{
                    response.statusMessage = 'customer Parameter is Required.';
                    response.statuscode = 400;
                    return response;
                }
                
                //Validation for Products &(Grant Type , License Type,License update Type)..
                if(req.requestPayload.products != null && req.requestPayload.products.size() > 0){
                    for(TF_LicenseCreateRequestWrapper.LicensedProduct product : req.requestPayload.products) {
                        //productUUID  Validation
                        response = isNotNullorEmpty('productUUID',product.productUUID,null,false,false);
                        if(response.statuscode == 400 || response.statuscode == 404){
                            return response;
                        }
                        if(productDetailByHubId.size() > 0 && productDetailByHubId.get(product.productUUID) != null && productDetailByHubId.containsKey(product.productUUID)){
                        }else{ 
                            response.statusMessage ='Product Not Found!!';
                            response.statuscode = 400;
                            return response;
                        }
                        //orderLineItemId  Validation
                        response = isNotNullorEmpty('orderLineItemId',product.orderLineItemId,null,false,false);
                        if(response.statuscode == 400 || response.statuscode == 404){
                            return response;
                        }
                        
                        //Product Version  Validation
                        response = isNotNullorEmpty('version',product.version,null,false,true);
                        if(response.statuscode == 400 || response.statuscode == 404){
                            return response;
                        }
                        
                        //licenseDetails Validations
                        
                        if(product.licenseDetails != null){
                            //licenseType Validation
                            response = isNotNullorEmpty('licenseType',product.licenseDetails.licenseType,new list<String> {'Subscription','Perpetual'},false,false);
                            if(response.statuscode == 400 || response.statuscode == 404){
                                
                                return response;
                            }
                            
                            //startDate Validation
                            response = isNotNullorEmpty('startDate',product.licenseDetails.startDate,null,false,false);
                            if(response.statuscode == 400 || response.statuscode == 404){
                                return response;
                            }
                            if(dateValidation(product.licenseDetails.startDate) == true){
                                if(date.valueOf(product.licenseDetails.startDate) < system.today()){
                                    response.statusMessage = 'startDate cannot be earlier than today date.';
                                    response.statuscode = 400; 
                                    return response;
                                }    
                            }else{
                                response.statusMessage = 'startDate is invalid.';
                                response.statuscode = 400; 
                                return response;
                            }
                            
                            if(product.licenseDetails.licenseType == 'Subscription'){
                                //EndDate Validations
                                response = isNotNullorEmpty('endDate',product.licenseDetails.endDate,null,false,false);
                                if(response.statuscode == 400 || response.statuscode == 404){
                                    return response;
                                }
                                //startDate Validation
                                response = isNotNullorEmpty('startDate',product.licenseDetails.startDate,null,false,false);
                                if(response.statuscode == 400 || response.statuscode == 404){
                                    return response;
                                }
                                
                                if(dateValidation(product.licenseDetails.endDate) == true && dateValidation(product.licenseDetails.startDate) == true){
                                    system.debug(dateValidation(product.licenseDetails.endDate));
                                    if(product.licenseDetails.endDate <= product.licenseDetails.startDate){
                                        response.statusMessage = 'start date cannot be greater than the endDate .';
                                        response.statuscode = 400; 
                                        return response;
                                    }
                                }else{
                                    if(dateValidation(product.licenseDetails.endDate) == false){
                                        response.statusMessage = 'endDate is invalid.';
                                    }else{
                                        response.statusMessage = 'startDate is invalid.';
                                    }
                                    response.statuscode = 400; 
                                    return response;
                                } 
                            }else if(product.licenseDetails.licenseType == 'Perpetual'){
                                if(product.licenseDetails.endDate != null){
                                    response.statusMessage = 'End date is not needed for Perpetual type.';
                                    response.statuscode = 400;
                                    return response;
                                }
                            }
                            
                            //licenseUpdateType Validation
                            response = isNotNullorEmpty('licenseUpdateType',product.licenseDetails.licenseUpdateType,new list<String> { 'Static','Dynamic'},false,false);
                            if(response.statuscode == 400 || response.statuscode == 404){
                                return response;
                            }
                            if(product.licenseDetails.licenseUpdateType == 'Dynamic'){
                                //License Update End Date Validations
                                response = isNotNullorEmpty('licenseUpdateEndDate',product.licenseDetails.licenseUpdateEndDate,null,false,false);
                                if(response.statuscode == 400 || response.statuscode == 404){
                                    return response;
                                }   
                                if(dateValidation(product.licenseDetails.licenseUpdateEndDate) == true){
                                    if(date.valueOf(product.licenseDetails.licenseUpdateEndDate) <= system.today()){
                                        system.debug('product.licenseDetails.endDate'+product.licenseDetails.endDate);
                                        response.statusMessage = 'License Update End Date cannot be earlier than Today.';
                                        response.statuscode = 400; 
                                        return response;
                                    }
                                }else{
                                    response.statusMessage = 'licenseUpdateEndDate is invalid';
                                    response.statuscode = 400; 
                                    return response;
                                }
                                
                            }
                            //channel Validation
                            response = isNotNullorEmpty('channel',product.licenseDetails.channel,new list<String> {'UBX'},false,false);
                            if(response.statuscode == 400 || response.statuscode == 404){
                                return response;
                            }
                            
                            //accessScope Validation
                            response = isNotNullorEmpty('accessScope',product.licenseDetails.accessScope,new list<String> {'Global'},false,false);
                            if(response.statuscode == 400 || response.statuscode == 404){
                                return response;
                            }
                            
                        }else{
                            response.statusMessage = 'license Details Parameter is Missing.';
                            response.statuscode = 400;   
                        }
                        
                        // Policies Validations
                        
                        if(product.licenseDetails.policies != null){
                            //grantType Validation
                            if(product.licenseDetails.policies.grantType != null){
                                response = isNotNullorEmpty('grantType',string.valueOf(product.licenseDetails.policies.grantType[0]),new list<String> { 'ViewOnline','Download'},false,false);
                                if(response.statuscode == 400 || response.statuscode == 404){
                                    return response;
                                }
                            }
                            //Drm Validations
                            if(product.licenseDetails.policies.drm != null){
                                if(product.licenseDetails.policies.drm == true){
                                    //Copycount Validations  
                                    response = isNotNullorEmpty('copyCount',product.licenseDetails.policies.copyCount,null,true,false);
                                    if(response.statuscode == 400 || response.statuscode == 404){
                                        return response;
                                    }
                                    //printCount Validations
                                    response = isNotNullorEmpty('printCount',product.licenseDetails.policies.printCount,null,true,false);
                                    if(response.statuscode == 400 || response.statuscode == 404){
                                        return response;
                                    }
                                    //concurrency Validations
                                    response = isNotNullorEmpty('concurrency',product.licenseDetails.policies.concurrency,null,true,false);
                                    if(response.statuscode == 400 || response.statuscode == 404){
                                        return response;
                                    }
                                }
                            } 
                        }else{
                            response.statusMessage = 'policies Parameter is mandatory';
                            response.statuscode = 400;
                            return response;
                        }
                        
                        //productType Validation - possible values - Collection/Bespoke Collection/Single Title
                        response = isNotNullorEmpty('productType',product.productType,new list<String> { 'COLLECTION','BESPOKE COLLECTION','SINGLE TITLE'},false,false);
                        if(response.statuscode == 400 || response.statuscode == 404){
                            return response;
                        }
                    }   
                }else{
                    response.statusMessage = 'Product Parameter is mandatory.';
                    response.statuscode = 400;   
                }
                
            }else{
                response.statusMessage = 'payload is mandatory';
                response.statuscode = 400;
            }
            
            //requestId validation
            response = isNotNullorEmpty('requestId',req.requestId,null,false,false);
            
            if(response.statusMessage != null && (response.statuscode == 404 || response.statuscode ==400)){
                system.debug('response'+response);
                return response;
            }else{
                List<Record_Creation_Request__c> existingRequests =  [SELECT Id FROM Record_Creation_Request__c WHERE TF_RequestID__c = :req.requestId];
                if(existingRequests.size() > 0){
                    response.statusMessage = 'Duplicate Request Id.';
                    response.statuscode = 400; 
                }else{
                    recordRequest.TF_RequestID__c  = req.requestId;
                    recordRequest.TF_Request_JSON__c = JSON.serialize(req);
                    recordRequest.TF_Response_Payload__c = JSON.serialize(req.requestPayload);
                    recordRequest.TF_Status__c = 'RECEIVED';
                    recordRequest.Request_Type__c = req.requestType; //SFAL-168 Vikas Varshney
                    insert recordRequest;
                    system.debug('recordRequest'+recordRequest.Id);
                    response.statusMessage = 'License Creation. Request Have Been Created Succesfully';
                    response.statuscode = 200;
                    response.requestId = recordRequest.Id;
                }
                return response;  
            }
        }
        catch(Exception e){
            system.debug('Exception'+e.getMessage()+'-@-'+e.getLineNumber());
            response.statusMessage = e.getMessage()+'-@-'+e.getLineNumber();
            response.statuscode = 404;
            return response;
        }
    }
    
    public Static Boolean dateValidation(String dateValue){
        try {
            Date d = Date.valueOf(dateValue);
            if(d.year() < 1999 || d.year() > 2099){
                return false; 
            }else{
                return true;     
            }
        }
        catch(TypeException e) {
            system.debug('exception ===>'+e.getMessage());
            return false;
        }
    }
    
    /* @description : This method is used to validate the Cancel Lincense Request
Modification Log:  
SFAL-161 / 01-05-2022 / Radhikay Banerjee /  Initial Version V1
*/
    
    public TF_LicenseCancellationRequestWrapper.CancelLicenseResponse validateCancelRequest(TF_LicenseCancellationRequestWrapper request) {
        TF_LicenseCancellationRequestWrapper.CancelLicenseResponse response = new TF_LicenseCancellationRequestWrapper.CancelLicenseResponse();
        List<TF_LicenseCancellationRequestWrapper.licensesWrapper> cancelLicenseList = new  List<TF_LicenseCancellationRequestWrapper.licensesWrapper>();
        if(request != null && request.requestPayload != null) {
            
            String originalRequestID = request.requestPayload.originalRequestID;
            
            
            //Validation for requestType
            if(request.requestType == null || request.requestType == ''){
                response.statuscode = 400;
                TF_LicenseCancellationRequestWrapper.licensesWrapper cancelLicense = new TF_LicenseCancellationRequestWrapper.licensesWrapper();
                cancelLicense.licenseId = '';
                cancelLicense.customerId = '';
                cancelLicense.licenseVersion = '';
                cancelLicense.status = 'Request Type is a mandatory field, it cannot be null or empty';
                cancelLicenseList.add(cancelLicense);
                response.licenses = cancelLicenseList;
                return response;
                
            }
            if(request.requestType != 'Cancel' && request.requestType != 'CANCEL'){
                response.statuscode = 400;
                TF_LicenseCancellationRequestWrapper.licensesWrapper cancelLicense = new TF_LicenseCancellationRequestWrapper.licensesWrapper();
                cancelLicense.licenseId = '';
                cancelLicense.customerId = '';
                cancelLicense.licenseVersion = '';
                cancelLicense.status = 'Request Rejected as requestType should be Cancel';
                cancelLicenseList.add(cancelLicense);
                response.licenses = cancelLicenseList;
                
                return response;
                
            }
            
            //Validation for duplicate request id
            if(request.requestId != null && request.requestId != ''){
                String thisReqId = request.requestId;
                List<Record_Creation_Request__c> existingRecord = [Select Id,TF_RequestID__c, TF_CallBackUrl__c, TF_Number_of_Licenses__c from Record_Creation_Request__c where TF_RequestID__c =: thisReqId];
                
                if(existingRecord != null && existingRecord.size() > 0){
                    response.statuscode = 400;
                    TF_LicenseCancellationRequestWrapper.licensesWrapper cancelLicense = new TF_LicenseCancellationRequestWrapper.licensesWrapper();
                    cancelLicense.licenseId = '';
                    cancelLicense.customerId = '';
                    cancelLicense.licenseVersion = '';
                    cancelLicense.status = 'Request Rejected as a record with requestId '+ thisReqId + ' already exists in Salesforce';
                    cancelLicenseList.add(cancelLicense);
                    response.licenses = cancelLicenseList;
                    return response;
                }
                
            }else{
                
                response.statuscode = 400;
                TF_LicenseCancellationRequestWrapper.licensesWrapper cancelLicense = new TF_LicenseCancellationRequestWrapper.licensesWrapper();
                cancelLicense.licenseId = '';
                cancelLicense.customerId = '';
                cancelLicense.licenseVersion = '';
                cancelLicense.status = 'Request Id is a mandatory field, it cannot be null or empty';
                cancelLicenseList.add(cancelLicense);
                response.licenses = cancelLicenseList;
                return response;
            }
            
            if(request.callBackurl == null || request.callBackurl == ''){
                response.statuscode = 400;
                TF_LicenseCancellationRequestWrapper.licensesWrapper cancelLicense = new TF_LicenseCancellationRequestWrapper.licensesWrapper();
                cancelLicense.licenseId = '';
                cancelLicense.customerId = '';
                cancelLicense.licenseVersion = '';
                cancelLicense.status = 'CallBack Url is a mandatory field, it cannot be null or empty';
                cancelLicenseList.add(cancelLicense);
                response.licenses = cancelLicenseList;
                return response;
            }
            
            if(originalRequestID != null && originalRequestID != ''){
                List<Record_Creation_Request__c> existingRecord = [Select Id,TF_RequestID__c, TF_CallBackUrl__c, TF_Number_of_Licenses__c from Record_Creation_Request__c where TF_RequestID__c =: originalRequestID];
                Map<String,Asset> licenseIdToAssetMap = new Map<String,Asset>();
                if(!existingRecord.isEmpty()){
                    if(existingRecord.size() >1){
                        
                        response.statuscode = 400;
                        TF_LicenseCancellationRequestWrapper.licensesWrapper cancelLicense = new TF_LicenseCancellationRequestWrapper.licensesWrapper();
                        cancelLicense.licenseId = '';
                        cancelLicense.customerId = '';
                        cancelLicense.licenseVersion = '';
                        cancelLicense.status = 'Request Rejected as more than one record exists with requestId '+ originalRequestID + ' in Salesforce';
                        cancelLicenseList.add(cancelLicense);
                        response.licenses = cancelLicenseList;
                        return response;
                    }
                    List<Asset> assetList = [Select  Id, TF_OMS_Order_Id__c, Status, TF_License_Version__c, TF_Customer_Id__c From Asset where TF_License_Creation_Request__r.Id =: existingRecord[0].Id ];
                    if(request.requestPayload.licenseID != null && (request.requestPayload.licenseID).size() > 0){
                        
                        if(!assetList.isEmpty()){
                            boolean licenseExists = true;
                            boolean licenseExpired = false;
                            Map<String,String> licenseIds = new Map<String,String>();
                            
                            for(Asset thisAsset : assetList){
                                licenseIds.put(thisAsset.Id, thisAsset.Status);
                                licenseIdToAssetMap.put(thisAsset.Id,thisAsset);
                            }
                            
                            String[] requestLicenceIds = request.requestPayload.licenseID;
                            for(String licenseId : requestLicenceIds){
                                
                                if(!(licenseIds.containsKey(licenseId))){
                                    
                                    licenseExists = false; 
                                }
                            }
                            if(!licenseExists){
                                
                                response.statuscode = 400;
                                TF_LicenseCancellationRequestWrapper.licensesWrapper cancelLicense = new TF_LicenseCancellationRequestWrapper.licensesWrapper();
                                cancelLicense.licenseId = '';
                                cancelLicense.customerId = '';
                                cancelLicense.licenseVersion = '';
                                cancelLicense.status = 'Request Rejected as License is not associated with original request id';
                                cancelLicenseList.add(cancelLicense);
                                response.licenses = cancelLicenseList;
                                return response;
                            }else{
                                String[] requestLicIds = request.requestPayload.licenseID;
                                for(String licenseId : requestLicIds){
                                    if(licenseIds.get(licenseId) == 'Expired' || licenseIds.get(licenseId) == 'Cancelled'){
                                        licenseExpired = true;
                                        
                                    }
                                }
                                if(licenseExpired){
                                    
                                    response.statuscode = 400;
                                    TF_LicenseCancellationRequestWrapper.licensesWrapper cancelLicense = new TF_LicenseCancellationRequestWrapper.licensesWrapper();
                                    cancelLicense.licenseId = '';
                                    cancelLicense.customerId = '';
                                    cancelLicense.licenseVersion = '';
                                    cancelLicense.status = 'Request Rejected as one of the License is expired or cancelled';
                                    cancelLicenseList.add(cancelLicense);
                                    response.licenses = cancelLicenseList;
                                    return response;
                                    
                                }else{    
                                    Record_Creation_Request__c recordRequest = new Record_Creation_Request__c();
                                    recordRequest.TF_Request_JSON__c = JSON.serialize(request);
                                    recordRequest.TF_Status__c = 'RECEIVED';
                                    recordRequest.Request_Type__c = request.requestType; 
                                    recordRequest.TF_RequestID__c = request.requestId; 
                                    recordRequest.OriginalRequestID__c = request.requestPayload.originalRequestID; 
                                    recordRequest.TF_CallBackUrl__c = request.callBackurl;
                                    insert recordRequest;
                                    
                                    
                                    response.statuscode = 200;
                                    for(String licenseId : requestLicIds){
                                        Asset thisCanAsset = licenseIdToAssetMap.get(licenseId);
                                        TF_LicenseCancellationRequestWrapper.licensesWrapper cancelLicense = new TF_LicenseCancellationRequestWrapper.licensesWrapper();
                                        cancelLicense.licenseId = thisCanAsset.Id;
                                        cancelLicense.customerId = thisCanAsset.TF_Customer_Id__c;
                                        cancelLicense.licenseVersion = String.Valueof(thisCanAsset.TF_License_Version__c);
                                        cancelLicense.status = 'Cancel';
                                        cancelLicenseList.add(cancelLicense);
                                        
                                    }
                                    
                                    response.licenses = cancelLicenseList;
                                    
                                    TF_GetLicenseService.cancelLicenseByLicenseID(requestLicIds,request.requestId);
                                    
                                    return response;
                                }
                            }
                        }
                    }else{
                        
                        for(Asset thisCanAsset : assetList){
                            if(thisCanAsset.Status == 'Expired' || thisCanAsset.Status == 'Cancelled'){ 
                                response.statuscode = 400;
                                TF_LicenseCancellationRequestWrapper.licensesWrapper cancelLicense = new TF_LicenseCancellationRequestWrapper.licensesWrapper();
                                cancelLicense.licenseId = '';
                                cancelLicense.customerId = '';
                                cancelLicense.licenseVersion = '';
                                cancelLicense.status = 'Request Rejected as one of the License is expired or cancelled';
                                cancelLicenseList.add(cancelLicense);
                                response.licenses = cancelLicenseList;
                                return response;
                            }else{
                                TF_LicenseCancellationRequestWrapper.licensesWrapper cancelLicense = new TF_LicenseCancellationRequestWrapper.licensesWrapper();
                                cancelLicense.licenseId = thisCanAsset.Id;
                                cancelLicense.customerId = thisCanAsset.TF_Customer_Id__c;
                                cancelLicense.licenseVersion = String.Valueof(thisCanAsset.TF_License_Version__c);
                                cancelLicense.status = 'Cancel';
                                cancelLicenseList.add(cancelLicense);
                            }
                        }
                        Record_Creation_Request__c recordRequest = new Record_Creation_Request__c();
                        recordRequest.TF_Request_JSON__c = JSON.serialize(request);
                        recordRequest.TF_Status__c = 'RECEIVED';
                        recordRequest.Request_Type__c = request.requestType; 
                        recordRequest.TF_RequestID__c = request.requestId;
                        recordRequest.OriginalRequestID__c = request.requestPayload.originalRequestID; 
                        recordRequest.TF_CallBackUrl__c = request.callBackurl; 
                        insert recordRequest;
                        
                        response.statuscode = 200;
                        response.licenses = cancelLicenseList;
                        List<Id> idList = new List<Id>();
                        for(Asset thisCaAsset : assetList){
                            idList.add(thisCaAsset.Id);
                        }
                        
                        TF_GetLicenseService.cancelLicenseByLicenseID(idList,request.requestId);
                        
                        return response;
                        
                    }
                }else{
                    
                    response.statuscode = 400;
                    TF_LicenseCancellationRequestWrapper.licensesWrapper cancelLicense = new TF_LicenseCancellationRequestWrapper.licensesWrapper();
                    cancelLicense.licenseId = '';
                    cancelLicense.customerId = '';
                    cancelLicense.licenseVersion = '';
                    cancelLicense.status = 'Request Rejected as no Record found for the original Request id : '+originalRequestID;
                    cancelLicenseList.add(cancelLicense);
                    response.licenses = cancelLicenseList;
                    return response;
                }
            }else{
                response.statuscode = 400;
                TF_LicenseCancellationRequestWrapper.licensesWrapper cancelLicense = new TF_LicenseCancellationRequestWrapper.licensesWrapper();
                cancelLicense.licenseId = '';
                cancelLicense.customerId = '';
                cancelLicense.licenseVersion = '';
                cancelLicense.status = 'Original RequestId is a mandatory field, it cannot be null or empty';
                cancelLicenseList.add(cancelLicense);
                response.licenses = cancelLicenseList;
                return response;
            }
        }
        return response;
    }
    
    private static TF_LicenseCreateRequestWrapper.LicenseCreateResponse isNotNullorEmpty(String fieldName,String givenValue,List<String> expectedValues,Boolean isNumeric,Boolean isDecimal) {
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse response = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        Boolean isValueMatched ;
        if(givenValue != null){
            if(givenValue != ''){
                if(expectedValues != null){
                    if(expectedValues.contains(givenValue)){
                        
                    }else{
                        response.statuscode = 400;
                        response.statusMessage = fieldName+' value is not valid.';
                    }
                }else{
                    if(isNumeric == true){
                        if(!givenValue.isNumeric()){
                            response.statuscode = 400;
                            response.statusMessage = 'Only numeric values are allowed for ' +fieldName;
                        }
                    }else if(isDecimal == true){
                        if(isDecimal(givenValue) == false){
                            response.statuscode = 400;
                            response.statusMessage = 'Only Decimal values are allowed for ' +fieldName;
                        }
                    }
                }
            }else{
                response.statuscode = 400;
                response.statusMessage = fieldName+' cannot be blank.';
            }
        }else{
            response.statuscode = 400;
            response.statusMessage = fieldName+' Parameter is needed.';
        }
        system.debug('response'+response);
        return response;
    }
    public static boolean isDecimal( String decimalPoint){
        //String decimalPoint = '1.23';
        Boolean isValidDecimal = true;
        if(decimalPoint != null){
            try{
                Decimal.valueOf(decimalPoint);
            }
            catch(TypeException e){
                isValidDecimal = false; 
            }
        }
        return isValidDecimal;
        //system.debug(isValidDecimal);
    }
}