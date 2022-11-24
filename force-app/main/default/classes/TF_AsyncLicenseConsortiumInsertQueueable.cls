/***********************************************************************************
    //Created by Vikas Varshney for POF project
    //This class is being used to retry SQS Framework (TF_EntitlementRetryFramework)
    //Modified by Vikas for LMS-196 on dated 22 Aug, 2019
************************************************************************************/

public class TF_AsyncLicenseConsortiumInsertQueueable implements Queueable, Database.AllowsCallouts {
    public Map<Id, License__c> licenseIdToLicensMap = new Map<Id, License__c>();
    public Map<Id, Exception_Log__c> licenseInsrtConsortiumCheckMap = new Map<Id, Exception_Log__c>();
    public Map<Id, Exception_Log__c> licenseMemberInsertCheckMap = new Map<Id, Exception_Log__c>();
    public Map<Id, Exception_Log__c> licenseUpdateCheckMap = new Map<Id, Exception_Log__c>();
    public Map<Id, Exception_Log__c> entitlementInboundMap = new Map<Id, Exception_Log__c>();
    public Map<Id, Exception_Log__c> entitlementInboundUpdateMap = new Map<Id, Exception_Log__c>();
    public Map<Exception_Log__c, Id> licenseMemberUpdateCheckMap = new Map<Exception_Log__c, Id>();
    
    public TF_AsyncLicenseConsortiumInsertQueueable ( Map<Id, License__c> licensIdToLicensMap, Map<Id, Exception_Log__c> licensInsrtConsortiumCheckMap, Map<Id, Exception_Log__c> licensMemberInsertCheckMap, Map<Id, Exception_Log__c> licensUpdateCheckMap, Map<Id, Exception_Log__c> entitlmentInboundMap, Map<Exception_Log__c, Id> licensMemberUpdateCheckMap, Map<Id, Exception_Log__c> entitlmentInboundUpdateMap ) {
        licenseIdToLicensMap = licensIdToLicensMap;
        licenseInsrtConsortiumCheckMap = licensInsrtConsortiumCheckMap;
        licenseMemberInsertCheckMap = licensMemberInsertCheckMap;
        licenseUpdateCheckMap = licensUpdateCheckMap;
        entitlementInboundMap = entitlmentInboundMap;
        entitlementInboundUpdateMap = entitlmentInboundUpdateMap;
        licenseMemberUpdateCheckMap = licensMemberUpdateCheckMap;
    }
    
    public void execute ( QueueableContext context ) {
        try {
            if ( !licenseInsrtConsortiumCheckMap.isEmpty() ) {
                List<License__c> licensList = new List<License__c>();
                String consortiumJson = '';
                Set<Id> licensIdSet = new Set<Id>();
                for ( Id consortiumId : licenseInsrtConsortiumCheckMap.keySet() ) {
                    if ( licenseIdToLicensMap.containsKey( consortiumId ) )
                        licensList.add( licenseIdToLicensMap.get( consortiumId ) );
                }
                if ( !licensList.isEmpty() && licensList.size() <= 25 ) {
                    for ( License__c lic : licensList ) {
                        List<License__c> singleLicenseList = new List<License__c>();
                        singleLicenseList.add( lic );
                        consortiumJson = TF_EntitlementRetryFramework.licenseInsertConsortiumJson( singleLicenseList );
                        licensIdSet.add( lic.id );
                        if ( String.isNotBlank( consortiumJson ) && !licensIdSet.isEmpty() ) {
                            TF_AsyncSQSJob.sqsQueue( consortiumJson, licensIdSet, true, false, false );
                        }
                        singleLicenseList.clear();
                        consortiumJson = '';
                        licensIdSet.clear();
                    }
                }
            }
            if ( !licenseMemberInsertCheckMap.isEmpty() || !licenseUpdateCheckMap.isEmpty() || !entitlementInboundMap.isEmpty() || !licenseMemberUpdateCheckMap.isEmpty() || !entitlementInboundUpdateMap.isEmpty() ) {
                if ( !Test.isRunningTest() ) {
                    Id licenseMemberInsertJobId = System.enqueueJob( new TF_AsyncLicenseMemberInsertQueueable( licenseIdToLicensMap, licenseMemberInsertCheckMap, licenseUpdateCheckMap, entitlementInboundMap, licenseMemberUpdateCheckMap, entitlementInboundUpdateMap ) );
                }
            }
        } catch ( Exception e ) {
            if ( !licenseMemberInsertCheckMap.isEmpty() || !licenseUpdateCheckMap.isEmpty() || !entitlementInboundMap.isEmpty() || !licenseMemberUpdateCheckMap.isEmpty() || !entitlementInboundUpdateMap.isEmpty() ) {
                if ( !Test.isRunningTest() ) {
                    Id licenseMemberInsertJobId = System.enqueueJob( new TF_AsyncLicenseMemberInsertQueueable( licenseIdToLicensMap, licenseMemberInsertCheckMap, licenseUpdateCheckMap, entitlementInboundMap, licenseMemberUpdateCheckMap, entitlementInboundUpdateMap ) );
                }
            }
        }
    }
}