/** Author: Shalini Singh
    Test Class: SAP_BP_utlDSTest
	Description: Used in new sap bp creation component in DS flow
**/
public class SAP_BP_utlDS {
    
    public class addressWrapper {
        
        public String PartyId;
        public String accountId;
        public String houseNumber;
        public String addressLine1;
        public String addressLine2;
        public String addressLine3;
        public String city;
        public String state;
        public String country;
        public String countryCode;
        public String postalCode;
        public String addressType;
        public String contactType;
        public String firstName;
        public String lastName;
        public String title;
        public String emailAddress;
        public String telephone;
        public String bpPartnerFunction;
        public String bpBusinessPartnerCategory;
        public String taxRegistrationNumber;
        public String taxNumberCategory;
        public String source;
        public String addressUseType;
        public String bpNumber;
        public String rrAddressId;
        public String department;
        public String careOf;
        public boolean status;
        public String street;
    }
    
    public class BPResponseObject {
        
        public String salesforceRecordId;
        public String houseNumber;
        public String addressLine1;
        public String addressLine2;
        public String addressLine3;
        public String city;
        public String state;
        public String country;
        public String countryCode;
        public String postalCode;
        public String addressType;
        public String contactType;
        public String firstName;
        public String lastName;
        public String title;
        public String emailAddress;
        public String telephone;
        public String bpNumber;
        public String bpPartnerFunction;
        public String bpBusinessPartnerCategory;
        public String taxRegistrationNumber;
        public String taxNumberCategory;
        public String source;
        public String department;
        public String careOf;
        public String addressUseType;        
        
        public BPResponseObject(){}
        public BPResponseObject(
            String salesforceRecordId,
            String houseNumber,
            String addressLine1,
            String addressLine2,
            String addressLine3,
            String city,
            String state,
            String country,
            String countryCode,
            String postalCode,
            String addressType,
            String contactType,
            String firstName,
            String lastName,
            String title,
            String emailAddress,
            String telephone,
            String bpNumber,
            String bpPartnerFunction,
            String bpBusinessPartnerCategory,
            String taxRegistrationNumber,
            String taxNumberCategory,
            String source,
            String addressUseType       
        ){
            this.salesforceRecordId = salesforceRecordId;
            this.houseNumber = houseNumber;
            this.addressLine1 = addressLine1;
            this.addressLine2 = addressLine2;
            this.addressLine3 = addressLine3;
            this.city = city;
            this.state = state;
            this.country = country;
            this.countryCode = countryCode;
            this.postalCode = postalCode;
            this.addressType = addressType;
            this.contactType = contactType;
            this.firstName = firstName;
            this.lastName = lastName;
            this.title = title;
            this.emailAddress = emailAddress;
            this.telephone = telephone;
            this.bpNumber = bpNumber;
            this.bpPartnerFunction = bpPartnerFunction;
            this.bpBusinessPartnerCategory = bpBusinessPartnerCategory;
            this.taxRegistrationNumber = taxRegistrationNumber;
            this.taxNumberCategory = taxNumberCategory;
            this.source = source;
            this.addressUseType = addressUseType;
        }
        
    }
    
    public static void validateRequest(addressWrapper responseData){
        system.debug('validateRequest '+responseData);
        if(responseData == null){
            throw new SAP_BP_Service.Bad_Request_Exception('Response cannot be null');
        }
        if(responseData.PartyId == null){
            throw new SAP_BP_Service.Bad_Request_Exception('Party Id cannot be null');
        }
        if(responseData.city == null){
            throw new SAP_BP_Service.Bad_Request_Exception('City cannot be null');
        }
        if(responseData.state == null){
            throw new SAP_BP_Service.Bad_Request_Exception('State cannot be null');
        }
        if(responseData.country == null){
            throw new SAP_BP_Service.Bad_Request_Exception('Country cannot be null');
        }
        if(responseData.postalCode == null){
            throw new SAP_BP_Service.Bad_Request_Exception('Postal code cannot be null');
        }
        if(responseData.lastName == null){
            throw new SAP_BP_Service.Bad_Request_Exception('Last Name code cannot be null');
        }
        if(responseData.emailAddress == null){
            throw new SAP_BP_Service.Bad_Request_Exception('Email Address code cannot be null');
        }
        if(!isValidEmail(responseData.emailAddress)){
            throw new SAP_BP_Service.Bad_Request_Exception('Incorrect email format, Email Address should be in proper format');
        }
        if(responseData.bpPartnerFunction != 'SP' && responseData.bpPartnerFunction != 'BP' && responseData.bpPartnerFunction != 'PY' && responseData.bpPartnerFunction != 'SH' ){
            throw new SAP_BP_Service.Bad_Request_Exception('BPPartnerFunction incorrect data. SP,BP,PY and SH are the only valid values for bp partner function.');
        }
        if(responseData.bpBusinessPartnerCategory != 'Organisation' && responseData.bpBusinessPartnerCategory != 'Person' ){
            throw new SAP_BP_Service.Bad_Request_Exception('BP Business Partner Category incorrect data. Organisation or Person are the valid inputs.');
        }
        
    }
    
    private static Boolean isValidEmail(String emailAddress) {
        String emailRegex = '^[a-zA-Z0-9._}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$';//***Modified by Shalini on 21 oct 2021*** '^[a-zA-Z0-9._}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'
        return String.isBlank(emailAddress) ? false : Pattern.compile(emailRegex).matcher(emailAddress).matches();
    }
    
    //Returns true if match found, false if not.
    public static Boolean addressMatcher(addressWrapper addressDataOne, addressWrapper addressDataTwo){
        
        //If any values in the JSON are null change them to ''.
        if(addressDataTwo.addressLine1==null){addressDataTwo.addressLine1='';}
        if(addressDataTwo.addressLine2==null){addressDataTwo.addressLine2='';}
        if(addressDataTwo.addressLine3==null){addressDataTwo.addressLine3='';}
        if(addressDataTwo.city==null){addressDataTwo.city='';}
        if(addressDataTwo.state==null){addressDataTwo.state='';}
        if(addressDataTwo.country==null){addressDataTwo.country='';}
        if(addressDataTwo.postalCode==null){addressDataTwo.postalCode='';}
        if(addressDataTwo.emailAddress==null){addressDataTwo.emailAddress='';}
        if(addressDataTwo.firstName==null){addressDataTwo.firstName='';}
        if(addressDataTwo.lastName==null){addressDataTwo.lastName='';}
        if(addressDataTwo.bpBusinessPartnerCategory==null){addressDataTwo.bpBusinessPartnerCategory='';}
        if(addressDataTwo.department==null){addressDataTwo.department='';}
        if(addressDataTwo.careOf==null){addressDataTwo.careOf='';}
        if(addressDataTwo.taxRegistrationNumber==null){addressDataTwo.taxRegistrationNumber='';}
        if(addressDataTwo.telephone==null){addressDataTwo.telephone='';}
        string addressDataTwoStreet='';
        if(String.isNotBlank(addressDataTwo.addressLine1)) addressDataTwoStreet+= addressDataTwo.addressLine1;
        if(String.isNotBlank(addressDataTwo.addressLine2)) addressDataTwoStreet+= ' '+addressDataTwo.addressLine2;
        if(String.isNotBlank(addressDataTwo.addressLine3)) addressDataTwoStreet+= ' '+addressDataTwo.addressLine3;
        
        boolean isMatch = false;
        if( 
            addressDataOne.street.deleteWhitespace().toLowerCase() == addressDataTwoStreet.deleteWhitespace().toLowerCase()  && 
            addressDataOne.city.deleteWhitespace().toLowerCase() == addressDataTwo.City.deleteWhitespace().toLowerCase() &&                             
            addressDataOne.state.deleteWhitespace().toLowerCase() == addressDataTwo.State.deleteWhitespace().toLowerCase()  &&
            addressDataOne.country.deleteWhitespace().toLowerCase() == addressDataTwo.Country.deleteWhitespace().toLowerCase() &&
            addressDataOne.postalCode.deleteWhitespace().toLowerCase() == addressDataTwo.postalCode.deleteWhitespace().toLowerCase() &&
            addressDataOne.emailAddress.deleteWhitespace().toLowerCase() == addressDataTwo.emailAddress.deleteWhitespace().toLowerCase() &&
            addressDataOne.firstName.deleteWhitespace().toLowerCase() == addressDataTwo.firstName.deleteWhitespace().toLowerCase() &&
            addressDataOne.lastName.deleteWhitespace().toLowerCase() == addressDataTwo.lastName.deleteWhitespace().toLowerCase()  &&
            addressDataOne.bpBusinessPartnerCategory.deleteWhitespace().toLowerCase() == addressDataTwo.bpBusinessPartnerCategory.deleteWhitespace().toLowerCase() &&
        	addressDataOne.taxRegistrationNumber.deleteWhitespace().toLowerCase() == addressDataTwo.taxRegistrationNumber.deleteWhitespace().toLowerCase() &&
            addressDataOne.department.deleteWhitespace().toLowerCase() == addressDataTwo.department.deleteWhitespace().toLowerCase() &&
        	addressDataOne.careOf.deleteWhitespace().toLowerCase() == addressDataTwo.careOf.deleteWhitespace().toLowerCase() &&
            addressDataOne.telephone.deleteWhitespace().toLowerCase() == addressDataTwo.telephone.deleteWhitespace().toLowerCase() 
        ){
            isMatch = true;
            system.debug('isMatch--> '+isMatch);
        }
        return isMatch;
    }
    
    public static addressWrapper mapAddressForSAP_BP(SAP_BP__c sapBPRecord){
        
        //Ensure we have no null values in the address fields, otherwise an error is thrown while trying to remove white space during matching.
        addressWrapper addressWrapperRecord = new addressWrapper();
        addressWrapperRecord.AddressLine1 = sapBPRecord.address_line1__c  == null ? '' : sapBPRecord.address_line1__c ;
        addressWrapperRecord.AddressLine2 = sapBPRecord.address_line2__c   == null ? '' : sapBPRecord.address_line2__c  ;
        addressWrapperRecord.AddressLine3 = sapBPRecord.address_line3__c   == null ? '' : sapBPRecord.address_line3__c  ;
		addressWrapperRecord.accountId = sapBPRecord.Account_Id__c == null ? '' : sapBPRecord.Account_Id__c;
        addressWrapperRecord.city = sapBPRecord.City__c == null ? '' : sapBPRecord.City__c;
        addressWrapperRecord.state = sapBPRecord.State__c == null ? '' : sapBPRecord.State__c;
        addressWrapperRecord.country = sapBPRecord.Country__c == null ? '' : sapBPRecord.Country__c;
        addressWrapperRecord.postalCode = sapBPRecord.ZIP__c == null ? '' : sapBPRecord.ZIP__c;
        addressWrapperRecord.emailAddress = sapBPRecord.Email__c == null ? '' : sapBPRecord.Email__c;
        addressWrapperRecord.firstName = sapBPRecord.First_Name__c == null ? '' : sapBPRecord.First_Name__c;
        addressWrapperRecord.lastName = sapBPRecord.Last_Name__c == null ? '' : sapBPRecord.Last_Name__c;
        addressWrapperRecord.bpBusinessPartnerCategory = sapBPRecord.Category__c == null ? '' : sapBPRecord.Category__c;
        addressWrapperRecord.source = sapBPRecord.Source__c == null ? '' : sapBPRecord.Source__c;
        addressWrapperRecord.addressUseType = sapBPRecord.Address_Type__c == null ? '' : sapBPRecord.Address_Type__c;
        addressWrapperRecord.taxRegistrationNumber = sapBPRecord.Tax_Registration_Number__c  == null ? '' : sapBPRecord.Tax_Registration_Number__c ;
		addressWrapperRecord.taxNumberCategory = sapBPRecord.Tax_Number_Category__c   == null ? '' : sapBPRecord.Tax_Number_Category__c  ;
		addressWrapperRecord.telephone = sapBPRecord.Telephone__c    == null ? '' : sapBPRecord.Telephone__c;
		addressWrapperRecord.department = sapBPRecord.Department__c     == null ? '' : sapBPRecord.Department__c ;
        addressWrapperRecord.careOf = sapBPRecord.Care_of__c    == null ? '' : sapBPRecord.Care_of__c;
        addressWrapperRecord.street = sapBPRecord.Street__c    == null ? '' : sapBPRecord.Street__c;
        return addressWrapperRecord;     
    }    
    
    public static SAP_BP__c noInsertCreateSAPBPRecord(addressWrapper addressInfo){
        system.debug('addressInfo '+addressInfo);
        string street='';
        if(String.isNotBlank(addressInfo.addressLine1)) street+= addressInfo.addressLine1;
        if(String.isNotBlank(addressInfo.addressLine2)) street+= ' '+addressInfo.addressLine2;
        if(String.isNotBlank(addressInfo.addressLine3)) street+= ' '+addressInfo.addressLine3;
        
        return new SAP_BP__c(
            Name='PENDING',
            Account_Id__c = addressInfo.accountId,
            address_line1__c = addressInfo.addressLine1,
            address_line2__c = addressInfo.addressLine2,
            address_line3__c = addressInfo.addressLine3,
            City__c = addressInfo.city,
            State__c = addressInfo.state,
            Country__c = addressInfo.country,
            ZIP__c = addressInfo.postalCode,
            //Status__c = true,
            Source__c = 'Direct/Agent Opp Order',
            Email__c = addressInfo.emailAddress,
            First_Name__c = addressInfo.firstName,
            Last_Name__c = addressInfo.lastName,
            Address_Type__c = addressInfo.addressUseType,  
            Category__c = addressInfo.bpBusinessPartnerCategory,
            Tax_Number_Category__c = addressInfo.taxNumberCategory,
            Tax_Registration_Number__c = addressInfo.taxRegistrationNumber,
            Telephone__c = addressInfo.telephone,
            Department__c = addressInfo.department,
            Care_of__c = addressInfo.careOf,
            Street__c = street
        );
    }
}