/************************************************************************************
    // This is handler class for trigger "TF_LicenseMemberJSON_Tgr"
    // This class is to create License Member JSON on its creation,
    // updation or deletion in Salesforce.
    // Created by Vikas for POF-262 on dated 29-10-2018
    // Test class "zTest_TF_LicenseMemberJSON_Tgr"
    // Modified by Vikas for POF-604 on dated 12-11-2018
    // Modified by Shefali Arora for POF-646 on dated 26-11-2018
    // Modified by Shefali Arora for POF-785 on date 08-02-2019
    // Modified by Vikas for LMS-181 on dated 25th July, 2019
    // Modified by Vikas for LMS-308 on dated 7th Oct, 2019
    // Modified by Vikas for LMS-329 on dated 22nd Oct, 2019
    // Modified by Vikas for LMS-433 on dated 11th Dec, 2019
    // Modified by Vikas for UBX-306 on dated 16th April, 2020
************************************************************************************/
public with sharing class TF_LicenseMemberJSON_Tgr implements TriggerInterface_License_Member.Runnable {
    public String licenseMemberJsonStr = '';
    public Boolean isBeforeFlag = false;
    public Boolean isDeleteFlag = false;
    public Set<Id> licenseIdSet = new Set<Id>();
    public Map<Id, License__c> licIdToLicenseMap = new Map<Id, License__c>();
    public List<LicenseMemberWrapper> nonActiveLicenseWrapperList = new List<LicenseMemberWrapper>();
    public Set<Id> nonActiveLicenseIdSet = new Set<Id>();
    public Boolean isAfterFlag = false;
    public Boolean isInsertFlag = false;
    public Map<Id, String> licIdToJsonMap = new Map<Id, String>();
    
    public void run(TriggerInterface_License_Member.Trig trig) {
        Set<Id> licenseMemberIdSet = new Set<Id>();
        List<License_Memeber__c> licMemberList = new List<License_Memeber__c>();
        
        isBeforeFlag = trig.isBefore;
        isDeleteFlag = trig.isDelete;
        isAfterFlag = trig.isAfter;
        isInsertFlag = trig.isInsert;

        if ( trig.isAfter && ( trig.isInsert || trig.isUpdate ) ) {
            //Iterating license member list to get its Id set
            if ( !trig.newList.isEmpty() ) {
                for ( License_Memeber__c licMem : trig.newList ) {
                    licenseMemberIdSet.add( licMem.id );
                }
            }
        } else if ( trig.isBefore && trig.isDelete ) {
            if ( !trig.oldList.isEmpty() ) {
                for ( License_Memeber__c licMem : trig.oldList ) {
                    licenseMemberIdSet.add( licMem.id );
                }
            }
        }
        
        //Query to create a list of license member
        if ( !licenseMemberIdSet.isEmpty() ) {
            licMemberList = [ SELECT Account__c, Account__r.Ringgold_Account_ID__c, Account__r.Customer_Id__c, License__r.Update_Type__c, License__c FROM License_Memeber__c WHERE id IN:licenseMemberIdSet ];
        }
        
        //Creating JSON for license member
        if ( !licMemberList.isEmpty() ) {
            licenseMemberJsonStr = licenseMemberJson( licMemberList );
        }
        
        //System.debug('License Member stopLicenseServiceApiCall ============>' + TF_LicenseAPIService.stopLicenseServiceApiCall);
        //making call out to pass json to SQS queue
        //if ( String.isNotBlank( licenseMemberJsonStr ) && !TF_LicenseAPIService.stopLicenseServiceApiCall ) {
        try {
            if ( String.isNotBlank( licenseMemberJsonStr ) ) {
                TF_AsyncSQSJob.callingSQSQueue( licenseMemberJsonStr, licenseIdSet, trig.isInsert, trig.isUpdate, trig.isDelete );
            } 
            //else if ( String.isNotBlank( licenseMemberJsonStr ) && TF_LicenseAPIService.stopLicenseServiceApiCall ) { 
                /*else if ( String.isNotBlank( licenseMemberJsonStr ) ) { //this else part is used to replace "license member json" with "add license json"
                licenseMemberJsonStr = licenseMemberJsonStr.replace( 'UpdateLicense', 'AddLicense' );
                TF_AsyncSQSJob.callingSQSQueue( licenseMemberJsonStr, licenseIdSet, trig.isInsert, trig.isUpdate, trig.isDelete );
            }*/
            if ( !licIdToLicenseMap.isEmpty() ) {
                //update licIdToLicenseMap.values();
            }
        } catch ( Exception ex ) {
            System.debug('************ License Member Trigger Exception ************');
            System.debug(ex);
        }
    }
    
    //method to create a json string for license member
    public String licenseMemberJson ( List<License_Memeber__c> licenseMembersList ) {
        String licenseMemberJsonStr = '';
        Map<Id, List<Id>> licenseIdToLicenseMemberIdListMap = new Map<Id, List<Id>>();
        List<License__c> licenseList = new List<License__c>();
        List<LicenseMemberWrapper> licenseMemberWrapperList = new List<LicenseMemberWrapper>();
        Map<id, id> licenseMemberIdToAccountIdMap = new Map<Id, Id>();
        Map<id, String> licensememberIdToRinggoldIdMap = new Map<Id, String>();
        Map<id, String> licensememberIdToCustomerIdMap = new Map<Id, String>();
        
        //Creating a map of license ids and its license members
        if ( !licenseMembersList.isEmpty() ) {
            for ( License_Memeber__c licMember : licenseMembersList ) {
                if ( !licenseIdToLicenseMemberIdListMap.containsKey( licMember.License__c ) ) {
                    licenseIdToLicenseMemberIdListMap.put( licMember.License__c, new List<Id>() );
                }
                licenseIdToLicenseMemberIdListMap.get( licMember.License__c ).add( licMember.id );
                if ( licMember.Account__c != NULL ) {
                    licenseMemberIdToAccountIdMap.put( licMember.id, licMember.Account__c );
                }
                if ( licMember.Account__c != NULL && licMember.Account__r.Ringgold_Account_ID__c != NULL ) {
                    licensememberIdToRinggoldIdMap.put(licMember.id, licMember.Account__r.Ringgold_Account_ID__c);
                }
                
                if(licMember.Account__c != NULL && licMember.Account__r.Customer_Id__c != NULL){
                   licensememberIdToCustomerIdMap.put(licMember.id, licMember.Account__r.Customer_Id__c);
                }
            }
        }
        
        //Query to create a list of licenses
        if ( !licenseIdToLicenseMemberIdListMap.isEmpty() ) {
            licenseList = [ SELECT id, name, Customer__c, Customer__r.Type, Customer__r.Ringgold_Account_ID__c, Customer__r.Customer_Id__c, Update_Type__c, Product__c, Product__r.Hub_Id__c, Order_Number__c, License_Type__c, Grant_Type__c, Start_Date__c, End_Date__c, Status__c, Contact__c, Contact__r.Party_Id__c, RecordType.Name, Access_Scope__c FROM License__c WHERE Id IN:licenseIdToLicenseMemberIdListMap.keySet() ];
        }

        //Creating a wrapper of license member
        if ( !licenseList.isEmpty() ) {
            for ( License__c lic : licenseList ) {
                if ( lic.Customer__c != NULL && 'Consortium'.equalsIgnoreCase( lic.Customer__r.Type ) ) {
                    License__c licRecord = new License__c();
                    licRecord.id = lic.id;
                    licRecord.Entitlement_Creation_Status__c = 'Initiated';
                    licRecord.Entitlement_Request_Status__c = 'Initiated';
                    licIdToLicenseMap.put( licRecord.id, licRecord );
                    
                    licenseIdSet.add( lic.id );
                    LicenseMemberWrapper licenseMemberWrapperRecord = new LicenseMemberWrapper();
                    List<LicenseMemberWrapperNew> licenseMemberWrapperNewAddList = new List<LicenseMemberWrapperNew>();
                    List<LicenseMemberWrapperNew> licenseMemberWrapperNewRemoveList = new List<LicenseMemberWrapperNew>();
                    List<String> grantList = new List<String>();
                    
                    if ( lic.Grant_Type__c != NULL ) {
                        if ( lic.Grant_Type__c.contains(';') )
                            grantList = lic.Grant_Type__c.split(';');
                        else
                            grantList.add( lic.Grant_Type__c );
                    }
                    List<LicenseMemberWrapperNew> blankMemberList = new List<LicenseMemberWrapperNew>();
                    licenseMemberWrapperRecord.type = 'UpdateLicense';
                    licenseMemberWrapperRecord.licenseId = lic.id;
                    if ( lic.RecordType.Name == 'T&F Account License' )
                        licenseMemberWrapperRecord.salesforceAccountID = lic.Customer__c != NULL ? lic.Customer__c : '' ;
                    else
                        licenseMemberWrapperRecord.salesforceAccountID = '';
                    if ( lic.RecordType.Name == 'T&F Account License' )
                        licenseMemberWrapperRecord.ringgoldID = lic.Customer__c != NULL && lic.Customer__r.Ringgold_Account_ID__c != NULL ? lic.Customer__r.Ringgold_Account_ID__c : '' ;
                    else
                        licenseMemberWrapperRecord.ringgoldID = '';
                    licenseMemberWrapperRecord.partyID = ( lic.Customer__c != NULL && lic.Customer__r.Customer_Id__c != NULL && ( lic.RecordType.Name == 'T&F Account License' || String.isBlank(lic.RecordType.Name) ) ) ? lic.Customer__r.Customer_Id__c : ( ( lic.Contact__c != NULL && lic.Contact__r.Party_Id__c != NULL && lic.RecordType.Name == 'T&F Individual License' ) ? lic.Contact__r.Party_Id__c : '' );
                    licenseMemberWrapperRecord.updateType = lic.Update_Type__c != NULL ? lic.Update_Type__c : '' ;
                    licenseMemberWrapperRecord.productId = lic.Product__r.Hub_Id__c <> NULL ? lic.Product__r.Hub_Id__c : '';
                    licenseMemberWrapperRecord.orderNumber = lic.Order_Number__c <> NULL ? lic.Order_Number__c : '';
                    licenseMemberWrapperRecord.licenseType = lic.License_Type__c != NULL ? lic.License_Type__c : '';
                    licenseMemberWrapperRecord.grantType = grantList;
                    licenseMemberWrapperRecord.startDate = lic.Start_Date__c != NULL ? String.valueOf( lic.Start_Date__c ) : '';
                    licenseMemberWrapperRecord.endDate = lic.End_Date__c != NULL ? String.valueOf( lic.End_Date__c ) : '';
                    //licenseMemberWrapperRecord.status = lic.Status__c != NULL ? lic.Status__c : '';
                    if ( isAfterFlag && isInsertFlag ) {
                        licenseMemberWrapperRecord.status = 'Active';
                    } else {
                        licenseMemberWrapperRecord.status = ( lic.Status__c != NULL && 'In progress'.equalsIgnoreCase(lic.Status__c) ) ? 'Active' : ( lic.Status__c != NULL ? lic.Status__c : '' );
                    }
                    licenseMemberWrapperRecord.customerType = ( lic.Customer__c != NULL && 'Consortium'.equalsIgnoreCase(lic.Customer__r.Type) && ( lic.RecordType.Name == 'T&F Account License' || String.isBlank(lic.RecordType.Name) ) ) ? 'Consortium' : ( ( lic.Customer__c != NULL && !'Consortium'.equalsIgnoreCase(lic.Customer__r.Type) && ( lic.RecordType.Name == 'T&F Account License' || String.isBlank(lic.RecordType.Name) ) ) ? 'B2B' : ( ( lic.Contact__c != NULL && lic.RecordType.Name == 'T&F Individual License' ) ? 'Individual' : '' ) );
                    if ( licenseIdToLicenseMemberIdListMap.containsKey( lic.id ) ) {
                        for ( Id licMemId : licenseIdToLicenseMemberIdListMap.get( lic.id ) ) {
                            LicenseMemberWrapperNew newWrapperRecord = new LicenseMemberWrapperNew();
                            if ( !isBeforeFlag && !isDeleteFlag ) {
                                if ( lic.RecordType.Name == 'T&F Account License' )
                                    newWrapperRecord.salesforceAccountID = (!licenseMemberIdToAccountIdMap.isEmpty() && licenseMemberIdToAccountIdMap.containsKey(licMemId) ) ? licenseMemberIdToAccountIdMap.get( licMemId ) : '';
                                else
                                    newWrapperRecord.salesforceAccountID = '';
                                if ( lic.RecordType.Name == 'T&F Account License' )
                                    newWrapperRecord.ringgoldID = (!licensememberIdToRinggoldIdMap.isEmpty() && licensememberIdToRinggoldIdMap.containsKey(licMemId)) ? licensememberIdToRinggoldIdMap.get( licMemId ) : '';
                                else
                                    newWrapperRecord.ringgoldID = '';
                                newWrapperRecord.partyID = (!licensememberIdToCustomerIdMap.isEmpty() && licensememberIdToCustomerIdMap.containsKey(licMemId) ? licensememberIdToCustomerIdMap.get( licMemId ) : '' );
                                licenseMemberWrapperNewAddList.add( newWrapperRecord );
                            } else if ( isBeforeFlag && isDeleteFlag ) {
                                if ( lic.RecordType.Name == 'T&F Account License' )
                                    newWrapperRecord.salesforceAccountID = (!licenseMemberIdToAccountIdMap.isEmpty() && licenseMemberIdToAccountIdMap.containsKey(licMemId) ) ? licenseMemberIdToAccountIdMap.get( licMemId ) : '';
                                else
                                    newWrapperRecord.salesforceAccountID = '';
                                if ( lic.RecordType.Name == 'T&F Account License' )
                                    newWrapperRecord.ringgoldID = (!licensememberIdToRinggoldIdMap.isEmpty() && licensememberIdToRinggoldIdMap.containsKey(licMemId)) ? licensememberIdToRinggoldIdMap.get( licMemId ) : '';
                                else
                                    newWrapperRecord.ringgoldID = '';
                                newWrapperRecord.partyID = (!licensememberIdToCustomerIdMap.isEmpty() && licensememberIdToCustomerIdMap.containsKey(licMemId) ? licensememberIdToCustomerIdMap.get( licMemId ) : '' );
                                licenseMemberWrapperNewRemoveList.add( newWrapperRecord );
                            }
                        }
                    }
                    licenseMemberWrapperRecord.addMember = !licenseMemberWrapperNewAddList.isEmpty() ? licenseMemberWrapperNewAddList : blankMemberList;
                    licenseMemberWrapperRecord.removeMember = !licenseMemberWrapperNewRemoveList.isEmpty() ? licenseMemberWrapperNewRemoveList : blankMemberList;
                    licenseMemberWrapperRecord.licenseName = lic.name;
                    licenseMemberWrapperRecord.accessScope = String.isBlank(lic.Access_Scope__c) ? 'Global' : lic.Access_Scope__c;
                    if ( ( isBeforeFlag && isDeleteFlag && String.isNotBlank(lic.Status__c) && 'Active'.equalsIgnoreCase(lic.Status__c) ) || ( isAfterFlag && isInsertFlag ) ) {
                        //licenseMemberWrapperList.add( licenseMemberWrapperRecord );
                        licIdToJsonMap.put( lic.id, JSON.serialize( licenseMemberWrapperRecord ) );
                    } else {
                        nonActiveLicenseIdSet.add( lic.id );
                        nonActiveLicenseWrapperList.add( licenseMemberWrapperRecord );
                    }
                }
            }
        }
        
        //Creating a json for license member of all licenses
        if ( !licenseMemberWrapperList.isEmpty() ) {
            licenseMemberJsonStr = JSON.serialize( licenseMemberWrapperList );
            licenseMemberJsonStr = licenseMemberJsonStr.removeStart('[');
            licenseMemberJsonStr = licenseMemberJsonStr.removeEnd(']');
        }
        
        if ( !licIdToJsonMap.isEmpty() ) {
            extraLicenseMemberExecution( licIdToJsonMap );
        }
        
        if ( !nonActiveLicenseWrapperList.isEmpty() ) {
            String nonActiveLicenseJsonString = '';
            nonActiveLicenseJsonString = JSON.serialize(nonActiveLicenseWrapperList);
            nonActiveLicenseJsonString = nonActiveLicenseJsonString.removeStart('[');
            nonActiveLicenseJsonString = nonActiveLicenseJsonString.removeEnd(']');
            
            if ( String.isNotBlank(nonActiveLicenseJsonString) && !nonActiveLicenseIdSet.isEmpty() ) {
                //TF_CreateLicenseJSON_Tgr.queueUpdateRequest( nonActiveLicenseIdSet, nonActiveLicenseJsonString, 'License is not Active for license member updation.', 'Outbound Failure', 'Update' );
                Map<Id, Case> failedLicIdToCaseMap = new Map<Id, Case>();
                failedLicIdToCaseMap = TF_AsyncSQSJob.returnLicIdToCaseMap( nonActiveLicenseIdSet, 'License is not Active for license member updation.' );
                
                if ( !failedLicIdToCaseMap.isEmpty() ) {
                    TF_AsyncSQSJob.createExceptionLog( nonActiveLicenseJsonString, failedLicIdToCaseMap, 'License is not Active for license member updation.' );
                }
            }
        }
        
        return licenseMemberJsonStr;
    }
    
    public void extraLicenseMemberExecution ( Map<Id, String> liccIdToJsonMap ) {
        Map<Id, String> licIdsToJsonMap = new Map<Id, String>();
        Decimal futureCalloutSize = 0;

        if ( !liccIdToJsonMap.isEmpty() ) {
            futureCalloutSize = Math.ceil( (Decimal)liccIdToJsonMap.keySet().size()/50 );
        }

        integer sizee = 0;
        if ( futureCalloutSize != 0 ) {
            sizee = (integer)futureCalloutSize;
            integer firstCount = 0;
            for ( integer i = 0; i < sizee; i++ ) {
                integer secondCount = 0;
                firstCount += 1;
                if ( !liccIdToJsonMap.isEmpty() ) {
                    for ( Id licId : liccIdToJsonMap.keySet() ) {
                        secondCount += 1;
                        licIdsToJsonMap.put( licId, liccIdToJsonMap.get(licId) );
                        if ( secondCount == 50 ) {
                            break;
                        }
                    }
                }
                
                if ( !licIdsToJsonMap.isEmpty() ) {
                    bulkLicenseMemberSQSFutureCallout( licIdsToJsonMap );
                    
                    for ( Id liccId : licIdsToJsonMap.keySet() ) {
                        liccIdToJsonMap.remove( liccId );
                    }
                    if ( !Test.isRunningTest() ) {
                        licIdsToJsonMap.clear();
                    }
                }
                
                if ( firstCount == 22 ) {
                    break;
                }
            }
        }
    }
    
    @future(callout=true)
    public static void bulkLicenseMemberSQSFutureCallout ( Map<Id, String> licIdToJsonMap ) {
        Map<Id, Case> existngLicIdToCaseMap = new Map<Id, Case>();
        List<License__c> licenseList = new List<License__c>();
        List<License__c> licensesHistoryUpdateList = new List<License__c>();
        Map<Id, String> licIdToResponseErrorMap = new Map<Id, String>();
        List<License__c> licensesUpdateList = new List<License__c>();
        Map<Id, Case> failedLicIdToCaseMap = new Map<Id, Case>();
        
        if ( !licIdToJsonMap.isEmpty() ) {
            existngLicIdToCaseMap = TF_CreateLicenseJSON_Tgr.findLicenseCase( licIdToJsonMap.keySet() );
        }
        
        if ( !licIdToJsonMap.isEmpty() ) {
            licenseList = [ SELECT id, Customer__c, Customer__r.Type, Customer__r.Ringgold_Account_ID__c, Customer__r.Customer_Id__c, Update_Type__c, Product__c, Product__r.Hub_Id__c, Order_Number__c, License_Type__c, Grant_Type__c, Start_Date__c, End_Date__c, Status__c, Contact__c, Contact__r.Party_Id__c, RecordType.Name, Entitlement_Request_Status__c, Entitlement_Creation_Status__c FROM License__c WHERE id IN:licIdToJsonMap.keySet() ];
        }

        if ( !licenseList.isEmpty() ) {
            for ( License__c licnse : licenseList ) {
                License__c updateLIcense = new License__c();
                updateLIcense.id = licnse.id;
                if ( licnse.Entitlement_Creation_Status__c != 'Initiated' ) {
                    updateLIcense.Entitlement_Creation_Status__c = 'Initiated';
                }
                if ( licnse.Entitlement_Request_Status__c != 'Initiated' ) {
                    updateLIcense.Entitlement_Request_Status__c = 'Initiated';
                }
                licensesHistoryUpdateList.add( updateLIcense );
            }
        }
        
        if ( !licenseList.isEmpty() ) {
            for ( License__c lic : licenseList ) {
                HttpResponse awsResponse = new HttpResponse();
                
                if ( !existngLicIdToCaseMap.containsKey(lic.id) && licIdToJsonMap.containsKey(lic.id) ) {
                    awsResponse = TF_AsyncSQSJob.postNotificationsToSNS(licIdToJsonMap.get(lic.id));
                }
                
                if ( Test.isRunningTest() ) {
                    awsResponse = NULL;
                }
                
                if ( awsResponse != NULL && awsResponse.getStatusCode() == 200 ) {
                    lic.Entitlement_Request_Status__c = 'Requested';
                    if ( !'Deactivated'.equalsIgnoreCase(lic.Status__c) )
                        lic.Status__c = 'License created successfully, Entitlement Creation in progress';
                } else {
                    lic.Entitlement_Request_Status__c = 'Failed';
                    lic.Status__c = 'License created successfully, EMS request failed';
                    String awsError = '';
                    String result = '';
                    if ( awsResponse != NULL && String.isNotBlank( awsResponse.getStatus() ) )
                        awsError = awsResponse.getStatusCode() + ' ' + awsResponse.getStatus() + ' : ';
                    if ( awsResponse != NULL && String.isNotBlank( awsResponse.getBody() ) )
                        awsError += awsResponse.getBody();
                    
                    if ( String.isNotBlank( awsError ) ) {
                        String failResponseBody = awsError;
                        result = failResponseBody.replaceAll('<br/>', '\n');
                        result = result.replaceAll('<br/>', '\n');
                        //regular expression to match all HTML/XML tags
                        string HTML_TAG_PATTERN = '<.*?>';
                        // compile the pattern
                        pattern myPattern = pattern.compile(HTML_TAG_PATTERN);
                        // get your matcher instance
                        matcher myMatcher = myPattern.matcher(result);
                        //remove the tags
                        result = myMatcher.replaceAll('');
                    }
                    if ( String.isBlank(result) ) {
                        result = 'License Member request failed to reach SQS.';
                    }
                    licIdToResponseErrorMap.put( lic.id, result );
                }
                licensesUpdateList.add( lic );
            }
        }
        
        if ( !licensesHistoryUpdateList.isEmpty() ) { //this is just to update license history for SQS request and response
            try {
                update licensesHistoryUpdateList;
            } catch ( Exception ex ) {
                System.debug('************ Update DML Exception ************');
                System.debug(ex.getMessage());
            }
        }
        
        if ( !licensesUpdateList.isEmpty() ) {
            try {
                update licensesUpdateList;
            } catch ( Exception ex ) {
                System.debug('************ Update DML Exception ************');
                System.debug(ex.getMessage());
            }
        }
        
        if ( !licIdToResponseErrorMap.isEmpty() ) {
            failedLicIdToCaseMap = TF_CreateLicenseJSON_Tgr.returnLicIdToCaseMap( licIdToResponseErrorMap );
        }
        
        if ( !failedLicIdToCaseMap.isEmpty() ) {
            TF_CreateLicenseJSON_Tgr.createLicenseExceptionLog( licIdToJsonMap, failedLicIdToCaseMap, licIdToResponseErrorMap);
        }
    }
    
    public class LicenseMemberWrapper {
        public String type;
        public String licenseId;
        public String salesforceAccountID;
        public String ringgoldID;
        public String partyID;
        public String updateType;
        public List<LicenseMemberWrapperNew> addMember;
        public List<LicenseMemberWrapperNew> removeMember;
        public String productId;
        public String orderNumber;
        public String licenseType;
        public List<String> grantType;
        public String startDate;
        public String endDate;
        public String status;
        public String customerType;
        public String licenseName;
        public String accessScope;
    }
    public class LicenseMemberWrapperNew {
        public String salesforceAccountID;
        public String ringgoldID;
        public String partyID;
    }
    
}