global class TF_AddAccountImpl {
    
    public enum AddressType {billing,shipping, mailing}
    public enum IdentifierType {ringGoldId,name,domain,id,sfid}
    public enum RelationshipType {child,parent}
    global class organization {
        public List<Organisation> organisations;
    }
    global class Organisation {
        public AccountSettings accountSettings;
        public List<AddressList> addressList;
        public String comments;
        public String description;
        public Boolean isTestOrg;
        public String isni;
        public String isniName;
        public String name;
        public String organisationType;
        public String parentRingGoldId;
        public String partyId;
        public String partySfdcId;
        public List<Relationship> relationships;
        public String ringGoldId;
        public String sfdcCategory;
        public String sfdcClassification;
        public String sfdcEnrollment;
        public String sfdcLegalSubcategory;
        public Integer sfdcNumberOfEmployees;
        public String sfdcType;
        public Integer sourceOrgId;
        public String url;
    }
    global class AddressList {
        public String addressEndDate;
        public Integer addressId;
        public String addressLine1;
        public String addressLine2;
        public String addressLine3;
        public String addressStartDate;
        public AddressType addressType;
        public String bpBusinessPartnerCategory;
        public String bpNumber;
        public String bpPartnerFunction;
        public String city;
        public String contactType;
        public String country;
        public String countryCode;
        public String emailAddress;
        public String firstName;
        public String lastName;
        public String postalCode;
        public String province;
        public String state;
        public String taxNumberCategory;
        public String taxRegistrationNumber;
        public String telephone;
        public String title;
        public String usStateCode;
    }
    global class Relationship {
        public IdentifierType identifierType;
        public String identifierValue;
        public String objectType;
        public RelationshipType relationshipType;
    }
    global class AccountSettings {
        public string Setting;
    }
    private static List<account> insertAccountList;
    private static List<account> updateAccountList;
    private static map<id,string> childAccountUpdateMap;
    
    /**
    * Add or Update the Account
    **/
    public static void addOrUpdateAccount(String jsonStr){
        system.debug('Test');
        organization addOrganisationRequest=(organization)JSON.deserialize(jsonStr,organization.class);
     
        //TF_CustomerService.CustomerResponse response = new TF_CustomerService.CustomerResponse();
        insertAccountList = new List<Account>();
        updateAccountList = new List<Account>();
        for(integer i =0;i<addOrganisationRequest.organisations.size();i++){
            
            if(addOrganisationRequest.organisations[i].ringGoldId!= null && addOrganisationRequest.organisations[i].ringGoldId.toLowerCase().contains('bucket')){
                setOrgTypeBucketAccount(addOrganisationRequest.organisations[i]);    
            }  
            
            Set<Id> accIdSet = getAccountID(addOrganisationRequest.organisations[i]);
            if(accIdSet == null || accIdSet.size() == 0){
                Account acc = new Account();
                system.debug('addAccountCall'); 
                addAccount(addOrganisationRequest.organisations[i],acc);                                                               
            }
            else{                                
                system.debug('updateAccountCall');
                Account existingaccount = [select id from Account where id in:accIdSet limit 1];
                updateAccount(addOrganisationRequest.organisations[i],existingAccount);
            }
            
        }
        if(insertAccountList !=null && insertAccountList.size()>0){
            system.debug(insertAccountList);
            insert insertAccountList;
        }
        if(updateAccountList !=null && updateAccountList.size()>0){
        update updateAccountList;
        }
        updateChildAccount();
    }
    
    /**
    * Update child account
    **/
    public static void updateChildAccount(){
        if (childAccountUpdateMap != null && !childAccountUpdateMap.isEmpty()){
            List<account>  updateChildList = new List<account>(); 
            for (Id key : childAccountUpdateMap.keySet()) {
                Account childAccount = [select id,name from account where id =: key limit 1];
                string str = childAccountUpdateMap.get(key);
                Account  parentAccount = [select id,name,Ringgold_Account_ID__c from account where Ringgold_Account_ID__c =:str limit 1];
                
                childAccount.ParentId=parentAccount.id;
                updateChildList.add(childAccount);   
            }
            system.debug('updateChild');
            update updateChildList;
        }
    }
    
    /**
    * Set OrganisationType for Bucket account
    **/
    public static void setOrgTypeBucketAccount(Organisation org){
        org.organisationType= 'anonymous';
        org.addressList=null;
        system.debug('setOrgTypeBucketAccount'+org);
    }
    
    /**
    * Add new Account
    **/
    public static void addAccount(Organisation org,Account Acc){
        system.debug('AddAccountMethod');
        insertPartyIfNot(org, acc);
        insertOrganization(org, acc);
        if(org.addressList != null)
        insertOrganizationAddress(org, acc);
        insertOrganizationHierarchy(org, acc);
        insertAccountList.add(acc);
    } 
    
    /**
    * Update Account
    **/
     public static void updateAccount(Organisation org,Account existingAccount){
         system.debug('updateAccountMethod');  
         //updateParty(org,existingAccount);                  
         updateOrganization(org,existingAccount);
         updateOrganizationAddress(org,existingAccount);
         updateOrgHierarchy(org,existingAccount);
         updateAccountList.add(existingAccount);
     }
    
    /**
    * Copy the Organisations party details from inputJSON to Account object
    **/
    public static void insertPartyIfNot(Organisation org, Account acc){
        acc.Customer_Id__c = org.partyId;    
    }        
    
    /**
    * Copy the Organisations details from inputJSON to Account object
    **/
    public static void insertOrganization(Organisation org, Account acc){
        system.debug('insertOrganisation');
        RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Account' AND Name='T&F - Accounts' ];
        acc.RecordtypeId = rt.Id;
        if(org.accountSettings != null){
            acc.Account_Settings__c = org.accountSettings.setting;
        }  
        
        acc.Description = org.description;
        acc.Name = org.name;
        acc.Ringgold_Account_ID__c = org.ringGoldId;
        acc.Website = org.url;
        acc.Category__c = org.sfdcCategory;
        acc.NumberOfEmployees = org.sfdcNumberOfEmployees;
        acc.Classification__c = org.sfdcClassification;
        //acc.Type = org.sfdcType;
        acc.Legal_SubCategory__c = org.sfdcLegalSubcategory;
        acc.Type = org.organisationType;
        system.debug(acc);
    }
    
    /**
    * Copy the Organisations address details from inputJSON to Account object
    **/
    public static void insertOrganizationAddress(Organisation org, Account acc){
        for(integer i=0;i<org.addressList.size();i++){
            if(org.addressList[i].addressType == AddressType.shipping){
                system.debug('shipping');
                acc.Shipping_City__c = org.addressList[i].city;
                acc.Shipping_ZIP_Postal_Code__c = org.addressList[i].postalCode;
                acc.ShippingState = org.addressList[i].state;
                acc.Shipping_Country_List__c = org.addressList[i].country;
                acc.Shipping_State_List__c = org.addressList[i].province;
                string str ='';
                str+=org.addressList[i].addressLine1; 
                str+=org.addressList[i].addressLine2;
                str+=org.addressList[i].addressLine3;
                acc.Shipping_Street__c = str;
            }
            if (org.addressList[i].addressType == AddressType.billing){
                system.debug('billing');
                acc.Billing_City__c = org.addressList[i].city;
                acc.Billing_ZIP__c = org.addressList[i].postalCode;
                acc.Billing_State__c = org.addressList[i].state;
                acc.Billing_Country_List__c = org.addressList[i].country;
                acc.Billing_State_List__c = org.addressList[i].province;
                string str ='';
                str+=org.addressList[i].addressLine1; 
                str+=org.addressList[i].addressLine2;
                str+=org.addressList[i].addressLine3;
                acc.Billing_Street__c = str;
            }
        }
    }
    
    /**
    * Insert the Organisations hierarchy details from inputJSON to Account object
    **/
    public static void insertOrganizationHierarchy(Organisation org, Account acc){
        system.debug('insertParent');
        if(org.relationships != null && org.relationships.size() > 0){
        for(integer i=0;i<org.relationships.size();i++){
            List<id> parentIdList =new List<id>();
            if(org.relationships[i].relationshipType == RelationshipType.parent){
                set<id> parentIdSet = getAccountIDFromRelationship(org);
                parentIdList.addAll(parentIdSet);
                system.debug(parentIdList); 
                acc.ParentId=parentIdList[0];
                system.debug('parent');                
            }
            if(org.relationships[i].relationshipType == RelationshipType.child){
                childAccountUpdateMap = new map<id,string>();
                set<id> childIdSet = getAccountIDFromRelationship(org);
                List<id> childIdList = new List<id>();
                childIdList.addAll(childIdSet);
                childAccountUpdateMap.put(childIdList[0],org.ringGoldId);    
            }
        }
        }
    }
    
    /*public static void updateParty(Organisation org,Account existingAccount){
        
    }*/
    
     /**
    * Update the Organisations details from inputJSON to Account object
    **/
    public static void updateOrganization(Organisation org,Account existingAccount){
        insertOrganization(org, existingAccount);
    }
    
    /**
    * Update the Organisations address details from inputJSON to Account object
    **/
    public static void updateOrganizationAddress(Organisation org,Account existingAccount){
        //Set<Id> accIdSet = getAccountID(org);   
        insertOrganizationAddress(org, existingAccount);    
    }
    
    /**
    * Update the Organisations hierarchy details from inputJSON to Account object
    **/
    public static void updateOrgHierarchy(Organisation org,Account existingAccount){
        insertOrganizationHierarchy(org, existingAccount);
    }
    
    /**
    * Fetch Account ID based on type(salesforceid, party id, name or Ringgold) and input paramter from relationship
    **/
    private static Set<Id> getAccountIDFromRelationship(Organisation org) {
        String accountSoql = 'select id from account where ';
        Set<Id> accIdSet = new Set<Id>();
        for(Relationship relationship : org.relationships){
                if(IdentifierType.sfid == relationship.identifierType){
                    accountSoql = accountSoql + ' id =\''+ relationship.identifierValue + '\' OR ';
                }
                if(IdentifierType.id == relationship.identifierType){
                    accountSoql = accountSoql + ' Customer_Id__c =\''+ relationship.identifierValue + '\' OR ';
                }
                if(IdentifierType.ringGoldId == relationship.identifierType){
                    accountSoql = accountSoql + ' Ringgold_Account_ID__c =\''+ relationship.identifierValue + '\' OR ';
                }
                if(IdentifierType.name == relationship.identifierType){
                    accountSoql = accountSoql + ' Name =\''+ relationship.identifierValue + '\' OR ';
                }
                if(IdentifierType.domain == relationship.identifierType){
                    accountSoql = accountSoql + ' domain =\''+ relationship.identifierValue + '\' OR ';
                }
                
            }        
        
        try{
            List<Account> accList = database.query(accountSoql.substring(0,(accountSoql.trim()).length() - 3 ));
            system.debug('@@@@@@'+accList);
            if(accList != null && accList.size() > 0){
                for(Account account : accList){
                    accIdSet.add(account.id);
                }
            }            
        }
        catch(exception e){
            system.debug(e.getMessage());
        } 
        return accIdSet;     
    }
    
    /**
    * Fetch Account ID based on type(Ringgold, partyId, name) and input paramter from organisation
    **/
    private static Set<Id> getAccountID(Organisation org) {
        String accountSoql = 'select id from account where ';
        Set<Id> accIdSet = new Set<Id>();
        
                if(!String.IsEmpty(org.ringGoldId)){
                    accountSoql = accountSoql + ' Ringgold_Account_ID__c =\''+ org.ringGoldId + '\' OR ';
                }
                else if(!String.IsEmpty(org.partyId)){
                    accountSoql = accountSoql + ' Customer_Id__c =\''+ org.partyId + '\' OR ';
                }
                else if(!String.IsEmpty(org.name)){
                    accountSoql = accountSoql + ' Name =\''+ org.name + '\' OR ';
                }      
        try{
            List<Account> accList = database.query(accountSoql.substring(0,(accountSoql.trim()).length() - 3 ));
            system.debug('@@@@@@'+accList);
            if(accList != null && accList.size() > 0){
                for(Account account : accList){
                    accIdSet.add(account.id);
                }
            }            
        }
        catch(exception e){
            system.debug(e.getMessage());
        } 
        return accIdSet;     
    }
        
   
}