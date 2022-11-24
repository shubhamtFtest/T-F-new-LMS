/************************************************************************
    //Created by Vikas Varshney for POF-543 on dated 16-11-2018
    //This class is being used to retry SQS Framework,
    //Used in trigger on case "TF_ExceptionResolvedCase_Tgr"
    //Test class "ztest_TF_EntitlementRetryFramework""
    //Modified by Vikas Varshney for POF-542 on dated 05 Dec, 2018
    //Modified by Vikas Varshney for POF-817 on dated 30 Jan, 2019
    //Modified by Vikas Varshney for LMS-196 on dated 22 Aug, 2019
    //Modified by Vikas Varshney for LMS-264 on dated 10 Sep, 2019
    //Modified by Vikas Varshney for LMS-433 on dated 11 Dec, 2019
    //Modified by Vikas Varshney for LMS-424 on dated 22nd Dec, 2019
    //Modified by Vikas Varshney for UBX-306 on dated 16th April, 2020
    //Modified by Vikas Varshney for UBX-1175 on dated 22th June, 2020
    //Modified by Vikas Varshney for UBX-12715 on dated 25th Aug, 2020
    //Modified by Vikas Varshney for UBX-13873 on dated 25th Sep, 2020
    //Modified by Vikas Varshney for UBXC-1788 on dated 14th June, 2021 //CHG0048117
************************************************************************/

public class TF_EntitlementRetryFramework {
    public static Map<Id, License__c> licenseIdToLicenseMap;

    //Method to retry License and Entitlement SQS Framework
    public static void licenseAndEntitlementHandler ( List<Exception_Log__c> exceptionList, String objectType, Map<Id, Case> idToCaseMap ) {
        if ( objectType.equalsIgnoreCase('License') ) {
            Map<Id, Exception_Log__c> licenseInsertB2BCheckMap = new Map<Id, Exception_Log__c>();
            Map<Id, Exception_Log__c> licenseInsertConsortiumCheckMap = new Map<Id, Exception_Log__c>();
            Map<Id, Exception_Log__c> licenseUpdateCheckMap = new Map<Id, Exception_Log__c>();
            Map<Id, Exception_Log__c> licenseMemberInsertCheckMap = new Map<Id, Exception_Log__c>();
            Map<Id, Exception_Log__c> entitlementInboundMap = new Map<Id, Exception_Log__c>();
            Map<Id, Exception_Log__c> entitlementInboundUpdateMap = new Map<Id, Exception_Log__c>();
            Map<Exception_Log__c, Id> licenseMemberUpdateCheckMap = new Map<Exception_Log__c, Id>();
            
            if ( !exceptionList.isEmpty() ) {
                for ( Exception_Log__c excption : exceptionList ) {
                    if ( String.isNotBlank( excption.Object_Type__c ) && excption.Object_Type__c.equalsIgnoreCase('License') ) {
                        if ( String.isNotBlank( excption.Object_ID__c ) && ( excption.Object_ID__c.startsWith( License__c.sobjecttype.getDescribe().getKeyPrefix() ) ) ) {
                            if ( String.isNotBlank( excption.Type_of_Action__c ) && String.isNotBlank( excption.Request_JSON__c ) && excption.Type_of_Action__c.equalsIgnoreCase('Insert') && excption.Request_JSON__c.containsIgnoreCase('AddLicense') ) {
                                if ( excption.Request_JSON__c.containsIgnoreCase('B2B') ) {
                                    licenseInsertB2BCheckMap.put( excption.Object_ID__c, excption ); // License Insert B2B Case
                                } else if ( excption.Request_JSON__c.containsIgnoreCase('Consortium') ) {
                                    licenseInsertConsortiumCheckMap.put( excption.Object_ID__c, excption ); // License Insert Consortium case
                                } else if ( excption.Request_JSON__c.containsIgnoreCase('Individual') ) {
                                    licenseInsertB2BCheckMap.put( excption.Object_ID__c, excption ); // Individual License Insert Case
                                }
                            }
                            if ( String.isNotBlank( excption.Type_of_Action__c ) && String.isNotBlank( excption.Request_JSON__c ) && excption.Type_of_Action__c.equalsIgnoreCase('Insert') && excption.Request_JSON__c.containsIgnoreCase('UpdateLicense') ) {
                                licenseMemberInsertCheckMap.put( excption.Object_ID__c, excption ); // License Member Insert Case
                            }
                            if ( String.isNotBlank( excption.Error_Type__c ) && String.isNotBlank( excption.Request_JSON__c ) && excption.Error_Type__c.equalsIgnoreCase('Inbound') && excption.Type_of_Action__c.equalsIgnoreCase('Insert') ) {
                                entitlementInboundMap.put( excption.Object_ID__c, excption ); // this is Entitlement inbound exception case
                            }
                            if ( String.isNotBlank( excption.Type_of_Action__c ) && String.isNotBlank( excption.Request_JSON__c ) && excption.Type_of_Action__c.equalsIgnoreCase('Update') && excption.Request_JSON__c.containsIgnoreCase('"removeMember":[]') && excption.Request_JSON__c.containsIgnoreCase('"addMember":[]') ) {
                                if ( !licenseInsertB2BCheckMap.containsKey( excption.Object_ID__c ) && !licenseInsertConsortiumCheckMap.containsKey( excption.Object_ID__c )  && !entitlementInboundMap.containsKey( excption.Object_ID__c ) )
                                    licenseUpdateCheckMap.put( excption.Object_ID__c, excption ); // License update case
                            }
                            if ( String.isNotBlank( excption.Type_of_Action__c ) && String.isNotBlank( excption.Request_JSON__c ) && excption.Type_of_Action__c.equalsIgnoreCase('Update') && !excption.Request_JSON__c.containsIgnoreCase('"removeMember":[]') && !excption.Request_JSON__c.containsIgnoreCase('message') ) {
                                licenseMemberUpdateCheckMap.put( excption, excption.Object_ID__c ); // License Member Update case
                            }
                            //if ( String.isNotBlank( excption.Type_of_Action__c ) && String.isNotBlank( excption.Request_JSON__c ) && excption.Type_of_Action__c.equalsIgnoreCase('Update') && excption.Request_JSON__c.containsIgnoreCase('message') ) {
                            if ( String.isNotBlank( excption.Error_Type__c ) && String.isNotBlank( excption.Request_JSON__c ) && excption.Error_Type__c.equalsIgnoreCase('Inbound') && excption.Type_of_Action__c.equalsIgnoreCase('Update') && !entitlementInboundMap.containsKey( excption.Object_ID__c ) ) {
                                entitlementInboundUpdateMap.put( excption.Object_ID__c, excption ); // this is Entitlement inbound exception case
                            }
                        }
                    }
                }
            }
            
            Set<Id> licenseIdSet = new Set<Id>();
            //Creating set of all license ids set
            if ( !licenseInsertB2BCheckMap.isEmpty() )
                licenseIdSet.addAll( licenseInsertB2BCheckMap.keySet() );
            if ( !licenseInsertConsortiumCheckMap.isEmpty() )
                licenseIdSet.addAll( licenseInsertConsortiumCheckMap.keySet() );
            if ( !licenseUpdateCheckMap.isEmpty() )
                licenseIdSet.addAll( licenseUpdateCheckMap.keySet() );
            if ( !licenseMemberInsertCheckMap.isEmpty() )
                licenseIdSet.addAll( licenseMemberInsertCheckMap.keySet() );
            if ( !licenseMemberUpdateCheckMap.isEmpty() )
                licenseIdSet.addAll( licenseMemberUpdateCheckMap.values() );
            if ( !entitlementInboundMap.isEmpty() )
                licenseIdSet.addAll( entitlementInboundMap.keySet() );
            if ( !entitlementInboundUpdateMap.isEmpty() ) 
                licenseIdSet.addAll( entitlementInboundUpdateMap.keySet() );
            
            //creating map of license id to license
            if ( !licenseIdSet.isEmpty() ) {
                licenseIdToLicenseMap = new Map<Id, License__c>( [ SELECT id, name, Customer__c, Customer__r.Type, Customer__r.Ringgold_Account_ID__c, Customer__r.Customer_Id__c, Product__c, Product__r.Hub_Id__c, Order_Number__c, License_Type__c, Grant_Type__c, Start_Date__c, End_Date__c, Status__c, Update_Type__c, Contact__c, Contact__r.Party_Id__c, RecordType.Name, Access_Scope__c FROM License__c WHERE id IN:licenseIdSet ] );
            }
            
            //searching consortium license inbound failure
            Map<Id, Exception_Log__c> entitlementInboundB2BMap = new Map<Id, Exception_Log__c>();
            if ( !entitlementInboundMap.isEmpty() ) {
                for ( Id liccId : entitlementInboundMap.KeySet() ) {
                    if ( licenseIdToLicenseMap.containsKey(liccId) ) {
                        if ( licenseIdToLicenseMap.get(liccId).Customer__c != NULL && licenseIdToLicenseMap.get(liccId).Customer__r.Type.equalsIgnoreCase('Consortium') ) {
                            licenseInsertConsortiumCheckMap.put(liccId, entitlementInboundMap.get(liccId));
                        } else {
                            entitlementInboundB2BMap.put(liccId, entitlementInboundMap.get(liccId));
                        }
                    }
                }
                entitlementInboundMap.clear();
            }
            
            if ( !entitlementInboundB2BMap.isEmpty() ) {
                entitlementInboundMap.putAll(entitlementInboundB2BMap);
            }
            
            //calling Entitlement API's
            if ( !licenseIdToLicenseMap.isEmpty() ) {
                if ( !licenseInsertB2BCheckMap.isEmpty() || !licenseInsertConsortiumCheckMap.isEmpty() || !licenseMemberInsertCheckMap.isEmpty() || !licenseUpdateCheckMap.isEmpty() || !entitlementInboundMap.isEmpty() || !licenseMemberUpdateCheckMap.isEmpty() || !entitlementInboundUpdateMap.isEmpty() ) {
                    if ( !Test.isRunningTest() ) {
                        Id queLicenseB2bInsertJobId = System.enqueueJob( new TF_AsyncLicenseB2BInsertQueueable( licenseIdToLicenseMap, licenseInsertB2BCheckMap, licenseInsertConsortiumCheckMap, licenseMemberInsertCheckMap, licenseUpdateCheckMap, entitlementInboundMap, licenseMemberUpdateCheckMap, entitlementInboundUpdateMap ) );
                    }
                }
            }
        } /*else if ( objectType.equalsIgnoreCase('Opportunity') ) {
            Set<Id> oppIdSet = new Set<Id>();
            List<Opportunity> oppList = new List<Opportunity>();
            Map<Id, Opportunity> oppIdToOppMap = new Map<Id, Opportunity>();
            
            if ( !exceptionList.isEmpty() ) {
                for ( Exception_Log__c excption : exceptionList ) {
                    if ( String.isNotBlank( excption.Object_Type__c ) && excption.Object_Type__c.equalsIgnoreCase('Opportunity') ) {
                        if ( String.isNotBlank( excption.Object_ID__c ) && ( excption.Object_ID__c.startsWith( Opportunity.sobjecttype.getDescribe().getKeyPrefix() ) ) ) {
                            oppIdSet.add( excption.Object_ID__c );
                        }
                    }
                }
            }
            
            if ( !oppIdSet.isEmpty() ) {
                oppList = [ SELECT id, StageName, Account.Billing_Street__c, Account.Billing_City__c, Account.Billing_State__c, Account.Billing_ZIP__c, Account.Billing_Country_List__c, Account.Billing_State_List__c, Account.Description, Order_Type__c, Start_Date__c, End_Date__c, Grant_Type__c, (SELECT id, product2.Id, UnitPrice, product2.name, product2.CurrencyIsoCode, ListPrice, Quantity, product2.Family FROM OpportunityLineItems) FROM Opportunity WHERE id IN:oppIdSet ];
            }
            
            if ( !oppList.isEmpty() ) {
                for ( Opportunity opp : oppList ) {
                    oppIdToOppMap.put( opp.id, opp );
                }
            }
            
            Set<Case> caseSet = new Set<Case>();
            if ( !idToCaseMap.isEmpty() ) {
                for ( Id oppId : idToCaseMap.keySet() ) {
                    if ( !oppIdToOppMap.isEmpty() && oppIdToOppMap.containsKey(oppId) && oppIdToOppMap.get(oppId).StageName != 'Closed Won' ) {
                        caseSet.add(idToCaseMap.get(oppId));
                    }
                }
            }
            
            if ( !caseSet.isEmpty() ) {
                for ( Case cassee : caseSet ) {
                    cassee.addError('Any of the opportunity is not Closed Won');
                }
            }
            if ( !oppList.isEmpty() ) {
                oppRetryFramework( oppList );
            }
        }*/
    }
    
    //method to retry hasPart update logic
    public static void hasPartUpdateRetry ( List<Exception_Log__c> exceptionList, String objectType, Case reopenedCase ) {
        
        if ( objectType.equalsIgnoreCase('hasPart Outbound') ) {
            String licensePrefix = '';
            licensePrefix = License__c.SObjectType.getDescribe().getKeyPrefix();
            Map<String, Set<Exception_Log__c>> licenseIdToExceptionLogSetMap = new Map<String, Set<Exception_Log__c>>();
            Map<String, Set<String>> licenseIdToPartsAddedSetMap = new Map<String, Set<String>>();
            Map<String, Set<String>> licenseIdToPartsDeletedSetMap = new Map<String, Set<String>>();
            List<License__c> licensList = new List<License__c>();
            Map<String, String> licIdToHubIdMap = new Map<String, String>();
            Map<String, Set<License__c>> hubIdToLicenseSetMap = new Map<String, Set<License__c>>(); //Initializing map of product hub id and its license list
            Map<String, String> hubIdToJSONMap = new Map<String, String>(); //Initializing map of product hub id and its json
            
            if ( !exceptionList.isEmpty() ) {
                for ( Exception_Log__c log : exceptionList ) {
                    if ( String.isNotBlank(log.Object_ID__c) && String.isNotBlank(licensePrefix) && log.Object_ID__c.contains(licensePrefix) ) {
                        if ( !licenseIdToExceptionLogSetMap.containsKey(log.Object_ID__c) ) {
                            licenseIdToExceptionLogSetMap.put( log.Object_ID__c, new Set<Exception_Log__c>() );
                        }
                        licenseIdToExceptionLogSetMap.get(log.Object_ID__c).add(log);
                        
                        //Creting parts added MAP
                        if ( !licenseIdToPartsAddedSetMap.containsKey(log.Object_ID__c) ) {
                            licenseIdToPartsAddedSetMap.put( log.Object_ID__c, new Set<String>() );
                        }
                        
                        //Creating parts deleted MAP
                        if ( !licenseIdToPartsDeletedSetMap.containsKey(log.Object_ID__c) ) {
                            licenseIdToPartsDeletedSetMap.put( log.Object_ID__c, new Set<String>() );
                        }
                        
                        if ( log.Request_JSON__c != NULL ) {
                            if ( log.Request_JSON__c.containsIgnoreCase('Body') ) {
                                TF_HasPartWrapper hasPartWrapperStr = new TF_HasPartWrapper();
                                String hasPartStr = log.Request_JSON__c;
                                hasPartWrapperStr = (TF_HasPartWrapper)System.JSON.deserialize( hasPartStr, TF_HasPartWrapper.class);
                                if ( hasPartWrapperStr != NULL ) {
                                    if ( hasPartWrapperStr.Body != NULL ) {
                                        if ( hasPartWrapperStr.Body.partsAdded != Null ) { //UBXC-1788
                                            if ( !hasPartWrapperStr.Body.partsAdded.isEmpty() ) {
                                                for ( String addedPart : hasPartWrapperStr.Body.partsAdded ) {
                                                    licenseIdToPartsAddedSetMap.get(log.Object_ID__c).add(addedPart);
                                                }
                                            }
                                        }
                                        
                                        if ( hasPartWrapperStr.Body.partsDeleted != Null ) { //UBXC-1788
                                            if ( !hasPartWrapperStr.Body.partsDeleted.isEmpty()  ) {
                                                for ( String deletedPart : hasPartWrapperStr.Body.partsDeleted ) {
                                                    licenseIdToPartsDeletedSetMap.get(log.Object_ID__c).add(deletedPart);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            if ( !licenseIdToExceptionLogSetMap.isEmpty() ) {
                licensList = [ SELECT id, name, License_Type__c, Product__c, Product__r.Hub_Id__c, End_Date__c, Customer__c, Customer__r.Customer_Id__c, Contact__c, Contact__r.Party_Id__c, Access_Scope__c, Status__c, Grant_Type__c, ( SELECT id, Account__c, Account__r.Customer_Id__c FROM License_Memebers__r ) FROM License__c WHERE id IN:licenseIdToExceptionLogSetMap.keySet() ];
            }
            
            Map<String,List<TF_HasPartWrapper.ChildPartyIds>> licIdToChildPartyIdsListMap = new Map<String,List<TF_HasPartWrapper.ChildPartyIds>>();
            if ( !licensList.isEmpty() ) {
                for ( License__c lic : licensList ) {
                    if ( lic.Product__c != NULL && String.isNotBlank(lic.Product__r.Hub_Id__c) ) {
                        //creating hubId and its licenses MAP
                         if ( !hubIdToLicenseSetMap.containsKey(lic.Product__r.Hub_Id__c) ) {
                            hubIdToLicenseSetMap.put( lic.Product__r.Hub_Id__c, new Set<License__c>() );
                        }
                        hubIdToLicenseSetMap.get(lic.Product__r.Hub_Id__c).add( lic );
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
            
            //creating map of hub id and its json to put file in S3 and post its location to SNS
            if ( !hubIdToLicenseSetMap.isEmpty() ) {
                for ( String hubId : hubIdToLicenseSetMap.keySet() ) {
                    TF_HasPartWrapper eventJsonRecord = new TF_HasPartWrapper();
                    eventJsonRecord.Header = new TF_HasPartWrapper.Header();
                    eventJsonRecord.Body = new TF_HasPartWrapper.Body();
                    eventJsonRecord.Body.Product = new TF_HasPartWrapper.Product();
                    eventJsonRecord.Body.Product.x_id = hubId;
                    eventJsonRecord.Body.partsAdded = new List<String>();
                    eventJsonRecord.Body.partsDeleted = new List<String>();
                    List<TF_HasPartWrapper.licenseDetails> licenseWrapperList = new List<TF_HasPartWrapper.licenseDetails>();
                    
                    if ( !hubIdToLicenseSetMap.get( hubId ).isEmpty() ) {
                        for ( License__c licDetail : hubIdToLicenseSetMap.get( hubId ) ) {
                            TF_HasPartWrapper.licenseDetails licenseDetailList = new TF_HasPartWrapper.licenseDetails();
                            List<TF_HasPartWrapper.ChildPartyIds> childPartyBlankList = new List<TF_HasPartWrapper.ChildPartyIds>();
                            String licStatus = '';
                            List<String> grantList = new List<String>();
                
                            if ( licDetail.Grant_Type__c != NULL ) {
                                if ( licDetail.Grant_Type__c.contains(';') )
                                    grantList = licDetail.Grant_Type__c.split(';');
                                else
                                    grantList.add( licDetail.Grant_Type__c );
                            }
                            
                            if ( String.isNotBlank(licDetail.Status__c) ) {
                                if ( licDetail.Status__c != NULL && 'Deactivated'.equalsIgnoreCase(licDetail.Status__c) ) {
                                    licStatus = 'Deactivated';
                                } else if ( licDetail.Status__c != NULL && 'Expired'.equalsIgnoreCase(licDetail.Status__c) ) {
                                    licStatus = 'Expired';
                                }else if ( licDetail.Status__c != NULL && 'Active'.equalsIgnoreCase(licDetail.Status__c) ) {
                                    licStatus = 'Active';
                                } else if ( licDetail.End_Date__c != NULL && licDetail.End_Date__c <= Date.today() ) {
                                    licStatus = 'Expired';
                                } else if ( licDetail.End_Date__c != NULL && licDetail.End_Date__c > Date.today() ) {
                                    licStatus = 'Active';
                                } else {
                                    licStatus = 'Active';
                                }
                            }
                            
                            licenseDetailList.licenseId = licDetail.id;
                            licenseDetailList.partyId = ( ( licDetail.customer__c != NULL && String.isNotBlank(licDetail.customer__r.customer_Id__c) ? String.valueOf(licDetail.customer__r.customer_Id__c) : ( ( licDetail.contact__c != NULL && String.isNotBlank(licDetail.contact__r.party_Id__c) ) ? String.valueOf(licDetail.contact__r.party_Id__c) : '') ) );
                            licenseDetailList.access_scope = String.isBlank(licDetail.Access_Scope__c) ? 'Global' : licDetail.Access_Scope__c;
                            licenseDetailList.status = licStatus;
                            licenseDetailList.licenseName = licDetail.name; //UBX-12715
                            licenseDetailList.licenseType =  licDetail.License_Type__c != NULL ? licDetail.License_Type__c : ''; //UBX-12715
                            if ( licIdToChildPartyIdsListMap.containsKey(licDetail.id) ) { //UBX-12715
                                licenseDetailList.childParties = licIdToChildPartyIdsListMap.get(licDetail.id);
                            } else {
                                licenseDetailList.childParties = childPartyBlankList;
                            }
                            licenseDetailList.grantType = grantList;
                            licenseWrapperList.add( licenseDetailList );
                            
                            if ( !licenseIdToPartsAddedSetMap.isEmpty() && licenseIdToPartsAddedSetMap.containsKey(licDetail.id) ) {
                                eventJsonRecord.Body.partsAdded.addAll(licenseIdToPartsAddedSetMap.get(licDetail.id));
                            }
                            if ( eventJsonRecord.Body.partsAdded != NULL && eventJsonRecord.Body.partsAdded.size() == 0 ){ //UBXC-1788
                                eventJsonRecord.Body.partsAdded = Null;
                            }
                            System.debug('partsAdded =====>' + eventJsonRecord.Body.partsAdded);
                            
                            if ( !licenseIdToPartsDeletedSetMap.isEmpty() && licenseIdToPartsDeletedSetMap.containsKey(licDetail.id) ) {
                                eventJsonRecord.Body.partsDeleted.addAll(licenseIdToPartsDeletedSetMap.get(licDetail.id));
                            }
                            if ( eventJsonRecord.Body.partsDeleted != NULL && eventJsonRecord.Body.partsDeleted.size() == 0 ) { //UBXC-1788
                                eventJsonRecord.Body.partsDeleted = Null;
                            }
                            
                            System.debug('partsDeleted =====>' + eventJsonRecord.Body.partsDeleted);
                        }
                        
                        eventJsonRecord.Body.licenses = new List<TF_HasPartWrapper.licenseDetails>();
                        if ( !licenseWrapperList.isEmpty() ) {
                            eventJsonRecord.Body.licenses = licenseWrapperList;
                        }
                        
                        hubIdToJSONMap.put( hubId, JSON.serialize(eventJsonRecord) );
                        licenseWrapperList.clear();
                    }
                }
            }
            
            if ( !hubIdToJSONMap.isEmpty() ) {
                System.debug('hubIdToJSONMap =====>' + hubIdToJSONMap);
                System.debug('hubIdToJSONMap Size =====>' + hubIdToJSONMap.size());
                TF_License_Update_Event_Tgr_Cls.s3LicenseCalloutAndSNSNotify( hubIdToJSONMap );
            }
        }/* else if ( objectType.equalsIgnoreCase('hasPart Inbound') ) {
            String licensePrefix = '';
            licensePrefix = License__c.SObjectType.getDescribe().getKeyPrefix();
            Set<Id> licIdSet = new Set<Id>();
            List<License__c> licensList = new List<License__c>();
            Map<String, Set<Id>> hubIdToLicIdSetMap = new Map<String, Set<Id>>();
            Map<String, String> hubIdToJsonMap = new Map<String, String>();
            
            if ( !exceptionList.isEmpty() ) {
                for ( Exception_Log__c inboundLog : exceptionList ) {
                    if ( String.isNotBlank(inboundLog.Request_JSON__c) && String.isNotBlank(licensePrefix) && inboundLog.Request_JSON__c.contains(licensePrefix) ) {
                        List<String> strList = new List<String>();
                        strList = inboundLog.Request_JSON__c.split(',');
                        if ( !strList.isEmpty() ) {
                            for ( String strr : strList ) {
                                //if ( strr.contains('license') ) {licenseID
                                if ( strr.contains('licenseID') ) {
                                    strr = strr.remove('{');
                                    strr = strr.remove('}');
                                    strr = strr.remove('"');
                                    strr = strr.remove(':');
                                    strr = strr.remove('licenseID');
                                    licIdSet.add( strr );
                                }
                            }
                        }
                        strList.clear();
                    }
                }
            }
            
            if ( !licIdSet.isEmpty() ) {
                licensList = [ SELECT id, Product__c, Product__r.Hub_Id__c FROM License__c WHERE id IN:licIdSet ];
            }
            
            if ( !licensList.isEmpty() ) {
                for ( License__c lic : licensList ) {
                    if ( lic.Product__c != NULL ) {
                        if ( !hubIdToLicIdSetMap.containsKey(lic.Product__r.Hub_Id__c) ) {
                            hubIdToLicIdSetMap.put( lic.Product__r.Hub_Id__c, new Set<Id>() );
                        }
                        hubIdToLicIdSetMap.get( lic.Product__r.Hub_Id__c ).add( lic.id );
                    }
                }
            }
            
            if ( !hubIdToLicIdSetMap.isEmpty() ) {
                for ( String evnthubId : hubIdToLicIdSetMap.keySet() ) {
                    TF_License_Update_Event_Tgr_Cls.eventJsonWrapper hasPartWrapper = new TF_License_Update_Event_Tgr_Cls.eventJsonWrapper();
                    hasPartWrapper.type = 'HasPartUpdate';
                    hasPartWrapper.licenseProductHubId = evnthubId;
                    hasPartWrapper.licenseIds = new List<Id>();
                    hasPartWrapper.licenseIds.addAll( hubIdToLicIdSetMap.get( evnthubId ) );
                    hubIdToJsonMap.put( evnthubId, JSON.serialize(hasPartWrapper) );
                }
            }

            if ( !hubIdToJsonMap.isEmpty() ) {
                TF_License_Update_Event_Tgr_Cls.s3LicenseCalloutAndSNSNotify( hubIdToJsonMap );
            }
        }*/
    }
    
    // ----- Private method definition ------
    //method to create a license insert json
    public static String licenseInsertJson ( List<License__c> licList ) {
        String licenseInsertJSONStr = '';
        List<TF_CreateLicenseJSON_Tgr.LicenseWrapper> licenseWrapperList = new List<TF_CreateLicenseJSON_Tgr.LicenseWrapper>();
        List<TF_CreateLicenseJSON_Tgr.LicenseWrapperNew> blankList = new List<TF_CreateLicenseJSON_Tgr.LicenseWrapperNew>();
        
        if ( !licList.isEmpty() ) {
            for ( License__c lic : licList ) {
                List<String> grantList = new List<String>();
                String licStatus = '';
                
                if ( lic.Grant_Type__c != NULL ) {
                    if ( lic.Grant_Type__c.contains(';') )
                        grantList = lic.Grant_Type__c.split(';');
                    else
                        grantList.add( lic.Grant_Type__c );
                }
                
                if ( String.isNotBlank(lic.Status__c) ) {
                    if ( lic.Status__c != NULL && 'Deactivated'.equalsIgnoreCase(lic.Status__c) ) {
                        licStatus = 'Deactivated';
                    } else if ( lic.Status__c != NULL && 'Expired'.equalsIgnoreCase(lic.Status__c) ) {
                        licStatus = 'Expired';
                    }else if ( lic.Status__c != NULL && 'Active'.equalsIgnoreCase(lic.Status__c) ) {
                        licStatus = 'Active';
                    } else if ( lic.End_Date__c != NULL && lic.End_Date__c <= Date.today() ) {
                        licStatus = 'Expired';
                    } else if ( lic.End_Date__c != NULL && lic.End_Date__c > Date.today() ) {
                        licStatus = 'Active';
                    } else {
                        licStatus = 'Active';
                    }
                }
                
                TF_CreateLicenseJSON_Tgr.LicenseWrapper licenseWrapperRecord = new TF_CreateLicenseJSON_Tgr.LicenseWrapper();
                licenseWrapperRecord.type = 'AddLicense';
                licenseWrapperRecord.licenseId = lic.id;
                if ( lic.RecordType.Name == 'T&F Account License' )
                    licenseWrapperRecord.salesforceAccountID = lic.Customer__c != NULL ? lic.Customer__c : '';
                else
                    licenseWrapperRecord.salesforceAccountID = '';
                if ( lic.RecordType.Name == 'T&F Account License' )
                    licenseWrapperRecord.ringgoldID = lic.Customer__c != NULL && lic.Customer__r.Ringgold_Account_ID__c <> NULL ? lic.Customer__r.Ringgold_Account_ID__c : '';
                else
                    licenseWrapperRecord.ringgoldID = '';
                licenseWrapperRecord.productId = lic.Product__r.Hub_Id__c <> NULL ? lic.Product__r.Hub_Id__c : '';
                licenseWrapperRecord.orderNumber = lic.Order_Number__c != NULL ? lic.Order_Number__c : '';
                licenseWrapperRecord.addMember = blankList;
                licenseWrapperRecord.removeMember = blankList;
                licenseWrapperRecord.licenseType = lic.License_Type__c != NULL ? lic.License_Type__c : '';
                licenseWrapperRecord.grantType = grantList;
                licenseWrapperRecord.startDate = lic.Start_Date__c != NULL ? String.valueOf( lic.Start_Date__c ) : '';
                licenseWrapperRecord.endDate = lic.End_Date__c != NULL ? String.valueOf( lic.End_Date__c ) : '';
                licenseWrapperRecord.status = licStatus;
                licenseWrapperRecord.customerType = ( lic.Customer__c != NULL && 'Consortium'.equalsIgnoreCase(lic.Customer__r.Type) && ( lic.RecordType.Name == 'T&F Account License' || String.isBlank(lic.RecordType.Name) ) ) ? 'Consortium' : ( ( lic.Customer__c != NULL && !'Consortium'.equalsIgnoreCase(lic.Customer__r.Type) && ( lic.RecordType.Name == 'T&F Account License' || String.isBlank(lic.RecordType.Name) ) ) ? 'B2B' : ( ( lic.Contact__c != NULL && lic.RecordType.Name == 'T&F Individual License' ) ? 'Individual' : '' ) );
                licenseWrapperRecord.partyID = ( lic.Customer__c != NULL && lic.Customer__r.Customer_Id__c != NULL && ( lic.RecordType.Name == 'T&F Account License' || String.isBlank(lic.RecordType.Name) ) ) ? lic.Customer__r.Customer_Id__c : ( ( lic.Contact__c != NULL && lic.Contact__r.Party_Id__c != NULL && lic.RecordType.Name == 'T&F Individual License' ) ? lic.Contact__r.Party_Id__c : '' );
                licenseWrapperRecord.updatetype = lic.Update_Type__c != NULL ? lic.Update_Type__c : '' ;
                licenseWrapperRecord.licenseName = lic.name;
                licenseWrapperRecord.accessScope = String.isBlank(lic.Access_Scope__c) ? 'Global' : lic.Access_Scope__c;
                licenseWrapperList.add(licenseWrapperRecord);
            }
        }
        
        //Serializing JSON if license wrapper list is not null
        if ( !licenseWrapperList.isEmpty() ) {
            licenseInsertJSONStr = JSON.serialize(licenseWrapperList);
            licenseInsertJSONStr = licenseInsertJSONStr.removeStart('[');
            licenseInsertJSONStr = licenseInsertJSONStr.removeEnd(']');
        }
        
        return licenseInsertJSONStr;
    }
    
    //method to create a License Member Json upon its insertion and updation
    public static String licenseMemberInsertJson ( List<License__c> licList ) {
        String liccenseMemberJson = '';
        List<TF_LicenseMemberJSON_Tgr.LicenseMemberWrapper> licenseMemberWrapperList = new List<TF_LicenseMemberJSON_Tgr.LicenseMemberWrapper>();
        Map<Id, License__c> licenseIdToLicenseMap = new Map<Id, License__c>();
        Map<Id, List<License_Memeber__c>> licenseIdToLicMemListMap = new Map<Id, List<License_Memeber__c>>();
        
        if ( !licList.isEmpty() ) {
            for ( License__c lic : licList ) {
                licenseIdToLicenseMap.put( lic.id, lic );
            }
        }
        
        //creating map of license and its license mamber list
        if ( !licenseIdToLicenseMap.isEmpty() ) {
            List<License_Memeber__c> licMemberList = new List<License_Memeber__c>();
            licMemberList = [ SELECT Account__c, Account__r.Ringgold_Account_ID__c, License__c, Account__r.Customer_Id__c, License__r.Update_Type__c FROM License_Memeber__c WHERE License__c IN:licenseIdToLicenseMap.keySet() ];
            
            if ( !licMemberList.isEmpty() ) {
                for ( License_Memeber__c licMem : licMemberList ) {
                    if ( !licenseIdToLicMemListMap.containsKey( licMem.License__c ) ) {
                        licenseIdToLicMemListMap.put( licMem.License__c, new List<License_Memeber__c>() );
                    }
                    licenseIdToLicMemListMap.get( licMem.License__c ).add( licMem );
                }
            }
        }
        
        if ( !licList.isEmpty() ) {
            for ( License__c lic : licList ) {
                Map<id, id> licenseMemberIdToAccountIdMap = new Map<Id, Id>();
                Map<id, String> licensememberIdToRinggoldIdMap = new Map<Id, String>();
                Map<id, String> licensememberIdToCustomerIdMap = new Map<Id, String>();
                String licStatus = '';
                
                if ( !licenseIdToLicMemListMap.isEmpty() && licenseIdToLicMemListMap.containsKey( lic.id ) ) {
                    for ( License_Memeber__c licMem : licenseIdToLicMemListMap.get( lic.id ) ) {
                        if ( licMem.Account__c != NULL ) {
                            licenseMemberIdToAccountIdMap.put( licMem.id, licMem.Account__c );
                        }
                        if( licMem.Account__c != NULL && licMem.Account__r.Ringgold_Account_ID__c != NULL ) {
                            licensememberIdToRinggoldIdMap.put(licMem.id, licMem.Account__r.Ringgold_Account_ID__c);
                        }
                        if( licMem.Account__c != NULL && licMem.Account__r.Customer_Id__c != NULL ) {
                           licensememberIdToCustomerIdMap.put(licMem.id, licMem.Account__r.Customer_Id__c);
                        }
                    }
                }
                
                TF_LicenseMemberJSON_Tgr.LicenseMemberWrapper licenseMemberWrapperRecord = new TF_LicenseMemberJSON_Tgr.LicenseMemberWrapper();
                List<TF_LicenseMemberJSON_Tgr.LicenseMemberWrapperNew> licenseMemberWrapperNewAddList = new List<TF_LicenseMemberJSON_Tgr.LicenseMemberWrapperNew>();
                List<TF_LicenseMemberJSON_Tgr.LicenseMemberWrapperNew> blankMemberList = new List<TF_LicenseMemberJSON_Tgr.LicenseMemberWrapperNew>();
                List<String> grantList = new List<String>();
                
                if ( lic.Grant_Type__c != NULL ) {
                    if ( lic.Grant_Type__c.contains(';') )
                        grantList = lic.Grant_Type__c.split(';');
                    else
                        grantList.add( lic.Grant_Type__c );
                }
                
                if ( String.isNotBlank(lic.Status__c) ) {
                    if ( lic.Status__c != NULL && 'Deactivated'.equalsIgnoreCase(lic.Status__c) ) {
                        licStatus = 'Deactivated';
                    } else if ( lic.Status__c != NULL && 'Expired'.equalsIgnoreCase(lic.Status__c) ) {
                        licStatus = 'Expired';
                    }else if ( lic.Status__c != NULL && 'Active'.equalsIgnoreCase(lic.Status__c) ) {
                        licStatus = 'Active';
                    } else if ( lic.End_Date__c != NULL && lic.End_Date__c <= Date.today() ) {
                        licStatus = 'Expired';
                    } else if ( lic.End_Date__c != NULL && lic.End_Date__c > Date.today() ) {
                        licStatus = 'Active';
                    } else {
                        licStatus = 'Active';
                    }
                }
                
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
                licenseMemberWrapperRecord.updatetype = lic.Update_Type__c != NULL ? lic.Update_Type__c : '' ;
                licenseMemberWrapperRecord.productId = lic.Product__r.Hub_Id__c <> NULL ? lic.Product__r.Hub_Id__c : '';
                licenseMemberWrapperRecord.orderNumber = lic.Order_Number__c <> NULL ? lic.Order_Number__c : '';
                licenseMemberWrapperRecord.licenseType = lic.License_Type__c != NULL ? lic.License_Type__c : '';
                licenseMemberWrapperRecord.grantType = grantList;
                licenseMemberWrapperRecord.startDate = lic.Start_Date__c != NULL ? String.valueOf( lic.Start_Date__c ) : '';
                licenseMemberWrapperRecord.endDate = lic.End_Date__c != NULL ? String.valueOf( lic.End_Date__c ) : '';
                licenseMemberWrapperRecord.status = licStatus;
                licenseMemberWrapperRecord.customerType = ( lic.Customer__c != NULL && 'Consortium'.equalsIgnoreCase(lic.Customer__r.Type) && ( lic.RecordType.Name == 'T&F Account License' || String.isBlank(lic.RecordType.Name) ) ) ? 'Consortium' : ( ( lic.Customer__c != NULL && !'Consortium'.equalsIgnoreCase(lic.Customer__r.Type) && ( lic.RecordType.Name == 'T&F Account License' || String.isBlank(lic.RecordType.Name) ) ) ? 'B2B' : ( ( lic.Contact__c != NULL && lic.RecordType.Name == 'T&F Individual License' ) ? 'Individual' : '' ) );
                if ( !licenseIdToLicMemListMap.isEmpty() && licenseIdToLicMemListMap.containsKey(lic.id) && !licenseIdToLicMemListMap.get(lic.id).isEmpty() ) {
                    for ( License_Memeber__c licMemb : licenseIdToLicMemListMap.get( lic.id ) ) {
                        TF_LicenseMemberJSON_Tgr.LicenseMemberWrapperNew newWrapperRecord = new TF_LicenseMemberJSON_Tgr.LicenseMemberWrapperNew();
                        if ( lic.RecordType.Name == 'T&F Account License' )
                            newWrapperRecord.salesforceAccountID = (!licenseMemberIdToAccountIdMap.isEmpty() && licenseMemberIdToAccountIdMap.containsKey( licMemb.id ) ) ? licenseMemberIdToAccountIdMap.get( licMemb.id ) : '';
                        else
                            newWrapperRecord.salesforceAccountID = '';
                        if ( lic.RecordType.Name == 'T&F Account License' )
                            newWrapperRecord.ringgoldID = (!licensememberIdToRinggoldIdMap.isEmpty() && licensememberIdToRinggoldIdMap.containsKey(licMemb.id)) ? licensememberIdToRinggoldIdMap.get( licMemb.id ) : '';
                        else
                            newWrapperRecord.ringgoldID = '';
                        newWrapperRecord.partyID = ( ( !licensememberIdToCustomerIdMap.isEmpty() && licensememberIdToCustomerIdMap.containsKey(licMemb.id) && String.isNotBlank( licensememberIdToCustomerIdMap.get( licMemb.id ) ) ) ? licensememberIdToCustomerIdMap.get( licMemb.id ) : '' );
                        licenseMemberWrapperNewAddList.add( newWrapperRecord );
                    }
                }
                licenseMemberWrapperRecord.addMember = !licenseMemberWrapperNewAddList.isEmpty() ? licenseMemberWrapperNewAddList : blankMemberList;
                licenseMemberWrapperRecord.removeMember = blankMemberList;
                licenseMemberWrapperRecord.licenseName = lic.name;
                licenseMemberWrapperRecord.accessScope = String.isBlank(lic.Access_Scope__c) ? 'Global' : lic.Access_Scope__c;
                licenseMemberWrapperList.add( licenseMemberWrapperRecord );
            }
        }
        
        //Serializing json for license member of all licenses
        if ( !licenseMemberWrapperList.isEmpty() ) {
            liccenseMemberJson = JSON.serialize( licenseMemberWrapperList );
            liccenseMemberJson = liccenseMemberJson.removeStart('[');
            liccenseMemberJson = liccenseMemberJson.removeEnd(']');
        }
        
        return liccenseMemberJson;
    }
    
    //method to create license insert json for consortium case
    public static String licenseInsertConsortiumJson ( List<License__c> licList ) {
        String licenseConsortiumJson = '';
        
        licenseConsortiumJson = licenseMemberInsertJson( licList );
        licenseConsortiumJson = licenseConsortiumJson.replace( 'UpdateLicense', 'AddLicense');

        return licenseConsortiumJson;
    }
    
    //method to create license update json
    public static String licenseUpdateJson ( List<License__c> licList ) {
        String licenseUpdateJSON = '';
        
        licenseUpdateJSON = licenseInsertJson( licList );
        licenseUpdateJSON = licenseUpdateJSON.replace( 'AddLicense', 'UpdateLicense' );

        return licenseUpdateJSON;
    }
    
    //method to create license member update json
    public static String licenseMemberUpdateJson ( List<Exception_Log__c> excpLogList, Map<Id, License__c> licenseIdToLicensMap ) {
        String licenseMembUpdateJson = '';
        Map<Id, License__c> licenseIdToLicenseMap = new Map<Id, License__c>();

        licenseIdToLicenseMap = licenseIdToLicensMap;
        
        for ( Exception_Log__c excpLog : excpLogList ) {
            if ( String.isNotBlank( excpLog.Object_ID__c ) && String.isNotBlank( excpLog.Request_JSON__c ) ) {
                String excpJson = '';
                List<License__c> liccList = new List<License__c>();
                liccList.add( licenseIdToLicenseMap.get( excpLog.Object_ID__c ) );
                excpJson = licenseUpdateJson( liccList );
                String splitStr = '"removeMember":[';
                String str = '';
                str = excpLog.Request_JSON__c.substringBefore('],');
                str = str.substringAfter('"removeMember":');
                str = str.remove('[');
                splitStr += str;
                splitStr += ']';
                excpJson = excpJson.replace( '"removeMember":[]', splitStr);
                excpJson += ',';
                licenseMembUpdateJson += excpJson;
                liccList.clear();
            }
        }
        licenseMembUpdateJson = licenseMembUpdateJson.removeEnd(',');

        return licenseMembUpdateJson;
    }
    /*
    //method to create opportunity json and retry order creation API in order hub
    private static void oppRetryFramework ( List<Opportunity> oppList ) {
        Map<Id, TF_Opp_ClosedWon_Wrapper> oppIdToWrapperMap = new Map<Id, TF_Opp_ClosedWon_Wrapper>();
        String opportunityStrJSON = '';
        
        if(!oppList.isEmpty()) {
            for(Opportunity opp1 : oppList) {
                TF_Opp_ClosedWon_Wrapper oppWrapperRecord = new TF_Opp_ClosedWon_Wrapper();
                TF_Opp_ClosedWon_Wrapper.Billing_Address billingaddressWrap = new TF_Opp_ClosedWon_Wrapper.Billing_Address();
                List<String> grantList = new List<String>();
                if ( opp1.Grant_Type__c != NULL ) {
                    if ( opp1.Grant_Type__c.contains(';') )
                        grantList = opp1.Grant_Type__c.split(';');
                    else
                        grantList.add( opp1.Grant_Type__c );
                }
                List<TF_Opp_ClosedWon_Wrapper.OpportunityLineItem> orderItemList = new List<TF_Opp_ClosedWon_Wrapper.OpportunityLineItem>();
                oppWrapperRecord.orderType = 'SALES';
                oppWrapperRecord.channel = 'SFDC';
                oppWrapperRecord.orderStatus = 'PLACED';
                oppWrapperRecord.opportunityId = opp1.id != NULL ? opp1.id : '' ;
                oppWrapperRecord.customerId = opp1.AccountId != NULL ? opp1.AccountId : '' ;
                oppWrapperRecord.seller = 'TANDF';
                billingaddressWrap.addressId = '';
                billingaddressWrap.addressLine1 = opp1.Account.Billing_Street__c != NULL ? opp1.Account.Billing_Street__c : '' ;
                billingaddressWrap.addressLine2 = '';
                billingaddressWrap.addressLine3 = '';
                billingaddressWrap.addressCountry = opp1.Account.Billing_Country_List__c != NULL ? opp1.Account.Billing_Country_List__c : '';
                billingaddressWrap.addressLocality = opp1.Account.Billing_City__c != NULL ? opp1.Account.Billing_City__c : '';
                billingaddressWrap.addressRegion = opp1.Account.Billing_State_List__c != NULL ? opp1.Account.Billing_State_List__c : '';
                billingaddressWrap.addressContactName = '';
                billingaddressWrap.addressContactEmail = '';
                billingaddressWrap.addressOrganisation = '';
                billingaddressWrap.postalCode = opp1.Account.Billing_ZIP__c != NULL ? opp1.Account.Billing_ZIP__c : '';
                billingaddressWrap.streetAddress = '';
                oppWrapperRecord.billingAddress = billingaddressWrap;
                if(!opp1.OpportunityLineItems.isEmpty()){
                    for ( OpportunityLineItem oli : opp1.OpportunityLineItems ) {
                        TF_Opp_ClosedWon_Wrapper.OpportunityLineItem orderItem = new TF_Opp_ClosedWon_Wrapper.OpportunityLineItem();
                        TF_Opp_ClosedWon_Wrapper.Fulfillment fulfilment = new TF_Opp_ClosedWon_Wrapper.Fulfillment();
                        orderItem.productId = oli.product2.id != NULL ? oli.product2.id : '' ;
                        orderItem.price = oli.UnitPrice != NULL ? oli.UnitPrice : 0 ;
                        orderItem.sellingPrice = oli.UnitPrice != NULL ? oli.UnitPrice : 0;
                        orderItem.currency_temp = oli.product2.CurrencyIsoCode != NULL ? oli.product2.CurrencyIsoCode : '' ; 
                        orderItem.quantity = oli.Quantity != NULL ? (Integer.valueOf( oli.Quantity )) : 0;
                        orderItem.orderedQuantity = oli.Quantity!= NULL ? (Integer.valueOf( oli.Quantity )) : 0;
                        orderItem.lineItemType = oli.product2.Family != NULL ? oli.product2.Family : '';
                        fulfilment.licenseType = opp1.Order_Type__c != NULL ? opp1.Order_Type__c : '' ;
                        fulfilment.name = 'Fulfillment for ' + opp1.Order_Type__c + ' license';
                        fulfilment.description = 'Fulfillment for ' + opp1.Order_Type__c + ' license';
                        fulfilment.termStartDate = opp1.Start_Date__c != NULL ? (String.valueOf(opp1.Start_Date__c)) : '';
                        fulfilment.termEndDate = opp1.End_Date__c != NULL ? (String.valueOf(opp1.End_Date__c)) : '';
                        fulfilment.grantType = grantList ;
                        fulfilment.bundle = oli.product2.name != NULL ? oli.product2.name : '';
                        orderItem.fulfillment = fulfilment;
                        orderItemList.add( orderItem );
                    }
                }
                oppWrapperRecord.orderedItem = orderItemList;
                oppIdToWrapperMap.put( opp1.id, oppWrapperRecord );
            }
            
            if ( !oppIdToWrapperMap.isEmpty() ) {
                for ( Id oppId : oppIdToWrapperMap.keySet() ) {
                    opportunityStrJSON = JSON.serialize(oppIdToWrapperMap.get( oppId ));
                    opportunityStrJSON = opportunityStrJSON.removeStart('[');
                    opportunityStrJSON = opportunityStrJSON.removeEnd(']');
                    opportunityStrJSON = opportunityStrJSON.replace('currency_temp','currency');

                    //Parsing the JSON and sending it to the order hub
                    if(String.isNotBlank(opportunityStrJSON)){
                        Set<Id> newOppIdSet = new Set<Id>();
                        newOppIdSet.add( oppId );
                        TF_OrderHubWebServiceCallout.createOrder(opportunityStrJSON, newOppIdSet);
                    }
                }
            }
        }
    }*/
}