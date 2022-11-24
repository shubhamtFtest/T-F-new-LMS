global class TF_VerifyAccountAddress {
    
    
    Public static Account accData{get;set;}
    public static String status = null;
    
    WebService static void getaccountId(Id accid){
        system.debug('--->'+accid);
        accData = [Select Id from Account where id=:accid];
        
        shippingAddressVerify(accData);
        mailingAddressVerify(accData);
        billingAddressVerify(accData);
        
        update accData;
        
    }
    @AuraEnabled
    public static string getaccountIdLightning(Id recordId){
        system.debug('--->'+recordId);
        accData = [Select Id, Onboarding_Status__c from Account where id=:recordId];
        
        shippingAddressVerify(accData);
        mailingAddressVerify(accData);
        billingAddressVerify(accData);
        if(status == null){
          accData.Onboarding_Status__c = 'Address Validation Done';   
        }
              
        update accData;
        if(status != null){
            return status;
        }
        return null;
    }
    
    /**
	* Billing Address Verification Implementation
	**/
    @AuraEnabled
    Public static void billingAddressVerify(Account accData){
        System.debug('billingAddressVerify');
        
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        String uri = (String) orgSpecificProps.get('Verify_Addrress_Endpoint__c');
        String methodType = 'POST';
        Map<String, String> headers = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        try {
            String body = getBillingBody(accData.id);
            if(body != Null){
                HttpResponse res = new HttpResponse();
                if ( String.isNotBlank(uri) ) {
                    
                        res = TF_PlatformExecuter.execute(uri, methodType, 'idtoken', body, headers, false);
                    
                }
                System.debug('response =====>' + res + 'body--->'+res.getBody());
                
                if ( res != NULL && res.getStatusCode() == 200 ) {
                    accData.Billing_Address_Verification_Color__c = 'Verified';
                }
                if ( res != NULL && res.getStatusCode() == 400 ) {
                    accData.Billing_Address_Verification_Color__c = 'Verification Failed';
                    if(status != null){
						status = status+' and ' +'Billing Address verification failed';
                    }else{
                        status = 'Billing Address verification failed';
                    }
                }
                
                if(res != NULL && String.isNotBlank(res.getBody()) && res.getStatusCode() != 200){                
                    String errorString = res.getBody();
                    string errorStringSet = errorString.substring(errorString.indexOf('details')+10,errorString.indexOf('"},'));
                    
                    accData.Billing_Verification_Output__c = errorStringSet;
                }
                else{
                    accData.Billing_Verification_Output__c = ' '; 
                }                
            }else{
                accData.Billing_Verification_Output__c = ' '; 
                 accData.Billing_Address_Verification_Color__c = 'notVerified';
            }
        } catch ( Exception ex ) {
            System.debug('*********** Exception :' + ex.getMessage());
        }
    }
    
    /**
	* Mailing Address Verification Implementation
	**/
    @AuraEnabled
    Public static void mailingAddressVerify(Account accData){
        System.debug('mailingAddressVerify');
        
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        String uri = (String) orgSpecificProps.get('Verify_Addrress_Endpoint__c');
        String methodType = 'POST';
        Map<String, String> headers = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        
        try {
            String body = getMailingBody(accData.id);
            if(body != Null){
                HttpResponse res = new HttpResponse();
                if ( String.isNotBlank(uri) ) {
                    
                    res = TF_PlatformExecuter.execute(uri, methodType, 'idtoken', body, headers, false);
                    
                }
                System.debug('response =====>' + res + 'body--->'+res.getBody());            
                
                if ( res != NULL && res.getStatusCode() == 200 ) {
                    accData.Mailing_Address_Verification_color__c = 'Verified'; 
                }
                if ( res != NULL && res.getStatusCode() == 400 ) {
                    accData.Mailing_Address_Verification_color__c = 'Verification Failed';
                    if(status != null){
						status = status+' and ' +'Mailing Address verification failed';
                    }else{
                        status = 'Mailing Address verification failed';
                    }
                }
                
                if(res != NULL && String.isNotBlank(res.getBody()) && res.getStatusCode() != 200){                
                    String errorString = res.getBody();
                    system.debug(res.getBody());
                    string errorStringSet = errorString.substring(errorString.indexOf('details')+10,errorString.indexOf('"},'));
                    
                    accData.Mailing_Verification_Output__c = errorStringSet;
                }
                else{
                    accData.Mailing_Verification_Output__c = ' '; 
                }  
            }else{
                accData.Mailing_Verification_Output__c = ' '; 
                accData.Mailing_Address_Verification_Color__c = 'notVerified';
            }
        } catch ( Exception ex ) {
            System.debug('*********** Exception :' + ex.getMessage());
        }
    }
    
    /**
	* Shipping Address Verification Implementation
	**/
    @AuraEnabled
    Public static void shippingAddressVerify(Account accData){
        System.debug('shippingAddressVerify');
        
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        String uri = (String) orgSpecificProps.get('Verify_Addrress_Endpoint__c');
        String methodType = 'POST';
        Map<String, String> headers = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        
        try {
            String body = getShippingBody(accData.id);
            if(body != Null){
                HttpResponse res = new HttpResponse();
                if ( String.isNotBlank(uri) ) {
                    
					res = TF_PlatformExecuter.execute(uri, methodType, 'idtoken', body, headers, false);                    
                }
                System.debug('response =====>' + res + 'body--->'+res.getBody());
                
                if ( res != NULL && res.getStatusCode() == 200 ) {
                    accData.Shipping_Address_verification_color__c = 'Verified'; 
                }
                if ( res != NULL && res.getStatusCode() == 400 ) {
                    accData.Shipping_Address_verification_color__c = 'Verification Failed';
                    if(status != null){
						status = status+' and ' +'Shipping Address verification failed';
                    }else{
                        status = 'Shipping Address verification failed';
                    }
                    
                }
                
                if(res != NULL && String.isNotBlank(res.getBody()) && res.getStatusCode() != 200){                
                    String errorString = res.getBody();
                    string errorStringSet = errorString.substring(errorString.indexOf('details')+10,errorString.indexOf('"},'));
                    
                    accData.Shipping_Verification_Output__c = errorStringSet;
                }
                else{
                    accData.Shipping_Verification_Output__c = ' '; 
                }
            }else{
                accData.Shipping_Verification_Output__c = ' '; 
                accData.Shipping_Address_verification_color__c = 'notVerified';
            }
        } catch ( Exception ex ) {
            System.debug('*********** Exception :' + ex.getMessage());
            
        }
    }
    
    /**
	* Get body for Billing Address Verification
	**/
    @AuraEnabled
    public static String getBillingBody(String accData){
        String getBillingAddressBody;
        String countryCode;
        if ( String.isNotBlank(accData) ){
            List<Account> AccList= [ SELECT Name, Billing_Country__c,Billing_Country_List__c, Billing_Street__c, Billing_ZIP__c, Billing_City__c, Phone, Fax, Billing_Region__c FROM Account WHERE Id =:accData ];
            
            For(Account a : AccList) {
                if(a.Billing_Street__c==null){
                    a.Billing_Street__c = '';
                }
                if(a.Billing_Street__c.contains('\n')){
                    List<String> billStreetList  = a.Billing_Street__c.split('\n');
                    String billListStr = '';
                    if(!billStreetList.isEmpty()){
                        for(String item : billStreetList ){
                            item = item.replace('\r',' ');
                            billListStr += item;
                        }
                    }
                    a.Billing_Street__c = billListStr;
                }
                if(a.Billing_Country_List__c==null){
                    a.Billing_Country_List__c= '';
                }
                if(a.Billing_ZIP__c==null){
                    a.Billing_ZIP__c= '';
                }
                if(a.Billing_City__c ==null){
                    a.Billing_City__c = '';
                }
                if(a.Billing_Region__c ==null){
                    a.Billing_Region__c = '';
                }
                if(a.Billing_Street__c == '' && a.Billing_Country_List__c == '' && a.Billing_ZIP__c == '' && a.Billing_City__c == '' && a.Billing_Region__c == ''){
                    getBillingAddressBody = Null;
                }
                else{
                    Country__c[] BillingCountryCode = [SELECT Country_2__c, Name FROM Country__c where Name LIKE: a.Billing_Country_List__c limit 1];
                    if (BillingCountryCode.size() > 0){
                        countryCode = BillingCountryCode[0].Country_2__c;
                    }
                    getBillingAddressBody = '{ "address": { "address1": "'+a.Billing_Street__c+'", "address2": "", "city": "'+a.Billing_City__c+'","country": "'+countryCode+'", "department": "", "faxNumber": "", "organization": "'+a.Name+'", "phoneExtension": "", "phoneNumber": "", "postalCode": "'+a.Billing_ZIP__c+'", "region": "'+a.Billing_Region__c+'" }, "customer": { "email": "mulesoft@informa.com" }, "person": { "firstName": "string", "lastName": "string", "title": "Mr" }, "sourceSystemId": "TF-EBOOK" }';
                    system.debug(getBillingAddressBody);
                }
            }   
        }
        return getBillingAddressBody;
    }
    
    /**
	* Get body for Mailing Address Verification
	**/
    @AuraEnabled
    public static String getMailingBody(String accData){
        String getMailingAddressBody;
        String countryCode;
        if ( String.isNotBlank(accData) ){
            List<Account> AccList= [ SELECT Name, Mailing_Country_List__c, BillingStreet, BillingPostalCode, BillingCity, Fax, Phone, Mailing_State_List__c FROM Account WHERE Id =:accData ];
            
            For(Account a : AccList) {
                if(a.BillingStreet==null){
                    a.BillingStreet = '';
                }
                if(a.BillingStreet.contains('\n')){
                    List<String> mailingStreetList  = a.BillingStreet.split('\n');
                    String mailListStr = '';
                    if(!mailingStreetList.isEmpty()){
                        for(String item : mailingStreetList ){
                            item = item.replace('\r',' ');
                            mailListStr += item;
                        }
                    }
                    a.BillingStreet = mailListStr;
                }
                if(a.Mailing_Country_List__c==null){
                    a.Mailing_Country_List__c= '';
                }
                if(a.BillingPostalCode==null){
                    a.BillingPostalCode= '';
                }
                if(a.BillingCity ==null){
                    a.BillingCity = '';
                }
                if(a.BillingStreet == '' && a.Mailing_Country_List__c == '' && a.BillingPostalCode == '' && a.BillingCity == ''){
                    getMailingAddressBody = Null;
                }
                else{
                    Country__c[] MailingCountryCode =[SELECT Country_2__c, Name FROM Country__c where Name LIKE: a.Mailing_Country_List__c limit 1];                        
                    if (MailingCountryCode.size() > 0){
                        countryCode = MailingCountryCode[0].Country_2__c;
                    }
                    getMailingAddressBody = '{ "address": { "address1": "'+a.BillingStreet+'", "address2": "", "city": "'+a.BillingCity+'", "country": "'+countryCode+'", "department": "", "faxNumber": "", "organization": "'+a.Name+'", "phoneExtension": "", "phoneNumber": "", "postalCode": "'+a.BillingPostalCode+'", "region": "'+a.Mailing_State_List__c+'" }, "customer": { "email": "mulesoft@informa.com" }, "person": { "firstName": "string", "lastName": "string", "title": "Mr" }, "sourceSystemId": "TF-EBOOK" }';
                    system.debug(getMailingAddressBody); 
                }
            }   
        }
        return getMailingAddressBody;
    }
    
    /**
    * Get body for Shipping Address Verification
    **/
    @AuraEnabled
    public static String getShippingBody(String accData){
        String getShippingAddressBody;
        String countryCode;
        if ( String.isNotBlank(accData) ){
            List<Account> AccList= [ SELECT Name, Shipping_Country_List__c, ShippingStreet, ShippingPostalCode, ShippingCity, Shipping_Region__c, Fax, Phone FROM Account WHERE Id =:accData ];
            
            For(Account a : AccList) {
                if(a.ShippingStreet==null){
                    a.ShippingStreet = '';
                }
                if(a.ShippingStreet.contains('\n')){
                    List<String> shipStreetList  = a.ShippingStreet.split('\n');
                    String shipListStr = '';
                    if(!shipStreetList.isEmpty()){
                        for(String item : shipStreetList ){
                            item = item.replace('\r',' ');
                            shipListStr += item;
                        }
                    }
                    a.ShippingStreet = shipListStr;
                }
                if(a.Shipping_Country_List__c==null){
                    a.Shipping_Country_List__c= '';
                }
                if(a.ShippingPostalCode==null){
                    a.ShippingPostalCode= '';
                }
                if(a.ShippingCity ==null){
                    a.ShippingCity = '';
                }
                if(a.Shipping_Region__c ==null){
                    a.Shipping_Region__c = '';
                }
                if(a.ShippingStreet == '' && a.Shipping_Country_List__c == '' && a.ShippingPostalCode == '' && a.ShippingCity == '' && a.Shipping_Region__c == ''){
                    getShippingAddressBody = Null;
                }
                else{
                    Country__c[] ShippingCountryCode = [SELECT Country_2__c, Name FROM Country__c where Name LIKE: a.Shipping_Country_List__c limit 1];
                    if (ShippingCountryCode.size() > 0){
                        countryCode = ShippingCountryCode[0].Country_2__c;
                    }
                    getShippingAddressBody = '{ "address": { "address1": "'+a.ShippingStreet+'", "address2": "", "city": "'+a.ShippingCity+'", "country": "'+countryCode+'", "department": "", "faxNumber": "", "organization": "'+a.Name+'", "phoneExtension": "", "phoneNumber": "", "postalCode": "'+a.ShippingPostalCode+'", "region": "'+a.Shipping_Region__c+'" }, "customer": { "email": "mulesoft@informa.com" }, "person": { "firstName": "string", "lastName": "string", "title": "Mr" }, "sourceSystemId": "TF-EBOOK" }';
                    system.debug(getShippingAddressBody);
                }     
            }   
        }
        return getShippingAddressBody;
    }   
}