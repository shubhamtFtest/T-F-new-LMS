/***********************************************************************************
    //Created by Vikas Varshney for POF project
    //This class is being used to retry SQS Framework (TF_EntitlementRetryFramework)
    //Modified by Vikas for LMS-196 on dated 22 Aug, 2019
************************************************************************************/

public class TF_AsyncLicenseMemberUpdateQueueable implements Queueable, Database.AllowsCallouts {
    public Map<Id, License__c> licenseIdToLicensMap = new Map<Id, License__c>();
    public Map<Exception_Log__c, Id> licenseMemberUpdateCheckMap = new Map<Exception_Log__c, Id>();
    
    public TF_AsyncLicenseMemberUpdateQueueable ( Map<Id, License__c> licensIdToLicensMap, Map<Exception_Log__c, Id> licensMemberUpdateCheckMap ) {
        licenseIdToLicensMap = licensIdToLicensMap;
        licenseMemberUpdateCheckMap = licensMemberUpdateCheckMap;
    }
    
    public void execute ( QueueableContext context ) {
        try {
            if ( !licenseMemberUpdateCheckMap.isEmpty() && licenseMemberUpdateCheckMap.size() <= 25 ) {
                for ( Exception_Log__c excepLog : licenseMemberUpdateCheckMap.keySet() ) {
                    String licenseMembUpdatJson = '';
                    Set<Id> licensIdSet = new Set<Id>();
                    List<Exception_Log__c> excpList = new List<Exception_Log__c>();
                    excpList.add( excepLog );
                    licenseMembUpdatJson = TF_EntitlementRetryFramework.licenseMemberUpdateJson( excpList, licenseIdToLicensMap );
                    licensIdSet.add( excepLog.Object_ID__c );
                    if ( String.isNotBlank( licenseMembUpdatJson ) && !licensIdSet.isEmpty() ) {
                        TF_AsyncSQSJob.sqsQueue( licenseMembUpdatJson, licensIdSet, false, true, false );
                    }
                    excpList.clear();
                    licenseMembUpdatJson = '';
                    licensIdSet.clear();
                }
            }
        } catch ( Exception e ) {
            System.debug('TF_AsyncLicenseMemberUpdateQueueable Exception =========>'+ e.getMessage());
        }
    }
}