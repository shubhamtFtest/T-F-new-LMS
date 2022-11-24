/***********************************************************************************
    // This class is to send dynamic license update request to Entitlement hub
       for every product hub Id matches with license product's hub Id
    // This class in being called in REST API "TF_LicenseAPIExposeService"
    // Test coverage "zTest_TF_HasPartUpdate_Cls"
    // Created by Vikas Varshney on dated 26 May, 2020 for UBX-920
    // Modified by Vikas Varshney on dated 25 Aug, 2020 for UBX-12715
    // Modified by Vikas Varshney on dated 25 Sep, 2020 for UBX-13873
***********************************************************************************/

public class TF_HasPartUpdate_Cls {
    
    public static void hasPartCallout ( String licenseType, Map<String, String> hubIdToHasPartJsonMap ) {
        
        List<License__c> licenseList = new List<License__c>();
        
        try {
            fetchHasPartLicenseList( licenseType, hubIdToHasPartJsonMap );
        } catch ( Exception ex ) {
            System.debug('***** Exception for Has Part Update *****' + ex.getMessage());
        }
    }
    
    public static void fetchHasPartLicenseList ( String licenseType, Map<String, String> hubIdToHasParrtJsonMap ) {
        Map<Id, License__c> licenseIdToLicenseMap = new Map<Id, License__c>();
        List<License__c> nonActiveLicenseList = new List<License__c>();
        List<License__c> returnedLicenseList = new List<License__c>();
        List<License__c> licenseList = new List<License__c>();
        Map<String, Set<License__c>> hubIdToLicenseSetMap = new Map<String, Set<License__c>>();
        Map<String, String> hubIdToJSONMap = new Map<String, String>();
        Set<String> licenseTypeSet = new Set<String>();
        TF_HasPartWrapper hasPartWrapperJson = new TF_HasPartWrapper();
        
        Set<String> excludeStatusSet = new Set<String>();
        excludeStatusSet.add('Expired');
        excludeStatusSet.add('Deactivated');
        excludeStatusSet.add('Inactive');
        excludeStatusSet.add('on Hold');
        
        if ( 'UPDATE_DYNAMIC_LICENSE'.equalsIgnoreCase(licenseType) ) {
            licenseTypeSet.add('Dynamic');
        } else if ( 'UPDATE_ALL_LICENSE'.equalsIgnoreCase(licenseType) ) {
            licenseTypeSet.add('Dynamic');
            licenseTypeSet.add('Static');
        } else {
            licenseTypeSet.add('Dynamic');
        }
        
        Date todaysDate = Date.newInstance(Date.today().year(), Date.today().month(), Date.today().day());
        
        if ( !hubIdToHasParrtJsonMap.isEmpty() ) {
            licenseList = [ SELECT id, name, License_Type__c, Product__c, Product__r.Hub_Id__c, Update_Type__c, Status__c, End_Date__c, customer__c, customer__r.customer_Id__c, Contact__c, Contact__r.party_Id__c, Access_Scope__c, Grant_Type__c, ( SELECT id, Account__c, Account__r.Customer_Id__c FROM License_Memebers__r ) FROM License__c WHERE Status__c NOT IN:excludeStatusSet AND Product__r.Hub_Id__c IN:hubIdToHasParrtJsonMap.keySet() AND Update_Type__c IN:licenseTypeSet AND ( End_Date__c = NULL OR End_Date__c > :todaysDate ) ];
        }
        
        Map<String,List<TF_HasPartWrapper.ChildPartyIds>> licIdToChildPartyIdsListMap = new Map<String,List<TF_HasPartWrapper.ChildPartyIds>>();
        if ( !licenseList.isEmpty() ) {
            for ( License__c lic : licenseList ) {
                if ( 'Active'.equalsIgnoreCase(lic.Status__c) && ( lic.End_Date__c > todaysDate || lic.End_Date__c == NULL ) ) {
                    licenseIdToLicenseMap.put( lic.id, lic );
                } else if ( ( !'Expired'.equalsIgnoreCase(lic.Status__c) ) && ( !'Deactivated'.equalsIgnoreCase(lic.Status__c) ) && ( !'Inactive'.equalsIgnoreCase(lic.Status__c) ) && ( lic.End_Date__c > todaysDate || lic.End_Date__c == NULL ) ) {
                    nonActiveLicenseList.add( lic );
                }
                
                if ( !lic.License_Memebers__r.isEmpty() ) { //UBX-12715
                    for ( License_Memeber__c licMember : lic.License_Memebers__r ) {
                        if ( !licIdToChildPartyIdsListMap.containsKey(lic.id) ) {
                            licIdToChildPartyIdsListMap.put(lic.id, new List<TF_HasPartWrapper.ChildPartyIds>());
                        }
                        TF_HasPartWrapper.ChildPartyIds childAccountPartyId = new TF_HasPartWrapper.ChildPartyIds();
                        if ( licMember.Account__c != NULL && licMember.Account__r.Customer_Id__c != NULL ) {
                            childAccountPartyId.partyID = licMember.Account__r.Customer_Id__c;
                        } else {
                            childAccountPartyId.partyID = '';
                        }
                        licIdToChildPartyIdsListMap.get(lic.id).add(childAccountPartyId);
                    }
                }
            }
        }
        
        if ( !licenseIdToLicenseMap.isEmpty() ) {
            for ( License__c activeLicense : licenseIdToLicenseMap.values() ) {
                if (  activeLicense.Product__c != NULL && String.isNotBlank(activeLicense.Product__r.Hub_Id__c) ) {
                    if ( !hubIdToLicenseSetMap.containsKey(activeLicense.Product__r.Hub_Id__c) ) {
                        hubIdToLicenseSetMap.put( activeLicense.Product__r.Hub_Id__c, new Set<License__c>() );
                    }
                    hubIdToLicenseSetMap.get(activeLicense.Product__r.Hub_Id__c).add( activeLicense );
                }
            }
        }
        
        if ( !hubIdToLicenseSetMap.isEmpty() ) {
            for ( String hubId : hubIdToLicenseSetMap.keySet() ) {
                if ( !hubIdToLicenseSetMap.get(hubId).isEmpty() ) {
                    List<TF_HasPartWrapper.licenseDetails> licenseWrapperList = new List<TF_HasPartWrapper.licenseDetails>();
                    for ( License__c lic : hubIdToLicenseSetMap.get(hubId) ) {
                        TF_HasPartWrapper.licenseDetails licenseWrapperRecord = new TF_HasPartWrapper.licenseDetails();
                        List<TF_HasPartWrapper.ChildPartyIds> childPartyBlankList = new List<TF_HasPartWrapper.ChildPartyIds>();
                        List<String> grantList = new List<String>();
                
                        if ( lic.Grant_Type__c != NULL ) {
                            if ( lic.Grant_Type__c.contains(';') )
                                grantList = lic.Grant_Type__c.split(';');
                            else
                                grantList.add( lic.Grant_Type__c );
                        }
                        
                        licenseWrapperRecord.licenseId = lic.id;
                        //licenseWrapperRecord.customerId = lic.customer__c != NULL ? String.valueOf( lic.customer__c ) : '';
                        //licenseWrapperRecord.contactId = lic.contact__c != NULL ? String.valueOf( lic.contact__c ) : '';
                        licenseWrapperRecord.partyId = ( ( lic.customer__c != NULL && String.isNotBlank(lic.customer__r.customer_Id__c) ? String.valueOf(lic.customer__r.customer_Id__c) : ( ( lic.contact__c != NULL && String.isNotBlank(lic.contact__r.party_Id__c) ) ? String.valueOf(lic.contact__r.party_Id__c) : '') ) );
                        licenseWrapperRecord.access_scope = String.isBlank(lic.Access_Scope__c) ? 'Global' : lic.Access_Scope__c;
                        licenseWrapperRecord.status = String.isNotBlank(lic.Status__c) ? lic.Status__c : '';
                        licenseWrapperRecord.licenseName = lic.name; //UBX-12715
                        licenseWrapperRecord.licenseType = lic.License_Type__c != NULL ? lic.License_Type__c : ''; //UBX-12715
                        if ( licIdToChildPartyIdsListMap.containsKey(lic.id) ) { //UBX-12715
                            licenseWrapperRecord.childParties = licIdToChildPartyIdsListMap.get(lic.id);
                        } else {
                            licenseWrapperRecord.childParties = childPartyBlankList;
                        }
                        licenseWrapperRecord.grantType = grantList;
                        licenseWrapperList.add(licenseWrapperRecord);
                    }
                    
                    if ( hubIdToHasParrtJsonMap.containsKey(hubId) ) {
                        hasPartWrapperJson = (TF_HasPartWrapper)System.JSON.deserialize( hubIdToHasParrtJsonMap.get(hubId), TF_HasPartWrapper.class);
                        hasPartWrapperJson.Body.licenses = licenseWrapperList;
                    }
                    hubIdToJSONMap.put( hubId, JSON.serialize(hasPartWrapperJson) );
                    licenseWrapperList.clear();
                }
            }
        }
        
        if ( !hubIdToJSONMap.isEmpty() ) {
            TF_License_Update_Event_Tgr_Cls.s3LicenseCalloutAndSNSNotify( hubIdToJSONMap );
        }
        
        if ( !nonActiveLicenseList.isEmpty() ) {
            logNonActiveLicenseError( nonActiveLicenseList, hubIdToHasParrtJsonMap );
        }
    }
    
    //this method is to log error about dyamic license update request failure for the existing non-active licenses
    public static void logNonActiveLicenseError ( List<License__c> nonActiveLicenseList, Map<String, String> hubIdToHasParrtJsonMap ) {
        Set<Id> nonActiveLicenseIdSet = new Set<Id>();
        Map<String, Set<License__c>> hubIdToNonActiveLicSetMap = new Map<String, Set<License__c>>();
        Map<Id, String> nonActiveLicIdToHubIdMap = new Map<Id, String>();
        Map<String, String> nonActiveHubIdToJsonMap = new Map<String, String>();
        TF_HasPartWrapper hasPartWrapperJson = new TF_HasPartWrapper();
        Map<String,List<TF_HasPartWrapper.ChildPartyIds>> licIdToChildPartyIdsListMap = new Map<String,List<TF_HasPartWrapper.ChildPartyIds>>();
        
        if ( !nonActiveLicenseList.isEmpty() ) {
            for ( License__c nonActivLicense : nonActiveLicenseList ) {
                if ( nonActivLicense.Product__c != NULL && String.isNotBlank(nonActivLicense.Product__r.Hub_Id__c) ) {
                    nonActiveLicenseIdSet.add( nonActivLicense.id );
                    nonActiveLicIdToHubIdMap.put( nonActivLicense.id, nonActivLicense.Product__r.Hub_Id__c );
                    if ( !hubIdToNonActiveLicSetMap.containsKey(nonActivLicense.Product__r.Hub_Id__c) ) {
                        hubIdToNonActiveLicSetMap.put( nonActivLicense.Product__r.Hub_Id__c, new Set<License__c>() );
                    }
                    hubIdToNonActiveLicSetMap.get( nonActivLicense.Product__r.Hub_Id__c ).add( nonActivLicense );
                }
                
                if ( !nonActivLicense.License_Memebers__r.isEmpty() ) { //UBX-12715
                    for ( License_Memeber__c licMember : nonActivLicense.License_Memebers__r ) {
                        if ( !licIdToChildPartyIdsListMap.containsKey(nonActivLicense.id) ) {
                            licIdToChildPartyIdsListMap.put(nonActivLicense.id, new List<TF_HasPartWrapper.ChildPartyIds>());
                        }
                        TF_HasPartWrapper.ChildPartyIds childAccountPartyId = new TF_HasPartWrapper.ChildPartyIds();
                        if ( licMember.Account__c != NULL && licMember.Account__r.Customer_Id__c != NULL ) {
                            childAccountPartyId.partyID = licMember.Account__r.Customer_Id__c;
                        } else {
                            childAccountPartyId.partyID = '';
                        }
                        licIdToChildPartyIdsListMap.get(nonActivLicense.id).add(childAccountPartyId);
                    }
                }
            }
        }
        
        if ( !nonActiveLicenseIdSet.isEmpty() ) {
            if ( !hubIdToNonActiveLicSetMap.isEmpty() ) {
                for ( String hubId : hubIdToNonActiveLicSetMap.keySet() ) {
                    if ( !hubIdToNonActiveLicSetMap.get(hubId).isEmpty() ) {
                        List<TF_HasPartWrapper.licenseDetails> licenseWrapperList = new List<TF_HasPartWrapper.licenseDetails>();
                        for ( License__c lic : hubIdToNonActiveLicSetMap.get(hubId) ) {
                            TF_HasPartWrapper.licenseDetails licenseWrapperRecord = new TF_HasPartWrapper.licenseDetails();
                            List<TF_HasPartWrapper.ChildPartyIds> childPartyBlankList = new List<TF_HasPartWrapper.ChildPartyIds>();
                            List<String> grantList = new List<String>();
                
                            if ( lic.Grant_Type__c != NULL ) {
                                if ( lic.Grant_Type__c.contains(';') )
                                    grantList = lic.Grant_Type__c.split(';');
                                else
                                    grantList.add( lic.Grant_Type__c );
                            }
                            
                            licenseWrapperRecord.licenseId = lic.id;
                            //licenseWrapperRecord.customerId = lic.customer__c != NULL ? String.valueOf( lic.customer__c ) : '';
                            //licenseWrapperRecord.contactId = lic.contact__c != NULL ? String.valueOf( lic.contact__c ) : '';
                            licenseWrapperRecord.partyId = ( ( lic.customer__c != NULL && String.isNotBlank(lic.customer__r.customer_Id__c) ? String.valueOf(lic.customer__r.customer_Id__c) : ( ( lic.contact__c != NULL && String.isNotBlank(lic.contact__r.party_Id__c) ) ? String.valueOf(lic.contact__r.party_Id__c) : '') ) );
                            licenseWrapperRecord.access_scope = String.isBlank(lic.Access_Scope__c) ? 'Global' : lic.Access_Scope__c;
                            licenseWrapperRecord.status = String.isNotBlank(lic.Status__c) ? lic.Status__c : '';
                            licenseWrapperRecord.licenseName = lic.name; //UBX-12715
                            licenseWrapperRecord.licenseType = lic.License_Type__c != NULL ? lic.License_Type__c : ''; //UBX-12715
                            if ( licIdToChildPartyIdsListMap.containsKey(lic.id) ) { //UBX-12715
                                licenseWrapperRecord.childParties = licIdToChildPartyIdsListMap.get(lic.id);
                            } else {
                                licenseWrapperRecord.childParties = childPartyBlankList;
                            }
                            licenseWrapperRecord.grantType = grantList;
                            licenseWrapperList.add(licenseWrapperRecord);
                        }
                        
                        if ( hubIdToHasParrtJsonMap.containsKey(hubId) ) {
                            hasPartWrapperJson = (TF_HasPartWrapper)System.JSON.deserialize( hubIdToHasParrtJsonMap.get(hubId), TF_HasPartWrapper.class);
                            hasPartWrapperJson.Body.licenses = licenseWrapperList;
                        }
                        nonActiveHubIdToJsonMap.put( hubId, JSON.serialize(hasPartWrapperJson) );
                        licenseWrapperList.clear();
                    }
                }
            }
            
            try {
                Map<Id, Case> failedLicIdToCaseMap = new Map<Id, Case>();
                failedLicIdToCaseMap = TF_AsyncSQSJob.returnLicIdToCaseMap( nonActiveLicenseIdSet, 'Licenses matching dynamic product update are not active.' );

                if ( !failedLicIdToCaseMap.isEmpty() ) {
                    List<Exception_Log__c> exceptionLogList = new List<Exception_Log__c>();
                    if ( !failedLicIdToCaseMap.isEmpty() ) {
                        for ( Id licId : failedLicIdToCaseMap.keySet() ) {
                            String licJson = '';
                            if ( nonActiveLicIdToHubIdMap.containsKey(licId) ) {
                                if ( nonActiveHubIdToJsonMap.containsKey(nonActiveLicIdToHubIdMap.get( licId )) ) {
                                    licJson = nonActiveHubIdToJsonMap.get( nonActiveLicIdToHubIdMap.get( licId ) );
                                }
                            }
                            Exception_Log__c exceptionLogInsert = new Exception_Log__c();
                            exceptionLogInsert.ownerId = UserInfo.getUserId();
                            exceptionLogInsert.Object_ID__c = licId;
                            exceptionLogInsert.Object_Type__c = 'Platform Event';
                            exceptionLogInsert.Error_Type__c = 'Outbound';
                            exceptionLogInsert.Error_message__c = 'HasPartUpdate : ' + 'Licenses matching dynamic product update are not active.';
                            exceptionLogInsert.Type_of_Action__c = ( String.isNotBlank(licJson) && licJson.contains('AddLicense') ) ? 'Insert' : ( ( String.isNotBlank(licJson) && ( licJson.contains('UpdateLicense') || licJson.containsIgnoreCase('partsAdded') ) ? 'Update' : '' ) );
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
                }
            } catch ( Exception ex ) {
                System.debug('Exception =====>' + ex.getMessage());
            }

            List<License__c> initiatedLicUpdateList = new List<License__c>();
            List<License__c> nonActiveLicUpdateList = new List<License__c>();
            if ( !nonActiveLicenseIdSet.isEmpty() ) {
                for ( Id licIdd : nonActiveLicenseIdSet ) {
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
                
                for ( Id licIdd : nonActiveLicenseIdSet ) {
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
    }
}