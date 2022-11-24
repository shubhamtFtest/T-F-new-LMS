public with sharing class V1IndividualCustomerService implements IndividualCustomerInterface {
    public Account create(Map<String,Object> input) {
      // Refer : https://salesforce.stackexchange.com/questions/29830/how-to-create-a-personaccount-in-salesforce-using-apex-code  
      // Check If the email Id is already exit or not
      String emailID = input.get('PersonEmail').toString();
        System.debug('request input'+ input);
      Contact contactDetails = null;
        
       	//LastName Validation By Sourabh Goyal SAL(CL) - 4718
        String regx ='[/!@#$%^&*()+=[]{};\\:|<>/?]+/;//]';//[a-zA-Z ]*'//'^([a-z]+[,.]?[ ]?|[a-z]+[\'-]?)+$';//'[/!@#$%^&*()+=[]{};\\:|<>/?]+/;//]';//[a-zA-Z ]*';
        String regex2 = '([--]?[..-]?[..]?[-\'\']?[..\'\']?[__]?[__..]?[__-]?[__\'\']?[-""]?[""]?[""\'\']?[""__]?[""..])+$';
        String lastName = String.valueOf(input.get('LastName'));
        lastName = lastName.toLowerCase();
        System.debug('@@@@@lastName'+lastName);
        System.debug(!Pattern.matches(regx,lastName));
        if(lastName != null &&  !Pattern.matches(regx,lastName) && !Pattern.matches(regex2, lastName)){
            System.debug('Matched');
        }else{
            throw new IndividualCustomerService.IndividualCustomerOnboardingException('LastName cannot contain special charcters exception.');
        }
        
      try {
      	contactDetails = [SELECT ID, FirstName, LastName, IsPersonAccount, AccountID, OwnerID FROM Contact WHERE Email = :emailID limit 1];
      } catch (QueryException ex) {
          System.debug('New contact ' + emailID);
      } 
      if(contactDetails != null) {
          if(contactDetails.LastName != null  && !Pattern.matches(regx,contactDetails.LastName.toLowerCase())   && !Pattern.matches(regex2,contactDetails.LastName.toLowerCase()) ){
            System.debug('Matched');
            }else{
                throw new IndividualCustomerService.IndividualCustomerOnboardingException('LastName cannot contain special charcters.');
           }
          if(contactDetails.IsPersonAccount) {
              Account ac = [SELECT id,customer_id__c from Account WHERE id = :contactDetails.AccountID];
              return ac;
          } else {
             String requestParty = String.valueOf(input.get('Customer_Id__c'));
              if(requestParty == null || requestParty == 'null'){
                  requestParty = '';
              }
             return convert(emailID,requestParty);  
          }
      	  
      } else {
          Integer partyID;
          Account newAccount = new Account();
          for(String fieldName : input.keySet()) {
            newAccount.put(fieldName, input.get(fieldName));
          }
          Id personAccountRecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
          newAccount.RecordTypeId = personAccountRecordTypeId;
          String requestParty = String.valueOf(input.get('Customer_Id__c'));
          if(requestParty == null || requestParty == 'null' || requestParty == ''){
          	partyID = PartyIdIncrementer.getNextPartyId();
          }else{
          	partyID = Integer.valueOf(requestParty);
          }
          newAccount.Customer_Id__c = string.valueOf(partyID);
          Database.SaveResult[] insertedAccounts = Database.insert(new List<Account>{newAccount}, false) ;
          System.debug('insertedAccounts'+insertedAccounts);
          
          if(insertedAccounts.get(0).isSuccess() && (newAccount.Request_BP_Number__c != null || newAccount.Request_BP_Number__c != '')){
              if(newAccount.BillingCountry != null && newAccount.BillingCountry != ''){
            Country__c countryCode = [SELECT Country_2__c, Name FROM Country__c where Name =:newAccount.BillingCountry];
			String jsonStringBody = '';
            jsonStringBody+='{';
        	jsonStringBody+='"houseNumber": "",';
        	jsonStringBody+='"addressLine1": "'+ newAccount.BillingStreet +'",';
        	jsonStringBody+='"addressLine2": "",';
        	jsonStringBody+='"addressLine3": "",';
        	jsonStringBody+='"city": "' + newAccount.BillingCity + '",'; 
        	jsonStringBody+='"state":"'+ newAccount.BillingState +'",';
        	jsonStringBody+='"country": "'+ newAccount.BillingCountry +'",';
        	jsonStringBody+='"countryCode": "'+countryCode+'",';
        	jsonStringBody+='"addressType": "PERSON",';
        	jsonStringBody+='"contactType": "",';
        	jsonStringBody+='"firstName": "'+ newAccount.FirstName +'",';
        	jsonStringBody+='"lastName": "'+ newAccount.LastName +'",';
        	jsonStringBody+='"title": "",';
        	jsonStringBody+='"emailAddress": "'+newAccount.PersonEmail+'",';
        	jsonStringBody+='"telephone" : "'+ newAccount.Phone +'",';
        	jsonStringBody+='"bpPartnerFunction": "SP",';
        	jsonStringBody+='"bpBusinessPartnerCategory" : "1",';
            if(newAccount.BillingPostalCode == null || newAccount.BillingPostalCode == '' || newAccount.BillingPostalCode == 'Not Available' ) {
            	jsonStringBody+='"postalCode": "",';  
            }else {
                jsonStringBody+='"postalCode": "'+ newAccount.BillingPostalCode +'",';
            }
            if(newAccount.Request_BP_Number__c  != null || newAccount.Request_BP_Number__c != ''){
            	jsonStringBody+='"bpNumber": "'+newAccount.Request_BP_Number__c +'",';
            }
            if(newAccount.Request_RRAddressId__c  != null || newAccount.Request_RRAddressId__c != ''){
            	jsonStringBody+='"rrAddressId": "'+newAccount.Request_RRAddressId__c +'",';
            }
        	jsonStringBody+='"source": "",';
        	jsonStringBody+='"addressUseType": "Account Billing"';
        	jsonStringBody+='}';
            System.debug('jsonStringBody'+jsonStringBody);
            String resp = SAP_BP_Service.processRequest(jsonStringBody, '/'+newAccount.Customer_Id__c+'/generateBP/');
            System.debug('SAP BP creation resp' + resp);
          }
      }
          return newAccount;          
      }
    }
    
    public Account convert(String emailID, String partyId) {
      // Get the Contact
      Contact contactNeedConversion = [SELECT ID,FirstName,LastName, IsPersonAccount,AccountID,OwnerID,Party_Id__c,CurrencyIsoCode FROM Contact WHERE Email = :emailID ORDER BY CreatedDate ASC LIMIT 1];
      ID oldAccountID = contactNeedConversion.AccountId;
      // Create a new Business Account base on the First namd and last name from the Contact   
      System.debug('Email ID : ' +  emailID);
      System.debug('oldAccountID : ' + oldAccountID);  
      String contactPartyID = contactNeedConversion.Party_Id__c;
      String firstName = contactNeedConversion.FirstName;
      String lastName = contactNeedConversion.LastName;
        if(firstName == null){
        	firstName = '';   
        }
        if(lastName == null){
        	lastName = '';   
        }
      String nameOfTheAccount =  firstName + ' ' + lastName;
      Account newPersonAccount = new Account();
      newPersonAccount.name = nameOfTheAccount;
      newPersonAccount.OwnerId = contactNeedConversion.OwnerId;
      newPersonAccount.CurrencyIsoCode = contactNeedConversion.CurrencyIsoCode ;
        if(partyId != null && partyId != ''){
        	newPersonAccount.Customer_Id__c =  partyId;
        }else{
            if(contactPartyID != null && contactPartyID != '' && contactPartyID != 'null'){
                newPersonAccount.Customer_Id__c = contactPartyID;
            }else{
                newPersonAccount.Customer_Id__c = String.valueOf(PartyIdIncrementer.getNextPartyId());
            }   
        }
      insert newPersonAccount;
        System.debug('newPersonAccount'+newPersonAccount);
      // Associate the existing contact to new BuinessAccount  
      contactNeedConversion.AccountId = newPersonAccount.Id;
      //Need this primary contact while creating a Case  
      contactNeedConversion.Primary_Account__c = oldAccountID;  
        System.debug('contactNeedConversion'+ contactNeedConversion);
      update contactNeedConversion;   
      // Create a new PlatformEvent which will take care BusinessAccount to PersonAccount converation
      ContactToPersonAccountConvertionRequest__e platformRequest = new ContactToPersonAccountConvertionRequest__e();
      platformRequest.Old_Account_ID__c = oldAccountID;
      platformRequest.New_Account_ID__c = newPersonAccount.Id;
      platformRequest.Contact_ID__c = contactNeedConversion.Id;
      EventBus.publish(platformRequest); 
      // Refer : https://success.salesforce.com/answers?id=9063A000000piwcQAA
      // Refer : https://developer.salesforce.com/forums/?id=906F00000008vy9IAA
      return newPersonAccount;
    } 
    
    public void validateRequest(Map<String,Object> input){
        if(input == null){
            throw new IndividualCustomerService.IndividualCustomerOnboardingException('CL:SF: Request Null Exception. Request cannot be null.');
        }
        if(input.get('PersonEmail').toString() == null || input.get('PersonEmail').toString() == ''){
            throw new IndividualCustomerService.IndividualCustomerOnboardingException('CL:SF: Email cannot be Null Exception. Email field in request cannot be null.');
        }
    }
    
}