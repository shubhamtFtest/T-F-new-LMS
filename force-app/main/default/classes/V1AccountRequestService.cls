public with sharing class V1AccountRequestService implements AccountRequestInterface {
    public Account create(ResourceV1AccountRequest.AccountRequest input) {
        try{
            List<Account> accountFound = new List<Account>();
            boolean automateAccount = false;
            boolean rejectAccountRequest = false;
            List<TF_SearchRinggoldIdCallout.RinggoldDataWrapper> thisDVList = new List<TF_SearchRinggoldIdCallout.RinggoldDataWrapper>();

            Account account = createAccountRequest(input);
            if(input.contact != null && (input.contact).size() > 0){
                createContacts(input.contact, account);
            }
            if(input.ips != null && (input.ips).size() > 0){
                createEndUserAccess(input.ips, account);
            }
            addAccountRequestLog(account, input);
            if(input.ringGoldId != null && input.ringGoldId != '') {
                accountFound = [Select Id,Ringgold_Account_ID__c from Account where Ringgold_Account_ID__c =: input.ringGoldId Limit 1];   
                System.debug('accountFound'+accountFound);
                if(accountFound != null && accountFound.size() > 0 && accountFound[0] != null && (accountFound[0]).id != null){
                    System.debug('in if');
                    rejectAccountRequest = true;
                }else{
                    account.Ringgold_Account_ID__c = input.ringGoldId;
                    update account;
                    automateAccount = true;
                    System.debug('automateAccount'+automateAccount);
                }
            }
            if(automateAccount){
                if(!test.isRunningTest()){
                    Id automateValidateIPJobId = System.enqueueJob( new AccountRequestOAAutomationService( account ));
                    System.debug('automateValidateIPJobId : '+automateValidateIPJobId);
                }
            }
            System.debug('rejectAccountRequest' + rejectAccountRequest);
            if(rejectAccountRequest && accountFound != null && accountFound.size() > 0 && accountFound[0].Ringgold_Account_ID__c != null){
                System.debug('rejectAccountRequest in if : ' + rejectAccountRequest);
                //call ringgold self rejection
                TF_SearchRinggoldIdCallout.RinggoldDataWrapper thisDupAcc = new TF_SearchRinggoldIdCallout.RinggoldDataWrapper();
                thisDupAcc.ringgoldId = Integer.valueOf(accountFound[0].Ringgold_Account_ID__c);
                thisDVList.add(thisDupAcc);
                System.debug('thisDupAcc 12 : ' + thisDupAcc);
                TF_SearchRinggoldIdCallout.updateThirdPartyAccountRejStatus(account.id, JSON.serialize(thisDVList));
            }
        
            return account;
        }catch(Exception ex){
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            String emailAddress = (String) orgSpecificProps.get('CustomerOnboardingExceptionEmailAddress__c');
          
            String emailBody = 'CL : SF : CustomerOnboardingException for below mentioned request :';
            System.debug('Email address: ' +emailAddress);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] { emailAddress};
            message.subject = 'CL : SF : CustomerOnboardingException';
            message.plainTextBody = emailBody + JSON.serialize(input);
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            if (results[0].success){
                System.debug('The email was sent successfully.');
            } else{
                System.debug('The email failed to send: ' + results[0].errors[0].message);
            }
            throw new ResourceV1AccountRequest.CustomerOnboadingException('CL:SF Exception : '+ex);
            
        }
    }
    
    private Account createAccountRequest(ResourceV1AccountRequest.AccountRequest input) {
        try{
            Account accountRequest = new Account();
            accountRequest.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Third Party Account Request').getRecordTypeId();
            accountRequest.Name = input.Name;
            accountRequest.Website = input.website;
            accountRequest.Source_of_Account__c = input.source;
            accountRequest.Onboarding_Status__c = 'Submitted for Approval';
            if(input.createBP != null){
                if(input.createBP == 'false'){
                    accountRequest.Create_BP__c = false;
                }else{
                    accountRequest.Create_BP__c = true;
                }
            }else{
                accountRequest.Create_BP__c = true;
            }
            List<ResourceV1AccountRequest.Address> addressList = input.address;
            if(addressList != null && addressList.size() > 0){
                for(ResourceV1AccountRequest.Address thisAddress : addressList){
                    if(thisAddress.addressType == 'billing'){
                        if(thisAddress.addressLine1 == null ){
                            thisAddress.addressLine1 = '';
                        }
                        if(thisAddress.addressLine2 == null ){
                            thisAddress.addressLine2 = '';
                        }
                        if(thisAddress.addressLine3 == null ){
                            thisAddress.addressLine3 = '';
                        }
                        //accountRequest.House_Number__c = thisAddress.houseNumber;
                        accountRequest.BillingStreet =  thisAddress.addressLine1 + ' ' + thisAddress.addressLine2 + ' ' + thisAddress.addressLine3;
                        accountRequest.BillingState = thisAddress.state;
                        accountRequest.Mailing_State_List__c = thisAddress.state;
                        accountRequest.BillingCity = thisAddress.city;
                        accountRequest.BillingCountry = thisAddress.country;
                        accountRequest.BillingPostalCode = thisAddress.postalCode;
                        accountRequest.Mailing_Country_List__c = thisAddress.country;
                        accountRequest.VAT_Number__c = thisAddress.taxRegistrationNumber;
                        accountRequest.Tax_Number_Category__c = thisAddress.taxNumberCategory;
                        accountRequest.Request_BP_Number__c = thisAddress.bpNumber;
                        
                        /*Shipping Address addon SAL-4292 */
                         
						accountRequest.ShippingStreet =  thisAddress.addressLine1 + ' ' + thisAddress.addressLine2 + ' ' + thisAddress.addressLine3;
                        accountRequest.ShippingState = thisAddress.state;
                        accountRequest.ShippingCity = thisAddress.city;
                        accountRequest.ShippingCountry = thisAddress.country;
                        accountRequest.ShippingPostalCode = thisAddress.postalCode;
                        
                        /*END Shipping Address addon SAL-4292 */
                    } 
                    if(thisAddress.addressType == 'shipping'){
                        accountRequest.ShippingStreet =  thisAddress.addressLine1 + ' ' + thisAddress.addressLine2 + ' ' + thisAddress.addressLine3;
                        accountRequest.ShippingState = thisAddress.state;
                        accountRequest.ShippingCity = thisAddress.city;
                        accountRequest.ShippingCountry = thisAddress.country;
                        accountRequest.ShippingPostalCode = thisAddress.postalCode;
                    }
                    if(thisAddress.addressType == 'mailing'){
                        accountRequest.Billing_Street__c =  thisAddress.addressLine1 + ' ' + thisAddress.addressLine2 + ' ' + thisAddress.addressLine3;
                        accountRequest.Billing_State__c = thisAddress.state;
                        accountRequest.Billing_City__c = thisAddress.city;
                        accountRequest.Billing_Country__c = thisAddress.country;
                        accountRequest.Billing_ZIP__c = thisAddress.postalCode;
                    }
                }
            }
        
            insert accountRequest;
            return accountRequest;
        }catch(Exception ex){
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            String emailAddress = (String) orgSpecificProps.get('CustomerOnboardingExceptionEmailAddress__c');
          
            String emailBody = 'CL : SF : CustomerOnboardingException for below mentioned request : Account Request Could not be created.  ';
            System.debug('Email address: ' +emailAddress);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] { emailAddress};
            message.subject = 'CL : SF : CustomerOnboardingException';
            message.plainTextBody = emailBody + JSON.serialize(input);
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            if (results[0].success){
                System.debug('The email was sent successfully.');
            } else{
                System.debug('The email failed to send: ' + results[0].errors[0].message);
            }
            throw new ResourceV1AccountRequest.CustomerOnboadingException('CL:SF Exception : '+ex);
        }
        
    }
    
    private void createContacts(List<ResourceV1AccountRequest.ContactDetails> contacts, Account account) {
        List<Contact> newContactList = new List<Contact>();
        Set<String> emailList = new Set<String>();
        for(ResourceV1AccountRequest.ContactDetails thisContact : contacts){
            if(thisContact.email != null){
                emailList.add(thisContact.email);  
            }
        }
        List<Contact> existingContact = [Select id, Name, Email,Shared_email_address__c from Contact where Email IN: emailList];
        Boolean exceptionFound = false;
        for(ResourceV1AccountRequest.ContactDetails thisContactRequest : contacts){
            Contact contactRequest = new Contact();
            if(thisContactRequest.firstname != null){
               contactRequest.FirstName = thisContactRequest.firstname; 
            }
            System.debug('thisContactRequest.lastname  : '+thisContactRequest.lastname);
            if(thisContactRequest.lastname != null && thisContactRequest.lastname != '' ){
               contactRequest.LastName = thisContactRequest.lastname; 
            }else{
               contactRequest.LastName = '.';
            }
            if(emailList.contains(thisContactRequest.email)){
                contactRequest.Email = thisContactRequest.email;
                contactRequest.Shared_email_address__c = true;
            }
            if(thisContactRequest.email == null || thisContactRequest.email == '' || thisContactRequest.email == 'null'){
                System.debug('before throw');
                exceptionFound = true;
            }
            System.debug('after throw 2');
            contactRequest.AccountId = account.id;
            newContactList.add(contactRequest);
        }
        if(exceptionFound){
            throw new ResourceV1AccountRequest.EmailIdCannotBeNullException('Email Id cannot be null for a contact.');
        }else{
            if(newContactList != null && newContactList.size() > 0){
                insert newContactList;
            }   
        }   
    }
    
    private void createEndUserAccess(List<ResourceV1AccountRequest.IPs> ips, Account account) {
        
        List<End_User_Access__c> newIPList = new List<End_User_Access__c>();
        for(ResourceV1AccountRequest.IPs thisIPRequest : ips){
            End_User_Access__c ipRequest = new End_User_Access__c();
            ipRequest.Description__c = thisIPRequest.description;
            ipRequest.IP_Range__c = thisIPRequest.iplist;
            ipRequest.Type__c = thisIPRequest.type;
            ipRequest.Account__c = account.id;
            newIPList.add(ipRequest);
        }
        if(newIPList != null && newIPList.size() > 0){
            insert newIPList;
        }
    }
    
    private void addAccountRequestLog(Account account, ResourceV1AccountRequest.AccountRequest input) {
        Account_Request_Log__c log = new Account_Request_Log__c();
        log.Request_ID__c = account.Id;
        log.Request_JSON__c = JSON.serialize(input);
        log.Source__c = input.source;
        log.Status__c = 'NEW';
        insert log;
     
    }
    
    public static void validateRequest(ResourceV1AccountRequest.AccountRequest input){
        if(input == null){
            throw new ResourceV1AccountRequest.FieldCannotBeNullException('CL:SF: Request Null Exception. Request cannot be null.');
        }
        if(input.name == null || input.name == ''){
            throw new ResourceV1AccountRequest.FieldCannotBeNullException('CL:SF: Account Request Name Null Exception. Name field cannot be null.');
        }
        
        if((input.address == null || (input.address).size() == 0 ) &&  (input.createBP == null || input.createBP == '' || input.createBP == 'true')){
            throw new ResourceV1AccountRequest.FieldCannotBeNullException('CL:SF: Address in Request Null Exception. No Address Information present in Request.');
        }
        if(input.address != null && (input.createBP == null || input.createBP == '' || input.createBP == 'true')){
        	for(ResourceV1AccountRequest.Address thisAdd : input.address){
            	if(thisAdd.addressType == 'billing' || thisAdd.addressType == '' || thisAdd.addressType == null ){
                	if(thisAdd.addressLine1 == null || thisAdd.addressLine1 == ''){
                    	throw new ResourceV1AccountRequest.FieldCannotBeNullException('CL:SF: AddressLine1 in Request Null Exception. AddressLine1 field cannot be null.');
                	}
                	if(thisAdd.city == null || thisAdd.city == ''){
                    	throw new ResourceV1AccountRequest.FieldCannotBeNullException('CL:SF: City in Request Null Exception. City field cannot be null.');
                	}
                	if(thisAdd.country == null || thisAdd.country == ''){
                    	throw new ResourceV1AccountRequest.FieldCannotBeNullException('CL:SF: Country in Request Null Exception. Country field cannot be null.');
                	}
            	}
        	}   
        }
        
        if(input.contact == null && (input.createBP == null || input.createBP == '' || input.createBP == 'true')){
            throw new ResourceV1AccountRequest.FieldCannotBeNullException('CL:SF: Contact info in Request Null Exception. No Contact Information present in Request.');
        }
    }
}