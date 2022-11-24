/************************************************************************************
    //This is handler class for trigger "TF_CreateLicenseJSON_Tgr"
    //This class is to create License JSON after a license get created in Salesforce.
    //Created by Vikas Varshney for POF-182 on dated 04-10-2018
    //Test coverage "zTest_TF_CreateLicenseJSON_Tgr"
    //Modified by Vikas Varshney for POF-261 on dated 15-10-2018
    //Modified by Vikas Varshney for POF-264 on dated 16-10-2018
    //Modified by Vikas Varshney for POF-604 on dated 12-11-2018
    //Modified by Shefali Arora for POF-646 on dated 22-11-2018
    //Modified by Vikas Varshney for POF-545 on dated 18-Dec-2018
    //Modified by Shefali Arora for POF-785 on 08-02-2019
    //Modified by Vikas Varshney for LMS-181 on dated 25th July, 2019
    //Modified by Vikas Varshney for LMS-251 on dated 06th September, 2019
    //Modified by Vikas Varshney for LMS-329 on dated 22nd Oct, 2019
    //Modified by Vikas Varshney for LMS-170 on dated 14th November, 2019
    //Modified by Vikas Varshney for LMS-278 on dated 09th December, 2019
    //Modified by Vikas Varshney for LMS-433 on dated 11th December, 2019
    //Modified by Vikas Varshney for UBXC-118 on dated 29th January, 2020
    //Modified by Vikas Varshney for UBXC-221 on dated 14th April, 2020 - CHG0037788
    //Modified by Vikas Varshney for UBXC-222 on dated 15th May, 2020 - CHG0038868
    //Modified by Vikas Varshney for UBX-306 on dated 16th April, 2020
    //Modified by Vikas Varshney for UBX-920 on dated 02nd June, 2020
    //Modified by Vikas Varshney for UBX-1187 on dated 11th June, 2020
    //Modified by Vikas Varshney for UBX-2876 on dated 27th July, 2020
    //Modified by Vikas Varshney for UBX-4971 on dated 4th August, 2020
    //Modified by Vikas Varshney for UBX-4976 on dated 6th August, 2020
    //Modified by Vikas Varshney for UBX-12715 on dated 26th August, 2020
    //Modified by Vikas Varshney for UBX-4879 on dated 01st Sep, 2020
    //Modified by Vikas Varshney for UBX-13873 on dated 25th Sep, 2020
************************************************************************************/

public with sharing class TF_CreateLicenseJSON_Tgr implements TriggerInterface_License.Runnable {
    public String licenseStrJSON = '';
    public Boolean afterFlag = false;
    public Boolean insertFlag = false;
    public Boolean updateFlag = false;
    public Boolean deleteFlag = false;
    public List<LicenseWrapper> licenseWrapperList = new List<LicenseWrapper>();
    public Map<Id, License__c> licenseOldMap = new Map<Id, License__c>();
    public List<LicenseWrapperNew> blankList = new List<LicenseWrapperNew>();
    public List<LicenseDeleteWrapper> licenseDeleteWrapperList = new List<LicenseDeleteWrapper>();
    public List<LicenseWrapper> nonActiveLicenseWrapperList = new List<LicenseWrapper>();
    public Map<Id, Case> existingLicIdToCaseMap = new Map<Id, Case>();

    public void run(TriggerInterface_License.Trig trig) {
        Set<Id> licenseIdSet = new Set<Id>();
        List<License__c> licenseList = new List<License__c>();
        Set<Id> delLicenseIdSet = new Set<Id>();
        Set<Id> beforeLicenseIdSet = new Set<Id>();
        Map<Id, Case> beforeExistingLicIdToCaseMap = new Map<Id, Case>();
        Set<Id> hasPartLicenseIdSet = new Set<Id>();
        Map<Id, Boolean> licIdToErrorFlagMap = new Map<Id, Boolean>();

        //to show an error
        if ( trig.isBefore && ( trig.isUpdate || trig.isDelete ) ) {
            for ( License__c beforeLic : trig.oldList ) {
                beforeLicenseIdSet.add( beforeLic.id );
                if ( trig.isBefore && trig.isUpdate ) {
                    if ( trig.oldMap.get( beforeLic.id ).Entitlement_Creation_Status__c != trig.newMap.get( beforeLic.id ).Entitlement_Creation_Status__c
                        || trig.oldMap.get( beforeLic.id ).Entitlement_Request_Status__c != trig.newMap.get( beforeLic.id ).Entitlement_Request_Status__c ) {
                        licIdToErrorFlagMap.put( beforeLic.id, false );
                    }
                } else {
                    licIdToErrorFlagMap.put( beforeLic.id, true );
                }
            }

            if ( !beforeLicenseIdSet.isEmpty() ) {
                beforeExistingLicIdToCaseMap = findLicenseCase( beforeLicenseIdSet );
            }

            List<License__c> errorLicList = new List<License__c>();
            if ( trig.isBefore && trig.isUpdate ) {
                errorLicList = trig.newList;
            } else if ( trig.isBefore && trig.isDelete ) {
                errorLicList = trig.oldList;
            }
            
            if ( !beforeExistingLicIdToCaseMap.isEmpty() ) {
                for ( License__c beforLic : errorLicList ) {
                    if ( beforeExistingLicIdToCaseMap.containsKey( beforLic.id ) && !TF_LicenseStaticBatch.licenseStaticFlag && licIdToErrorFlagMap.containsKey(beforLic.id) ) {
                        if ( licIdToErrorFlagMap.get( beforLic.id ) ) {
                            beforLic.addError('Before updating the License ' + beforLic.name + ' (Id = ' + beforLic.id +') close its existing case.');
                        }
                    }
                }
            }
        }
        
        //UBX-4971 to track grant type values
        Map<String, License__c> clonedLicIdToNewLicMap = new Map<String, License__c>();
        if ( trig.isBefore && trig.isInsert ) {
            for ( License__c licBeforeInsert : trig.newList ) {
                licBeforeInsert.Grant_Type_Traceable__c = licBeforeInsert.Grant_Type__c; //UBX-4971
                if ( licBeforeInsert.isClone() ) { //UBX-4976
                    String clonedLicenseId = '';
                    clonedLicenseId = licBeforeInsert.getCloneSourceId();
                    if ( String.isNotBlank(clonedLicenseId) ) {
                        clonedLicIdToNewLicMap .put(clonedLicenseId, licBeforeInsert);
                    }
                }
            }
            
            //getting cloned license list
            if ( !clonedLicIdToNewLicMap.isEmpty() ) {
                //List<License__c> clonedLicenseList = new List<License__c>();
                //All non-editable fields on all page layouts need to add in this query and map them accordingly
                //clonedLicenseList = ;
                for ( License__c clonedLic : [ SELECT id, Customer__c, Contact__c, Product__c, Purchase_Date__c FROM License__c WHERE id IN:clonedLicIdToNewLicMap.keySet() ] ) {
                    if ( clonedLic.Customer__c != NULL ) {
                        clonedLicIdToNewLicMap.get(clonedLic.id).Customer__c = clonedLic.Customer__c;
                    }
                    if ( clonedLic.Contact__c != NULL ) {
                        clonedLicIdToNewLicMap.get(clonedLic.id).Contact__c = clonedLic.Contact__c;
                    }
                    if ( clonedLic.Product__c != NULL ) {
                        clonedLicIdToNewLicMap.get(clonedLic.id).Product__c = clonedLic.Product__c;
                    }
                    if ( clonedLic.Purchase_Date__c != NULL ) {
                        clonedLicIdToNewLicMap.get(clonedLic.id).Purchase_Date__c = clonedLic.Purchase_Date__c;
                    }
                }
            }
            System.debug('clonedLicIdToNewLicMap =====>' + clonedLicIdToNewLicMap);
        }
        
        //to set fields "Entitlement Creation Status" & "Entitlement Request Status" as "Initiated" before sending request to SQS
        if ( trig.isBefore && trig.isUpdate ) {
            for ( License__c lic : trig.newList ) {
                if ( trig.oldMap.get( lic.id ).License_Type__c != lic.License_Type__c 
                        || trig.oldMap.get( lic.id ).Grant_Type__c != lic.Grant_Type__c
                        || ( trig.oldMap.get( lic.id ).Status__c != lic.Status__c && !'Deactivated'.equalsIgnoreCase(trig.oldMap.get( lic.id ).Status__c) && 'Deactivated'.equalsIgnoreCase(lic.Status__c) )
                        || trig.oldMap.get( lic.id ).Start_Date__c != lic.Start_Date__c
                        || trig.oldMap.get( lic.id ).End_Date__c != lic.End_Date__c ) {
                    if ( trig.oldMap.get( lic.id ).Start_Date__c == lic.Start_Date__c
                        && trig.oldMap.get( lic.id ).End_Date__c == lic.End_Date__c) {
                        lic.Entitlement_Creation_Status__c = 'Initiated';
                        lic.Entitlement_Request_Status__c = 'Initiated';
                    }
                    
                    //UBX-4971 to track grant type values
                    if ( trig.oldMap.get( lic.id ).Grant_Type__c != lic.Grant_Type__c ) {
                        lic.Grant_Type_Traceable__c = lic.Grant_Type__c;
                    }
                    
                    if ( lic.End_Date__c <= lic.Start_Date__c ) {
                        lic.addError('Please enter End Date greater than Start Date');
                    }
                    if ( trig.oldMap.get( lic.id ).Start_Date__c != lic.Start_Date__c && lic.Start_Date__c < Date.today() ) {
                        lic.addError('Please enter future Start Date');
                    }
                    if ( trig.oldMap.get( lic.id ).End_Date__c != lic.End_Date__c && lic.End_Date__c <= Date.today() ) {
                        lic.addError('Please enter future End Date');
                    }
                }
                
                Boolean checkLicenseType = true;
                if ( trig.oldMap.get( lic.id ).Update_Type__c != lic.Update_Type__c && 'Static'.equalsIgnoreCase(lic.Update_Type__c) && lic.Dynamic_License_End_Date__c != NULL && !TF_LicenseStaticBatch.licenseStaticFlag ) {
                //if ( 'Static'.equalsIgnoreCase(lic.Update_Type__c) && lic.Dynamic_License_End_Date__c != NULL && ( trig.oldMap.get( lic.id ).status__c == lic.status__c ) && ( trig.oldMap.get( lic.id ).Entitlement_Creation_Status__c == lic.Entitlement_Creation_Status__c ) && !TF_LicenseStaticBatch.licenseStaticFlag ) {
                    //lic.addError('Dynamic License End Date should only be specified for "Dynamic" License Type. Please clear the field and then save!'); //UBX-4879
                    lic.addError('Dynamic License End Date should only be specified for "Dynamic" License Type. Either choose the license type as "Dynamic" or clear the Dynamic License End Date field if the license type is "Static"!');
                } else if ( lic.Dynamic_License_End_Date__c != NULL && ( trig.oldMap.get( lic.id ).Dynamic_License_End_Date__c != lic.Dynamic_License_End_Date__c ) && 'Static'.equalsIgnoreCase(lic.Update_Type__c) && !TF_LicenseStaticBatch.licenseStaticFlag ) {
                    lic.addError('Dynamic License End Date should only be specified for "Dynamic" License Type. Either choose the license type as "Dynamic" or clear the Dynamic License End Date field if the license type is "Static"!');
                } else if ( ( trig.oldMap.get( lic.id ).Dynamic_License_End_Date__c != lic.Dynamic_License_End_Date__c ) && lic.Dynamic_License_End_Date__c < Date.today() ) {
                    lic.addError('Dynamic License End Date should be greater than the current date and less than or equal to the End Date!');
                } else if ( ( trig.oldMap.get( lic.id ).Dynamic_License_End_Date__c != NULL ) && ( lic.Dynamic_License_End_Date__c == NULL ) && 'Dynamic'.equalsIgnoreCase(lic.Update_Type__c) ) {
                    lic.addError('Please enter Dynamic License End Date for "Dynamic" License Type!');
                } else if ( ( trig.oldMap.get( lic.id ).Dynamic_License_End_Date__c != lic.Dynamic_License_End_Date__c ) && ( !'Active'.equalsIgnoreCase(lic.Status__c) ) && !TF_LicenseStaticBatch.licenseStaticFlag ) {
                    lic.addError('Dynamic License End Date can\'t be changed as license\'s status is not active');
                } else if ( lic.Start_Date__c != NULL && lic.Dynamic_License_End_Date__c != NULL && lic.Dynamic_License_End_Date__c < lic.Start_Date__c ) {
                    lic.addError('Dynamic License End Date should be greater than the current date and less than or equal to the End Date!');
                } else if ( lic.End_Date__c != NULL && lic.Dynamic_License_End_Date__c != NULL && lic.Dynamic_License_End_Date__c > lic.End_Date__c ) {
                    lic.addError('Dynamic License End Date should be greater than the current date and less than or equal to the End Date!'); //UBX-4879
                } /*else if ( trig.oldMap.get( lic.id ).Update_Type__c != lic.Update_Type__c && 'Static'.equalsIgnoreCase(lic.Update_Type__c) && lic.Dynamic_License_End_Date__c != NULL ) {
                    lic.addError('Dynamic License End Date should only be specified for "Dynamic" License Type. Please clear the field and then save!'); //UBX-4879
                }*/ else if ( ( trig.oldMap.get( lic.id ).Dynamic_License_End_Date__c != lic.Dynamic_License_End_Date__c ) && ( 'Active'.equalsIgnoreCase(lic.Status__c) ) ) {
                    lic.Stop_Alert_Msg__c = false;
                    lic.Update_Type__c = 'Static';
                    checkLicenseType = false;
                } else if ( checkLicenseType && ( trig.oldMap.get( lic.id ).Update_Type__c != lic.Update_Type__c ) && 'Static'.equalsIgnoreCase( trig.oldMap.get( lic.id ).Update_Type__c ) && 'Dynamic'.equalsIgnoreCase( lic.Update_Type__c ) && !TF_LicenseStaticBatch.licenseStaticFlag ) { //UBXC-221 modification
                    //lic.addError('License Type can\'t be changed alone. You should extend dynamic license end date.');
                    lic.addError('Please enter Dynamic License End Date for "Dynamic" License Type!');
                } 
            }
        }
        
        //Iterating license list to get license Id set
        if ( trig.isAfter && trig.isInsert ) {
            if ( !trig.newList.isEmpty() ) {
                for ( License__c lic : trig.newList ) {
                    licenseIdSet.add( lic.id );
                }
            }
        } else if ( trig.isAfter && trig.isUpdate ) {
            if ( !trig.newList.isEmpty() ) {
                for ( License__c lic : trig.newList ) {
                    if ( trig.oldMap.get( lic.id ).License_Type__c != lic.License_Type__c 
                        || trig.oldMap.get( lic.id ).Grant_Type__c != lic.Grant_Type__c
                        || ( trig.oldMap.get( lic.id ).Status__c != lic.Status__c && !'Deactivated'.equalsIgnoreCase(trig.oldMap.get( lic.id ).Status__c) && 'Deactivated'.equalsIgnoreCase(lic.Status__c) ) ) {
                        //|| trig.oldMap.get( lic.id ).Start_Date__c != lic.Start_Date__c
                        //|| trig.oldMap.get( lic.id ).End_Date__c != lic.End_Date__c ) {
                        if ( !TF_LicenseExpirationBatch.stopLicenseTriggerFlag ) {
                            licenseIdSet.add( lic.id );
                        }
                    }
                    
                    if ( (trig.oldMap.get( lic.id ).Dynamic_License_End_Date__c != lic.Dynamic_License_End_Date__c) && ( 'Active'.equalsIgnoreCase(lic.Status__c) ) && lic.Dynamic_License_End_Date__c != NULL && 'Static'.equalsIgnoreCase(lic.Update_Type__c) ) { //this part is to send has part update to EMS for UBXC-222
                        hasPartLicenseIdSet.add( lic.id );
                    }
                }
            }
        } else if ( trig.isBefore && trig.isDelete ) {
            for ( License__c delLic : trig.oldList ) {
                delLicenseIdSet.add( delLic.id );
            }
        }
        
        if ( !hasPartLicenseIdSet.isEmpty() ) {
            hasPartLicenseFlow( hasPartLicenseIdSet );
        }
        
        //Creating a license list if license id set is not null
        if ( !licenseIdSet.isEmpty() ) {
            existingLicIdToCaseMap = findLicenseCase( licenseIdSet );
            licenseList = [ SELECT id, name, Customer__c, Customer__r.Type, Customer__r.Ringgold_Account_ID__c, Customer__r.Customer_Id__c, Update_Type__c, Product__c, Product__r.Hub_Id__c, Order_Number__c, License_Type__c, Grant_Type__c, Start_Date__c, End_Date__c, Status__c, Contact__c, Contact__r.Party_Id__c, RecordType.Name, Access_Scope__c FROM License__c WHERE id IN:licenseIdSet ];
        }
        
        afterFlag = trig.isAfter;
        insertFlag = trig.isInsert;
        updateFlag = trig.isUpdate;
        deleteFlag = trig.isDelete;
        licenseOldMap = trig.oldMap;
        
        List<License__c> licenseList2 = new List<License__c>();
        List<License__c> extraLicenseList = new List<License__c>();
        if ( !licenseList.isEmpty() ) {
            licenseList2.addAll( licenseList );
            licenseList.clear();
            licenseList.add( licenseList2[0] );
        }
        
        if ( !licenseList2.isEmpty() ) {
            for ( integer i = 1; i < licenseList2.size(); i++ ) {
                extraLicenseList.add( licenseList2[i] );
            }
        }
        
        if ( !extraLicenseList.isEmpty() ) {
            extraLicenseExecution( extraLicenseList );
        }
        
        try {
            if ( !licenseList.isEmpty() ) {
                licenseJSONCreation( licenseList );
            }
            
            if ( !delLicenseIdSet.isEmpty() ) {
                existingLicIdToCaseMap.putAll( findLicenseCase( delLicenseIdSet ) );
                deleteLicenseJSON( delLicenseIdSet );
            }
        } catch ( Exception ex ) {
            System.debug('************ License Trigger Exception ************');
            System.debug(ex.getMessage());
        }
    }
    
    //method to create a JSON on license creation and updation and passing the same to call Entitlement to get the response
    public void licenseJSONCreation ( List<License__c> licenseList ) {
        licenseWrapperList = new List<LicenseWrapper>();
        Set<Id> licenseIdSet = new Set<Id>();
        nonActiveLicenseWrapperList = new List<LicenseWrapper>();
        Set<Id> nonActiveLicenseIdSet = new Set<Id>();

        //Creating a JSON string for license object if license list is not null
        if ( !licenseList.isEmpty() ) {
            for ( License__c lic : licenseList ) {
                licenseIdSet.add( lic.id );
                List<String> grantList = new List<String>();
                
                if ( lic.Grant_Type__c != NULL ) {
                    if ( lic.Grant_Type__c.contains(';') )
                        grantList = lic.Grant_Type__c.split(';');
                    else
                        grantList.add( lic.Grant_Type__c );
                }

                if ( afterFlag && insertFlag ) {
                    LicenseWrapper licenseWrapperRecord = new LicenseWrapper();
                    licenseWrapperRecord.type = 'AddLicense';
                    licenseWrapperRecord.licenseId = lic.id;
                    if ( lic.RecordType.Name == 'T&F Account License' ) {
                        if ( lic.Customer__c != NULL ) {
                            //licenseWrapperRecord.salesforceAccountID = (lic.Customer__c != NULL) ? lic.Customer__c : '';
                            licenseWrapperRecord.salesforceAccountID = lic.Customer__c;
                        } else {
                            licenseWrapperRecord.salesforceAccountID = '';
                        }
                    } else {
                        licenseWrapperRecord.salesforceAccountID = '';
                    }
                    licenseWrapperRecord.productId = (lic.Product__c != NULL && lic.Product__r.Hub_Id__c <> NULL) ? lic.Product__r.Hub_Id__c : '';
                    licenseWrapperRecord.orderNumber = lic.Order_Number__c != NULL ? lic.Order_Number__c : '';
                    licenseWrapperRecord.addMember = blankList;
                    licenseWrapperRecord.removeMember = blankList;
                    licenseWrapperRecord.licenseType = lic.License_Type__c != NULL ? lic.License_Type__c : '';
                    licenseWrapperRecord.grantType = grantList;
                    licenseWrapperRecord.startDate = lic.Start_Date__c != NULL ? String.valueOf( lic.Start_Date__c ) : '';
                    licenseWrapperRecord.endDate = lic.End_Date__c != NULL ? String.valueOf( lic.End_Date__c ) : '';
                    //licenseWrapperRecord.status = lic.Status__c != NULL ? lic.Status__c : '';
                    licenseWrapperRecord.status = ( lic.Status__c != NULL && 'In progress'.equalsIgnoreCase(lic.Status__c) ) ? 'Active' : ( lic.Status__c != NULL ? lic.Status__c : '' );
                    licenseWrapperRecord.customerType = ( lic.Customer__c != NULL && 'Consortium'.equalsIgnoreCase(lic.Customer__r.Type) && ( lic.RecordType.Name == 'T&F Account License' || String.isBlank(lic.RecordType.Name) ) ) ? 'Consortium' : ( ( lic.Customer__c != NULL && !'Consortium'.equalsIgnoreCase(lic.Customer__r.Type) && ( lic.RecordType.Name == 'T&F Account License' || String.isBlank(lic.RecordType.Name) ) ) ? 'B2B' : ( ( lic.Contact__c != NULL && lic.RecordType.Name == 'T&F Individual License' ) ? 'Individual' : '' ) );
                    if ( lic.RecordType.Name == 'T&F Account License' )
                        licenseWrapperRecord.ringgoldID = lic.Customer__c != NULL && lic.Customer__r.Ringgold_Account_ID__c <> NULL ? lic.Customer__r.Ringgold_Account_ID__c : '';
                    else
                        licenseWrapperRecord.ringgoldID = '';
                    licenseWrapperRecord.partyID = ( lic.Customer__c != NULL && lic.Customer__r.Customer_Id__c != NULL && ( lic.RecordType.Name == 'T&F Account License' || String.isBlank(lic.RecordType.Name) ) ) ? lic.Customer__r.Customer_Id__c : ( ( lic.Contact__c != NULL && lic.Contact__r.Party_Id__c != NULL && lic.RecordType.Name == 'T&F Individual License' ) ? lic.Contact__r.Party_Id__c : '' );
                    licenseWrapperRecord.updateType = lic.Update_Type__c != NULL ? lic.Update_Type__c : '' ;
                    licenseWrapperRecord.licenseName = lic.name;
                    licenseWrapperRecord.accessScope = String.isBlank(lic.Access_Scope__c) ? 'Global' : lic.Access_Scope__c;
                    licenseWrapperList.add(licenseWrapperRecord);
                }
                
                if ( afterFlag && updateFlag ) {
                    if ( licenseOldMap.get( lic.id ).License_Type__c != lic.License_Type__c 
                        || licenseOldMap.get( lic.id ).Grant_Type__c != lic.Grant_Type__c
                        || ( licenseOldMap.get( lic.id ).Status__c != lic.Status__c && !'Deactivated'.equalsIgnoreCase(licenseOldMap.get( lic.id ).Status__c) && 'Deactivated'.equalsIgnoreCase(lic.Status__c) ) ) {
                        //|| licenseOldMap.get( lic.id ).Start_Date__c != lic.Start_Date__c
                        //|| licenseOldMap.get( lic.id ).End_Date__c != lic.End_Date__c ) {
                        LicenseWrapper licenseWrapperRecord = new LicenseWrapper();
                        licenseWrapperRecord.type = 'UpdateLicense';
                        licenseWrapperRecord.licenseId = lic.id;
                        if ( lic.RecordType.Name == 'T&F Account License' )
                            licenseWrapperRecord.salesforceAccountID = ( lic.RecordType.Name == 'T&F Account License' && lic.Customer__c != NULL ) ? lic.Customer__c : '' ;
                        else
                            licenseWrapperRecord.salesforceAccountID = '';
                        licenseWrapperRecord.productId = lic.Product__r.Hub_Id__c <> NULL ? lic.Product__r.Hub_Id__c : '';
                        licenseWrapperRecord.orderNumber = lic.Order_Number__c <> NULL ? lic.Order_Number__c : '';
                        licenseWrapperRecord.addMember = blankList;
                        licenseWrapperRecord.removeMember = blankList;
                        licenseWrapperRecord.licenseType = lic.License_Type__c != NULL ? lic.License_Type__c : '';
                        licenseWrapperRecord.grantType = grantList;
                        licenseWrapperRecord.startDate = lic.Start_Date__c != NULL ? String.valueOf( lic.Start_Date__c ) : '';
                        //licenseWrapperRecord.endDate = lic.End_Date__c != NULL ? String.valueOf( lic.End_Date__c ) : '';
                        //licenseWrapperRecord.status = lic.Status__c != NULL ? lic.Status__c : '';
                        licenseWrapperRecord.endDate = ( licenseOldMap.containsKey(lic.id) && licenseOldMap.get( lic.id ).License_Type__c != lic.License_Type__c && 'Subscription'.equalsIgnoreCase(licenseOldMap.get( lic.id ).License_Type__c) && 'Perpetual'.equalsIgnoreCase(lic.License_Type__c) ? '' : ( lic.End_Date__c != NULL ? String.valueOf( lic.End_Date__c ) : '' ) );
                        //licenseWrapperRecord.status = ( licenseOldMap.containsKey(lic.id) && licenseOldMap.get( lic.id ).End_Date__c != lic.End_Date__c && 'Expired'.equalsIgnoreCase(lic.Status__c) ) ? 'Active' : ( ( licenseOldMap.containsKey(lic.id) && licenseOldMap.get( lic.id ).License_Type__c != lic.License_Type__c && 'Subscription'.equalsIgnoreCase(licenseOldMap.get( lic.id ).License_Type__c) && 'Perpetual'.equalsIgnoreCase(lic.License_Type__c) && 'Expired'.equalsIgnoreCase(lic.Status__c) ) ? 'Active' : ( ( licenseOldMap.containsKey(lic.id) && licenseOldMap.get( lic.id ).License_Type__c != lic.License_Type__c && 'Perpetual'.equalsIgnoreCase(licenseOldMap.get( lic.id ).License_Type__c) && 'Subscription'.equalsIgnoreCase(lic.License_Type__c) && 'Expired'.equalsIgnoreCase(lic.Status__c) ) ? 'Active' : ( lic.Status__c != NULL ? lic.Status__c : '' )));
                        licenseWrapperRecord.status = ( lic.Status__c != NULL && 'Deactivated'.equalsIgnoreCase(lic.Status__c) ? 'Deactivated' : ( lic.Status__c != NULL ? 'Active' : '' ) );
                        licenseWrapperRecord.customerType = ( lic.Customer__c != NULL && 'Consortium'.equalsIgnoreCase(lic.Customer__r.Type) && ( lic.RecordType.Name == 'T&F Account License' || String.isBlank(lic.RecordType.Name) ) ) ? 'Consortium' : ( ( lic.Customer__c != NULL && !'Consortium'.equalsIgnoreCase(lic.Customer__r.Type) && ( lic.RecordType.Name == 'T&F Account License' || String.isBlank(lic.RecordType.Name) ) ) ? 'B2B' : ( ( lic.Contact__c != NULL && lic.RecordType.Name == 'T&F Individual License' ) ? 'Individual' : '' ) );
                        if ( lic.RecordType.Name == 'T&F Account License' )
                            licenseWrapperRecord.ringgoldID = ( lic.RecordType.Name == 'T&F Account License' && lic.Customer__c != NULL && lic.Customer__r.Ringgold_Account_ID__c <> NULL ) ? lic.Customer__r.Ringgold_Account_ID__c : '';
                        else
                            licenseWrapperRecord.ringgoldID = '';
                        licenseWrapperRecord.partyID = ( lic.Customer__c != NULL && lic.Customer__r.Customer_Id__c != NULL && ( lic.RecordType.Name == 'T&F Account License' || String.isBlank(lic.RecordType.Name) ) ) ? lic.Customer__r.Customer_Id__c : ( ( lic.Contact__c != NULL && lic.Contact__r.Party_Id__c != NULL && lic.RecordType.Name == 'T&F Individual License' ) ? lic.Contact__r.Party_Id__c : '' );
                        licenseWrapperRecord.updateType = lic.Update_Type__c != NULL ? lic.Update_Type__c : '' ;
                        licenseWrapperRecord.licenseName = lic.name;
                        licenseWrapperRecord.accessScope = String.isBlank(lic.Access_Scope__c) ? 'Global' : lic.Access_Scope__c;
                        if ( !existingLicIdToCaseMap.containsKey(lic.id) ) {
                            licenseWrapperList.add( licenseWrapperRecord );
                        } else {
                            nonActiveLicenseIdSet.add( lic.id );
                            nonActiveLicenseWrapperList.add( licenseWrapperRecord );
                        }
                    }
                }
            }
        }

        //Serializing JSON if license wrapper list is not null
        if ( !licenseWrapperList.isEmpty() ) {
            licenseStrJSON = JSON.serialize(licenseWrapperList);
            if ( licenseWrapperList.size() == 1 ) {
                licenseStrJSON = licenseStrJSON.removeStart('[');
                licenseStrJSON = licenseStrJSON.removeEnd(']');
            }
        }
        
        if ( !nonActiveLicenseWrapperList.isEmpty() ) {
            String nonActiveLicenseJsonString = '';
            nonActiveLicenseJsonString = JSON.serialize(nonActiveLicenseWrapperList);
            nonActiveLicenseJsonString = nonActiveLicenseJsonString.removeStart('[');
            nonActiveLicenseJsonString = nonActiveLicenseJsonString.removeEnd(']');
            
            if ( String.isNotBlank(nonActiveLicenseJsonString) && !nonActiveLicenseIdSet.isEmpty() ) {
                //queueUpdateRequest( nonActiveLicenseIdSet, nonActiveLicenseJsonString, 'License is not Active', 'Outbound Failure', 'Update' );
                Map<Id, Case> failedLicIdToCaseMap = new Map<Id, Case>();
                failedLicIdToCaseMap = TF_AsyncSQSJob.returnLicIdToCaseMap( nonActiveLicenseIdSet, 'License failed to send request to EMS' );
                
                if ( !failedLicIdToCaseMap.isEmpty() ) {
                    TF_AsyncSQSJob.createExceptionLog( nonActiveLicenseJsonString, failedLicIdToCaseMap, 'License failed to send request to EMS' );
                }
            }
        }
        
        /*if ( String.isNotBlank( licenseStrJSON ) && licenseStrJSON.containsIgnoreCase('B2B') ) {
            TF_LicenseAPIService.stopLicenseServiceApiCall = false;
        }*/
        
        //Passing JSON request and license id set to component if it is having some value
        //if ( String.isNotBlank( licenseStrJSON ) && !TF_LicenseExpirationBatch.stopLicenseTriggerFlag && !TF_LicenseAPIService.stopLicenseServiceApiCall ) {
        if ( String.isNotBlank( licenseStrJSON ) && !TF_LicenseExpirationBatch.stopLicenseTriggerFlag ) {
            TF_AsyncSQSJob.callingSQSQueue( licenseStrJSON, licenseIdSet, insertFlag, updateFlag, deleteFlag );
        }
    }
    
    //method to send notification to SQS upon license deletion
    public void deleteLicenseJSON ( Set<Id> deletLicenseIdSet ) {
        List<License__c> delLicenseList = new List<License__c>();
        String delLicenseJSONStr = '';
        
        if ( !deletLicenseIdSet.isEmpty() ) {
            delLicenseList = [ SELECT id, Customer__c, Customer__r.Type, Customer__r.Ringgold_Account_ID__c, Customer__r.Customer_Id__c, Product__c, Product__r.Hub_Id__c, Order_Number__c, License_Type__c, Grant_Type__c, Start_Date__c, End_Date__c, Status__c, Contact__c, Contact__r.Party_Id__c, RecordType.Name FROM License__c WHERE id IN:deletLicenseIdSet ];
        }
        
        if ( !delLicenseList.isEmpty() ) {
            for ( License__c delLicense : delLicenseList ) {
                LicenseDeleteWrapper delLicenseWrapperRecord = new LicenseDeleteWrapper();
                delLicenseWrapperRecord.type = 'DeleteLicense';
                delLicenseWrapperRecord.licenseId = delLicense.id;
                if ( delLicense.RecordType.Name == 'T&F Account License' )
                    delLicenseWrapperRecord.salesforceAccountID = delLicense.Customer__c != NULL ? delLicense.Customer__c : '' ;
                else
                    delLicenseWrapperRecord.salesforceAccountID = '';
                if ( delLicense.RecordType.Name == 'T&F Account License' )
                    delLicenseWrapperRecord.ringgoldID = delLicense.Customer__c != NULL && delLicense.Customer__r.Ringgold_Account_ID__c <> NULL ? delLicense.Customer__r.Ringgold_Account_ID__c : '';
                else
                    delLicenseWrapperRecord.ringgoldID = '';
                delLicenseWrapperRecord.partyID = ( delLicense.Customer__c != NULL && delLicense.Customer__r.Customer_Id__c != NULL && ( delLicense.RecordType.Name == 'T&F Account License' || String.isBlank(delLicense.RecordType.Name) ) ) ? delLicense.Customer__r.Customer_Id__c : ( ( delLicense.Contact__c != NULL && delLicense.Contact__r.Party_Id__c != NULL && delLicense.RecordType.Name == 'T&F Individual License' ) ? delLicense.Contact__r.Party_Id__c : '' );
                delLicenseWrapperRecord.productId = delLicense.Product__c != NULL && delLicense.Product__r.Hub_Id__c <> NULL ? delLicense.Product__r.Hub_Id__c : '';
                delLicenseWrapperRecord.customerType = ( delLicense.Customer__c != NULL && 'Consortium'.equalsIgnoreCase(delLicense.Customer__r.Type) && ( delLicense.RecordType.Name == 'T&F Account License' || String.isBlank(delLicense.RecordType.Name) ) ) ? 'Consortium' : ( ( delLicense.Customer__c != NULL && !'Consortium'.equalsIgnoreCase(delLicense.Customer__r.Type) && ( delLicense.RecordType.Name == 'T&F Account License' || String.isBlank(delLicense.RecordType.Name) ) ) ? 'B2B' : ( ( delLicense.Contact__c != NULL && delLicense.RecordType.Name == 'T&F Individual License' ) ? 'Individual' : '' ) );
                licenseDeleteWrapperList.add( delLicenseWrapperRecord );
            }
        }
        
        //Serializing JSON 
        if ( !licenseDeleteWrapperList.isEmpty() ) {
            delLicenseJSONStr = JSON.serialize(licenseDeleteWrapperList);
            delLicenseJSONStr = delLicenseJSONStr.removeStart('[');
            delLicenseJSONStr = delLicenseJSONStr.removeEnd(']');
        }
        
        //Passing JSON request and license id set to component if it is having some value
        if ( String.isNotBlank( delLicenseJSONStr ) ) {
            TF_AsyncSQSJob.callingSQSQueue( delLicenseJSONStr, deletLicenseIdSet, false, false, true );
        }
    }
    
    public void extraLicenseExecution ( List<License__c> licList ) {
        Set<License__c> licenseSet = new Set<License__c>();
        licenseSet.clear();
        List<License__c> first45LicenseList = new List<License__c>();
        List<License__c> licenseSett = new List<License__c>();
        Map<Id, License__c> licIdToLiccMap = new Map<Id, License__c>();
        Decimal futureCalloutSize = 0;
        if ( !licList.isEmpty() ) {
            licenseSet.addAll( licList );
        }
        if ( !licenseSet.isEmpty() ) {
            futureCalloutSize = Math.ceil( (Decimal)licenseSet.size()/50 );
        }
        
        integer sizee = 0;
        if ( futureCalloutSize != 0 ) {
            sizee = (integer)futureCalloutSize;
            integer firstCount = 0;
            for ( integer i = 0; i < sizee; i++ ) {
                integer secondCount = 0;
                firstCount += 1;
                for ( License__c lic : licenseSet ) {
                    secondCount += 1;
                    licIdToLiccMap.put( lic.id, lic );
                    if ( secondCount == 50 ) {
                        break;
                    }
                }
                String issFlag = '';
                issFlag = ( insertFlag == true ) ? 'isInsert' : ( updateFlag == true ) ? 'isUpdate' : '';
                if ( !TF_LicenseExpirationBatch.stopLicenseTriggerFlag ) {
                    bulkLicenseSQSFutureCallout( licIdToLiccMap.keySet(), issFlag );
                } else {
                    bulkLicenseSQSCallout( licIdToLiccMap.keySet(), issFlag );
                }
                
                //removing licenses from main license set
                licenseSet.removeAll( licIdToLiccMap.values() );
                if ( !Test.isRunningTest() ) {
                    licIdToLiccMap.clear();
                }
                
                if ( firstCount == 25 ) {
                    break;
                }
            }
        }
    }
    
    @future(callout=true)
    public static void bulkLicenseSQSFutureCallout ( Set<Id> licensIdSet, String isFlaag ) {
        bulkLicenseSQSCallout( licensIdSet, isFlaag );
    }
    
    public static void bulkLicenseSQSCallout ( Set<Id> licenseIdSet, String isFlag ) {
        List<License__c> licenseList = new List<License__c>();
        List<LicenseWrapperNew> blankWrapperList = new List<LicenseWrapperNew>();
        Map<Id, String> licIdToJsonMap = new Map<Id, String>();
        List<License__c> licensesHistoryUpdateList = new List<License__c>();
        Map<Id, String> licIdToResponseErrorMap = new Map<Id, String>();
        List<License__c> licensesUpdateList = new List<License__c>();
        Map<Id, Case> failedLicIdToCaseMap = new Map<Id, Case>();
        Map<Id, Case> existngLicIdToCaseMap = new Map<Id, Case>();
        
        if ( !licenseIdSet.isEmpty() ) {
            existngLicIdToCaseMap = findLicenseCase( licenseIdSet );
        }
        
        if ( String.isBlank(isFlag) ) {
            isFlag = 'isUpdate';
        }
        
        if ( !licenseIdSet.isEmpty() ) {
            licenseList = [ SELECT id, name, Customer__c, Customer__r.Type, Customer__r.Ringgold_Account_ID__c, Customer__r.Customer_Id__c, Update_Type__c, Product__c, Product__r.Hub_Id__c, Order_Number__c, License_Type__c, Grant_Type__c, Start_Date__c, End_Date__c, Status__c, Contact__c, Contact__r.Party_Id__c, RecordType.Name, Entitlement_Request_Status__c, Entitlement_Creation_Status__c, Access_Scope__c FROM License__c WHERE id IN:licenseIdSet ];
        }

        if ( !licenseList.isEmpty() ) {
            for ( License__c licnse : licenseList ) {
                if ( licnse.Entitlement_Creation_Status__c != 'Initiated' ) {
                    licnse.Entitlement_Creation_Status__c = 'Initiated';
                }
                if ( licnse.Entitlement_Request_Status__c != 'Initiated' ) {
                    licnse.Entitlement_Request_Status__c = 'Initiated';
                }
                licensesHistoryUpdateList.add( licnse );
            }
        }
        
        if ( !licenseList.isEmpty() ) {
            for ( License__c lic : licenseList ) {
                HttpResponse awsResponse = new HttpResponse();
                List<String> grantList = new List<String>();
                
                if ( lic.Grant_Type__c != NULL ) {
                    if ( lic.Grant_Type__c.contains(';') )
                        grantList = lic.Grant_Type__c.split(';');
                    else
                        grantList.add( lic.Grant_Type__c );
                }

                LicenseWrapper licenseWrapperRecord = new LicenseWrapper();
                licenseWrapperRecord.type = ( 'isInsert'.equalsIgnoreCase(isFlag) ) ? 'AddLicense' : ( 'isUpdate'.equalsIgnoreCase(isFlag) ) ? 'UpdateLicense' : 'UpdateLicense';
                licenseWrapperRecord.licenseId = lic.id;
                if ( lic.RecordType.Name == 'T&F Account License' ) {
                    if ( lic.Customer__c != NULL ) {
                        licenseWrapperRecord.salesforceAccountID = lic.Customer__c;
                    } else {
                        licenseWrapperRecord.salesforceAccountID = '';
                    }
                } else {
                    licenseWrapperRecord.salesforceAccountID = '';
                }
                licenseWrapperRecord.productId = (lic.Product__c != NULL && lic.Product__r.Hub_Id__c <> NULL) ? lic.Product__r.Hub_Id__c : '';
                licenseWrapperRecord.orderNumber = lic.Order_Number__c != NULL ? lic.Order_Number__c : '';
                licenseWrapperRecord.addMember = blankWrapperList;
                licenseWrapperRecord.removeMember = blankWrapperList;
                licenseWrapperRecord.licenseType = lic.License_Type__c != NULL ? lic.License_Type__c : '';
                licenseWrapperRecord.grantType = grantList;
                licenseWrapperRecord.startDate = lic.Start_Date__c != NULL ? String.valueOf( lic.Start_Date__c ) : '';
                //licenseWrapperRecord.endDate = lic.End_Date__c != NULL ? String.valueOf( lic.End_Date__c ) : '';
                //licenseWrapperRecord.status =  ( ( TF_LicenseExpirationBatch.stopLicenseTriggerFlag ) ? 'Expired' : ( ( 'isInsert'.equalsIgnoreCase(isFlag) ) ? 'Active' : ( lic.Status__c != NULL ? lic.Status__c : '' ) ) );
                licenseWrapperRecord.endDate = ( lic.License_Type__c != NULL && 'Perpetual'.equalsIgnoreCase(lic.License_Type__c) ) ? '' : ( lic.End_Date__c != NULL ? String.valueOf( lic.End_Date__c ) : '' );
                licenseWrapperRecord.status =  ( ( TF_LicenseExpirationBatch.stopLicenseTriggerFlag ) ? 'Expired' : ( ( 'isInsert'.equalsIgnoreCase(isFlag) ) ? 'Active' : ( lic.Status__c != NULL && 'Deactivated'.equalsIgnoreCase(lic.Status__c) ? 'Deactivated' : ( ( lic.Status__c != NULL ? 'Active' : '' ) ) ) ) );
                licenseWrapperRecord.customerType = ( lic.Customer__c != NULL && 'Consortium'.equalsIgnoreCase(lic.Customer__r.Type) && ( lic.RecordType.Name == 'T&F Account License' || String.isBlank(lic.RecordType.Name) ) ) ? 'Consortium' : ( ( lic.Customer__c != NULL && !'Consortium'.equalsIgnoreCase(lic.Customer__r.Type) && ( lic.RecordType.Name == 'T&F Account License' || String.isBlank(lic.RecordType.Name) ) ) ? 'B2B' : ( ( lic.Contact__c != NULL && lic.RecordType.Name == 'T&F Individual License' ) ? 'Individual' : '' ) );
                if ( lic.RecordType.Name == 'T&F Account License' )
                    licenseWrapperRecord.ringgoldID = lic.Customer__c != NULL && lic.Customer__r.Ringgold_Account_ID__c <> NULL ? lic.Customer__r.Ringgold_Account_ID__c : '';
                else
                    licenseWrapperRecord.ringgoldID = '';
                licenseWrapperRecord.partyID = ( lic.Customer__c != NULL && lic.Customer__r.Customer_Id__c != NULL && ( lic.RecordType.Name == 'T&F Account License' || String.isBlank(lic.RecordType.Name) ) ) ? lic.Customer__r.Customer_Id__c : ( ( lic.Contact__c != NULL && lic.Contact__r.Party_Id__c != NULL && lic.RecordType.Name == 'T&F Individual License' ) ? lic.Contact__r.Party_Id__c : '' );
                licenseWrapperRecord.updateType = lic.Update_Type__c != NULL ? lic.Update_Type__c : '' ;
                licenseWrapperRecord.licenseName = lic.name;
                licenseWrapperRecord.accessScope = String.isBlank(lic.Access_Scope__c) ? 'Global' : lic.Access_Scope__c;
                licIdToJsonMap.put( lic.id, JSON.serialize(licenseWrapperRecord) );
                if ( !existngLicIdToCaseMap.containsKey(lic.id) && licIdToJsonMap.containsKey(lic.id) ) {
                    awsResponse = TF_AsyncSQSJob.postNotificationsToSNS(licIdToJsonMap.get(lic.id));
                }
                
                if ( Test.isRunningTest() ) {
                    awsResponse = NULL;
                }
                
                if ( awsResponse != NULL && awsResponse.getStatusCode() == 200 ) {
                    lic.Entitlement_Request_Status__c = 'Requested';
                    lic.Entitlement_Creation_Status__c = 'Initiated';
                    if ( !'Deactivated'.equalsIgnoreCase(lic.Status__c) )
                        lic.Status__c = 'License created successfully, Entitlement Creation in progress';
                } else {
                    lic.Entitlement_Request_Status__c = 'Failed';
                    lic.Entitlement_Creation_Status__c = 'Initiated';
                    lic.Status__c = 'License created successfully, EMS request failed';
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
                    if ( String.isBlank(result) ) {
                        result = 'License insert or update failed';
                    }
                    licIdToResponseErrorMap.put( lic.id, result );
                }
                licensesUpdateList.add( lic );
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
        
        if ( !licensesUpdateList.isEmpty() ) {
            try {
                update licensesUpdateList;
            } catch ( Exception ex ) {
                System.debug('************ Update DML Exception ************');
                System.debug(ex.getMessage());
            }
        }
        
        if ( !licIdToResponseErrorMap.isEmpty() ) {
            failedLicIdToCaseMap = returnLicIdToCaseMap( licIdToResponseErrorMap );
        }
        
        if ( !failedLicIdToCaseMap.isEmpty() ) {
            createLicenseExceptionLog( licIdToJsonMap, failedLicIdToCaseMap, licIdToResponseErrorMap);
        }
    }
    
    public static Map<Id, Case> returnLicIdToCaseMap ( Map<Id, String> licenseIdToErrorMap ) {
        Id caseRecordTypeId;
        Map<Id, Case> caseIdToCaseMap;
        Set<String> licStringSet = new Set<String>();
        Map<Id, Case> licIdToCaseMap = new Map<Id, Case>();
        Map<Id, Case> licIdToCaseInsertMap = new Map<Id, Case>();
        
        try {
            if ( !licenseIdToErrorMap.isEmpty() ) {
                for ( Id licId : licenseIdToErrorMap.keySet() ) {
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
        
        if ( !licenseIdToErrorMap.isEmpty() ) {
            for ( Id liccId : licenseIdToErrorMap.keySet() ) {
                if ( !licIdToCaseMap.containsKey(liccId) ) {
                    Case caseInsert = new Case();
                    caseInsert.RecordTypeId = caseRecordTypeId != NULL ? caseRecordTypeId : '';
                    caseInsert.Status = 'New';
                    caseInsert.Priority = 'Low';
                    caseInsert.Application__c = 'License and Entitlement';
                    caseInsert.Type = 'Outbound Failure';
                    caseInsert.Origin = 'Other';
                    caseInsert.Subject = 'License creation or updation failed in Entitlement Hub for license : ' + liccId;
                    caseInsert.Description = 'An error occurred in License record. Error message: ' + licenseIdToErrorMap.get(liccId);
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
    
    public static void createLicenseExceptionLog ( Map<Id, String> licIdToJsonMap, Map<Id, Case> licnseIdToCaseMap, Map<Id, String> licIdToErrorMap ) {
        List<Exception_Log__c> exceptionLogList = new List<Exception_Log__c>();

        try {
            if ( !licnseIdToCaseMap.isEmpty() ) {
                for ( Id licId : licnseIdToCaseMap.keySet() ) {
                    Exception_Log__c exceptionLogInsert = new Exception_Log__c();
                    exceptionLogInsert.ownerId = UserInfo.getUserId();
                    exceptionLogInsert.Object_ID__c = licId;
                    exceptionLogInsert.Object_Type__c = 'License';
                    exceptionLogInsert.Error_Type__c = 'Outbound';
                    exceptionLogInsert.Error_message__c = ( !licIdToErrorMap.isEmpty() && licIdToErrorMap.containsKey(licId) ) ? licIdToErrorMap.get(licId) : '';
                    exceptionLogInsert.Type_of_Action__c = ( !licIdToJsonMap.isEmpty() && licIdToJsonMap.containsKey(licId) && licIdToJsonMap.get(licId).contains('AddLicense') ) ? 'Insert' : ( ( !licIdToJsonMap.isEmpty() && licIdToJsonMap.containsKey(licId) && ( licIdToJsonMap.get(licId).contains('UpdateLicense') || licIdToJsonMap.get(licId).contains('HasPartUpdate') ) ? 'Update' : '' ) );
                    exceptionLogInsert.Request_JSON__c = ( !licIdToJsonMap.isEmpty() && licIdToJsonMap.containsKey(licId) ) ? licIdToJsonMap.get(licId) : '';
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
    
    public static Map<Id, Case> findLicenseCase ( Set<Id> licnseIdSet ) {
        Id caseRecordTypeId;
        Map<Id, Case> caseIdToCaseMap;
        Set<String> licStringSet = new Set<String>();
        Map<Id, Case> licIdToCaseMap = new Map<Id, Case>();

        try {
            caseRecordTypeId = [ SELECT id, name FROM RecordType WHERE sObjectType = 'Case' AND Name = 'Salesforce Internal Support' LIMIT 1 ].id;
            if ( !licnseIdSet.isEmpty() ) {
                for ( Id licId : licnseIdSet ) {
                    licStringSet.add('%'+licId+'%');
                }
            }

            if ( !licStringSet.isEmpty() ) {
                try {
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
        
        return licIdToCaseMap;
    }
    
    //CHG0038868
    public void hasPartLicenseFlow ( Set<Id> licIdsSet ) { // this method is to send S3 notification to EMS whenever dynamic license end date is extended
        List<License__c> hasPartLicenseList = new List<License__c>();
        Map<String, Set<License__c>> hubIdToLicenseSetMap = new Map<String, Set<License__c>>(); //Initializing map of product hub id and its license ids list
        Map<String, String> hubIdToJSONMap = new Map<String, String>(); //Initializing map of product hub id and its json of license ids list
        List<License__c> licListUpdate = new List<License__c>();
        
        if ( !licIdsSet.isEmpty() ) {
            hasPartLicenseList = [ SELECT id, name, License_Type__c, Product__c, Product__r.Hub_Id__c, Update_Type__c, Stop_Alert_Msg__c, Status__c, End_Date__c, customer__c, customer__r.customer_Id__c, Contact__c, Contact__r.party_Id__c, Access_Scope__c, Grant_Type__c, ( SELECT id, Account__c, Account__r.Customer_Id__c FROM License_Memebers__r ) FROM License__c WHERE id IN:licIdsSet ];
        }
        
        Map<String,List<TF_HasPartWrapper.ChildPartyIds>> licIdToChildPartyIdsListMap = new Map<String,List<TF_HasPartWrapper.ChildPartyIds>>();
        if ( !hasPartLicenseList.isEmpty() ) {
            for ( License__c lic : hasPartLicenseList ) {
                if ( lic.Product__c !=  NULL && String.isNotBlank(lic.Product__r.Hub_Id__c) ) {
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
                List<TF_HasPartWrapper.licenseDetails> licenseWrapperList = new List<TF_HasPartWrapper.licenseDetails>();
                
                if ( !hubIdToLicenseSetMap.get( hubId ).isEmpty() ) {
                    for ( License__c licDetail : hubIdToLicenseSetMap.get( hubId ) ) {
                        TF_HasPartWrapper.licenseDetails licenseDetailList = new TF_HasPartWrapper.licenseDetails();
                        List<TF_HasPartWrapper.ChildPartyIds> childPartyBlankList = new List<TF_HasPartWrapper.ChildPartyIds>();
                        List<String> grantList = new List<String>();
                
                        if ( licDetail.Grant_Type__c != NULL ) {
                            if ( licDetail.Grant_Type__c.contains(';') )
                                grantList = licDetail.Grant_Type__c.split(';');
                            else
                                grantList.add( licDetail.Grant_Type__c );
                        }
                        
                        licenseDetailList.licenseId = licDetail.id;
                        licenseDetailList.partyId = ( ( licDetail.customer__c != NULL && String.isNotBlank(licDetail.customer__r.customer_Id__c) ? String.valueOf(licDetail.customer__r.customer_Id__c) : ( ( licDetail.contact__c != NULL && String.isNotBlank(licDetail.contact__r.party_Id__c) ) ? String.valueOf(licDetail.contact__r.party_Id__c) : '') ) );
                        licenseDetailList.access_scope = String.isBlank(licDetail.Access_Scope__c) ? 'Global' : licDetail.Access_Scope__c;
                        licenseDetailList.status = 'Active';
                        licenseDetailList.licenseName = licDetail.name; //UBX-12715
                        licenseDetailList.licenseType = licDetail.License_Type__c != NULL ? licDetail.License_Type__c : ''; //UBX-12715
                        if ( licIdToChildPartyIdsListMap.containsKey(licDetail.id) ) { //UBX-12715
                            licenseDetailList.childParties = licIdToChildPartyIdsListMap.get(licDetail.id);
                        } else {
                            licenseDetailList.childParties = childPartyBlankList;
                        }
                        licenseDetailList.grantType = grantList;
                        licenseWrapperList.add( licenseDetailList );
                    }
                    eventJsonRecord.Body.licenses = new List<TF_HasPartWrapper.licenseDetails>();
                    if ( !licenseWrapperList.isEmpty() ) {
                        eventJsonRecord.Body.licenses = licenseWrapperList;
                        hubIdToJSONMap.put( hubId, JSON.serialize(eventJsonRecord) );
                    }
                    licenseWrapperList.clear();
                }
            }
        }
        
        if ( !hubIdToJSONMap.isEmpty() ) {
            TF_License_Update_Event_Tgr_Cls.s3LicenseCalloutAndSNSNotify( hubIdToJSONMap );
        }
        
        if ( !licIdsSet.isEmpty() ) {
            for ( Id licId : licIdsSet ) {
                License__c licUpdate = new License__c();
                licUpdate.id = licId;
                if ( licUpdate.Update_Type__c != 'Dynamic' ) {
                    licUpdate.Update_Type__c = 'Dynamic';
                }
                //if ( licUpdate.Stop_Alert_Msg__c == true ) {
                    //licUpdate.Stop_Alert_Msg__c = false;
                //}
                licListUpdate.add( licUpdate );
            }
        }
        
        if ( !licListUpdate.isEmpty() ) {
            try {
                update licListUpdate;
            } catch ( Exception ex ) {
                System.debug('Exception =====>' + ex.getMessage());
            }
        }
    }
    
    //Wrapper class to store JSON object for license
    public class LicenseWrapper {
        public String type;
        public String licenseId;
        public String salesforceAccountID;
        public String productId;
        public String orderNumber;
        public List<LicenseWrapperNew> addMember;
        public List<LicenseWrapperNew> removeMember;
        public String licenseType;
        public List<String> grantType;
        public String startDate;
        public String endDate;
        public String status;
        public String customerType;
        public String ringgoldID;
        public String partyID;
        public String updateType;
        public String licenseName;
        public String accessScope;
    }
    public class LicenseWrapperNew {
        public String salesforceAccountID;
        public String ringgoldID;
    }
    public class LicenseDeleteWrapper {
        public String type;
        public String licenseId;
        public String salesforceAccountID;
        public String ringgoldID;
        public String partyID;
        public String productId;
        public String customerType;
    }
}