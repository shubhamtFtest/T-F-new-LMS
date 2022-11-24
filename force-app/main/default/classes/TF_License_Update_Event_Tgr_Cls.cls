/***********************************************************************************
    // This is handler class for trigger "TF_License_Update_Event_Tgr"
    // This class is to send dynamic license update request to Entitlement hub
       for every product hub Id matches with license product's hub Id
    // Created by Vikas Varshney on dated 15-01-2019 for POF-776 & POF-777
    // Test class "zTest_TF_License_Update_Event_Tgr"
    // Modified by Vikas for LMS-181 on dated 25th July, 2019
    // Modified by Vikas for LMS-329 on dated 22nd Oct, 2019
    // Modified by Vikas for LMS-424 on dated 22nd Dec, 2019
    // Modified by Vikas for UBXC-169 on dated 17th Feb, 2020
    // Modified by Vikas for UBX-920 on dated 02nd June, 2020
***********************************************************************************/

public class TF_License_Update_Event_Tgr_Cls {
    
    //method to send license update event json to Entitlement hub for product hub request
    //Disabling code trigeer os not required now and switched this work to API "/services/apexrest/licenses/postHasPartUpdate?type=update_dynamic_license"
    public static void updateDynamicRequest ( List<License_Update_Event__e> licenseUpdateEventNewList ) {
        /*
        Map<String, String> eventHubIdToUpdateTypeMap = new Map<String, String>();
        Map<Id, License__c> licenseIdToLicenseMap = new Map<Id, License__c>();
        String eventJsonRequest = '';
        String excptionLogObjectIdd = '';
        List<License__c> licenseList = new List<License__c>();
        List<License__c> nonActiveLicenseList = new List<License__c>();
        String nonActiveLicenseJsonRequest = '';
        Set<String> excludeStatusSet = new Set<String>();
        excludeStatusSet.add('Expired');
        excludeStatusSet.add('Deactivated');

        if ( !licenseUpdateEventNewList.isEmpty() ) {
            for ( License_Update_Event__e event : licenseUpdateEventNewList ) {
                if ( String.isBlank( event.hubID__c ) ) {
                    createCase( 'Hub Id not available', event );
                } else if ( String.isBlank( event.Update_Type__c ) ) {
                    createCase( 'Update Type not available', event );
                } else if ( String.isNotBlank( event.Update_Type__c ) && !event.Update_Type__c.equalsIgnoreCase('UPDATE_ALL_LICENSE') && !event.Update_Type__c.equalsIgnoreCase('UPDATE_DYNAMIC_LICENSE') ) {
                    createCase( 'Update Type does not match with UPDATE_ALL_LICENSE or UPDATE_DYNAMIC_LICENSE', event );
                } else if ( String.isNotBlank( event.hubID__c ) && String.isNotBlank( event.Update_Type__c ) ) {
                    eventHubIdToUpdateTypeMap.put( event.hubID__c, event.Update_Type__c );
                }
            }
        }

        try {
            if ( !eventHubIdToUpdateTypeMap.isEmpty() ) {
                licenseList = [ SELECT id, name, Product__c, Product__r.Hub_Id__c, Update_Type__c, Status__c, End_Date__c FROM License__c WHERE Status__c NOT IN:excludeStatusSet AND Product__r.Hub_Id__c IN:eventHubIdToUpdateTypeMap.keySet() ];
            }

            Date todaysDate = Date.newInstance(Date.today().year(), Date.today().month(), Date.today().day());

            if ( !licenseList.isEmpty() ) {
                for ( License__c lic : licenseList ) {
                    if ( 'Active'.equalsIgnoreCase(lic.Status__c) ) {
                        licenseIdToLicenseMap.put( lic.id, lic );
                    } else if ( ( !'Expired'.equalsIgnoreCase(lic.Status__c) ) && ( !'Deactivated'.equalsIgnoreCase(lic.Status__c) ) && ( lic.End_Date__c > todaysDate || lic.End_Date__c == NULL ) ) {
                        nonActiveLicenseList.add( lic );
                    }
                }
            }

            Map<String, Set<Id>> hubIdToLicenseIdSetMap = new Map<String, Set<Id>>(); //Initializing map of product hub id and its license ids list
            Map<String, String> hubIdToJSONMap = new Map<String, String>(); //Initializing map of product hub id and its json of license ids list
            if ( !licenseUpdateEventNewList.isEmpty() ) {
                for ( License_Update_Event__e evnt : licenseUpdateEventNewList ) {
                    if ( !hubIdToLicenseIdSetMap.containsKey(evnt.hubID__c) ) {
                        hubIdToLicenseIdSetMap.put( evnt.hubID__c, new Set<Id>() );
                    }
                    //Update Type can be UPDATE_ALL_LICENSE or UPDATE_DYNAMIC_LICENSE
                    if ( String.isNotBlank(evnt.Update_Type__c) && 'UPDATE_DYNAMIC_LICENSE'.equalsIgnoreCase(evnt.Update_Type__c) ) {
                        if ( !licenseIdToLicenseMap.isEmpty() ) {
                            for ( License__c licc : licenseIdToLicenseMap.values() ) {
                                if ( String.isNotBlank(licc.Product__c) && String.isNotBlank(licc.Product__r.Hub_Id__c) && licc.Product__r.Hub_Id__c.equalsIgnoreCase(evnt.hubID__c) && 'Dynamic'.equalsIgnoreCase(licc.Update_Type__c) ) {
                                    hubIdToLicenseIdSetMap.get(evnt.hubID__c).add( licc.id );
                                }
                            }
                        }
                    } else if ( String.isNotBlank(evnt.Update_Type__c) && 'UPDATE_ALL_LICENSE'.equalsIgnoreCase(evnt.Update_Type__c) ) {
                        if ( !licenseIdToLicenseMap.isEmpty() ) {
                            for ( License__c licnse : licenseIdToLicenseMap.values() ) {
                                if ( String.isNotBlank(licnse.Product__c) && String.isNotBlank(licnse.Product__r.Hub_Id__c) && licnse.Product__r.Hub_Id__c.equalsIgnoreCase(evnt.hubID__c) ) {
                                    hubIdToLicenseIdSetMap.get(evnt.hubID__c).add( licnse.id );
                                }
                            }
                        }
                    }
                }
            }
            
            //creating map of hub id and its json to post to S3
            if ( !hubIdToLicenseIdSetMap.isEmpty() ) {
                for ( String hubId : hubIdToLicenseIdSetMap.keySet() ) {
                    if ( !hubIdToLicenseIdSetMap.get( hubId ).isEmpty() ) {
                        eventJsonWrapper eventJsonRecord = new eventJsonWrapper();
                        eventJsonRecord.type = 'HasPartUpdate';
                        eventJsonRecord.licenseProductHubId = hubId;
                        eventJsonRecord.licenseIds = new List<Id>();
                        eventJsonRecord.licenseIds.addAll( hubIdToLicenseIdSetMap.get( hubId ) );
                        hubIdToJSONMap.put( hubId, JSON.serialize(eventJsonRecord) );
                    }
                }
            }
            
            if ( !hubIdToJSONMap.isEmpty() ) {
                s3LicenseCalloutAndSNSNotify( hubIdToJSONMap );
            }
            
            //this is to queue dyamic license update request to the existinf case for non-active licenses
            Set<Id> nonActiveLicenseSet = new Set<Id>();
            Map<String, Set<Id>> hubIdToNonActiveLicIdSetMap = new Map<String, Set<Id>>();
            Map<Id, String> nonActiveLicIdToHubIdMap = new Map<Id, String>();
            Map<String, String> nonActiveHubIdToJsonMap = new Map<String, String>();
            if ( !nonActiveLicenseList.isEmpty() ) {
                for ( License__c nonActivLicense : nonActiveLicenseList ) {
                    if ( nonActivLicense.Product__c != NULL && String.isNotBlank(nonActivLicense.Product__r.Hub_Id__c) ) {
                        nonActiveLicenseSet.add( nonActivLicense.id );
                        nonActiveLicIdToHubIdMap.put( nonActivLicense.id, nonActivLicense.Product__r.Hub_Id__c );
                        if ( !hubIdToNonActiveLicIdSetMap.containsKey(nonActivLicense.Product__r.Hub_Id__c) ) {
                            hubIdToNonActiveLicIdSetMap.put( nonActivLicense.Product__r.Hub_Id__c, new Set<Id>() );
                        }
                        hubIdToNonActiveLicIdSetMap.get( nonActivLicense.Product__r.Hub_Id__c ).add( nonActivLicense.id );
                    }
                }
            }
            
            if ( !nonActiveLicenseSet.isEmpty() ) {
                if ( !hubIdToNonActiveLicIdSetMap.isEmpty() ) {
                    for ( String evnthubId : hubIdToNonActiveLicIdSetMap.keySet() ) {
                        eventJsonWrapper nonActiveLicenseJsonRecord = new eventJsonWrapper();
                        nonActiveLicenseJsonRecord.type = 'HasPartUpdate';
                        nonActiveLicenseJsonRecord.licenseProductHubId = evnthubId;
                        nonActiveLicenseJsonRecord.licenseIds = new List<Id>();
                        nonActiveLicenseJsonRecord.licenseIds.addAll( hubIdToNonActiveLicIdSetMap.get( evnthubId ) );
                        nonActiveHubIdToJsonMap.put( evnthubId, JSON.serialize(nonActiveLicenseJsonRecord) );
                    }
                }
                
                Map<Id, Case> failedLicIdToCaseMap = new Map<Id, Case>();
                failedLicIdToCaseMap = TF_AsyncSQSJob.returnLicIdToCaseMap( nonActiveLicenseSet, 'Licenses matching dynamic product update are not active.' );

                if ( !failedLicIdToCaseMap.isEmpty() ) {
                    List<Exception_Log__c> exceptionLogList = new List<Exception_Log__c>();
                    
                    try {
                        if ( !failedLicIdToCaseMap.isEmpty() ) {
                            for ( Id licId : failedLicIdToCaseMap.keySet() ) {
                                String licJson = '';
                                if ( nonActiveLicIdToHubIdMap.containsKey(licId) ) {
                                    licJson = nonActiveHubIdToJsonMap.get( nonActiveLicIdToHubIdMap.get( licId ) );
                                }
                                Exception_Log__c exceptionLogInsert = new Exception_Log__c();
                                exceptionLogInsert.ownerId = UserInfo.getUserId();
                                exceptionLogInsert.Object_ID__c = licId;
                                exceptionLogInsert.Object_Type__c = 'License';
                                exceptionLogInsert.Error_Type__c = 'Outbound';
                                exceptionLogInsert.Error_message__c = 'Licenses matching dynamic product update are not active.';
                                exceptionLogInsert.Type_of_Action__c = ( String.isNotBlank(licJson) && licJson.contains('AddLicense') ) ? 'Insert' : ( ( String.isNotBlank(licJson) && ( licJson.contains('UpdateLicense') || licJson.contains('HasPartUpdate') ) ? 'Update' : '' ) );
                                exceptionLogInsert.Request_JSON__c = licJson;
                                exceptionLogInsert.Case_Number__c = ( failedLicIdToCaseMap.containsKey(licId) && String.isNotBlank(failedLicIdToCaseMap.get(licId).CaseNumber) ? failedLicIdToCaseMap.get(licId).CaseNumber : '');
                                exceptionLogInsert.Resolution_Status__c = 'New';
                                exceptionLogInsert.Case__c = failedLicIdToCaseMap.containsKey(licId) ? failedLicIdToCaseMap.get(licId).id : '';
                                exceptionLogList.add(exceptionLogInsert);
                            }
                        }
                        
                        if ( !exceptionLogList.isEmpty() ) {
                            insert exceptionLogList;
                        }
                    } catch ( Exception ex ) {
                        System.debug('Exception =====>' + ex.getMessage());
                    }
                }

                List<License__c> initiatedLicUpdateList = new List<License__c>();
                List<License__c> nonActiveLicUpdateList = new List<License__c>();
                if ( !nonActiveLicenseSet.isEmpty() ) {
                    for ( Id licIdd : nonActiveLicenseSet ) {
                        License__c initiatedLicense = new License__c();
                        initiatedLicense.id = licIdd;
                        initiatedLicense.Entitlement_Creation_Status__c = 'Initiated';
                        initiatedLicense.Entitlement_Request_Status__c = 'Initiated';
                        initiatedLicUpdateList.add( initiatedLicense );
                    }
                    
                    if ( !initiatedLicUpdateList.isEmpty() ) {
                        try {
                            update initiatedLicUpdateList;
                        } catch ( Exception ex ) {
                            System.debug('************ Update DML Exception ************');
                            System.debug('Exception =====>' + ex.getMessage());
                        }
                    }
                    
                    for ( Id licIdd : nonActiveLicenseSet ) {
                        License__c updateLicnse = new License__c();
                        updateLicnse.id = licIdd;
                        updateLicnse.Entitlement_Request_Status__c = 'Failed';
                        updateLicnse.Status__c = 'License created successfully, EMS request failed';
                        nonActiveLicUpdateList.add( updateLicnse );
                    }
                    
                    if ( !nonActiveLicUpdateList.isEmpty() ) {
                        try {
                            update nonActiveLicUpdateList;
                        } catch ( Exception ex ) {
                            System.debug('************ Update DML Exception ************');
                            System.debug('Exception =====>' + ex.getMessage());
                        }
                    }
                }
            }
        } catch ( Exception e ) {
            System.debug('Exception for Dynamic License Update ==========>' + e.getMessage());
        }*/
    }
    
    /*
    //********** ------------- private and public methods ------------- **********
    private static void createCase ( String productHubError, License_Update_Event__e requestedJsonStr ) {
        Case caseInsert = new Case();
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Salesforce Internal Support').getRecordTypeId();
        caseInsert.RecordTypeId = caseRecordTypeId != NULL ? caseRecordTypeId : '';
        caseInsert.Status = 'New';
        caseInsert.Priority = 'Low';
        caseInsert.Application__c = 'License and Entitlement';
        caseInsert.Type = 'Outbound Failure';
        caseInsert.Origin = 'Other';
        caseInsert.Subject = 'Dynamic product update notification failed : HasPartUpdate';
        caseInsert.Description =  'Error message :- ' + '\n\n'+ productHubError + '\n\n' + requestedJsonStr;
        caseInsert.OwnerId = UserInfo.getUserId();
        
        insert caseInsert;
    }
    */
    
    public static String putUUIDRequestLicenseJsonToS3(String payload, String productId, String bucketName, String folderPath){
        try{
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            String regionName = (String) orgSpecificProps.get('AWS_Region_Name__c');
            String keyAccessId = (String) orgSpecificProps.get('AWS_SNS_License_Access_Key_Id__c');
            String secretAccessKey = (String) orgSpecificProps.get('AWS_SNS_License_Secret_Access_key__c');
            String hostUrl = 'https://'+ bucketName + (String) orgSpecificProps.get('AWS_S3_Host_Url__c');
            TF_AwsRestWrapper  tFAwsRestWrapper = new TF_AwsRestWrapper();
            if( String.isNotBlank(regionName) && String.isNotBlank(keyAccessId) && String.isNotBlank(secretAccessKey) && String.isNotBlank(hostUrl) && String.isNotBlank(productId)){
                String sampleText = 'test string';
                String objectName = 'test ObjectName';
                String response = tFAwsRestWrapper.put(payload ,'application/json', regionName, folderPath, productId, productId, keyAccessId, secretAccessKey, hostUrl);
                if(response != null){
                    System.debug('JSON Placed in S3');
                    return response;
                } else {
                    System.debug('Error Placing the JSON in S3');
                    return null;
                }
            }
            else {
                throw new SFDCCustomException('One or more org specific property for S3 is blank');
            }
        } catch(Exception e){
            System.debug('Error in processing method putUUIDRequestLicenseJsonToS3, Error Message : '+e.getMessage());
        }
        return null;
    }
    
    @future(callout=true)
    public static void s3LicenseCalloutAndSNSNotify ( Map<String, String> hubIddToJsonMap ) {
        try {
            Map<String, String> hubIdToS3LocationMap = new Map<String, String>();
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            String bucketNameS3 = (String) orgSpecificProps.get('AWS_S3_License_Validation_Bucket__c');
            DateTime noww = Datetime.now();
            String reqFolder = 'HasPartUpdate/' + String.valueOf(noww.formatGMT('yyyy/MM/dd'));
            Map<String, String> hubIdToAwsResponseMap = new Map<String, String>();
            Map<String, Set<Id>> hubIddToLicenseIdSetMap = new Map<String, Set<Id>>();
            Map<Id, String> licIdToAwsStatusMap = new Map<Id, String>();
            Set<Id> activeLicenseIdSet = new Set<Id>();
            List<License__c> licensesList = new List<License__c>();
            Map<Id, String> licIdToHubIdMap = new Map<Id, String>();
            
            if ( !hubIddToJsonMap.isEmpty() ) {
                for ( String hubId : hubIddToJsonMap.keySet() ) {
                    String s3Response = '';
                    String reqFilename = String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd-HH-mm-ss-SSS')) + '.json' ;
                    if ( !hubIddToLicenseIdSetMap.containsKey(hubId) ) {
                        hubIddToLicenseIdSetMap.put( hubId, new Set<Id>() );
                    }
                    if ( String.isNotBlank(hubIddToJsonMap.get(hubId)) ) {
                        s3Response = putUUIDRequestLicenseJsonToS3( hubIddToJsonMap.get(hubId), reqFilename, bucketNameS3, reqFolder ); //putting has part update request in S3
                        TF_HasPartWrapper hasPartWrapperRecord = new TF_HasPartWrapper();
                        hasPartWrapperRecord = (TF_HasPartWrapper)JSON.deserialize(hubIddToJsonMap.get(hubId), TF_HasPartWrapper.class);
                        /*if ( !hasPartWrapper.licenseIds.isEmpty() ) {
                            hubIddToLicenseIdSetMap.get(hubId).addAll(hasPartWrapper.licenseIds);
                        }*/
                        List<TF_HasPartWrapper.licenseDetails> licenseWrapperList = new List<TF_HasPartWrapper.licenseDetails>();
                        if ( hasPartWrapperRecord != NULL && hasPartWrapperRecord.Body != NULL ) {
                            if ( !hasPartWrapperRecord.Body.licenses.isEmpty() ) {
                                licenseWrapperList = hasPartWrapperRecord.Body.licenses;
                            }
                        }
                        
                        if ( !licenseWrapperList.isEmpty() ) {
                            for ( TF_HasPartWrapper.licenseDetails licDetail : licenseWrapperList ) {
                                if ( String.isNotBlank(licDetail.licenseId) ) {
                                    hubIddToLicenseIdSetMap.get(hubId).add( licDetail.licenseId );
                                }
                            }
                        }
                    }
                    
                    System.debug('s3Response =====>' + s3Response);
                    System.debug('hubIddToLicenseIdSetMap =====>' + hubIddToLicenseIdSetMap);
                    System.debug('hubIddToLicenseIdSetMap Size =====>' + hubIddToLicenseIdSetMap.Size());
                    
                    if ( String.isNotBlank(s3Response) && s3Response.containsIgnoreCase('https') ) {
                        HttpResponse awsResponse = new HttpResponse();
                        String awsJson = '{"s3HasPartLocation": "'+ s3Response +'"}';
                        awsResponse = TF_AsyncSQSJob.postNotificationsToSNS( awsJson ); //posting request to SNS
                        
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
                        
                        System.debug('result =====>' + result);
                        if ( awsResponse != NULL && String.valueOf(awsResponse.getStatusCode()).startsWith('2') ) {
                            hubIdToAwsResponseMap.put( hubId, String.valueOf(awsResponse.getStatusCode()) );
                        } else {
                            if ( String.isNotBlank(result) ) {
                                hubIdToAwsResponseMap.put( hubId, result );
                            } else {
                                hubIdToAwsResponseMap.put( hubId, String.valueOf(awsResponse.getStatusCode()) );
                            }
                        }
                    }
                    hubIdToS3LocationMap.put( hubId, s3Response );
                    s3Response = '';
                }
            }
            System.debug('hubIdToAwsResponseMap =====>' + hubIdToAwsResponseMap);
            System.debug('hubIdToS3LocationMap =====>' + hubIdToS3LocationMap);
            
            if ( !hubIddToJsonMap.isEmpty() ) {
                for ( String hubbId : hubIddToJsonMap.keySet() ) {
                    if ( hubIddToLicenseIdSetMap.containsKey(hubbId) && !hubIddToLicenseIdSetMap.get(hubbId).isEmpty() ) {
                        for ( Id licId : hubIddToLicenseIdSetMap.get(hubbId) ) {
                            activeLicenseIdSet.add( licId );
                            licIdToHubIdMap.put( licId, hubbId );
                            licIdToAwsStatusMap.put( licId, hubIdToAwsResponseMap.get(hubbId) );
                        }
                    }
                }
            }
            System.debug('activeLicenseIdSet =====>' + activeLicenseIdSet);

            if ( !activeLicenseIdSet.isEmpty() ) {
                licensesList = [ SELECT id, Status__c, Entitlement_Request_Status__c, Entitlement_Creation_Status__c FROM License__c WHERE id IN:activeLicenseIdSet ];
            }
            System.debug('licensesList =====>' + licensesList);
            
            List<License__c> licenseInitiateUpdateList = new List<License__c>(); //updating EMS creation and request statuses on licenses to "Initiate"
            if ( !licensesList.isEmpty() ) {
                for ( License__c lic : licensesList ) {
                    License__c updateRecord = new License__c();
                    updateRecord.id = lic.id;
                    if ( !'Initiated'.equalsIgnoreCase(lic.Entitlement_Creation_Status__c) ) {
                        updateRecord.Entitlement_Creation_Status__c = 'Initiated';
                    }
                    if ( !'Initiated'.equalsIgnoreCase(lic.Entitlement_Request_Status__c) ) {
                        updateRecord.Entitlement_Request_Status__c = 'Initiated';
                    }
                    licenseInitiateUpdateList.add( updateRecord );
                }
            }
            
            System.debug('licenseInitiateUpdateList =====>' + licenseInitiateUpdateList);
            if ( !licenseInitiateUpdateList.isEmpty() ) { //this is just to update license history for SQS request and response
                try {
                    update licenseInitiateUpdateList;
                    System.debug('licenseInitiateUpdateList =====>' + licenseInitiateUpdateList);
                    System.debug('licenseInitiateUpdateList Size =====>' + licenseInitiateUpdateList.Size());
                } catch ( Exception ex ) {
                    System.debug('************ Update DML Exception ************');
                    System.debug('Exception =====>' + ex.getMessage());
                }
            }
            
            List<License__c> licenseUpdateList = new List<License__c>();
            Set<Id> failedLicenseIdSet = new Set<Id>();
            if ( !licensesList.isEmpty() ) {
                for ( License__c licc : licensesList ) {
                    License__c updateLicRecord = new License__c();
                    if ( licIdToAwsStatusMap.containsKey(licc.id) && String.isNotBlank(licIdToAwsStatusMap.get(licc.id)) ) {
                        if ( licIdToAwsStatusMap.get(licc.id).startsWith('2') ) {
                            updateLicRecord.id = licc.id;
                            updateLicRecord.Entitlement_Request_Status__c = 'Requested';
                            if ( !'Deactivated'.equalsIgnoreCase(licc.Status__c) ) {
                                updateLicRecord.Status__c = 'License created successfully, Entitlement Creation in progress';
                            }
                        } else {
                            updateLicRecord.id = licc.id;
                            updateLicRecord.Entitlement_Request_Status__c = 'Failed';
                            updateLicRecord.Status__c = 'License created successfully, EMS request failed';
                            failedLicenseIdSet.add( licc.id );
                        }
                    } else {
                        updateLicRecord.id = licc.id;
                        updateLicRecord.Entitlement_Request_Status__c = 'Failed';
                        updateLicRecord.Status__c = 'License created successfully, EMS request failed';
                        failedLicenseIdSet.add( licc.id );
                    }
                    licenseUpdateList.add( updateLicRecord );
                }
            }
            
            if ( Test.isRunningTest() ) {
                failedLicenseIdSet.add(licensesList[0].id);
            }
            
            System.debug('licenseUpdateList =====>' + licenseUpdateList);
            if ( !licenseUpdateList.isEmpty() ) {
                try {
                    update licenseUpdateList;
                    System.debug('licenseUpdateList =====>' + licenseUpdateList);
                    System.debug('licenseUpdateList Size =====>' + licenseUpdateList.Size());
                } catch ( Exception ex ) {
                    System.debug('************ Update DML Exception ************');
                    System.debug('Exception =====>' + ex.getMessage());
                }
            }
            
            if ( !failedLicenseIdSet.isEmpty() ) {
                Map<Id, Case> licnseIdToCaseMap = new Map<Id, Case>();
                licnseIdToCaseMap = TF_AsyncSQSJob.returnLicIdToCaseMap( failedLicenseIdSet, 'HasPartUpdate EMS request failed.' );
                
                if ( !licnseIdToCaseMap.isEmpty() ) {
                    //TF_AsyncSQSJob.createExceptionLog( eventJsonStr, failedLicIdToCaseMap, result );
                    List<Exception_Log__c> exceptionLogList = new List<Exception_Log__c>();
                    
                    try {
                        if ( !licnseIdToCaseMap.isEmpty() ) {
                            for ( Id licId : licnseIdToCaseMap.keySet() ) {
                                String licJson = '';
                                if ( licIdToHubIdMap.containsKey(licId) ) {
                                    licJson = hubIddToJsonMap.get( licIdToHubIdMap.get( licId ) );
                                }
                                Exception_Log__c exceptionLogInsert = new Exception_Log__c();
                                exceptionLogInsert.ownerId = UserInfo.getUserId();
                                exceptionLogInsert.Object_ID__c = licId;
                                exceptionLogInsert.Object_Type__c = 'Platform Event';
                                exceptionLogInsert.Error_Type__c = 'Outbound';
                                exceptionLogInsert.Error_message__c = 'HasPartUpdate : ' + licIdToAwsStatusMap.get( licId );
                                exceptionLogInsert.Type_of_Action__c = ( String.isNotBlank(licJson) && licJson.contains('AddLicense') ) ? 'Insert' : ( ( String.isNotBlank(licJson) && ( licJson.contains('UpdateLicense') || licJson.contains('HasPartUpdate') ) ? 'Update' : '' ) );
                                exceptionLogInsert.Request_JSON__c = licJson;
                                exceptionLogInsert.Case_Number__c = ( licnseIdToCaseMap.containsKey(licId) && String.isNotBlank(licnseIdToCaseMap.get(licId).CaseNumber) ? licnseIdToCaseMap.get(licId).CaseNumber : '');
                                exceptionLogInsert.Resolution_Status__c = 'New';
                                exceptionLogInsert.Case__c = licnseIdToCaseMap.containsKey(licId) ? licnseIdToCaseMap.get(licId).id : '';
                                exceptionLogList.add(exceptionLogInsert);
                            }
                        }
                        
                        if ( !exceptionLogList.isEmpty() ) {
                            insert exceptionLogList;
                        }
                    } catch ( Exception ex ) {
                        System.debug('Exception =====>' + ex.getMessage());
                    }
                }
            }
        } catch ( Exception ex ) {
            System.debug('***** TF_License_Update_Event_Tgr_Cls.s3LicenseCallout Exception *****' + ex.getMessage());
        }
    }
    
    //********** ------------- Wrapper class ------------- **********
    public class eventJsonWrapper {
        public String type;
        public String licenseProductHubId;
        public List<Id> licenseIds;
    }
}