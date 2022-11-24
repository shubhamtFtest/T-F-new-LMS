/**
 * TF License Service
 * test class "zTEST_TF_LicenseAPIService"
 * Modified by Vikas Varshney for LMS-181 on dated 25th July, 2019
 * Modified by Vikas Varshney for LMS-251 on dated 06th September, 2019
 * Modified by Vikas Varshney for UBX-10932 on dated 17th August, 2020
 **/

@RestResource(urlMapping='/LicenseService/*')
global class  TF_LicenseAPIService {

    public class LicenseServiceException extends Exception {}
    public static Boolean stopLicenseServiceApiCall = false;

    // -----  Request object definition ------
    global class UpdateEntitlementResponse {
        public String licenseID;
        public String Type;
        public String status; // created or failed
        public String message;
    }
    
    global class UpdateEntitlementStatusRequest {
        public List<UpdateEntitlementResponse> response;
        
        public void updateValidation() {
            Set<Id> licenseIdSet = new Set<Id>();
            Set<License__c> licenseSet = new Set<License__c>();
            Set<Id> existingLicenseIdSet = new Set<Id>();
            String statusValues = '';
            Set<String> pickListValuesSet = new Set<String>();
            Set<String> typeSet = new Set<String>();
            typeSet.add('AddLicense');
            typeSet.add('UpdateLicense');
            typeSet.add('HasPartUpdate');
            
            Schema.DescribeFieldResult fieldResult = License__c.Entitlement_Creation_Status__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple){
                pickListValuesSet.add(pickListVal.getValue());
            }
            pickListValuesSet.remove('Initiated');
            
            if ( response.size() == 0 ) {
                throw new LicenseServiceException('Response cannot be blank');
            }
            
            if ( response.size() > 0 ) {
                for ( UpdateEntitlementResponse resp : response ) {
                    if ( String.isNotBlank( resp.licenseID ) )
                    licenseIdSet.add( resp.licenseID );
                }
                
                try {
                    licenseSet.addAll( [ SELECT id FROM License__c WHERE id IN:licenseIdSet ] );
                    if ( !licenseSet.isEmpty() ) {
                        for ( License__c lic : licenseSet ) {
                            existingLicenseIdSet.add( lic.id );
                        }
                    }
                } catch ( Exception ex ) {
                    throw new LicenseServiceException('License Id does not match');
                }
                
                for ( UpdateEntitlementResponse resp : response ) {
                    //License Id validation
                    if(String.isBlank(resp.licenseID)) {
                        throw new LicenseServiceException('License Id cannot be empty');
                    }
                    
                    //if licenseId is wrong
                    if ( !existingLicenseIdSet.contains( resp.licenseID ) ) {
                        throw new LicenseServiceException('License Id does not exist');
                    }
                    
                    //Checking if the status is blank
                    if(String.isBlank(resp.status)) {
                        throw new LicenseServiceException('Status cannot be empty');
                    }
                    
                    //Status value should be created or failed
                    if(!pickListValuesSet.contains(resp.status)) {
                        throw new LicenseServiceException('Status should be ' + pickListValuesSet);
                    }
                    
                    //Checking type should not be blank
                    if ( String.isBlank(resp.Type) ) {
                        throw new LicenseServiceException('License Type can not be empty');
                    }
                    
                    //Checking license type should have AddLicense, UpdateLicense and HasPartUpdate values only
                    if ( !typeSet.contains(resp.Type) ) {
                        throw new LicenseServiceException('License Type must have values : ' + typeSet);
                    }
                }
            }
        }
    }
    
    /*
    global class CreateLicenseRequest {
        public String salesforceID;
        public String licenseType;
        public String orderNumber;
        public Date startDate;
        public Date endDate;
        public Date purchaseDate;
        public List<String> grantType;

        public void validate() {
            Set<String> licenseTypeSet = new Set<String>();
            licenseTypeSet.add('Perpetual');
            licenseTypeSet.add('Subscription');
            licenseTypeSet.add('EBS');
            licenseTypeSet.add('Trial');
            Set<String> grantTypeSet = new Set<String>();
            grantTypeSet.add('View');
            grantTypeSet.add('Download');
            Opportunity Oppportunity = new Opportunity();
            List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
            Map<Id, License__c> licenseIdToLicenseMap = new Map<Id, License__c>( [ SELECT id, Customer__c, Product__c, License_Type__c, Start_Date__c, End_Date__c FROM License__c ] );
            Map<Id, List<Id>> oppIdToProductIdListMap = new Map<Id, List<Id>>();
            Map<Id, List<OpportunityLineItem>> oppIdToOliListMap = new Map<Id, List<OpportunityLineItem>>();
            
            // --- Salesforce ID Validation
            if (string.isBlank(salesforceID)) {
                throw new LicenseServiceException('Salesforce Id cannot be empty');
            }
            try {
                Oppportunity = [SELECT id, StageName, AccountId FROM Opportunity WHERE id=:salesforceID LIMIT 1];
            } catch (Exception ex) {
                throw new LicenseServiceException('Salesforce Id does not exist');
            }
            //----Opportunity Stage Validation
            if ( Oppportunity != NULL && !'Closed Won'.equalsIgnoreCase(Oppportunity.StageName) ) {
                throw new LicenseServiceException('Opportunity Stage is not \'Closed Won\'');
            }
            try {
                oliList = [SELECT id, opportunityId, product2Id, product2.Family FROM OpportunityLineItem WHERE opportunityId=:salesforceID];
                if ( !oliList.isEmpty() ) {
                    for ( OpportunityLineItem oli : oliList ) {
                        if ( !oppIdToProductIdListMap.containsKey( oli.opportunityId ) ) {
                            oppIdToProductIdListMap.put( oli.opportunityId, new List<Id>() );
                        }
                        oppIdToProductIdListMap.get( oli.opportunityId ).add( oli.product2Id );
                        if ( !oppIdToOliListMap.containsKey(  oli.opportunityId ) ) {
                            oppIdToOliListMap.put( oli.opportunityId, new List<OpportunityLineItem>() );
                        }
                        oppIdToOliListMap.get( oli.opportunityId ).add( oli );
                    }
                }
                if ( !oppIdToOliListMap.isEmpty() ) {
                    for ( OpportunityLineItem oli : oppIdToOliListMap.get(salesforceID) ) {
                        if ( String.isNotBlank( oli.product2.Family ) && oli.product2.Family != 'Collections' ) {
                            throw new LicenseServiceException('Collections product does not exist.');
                        }
                    }
                }
            } catch (Exception ex) {
                throw new LicenseServiceException('Collections product does not exist');
            }
            
            //Start Date validation
            if (startDate == NULL) {
                throw new LicenseServiceException('Start Date is missing');
            }
            
            // -- License Type Validation
            if ( String.isBlank( licenseType ) ) {
                throw new LicenseServiceException('License Type cannot be empty');
            } else if ( endDate == NULL && ( licenseType.equals('Subscription') || licenseType.equals('Trial') ) ) {
                throw new LicenseServiceException('License Type must have End Date');
            }
            if ( !licenseTypeSet.contains(licenseType) ) {
                throw new LicenseServiceException('Invalid License Type');
            }
            
            //End Date validation
            if (endDate == NULL) {
                throw new LicenseServiceException('End Date is missing');
            }
            
            // -- Start Date Validation
            if(startDate != NULL && endDate != NULL) {
                if ( startDate > endDate ) {
                    throw new LicenseServiceException('End Date should be greater than Start Date');
                }                
            }
            
            // Purchase Date Validation
            DateTime currentDate = DateTime.newInstance( DateTime.now().year(), DateTime.now().month(), DateTime.now().day(), DateTime.now().hour(), DateTime.now().minute(), DateTime.now().second());
            //if( purchaseDate != Date.today() ) {
            if( purchaseDate != currentDate.dateGMT() ) {
                throw new LicenseServiceException('Purchase Date should allow only current date');
            }
            
            // Grant Type Validation
            if(grantType.isEmpty()) {
                 throw new LicenseServiceException('Grant Type cannot be empty'); 
            } else {
                for(String gt : grantType) {
                    if ( !grantTypeSet.contains(gt) ) {
                        throw new LicenseServiceException('Invalid Grant Type');
                    }
                }
            }
            
            //Duplicate License check
            if ( !licenseIdToLicenseMap.isEmpty() ) {
                for ( Id licenseId : licenseIdToLicenseMap.keySet() ) {
                    if ( Oppportunity != NULL && Oppportunity.AccountId != NULL && Oppportunity.AccountId == licenseIdToLicenseMap.get( licenseId ).Customer__c ) {
                        if ( !oppIdToProductIdListMap.isEmpty() && !oppIdToProductIdListMap.get( salesforceID ).isEmpty() && licenseIdToLicenseMap.get( licenseId ).Product__c != NULL ) {
                            Set<Id> productIdSet = new Set<Id>();
                            productIdSet.addAll( oppIdToProductIdListMap.get( salesforceID ) );
                            if ( productIdSet.contains( licenseIdToLicenseMap.get( licenseId ).Product__c ) && licenseType == licenseIdToLicenseMap.get( licenseId ).License_Type__c && startDate == licenseIdToLicenseMap.get( licenseId ).Start_Date__c && endDate == licenseIdToLicenseMap.get( licenseId ).End_Date__c ) {
                                throw new LicenseServiceException('Duplicate license');
                            }
                        }
                    }
                }
            }
        }
    }*/
    // ----- Response object definition ------
    global class LicenseResponse {
        public Boolean success;
        public String errorMessage;

        public void setError(String errorMessage) {
            this.success = false;
            this.errorMessage = errorMessage;
        }
    }  


    @HttpPost
    global static void doPost() {
        String result               = '';
        String command              = getCommand(RestContext.request.requestURI);
        String operation            = operationLookup('POST', command);
        String jsonStr              = RestContext.request.requestBody != null ? RestContext.request.requestBody.toString() : null;

        /*if (operation == 'createLicense') {
            result = createLicense(jsonStr);

        } else*/
        if (operation == 'updateEntitlementStatus') {
            result = updateEntitlementStatus(jsonStr);
        } else {
            result = 'Invalid Resource';
        }
        if (result != NULL)
            RestContext.response.responseBody = Blob.valueOf(result);
    }

    private static String updateEntitlementStatus(String jsonStr) {
        UpdateEntitlementStatusRequest request = new UpdateEntitlementStatusRequest();
        LicenseResponse response = new LicenseResponse();
        List<License__c> licenseUpdateList = new List<License__c>();
        Map<Id, License__c> licenseIdToLicenseUpdateMap = new Map<Id, License__c>();
        List<UpdateEntitlementResponse> failedEntitlementList = new List<UpdateEntitlementResponse>();

        try {
            request = (UpdateEntitlementStatusRequest)JSON.deserialize(jsonStr, UpdateEntitlementStatusRequest.class);
            request.updateValidation();
            //System.debug('********** Validation passed **********');
            Set<Id> failedLicenseIddSet = new Set<Id>();
            Set<Id> licIdSet = new Set<Id>();
            Map<Id, License__c> licIdToLicenseMap;
            
            for ( UpdateEntitlementResponse entitlementReqq : request.response ) {
                licIdSet.add( entitlementReqq.licenseId );
            }
            
            if ( !licIdSet.isEmpty() ) {
                try {
                    licIdToLicenseMap = new Map<Id, License__c>( [ SELECT id, Status__c, End_Date__c, License_Type__c FROM License__c WHERE id IN:licIdSet ] );
                } catch ( Exception ex ) {
                    licIdToLicenseMap = new Map<Id, License__c>();
                }
            }

            for ( UpdateEntitlementResponse entitlementReq : request.response ) {
                License__c license = new License__c();
                license.id = entitlementReq.licenseId;
                license.Entitlement_Creation_Status__c = entitlementReq.status;
                //if ( 'created'.equalsIgnoreCase(entitlementReq.status) && licIdToLicenseMap.containsKey(entitlementReq.licenseId) && !licIdToLicenseMap.get(entitlementReq.licenseId).Status__c.equals('Active') ) {
                if ( 'created'.equalsIgnoreCase(entitlementReq.status) && licIdToLicenseMap.containsKey(entitlementReq.licenseId) && !licIdToLicenseMap.get(entitlementReq.licenseId).Status__c.equals('Active') && !licIdToLicenseMap.get(entitlementReq.licenseId).Status__c.equals('Deactivated') ) {
                    DateTime noww = DateTime.now();
                    Date gmtTodaysDate = noww.dateGMT();
                    //UBX-10932 - no need to make end date as blank for perpetual licenses
                    //if ( licIdToLicenseMap.get(entitlementReq.licenseId).License_Type__c.equals('Perpetual') ) {
                        //license.Status__c = 'Active';
                        //license.End_Date__c = NULL;
                    //} else 
                    if ( licIdToLicenseMap.get(entitlementReq.licenseId).End_Date__c <= gmtTodaysDate ) {
                        license.Status__c = 'Expired';
                    } else {
                        license.Status__c = 'Active';
                    }
                } else if ( 'failed'.equalsIgnoreCase(entitlementReq.status) ) {
                    license.Status__c = 'License created successfully, EMS creation failed';
                }
                licenseIdToLicenseUpdateMap.put( license.id, license );
                if ( entitlementReq.status == 'failed' ) {
                    failedEntitlementList.add( entitlementReq );
                    failedLicenseIddSet.add( entitlementReq.licenseId );
                }
            }
            
            if ( !licenseIdToLicenseUpdateMap.isEmpty() ) {
                Set<License__c> licenseSet = new Set<License__c>();
                licenseSet.addAll( licenseIdToLicenseUpdateMap.values() );
                licenseUpdateList.addAll( licenseSet );
            }
            if ( !licenseUpdateList.isEmpty() ) {
                try {
                    update licenseUpdateList;
                } catch ( Exception ex ) {
                    System.debug('Update DML Exception =========>' + ex.getMessage());
                }
            }
            
            if ( !failedEntitlementList.isEmpty() ) {
                inboundFailedCaseCreation( failedEntitlementList, failedLicenseIddSet );
            }
            
            response.success = true;
        } catch(Exception e) {
            response.setError(e.getMessage());
            System.debug('Exception ========>' + response.errorMessage);
        }
        return JSON.serialize(response);
    }

    /*private static String createLicense(String jsonStr) {
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        List<License__c> licenseInsertList = new List<License__c>();
        CreateLicenseRequest request;
        LicenseResponse response = new LicenseResponse();
        try {
            request = (CreateLicenseRequest)JSON.deserialize(jsonStr, CreateLicenseRequest.class);
            request.validate();
            oliList = [ SELECT id, OpportunityId, Opportunity.AccountId, product2.id, product2.Family FROM OpportunityLineItem WHERE opportunityId =:request.salesforceID ];
            if ( !oliList.isEmpty() ) {
                for ( OpportunityLineItem oli : oliList ) {
                    if ( oli.product2.Family.equals('Collections') ) {
                        License__c license = new License__c();
                        Opportunity opp = new Opportunity();
                        List<String> grantList = new List<String>();
                        grantList = request.grantType != NULL ? request.grantType : NULL;
                        license.Customer__c = oli.Opportunity.AccountId;
                        license.Product__c = oli.product2.id;
                        license.Purchase_Date__c = (request.purchaseDate != NULL ? request.purchaseDate : NULL);
                        license.License_Type__c = (request.licenseType != NULL ? request.licenseType : NULL);
                        license.Start_Date__c = (request.startDate != NULL ? request.startDate : NULL);
                        license.End_Date__c = (request.endDate != NULL ? request.endDate : NULL);
                        license.Status__c = 'Active';
                        license.Entitlement_Creation_Status__c = 'Initiated';
                        license.Order_Number__c = (request.orderNumber != NULL ? request.orderNumber : NULL);
                        if ( grantList.size() > 1 ) {
                            String grant = '';
                            for ( String licGrant : grantList ) {
                                grant += licGrant + '; ';
                            }
                            grant = grant.removeEnd('; ');
                            license.Grant_Type__c = grant;
                        } else
                            license.Grant_Type__c = grantList[0];
                        licenseInsertList.add(license);
                    }
                }
             }
             
            //inserting licence list if it is not empty
            if ( !licenseInsertList.isEmpty() ) {
                stopLicenseServiceApiCall = true;
                insert licenseInsertList;
            } 

            // To add consortium level details
            for(License__c lic : licenseInsertList) {
                if(isConsortiumAccount(lic.Customer__c)) {
                    addConsortiumMembers(lic.Id, request.salesforceID);
                }
            }

            response.success = true;    
        } catch(Exception e) {
            response.setError(e.getMessage());
            System.debug('Exception ========>' + response.errorMessage);
        }
        return JSON.serialize(response);        
    }
    */

    // ----- Private method definition ------
    private static String getCommand(String requestedUri) {
        System.debug('getcommand =====>' + requestedUri.substring(requestedUri.lastIndexOf('/LicenseService/')+15));
        return requestedUri.substring(requestedUri.lastIndexOf('/LicenseService/')+15);
    }

    private static String operationLookup(String method, String command) {
        String operation = 'unknown';
        if(method.equals('POST')) {
            /*if (command.contains('createLicense')) {
                operation = 'createLicense';
            } else */
            if (command.contains('updateEntitlementStatus')) {
                operation = 'updateEntitlementStatus';
            }
        } else if (method.equals('DELETE')) {

        } else if (method.equals('PUT')) {

        }
        return operation;
    }

    private static Boolean isConsortiumAccount(ID accountID) {
        Account account = [SELECT Id, Type FROM Account WHERE Id = :accountID LIMIT 1];
        return account.Type.equalsIgnoreCase('Consortium');
    }
    

    private static void addConsortiumMembers(Id licenseID, ID operationID) {
        List<Account_To_Opportunity__c> dealMemebrs = new List<Account_To_Opportunity__c>();
        List<License_Memeber__c> licenseMemebrs = new List<License_Memeber__c>();
        dealMemebrs = [SELECT Account__c FROM Account_To_Opportunity__c WHERE Opportunity__c = :operationID];
        for(Account_To_Opportunity__c dealMemeber : dealMemebrs) {
            License_Memeber__c member = new License_Memeber__c();
            member.License__c = licenseID;
            member.Account__c = dealMemeber.Account__c;
            licenseMemebrs.add(member);
        }
        if(!licenseMemebrs.isEmpty()) {
            stopLicenseServiceApiCall = true;
            insert licenseMemebrs;
        }
    }
    /*
    //this method is to create exception logs for "HasPart Update"
    private static void inboundCaseCreation ( List<UpdateEntitlementResponse> entitlementResponseList, String caseType ) {
        Case caseRecord = new Case();
        Boolean isCaseInsertFlag = false;
        List<Exception_Log__c> exceptionLogInsertList = new List<Exception_Log__c>();
        
        try {
            caseRecord = [ SELECT id, CaseNumber, Status, Subject, Type FROM Case WHERE Subject = 'HasPart updation failed in Entitlement Hub' AND Status != 'Closed' AND Type =:caseType LIMIT 1 ];
        } catch ( Exception ex ) {
            isCaseInsertFlag = true;
            System.debug('************** HasPart Case not found **************');
        }
        
        if ( isCaseInsertFlag ) {
            Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Salesforce Internal Support').getRecordTypeId();
            caseRecord.RecordTypeId = caseRecordTypeId != NULL ? caseRecordTypeId : '';
            caseRecord.Status = 'New';
            caseRecord.Priority = 'Low';
            caseRecord.Application__c = 'License and Entitlement';
            caseRecord.Type = caseType; //'HasPartUpdate Failure'
            caseRecord.Origin = 'Other';
            caseRecord.Subject = 'HasPart updation failed in Entitlement Hub';
            caseRecord.Description = 'An error occurred while Dynamic License Update. Error message: ' + entitlementResponseList[0].message;
            caseRecord.OwnerId = UserInfo.getUserId();
            insert caseRecord;
        }

        for ( UpdateEntitlementResponse response : entitlementResponseList ) {
            String typeOfAction = '';
            
            if ( response.Type == 'HasPartUpdate' ) {
                typeOfAction = 'Update';
            }
            
            Exception_Log__c exceptionLogInsert = new Exception_Log__c();
            exceptionLogInsert.ownerId = UserInfo.getUserId();
            exceptionLogInsert.Object_ID__c = 'NA'; 
            exceptionLogInsert.Object_Type__c = 'Platform Event'; 
            exceptionLogInsert.Error_Type__c = ( caseType.equalsIgnoreCase('Outbound Failure') ? 'Outbound' : ( caseType.equalsIgnoreCase('Inbound Failure') ? 'Inbound' : '' ) );
            exceptionLogInsert.Error_message__c = response.message;
            exceptionLogInsert.Type_of_Action__c = typeOfAction;
            exceptionLogInsert.Request_JSON__c = JSON.serialize( response );
            exceptionLogInsert.Case_Number__c = caseRecord.CaseNumber;
            exceptionLogInsert.Resolution_Status__c = 'New';
            exceptionLogInsert.Case__c = caseRecord.id;
            exceptionLogInsertList.add( exceptionLogInsert );
        }
        
        if ( !exceptionLogInsertList.isEmpty() ) {
            try {
                insert exceptionLogInsertList;
            } catch ( Exception ex ) {
                System.debug('********** Exception Log Insert Exception **********');
                System.debug('Exception =========>' + ex);
            }
        }
    }
    
    //this method is to create exception logs for "Add License" and "Update License"
    private static void inboundAsyncCaseCreation ( List<UpdateEntitlementResponse> entitlmentResponseList, String caseType ) {
        Case caseRecord = new Case();
        Boolean isCaseInsertFlag = false;
        List<Exception_Log__c> exceptionLogInsertList = new List<Exception_Log__c>();
        
        try {
            caseRecord = [ SELECT id, CaseNumber, Status, Subject, Type FROM Case WHERE Subject = 'License creation or updation failed in Entitlement Hub' AND Status != 'Closed' AND Type =:caseType LIMIT 1 ];
        } catch ( Exception ex ) {
            isCaseInsertFlag = true;
            System.debug('************** AsyncSQS Inbound Case not found **************');
        }
        
        if ( isCaseInsertFlag ) {
            Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Salesforce Internal Support').getRecordTypeId();
            caseRecord.RecordTypeId = caseRecordTypeId != NULL ? caseRecordTypeId : '';
            caseRecord.Status = 'New';
            caseRecord.Priority = 'Low';
            caseRecord.Application__c = 'License and Entitlement';
            caseRecord.Type = caseType;
            caseRecord.Origin = 'Other';
            caseRecord.Subject = 'License creation or updation failed in Entitlement Hub';
            caseRecord.Description = 'An error occurred in License record. Error message: ' + entitlmentResponseList[0].message;
            caseRecord.OwnerId = UserInfo.getUserId();
            insert caseRecord;
        }

        for ( UpdateEntitlementResponse response : entitlmentResponseList ) {
            String typeOfAction = '';
            if ( response.Type == 'AddLicense' ) {
                typeOfAction = 'Insert';
            } else if ( response.Type == 'UpdateLicense' ) {
                typeOfAction = 'Update';
            }
            Exception_Log__c exceptionLogInsert = new Exception_Log__c();
            exceptionLogInsert.ownerId = UserInfo.getUserId();
            exceptionLogInsert.Object_ID__c = response.licenseId; 
            exceptionLogInsert.Object_Type__c = 'License'; 
            exceptionLogInsert.Error_Type__c = ( caseType.equalsIgnoreCase('Outbound Failure') ? 'Outbound' : ( caseType.equalsIgnoreCase('Inbound Failure') ? 'Inbound' : '' ) );
            exceptionLogInsert.Error_message__c = response.message;
            exceptionLogInsert.Type_of_Action__c = typeOfAction;
            exceptionLogInsert.Request_JSON__c = JSON.serialize( response );
            exceptionLogInsert.Case_Number__c = caseRecord.CaseNumber;
            exceptionLogInsert.Resolution_Status__c = 'New';
            exceptionLogInsert.Case__c = caseRecord.id;
            exceptionLogInsertList.add( exceptionLogInsert );
        }
        
        if ( !exceptionLogInsertList.isEmpty() ) {
            try {
                insert exceptionLogInsertList;
            } catch ( Exception ex ) {
                System.debug('********** Exception Log Insert Exception **********');
                System.debug('Exception =========>' + ex);
            }
        }
    }*/
    
    private static void inboundFailedCaseCreation ( List<UpdateEntitlementResponse> entitlementResponseList, Set<Id> failedLicenseIdSet) {
        Map<Id, Case> failedLicIdToCaseMap = new Map<Id, Case>();
        List<Exception_Log__c> exceptionLogInsertList = new List<Exception_Log__c>();
        
        if ( !failedLicenseIdSet.isEmpty() ) {
            failedLicIdToCaseMap = TF_AsyncSQSJob.returnLicIdToCaseMap( failedLicenseIdSet, 'Entitlement failure in EMS' );
        }
        
        if ( !entitlementResponseList.isEmpty() ) {
            for ( UpdateEntitlementResponse response : entitlementResponseList ) {
                String typeOfAction = '';
                String objType = 'License';
                
                if ( response.Type == 'HasPartUpdate' ) {
                    typeOfAction = 'Update';
                    objType = 'Platform Event';
                } else if ( response.Type == 'AddLicense' ) {
                    typeOfAction = 'Insert';
                } else if ( response.Type == 'UpdateLicense' ) {
                    typeOfAction = 'Update';
                }
                
                Exception_Log__c exceptionLogInsert = new Exception_Log__c();
                exceptionLogInsert.ownerId = UserInfo.getUserId();
                exceptionLogInsert.Object_ID__c = response.licenseId; 
                exceptionLogInsert.Object_Type__c = objType; 
                exceptionLogInsert.Error_Type__c = 'Inbound';
                exceptionLogInsert.Error_message__c = response.message;
                exceptionLogInsert.Type_of_Action__c = typeOfAction;
                exceptionLogInsert.Request_JSON__c = JSON.serialize( response );
                exceptionLogInsert.Case_Number__c = ( failedLicIdToCaseMap.containsKey(response.licenseId) && String.isNotBlank(failedLicIdToCaseMap.get(response.licenseId).CaseNumber) ? failedLicIdToCaseMap.get(response.licenseId).CaseNumber : '');
                exceptionLogInsert.Resolution_Status__c = 'New';
                exceptionLogInsert.Case__c = failedLicIdToCaseMap.containsKey(response.licenseId) ? failedLicIdToCaseMap.get(response.licenseId).id : '';
                exceptionLogInsertList.add( exceptionLogInsert );
            }
        }
        
        if ( !exceptionLogInsertList.isEmpty() ) {
            try {
                insert exceptionLogInsertList;
            } catch ( Exception ex ) {
                System.debug('Exception =========>' + ex);
            }
        }
    }
}