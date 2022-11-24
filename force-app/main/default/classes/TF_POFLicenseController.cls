/*
    * Test class "zTest_TF_POFLicenseController"
    * Modified by Vikas for LMS-249 (Validation error should be corrected for Empty PartyID field) on dated 09th September, 2019
    * Modified by Vikas for LMS-170 on dated 14th November, 2019
*/

public class TF_POFLicenseController {
    @AuraEnabled
    public static Map<Integer, List<Object>> getConsortiumMemebrs(Id licenseID){
        License__c license = [SELECT id, Customer__c FROM License__c WHERE id=:licenseID LIMIT 1];
        List<Account> memebers = [SELECT id, name FROM Account WHERE id in (SELECT Consortium_Member__c FROM TandF_Account_to_Consortium__c WHERE ConsortiumParent__c = :license.Customer__c) Order By Name];
        List<Id> licensedMemebers = new List<Id>();
        for(Account account :  [SELECT id, name FROM Account WHERE id in (SELECT Account__c FROM License_Memeber__c WHERE License__c = :licenseID)]) {
            licensedMemebers.add(account.Id);
        }

        Map<Integer, List<Object>> details = new Map<Integer, List<Object>>();
        details.put(1,memebers);
        details.put(2,licensedMemebers);
        return details;
    } 

    @AuraEnabled
    public static Map<Integer, List<Object>> updateConsortiumMemebers(Id licenseID, List<Id> selectedMembers) {
        Map<id, License_Memeber__c> existingLicenseMemberMap = new Map<id, License_Memeber__c>( [ SELECT id, License__c, Account__c, Account__r.Customer_Id__c, License__r.Customer__c FROM License_Memeber__c WHERE License__c =:licenseID ] ); 
        List<License_Memeber__c> licenseMemberInertList = new List<License_Memeber__c>();
        List<License_Memeber__c> licenseMemberDeleteList = new List<License_Memeber__c>();
        Set<Id> existingMemberIdSet = new Set<Id>();
        Map<Id, Account> accountIdToAccountMap;
        Set<Id> customerIdErrorSet = new Set<Id>();
        String customerIdErrorMessage = '';
        
        Map<Id, Case> existingLicIdToCaseMap = new Map<Id, Case>();
        Set<Id> licenseIdSet = new Set<Id>();
        licenseIdSet.add( licenseID );
        existingLicIdToCaseMap = TF_CreateLicenseJSON_Tgr.findLicenseCase( licenseIdSet );

        if ( selectedMembers.isEmpty() ) {
            accountIdToAccountMap = new Map<Id, Account>();
        } else {
            accountIdToAccountMap = new Map<Id, Account>( [ SELECT id, name, Customer_Id__c FROM Account WHERE id IN:selectedMembers ] );
        }
        
        //Creating a set of existing account of licence member
        if ( !existingLicenseMemberMap.isEmpty() ) {
            for ( License_Memeber__c licMember : existingLicenseMemberMap.values() ) {
                if ( licMember.License__r.Customer__c != NULL ) {
                    existingMemberIdSet.add( licMember.Account__c );
                }
            }
        }
        
        //checking if selected member list is blank but license members are available
        if ( selectedMembers.isEmpty() && !existingLicenseMemberMap.isEmpty() && !existingLicIdToCaseMap.containsKey( licenseID ) ) {
            for ( License_Memeber__c licMember : existingLicenseMemberMap.values() ) {
                licenseMemberDeleteList.add( licMember );
            }
        } else if ( !selectedMembers.isEmpty() && existingLicenseMemberMap.isEmpty() && !existingLicIdToCaseMap.containsKey( licenseID ) ) { //checking selected member list is not empty but existing license member not available
            for ( Id memberId : selectedMembers ) {
                if ( !accountIdToAccountMap.isEmpty() ) {
                    if ( accountIdToAccountMap.containsKey( memberId ) && String.isNotBlank( accountIdToAccountMap.get( memberId ).Customer_Id__c ) ) {
                        License_Memeber__c licMember = new License_Memeber__c();
                        licMember.License__c = licenseID;
                        licMember.Account__c = memberId;
                        licenseMemberInertList.add( licMember );
                    } else if ( accountIdToAccountMap.containsKey( memberId ) && String.isBlank( accountIdToAccountMap.get( memberId ).Customer_Id__c ) ) {
                        customerIdErrorSet.add( memberId );
                    }
                }
            }
        } else if ( !selectedMembers.isEmpty() && !existingLicenseMemberMap.isEmpty() && existingLicenseMemberMap.size() < selectedMembers.size() && !existingLicIdToCaseMap.containsKey( licenseID )  ) { //chehcking exisiting member size is less than selected member size
            for ( Id memberId : selectedMembers ) {
                if ( !accountIdToAccountMap.isEmpty() ) {
                    if ( accountIdToAccountMap.containsKey( memberId ) && String.isNotBlank( accountIdToAccountMap.get( memberId ).Customer_Id__c ) ) {
                        if ( !existingMemberIdSet.contains( memberId ) ) {
                            License_Memeber__c licMember = new License_Memeber__c();
                            licMember.License__c = licenseID;
                            licMember.Account__c = memberId;
                            licenseMemberInertList.add( licMember );
                        }
                    } else if ( accountIdToAccountMap.containsKey( memberId ) && String.isBlank( accountIdToAccountMap.get( memberId ).Customer_Id__c ) ) {
                        customerIdErrorSet.add( memberId );
                    }
                }
            }
        } else if ( !selectedMembers.isEmpty() && !existingLicenseMemberMap.isEmpty() && existingLicenseMemberMap.size() > selectedMembers.size() && !existingLicIdToCaseMap.containsKey( licenseID ) ) { //checking existing license member size is greater than selected member size
            for ( License_Memeber__c licMember : existingLicenseMemberMap.values() ) {
                if ( !selectedMembers.contains( licMember.Account__c ) ) {
                    licenseMemberDeleteList.add( licMember );
                }
            }
        }  else if ( !selectedMembers.isEmpty() && !existingLicenseMemberMap.isEmpty() && selectedMembers.size() == existingLicenseMemberMap.size() && !existingLicIdToCaseMap.containsKey( licenseID ) ) {
            for ( License_Memeber__c licMember : existingLicenseMemberMap.values() ) {
                if ( !selectedMembers.contains( licMember.Account__c ) ) {
                    licenseMemberDeleteList.add( licMember );
                }
            }
            
            for ( Id accId : selectedMembers ) {
                if ( accountIdToAccountMap.containsKey( accId ) && String.isBlank( accountIdToAccountMap.get( accId ).Customer_Id__c ) ) {
                    customerIdErrorSet.add( accId );
                }
            }
        }
        
        //checking list of license member is not empty to insert
        if ( licenseMemberInertList!= null && !licenseMemberInertList.isEmpty() ) {
            insert licenseMemberInertList;
        }
        
        //Checking list of license member is not empty to delete
        if ( !licenseMemberDeleteList.isEmpty() ) {
            delete licenseMemberDeleteList;
        }
        
        List<String> errorStringList = new List<String>();
        if ( !customerIdErrorSet.isEmpty() ) {
            customerIdErrorMessage = customerIdError( customerIdErrorSet, accountIdToAccountMap );
            customerIdErrorMessage = customerIdErrorMessage.removeEnd(', ');
            //customerIdErrorMessage += '. First refresh before adding or removing any member.';
            if ( String.isNotBlank( customerIdErrorMessage ) ) {
                //return customerIdErrorMessage;
                errorStringList.add( customerIdErrorMessage );
            }
        }
        
        List<Id> returnedAccIdList = new List<Id>();
        Set<Id> returnedAccIdSet = new Set<Id>();
        if ( !selectedMembers.isEmpty() ) {
            returnedAccIdSet.addAll( selectedMembers );
            for ( Id accIdd : selectedMembers ) {
                if ( !customerIdErrorSet.isEmpty() && customerIdErrorSet.contains( accIdd ) ) {
                    returnedAccIdSet.remove( accIdd );
                }
            }
        }
        
        if ( !returnedAccIdSet.isEmpty() ) {
            returnedAccIdList.addAll( returnedAccIdSet );
        }
        
        if ( existingLicIdToCaseMap.containsKey( licenseID ) ) {
            if ( !errorStringList.isEmpty() ) {
                errorStringList[0] = 'Before adding or removing any member, close this license existing case.';
            } else {
                errorStringList.add( 'Before adding or removing any member, close this license existing case.' );
            }
        }

        Map<Integer, List<Object>> returnedValuesMap = new Map<Integer, List<Object>>();
        returnedValuesMap.put( 1, errorStringList );
        returnedValuesMap.put( 2, returnedAccIdList );
        
        return returnedValuesMap;

    }
    
    //method to generate error message for accounts not having customer id
    public static String customerIdError ( Set<Id> accountIdErrorSet, Map<Id, Account> accIdToAccountMap ) {
        String errorMessage = 'Members must have customer id.';
        
        if ( !accountIdErrorSet.isEmpty() ) {
            errorMessage += ' The list is : ';
            for ( Id accId : accountIdErrorSet ) {
                //accountIdErrorSet
                if ( !accIdToAccountMap.isEmpty() && accIdToAccountMap.containsKey( accId ) ) {
                    errorMessage += accIdToAccountMap.get( accId ).Name + ', ';
                }
            }
        }
        
        return errorMessage;
        
    }
    @AuraEnabled
    public static Account fetchAccountDetailForLicense(String accountId){
        List<Account> accLst = new List<Account>();
        if(String.isNotBlank(accountId)){
            accLst = [SELECT Name, Type,Customer_Id__c  FROM Account where Id =: accountId Limit 1];
            Account acc = accLst[0];
            return acc;
        }
        return null;
    }
    
    
    @AuraEnabled
    public static Map<Integer, List<Object>> getConsortiumMembersForAccount(Id CustomerId){
        /*if ( String.isNotBlank(CustomerId) ) {
            TF_AccountPartyIdWebServiceCallout.consortiumCallout( CustomerId );
        }*/
        
        List<Account> members = [SELECT id, name,Customer_id__c  FROM Account WHERE id in (SELECT Consortium_Member__c FROM TandF_Account_to_Consortium__c WHERE ConsortiumParent__c = :CustomerId) Order By Name];
        List<Id> licensedMembers = new List<Id>();
        for(Account account :  [SELECT id, name FROM Account WHERE id in (SELECT Account__c FROM License_Memeber__c WHERE Account__c = :CustomerId)]) {
            licensedMembers.add(account.Id);
        }

        Map<Integer, List<Object>> details = new Map<Integer, List<Object>>();
        details.put(1,members);
        details.put(2,licensedMembers);
        return details;
    }
    
    @AuraEnabled
    public static Map<Integer, List<Object>> updateStringConsortiumMemebers(Id licenseID, String selectedMembrsStr) {
        List<String> selectedMembrs=new List<String>();
        List<Id> selectedMembers = new List<Id>();
        List<String> splitList = new List<String>();
        String licenseIdStr = '';
        
        splitList = (List<String>) JSON.deserialize(selectedMembrsStr, List<String>.class);
        
        if ( !splitList.isEmpty() ) {
            for(String str : splitList){
                selectedMembers.add(Id.valueOf( str ));
            }
        }
        
        
        if ( licenseID != NULL && !selectedMembers.isEmpty() ) {
            updateConsortiumMemebers( licenseID, selectedMembers );
        }
        
        return NULL;
    }
    
    @AuraEnabled
    public static Contact fetchContactDetailForLicense(String contactId){
        List<Contact> conLst = new List<Contact>();
        if(String.isNotBlank(contactId)){
            conLst = [SELECT name, Party_Id__c,Email FROM Contact where Id =: contactId Limit 1];
            Contact con = conLst[0];        
            return con;
        }
        return null;
    }
    
    @AuraEnabled
    public static String updateContactPartyIdForLicense(String contactId,String contactEmail){
        String UpdateStatus='';
        if(String.isNotBlank(contactId)&& String.isNotBlank(contactEmail)){
          TF_ContactPartyIdWebServiceCallout.getContactPartyID(contactId,contactEmail); 
        }
        return UpdateStatus;
    }
    
    @AuraEnabled
    public static String getRecordTypeId(String objectName,String recordTypeName){
        String returnRecordTypeName='';
        if(String.isNotBlank(objectName)&&String.isNotBlank(recordTypeName)){
          Id productRecordtypeId = MiscFunctions.getRecordtypeId(objectName,recordTypeName); 
            returnRecordTypeName=String.valueof(productRecordtypeId);
        }
        return returnRecordTypeName;
    }
    
    @AuraEnabled
    public static String updateAccountPartyIdForLicense ( String accountId ) {
        if ( String.isNotBlank(accountId) ) {
            String partyIdReturnedvalue = '';
            partyIdReturnedvalue = TF_AccountPartyIdWebServiceCallout.getAccountPartyID(accountId);
            return partyIdReturnedvalue;
        }
        return '';
    }
    
    /*@AuraEnabled
    public static void updateConsortiumPartyIds ( String accountId ) {
        if ( String.isNotBlank(accountId) ) {
            TF_AccountPartyIdWebServiceCallout.consortiumCallout( accountId );
        }
    }*/
    
    @AuraEnabled
    public static String isUbxAccResponse ( String acountId ) {
        String isUbxResp = 'false';
        
        if ( String.isNotBlank(acountId) ) { //This is done for LMS-251 (Validation error should be corrected for Empty PartyID field)
            Account accRecord = [SELECT id, Name, Customer_id__c FROM Account WHERE id =:acountId LIMIT 1 ];
            if ( String.isBlank(accRecord.Customer_id__c) ) {
                isUbxResp = TF_UBXAccountWebServiceCallout.getAcountPartyID( acountId );
                if ( String.isBlank(isUbxResp) ) {
                    isUbxResp = 'Licence can not be created as account does not have party Id!';
                    return isUbxResp;
                }
            }
        }
        
        if ( String.isNotBlank(acountId) ) {
            if ( TF_UBXAccountWebServiceCallout.getUBXAccountValidation(acountId) ) {
                isUbxResp = 'true';
            } else {
                isUbxResp = 'false';
            }
        }

        return isUbxResp;
    }
}