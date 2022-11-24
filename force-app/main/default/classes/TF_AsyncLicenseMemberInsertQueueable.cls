/***********************************************************************************
    //Created by Vikas Varshney for POF project
    //This class is being used to retry SQS Framework (TF_EntitlementRetryFramework)
    //Modified by Vikas for LMS-196 on dated 22 Aug, 2019
************************************************************************************/

public class TF_AsyncLicenseMemberInsertQueueable implements Queueable, Database.AllowsCallouts {
    public Map<Id, License__c> licenseIdToLicensMap = new Map<Id, License__c>();
    public Map<Id, Exception_Log__c> licenseMemberInsertCheckMap = new Map<Id, Exception_Log__c>();
    public Map<Id, Exception_Log__c> licenseUpdateCheckMap = new Map<Id, Exception_Log__c>();
    public Map<Id, Exception_Log__c> entitlementInboundMap = new Map<Id, Exception_Log__c>();
    public Map<Id, Exception_Log__c> entitlementInboundUpdateMap = new Map<Id, Exception_Log__c>();
    public Map<Exception_Log__c, Id> licenseMemberUpdateCheckMap = new Map<Exception_Log__c, Id>();
    
    public TF_AsyncLicenseMemberInsertQueueable ( Map<Id, License__c> licensIdToLicensMap, Map<Id, Exception_Log__c> licensMemberInsertCheckMap, Map<Id, Exception_Log__c> licensUpdateCheckMap, Map<Id, Exception_Log__c> entitlmentInboundMap, Map<Exception_Log__c, Id> licensMemberUpdateCheckMap, Map<Id, Exception_Log__c> entitlmentInboundUpdateMap ) {
        licenseIdToLicensMap = licensIdToLicensMap;
        licenseMemberInsertCheckMap = licensMemberInsertCheckMap;
        licenseUpdateCheckMap = licensUpdateCheckMap;
        entitlementInboundMap = entitlmentInboundMap;
        entitlementInboundUpdateMap = entitlmentInboundUpdateMap;
        licenseMemberUpdateCheckMap = licensMemberUpdateCheckMap;
    }
    
    public void execute ( QueueableContext context ) {
        try {
            if ( !licenseMemberInsertCheckMap.isEmpty() ) {
                List<License__c> licensList = new List<License__c>();
                String licenseMembInsrtJson = '';
                Set<Id> licensIdSet = new Set<Id>();
                for ( Id memberId : licenseMemberInsertCheckMap.keySet() ) {
                    if ( licenseIdToLicensMap.containsKey( memberId ) )
                        licensList.add( licenseIdToLicensMap.get( memberId ) );
                }
                if ( !licensList.isEmpty() && licensList.size() <= 25 ) {
                    for ( License__c lic : licensList ) {
                        List<License__c> singleLicenseList = new List<License__c>();
                        singleLicenseList.add( lic );
                        licenseMembInsrtJson = TF_EntitlementRetryFramework.licenseMemberInsertJson( singleLicenseList );
                        licensIdSet.add( lic.id );
                        if ( String.isNotBlank( licenseMembInsrtJson ) && !licensIdSet.isEmpty() ) {
                            TF_AsyncSQSJob.sqsQueue( licenseMembInsrtJson, licensIdSet, true, false, false );
                        }
                        singleLicenseList.clear();
                        licenseMembInsrtJson = '';
                        licensIdSet.clear();
                    }
                }
            }
            if ( !licenseMemberInsertCheckMap.isEmpty() || !licenseUpdateCheckMap.isEmpty() || !entitlementInboundMap.isEmpty() || !licenseMemberUpdateCheckMap.isEmpty() || !entitlementInboundUpdateMap.isEmpty() ) {
                if ( !Test.isRunningTest() ) {
                    Id licenseUpdateOrEntitlementInboundJobId = System.enqueueJob( new TF_AsyncLicenseUpdateQueueable( licenseIdToLicensMap, licenseMemberInsertCheckMap, licenseUpdateCheckMap, entitlementInboundMap, licenseMemberUpdateCheckMap, entitlementInboundUpdateMap ) );
                }
            }
        } catch ( Exception e ) {
            if ( !licenseMemberInsertCheckMap.isEmpty() || !licenseUpdateCheckMap.isEmpty() || !entitlementInboundMap.isEmpty() || !licenseMemberUpdateCheckMap.isEmpty() || !entitlementInboundUpdateMap.isEmpty() ) {
                if ( !Test.isRunningTest() ) {
                    Id licenseUpdateOrEntitlementInboundJobId = System.enqueueJob( new TF_AsyncLicenseUpdateQueueable( licenseIdToLicensMap, licenseMemberInsertCheckMap, licenseUpdateCheckMap, entitlementInboundMap, licenseMemberUpdateCheckMap, entitlementInboundUpdateMap ) );
                }
            }
        }
    }
}