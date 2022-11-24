/************************************************************************
    //Created by Vikas for POF-264 on dated 16-10-2018
    //This class is being used in trigger 'TF_CreateLicenseJSON_Tgr'
    //to make a callout in trigger
    //Modified by Vikas for POF-604 on dated 12-11-2018
    //Modified by Vikas for LMS-181 on dated 25th July, 2019
    //Modified by Vikas for LMS-329 on dated 22nd Oct, 2019
************************************************************************/


public class TF_AsyncSQSJob {

    @future(callout=true)
    public static void callingSQSQueue ( String licenseJsonStringg, Set<id> licensesIdSett, Boolean isInsertt, Boolean isUpdatee, Boolean isDeletee ) {
        sqsQueue( licenseJsonStringg, licensesIdSett, isInsertt, isUpdatee, isDeletee );
    }
    
    public static void sqsQueue ( String licenseJsonString, Set<id> licensesIdSet, Boolean isInsert, Boolean isUpdate, Boolean isDelete ) {
        HttpResponse awsResponse = new HttpResponse();
        List<License__c> licensesList = new List<License__c>();
        List<License__c> licensesUpdateList = new List<License__c>();
        List<License__c> licensesHistoryUpdateList = new List<License__c>();
        Set<Id> failedLicIdSet = new Set<Id>();
        Map<Id, Case> failedLicIdToCaseMap = new Map<Id, Case>();
        
        awsResponse = postNotificationsToSNS( licenseJsonString );

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

        if ( !licensesIdSet.isEmpty() ) {
            licensesList = [ SELECT id, Status__c, Entitlement_Request_Status__c, Entitlement_Creation_Status__c FROM License__c WHERE id IN:licensesIdSet ];
        }
        
        if ( !licensesList.isEmpty() && String.isNotBlank(result) ) { // this loop is to make "Entitlement Creation Status" & "Entitlement Request Status" fields as "Initiated" if not
            for ( License__c licnse : licensesList ) {
                if ( licnse.Entitlement_Creation_Status__c != 'Initiated' ) {
                    licnse.Entitlement_Creation_Status__c = 'Initiated';
                }
                if ( licnse.Entitlement_Request_Status__c != 'Initiated' ) {
                    licnse.Entitlement_Request_Status__c = 'Initiated';
                }
                licensesHistoryUpdateList.add( licnse );
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

        //Updating the request result in license
        if ( !licensesList.isEmpty() ) {
            for ( License__c lic : licensesList ) {
                if ( awsResponse != NULL && awsResponse.getStatusCode() == 200 ) {
                    lic.Entitlement_Request_Status__c = 'Requested';
                    if ( !'Deactivated'.equalsIgnoreCase(lic.Status__c) )
                        lic.Status__c = 'License created successfully, Entitlement Creation in progress';
                } else {
                    lic.Entitlement_Request_Status__c = 'Failed';
                    lic.Status__c = 'License created successfully, EMS request failed';
                    //licenseExceptionLog( lic, licenseJsonString, result, 'Outbound Failure', isInsert, isUpdate, isDelete );
                    failedLicIdSet.add( lic.id );
                }
                licensesUpdateList.add( lic );
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
        
        if ( !failedLicIdSet.isEmpty() ) {
            failedLicIdToCaseMap = returnLicIdToCaseMap( failedLicIdSet, result );
        }

        if ( !failedLicIdToCaseMap.isEmpty() ) {
            createExceptionLog( licenseJsonString, failedLicIdToCaseMap, result );
        }
    }
    
    public static Map<Id, Case> returnLicIdToCaseMap ( Set<Id> licnseIdSet, String licenseError ) {
        Id caseRecordTypeId;
        Map<Id, Case> caseIdToCaseMap;
        Set<String> licStringSet = new Set<String>();
        Map<Id, Case> licIdToCaseMap = new Map<Id, Case>();
        Map<Id, Case> licIdToCaseInsertMap = new Map<Id, Case>();
        
        try {
            if ( !licnseIdSet.isEmpty() ) {
                for ( Id licId : licnseIdSet ) {
                    licStringSet.add('%'+licId+'%');
                }
            }

            if ( !licStringSet.isEmpty() ) {
                try {
                    caseRecordTypeId = [ SELECT id, name FROM RecordType WHERE sObjectType = 'Case' AND Name = 'Salesforce Internal Support' LIMIT 1 ].id;
                    caseIdToCaseMap = new Map<Id, Case>( [ SELECT id, CaseNumber, Status, Subject FROM Case WHERE RecordTypeId =:caseRecordTypeId AND Status = 'New' AND Subject LIKE :licStringSet ] );
                } catch ( Exception ex ) {
                    caseIdToCaseMap = new Map<Id, Case>();
                    System.debug('Exception =====>' + ex.getMessage());
                }
            }

            String licensePrefix = '';
            licensePrefix = License__c.SObjectType.getDescribe().getKeyPrefix();
            if ( !caseIdToCaseMap.isEmpty() ) {
                for ( Case casse : caseIdToCaseMap.values() ) {
                    if ( casse.subject.contains(licensePrefix) ) {
                        String licenseStr = '';
                        licenseStr = casse.subject.subStringAfter(licensePrefix);
                        String licenseIdd = '';
                        if ( licenseStr.length() >= 15 ) {
                            licenseIdd = licenseStr.substring(0,15);
                        } else if ( licenseStr.length() >= 12 ) {
                            licenseIdd = licenseStr.substring(0,12);
                        }
                        licenseIdd = licenseIdd.trim();
                        licenseIdd = licensePrefix + licenseIdd;
                        licIdToCaseMap.put( licenseIdd, casse );
                    }
                }
            }
        } catch ( Exception ex ) {
            System.debug('Exception =====>' + ex.getMessage());
        }
        
        if ( !licnseIdSet.isEmpty() ) {
            for ( Id liccId : licnseIdSet ) {
                if ( !licIdToCaseMap.containsKey(liccId) ) {
                    Case caseInsert = new Case();
                    caseInsert.RecordTypeId = caseRecordTypeId != NULL ? caseRecordTypeId : '';
                    caseInsert.Status = 'New';
                    caseInsert.Priority = 'Low';
                    caseInsert.Application__c = 'License and Entitlement';
                    caseInsert.Type = 'Outbound Failure';
                    caseInsert.Origin = 'Other';
                    caseInsert.Subject = 'License creation or updation failed in Entitlement Hub for license : ' + liccId;
                    caseInsert.Description = 'An error occurred in License record. Error message: ' + licenseError;
                    caseInsert.OwnerId = UserInfo.getUserId();
                    licIdToCaseInsertMap.put( liccId, caseInsert );
                    licIdToCaseMap.put( liccId, caseInsert );
                }
            }
        }

        if ( !licIdToCaseInsertMap.isEmpty() ) {
            try {
                insert licIdToCaseInsertMap.values();
            } catch ( Exception ex ) {
                System.debug('Exception =====>' + ex.getMessage());
            }
        }
        
        return licIdToCaseMap;
    }
    
    public static void createExceptionLog ( String licJson, Map<Id, Case> licnseIdToCaseMap, String licError ) {
        List<Exception_Log__c> exceptionLogList = new List<Exception_Log__c>();

        try {
            if ( !licnseIdToCaseMap.isEmpty() ) {
                for ( Id licId : licnseIdToCaseMap.keySet() ) {
                    Exception_Log__c exceptionLogInsert = new Exception_Log__c();
                    exceptionLogInsert.ownerId = UserInfo.getUserId();
                    exceptionLogInsert.Object_ID__c = licId;
                    exceptionLogInsert.Object_Type__c = 'License';
                    exceptionLogInsert.Error_Type__c = 'Outbound';
                    exceptionLogInsert.Error_message__c = licError;
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
    
    /* post to sns*/
    //this method has implemented for ticket LMS-329
    public static HttpResponse postNotificationsToSNS( String message ) {
        TF_AwsRestWrapper tFAwsRestWrapper = new TF_AwsRestWrapper();
        try{
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            String keyAccessId = (String) orgSpecificProps.get('AWS_SNS_License_Access_Key_Id__c');
            String secretAccessKey = (String) orgSpecificProps.get('AWS_SNS_License_Secret_Access_key__c');
            String topicArn = (String) orgSpecificProps.get('AWS_SNS_License_TopicArn__c');
            //String regionName = (String) orgSpecificProps.get('AWS_Region_Name__c');
            //String hostUrl = (String) orgSpecificProps.get('AWS_SNS_Host_Url__c');
            String regionName = (String) orgSpecificProps.get('AWS_SNS_License_Region_Name__c');
            String hostUrl = (String) orgSpecificProps.get('AWS_SNS_License_Host_Url__c');
            
            if( String.isNotBlank(regionName) && String.isNotBlank(keyAccessId) && String.isNotBlank(secretAccessKey) && String.isNotBlank(hostUrl) && String.isNotBlank(topicArn) && String.isNotBlank(message)){
                HttpResponse response = tFAwsRestWrapper.postToSNS(message, 'application/xml', regionName, keyAccessId, secretAccessKey, hostUrl, topicArn);
                return response;
            }
            else {
                throw new SFDCCustomException('One or more org specific property for AWS is blank');
            }
        } catch ( Exception e ) {
            System.debug('Error in processing method postNotificationsToSNS, Error Message:'+e.getMessage());
        }
        return null;
    }
}