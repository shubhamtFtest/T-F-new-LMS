public class TF_AddCustomerImpl {
    public static boolean bucketVar;
    /**
     * send the SNS notification to CS 
     **/
        public static String notifyReferenceContact(TF_CustomerService.ContactDetails contact) {
        String partyNumber = getPartyNumber(contact);
        String jsonPayLoad;
        String changeType;
        if(partyNumber != null) {
            changeType ='UPDATE';
        } else {
            partyNumber = string.valueOf(PartyIdIncrementer.getNextPartyId());
            changeType ='CREATE';
        }
        Contact newContact = new Contact();
        copyContactDetails(contact, newContact);
        newContact.Party_Id__c = partyNumber;
        TF_CustomerService.PayLoad payload= new TF_CustomerService.PayLoad();
        TF_CustomerService.ChangeEventHeader header = new TF_CustomerService.ChangeEventHeader();
        header.entityName = 'External-Contact';
        header.changeType = changeType;
        payload.contact = newContact;
        payload.changeEventHeader = header;
        String Json = JSON.serialize(payload);
        awsSendCustomerNotification(Json);
        return partyNumber;
    }
   
    
    /**
    * Add or Update the Contact
    **/
    public static string addOrUpdateContact(TF_CustomerService.ContactDetails contact) {
        String emailID = contact.getEmail(TF_CustomerService.ContactType.primary);
        String accountId;
        if(emailId!=null){
            Contact existingContact = getExistingContact(emailID);
            if(existingContact != null) {
                accountId = updateContact(contact, existingContact);
            } else {
                accountId  = addContact(contact);         
            } 
        }  
        return accountId;
    }
    
    /**
    * Add new Contact
    **/
    private static string addContact(TF_CustomerService.ContactDetails contact) {
        Contact newContact = new Contact();      
        copyContactDetails(contact, newContact);  
        String accountId = newContact.AccountId;
        System.debug('newContact : '+newContact);
        insert newContact;
        List<contact> con = [SELECT id, Party_Id__c FROM Contact WHERE id= :newContact.id limit 1];
        
        Set<Id> accIdSet = getAccountID(contact);
        if(!accIdSet.isEmpty()){
            addOrUpdatePlatformRole(newContact, contact);
        }
        System.debug('con[0].Party_Id__c : '+con[0].Party_Id__c);
        associateContactToAccounts(contact, newContact);
        contact.partyId = con[0].Party_Id__c;
        contact.partySfdcId = newContact.Id; 
        return accountId;
    }
    
    /**
    * Update existing Contact
    **/
    public static string updateContact(TF_CustomerService.ContactDetails contact,Contact existingContact) {
        copyContactDetails(contact,existingContact);
        String accountId = existingContact.AccountId;
        if(existingContact.Party_Id__c == null || existingContact.Party_Id__c == ''){
            existingContact.Party_Id__c = string.valueOf(PartyIdIncrementer.getNextPartyId());
        }
        update existingContact;
        List<contact> con = [SELECT id, Party_Id__c FROM Contact WHERE id= :existingContact.id limit 1];
        
        Set<Id> accIdSet = getAccountID(contact);
        if(!accIdSet.isEmpty()){
            addOrUpdatePlatformRole(existingContact, contact);
        }
        associateContactToAccounts(contact, existingContact);
        contact.partyId = con[0].Party_Id__c;
        contact.partySfdcId = existingContact.Id;    
        return accountId;
    }
    
    /**
    * Copy Cotact details from inputJSON to Contact object
    **/
    private static void copyContactDetails (contact contact, TF_CustomerService.contactList[] contactList) {
        //ContactNumber and email map
        if(contactList != null){
            for(integer i =0;i<contactList.size();i++){
                if(contactlist[i].ContactType==TF_CustomerService.ContactType.primary){
                    contact.email=contactlist[i].email;
                    contact.Phone=contactlist[i].contactNumber;
                }
                else if(contactlist[i].ContactType==TF_CustomerService.ContactType.Alternate){
                    contact.Additional_Email__c=contactlist[i].email;
                    contact.MobilePhone=contactlist[i].contactNumber;
                }
            }
        }
        // If more that 3 Address we need to throw an error... Implementation Required for future.    
    }
    
    /**
    * Copy the contact detaisl from JSON to contact object
    **/
    private static void copyContactDetails(TF_CustomerService.ContactDetails contact, Contact existingContact) {
        RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='contact' AND Name='T&F - Contacts' ];
        existingContact.RecordtypeId=rt.Id; 
        if(contact.dob != null){
            String dob = (contact.dob).replaceAll('[^a-zA-Z0-9\\s+]', '/');
            System.debug('dob'+dob);
            List<String> datePart = dob.split('/');
            Date myDate1 ;
            if(datePart[0].length() == 4){
                myDate1 = date.parse(datePart[1]+'/'+datePart[2]+'/'+datePart[0]);
            }else{
                myDate1 = date.parse(dob);
            }
            System.debug('myDate1'+myDate1);
            existingContact.Birthdate=myDate1;
        }
        if(existingContact.Party_Id__c == null && (contact.partyId != null && contact.partyId != '')){
            existingContact.Party_Id__c = contact.partyId;
        }
        existingContact.LastName=contact.lastName;
        existingContact.FirstName=contact.FirstName;
        existingContact.Status__c='Active';
        existingContact.Business__c='eBooks';
        existingContact.LeadSource='other';
        TF_CustomerService.Preference[] preferences = contact.preferences;
        if(preferences != null && !preferences.isEmpty()) {
            //preference value check added by Renil Rejith on 2022-08-22 to fix email preference bug - https://taylorfrancis.atlassian.net/wiki/spaces/MULESOFT/pages/2766635009/Email+Preference+Update+Bug+in+SF
            if((preferences[0].preferenceName == TF_CustomerService.PreferenceName.opt_out && preferences[0].preferenceValue.equals(String.valueOf(true))) || (preferences[0].preferenceName == TF_CustomerService.PreferenceName.opt_in && preferences[0].preferenceValue.equals(String.valueOf(false)))){
                existingContact.HasOptedOutOfEmail = true;
            }
            else{
                    //added by Renil Rejith on 2022-08-23 to fix email preference bug on Explicit Opt-in scenario.
                    existingContact.Email_Opt_In2__c = true;
                    existingContact.optin_optout_status__c = 'Explicit Opt-In';
                    existingContact.HasOptedOutOfEmail = false;
                }           
         }
        
        if(contact.addressList != null && !(contact.addressList).isEmpty()){
            copyAddressDetails(existingContact,contact.addressList);
        }
        
        if(contact.contactList != null && !(contact.contactList).isEmpty()){
            copyContactDetails(existingContact,contact.contactList);
        }
        
        if(contact.references != null && !(contact.references).isEmpty()){
            copyReferenceDetails(existingContact,contact.references); 
        }
        
        List<Account> accList = getAccount(contact);
        if(accList == null || accList.size() == 0){
            //throw new TF_CustomerService.CustomerServiceException('Account not found in relationship list');
            String bucketAcc = '%'+'Bucket'+'%';
            List<Account> bucketAccList = [select id, Name, (Select id, Name from Contacts) from Account where Name LIKE:bucketAcc ORDER BY CreatedDate DESC limit 1];
            
            if(bucketAccList != null && bucketAccList.size() >0){
                if(bucketAccList[0].Contacts.size() == 10000){
                    
                    Account thisAccount = [SELECT CreatedDate,Id,Name FROM Account WHERE Name LIKE '%Bucket%' ORDER BY CreatedDate DESC NULLS FIRST LIMIT 1];
					String[] accounNameList = (thisAccount.Name).split('-');
					Integer len = accounNameList.size() -1;
					Integer bucketAccNo = Integer.valueOf(accounNameList[len]);
					System.debug('bucketAccNo : '+bucketAccNo);
                    Integer newBAN = bucketAccNo +1;
                    System.debug('new bucketAccNo'+newBAN);

                    Account newBucketAcc = new Account();
                    newBucketAcc.Name = 'Bucket Account-'+newBAN;
                    newBucketAcc.type = 'Agent';
                    insert newBucketAcc; 
                    if(existingContact.AccountId == null){
                    	existingContact.AccountId = newBucketAcc.id;
                    }
                   
                }else{
                    if(existingContact.AccountId == null){
                    	existingContact.AccountId = bucketAccList[0].id;
                    }
                }
            }
         bucketVar = true;  
        }
        else{
            if(existingContact.AccountId == null || (existingContact.Account.Name).contains('Bucket')){
                boolean allBucket = true;
				for(Account thisAcc : accList){
                	if(!(thisAcc.Name).contains('Bucket')){
                    	existingContact.AccountId = thisAcc.id;
                        allBucket = false;
                	}
                }
                if(allBucket){
                    existingContact.AccountId = accList[0].id;
                }
                
            }
        }
    }
    
    /**
    * Copy address details from inputJSON to Contact object
    **/
    private static void copyAddressDetails(Contact contact, TF_CustomerService.Address[] addressList) {
        //TODO : copy all address list to Contact
       
        for(integer i=0;i<addressList.size();i++){
            if(addressList[i].addressType==TF_CustomerService.AddressType.shipping || addressList[i].addressType==TF_CustomerService.AddressType.primary){
                contact.MailingCity=addressList[i].city;
                contact.MailingPostalCode=addressList[i].postalCode;
                contact.Mailingstate=addressList[i].state;
                contact.Mailing_Country_List__c=addressList[i].country;
                contact.Mailing_State_List__c=addressList[i].province;
                string str ='';
                str+=addressList[i].addressLine1; 
                str+=addressList[i].addressLine2;
                str+=addressList[i].addressLine3;
                contact.MailingStreet=str;
            }
            else if (addressList[i].addressType==TF_CustomerService.AddressType.billing || addressList[i].addressType==TF_CustomerService.AddressType.alternate){
                contact.OtherCity=addressList[i].city;
                contact.OtherPostalCode=addressList[i].postalCode;
                contact.Otherstate=addressList[i].state;
                contact.Other_Country_List__c=addressList[i].country;
                contact.Other_State_List__c=addressList[i].province;
                string str ='';
                str+=addressList[i].addressLine1; 
                str+=addressList[i].addressLine2;
                str+=addressList[i].addressLine3;
                contact.OtherStreet=str;
            }
        }  
    }
    private static void copyReferenceDetails(Contact contact, TF_CustomerService.References[] references) {
        //TODO : copy all refercen details into Contact object
        
        for(integer i = 0 ;i<references.size();i++){
            if(references[i].name== TF_CustomerService.ReferenceName.OPENATHENS){
                contact.OPENATHENS_ID__c=references[i].id;   
            }
            if(references[i].name== TF_CustomerService.ReferenceName.SAML){
                contact.SAML_ID__c=references[i].id;
            }
            if(references[i].name== TF_CustomerService.ReferenceName.SHIBBOLETH){
                contact.SHIBBOLETH_ID__c=references[i].id;
            }
            if(references[i].name== TF_CustomerService.ReferenceName.ORCID){
                contact.ORCID__c=references[i].id;
            }
           
        }
    }

    private static void associateContactToAccounts(TF_CustomerService.ContactDetails contact, Contact newContact){
        Set<Id> accIdSet = getAccountID(contact);
        List<AccountContactRelation> accConRelList = new List<AccountContactRelation>();
        if(accIdSet != null && accIdSet.size() > 1){
            List<AccountContactRelation> existingRelations = [Select Id,ContactId,AccountId FROM AccountContactRelation where AccountId IN: accIdSet AND ContactId=: newContact.id];
            for(Id accid : accIdSet){
                boolean acrFound = false;
                if(existingRelations != null && existingRelations.size()>0){
                    for(AccountContactRelation eACR : existingRelations){
                        System.debug('eACR.AccountId ' + eACR.AccountId);
                        System.debug('AccountId ' + accid);
                        if(accid == newContact.AccountId || (eACR.AccountId == accid && eACR.ContactId == newContact.id)){
                            System.debug('acrFound');
                            acrFound = true;
                        }
                    } 
                    if(!acrFound){
                     	AccountContactRelation newAccConRel = new AccountContactRelation();
                    	newAccConRel.ContactId = newContact.id ;
                    	newAccConRel.AccountId = accid;
                        System.debug('newAccConRel:'+newAccConRel);
                    	accConRelList.add(newAccConRel);  
                    }
                }else{
                    if(accid != newContact.AccountId){
                    	AccountContactRelation newAccConRel = new AccountContactRelation();
                    	newAccConRel.ContactId = newContact.id ;
                    	newAccConRel.AccountId = accid;
                    	accConRelList.add(newAccConRel);
                	}
                }
                
            }
        }
        if(accConRelList != null && accConRelList.size() > 0){
            try{
                System.debug('accConRelList : '+accConRelList);
                insert accConRelList;
            }catch(Exception ex){
                throw new TF_CustomerService.CustomerServiceException(ex.getMessage());
            }
        }
    }
    
    /**
    * Fetch Account ID based on type(salesforceid, party id or Ringgold) and input paramter 
    **/
    private static Set<Id> getAccountID(TF_CustomerService.ContactDetails contact) {
        String accountSoql = 'select id from account where ';
        Set<Id> accIdSet = new Set<Id>();
        if(contact.relationships != null && !(contact.relationships).isEmpty()){
            for(TF_CustomerService.Relationship relationship : contact.relationships){
                if(TF_CustomerService.IdentifierType.sfid == relationship.identifierType){
                    accountSoql = accountSoql + ' id =\''+ relationship.identifierValue + '\' OR ';
                }
                if(TF_CustomerService.IdentifierType.id == relationship.identifierType){
                    accountSoql = accountSoql + ' Customer_Id__c =\''+ relationship.identifierValue + '\' OR ';
                }
                if(TF_CustomerService.IdentifierType.ringGoldId == relationship.identifierType){
                    accountSoql = accountSoql + ' Ringgold_Account_ID__c =\''+ relationship.identifierValue + '\' OR ';
                }
                if(TF_CustomerService.IdentifierType.name == relationship.identifierType){
                    accountSoql = accountSoql + ' Name =\''+ relationship.identifierValue + '\' OR ';
                }
                if(TF_CustomerService.IdentifierType.domain == relationship.identifierType){
                    accountSoql = accountSoql + ' domain =\''+ relationship.identifierValue + '\' OR ';
                }
                
            }  
      
        try{
            List<Account> accList = database.query(accountSoql.substring(0,(accountSoql.trim()).length() - 3 ));
            if(accList != null && accList.size() > 0){
                for(Account account : accList){
                    accIdSet.add(account.id);//String.valueOf(account.Id).substring(0, 15);
                }
            }            
        }
            catch(exception e){
                system.debug(e.getMessage()+'****'+e.getLineNumber());
            } 
        }
        return accIdSet;     
    }
    
     /**
    * Fetch Account based on type(salesforceid, party id or Ringgold) and input paramter 
    **/
    private static List<Account> getAccount(TF_CustomerService.ContactDetails contact) {
        String accountSoql = 'select id,name from account where ';
        List<Account> existingAccountList = new List<Account>();
        if(contact.relationships != null && !(contact.relationships).isEmpty()){
            for(TF_CustomerService.Relationship relationship : contact.relationships){
                if(TF_CustomerService.IdentifierType.sfid == relationship.identifierType){
                    accountSoql = accountSoql + ' id =\''+ relationship.identifierValue + '\' OR ';
                }
                if(TF_CustomerService.IdentifierType.id == relationship.identifierType){
                    accountSoql = accountSoql + ' Customer_Id__c =\''+ relationship.identifierValue + '\' OR ';
                }
                if(TF_CustomerService.IdentifierType.ringGoldId == relationship.identifierType){
                    accountSoql = accountSoql + ' Ringgold_Account_ID__c =\''+ relationship.identifierValue + '\' OR ';
                }
                if(TF_CustomerService.IdentifierType.name == relationship.identifierType){
                    accountSoql = accountSoql + ' Name =\''+ relationship.identifierValue + '\' OR ';
                }
                if(TF_CustomerService.IdentifierType.domain == relationship.identifierType){
                    accountSoql = accountSoql + ' domain =\''+ relationship.identifierValue + '\' OR ';
                }
                
            }  
      
        try{
            existingAccountList = database.query(accountSoql.substring(0,(accountSoql.trim()).length() - 3 ));            
        }
            catch(exception e){
                system.debug(e.getMessage()+'****'+e.getLineNumber());
            } 
        }
        return existingAccountList;     
    }
    
    /**
    * Fetch the existing Contact by Email ID
    **/
    private static Contact getExistingContact(String emailID) {
        List<contact> con = [SELECT id, Email,AccountId,Account.Name, Party_Id__c FROM Contact WHERE Email = :emailID limit 1];
        if(con.size()==0 || con==Null){
            return null;
        }
        else
            return con[0];   
    }
    
    private static String getPartyNumber(TF_CustomerService.ContactDetails contact) {
        if(contact.partyId != null && contact.partyId != ''){
            return contact.partyId;
        }
        return null;
    }
    
    @future (callout=true)
    private static void awsSendCustomerNotification(String Json) {
        TF_AWSService awsServie = new TF_AWSService();
        awsServie.sendCustomerNotification(Json);
    }
    
    /**
    * Check the Contact details. 
    **/
    public static void validateContactDetails(TF_CustomerService.ContactDetails contact) {
        if(contact != null && contact.references != null && !contact.references.isEmpty()) {
            throw new TF_CustomerService.CustomerServiceException('Can not create Reference contact in Salesforce'); 
        }
        if(contact != null && contact.addressList != null && contact.addressList.size() > 0){
            //Check for number of addresses for the contact in the request
            if((contact.addressList).size() > 2){
                throw new TF_CustomerService.CustomerServiceException('Contact request can have maximum 2 Addresses');
            }
            if((contact.addressList).size() > 1 && contact.addressList[0].addressType == contact.addressList[1].addressType){
                throw new TF_CustomerService.CustomerServiceException('Contact cannot have more than one Address with Same Address Type');
            }
        } 
        if(contact != null && contact.contactList != null && contact.contactList.size() > 0){
            if((contact.contactList).size() > 2){
                throw new TF_CustomerService.CustomerServiceException('Request can have maximum 2 contacts in contactList');
            }
            if((contact.contactList).size() > 1 && contact.contactList[0].contactType == contact.contactList[1].contactType){
                throw new TF_CustomerService.CustomerServiceException('Both Contacts cannot have the same type');
            }
            for(TF_CustomerService.ContactList thisContacts : contact.contactList) {
                if(thisContacts.email != null && String.isNotBlank(thisContacts.email)) {
                    if(!(isValidEmail(thisContacts.email))){
                        throw new TF_CustomerService.CustomerServiceException('Contact email is invalid');
                    }
                }
            }
        }  
    }
    
    private static Boolean isValidEmail(String emailAddress) {
        String emailRegex = '^[a-zA-Z0-9._}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
        return String.isBlank(emailAddress) ? false : Pattern.compile(emailRegex).matcher(emailAddress).matches();
    }
    
    public static TF_CustomerService.Customer initializeDefaultValue(TF_CustomerService.Customer customerRequest) {
        if(customerRequest.contact.contactList != null && !((customerRequest.contact.contactList).isEmpty()) ){
            for(TF_CustomerService.ContactList thisContact : customerRequest.contact.contactList){
                if(thisContact.contactType == null){
                    thisContact.contactType = TF_CustomerService.ContactType.primary;
                }
            }
        }        
        
        if(customerRequest.contact.addressList != null && !((customerRequest.contact.addressList).isEmpty()) ){
            for(TF_CustomerService.Address thisAddress: customerRequest.contact.addressList){
                if(thisAddress.addressType == null){    
                    thisAddress.addressType = TF_CustomerService.AddressType.billing;
                }
            }
        }
        return customerRequest;
    }
    
     private static void addOrUpdatePlatformRole(Contact thisContact, TF_CustomerService.ContactDetails contact){
        String accountSoql = 'SELECT id, Name, Ringgold_Account_ID__c, Customer_Id__c FROM Account where ';
        List<Platform_Role__c> platformRoleUpdatedList = new List<Platform_Role__c>();
        if(contact.relationships != null && !(contact.relationships).isEmpty()){
            for(TF_CustomerService.Relationship relationship : contact.relationships){
                if(TF_CustomerService.IdentifierType.sfid == relationship.identifierType){
                    accountSoql = accountSoql + ' id =\''+ relationship.identifierValue + '\' OR ';
                }
                if(TF_CustomerService.IdentifierType.id == relationship.identifierType){
                    accountSoql = accountSoql + ' Customer_Id__c =\''+ relationship.identifierValue + '\' OR ';
                }
                if(TF_CustomerService.IdentifierType.ringGoldId == relationship.identifierType){
                    accountSoql = accountSoql + ' Ringgold_Account_ID__c =\''+ relationship.identifierValue + '\' OR ';
                }
                if(TF_CustomerService.IdentifierType.name == relationship.identifierType){
                    accountSoql = accountSoql + ' Name =\''+ relationship.identifierValue + '\' OR ';
                }
                
            }
            List<Account> accountList = database.query(accountSoql.substring(0,(accountSoql.trim()).length() - 3 ));
		 	
            List<Platform_Role__c> platformRoleList = [SELECT id, Name, Account__c,Account__r.Name,Account__r.Customer_Id__c, Account__r.Ringgold_Account_ID__c, Contact__c,Platform__c,Roles__c FROM Platform_Role__c WHERE Contact__c =: thisContact.id ];
           
            for(TF_CustomerService.Relationship relationship : contact.relationships){
                Platform_Role__c thisPlatformRole = new Platform_Role__c();
                boolean addUpdate = true;
                boolean isUpdated = false;
                for(Platform_Role__c platformrole : platformRoleList){
                    String picklistValues = platformrole.Roles__c +';'+ relationship.relationshipType;
                    
                    if(String.isNotBlank(String.valueOf(relationship.identifierValue))){
                        if(TF_CustomerService.IdentifierType.sfid == relationship.identifierType && (String.valueOf(platformrole.Account__c)).substring(0,15) == (String.valueOf(relationship.identifierValue)).substring(0,15)){
                            if( !((platformrole.Roles__c).contains(String.valueOf(relationship.relationshipType)))){
                                thisPlatformRole.id = platformrole.id;
                                thisPlatformRole.Roles__c = picklistValues;
                                platformRoleUpdatedList.add(thisPlatformRole);
                                isUpdated = true;
                            }
                            else{
                                addUpdate = false;
                            }
                        }
                    }else{
                        addUpdate = false;
                    }
                    
                    
                    if(TF_CustomerService.IdentifierType.id == relationship.identifierType && platformrole.Account__r.Customer_Id__c == relationship.identifierValue) {
                       if( !((platformrole.Roles__c).contains(String.valueOf(relationship.relationshipType)))){
                            thisPlatformRole.id = platformrole.id;
                            thisPlatformRole.Roles__c = picklistValues;
                            platformRoleUpdatedList.add(thisPlatformRole);
                            isUpdated = true;
                        }
                        else{
                            addUpdate = false;
                        } 
                    }
                    
                    if(TF_CustomerService.IdentifierType.ringGoldId == relationship.identifierType && platformrole.Account__r.Ringgold_Account_ID__c == relationship.identifierValue){
                        if( !((platformrole.Roles__c).contains(String.valueOf(relationship.relationshipType)))){
                            thisPlatformRole.id = platformrole.id;
                            thisPlatformRole.Roles__c = picklistValues;
                            platformRoleUpdatedList.add(thisPlatformRole);
                            isUpdated = true;
                        }
                        else{
                            addUpdate = false;
                        }
                    }
                    
                    if(TF_CustomerService.IdentifierType.name == relationship.identifierType ){
                        if(platformrole.Account__r.Name == relationship.identifierValue && !((platformrole.Roles__c).contains(String.valueOf(relationship.relationshipType)))){
                            
                            thisPlatformRole.id = platformrole.id;
                            thisPlatformRole.Roles__c = picklistValues;
                            platformRoleUpdatedList.add(thisPlatformRole);
                            isUpdated = true;
                        }
                        else{
                            addUpdate = false;
                        }
                    }
                }
                if(!isUpdated && addUpdate){
                    boolean addPlatformRole = true;
                    Account relationshipAccount = new Account();
                    if(accountList != null && accountList.size() > 0){
                        for(Account thisAccount : accountList){
                            if(TF_CustomerService.IdentifierType.sfid == relationship.identifierType && (String.valueOf(thisAccount.id)).substring(0,15) == (String.valueOf(relationship.identifierValue)).substring(0,15)){
                                relationshipAccount = thisAccount;
                            }
                            
                            if(TF_CustomerService.IdentifierType.id == relationship.identifierType && thisAccount.Customer_Id__c == relationship.identifierValue){
                                relationshipAccount = thisAccount;
                            }
                            if(TF_CustomerService.IdentifierType.ringGoldId == relationship.identifierType && thisAccount.Ringgold_Account_ID__c == relationship.identifierValue){
                                        
                                relationshipAccount = thisAccount;
                            }
                            if(TF_CustomerService.IdentifierType.name == relationship.identifierType && thisAccount.Name == relationship.identifierValue){
                                        
                                relationshipAccount = thisAccount;
                            }

                        }    
                    }
                    if(platformRoleUpdatedList != null && platformRoleUpdatedList.size() > 0){
                        for(Platform_Role__c platformRole : platformRoleUpdatedList){
                            if(platformRole.Contact__c == thisContact.id && relationshipAccount != null && platformRole.Account__C == relationshipAccount.id){
                                if(!((platformRole.Roles__c).contains(String.valueOf(relationship.relationshipType)))){
                                    platformRole.Roles__c = platformRole.Roles__c +';'+ relationship.relationshipType;
                                }
                                addPlatformRole = false;
                            }
                        }
                    }
                    if(addPlatformRole){
                        Platform_Role__c newPlatformRole = new Platform_Role__c();
                        
                        newPlatformRole.Account__c = relationshipAccount.id;
                        
                        newPlatformRole.Contact__c = thisContact.id;
                        newPlatformRole.Roles__c = String.valueOf(relationship.relationshipType);
                        newPlatformRole.Platform__c = 'UBX';
                        platformRoleUpdatedList.add(newPlatformRole);
                    }
                }
            }

        }

        if(platformRoleUpdatedList != null && platformRoleUpdatedList.size() > 0){
            upsert platformRoleUpdatedList;
        }

    }  
   
    public static void validateAddressRequest(TF_CustomerService.Address address){
        if(address.emailAddress != null && !isValidEmail(address.emailAddress)){
            throw new TF_CustomerService.CustomerServiceException('Email Address is invalid');
        } 
        
        if(address.bpNumber != null && !((address.bpNumber).isNumeric())){
            throw new TF_CustomerService.CustomerServiceException('Invalid BP Number. Only numeric digits are accepted');
        } 
        
        if(address.bpNumber != null && address.bpPartnerFunction == null){
            throw new TF_CustomerService.CustomerServiceException('BP partner function is missing.');
        }   
    } 
      public static void addCustomerAddress(TF_CustomerService.Address address, String partyid, TF_CustomerService.BpDetails bpdetailsFromRequest){
       
        List<Account> accountList = new List<Account>();
        List<Contact> contactList = new List<Contact>();
        if(address.addressType == null){
            address.addressType = TF_CustomerService.AddressType.billing;
        } 
        if(address.contactType == null){
            address.contactType = TF_CustomerService.ContactType.primary;
        } 
        accountList = [SELECT Id, Name, Billing_BP_Details__c, Billing_BP_Number__c, Mailing_BP_Details__c, Mailing_BP_Number__c, Shipping_BP_Details__c, Shipping_BP_Number__c, Billing_City__c, Billing_Country__c, Billing_Region__c, Billing_State__c, Billing_Street__c, Billing_ZIP__c, BillingAddress, ShippingAddress From Account where Customer_Id__c =: partyid];
        
        if(accountList != null && accountList.size() > 0){
            if(address.addressType==TF_CustomerService.AddressType.shipping){
                accountList[0].ShippingCity = address.city;
                accountList[0].ShippingPostalCode = address.postalCode;
                accountList[0].Shippingstate = address.state;
                accountList[0].Shipping_Country_List__c = address.country;
                accountList[0].Shipping_State_List__c = address.province;
                string str = '';
                str += address.addressLine1; 
                str += address.addressLine2;
                str += address.addressLine3;
                accountList[0].ShippingStreet = str;
                accountList[0].Shipping_BP_Number__c = address.bpNumber;
                accountList[0].Shipping_BP_Details__c = JSON.serialize(bpdetailsFromRequest);
            }
            else if (address.addressType==TF_CustomerService.AddressType.billing){
                accountList[0].Billing_City__c = address.city;
                accountList[0].Billing_ZIP__c = address.postalCode;
                accountList[0].Billing_State__c = address.state;
                accountList[0].Billing_Country_List__c = address.country;
                accountList[0].Billing_State_List__c = address.province;
                string str = '';
                str += address.addressLine1; 
                str += address.addressLine2;
                str += address.addressLine3;
                accountList[0].Billing_Street__c = str;
                accountList[0].Billing_BP_Number__c = address.bpNumber;
                accountList[0].Billing_BP_Details__c = JSON.serialize(bpdetailsFromRequest);
            }
            else if (address.addressType == TF_CustomerService.AddressType.mailing){
                accountList[0].BillingCity = address.city;
                accountList[0].BillingPostalCode = address.postalCode;
                accountList[0].Billingstate = address.state;
                accountList[0].Mailing_Country_List__c = address.country;
                accountList[0].Mailing_State_List__c = address.province;
                string str ='';
                str += address.addressLine1; 
                str += address.addressLine2;
                str += address.addressLine3;
                accountList[0].BillingStreet = str;
                accountList[0].Mailing_BP_Number__c = address.bpNumber;
                accountList[0].Mailing_BP_Details__c = JSON.serialize(bpdetailsFromRequest);
            }
        }else{
            contactList = [Select Billing_BP_Details__c, Billing_BP_Number__c, Mailing_BP_Details__c, Mailing_BP_Number__c, Shipping_BP_Details__c, Shipping_BP_Number__c, MailingCity, MailingPostalCode, Mailingstate, Mailing_Country_List__c, Mailing_State_List__c, MailingStreet From Contact where Party_Id__c =: partyid];

            if(contactList != null && contactList.size() > 0){
                if(address.addressType==TF_CustomerService.AddressType.shipping){
                    contactList[0].MailingCity = address.city;
                    contactList[0].MailingPostalCode = address.postalCode;
                    contactList[0].Mailingstate = address.state;
                    contactList[0].Mailing_Country_List__c = address.country;
                    contactList[0].Mailing_State_List__c = address.province;
                    string str = '';
                    str += address.addressLine1; 
                    str += address.addressLine2;
                    str += address.addressLine3;
                    contactList[0].MailingStreet = str;
                    contactList[0].Mailing_BP_Number__c = address.bpNumber;
                    contactList[0].Mailing_BP_Details__c = JSON.serialize(bpdetailsFromRequest);
                }
                else if (address.addressType == TF_CustomerService.AddressType.billing){
                    contactList[0].OtherCity = address.city;
                    contactList[0].OtherPostalCode = address.postalCode;
                    contactList[0].Otherstate = address.state;
                    contactList[0].Other_Country_List__c = address.country;
                    contactList[0].Other_State_List__c = address.province;
                    string str ='';
                    str += address.addressLine1; 
                    str += address.addressLine2;
                    str += address.addressLine3;
                    contactList[0].OtherStreet = str;
                    contactList[0].Billing_BP_Number__c = address.bpNumber;
                    contactList[0].Billing_BP_Details__c = JSON.serialize(bpdetailsFromRequest);
                }
            }
        }
        if(accountList != null && accountList.size() > 0){
            update accountList;
        }
        else if(contactList != null && contactList.size() > 0){
            update contactList;
        }else{
            throw new TF_CustomerService.CustomerServiceException('No Account or Contact present with this party Id');
        } 
    }   
    
     public static void updateCustomerAddress(TF_CustomerService.Address address, String partyid, TF_CustomerService.BpDetails bpdetailsFromRequest){
       
        List<Account> accountList = new List<Account>();
        List<Contact> contactList = new List<Contact>();
        accountList = [SELECT Id, Name, Billing_BP_Details__c, Billing_BP_Number__c, Mailing_BP_Details__c, Mailing_BP_Number__c, Shipping_BP_Details__c, Shipping_BP_Number__c, Billing_City__c, Billing_Country__c, Billing_Region__c, Billing_State__c, Billing_Street__c, Billing_ZIP__c, BillingAddress, ShippingAddress From Account where Customer_Id__c =: partyid];
        if(accountList != null && accountList.size() > 0){
            if(address.addressType==TF_CustomerService.AddressType.shipping){
                if(accountList[0].Shipping_BP_Number__c != null){    
                    throw new TF_CustomerService.CustomerServiceException('Address associated with a BP number cannot be updated');
                }else{
                    accountList[0].ShippingCity = address.city;
                    accountList[0].ShippingPostalCode = address.postalCode;
                    accountList[0].Shippingstate = address.state;
                    accountList[0].Shipping_Country_List__c = address.country;
                    accountList[0].Shipping_State_List__c = address.province;
                    string str = '';
                    str += address.addressLine1; 
                    str += address.addressLine2;
                    str += address.addressLine3;
                    accountList[0].ShippingStreet = str;
                    accountList[0].Shipping_BP_Number__c = address.bpNumber;
                    accountList[0].Shipping_BP_Details__c = JSON.serialize(bpdetailsFromRequest);
                }
            }
            else if (address.addressType==TF_CustomerService.AddressType.billing){
                if(accountList[0].Billing_BP_Number__c != null){    
                    throw new TF_CustomerService.CustomerServiceException('Address associated with a BP number cannot be updated');
                }else{
                    accountList[0].Billing_City__c = address.city;
                    accountList[0].Billing_ZIP__c = address.postalCode;
                    accountList[0].Billing_State__c = address.state;
                    accountList[0].Billing_Country_List__c = address.country;
                    accountList[0].Billing_State_List__c = address.province;
                    string str = '';
                    str += address.addressLine1; 
                    str += address.addressLine2;
                    str += address.addressLine3;
                    accountList[0].Billing_Street__c = str;
                    accountList[0].Billing_BP_Number__c = address.bpNumber;
                    accountList[0].Billing_BP_Details__c = JSON.serialize(bpdetailsFromRequest);
                }
            }
            else if (address.addressType == TF_CustomerService.AddressType.mailing){
                if(accountList[0].Mailing_BP_Number__c != null){    
                    throw new TF_CustomerService.CustomerServiceException('Address associated with a BP number cannot be updated');
                }else{
                    accountList[0].BillingCity = address.city;
                    accountList[0].BillingPostalCode = address.postalCode;
                    accountList[0].Billingstate = address.state;
                    accountList[0].Mailing_Country_List__c = address.country;
                    accountList[0].Mailing_State_List__c = address.province;
                    string str ='';
                    str += address.addressLine1; 
                    str += address.addressLine2;
                    str += address.addressLine3;
                    accountList[0].BillingStreet = str;
                    accountList[0].Mailing_BP_Number__c = address.bpNumber;
                    accountList[0].Mailing_BP_Details__c = JSON.serialize(bpdetailsFromRequest);
                }
            }
        }else{
            contactList = [Select Billing_BP_Details__c, Billing_BP_Number__c, Mailing_BP_Details__c, Mailing_BP_Number__c, Shipping_BP_Details__c, Shipping_BP_Number__c, MailingCity, MailingPostalCode, Mailingstate, Mailing_Country_List__c, Mailing_State_List__c, MailingStreet From Contact where Party_Id__c =: partyid];

            if(contactList != null && contactList.size() > 0){
                if(address.addressType==TF_CustomerService.AddressType.shipping){
                    if(contactList[0].Mailing_BP_Number__c != null){    
                            throw new TF_CustomerService.CustomerServiceException('Address associated with a BP number cannot be updated');
                    }else{
                        contactList[0].MailingCity = address.city;
                        contactList[0].MailingPostalCode = address.postalCode;
                        contactList[0].Mailingstate = address.state;
                        contactList[0].Mailing_Country_List__c = address.country;
                        contactList[0].Mailing_State_List__c = address.province;
                        string str = '';
                        str += address.addressLine1; 
                        str += address.addressLine2;
                        str += address.addressLine3;
                        contactList[0].MailingStreet = str;
                        contactList[0].Mailing_BP_Number__c = address.bpNumber;
                        contactList[0].Mailing_BP_Details__c = JSON.serialize(bpdetailsFromRequest);
                    }
                }
                else if (address.addressType == TF_CustomerService.AddressType.billing){
                    if(contactList[0].Billing_BP_Number__c != null){    
                        throw new TF_CustomerService.CustomerServiceException('Address associated with a BP number cannot be updated');
                    }else{
                        contactList[0].OtherCity = address.city;
                        contactList[0].OtherPostalCode = address.postalCode;
                        contactList[0].Otherstate = address.state;
                        contactList[0].Other_Country_List__c = address.country;
                        contactList[0].Other_State_List__c = address.province;
                        string str ='';
                        str += address.addressLine1; 
                        str += address.addressLine2;
                        str += address.addressLine3;
                        contactList[0].OtherStreet = str;
                        contactList[0].Billing_BP_Number__c = address.bpNumber;
                        contactList[0].Billing_BP_Details__c = JSON.serialize(bpdetailsFromRequest);
                    }
                }
            }
        }
        if(accountList != null && accountList.size() > 0){
            update accountList;
        }
        else if(contactList != null && contactList.size() > 0){
            update contactList;
        }else{
            throw new TF_CustomerService.CustomerServiceException('No Account or Contact present with this party Id');
        } 
    }   
}