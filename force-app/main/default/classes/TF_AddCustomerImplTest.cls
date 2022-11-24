@IsTest
public class TF_AddCustomerImplTest {
    
    @isTest 
    private static void addOrUpdateContactTest(){
    
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
 
        Account acc = new Account (Name= 'Test', RecordTypeId = RecordTypeIdAccount, Type = 'Other', Classification__c = 'Other', CurrencyIsoCode = 'USD',Mailing_Country_List__c = 'United Kingdom', Locale__c = 'APAC', Sales_Region__c = 'Africa', Shipping_Country_List__c = 'United Kingdom', Ringgold_Account_ID__c = '12345');
        insert acc;
        system.debug(acc);
        
        Account testBucketAccount = new Account();
        testBucketAccount.name = 'Test Bucket Account';
        testBucketAccount.type = 'Agent';
        insert testBucketAccount;
        
        String emailNull = '{"contact":{"partyId":"string","dob":"04-17-1998","firstName":"Test","fullName":"TestAddCustomer","lastName":"AddCustomer","orcid":"string","partySfdcId":"string","addressList":[{"addressId":"string","addressLine1":"108 ","addressLine2":"Oak Valley Dr.","addressLine3":"Suitland, MD 20746","addressEndDate":"timestamp","addressStartDate":"timestamp","addressType":"billing","city":"AL","postalCode":"36067","state":"Alabama","country":"United States","province":"","contactType":"primary","bpNumber":"string","bpPartnerFunction":"SP","bpBusinessPartnerFunction":"string","countryCode":"","usStateCode":"","emailAddress":"testRandom@gmail.com","title":"string","firstName":"string","lastName":"string","telephone":"string","taxRegistrationNumber":"string","taxNumberCategory":"string"},{"addressId":"string","addressLine1":"108 ","addressLine2":"Oak Valley Dr.","addressLine3":"Suitland, MD 20746","addressEndDate":"timestamp","addressStartDate":"timestamp","addressType":"shipping","city":"AL","postalCode":"36067","state":"Alabama","country":"United States","province":"","contactType":"primary","bpNumber":"string","bpPartnerFunction":"SP","bpBusinessPartnerFunction":"string","countryCode":"","usStateCode":"","emailAddress":"testRandom@gmail.com","title":"string","firstName":"string","lastName":"string","telephone":"string","taxRegistrationNumber":"string","taxNumberCategory":"string"}],"contactList":[{"contactNumber":"51251521365","email":"","partySfdcId":"string","contactType":"primary"}],"relationships":[{"identifierType":"sfid","identifierValue":"'+acc.id+'","relationshipType":"librarian_admin"}],"preferences":[{"preferenceName":"opt_out","preferenceValue":"s"}],"references":[]}}';
        TF_CustomerService.Customer emailNullVar = (TF_CustomerService.Customer)JSON.deserialize(emailNull, TF_CustomerService.Customer.class);
        TF_AddCustomerImpl.notifyReferenceContact(emailNullVar.contact);
    
		String updateContact='{"contact":{"partyId":"string","dob":"04-17-1998","firstName":"Test","fullName":"string","lastName":"Test1","orcid":"string","partySfdcId":"string","addressList":[{"addressId":"string","addressLine1":"108","addressLine2":"Oak Valley Dr.","addressLine3":"Suitland, MD 20746","addressEndDate":"timestamp","addressStartDate":"timestamp","addressType":"billing","city":"AL","postalCode":"36067","state":"Alabama","country":"United States","province":"","contactType":"primary","bpNumber":"string","bpPartnerFunction":"SP","bpBusinessPartnerFunction":"string","countryCode":"string","usStateCode":"string","emailAddress":"string","title":"string","firstName":"string","lastName":"string","telephone":"string","taxRegistrationNumber":"string","taxNumberCategory":"string"}],"contactList":[{"contactNumber":"51251521365","email":"kazan@gmail.com","partySfdcId":"string","contactType":"primary"}],"relationships":[{"identifierType":"sfid","identifierValue":"'+acc.id+'","relationshipType":"librarian_admin"}],"preferences":[{"preferenceName":"opt_out","preferenceValue":"true"}],"references":[]}}';
        TF_CustomerService.Customer updateCustomerRequest = (TF_CustomerService.Customer)JSON.deserialize(updateContact, TF_CustomerService.Customer.class);
        TF_AddCustomerImpl.addOrUpdateContact(updateCustomerRequest.contact);
        
		String insertContact= '{"contact":{"partyId":"string","dob":"04-17-1998","firstName":"TestString","fullName":"TestAddCustomer","lastName":"AddCustomer","orcid":"string","partySfdcId":"string","addressList":[{"addressId":"string","addressLine1":"108 ","addressLine2":"Oak Valley Dr.","addressLine3":"Suitland, MD 20746","addressEndDate":"timestamp","addressStartDate":"timestamp","addressType":"billing","city":"AL","postalCode":"36067","state":"Alabama","country":"United States","province":"","contactType":"primary","bpNumber":"string","bpPartnerFunction":"SP","bpBusinessPartnerFunction":"string","countryCode":"","usStateCode":"","emailAddress":"testRandom@gmail.com","title":"string","firstName":"string","lastName":"string","telephone":"string","taxRegistrationNumber":"string","taxNumberCategory":"string"},{"addressId":"string","addressLine1":"108 ","addressLine2":"Oak Valley Dr.","addressLine3":"Suitland, MD 20746","addressEndDate":"timestamp","addressStartDate":"timestamp","addressType":"shipping","city":"AL","postalCode":"36067","state":"Alabama","country":"United States","province":"","contactType":"primary","bpNumber":"string","bpPartnerFunction":"SP","bpBusinessPartnerFunction":"string","countryCode":"","usStateCode":"","emailAddress":"testRandom@gmail.com","title":"string","firstName":"string","lastName":"string","telephone":"string","taxRegistrationNumber":"string","taxNumberCategory":"string"}],"contactList":[{"contactNumber":"51251521365","email":"kazan@gmail.com","partySfdcId":"string","contactType":"primary"},{"contactNumber":"51251521365","email":"omsk@gmail.com","partySfdcId":"string","contactType":"alternate"}],"relationships":[{"identifierType":"sfid","identifierValue":"'+acc.id+'","relationshipType":"librarian_admin"},{"identifierType":"name","identifierValue":"test","relationshipType":"librarian_admin"},{"identifierType":"ringGoldId","identifierValue":"12345","relationshipType":"librarian_admin"}],"preferences":[{"preferenceName":"opt_out","preferenceValue":"true"}],"references":[]}}';
        TF_CustomerService.Customer addCustomer = (TF_CustomerService.Customer)JSON.deserialize(insertContact, TF_CustomerService.Customer.class);
        TF_AddCustomerImpl.addOrUpdateContact(addCustomer.contact);
        
        String notInsertContact= '{"contact":{"partyId":"string","dob":"04-17-1998","firstName":"Test","fullName":"TestAddCustomer","lastName":"AddCustomer","orcid":"string","partySfdcId":"string","addressList":[{"addressId":"string","addressLine1":"108 ","addressLine2":"Oak Valley Dr.","addressLine3":"Suitland, MD 20746","addressEndDate":"timestamp","addressStartDate":"timestamp","addressType":"billing","city":"AL","postalCode":"36067","state":"Alabama","country":"United States","province":"","contactType":"primary","bpNumber":"string","bpPartnerFunction":"SP","bpBusinessPartnerFunction":"string","countryCode":"","usStateCode":"","emailAddress":"testRandom@gmail.com","title":"string","firstName":"string","lastName":"string","telephone":"string","taxRegistrationNumber":"string","taxNumberCategory":"string"},{"addressId":"string","addressLine1":"108 ","addressLine2":"Oak Valley Dr.","addressLine3":"Suitland, MD 20746","addressEndDate":"timestamp","addressStartDate":"timestamp","addressType":"shipping","city":"AL","postalCode":"36067","state":"Alabama","country":"United States","province":"","contactType":"primary","bpNumber":"string","bpPartnerFunction":"SP","bpBusinessPartnerFunction":"string","countryCode":"","usStateCode":"","emailAddress":"testRandom@gmail.com","title":"string","firstName":"string","lastName":"string","telephone":"string","taxRegistrationNumber":"string","taxNumberCategory":"string"}],"contactList":[{"contactNumber":"51251521365","email":"veliky@gmail.com","partySfdcId":"string","contactType":"alternate"}],"relationships":[{"identifierType":"sfid","identifierValue":"'+acc.id+'","relationshipType":"librarian_admin"}],"preferences":[{"preferenceName":"opt_in","preferenceValue":"false"}],"references":[]}}';
        TF_CustomerService.Customer notaddCustomer = (TF_CustomerService.Customer)JSON.deserialize(notInsertContact, TF_CustomerService.Customer.class);
        TF_AddCustomerImpl.addOrUpdateContact(notaddCustomer.contact); 
        
		String identifireTypeName= '{"contact":{"partyId":"string","dob":"04-17-1998","firstName":"Test","fullName":"TestAddCustomer","lastName":"AddCustomer","orcid":"string","partySfdcId":"string","addressList":[{"addressId":"string","addressLine1":"108 ","addressLine2":"Oak Valley Dr.","addressLine3":"Suitland, MD 20746","addressEndDate":"timestamp","addressStartDate":"timestamp","addressType":"billing","city":"AL","postalCode":"36067","state":"Alabama","country":"United States","province":"","contactType":"primary","bpNumber":"string","bpPartnerFunction":"SP","bpBusinessPartnerFunction":"string","countryCode":"","usStateCode":"","emailAddress":"testRandom@gmail.com","title":"string","firstName":"string","lastName":"string","telephone":"string","taxRegistrationNumber":"string","taxNumberCategory":"string"},{"addressId":"string","addressLine1":"108 ","addressLine2":"Oak Valley Dr.","addressLine3":"Suitland, MD 20746","addressEndDate":"timestamp","addressStartDate":"timestamp","addressType":"shipping","city":"AL","postalCode":"36067","state":"Alabama","country":"United States","province":"","contactType":"primary","bpNumber":"string","bpPartnerFunction":"SP","bpBusinessPartnerFunction":"string","countryCode":"","usStateCode":"","emailAddress":"testRandom@gmail.com","title":"string","firstName":"string","lastName":"string","telephone":"string","taxRegistrationNumber":"string","taxNumberCategory":"string"}],"contactList":[{"contactNumber":"51251521365","email":"pskov@gmail.com","partySfdcId":"string","contactType":"primary"}],"relationships":[{"identifierType":"name","identifierValue":"Test","relationshipType":"librarian_admin"}],"preferences":[{"preferenceName":"opt_in","preferenceValue":"false"}],"references":[]}}';
        TF_CustomerService.Customer NameCustomer = (TF_CustomerService.Customer)JSON.deserialize(identifireTypeName, TF_CustomerService.Customer.class);
        TF_AddCustomerImpl.addOrUpdateContact(NameCustomer.contact); 
        
        String identifireTypeRingGoldId= '{"contact":{"partyId":"string","dob":"04-17-1998","firstName":"Test","fullName":"TestAddCustomer","lastName":"AddCustomer","orcid":"string","partySfdcId":"string","addressList":[{"addressId":"string","addressLine1":"108 ","addressLine2":"Oak Valley Dr.","addressLine3":"Suitland, MD 20746","addressEndDate":"timestamp","addressStartDate":"timestamp","addressType":"billing","city":"AL","postalCode":"36067","state":"Alabama","country":"United States","province":"","contactType":"primary","bpNumber":"string","bpPartnerFunction":"SP","bpBusinessPartnerFunction":"string","countryCode":"","usStateCode":"","emailAddress":"testRandom@gmail.com","title":"string","firstName":"string","lastName":"string","telephone":"string","taxRegistrationNumber":"string","taxNumberCategory":"string"},{"addressId":"string","addressLine1":"108 ","addressLine2":"Oak Valley Dr.","addressLine3":"Suitland, MD 20746","addressEndDate":"timestamp","addressStartDate":"timestamp","addressType":"shipping","city":"AL","postalCode":"36067","state":"Alabama","country":"United States","province":"","contactType":"primary","bpNumber":"string","bpPartnerFunction":"SP","bpBusinessPartnerFunction":"string","countryCode":"","usStateCode":"","emailAddress":"testRandom@gmail.com","title":"string","firstName":"string","lastName":"string","telephone":"string","taxRegistrationNumber":"string","taxNumberCategory":"string"}],"contactList":[{"contactNumber":"51251521365","email":"pskov@gmail.com","partySfdcId":"string","contactType":"primary"}],"relationships":[{"identifierType":"ringGoldId","identifierValue":"12345","relationshipType":"librarian_admin"}],"preferences":[{"preferenceName":"opt_in","preferenceValue":"false"}],"references":[]}}';
        TF_CustomerService.Customer RingGoldIdCustomer = (TF_CustomerService.Customer)JSON.deserialize(identifireTypeRingGoldId, TF_CustomerService.Customer.class);
        TF_AddCustomerImpl.addOrUpdateContact(RingGoldIdCustomer.contact); 
        
        String identifireTypeDomain= '{"contact":{"partyId":"string","dob":"04-17-1998","firstName":"Test","fullName":"TestAddCustomer","lastName":"AddCustomer","orcid":"string","partySfdcId":"string","addressList":[{"addressId":"string","addressLine1":"108 ","addressLine2":"Oak Valley Dr.","addressLine3":"Suitland, MD 20746","addressEndDate":"timestamp","addressStartDate":"timestamp","addressType":"billing","city":"AL","postalCode":"36067","state":"Alabama","country":"United States","province":"","contactType":"primary","bpNumber":"string","bpPartnerFunction":"SP","bpBusinessPartnerFunction":"string","countryCode":"","usStateCode":"","emailAddress":"testRandom@gmail.com","title":"string","firstName":"string","lastName":"string","telephone":"string","taxRegistrationNumber":"string","taxNumberCategory":"string"},{"addressId":"string","addressLine1":"108 ","addressLine2":"Oak Valley Dr.","addressLine3":"Suitland, MD 20746","addressEndDate":"timestamp","addressStartDate":"timestamp","addressType":"shipping","city":"AL","postalCode":"36067","state":"Alabama","country":"United States","province":"","contactType":"primary","bpNumber":"string","bpPartnerFunction":"SP","bpBusinessPartnerFunction":"string","countryCode":"","usStateCode":"","emailAddress":"testRandom@gmail.com","title":"string","firstName":"string","lastName":"string","telephone":"string","taxRegistrationNumber":"string","taxNumberCategory":"string"}],"contactList":[{"contactNumber":"51251521365","email":"pskov@gmail.com","partySfdcId":"string","contactType":"primary"}],"relationships":[{"identifierType":"name","identifierValue":"Test","relationshipType":"librarian_admin"}],"preferences":[{"preferenceName":"opt_in","preferenceValue":"false"}],"references":[]}}';
        TF_CustomerService.Customer DomainCustomer = (TF_CustomerService.Customer)JSON.deserialize(identifireTypeDomain, TF_CustomerService.Customer.class);
        TF_AddCustomerImpl.addOrUpdateContact(DomainCustomer.contact); 
    
        String allReferenceNames= '{"contact":{"partyId":"string","dob":"04-17-1998","firstName":"Test","fullName":"TestAddCustomer","lastName":"AddCustomer","orcid":"string","partySfdcId":"string","addressList":[{"addressId":"string","addressLine1":"108 ","addressLine2":"Oak Valley Dr.","addressLine3":"Suitland, MD 20746","addressEndDate":"timestamp","addressStartDate":"timestamp","addressType":"billing","city":"AL","postalCode":"36067","state":"Alabama","country":"United States","province":"","contactType":"primary","bpNumber":"string","bpPartnerFunction":"SP","bpBusinessPartnerFunction":"string","countryCode":"","usStateCode":"","emailAddress":"testRandom@gmail.com","title":"string","firstName":"string","lastName":"string","telephone":"string","taxRegistrationNumber":"string","taxNumberCategory":"string"},{"addressId":"string","addressLine1":"108 ","addressLine2":"Oak Valley Dr.","addressLine3":"Suitland, MD 20746","addressEndDate":"timestamp","addressStartDate":"timestamp","addressType":"shipping","city":"AL","postalCode":"36067","state":"Alabama","country":"United States","province":"","contactType":"primary","bpNumber":"string","bpPartnerFunction":"SP","bpBusinessPartnerFunction":"string","countryCode":"","usStateCode":"","emailAddress":"testRandom@gmail.com","title":"string","firstName":"string","lastName":"string","telephone":"string","taxRegistrationNumber":"string","taxNumberCategory":"string"}],"contactList":[{"contactNumber":"51251521365","email":"rostov@gmail.com","partySfdcId":"string","contactType":"alternate"}],"relationships":[{"identifierType":"name","identifierValue":"Test","relationshipType":"librarian_admin"}],"preferences":[{"preferenceName":"opt_out","preferenceValue":"true"}],"references":[]}}';
        TF_CustomerService.Customer referenceCustomer = (TF_CustomerService.Customer)JSON.deserialize(allReferenceNames, TF_CustomerService.Customer.class);
        TF_AddCustomerImpl.addOrUpdateContact(referenceCustomer.contact); 
       
        String contactDetails= '{"contact":{"partyId":"string","dob":"04-17-1998","firstName":"Test","fullName":"TestAddCustomer","lastName":"AddCustomer","orcid":"string","partySfdcId":"string","addressList":[{"addressId":"string","addressLine1":"108 ","addressLine2":"Oak Valley Dr.","addressLine3":"Suitland, MD 20746","addressEndDate":"timestamp","addressStartDate":"timestamp","addressType":"billing","city":"AL","postalCode":"36067","state":"Alabama","country":"United States","province":"","contactType":"primary","bpNumber":"string","bpPartnerFunction":"SP","bpBusinessPartnerFunction":"string","countryCode":"","usStateCode":"","emailAddress":"testRandom@gmail.com","title":"string","firstName":"string","lastName":"string","telephone":"string","taxRegistrationNumber":"string","taxNumberCategory":"string"},{"addressId":"string","addressLine1":"108 ","addressLine2":"Oak Valley Dr.","addressLine3":"Suitland, MD 20746","addressEndDate":"timestamp","addressStartDate":"timestamp","addressType":"shipping","city":"AL","postalCode":"36067","state":"Alabama","country":"United States","province":"","contactType":"primary","bpNumber":"string","bpPartnerFunction":"SP","bpBusinessPartnerFunction":"string","countryCode":"","usStateCode":"","emailAddress":"testRandom@gmail.com","title":"string","firstName":"string","lastName":"string","telephone":"string","taxRegistrationNumber":"string","taxNumberCategory":"string"}],"contactList":[{"contactNumber":"51251521365","email":"rostov@gmail.com","partySfdcId":"string","contactType":"alternate"}],"relationships":[{"identifierType":"name","identifierValue":"Test","relationshipType":"librarian_admin"}],"preferences":[{"preferenceName":"opt_out","preferenceValue":"true"}],"references":[]}}';
        TF_CustomerService.Customer customerDetailref = (TF_CustomerService.Customer)JSON.deserialize(contactDetails, TF_CustomerService.Customer.class);
        TF_AddCustomerImpl.validateContactDetails(customerDetailref.contact); 
        
    	String identifireValueMissing= '{"contact":{"partyId":"string","dob":"04-17-1998","firstName":"Test","fullName":"TestAddCustomer","lastName":"AddCustomer","orcid":"string","partySfdcId":"string","addressList":[{"addressId":"string","addressLine1":"108 ","addressLine2":"Oak Valley Dr.","addressLine3":"Suitland, MD 20746","addressEndDate":"timestamp","addressStartDate":"timestamp","addressType":"billing","city":"AL","postalCode":"36067","state":"Alabama","country":"United States","province":"","contactType":"primary","bpNumber":"string","bpPartnerFunction":"SP","bpBusinessPartnerFunction":"string","countryCode":"","usStateCode":"","emailAddress":"testRandom@gmail.com","title":"string","firstName":"string","lastName":"string","telephone":"string","taxRegistrationNumber":"string","taxNumberCategory":"string"},{"addressId":"string","addressLine1":"108 ","addressLine2":"Oak Valley Dr.","addressLine3":"Suitland, MD 20746","addressEndDate":"timestamp","addressStartDate":"timestamp","addressType":"shipping","city":"AL","postalCode":"36067","state":"Alabama","country":"United States","province":"","contactType":"primary","bpNumber":"string","bpPartnerFunction":"SP","bpBusinessPartnerFunction":"string","countryCode":"","usStateCode":"","emailAddress":"testRandom@gmail.com","title":"string","firstName":"string","lastName":"string","telephone":"string","taxRegistrationNumber":"string","taxNumberCategory":"string"}],"contactList":[{"contactNumber":"51251521365","email":"pskov@gmail.com","partySfdcId":"string","contactType":"primary"}],"relationships":[{"identifierType":"sfid","identifierValue":"","relationshipType":"librarian_admin"}],"preferences":[{"preferenceName":"opt_in","preferenceValue":"false"}],"references":[]}}';
        TF_CustomerService.Customer bucketAccount = (TF_CustomerService.Customer)JSON.deserialize(identifireValueMissing, TF_CustomerService.Customer.class);
        TF_AddCustomerImpl.addOrUpdateContact(bucketAccount.contact); 
        
    }  
    
    @isTest
    private static void test_validateContactDetails_ContactListwith2samecontacttype(){
        
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        insert testAccount;

        try{
            Test.startTest();
			String contactDetails = '{"contact":{"partyId":"12323657","dob":"04-17-1998","firstName":"Tester","fullName":"string","lastName":"Test1","orcid":"string","partySfdcId":"string","addressList":[{"addressId":"string","addressLine1":"108","addressLine2":"Oak Valley Dr.","addressLine3":"Suitland, MD 20746","addressEndDate":"timestamp","addressStartDate":"timestamp","addressType":"billing","city":"AL","postalCode":"36067","state":"Alabama","country":"United States","province":"","contactType":"primary","bpNumber":"string","bpPartnerFunction":"SP","bpBusinessPartnerFunction":"string","countryCode":"string","usStateCode":"string","emailAddress":"string","title":"string","firstName":"string","lastName":"string","telephone":"string","taxRegistrationNumber":"string","taxNumberCategory":"string"}],"contactList":[{"contactNumber":"51251521365","email":"test1234@xyz.com","partySfdcId":"string","contactType":"primary"},{"contactNumber":"51251521265","email":"test1231@xyz.com","partySfdcId":"string","contactType":"primary"}],"relationships":[{"identifierType":"sfid","identifierValue":"'+testAccount.id+'","relationshipType":"librarian_admin"}],"preferences":[{"preferenceName":"opt_in","preferenceValue":"s"}],"references":[]},"organisations":[]}';          
            TF_CustomerService.Customer customerDetailref = (TF_CustomerService.Customer)JSON.deserialize(contactDetails, TF_CustomerService.Customer.class);
            TF_AddCustomerImpl.validateContactDetails(customerDetailref.contact);
            Test.stopTest();
        }catch(Exception ex){
            System.assertEquals('Both Contacts cannot have the same type',ex.getMessage());
        }
        

    }
    
    @isTest
    private static void test_validateContactDetails_WithMoreThan2Contacts(){
        
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        insert testAccount;

        try{
            Test.startTest();
			String contactDetails = '{"contact":{"partyId":"12323657","dob":"04-17-1998","firstName":"Tester","fullName":"string","lastName":"Test1","orcid":"string","partySfdcId":"string","addressList":[{"addressId":"string","addressLine1":"108","addressLine2":"Oak Valley Dr.","addressLine3":"Suitland, MD 20746","addressEndDate":"timestamp","addressStartDate":"timestamp","addressType":"billing","city":"AL","postalCode":"36067","state":"Alabama","country":"United States","province":"","contactType":"primary","bpNumber":"string","bpPartnerFunction":"SP","bpBusinessPartnerFunction":"string","countryCode":"string","usStateCode":"string","emailAddress":"string","title":"string","firstName":"string","lastName":"string","telephone":"string","taxRegistrationNumber":"string","taxNumberCategory":"string"}],"contactList":[{"contactNumber":"51251521365","email":"test1234@xyz.com","partySfdcId":"string","contactType":"primary"},{"contactNumber":"51251521265","email":"test1231@xyz.com","partySfdcId":"string","contactType":"alternate"},{"contactNumber":"51251521265","email":"test1231@xyz.com","partySfdcId":"string","contactType":"alternate"}],"relationships":[{"identifierType":"sfid","identifierValue":"'+testAccount.id+'","relationshipType":"librarian_admin"}],"preferences":[{"preferenceName":"opt_in","preferenceValue":"s"}],"references":[]}}';           
            TF_CustomerService.Customer customerDetailref = (TF_CustomerService.Customer)JSON.deserialize(contactDetails, TF_CustomerService.Customer.class);
            TF_AddCustomerImpl.validateContactDetails(customerDetailref.contact);
            Test.stopTest();
        }catch(Exception ex){
            System.assertEquals('Request can have maximum 2 contacts in contactList',ex.getMessage());
        }
        

    }
    
    @isTest
    private static void test_validateContactDetails_emailNotValid(){
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        insert testAccount;
        
        try{
            Test.startTest();
			String contactDetails = '{"contact":{"partyId":"12323657","dob":"04-17-1998","firstName":"Tester","fullName":"string","lastName":"Test1","orcid":"string","partySfdcId":"string","addressList":[{"addressId":"string","addressLine1":"108","addressLine2":"Oak Valley Dr.","addressLine3":"Suitland, MD 20746","addressEndDate":"timestamp","addressStartDate":"timestamp","addressType":"billing","city":"AL","postalCode":"36067","state":"Alabama","country":"United States","province":"","contactType":"primary","bpNumber":"string","bpPartnerFunction":"SP","bpBusinessPartnerFunction":"string","countryCode":"string","usStateCode":"string","emailAddress":"string","title":"string","firstName":"string","lastName":"string","telephone":"string","taxRegistrationNumber":"string","taxNumberCategory":"string"}],"contactList":[{"contactNumber":"51251521365","email":"test1234xyz.com","partySfdcId":"string","contactType":"primary"}],"relationships":[{"identifierType":"sfid","identifierValue":"'+testAccount.id+'","relationshipType":"librarian_admin"}],"preferences":[{"preferenceName":"opt_in","preferenceValue":"s"}],"references":[]}}';
            TF_CustomerService.Customer customerDetailref = (TF_CustomerService.Customer)JSON.deserialize(contactDetails, TF_CustomerService.Customer.class);
            TF_AddCustomerImpl.validateContactDetails(customerDetailref.contact);
            Test.stopTest();
        } catch(Exception ex){
            System.assertEquals('Contact email is invalid',ex.getMessage());
        }

    }
    
    @isTest
    private static void test_validateContactDetails_AddressListwith2SameAddresstype(){
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        insert testAccount;
        
        try{
            Test.startTest();
			String contactDetails = '{"contact":{"partyId":"12323657","dob":"04-17-1998","firstName":"Tester","fullName":"string","lastName":"Test1","orcid":"string","partySfdcId":"string","addressList":[{"addressId":"string","addressLine1":"108","addressLine2":"Oak Valley Dr.","addressLine3":"Suitland, MD 20746","addressEndDate":"timestamp","addressStartDate":"timestamp","addressType":"billing","city":"AL","postalCode":"36067","state":"Alabama","country":"United States","province":"","contactType":"primary","bpNumber":"string","bpPartnerFunction":"SP","bpBusinessPartnerFunction":"string","countryCode":"string","usStateCode":"string","emailAddress":"string","title":"string","firstName":"string","lastName":"string","telephone":"string","taxRegistrationNumber":"string","taxNumberCategory":"string"},{"addressId":"string","addressLine1":"109","addressLine2":"Oak Valley Dr.","addressLine3":"Suitland, AMD 20746","addressEndDate":"timestamp","addressStartDate":"timestamp","addressType":"billing","city":"AL","postalCode":"36067","state":"Alabama","country":"United States","province":"","contactType":"primary","bpNumber":"string","bpPartnerFunction":"SP","bpBusinessPartnerFunction":"string","countryCode":"string","usStateCode":"string","emailAddress":"string","title":"string","firstName":"string","lastName":"string","telephone":"string","taxRegistrationNumber":"string","taxNumberCategory":"string"}],"contactList":[{"contactNumber":"51251521365","email":"test1234@xyz.com","partySfdcId":"string","contactType":"primary"}],"relationships":[{"identifierType":"sfid","identifierValue":"'+testAccount.id+'","relationshipType":"librarian_admin"}],"preferences":[{"preferenceName":"opt_in","preferenceValue":"s"}],"references":[]}}';

            TF_CustomerService.Customer customerDetailref = (TF_CustomerService.Customer)JSON.deserialize(contactDetails, TF_CustomerService.Customer.class);
            TF_AddCustomerImpl.validateContactDetails(customerDetailref.contact);
            Test.stopTest();
        } catch(Exception ex){
            System.assertEquals('Contact cannot have more than one Address with Same Address Type',ex.getMessage());
        }

    }
    
    @isTest
    private static void test_validateContactDetails_withMoreThan2Addresses(){
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        insert testAccount;
        
        try{
            Test.startTest();
			String contactDetails = '{"contact":{"partyId":"12323657","dob":"04-17-1998","firstName":"Tester","fullName":"string","lastName":"Test1","orcid":"string","partySfdcId":"string","addressList":[{"addressId":"string","addressLine1":"108","addressLine2":"Oak Valley Dr.","addressLine3":"Suitland, MD 20746","addressEndDate":"timestamp","addressStartDate":"timestamp","addressType":"billing","city":"AL","postalCode":"36067","state":"Alabama","country":"United States","province":"","contactType":"primary","bpNumber":"string","bpPartnerFunction":"SP","bpBusinessPartnerFunction":"string","countryCode":"string","usStateCode":"string","emailAddress":"string","title":"string","firstName":"string","lastName":"string","telephone":"string","taxRegistrationNumber":"string","taxNumberCategory":"string"},{"addressId":"string","addressLine1":"109","addressLine2":"Oak Valley Dr.","addressLine3":"Suitland, AMD 20746","addressEndDate":"timestamp","addressStartDate":"timestamp","addressType":"shipping","city":"AL","postalCode":"36067","state":"Alabama","country":"United States","province":"","contactType":"primary","bpNumber":"string","bpPartnerFunction":"SP","bpBusinessPartnerFunction":"string","countryCode":"string","usStateCode":"string","emailAddress":"string","title":"string","firstName":"string","lastName":"string","telephone":"string","taxRegistrationNumber":"string","taxNumberCategory":"string"},{"addressId":"string","addressLine1":"109","addressLine2":"Oak Valley Dr.","addressLine3":"Suitland, AMD 20746","addressEndDate":"timestamp","addressStartDate":"timestamp","addressType":"mailing","city":"AL","postalCode":"36067","state":"Alabama","country":"United States","province":"","contactType":"primary","bpNumber":"string","bpPartnerFunction":"SP","bpBusinessPartnerFunction":"string","countryCode":"string","usStateCode":"string","emailAddress":"string","title":"string","firstName":"string","lastName":"string","telephone":"string","taxRegistrationNumber":"string","taxNumberCategory":"string"}],"contactList":[{"contactNumber":"51251521365","email":"test1234@xyz.com","partySfdcId":"string","contactType":"primary"}],"relationships":[{"identifierType":"sfid","identifierValue":"'+testAccount.id+'","relationshipType":"librarian_admin"}],"preferences":[{"preferenceName":"opt_in","preferenceValue":"s"}],"references":[]}}';

            TF_CustomerService.Customer customerDetailref = (TF_CustomerService.Customer)JSON.deserialize(contactDetails, TF_CustomerService.Customer.class);
            TF_AddCustomerImpl.validateContactDetails(customerDetailref.contact);
            Test.stopTest();
        } catch(Exception ex){
            System.assertEquals('Contact request can have maximum 2 Addresses',ex.getMessage());
        }

    }
    
    @isTest
    private static void test_initializedefaultvalues_ContactType(){
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        insert testAccount;
        
        Test.startTest();
        String updateContact = '{ "contact": { "partyId": "12323657", "dob": "04-17-1998", "firstName": "Tester", "fullName": "string", "lastName": "Test1", "orcid": "string", "partySfdcId": "string", "addressList": [{ "addressId": "string", "addressLine1": "108", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "contactList": [{ "contactNumber": "51251521365", "email": "test1234@xyz.com", "partySfdcId": "string" },{ "contactNumber": "51251521265", "email": "test1231@xyz.com", "partySfdcId": "string", "contactType": "primary" }], "relationships": [{ "identifierType": "sfid", "identifierValue": "'+testAccount.id+'", "relationshipType": "librarian_admin" }], "preferences": [{ "preferenceName": "opt_in", "preferenceValue": "s" }], "references": [{ "orgId": "<organisation party id>", "name": "OPENATHENS", "id": "<value of reference attribute>" }] }, "organisations": [{ "partyId": "string", "name": "string", "parentRingGoldId": "string", "ringGoldId": "string", "sourceOrgId": "", "organisationType": "consortium", "partySfdcId": "", "description": "string", "isni": "string", "isniName": "string", "url": "string", "comments": "string", "isTestOrg": "boolean", "sfdcEnrollment": "string", "sfdcCategory": "srtring", "sfdcNumberOfEmployees": "number", "sfdcClassification": "string", "sfdcType": "string", "sfdcLegalSubcategory": "string", "addressList": [{ "addressId": "string", "addressLine1": "string", "addressLine2": "string", "addressLine3": "string", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "string", "postalCode": "string", "state": "string", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [{ "identifierType": "ringGoldId", "identifierValue": "<toIdentifyOrg>", "objectType": "consortium", "relationshipType": "child/parent" }] }, { "name": "string", "parentRingGoldId": "string", "ringGoldId": "string", "sourceOrgId": "", "organisationType": "string<lookup>", "partySfdcId": "", "description": "string", "isni": "string", "isniName": "string", "url": "string", "comments": "string", "isTestOrg": "boolean", "addressList": [{ "addressLine1": "string", "addressLine2": "string", "addressLine3": "string", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "string", "postalCode": "string", "state": "string", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [] } ] }';
        TF_CustomerService.Customer updateCustomerRequest = (TF_CustomerService.Customer)JSON.deserialize(updateContact, TF_CustomerService.Customer.class);
        TF_CustomerService.Customer updateCustomerRequestNew = TF_AddCustomerImpl.initializeDefaultValue(updateCustomerRequest);
        System.assertEquals(TF_CustomerService.ContactType.primary, updateCustomerRequestNew.contact.contactList[0].contactType);
        Test.stopTest();
    }
    
    @isTest
    private static void test_initializedefaultvalues_addressType(){
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        insert testAccount;
        
        Test.startTest();
        String updateContact = '{ "contact": { "partyId": "12323657", "dob": "04-17-1998", "firstName": "Tester", "fullName": "string", "lastName": "Test1", "orcid": "string", "partySfdcId": "string", "addressList": [{ "addressId": "string", "addressLine1": "108", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "contactList": [{ "contactNumber": "51251521365", "email": "test1234@xyz.com", "partySfdcId": "string" },{ "contactNumber": "51251521265", "email": "test1231@xyz.com", "partySfdcId": "string", "contactType": "primary" }], "relationships": [{ "identifierType": "sfid", "identifierValue": "'+testAccount.id+'", "relationshipType": "librarian_admin" }], "preferences": [{ "preferenceName": "opt_in", "preferenceValue": "s" }], "references": [{ "orgId": "<organisation party id>", "name": "OPENATHENS", "id": "<value of reference attribute>" }] }, "organisations": [{ "partyId": "string", "name": "string", "parentRingGoldId": "string", "ringGoldId": "string", "sourceOrgId": "", "organisationType": "consortium", "partySfdcId": "", "description": "string", "isni": "string", "isniName": "string", "url": "string", "comments": "string", "isTestOrg": "boolean", "sfdcEnrollment": "string", "sfdcCategory": "srtring", "sfdcNumberOfEmployees": "number", "sfdcClassification": "string", "sfdcType": "string", "sfdcLegalSubcategory": "string", "addressList": [{ "addressId": "string", "addressLine1": "string", "addressLine2": "string", "addressLine3": "string", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "string", "postalCode": "string", "state": "string", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [{ "identifierType": "ringGoldId", "identifierValue": "<toIdentifyOrg>", "objectType": "consortium", "relationshipType": "child/parent" }] }, { "name": "string", "parentRingGoldId": "string", "ringGoldId": "string", "sourceOrgId": "", "organisationType": "string<lookup>", "partySfdcId": "", "description": "string", "isni": "string", "isniName": "string", "url": "string", "comments": "string", "isTestOrg": "boolean", "addressList": [{ "addressLine1": "string", "addressLine2": "string", "addressLine3": "string", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "string", "postalCode": "string", "state": "string", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [] } ] }';
        TF_CustomerService.Customer updateCustomerRequest = (TF_CustomerService.Customer)JSON.deserialize(updateContact, TF_CustomerService.Customer.class);
        TF_CustomerService.Customer updateCustomerRequestNew = TF_AddCustomerImpl.initializeDefaultValue(updateCustomerRequest);
        System.assertEquals(TF_CustomerService.AddressType.billing, updateCustomerRequestNew.contact.addressList[0].addressType);
        Test.stopTest();
    }
    
    @isTest
    private static void test_updateCustomer(){
       
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        insert testAccount;

        Contact newContact = new Contact();
        newContact.email = 'test1234@xyz.com';
        newContact.Party_Id__c = '12323657';
        newContact.FirstName = 'test';
        newContact.LastName = '01';
        Test.startTest();
        insert newContact;
        
        String updateContact ='{ "contact": { "partyId": "12323657", "dob": "04-17-1998", "firstName": "Tester", "fullName": "string", "lastName": "Test1", "orcid": "string", "partySfdcId": "string", "addressList": [{ "addressId": "string", "addressLine1": "108", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "contactList": [{ "contactNumber": "51251521365", "partySfdcId": "string", "contactType": "primary" }], "relationships": [{ "identifierType": "sfid", "identifierValue": "'+testAccount.id+'", "relationshipType": "librarian_admin" }], "preferences": [{ "preferenceName": "opt_in", "preferenceValue": "s" }], "references": [{ "orgId": "<organisation party id>", "name": "OPENATHENS", "id": "<value of reference attribute>" }] }, "organisations": [{ "partyId": "string", "name": "string", "parentRingGoldId": "string", "ringGoldId": "string", "sourceOrgId": "", "organisationType": "consortium", "partySfdcId": "", "description": "string", "isni": "string", "isniName": "string", "url": "string", "comments": "string", "isTestOrg": "boolean", "sfdcEnrollment": "string", "sfdcCategory": "srtring", "sfdcNumberOfEmployees": "number", "sfdcClassification": "string", "sfdcType": "string", "sfdcLegalSubcategory": "string", "addressList": [{ "addressId": "string", "addressLine1": "string", "addressLine2": "string", "addressLine3": "string", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "string", "postalCode": "string", "state": "string", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [{ "identifierType": "ringGoldId", "identifierValue": "<toIdentifyOrg>", "objectType": "consortium", "relationshipType": "child/parent" }] }, { "name": "string", "parentRingGoldId": "string", "ringGoldId": "string", "sourceOrgId": "", "organisationType": "string<lookup>", "partySfdcId": "", "description": "string", "isni": "string", "isniName": "string", "url": "string", "comments": "string", "isTestOrg": "boolean", "addressList": [{ "addressLine1": "string", "addressLine2": "string", "addressLine3": "string", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "string", "postalCode": "string", "state": "string", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [] } ] }';
        TF_CustomerService.Customer updateCustomerRequest = (TF_CustomerService.Customer)JSON.deserialize(updateContact, TF_CustomerService.Customer.class);
        TF_AddCustomerImpl.updateContact(updateCustomerRequest.contact, newContact);
        
        Test.stopTest();
        List<contact> contactList = [SELECT id, Email, FirstName, LastName, AccountId, Party_Id__c FROM Contact WHERE Party_Id__c = '12323657' limit 1];
        System.assert(contactList != null);
        System.assertEquals(contactList.size(),1);
        System.assertEquals(contactList[0].FirstName, 'Tester');
        
        List< Platform_Role__c> platformRoleList = [SELECT id, Name, Account__c,Contact__c,Platform__c,Roles__c FROM Platform_Role__c WHERE Contact__c =: contactList[0].id ];
        System.assert(platformRoleList != null);
        System.assertEquals(platformRoleList.size(),1);
        System.assertEquals(testAccount.id,platformRoleList[0].Account__c);
        System.assertEquals('librarian_admin',platformRoleList[0].Roles__c);
    }
    
    @isTest
    private static void test_addorupdateCustomer_platformRoleCheck(){
        Account testAccount = new Account (Name= 'Test', Type = 'Other', Classification__c = 'Other', CurrencyIsoCode = 'USD',Mailing_Country_List__c = 'United Kingdom', Locale__c = 'APAC', Sales_Region__c = 'Africa', Shipping_Country_List__c = 'United Kingdom', Ringgold_Account_ID__c = '12345');
        insert testAccount;
        Test.startTest();
        
        String insertContact= '{ "contact": { "partyId": "string", "dob": "04-17-1998", "firstName": "Tester", "fullName": "TestAddCustomer", "lastName": "AddCustomer", "orcid": "string", "partySfdcId": "string", "addressList": [{ "addressId": "string", "addressLine1": "108 ", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "", "usStateCode": "", "emailAddress": "testRandom@gmail.com", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }, { "addressId": "string", "addressLine1": "108 ", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "shipping", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "", "usStateCode": "", "emailAddress": "testRandom@gmail.com", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "contactList": [{ "contactNumber": "51251521365", "email": "kazan@gmail.com", "partySfdcId": "string", "contactType": "primary" }, { "contactNumber": "51251521365", "email": "omsk@gmail.com", "partySfdcId": "string", "contactType": "alternate" } ], "relationships": [{ "identifierType": "sfid", "identifierValue": "'+testAccount.id+'", "relationshipType": "librarian_admin" }, { "identifierType": "name", "identifierValue": "test", "relationshipType": "librarian_admin" }, { "identifierType": "ringGoldId", "identifierValue": "12345", "relationshipType": "librarian_admin" } ], "preferences": [{ "preferenceName": "opt_out", "preferenceValue": "true" }], "references": [{ "orgId": "<organisation party id>", "name": "OPENATHENS", "id": "<value of reference attribute>" }] }, "organisations": [{ "partyId": "string", "name": "string", "parentRingGoldId": "string", "ringGoldId": "string", "sourceOrgId": "", "organisationType": "consortium", "partySfdcId": "", "description": "string", "isni": "string", "isniName": "string", "url": "string", "comments": "string", "isTestOrg": "boolean", "sfdcEnrollment": "string", "sfdcCategory": "srtring", "sfdcNumberOfEmployees": "number", "sfdcClassification": "string", "sfdcType": "string", "sfdcLegalSubcategory": "string", "addressList": [{ "addressId": "string", "addressLine1": "string", "addressLine2": "string", "addressLine3": "string", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "string", "postalCode": "string", "state": "string", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [{ "identifierType": "ringGoldId", "identifierValue": "12345", "objectType": "consortium", "relationshipType": "child/parent" }] }, { "name": "string", "parentRingGoldId": "string", "ringGoldId": "string", "sourceOrgId": "", "organisationType": "string<lookup>", "partySfdcId": "", "description": "string", "isni": "string", "isniName": "string", "url": "string", "comments": "string", "isTestOrg": "boolean", "addressList": [{ "addressLine1": "string", "addressLine2": "string", "addressLine3": "string", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "string", "postalCode": "string", "state": "string", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [] }] }';
        TF_CustomerService.Customer addCustomer = (TF_CustomerService.Customer)JSON.deserialize(insertContact, TF_CustomerService.Customer.class);
        TF_AddCustomerImpl.addOrUpdateContact(addCustomer.contact);
        
        Test.stopTest();
        List<contact> contactList = [SELECT id, Email, FirstName, LastName, AccountId, Party_Id__c FROM Contact WHERE AccountId  =:testAccount.id  limit 1];
        System.assert(contactList != null);
        System.assertEquals(contactList.size(),1);
        System.assertEquals(contactList[0].FirstName, 'Tester');
        
        List< Platform_Role__c> platformRoleList = [SELECT id, Name, Account__c,Contact__c,Platform__c,Roles__c FROM Platform_Role__c WHERE Contact__c =: contactList[0].id ];
        System.assert(platformRoleList != null);
        System.assertEquals(platformRoleList.size(),1);
        System.assertEquals(testAccount.id,platformRoleList[0].Account__c);
        System.assertEquals('librarian_admin',platformRoleList[0].Roles__c);
    }
    
    @isTest
    private static void test_updateCustomer_updatePlatformRole(){
       
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        insert testAccount;

        Contact newContact = new Contact();
        newContact.email = 'test1234@xyz.com';
        newContact.Party_Id__c = '12323657';
        newContact.FirstName = 'test';
        newContact.LastName = '01';
        Test.startTest();
        insert newContact;
        Platform_Role__c newPlatformRole = new Platform_Role__c();
        newPlatformRole.Account__c = testAccount.id;
        newPlatformRole.Contact__c = newContact.id;
        newPlatformRole.Roles__c = 'admin';
        newPlatformRole.Platform__c = 'UBX';
        insert newPlatformRole;
        String updateContact ='{ "contact": { "partyId": "12323657", "dob": "04-17-1998", "firstName": "Tester", "fullName": "string", "lastName": "Test1", "orcid": "string", "partySfdcId": "string", "addressList": [{ "addressId": "string", "addressLine1": "108", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "contactList": [{ "contactNumber": "51251521365", "partySfdcId": "string", "contactType": "primary" }], "relationships": [{ "identifierType": "sfid", "identifierValue": "'+testAccount.id+'", "relationshipType": "librarian_admin" }], "preferences": [{ "preferenceName": "opt_in", "preferenceValue": "s" }], "references": [{ "orgId": "<organisation party id>", "name": "OPENATHENS", "id": "<value of reference attribute>" }] }, "organisations": [{ "partyId": "string", "name": "string", "parentRingGoldId": "string", "ringGoldId": "string", "sourceOrgId": "", "organisationType": "consortium", "partySfdcId": "", "description": "string", "isni": "string", "isniName": "string", "url": "string", "comments": "string", "isTestOrg": "boolean", "sfdcEnrollment": "string", "sfdcCategory": "srtring", "sfdcNumberOfEmployees": "number", "sfdcClassification": "string", "sfdcType": "string", "sfdcLegalSubcategory": "string", "addressList": [{ "addressId": "string", "addressLine1": "string", "addressLine2": "string", "addressLine3": "string", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "string", "postalCode": "string", "state": "string", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [{ "identifierType": "ringGoldId", "identifierValue": "<toIdentifyOrg>", "objectType": "consortium", "relationshipType": "child/parent" }] }, { "name": "string", "parentRingGoldId": "string", "ringGoldId": "string", "sourceOrgId": "", "organisationType": "string<lookup>", "partySfdcId": "", "description": "string", "isni": "string", "isniName": "string", "url": "string", "comments": "string", "isTestOrg": "boolean", "addressList": [{ "addressLine1": "string", "addressLine2": "string", "addressLine3": "string", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "string", "postalCode": "string", "state": "string", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [] } ] }';
        TF_CustomerService.Customer updateCustomerRequest = (TF_CustomerService.Customer)JSON.deserialize(updateContact, TF_CustomerService.Customer.class);
        TF_AddCustomerImpl.updateContact(updateCustomerRequest.contact, newContact);
        
        Test.stopTest();
        List<contact> contactList = [SELECT id, Email, FirstName, LastName, AccountId, Party_Id__c FROM Contact WHERE Party_Id__c = '12323657' limit 1];
        System.assert(contactList != null);
        System.assertEquals(contactList.size(),1);
        System.assertEquals(contactList[0].FirstName, 'Tester');
        
        List< Platform_Role__c> platformRoleList = [SELECT id, Name, Account__c,Contact__c,Platform__c,Roles__c FROM Platform_Role__c WHERE Contact__c =: contactList[0].id ];
        System.assert(platformRoleList != null);
        System.assertEquals(platformRoleList.size(),1);
        System.assertEquals(testAccount.id,platformRoleList[0].Account__c);
        System.assertEquals('admin;librarian_admin',platformRoleList[0].Roles__c);
    }
    @isTest
    private static void test_updateCustomer_updatePlatformRolewithRinggoldId(){
       
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Ringgold_Account_ID__c = '1234532';
        insert testAccount;

        Contact newContact = new Contact();
        newContact.email = 'test1234@xyz.com';
        newContact.Party_Id__c = '12323657';
        newContact.FirstName = 'test';
        newContact.LastName = '01';
        Test.startTest();
        insert newContact;
        Platform_Role__c newPlatformRole = new Platform_Role__c();
        newPlatformRole.Account__c = testAccount.id;
        newPlatformRole.Contact__c = newContact.id;
        newPlatformRole.Roles__c = 'admin';
        newPlatformRole.Platform__c = 'UBX';
        insert newPlatformRole;
        String updateContact ='{ "contact": { "partyId": "12323657", "dob": "04-17-1998", "firstName": "Tester", "fullName": "string", "lastName": "Test1", "orcid": "string", "partySfdcId": "string", "addressList": [{ "addressId": "string", "addressLine1": "108", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "contactList": [{ "contactNumber": "51251521365", "partySfdcId": "string", "contactType": "primary" }], "relationships": [{ "identifierType": "ringGoldId", "identifierValue": "1234532", "relationshipType": "librarian" }], "preferences": [{ "preferenceName": "opt_in", "preferenceValue": "s" }], "references": [{ "orgId": "<organisation party id>", "name": "OPENATHENS", "id": "<value of reference attribute>" }] }, "organisations": [{ "partyId": "string", "name": "string", "parentRingGoldId": "string", "ringGoldId": "string", "sourceOrgId": "", "organisationType": "consortium", "partySfdcId": "", "description": "string", "isni": "string", "isniName": "string", "url": "string", "comments": "string", "isTestOrg": "boolean", "sfdcEnrollment": "string", "sfdcCategory": "srtring", "sfdcNumberOfEmployees": "number", "sfdcClassification": "string", "sfdcType": "string", "sfdcLegalSubcategory": "string", "addressList": [{ "addressId": "string", "addressLine1": "string", "addressLine2": "string", "addressLine3": "string", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "string", "postalCode": "string", "state": "string", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [{ "identifierType": "ringGoldId", "identifierValue": "<toIdentifyOrg>", "objectType": "consortium", "relationshipType": "child/parent" }] }, { "name": "string", "parentRingGoldId": "string", "ringGoldId": "string", "sourceOrgId": "", "organisationType": "string<lookup>", "partySfdcId": "", "description": "string", "isni": "string", "isniName": "string", "url": "string", "comments": "string", "isTestOrg": "boolean", "addressList": [{ "addressLine1": "string", "addressLine2": "string", "addressLine3": "string", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "string", "postalCode": "string", "state": "string", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [] } ] }';
        TF_CustomerService.Customer updateCustomerRequest = (TF_CustomerService.Customer)JSON.deserialize(updateContact, TF_CustomerService.Customer.class);
        TF_AddCustomerImpl.updateContact(updateCustomerRequest.contact, newContact);
        
        Test.stopTest();
        List<contact> contactList = [SELECT id, Email, FirstName, LastName, AccountId, Party_Id__c FROM Contact WHERE Party_Id__c = '12323657' limit 1];
        System.assert(contactList != null);
        System.assertEquals(contactList.size(),1);
        System.assertEquals(contactList[0].FirstName, 'Tester');
        
        List< Platform_Role__c> platformRoleList = [SELECT id, Name, Account__c,Contact__c,Platform__c,Roles__c FROM Platform_Role__c WHERE Contact__c =: contactList[0].id ];
        System.assert(platformRoleList != null);
        System.assertEquals(platformRoleList.size(),1);
        System.assertEquals(testAccount.id,platformRoleList[0].Account__c);
        System.assertEquals('admin;librarian',platformRoleList[0].Roles__c);
    }
    
    @isTest
    private static void test_updateCustomer_updatePlatformRolewithpartyId(){
       
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Ringgold_Account_ID__c = '1234532';
        testAccount.Customer_Id__c = '1155112';
        insert testAccount;

        Contact newContact = new Contact();
        newContact.email = 'test1234@xyz.com';
        newContact.Party_Id__c = '12323657';
        newContact.FirstName = 'test';
        newContact.LastName = '01';
        Test.startTest();
        insert newContact;
        Platform_Role__c newPlatformRole = new Platform_Role__c();
        newPlatformRole.Account__c = testAccount.id;
        newPlatformRole.Contact__c = newContact.id;
        newPlatformRole.Roles__c = 'admin';
        newPlatformRole.Platform__c = 'UBX';
        insert newPlatformRole;
        String updateContact ='{ "contact": { "partyId": "12323657", "dob": "04-17-1998", "firstName": "Tester", "fullName": "string", "lastName": "Test1", "orcid": "string", "partySfdcId": "string", "addressList": [{ "addressId": "string", "addressLine1": "108", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "contactList": [{ "contactNumber": "51251521365", "partySfdcId": "string", "contactType": "primary" }], "relationships": [{ "identifierType": "id", "identifierValue": "1155112", "relationshipType": "librarian" }], "preferences": [{ "preferenceName": "opt_in", "preferenceValue": "s" }], "references": [{ "orgId": "<organisation party id>", "name": "OPENATHENS", "id": "<value of reference attribute>" }] }, "organisations": [{ "partyId": "string", "name": "string", "parentRingGoldId": "string", "ringGoldId": "string", "sourceOrgId": "", "organisationType": "consortium", "partySfdcId": "", "description": "string", "isni": "string", "isniName": "string", "url": "string", "comments": "string", "isTestOrg": "boolean", "sfdcEnrollment": "string", "sfdcCategory": "srtring", "sfdcNumberOfEmployees": "number", "sfdcClassification": "string", "sfdcType": "string", "sfdcLegalSubcategory": "string", "addressList": [{ "addressId": "string", "addressLine1": "string", "addressLine2": "string", "addressLine3": "string", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "string", "postalCode": "string", "state": "string", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [{ "identifierType": "ringGoldId", "identifierValue": "<toIdentifyOrg>", "objectType": "consortium", "relationshipType": "child/parent" }] }, { "name": "string", "parentRingGoldId": "string", "ringGoldId": "string", "sourceOrgId": "", "organisationType": "string<lookup>", "partySfdcId": "", "description": "string", "isni": "string", "isniName": "string", "url": "string", "comments": "string", "isTestOrg": "boolean", "addressList": [{ "addressLine1": "string", "addressLine2": "string", "addressLine3": "string", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "string", "postalCode": "string", "state": "string", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [] } ] }';
        TF_CustomerService.Customer updateCustomerRequest = (TF_CustomerService.Customer)JSON.deserialize(updateContact, TF_CustomerService.Customer.class);
        TF_AddCustomerImpl.updateContact(updateCustomerRequest.contact, newContact);
        
        Test.stopTest();
        List<contact> contactList = [SELECT id, Email, FirstName, LastName, AccountId, Party_Id__c FROM Contact WHERE Party_Id__c = '12323657' limit 1];
        System.assert(contactList != null);
        System.assertEquals(contactList.size(),1);
        System.assertEquals(contactList[0].FirstName, 'Tester');
        
        List< Platform_Role__c> platformRoleList = [SELECT id, Name, Account__c,Contact__c,Platform__c,Roles__c FROM Platform_Role__c WHERE Contact__c =: contactList[0].id ];
        System.assert(platformRoleList != null);
        System.assertEquals(platformRoleList.size(),1);
        System.assertEquals(testAccount.id,platformRoleList[0].Account__c);
        System.assertEquals('admin;librarian',platformRoleList[0].Roles__c);
    }
    
    @isTest
    private static void test_addCustomerAddress_accountbilling(){
       
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Ringgold_Account_ID__c = '1234532';
        testAccount.Customer_Id__c = '1155112';
        insert testAccount;
        Test.startTest();
        String addrJSON='{ "addressId": "string", "addressLine1": "109", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "1237248", "bpPartnerFunction": "BP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string@json.com", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }';
        TF_CustomerService.Address addCustomerAddRequest = (TF_CustomerService.Address)JSON.deserialize(addrJSON, TF_CustomerService.Address.class);
        TF_CustomerService.BpDetails bpdetailsFromRequest = (TF_CustomerService.BpDetails)JSON.deserialize(addrJSON, TF_CustomerService.BpDetails.class);
        TF_AddCustomerImpl.addCustomerAddress(addCustomerAddRequest, '1155112', bpdetailsFromRequest);
        
        Test.stopTest();
        
        List< Account> account = [SELECT id, Name, BillingStreet,Billing_BP_Details__c,Billing_BP_Number__c,Billing_City__c,Billing_Country_List__c,Billing_Country__c,Billing_Region__c,Billing_State_List__c,Billing_State__c FROM Account WHERE id =: testAccount.id ];
        System.assert(account != null);
        System.assertEquals(account.size(),1);
        System.assertEquals('1237248', account[0].Billing_BP_Number__c);
        System.assertEquals('Alabama', account[0].Billing_State__c);
    }
    
    @isTest
    private static void test_addCustomerAddress_accountshipping(){
       
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Ringgold_Account_ID__c = '1234532';
        testAccount.Customer_Id__c = '1155112';
        insert testAccount;
        Test.startTest();
        String addrJSON='{ "addressId": "string", "addressLine1": "109", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "shipping", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "1237248", "bpPartnerFunction": "BP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string@json.com", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }';
        TF_CustomerService.Address addCustomerAddRequest = (TF_CustomerService.Address)JSON.deserialize(addrJSON, TF_CustomerService.Address.class);
        TF_CustomerService.BpDetails bpdetailsFromRequest = (TF_CustomerService.BpDetails)JSON.deserialize(addrJSON, TF_CustomerService.BpDetails.class);
        TF_AddCustomerImpl.addCustomerAddress(addCustomerAddRequest, '1155112', bpdetailsFromRequest);
        
        Test.stopTest();
        
        List< Account> account = [SELECT id, Name, ShippingCity, ShippingPostalCode, Shippingstate, Shipping_BP_Number__c FROM Account WHERE id =: testAccount.id ];
        System.assert(account != null);
        System.assertEquals(account.size(),1);
        System.assertEquals('1237248', account[0].Shipping_BP_Number__c);
        System.assertEquals('Alabama', account[0].Shippingstate);
    }
    
    @isTest
    private static void test_addCustomerAddress_accountmailing(){
       
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Ringgold_Account_ID__c = '1234532';
        testAccount.Customer_Id__c = '1155112';
        insert testAccount;
        Test.startTest();
        String addrJSON='{ "addressId": "string", "addressLine1": "109", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "mailing", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "1237248", "bpPartnerFunction": "BP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string@json.com", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }';
        TF_CustomerService.Address addCustomerAddRequest = (TF_CustomerService.Address)JSON.deserialize(addrJSON, TF_CustomerService.Address.class);
        TF_CustomerService.BpDetails bpdetailsFromRequest = (TF_CustomerService.BpDetails)JSON.deserialize(addrJSON, TF_CustomerService.BpDetails.class);
        TF_AddCustomerImpl.addCustomerAddress(addCustomerAddRequest, '1155112', bpdetailsFromRequest);
        
        Test.stopTest();
        
        List< Account> account = [SELECT id, Name, BillingCity, BillingPostalCode, Billingstate, Mailing_BP_Number__c FROM Account WHERE id =: testAccount.id ];
        System.assert(account != null);
        System.assertEquals(account.size(),1);
        System.assertEquals('1237248', account[0].Mailing_BP_Number__c);
        System.assertEquals('AL', account[0].BillingCity);
    }
    
    @isTest
    private static void test_addCustomerAddress_contactbilling(){
       
        Contact newContact = new Contact();
        newContact.email = 'test1234@xyz.com';
        newContact.Party_Id__c = '12323657';
        newContact.FirstName = 'test';
        newContact.LastName = '01';
        insert newContact;
        Test.startTest();
        String addrJSON='{ "addressId": "string", "addressLine1": "109", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "1237248", "bpPartnerFunction": "BP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string@json.com", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }';
        TF_CustomerService.Address addCustomerAddRequest = (TF_CustomerService.Address)JSON.deserialize(addrJSON, TF_CustomerService.Address.class);
        TF_CustomerService.BpDetails bpdetailsFromRequest = (TF_CustomerService.BpDetails)JSON.deserialize(addrJSON, TF_CustomerService.BpDetails.class);
        TF_AddCustomerImpl.addCustomerAddress(addCustomerAddRequest, '12323657', bpdetailsFromRequest);
        
        Test.stopTest();
        
        List<Contact> contact = [SELECT id, Name, OtherCity, OtherPostalCode, Otherstate, Billing_BP_Number__c FROM Contact WHERE id =: newContact.id ];
        System.assert(contact != null);
        System.assertEquals(contact.size(),1);
        System.assertEquals('1237248', contact[0].Billing_BP_Number__c);
        System.assertEquals('AL', contact[0].OtherCity);
    }
    
    @isTest
    private static void test_addCustomerAddress_contactshipping(){
       
        Contact newContact = new Contact();
        newContact.email = 'test1234@xyz.com';
        newContact.Party_Id__c = '12323657';
        newContact.FirstName = 'test';
        newContact.LastName = '01';
        insert newContact;
        Test.startTest();
        String addrJSON='{ "addressId": "string", "addressLine1": "109", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "shipping", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "1237248", "bpPartnerFunction": "BP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string@json.com", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }';
        TF_CustomerService.Address addCustomerAddRequest = (TF_CustomerService.Address)JSON.deserialize(addrJSON, TF_CustomerService.Address.class);
        TF_CustomerService.BpDetails bpdetailsFromRequest = (TF_CustomerService.BpDetails)JSON.deserialize(addrJSON, TF_CustomerService.BpDetails.class);
        TF_AddCustomerImpl.addCustomerAddress(addCustomerAddRequest, '12323657', bpdetailsFromRequest);
        
        Test.stopTest();
        
        List<Contact> contact = [SELECT id, Name, MailingCity, MailingPostalCode, Mailingstate, Mailing_BP_Number__c FROM Contact WHERE id =: newContact.id ];
        System.assert(contact != null);
        System.assertEquals(contact.size(),1);
        System.assertEquals('1237248', contact[0].Mailing_BP_Number__c);
        System.assertEquals('AL', contact[0].MailingCity);
    }
    
    @isTest
    private static void test_validateAddressRequest(){
       
        try{
        
        Test.startTest();
        String addrJSON='{ "addressId": "string", "addressLine1": "109", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "shipping", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "1237248", "bpPartnerFunction": "BP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "stringjsoncom", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }';
        TF_CustomerService.Address addCustomerAddRequest = (TF_CustomerService.Address)JSON.deserialize(addrJSON, TF_CustomerService.Address.class);
        TF_AddCustomerImpl.validateAddressRequest(addCustomerAddRequest);
        
        Test.stopTest();
        
        }catch(Exception ex){
            System.assertEquals('Email Address is invalid',ex.getMessage());
        }
    }
    
    @isTest
    private static void test_validateAddressRequest_invalidBPNumber(){
       
        try{
        
        Test.startTest();
        String addrJSON='{ "addressId": "string", "addressLine1": "109", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "shipping", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "12AAA48", "bpPartnerFunction": "BP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string@json.com", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }';
        TF_CustomerService.Address addCustomerAddRequest = (TF_CustomerService.Address)JSON.deserialize(addrJSON, TF_CustomerService.Address.class);
        TF_AddCustomerImpl.validateAddressRequest(addCustomerAddRequest);
        
        Test.stopTest();
        
        }catch(Exception ex){
            System.assertEquals('Invalid BP Number. Only numeric digits are accepted',ex.getMessage());
        }
    }
    
    @isTest
    private static void test_validateAddressRequest_invalidBPpartnerFunction(){
       
        try{
        
        Test.startTest();
        String addrJSON='{ "addressId": "string", "addressLine1": "109", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "shipping", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "12948", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string@json.com", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }';
        TF_CustomerService.Address addCustomerAddRequest = (TF_CustomerService.Address)JSON.deserialize(addrJSON, TF_CustomerService.Address.class);
        TF_AddCustomerImpl.validateAddressRequest(addCustomerAddRequest);
        
        Test.stopTest();
        
        }catch(Exception ex){
            System.assertEquals('BP partner function is missing.',ex.getMessage());
        }
    }
    
    @isTest
    private static void test_updateCustomerAddress_contactbilling(){
       
        Contact newContact = new Contact();
        newContact.email = 'test1234@xyz.com';
        newContact.Party_Id__c = '12323657';
        newContact.FirstName = 'test';
        newContact.LastName = '01';
        insert newContact;
        Test.startTest();
        String addrJSON='{ "addressId": "string", "addressLine1": "109", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "1237248", "bpPartnerFunction": "BP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string@json.com", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }';
        TF_CustomerService.Address addCustomerAddRequest = (TF_CustomerService.Address)JSON.deserialize(addrJSON, TF_CustomerService.Address.class);
        TF_CustomerService.BpDetails bpdetailsFromRequest = (TF_CustomerService.BpDetails)JSON.deserialize(addrJSON, TF_CustomerService.BpDetails.class);
        TF_AddCustomerImpl.updateCustomerAddress(addCustomerAddRequest, '12323657', bpdetailsFromRequest);
        
        Test.stopTest();
        
        List<Contact> contact = [SELECT id, Name, OtherCity, OtherPostalCode, Mailingstate, Billing_BP_Number__c FROM Contact WHERE id =: newContact.id ];
        System.assert(contact != null);
        System.assertEquals(contact.size(),1);
        System.assertEquals('1237248', contact[0].Billing_BP_Number__c);
        System.assertEquals('AL', contact[0].OtherCity);
    }
    
    @isTest
    private static void test_updateCustomerAddress_contactshipping(){
       
        Contact newContact = new Contact();
        newContact.email = 'test1234@xyz.com';
        newContact.Party_Id__c = '12323657';
        newContact.FirstName = 'test';
        newContact.LastName = '01';
        insert newContact;
        Test.startTest();
        String addrJSON='{ "addressId": "string", "addressLine1": "109", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "shipping", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "1237248", "bpPartnerFunction": "BP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string@json.com", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }';
        TF_CustomerService.Address addCustomerAddRequest = (TF_CustomerService.Address)JSON.deserialize(addrJSON, TF_CustomerService.Address.class);
        TF_CustomerService.BpDetails bpdetailsFromRequest = (TF_CustomerService.BpDetails)JSON.deserialize(addrJSON, TF_CustomerService.BpDetails.class);
        TF_AddCustomerImpl.updateCustomerAddress(addCustomerAddRequest, '12323657', bpdetailsFromRequest);
        
        Test.stopTest();
        
        List<Contact> contact = [SELECT id, Name, MailingCity, MailingPostalCode, Mailingstate, Mailing_BP_Number__c FROM Contact WHERE id =: newContact.id ];
        System.assert(contact != null);
        System.assertEquals(contact.size(),1);
        System.assertEquals('1237248', contact[0].Mailing_BP_Number__c);
        System.assertEquals('AL', contact[0].MailingCity);
    }
    @isTest
    private static void test_updateCustomerAddress_accountshipping(){
       
        
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Ringgold_Account_ID__c = '1234532';
        testAccount.Customer_Id__c = '12323657';
        insert testAccount;
        Test.startTest();
        String addrJSON='{ "addressId": "string", "addressLine1": "109", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "shipping", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "1237248", "bpPartnerFunction": "BP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string@json.com", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }';
        TF_CustomerService.Address addCustomerAddRequest = (TF_CustomerService.Address)JSON.deserialize(addrJSON, TF_CustomerService.Address.class);
        TF_CustomerService.BpDetails bpdetailsFromRequest = (TF_CustomerService.BpDetails)JSON.deserialize(addrJSON, TF_CustomerService.BpDetails.class);
        TF_AddCustomerImpl.updateCustomerAddress(addCustomerAddRequest, '12323657', bpdetailsFromRequest);
        
        Test.stopTest();
        
        List<Account> account = [SELECT id, Name, ShippingCity, ShippingPostalCode, Shipping_BP_Number__c FROM Account WHERE id =: testAccount.id ];
        System.assert(account != null);
        System.assertEquals(account.size(),1);
        System.assertEquals('1237248', account[0].Shipping_BP_Number__c);
        System.assertEquals('AL', account[0].ShippingCity);
    }
    @isTest
    private static void test_updateCustomerAddress_accountbilling(){
       
        
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Ringgold_Account_ID__c = '1234532';
        testAccount.Customer_Id__c = '12323657';
        insert testAccount;
        Test.startTest();
        String addrJSON='{ "addressId": "string", "addressLine1": "109", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "1237248", "bpPartnerFunction": "BP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string@json.com", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }';
        TF_CustomerService.Address addCustomerAddRequest = (TF_CustomerService.Address)JSON.deserialize(addrJSON, TF_CustomerService.Address.class);
        TF_CustomerService.BpDetails bpdetailsFromRequest = (TF_CustomerService.BpDetails)JSON.deserialize(addrJSON, TF_CustomerService.BpDetails.class);
        TF_AddCustomerImpl.updateCustomerAddress(addCustomerAddRequest, '12323657', bpdetailsFromRequest);
        
        Test.stopTest();
        
        List<Account> account = [SELECT id, Name, Billing_City__c, Billing_ZIP__c, Billing_BP_Number__c FROM Account WHERE id =: testAccount.id ];
        System.assert(account != null);
        System.assertEquals(account.size(),1);
        System.assertEquals('1237248', account[0]. Billing_BP_Number__c);
        System.assertEquals('AL', account[0].Billing_City__c);
    }
    @isTest
    private static void test_updateCustomerAddress_accountmailing(){
       
        
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Ringgold_Account_ID__c = '1234532';
        testAccount.Customer_Id__c = '12323657';
        insert testAccount;
        Test.startTest();
        String addrJSON='{ "addressId": "string", "addressLine1": "109", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "mailing", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "1237248", "bpPartnerFunction": "BP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string@json.com", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }';
        TF_CustomerService.Address addCustomerAddRequest = (TF_CustomerService.Address)JSON.deserialize(addrJSON, TF_CustomerService.Address.class);
        TF_CustomerService.BpDetails bpdetailsFromRequest = (TF_CustomerService.BpDetails)JSON.deserialize(addrJSON, TF_CustomerService.BpDetails.class);
        TF_AddCustomerImpl.updateCustomerAddress(addCustomerAddRequest, '12323657', bpdetailsFromRequest);
        
        Test.stopTest();
        
        List<Account> account = [SELECT id, Name, BillingCity, BillingPostalCode, Mailing_BP_Number__c FROM Account WHERE id =: testAccount.id ];
        System.assert(account != null);
        System.assertEquals(account.size(),1);
        System.assertEquals('1237248', account[0]. Mailing_BP_Number__c);
        System.assertEquals('AL', account[0].BillingCity);
    }
}