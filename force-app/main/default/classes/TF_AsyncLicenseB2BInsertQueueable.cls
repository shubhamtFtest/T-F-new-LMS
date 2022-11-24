/***********************************************************************************
    //Created by Vikas Varshney for POF project
    //This class is being used to retry SQS Framework (TF_EntitlementRetryFramework)
    //Modified by Vikas for LMS-196 on dated 22 Aug, 2019
************************************************************************************/

public class TF_AsyncLicenseB2BInsertQueueable implements Queueable, Database.AllowsCallouts {
    public Map<Id, License__c> licenseIdToLicensMap = new Map<Id, License__c>();
    public Map<Id, Exception_Log__c> licenseInsrtB2BCheckMap = new Map<Id, Exception_Log__c>();
    public Map<Id, Exception_Log__c> licenseInsrtConsortiumCheckMap = new Map<Id, Exception_Log__c>();
    public Map<Id, Exception_Log__c> licenseMemberInsertCheckMap = new Map<Id, Exception_Log__c>();
    public Map<Id, Exception_Log__c> licenseUpdateCheckMap = new Map<Id, Exception_Log__c>();
    public Map<Id, Exception_Log__c> entitlementInboundMap = new Map<Id, Exception_Log__c>();
    public Map<Id, Exception_Log__c> entitlementInboundUpdateMap = new Map<Id, Exception_Log__c>();
    public Map<Exception_Log__c, Id> licenseMemberUpdateCheckMap = new Map<Exception_Log__c, Id>();
    
    public TF_AsyncLicenseB2BInsertQueueable ( Map<Id, License__c> licensIdToLicnseMap, Map<Id, Exception_Log__c> licnsInsertB2BCheckMap, Map<Id, Exception_Log__c> licensInsrtConsortiumCheckMap, Map<Id, Exception_Log__c> licensMemberInsertCheckMap, Map<Id, Exception_Log__c> licensUpdateCheckMap, Map<Id, Exception_Log__c> entitlmentInboundMap, Map<Exception_Log__c, Id> licensMemberUpdateCheckMap, Map<Id, Exception_Log__c> entitlmentInboundUpdateMap ) {
        licenseIdToLicensMap = licensIdToLicnseMap;
        licenseInsrtB2BCheckMap = licnsInsertB2BCheckMap;
        licenseInsrtConsortiumCheckMap = licensInsrtConsortiumCheckMap;
        licenseMemberInsertCheckMap = licensMemberInsertCheckMap;
        licenseUpdateCheckMap = licensUpdateCheckMap;
        entitlementInboundMap = entitlmentInboundMap;
        entitlementInboundUpdateMap = entitlmentInboundUpdateMap;
        licenseMemberUpdateCheckMap = licensMemberUpdateCheckMap;
    }
        
    public void execute ( QueueableContext context ) {
        try {
            if ( !licenseInsrtB2BCheckMap.isEmpty() ) {
                List<License__c> licensList = new List<License__c>();
                String b2Bjson = '';
                Set<Id> licensIdSet = new Set<Id>();
                for ( Id b2BId : licenseInsrtB2BCheckMap.keySet() ) {
                    if ( licenseIdToLicensMap.containsKey( b2BId ) )
                        licensList.add( licenseIdToLicensMap.get( b2BId ) );
                }
                if ( !licensList.isEmpty() && licensList.size() <= 25 ) {
                    for ( License__c lic : licensList ) {
                        List<License__c> singleLicenseList = new List<License__c>();
                        singleLicenseList.add( lic );
                        b2Bjson = TF_EntitlementRetryFramework.licenseInsertJson( singleLicenseList );
                        licensIdSet.add( lic.id );
                        if ( String.isNotBlank( b2Bjson ) && !licensIdSet.isEmpty() ) {
                            TF_AsyncSQSJob.sqsQueue( b2Bjson, licensIdSet, true, false, false );
                        }
                        singleLicenseList.clear();
                        b2Bjson = '';
                        licensIdSet.clear();
                    }
                }
            }
            if ( !licenseInsrtConsortiumCheckMap.isEmpty() || !licenseMemberInsertCheckMap.isEmpty() || !licenseUpdateCheckMap.isEmpty() || !entitlementInboundMap.isEmpty() || !licenseMemberUpdateCheckMap.isEmpty() || !entitlementInboundUpdateMap.isEmpty() ) {
                if ( !Test.isRunningTest() ) {
                Id licenseConsortiumInsertJobId = System.enqueueJob( new TF_AsyncLicenseConsortiumInsertQueueable( licenseIdToLicensMap, licenseInsrtConsortiumCheckMap, licenseMemberInsertCheckMap, licenseUpdateCheckMap, entitlementInboundMap, licenseMemberUpdateCheckMap, entitlementInboundUpdateMap ) );
                }
            }
        } catch ( Exception e ) {
            if ( !licenseInsrtConsortiumCheckMap.isEmpty() || !licenseMemberInsertCheckMap.isEmpty() || !licenseUpdateCheckMap.isEmpty() || !entitlementInboundMap.isEmpty() || !licenseMemberUpdateCheckMap.isEmpty() || !entitlementInboundUpdateMap.isEmpty() ) {
                if ( !Test.isRunningTest() ) {
                Id licenseConsortiumInsertJobId = System.enqueueJob( new TF_AsyncLicenseConsortiumInsertQueueable( licenseIdToLicensMap, licenseInsrtConsortiumCheckMap, licenseMemberInsertCheckMap, licenseUpdateCheckMap, entitlementInboundMap, licenseMemberUpdateCheckMap, entitlementInboundUpdateMap ) );
                }
            }
        }
    }
}