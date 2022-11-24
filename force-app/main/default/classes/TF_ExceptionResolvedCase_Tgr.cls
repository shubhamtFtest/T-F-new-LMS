/***********************************************************************************
    //Created by Vikas Varshney for POF-543 on dated 16-11-2018
    //This class is being used to retry SQS Framework (TF_EntitlementRetryFramework)
    //This trigger is only for single case closure
    //Modified by Vikas Varshney for POF-542 on dated 05 Dec, 2018
    //Modified by Vikas Varshney for POF-817 on dated 30 Jan, 2019
    //Modified by Vikas Varshney for LMS-196 on dated 22 Aug, 2019
    //Modified by Vikas Varshney for LMS-424 on dated 22nd Dec, 2019
    //Modified by Vikas Varshney for UBX-1175 on dated 11th June, 2020
************************************************************************************/

public with sharing class TF_ExceptionResolvedCase_Tgr implements TriggerInterface_Case.Runnable {
    
    public void run( TriggerInterface_Case.Trig trig ) {
        Set<Id> caseIdSet = new Set<Id>();
        List<Case> caseList = new List<Case>();
        List<Exception_Log__c> licenseExceptionsList = new List<Exception_Log__c>();
        List<Exception_Log__c> oppExceptionsList = new List<Exception_Log__c>();
        Map<Id, Case> licenseIdOROppIdToCaseMap = new Map<Id, Case>();
        Map<Id, Case> addErrorcaseIdToCaseMap = new Map<Id, Case>();
        List<Case> hasPartCaseList = new List<Case>();
        List<Exception_Log__c> hasPartOutboundExceptionsList = new List<Exception_Log__c>();
        List<Exception_Log__c> hasPartInboundExceptionsList = new List<Exception_Log__c>();
        Case hasParRreopenOutboundCase = new Case();
        Case hasParRreopenInboundCase = new Case();
        
        //Iterating case list to get case Id set
        if ( !trig.newList.isEmpty() && trig.isAfter && trig.isUpdate) {
            for ( Case casee : trig.newList ) {
                addErrorcaseIdToCaseMap.put(casee.id, casee);
                //if ( ( ('License and Entitlement'.equalsIgnoreCase( casee.Application__c ) ) || ('Opportunity To OrderHub Integration'.equalsIgnoreCase( casee.Application__c ) ) ) && trig.oldMap.get( casee.id ).Status != 'Closed' && trig.newMap.get( casee.id ).Status == 'Closed' && (trig.newMap.get( casee.id ).Subject.containsIgnoreCase('License creation or updation failed in Entitlement Hub for license')) ) {
                if ( ( ('License and Entitlement'.equalsIgnoreCase( casee.Application__c ) ) || ('Opportunity To OrderHub Integration'.equalsIgnoreCase( casee.Application__c ) ) ) && !trig.oldMap.get( casee.id ).Status.containsIgnoreCase('Closed') && trig.newMap.get( casee.id ).Status == 'Closed - Completed' && (trig.newMap.get( casee.id ).Subject.containsIgnoreCase('License creation or updation failed in Entitlement Hub for license')) ) {
                    caseIdSet.add( casee.id );
                }
            }
        }

        if ( !caseIdSet.isEmpty() ) {
            caseList = [ SELECT id, RecordTypeId, Application__c, Status, Type, ( SELECT id, name, Case__c, Case_Number__c, Error_message__c, Error_Type__c, Object_ID__c, Object_Type__c, Request_JSON__c, Resolution_Status__c, Type_of_Action__c FROM Exception_Logs__r Order BY Type_of_Action__c ) FROM Case WHERE id IN:caseIdSet LIMIT 10000 ];
        }
        
        Set<Case> hasPartCaseSet = new Set<Case>();
        String oppPrefix = '';
        String licensePrefix = '';
        licensePrefix = License__c.SObjectType.getDescribe().getKeyPrefix();
        oppPrefix = Opportunity.SObjectType.getDescribe().getKeyPrefix();
        if ( !caseList.isEmpty() ) {
            for ( Case casse : caseList ) {
                if ( !casse.Exception_Logs__r.isEmpty() ) {
                    for ( Exception_Log__c excepton : casse.Exception_Logs__r ) {
                        if ( 'License'.equalsIgnoreCase( excepton.Object_Type__c ) && !excepton.Request_JSON__c.containsIgnoreCase('HasPart') && !excepton.Request_JSON__c.containsIgnoreCase('"body"') ) {
                            licenseExceptionsList.add( excepton );
                        } else if ( ( 'License'.equalsIgnoreCase( excepton.Object_Type__c ) || 'Platform Event'.equalsIgnoreCase( excepton.Object_Type__c ) ) && ( excepton.Request_JSON__c.containsIgnoreCase('HasPart') || excepton.Request_JSON__c.containsIgnoreCase('"body"') ) ) {
                            hasPartCaseSet.add( casse );
                        }
                        //if ( 'Opportunity'.equalsIgnoreCase( excepton.Object_Type__c ) )
                            //oppExceptionsList.add( excepton );
                        if ( String.isNotBlank(excepton.Object_ID__c) && addErrorcaseIdToCaseMap.containsKey( casse.id ) && ( excepton.Object_ID__c.contains(licensePrefix) || excepton.Object_ID__c.contains(oppPrefix) ) ) {
                            licenseIdOROppIdToCaseMap.put( excepton.Object_ID__c, addErrorcaseIdToCaseMap.get( casse.id ) );
                        }
                    }
                }
            }
        }
        
        if ( !hasPartCaseSet.isEmpty() ) {
            hasPartCaseList.addAll( hasPartCaseSet );
        }
        if ( !hasPartCaseList.isEmpty() ) {
            for ( Case hasPartCase : hasPartCaseList ) {
                if ( !hasPartCase.Exception_Logs__r.isEmpty() && ( 'Outbound Failure'.equalsIgnoreCase(hasPartCase.Type) || 'Inbound Failure'.equalsIgnoreCase(hasPartCase.Type) ) ) {
                    for ( Exception_Log__c excepton : hasPartCase.Exception_Logs__r ) {
                        if ( 'Outbound'.equalsIgnoreCase(excepton.Error_Type__c) && ( excepton.Request_JSON__c.containsIgnoreCase('HasPart') || excepton.Request_JSON__c.containsIgnoreCase('"body"') ) ) {
                            hasPartOutboundExceptionsList.add( excepton );
                        } else if ( 'Inbound'.equalsIgnoreCase(excepton.Error_Type__c) && excepton.Request_JSON__c.containsIgnoreCase('HasPart') ) {
                            //hasPartInboundExceptionsList.add( excepton );
                            hasPartOutboundExceptionsList.add( excepton );
                        }
                    }
                }
            }
        }
        
        //getting case to be re-opened
        if ( !addErrorcaseIdToCaseMap.isEmpty() ) {
            for ( Case outboundCase : addErrorcaseIdToCaseMap.values() ) { //loop for checking hasPart outbound case
                if ( outboundCase.Subject.containsIgnoreCase('HasPart updation failed') && 'Outbound Failure'.equalsIgnoreCase(outboundCase.Type) ) {
                    hasParRreopenOutboundCase = outboundCase;
                    break;
                }
            }
            for ( Case inboundCase : addErrorcaseIdToCaseMap.values() ) { //loop for checking hasPart inbound case
                if ( inboundCase.Subject.containsIgnoreCase('HasPart updation failed') && 'Inbound Failure'.equalsIgnoreCase(inboundCase.Type) ) {
                    hasParRreopenInboundCase = inboundCase;
                    break;
                }
            }
        }
        
        //passing exception logs to the method for License
        try {
            if ( !licenseExceptionsList.isEmpty() ) {
                TF_EntitlementRetryFramework.licenseAndEntitlementHandler( licenseExceptionsList, 'License', licenseIdOROppIdToCaseMap );
            }
        } catch ( Exception ex ) {
            System.debug('Exception =====>' + ex.getMessage());
        }
        /*
        //passing exception logs to the method for Opportunity
        if ( !oppExceptionsList.isEmpty() ) {
            TF_EntitlementRetryFramework.licenseAndEntitlementHandler( oppExceptionsList, 'Opportunity', licenseIdOROppIdToCaseMap );
        }*/
        //passing exception logs to the method for hasPart
        try {
            if ( !hasPartOutboundExceptionsList.isEmpty() ) { //retry logic for hasPart outbound case
                TF_EntitlementRetryFramework.hasPartUpdateRetry( hasPartOutboundExceptionsList, 'hasPart Outbound', hasParRreopenOutboundCase );
            }
            /*if ( !hasPartInboundExceptionsList.isEmpty() ) { //retry logic for hasPart inbound case
                TF_EntitlementRetryFramework.hasPartUpdateRetry( hasPartInboundExceptionsList, 'hasPart Inbound', hasParRreopenInboundCase );
            }*/
        } catch ( Exception ex ) {
            System.debug('Exception =====>' + ex.getMessage());
        }
    }
}