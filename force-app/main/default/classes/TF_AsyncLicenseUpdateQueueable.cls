/***********************************************************************************
    //Created by Vikas Varshney for POF project
    //This class is being used to retry SQS Framework (TF_EntitlementRetryFramework)
    //Modified by Vikas for LMS-196 on dated 22 Aug, 2019
************************************************************************************/

public class TF_AsyncLicenseUpdateQueueable implements Queueable, Database.AllowsCallouts {
    public Map<Id, License__c> licenseIdToLicensMap = new Map<Id, License__c>();
    public Map<Id, Exception_Log__c> licenseMemberInsertCheckMap = new Map<Id, Exception_Log__c>();
    public Map<Id, Exception_Log__c> licenseUpdateCheckMap = new Map<Id, Exception_Log__c>();
    public Map<Id, Exception_Log__c> entitlementInboundMap = new Map<Id, Exception_Log__c>();
    public Map<Id, Exception_Log__c> entitlementInboundUpdateMap = new Map<Id, Exception_Log__c>();
    public Map<Exception_Log__c, Id> licenseMemberUpdateCheckMap = new Map<Exception_Log__c, Id>();

    public TF_AsyncLicenseUpdateQueueable ( Map<Id, License__c> licensIdToLicensMap, Map<Id, Exception_Log__c> licensMemberInsertCheckMap, Map<Id, Exception_Log__c> licensUpdateCheckMap, Map<Id, Exception_Log__c> entitlmentInboundMap, Map<Exception_Log__c, Id> licensMemberUpdateCheckMap, Map<Id, Exception_Log__c> entitlmentInboundUpdateMap ) {
        licenseIdToLicensMap = licensIdToLicensMap;
        licenseMemberInsertCheckMap = licensMemberInsertCheckMap;
        licenseUpdateCheckMap = licensUpdateCheckMap;
        entitlementInboundMap = entitlmentInboundMap;
        entitlementInboundUpdateMap = entitlmentInboundUpdateMap;
        licenseMemberUpdateCheckMap = licensMemberUpdateCheckMap;
    }
    
    public void execute ( QueueableContext context ) {
        try {
            if ( !licenseUpdateCheckMap.isEmpty() || !entitlementInboundMap.isEmpty() || !entitlementInboundUpdateMap.isEmpty() ) {
                List<License__c> licensList = new List<License__c>();
                List<License__c> inboundAddList = new List<License__c>();
                List<License__c> inboundAddUpdateList = new List<License__c>();
                String licenseUpdatJson = '';
                String inboundAddJson = '';
                //String inboundUpdateJson = '';
                Set<Id> licensIdSet = new Set<Id>();
                Set<Id> inboundAddIdSet = new Set<Id>();
                Set<Id> inboundUpdateIdSet = new Set<Id>();
                if ( !licenseUpdateCheckMap.isEmpty() ) {
                    for ( Id licenseId : licenseUpdateCheckMap.keySet() ) {
                        if ( !licenseMemberInsertCheckMap.containsKey( licenseId ) ) {
                            if ( licenseIdToLicensMap.containsKey( licenseId ) )
                                licensList.add( licenseIdToLicensMap.get( licenseId ) );
                        }
                    }
                }
                if ( !licensList.isEmpty() && licensList.size() <= 25 ) {
                    for ( License__c lic : licensList ) {
                        List<License__c> singleLicensList = new List<License__c>();
                        singleLicensList.add( lic );
                        licenseUpdatJson = TF_EntitlementRetryFramework.licenseUpdateJson( singleLicensList );
                        licensIdSet.add( lic.id );
                        if ( String.isNotBlank( licenseUpdatJson ) && !licensIdSet.isEmpty() ) {
                            TF_AsyncSQSJob.sqsQueue( licenseUpdatJson, licensIdSet, false, true, false );
                        }
                        singleLicensList.clear();
                        licenseUpdatJson = '';
                        licensIdSet.clear();
                    }
                }
                
                if ( !entitlementInboundMap.isEmpty() ) { //inbound case Insert case
                    for ( Id inboundId : entitlementInboundMap.keySet() ) {
                        if ( !licenseMemberInsertCheckMap.containsKey( inboundId ) ) {
                            if ( licenseIdToLicensMap.containsKey( inboundId ) )
                                inboundAddList.add( licenseIdToLicensMap.get( inboundId ) );
                        }
                    }
                }
                if ( !inboundAddList.isEmpty() && inboundAddList.size() <= 5 ) { //this is to create entitlement inbound add json
                    for ( License__c lic : inboundAddList ) {
                        List<License__c> singleLicenseList = new List<License__c>();
                        singleLicenseList.add( lic );
                        inboundAddJson = TF_EntitlementRetryFramework.licenseInsertJson( singleLicenseList );
                        inboundAddIdSet.add( lic.id );
                        if ( String.isNotBlank( inboundAddJson ) && !inboundAddIdSet.isEmpty() ) {
                            TF_AsyncSQSJob.sqsQueue( inboundAddJson, inboundAddIdSet, true, false, false );
                        }
                        singleLicenseList.clear();
                        inboundAddJson = '';
                        inboundAddIdSet.clear();
                    }
                }
                
                if ( !entitlementInboundUpdateMap.isEmpty() ) { //inbound case update case
                    for ( Id inboundUpdateId : entitlementInboundUpdateMap.keySet() ) {
                        if ( !licenseMemberInsertCheckMap.containsKey( inboundUpdateId ) ) {
                            if ( licenseIdToLicensMap.containsKey( inboundUpdateId ) )
                                inboundAddUpdateList.add( licenseIdToLicensMap.get( inboundUpdateId ) );
                        }
                    }
                }
                if ( !inboundAddUpdateList.isEmpty() && inboundAddUpdateList.size() <= 5 ) { //this is to create entitlement inbound update json
                    //inboundUpdateJson = TF_EntitlementRetryFramework.licenseUpdateJson( inboundAddUpdateList );
                    for ( License__c lic : inboundAddUpdateList ) {
                        inboundUpdateIdSet.add( lic.id );
                    }
                }
                //if ( String.isNotBlank( inboundUpdateJson ) && !inboundUpdateIdSet.isEmpty() ) {
                    //TF_AsyncSQSJob.callingSQSQueue( inboundUpdateJson, inboundUpdateIdSet, false, true, false );
                if ( !inboundUpdateIdSet.isEmpty() ) {
                    TF_CreateLicenseJSON_Tgr.bulkLicenseSQSFutureCallout( inboundUpdateIdSet, '' );
                }
                
            }
            if ( !licenseMemberUpdateCheckMap.isEmpty() ) {
                if ( !Test.isRunningTest() ) {
                    Id licenseMemberUpdateJobId = System.enqueueJob( new TF_AsyncLicenseMemberUpdateQueueable( licenseIdToLicensMap, licenseMemberUpdateCheckMap ) );
                }
            }
        } catch ( Exception e ) {
            if ( !licenseMemberUpdateCheckMap.isEmpty() ) {
                if ( !Test.isRunningTest() ) {
                    Id licenseMemberUpdateJobId = System.enqueueJob( new TF_AsyncLicenseMemberUpdateQueueable( licenseIdToLicensMap, licenseMemberUpdateCheckMap ) );
                }
            }
        }
    }
}