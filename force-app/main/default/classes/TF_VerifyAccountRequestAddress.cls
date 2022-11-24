public class TF_VerifyAccountRequestAddress {
    
    public static String status = null;
    
    /**
    * Mailing Address Verification Implementation
    **/
    @AuraEnabled
    Public static string mailingAddressVerify(Account Account, String MailingAddLine1, String MailingAddLine2){
        System.debug('mailingAddressVerify');
        string errorStringSet;
        
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        String uri = (String) orgSpecificProps.get('Verify_Addrress_Endpoint__c');
        
        Map<String, String> headers = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        
        try {
            String body = getMailingBody(Account, MailingAddLine1, MailingAddLine2);
            system.debug(body);
            if(body != Null){
                HttpResponse res = new HttpResponse();
                if ( String.isNotBlank(uri) ) {
                    
                    res = TF_PlatformExecuter.execute( uri, 'POST', 'idtoken', body, headers, false );
                    
                }
                System.debug('response =====>' + res + 'body--->'+res.getBody());
                
                if ( res != NULL && res.getStatusCode() == 200 ) {
                    Account.Mailing_Address_Verification_Color__c = 'Verified';
                }
                if ( res != NULL && res.getStatusCode() == 400 ) {
                    Account.Mailing_Address_Verification_Color__c = 'Verification Failed';
                    if(status != null){
                        status = status+' and ' +'Mailing Address verification failed';
                    }else{
                        status = 'Mailing Address verification failed';
                    }
                }
                
                if(res != NULL && String.isNotBlank(res.getBody()) && res.getStatusCode() != 200){                
                    String errorString = res.getBody();
                    errorStringSet = errorString.substring(errorString.indexOf('details')+10,errorString.indexOf('"},'));
                    
                    Account.Mailing_Verification_Output__c = errorStringSet;
                }
                else{
                    Account.Mailing_Verification_Output__c = ' '; 
                }                
            }
            
        } catch ( Exception ex ) {
            System.debug('*********** Exception :' + ex.getMessage());
        }
        return errorStringSet;
    }
    
    /**
    * Get body for Mailing Address Verification
    **/
    @AuraEnabled
    public static String getMailingBody(Account Account, String MailingAddLine1, String MailingAddLine2){
        String getMailingAddressBody;
        String countryCode;
        
        if(String.isBlank(MailingAddLine1)){
            MailingAddLine1 = '';
        }
        if(String.isBlank(MailingAddLine2)){
            MailingAddLine2 = '';
        }
        if(String.isBlank(Account.Mailing_Country_List__c)){
            Account.Mailing_Country_List__c = '';
        }
        if(String.isBlank(Account.BillingPostalCode)){
            Account.BillingPostalCode = '';
        }
        if(String.isBlank(Account.BillingCity)){
            Account.BillingCity = '';
        }
        if(String.isBlank(Account.Mailing_State_List__c)){
            Account.Mailing_State_List__c = '';
        }
        if(MailingAddLine1 == '' && MailingAddLine2 == '' && Account.Mailing_Country_List__c == '' && Account.BillingPostalCode == '' && Account.BillingCity == '' && Account.Mailing_State_List__c == '' ){
            getMailingAddressBody = Null;
        }
        else{
            Country__c[] MailingCountryCode = [SELECT Country_2__c, Name FROM Country__c where Name LIKE: Account.Mailing_Country_List__c limit 1];
            if (MailingCountryCode.size() > 0){
                countryCode = MailingCountryCode[0].Country_2__c;
            }
            getMailingAddressBody = '{ "address": { "address1": "'+MailingAddLine1+'", "address2": "'+MailingAddLine2+'", "city": "'+Account.BillingCity+'","country": "'+countryCode+'", "department": "", "faxNumber": "", "organization": "'+Account.Name+'", "phoneExtension": "", "phoneNumber": "", "postalCode": "'+Account.BillingPostalCode+'", "region": "" }, "customer": { "email": "mulesoft@informa.com" }, "person": { "firstName": "string", "lastName": "string", "title": "Mr" }, "sourceSystemId": "TF-EBOOK" }';
            system.debug(getMailingAddressBody);
            
        }
        return getMailingAddressBody;
    }
    
    /**
    * Shipping Address Verification Implementation
    **/
    @AuraEnabled
    Public static string shippingAddressVerify(Account Account, String ShippingAddLine1, String ShippingAddLine2){
        System.debug('shippingAddressVerify');
        string errorStringSet;
        
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        String uri = (String) orgSpecificProps.get('Verify_Addrress_Endpoint__c');
        
        Map<String, String> headers = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        
        try {
            String body = getShippingBody(Account, ShippingAddLine1, ShippingAddLine2);
            system.debug(body);
            if(body != Null){
                HttpResponse res = new HttpResponse();
                if ( String.isNotBlank(uri) ) {
                    
                    res = TF_PlatformExecuter.execute( uri, 'POST', 'idtoken', body, headers, false );
                    
                }
                System.debug('response =====>' + res + 'body--->'+res.getBody());
                
                if ( res != NULL && res.getStatusCode() == 200 ) {
                    Account.Shipping_Address_Verification_Color__c = 'Verified';
                }
                if ( res != NULL && res.getStatusCode() == 400 ) {
                    Account.Shipping_Address_Verification_Color__c = 'Verification Failed';
                    if(status != null){
                        status = status+' and ' +'Shipping Address verification failed';
                    }else{
                        status = 'Shipping Address verification failed';
                    }
                }
                
                if(res != NULL && String.isNotBlank(res.getBody()) && res.getStatusCode() != 200){                
                    String errorString = res.getBody();
                    errorStringSet = errorString.substring(errorString.indexOf('details')+10,errorString.indexOf('"},'));
                    
                    Account.Shipping_Verification_Output__c = errorStringSet;
                }
                else{
                    Account.Shipping_Verification_Output__c = ' '; 
                }                
            }
            
        } catch ( Exception ex ) {
            System.debug('*********** Exception :' + ex.getMessage());
        }
        return errorStringSet;
    }
    
    /**
    * Get body for Shipping Address Verification
    **/
    @AuraEnabled
    public static String getShippingBody(Account Account, String ShippingAddLine1, String ShippingAddLine2){
        String getShippingAddressBody;
        String countryCode;
        
        if(String.isBlank(ShippingAddLine1)){
            ShippingAddLine1 = '';
        }
        if(String.isBlank(ShippingAddLine2)){
            ShippingAddLine2 = '';
        }
        if(String.isBlank(Account.Shipping_Country_List__c)){
            Account.Shipping_Country_List__c = '';
        }
        if(String.isBlank(Account.ShippingPostalCode)){
            Account.ShippingPostalCode = '';
        }
        if(String.isBlank(Account.ShippingCity)){
            Account.ShippingCity = '';
        }
        if(String.isBlank(Account.Shipping_State_List__c)){
            Account.Shipping_State_List__c = '';
        }
        if(ShippingAddLine1 == '' && ShippingAddLine2 == '' && Account.Shipping_Country_List__c == '' && Account.ShippingPostalCode == '' && Account.ShippingCity == '' && Account.Shipping_State_List__c == '' ){
            getShippingAddressBody = Null;
        }
        else{
            Country__c[] ShippingCountryCode = [SELECT Country_2__c, Name FROM Country__c where Name LIKE: Account.Shipping_Country_List__c limit 1];
            if (ShippingCountryCode.size() > 0){
                countryCode = ShippingCountryCode[0].Country_2__c;
            }
            getShippingAddressBody = '{ "address": { "address1": "'+ShippingAddLine1+'", "address2": "'+ShippingAddLine2+'", "city": "'+Account.ShippingCity+'","country": "'+countryCode+'", "department": "", "faxNumber": "", "organization": "'+Account.Name+'", "phoneExtension": "", "phoneNumber": "", "postalCode": "'+Account.ShippingPostalCode+'", "region": "" }, "customer": { "email": "mulesoft@informa.com" }, "person": { "firstName": "string", "lastName": "string", "title": "Mr" }, "sourceSystemId": "TF-EBOOK" }';
            system.debug(getShippingAddressBody);
            
        }
        return getShippingAddressBody;
    }
    
    /**
    * Billing Address Verification Implementation
    **/
    @AuraEnabled
    Public static string billingAddressVerify(Account Account, String BillingAddLine1, String BillingAddLine2){
        System.debug('billingAddressVerify');
        string errorStringSet;
        
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        String uri = (String) orgSpecificProps.get('Verify_Addrress_Endpoint__c');
        
        Map<String, String> headers = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        
        try {
            String body = getBillingBody(Account, BillingAddLine1, BillingAddLine2);
            system.debug(body);
            if(body != Null){
                HttpResponse res = new HttpResponse();
                if ( String.isNotBlank(uri) ) {
                    
                    res = TF_PlatformExecuter.execute( uri, 'POST', 'idtoken', body, headers, false );
                    
                }
                System.debug('response =====>' + res + 'body--->'+res.getBody());
                
                if ( res != NULL && res.getStatusCode() == 200 ) {
                    Account.Billing_Address_Verification_Color__c = 'Verified';
                }
                if ( res != NULL && res.getStatusCode() == 400 ) {
                    Account.Billing_Address_Verification_Color__c = 'Verification Failed';
                    if(status != null){
                        status = status+' and ' +'Billing Address verification failed';
                    }else{
                        status = 'Billing Address verification failed';
                    }
                }
                
                if(res != NULL && String.isNotBlank(res.getBody()) && res.getStatusCode() != 200){                
                    String errorString = res.getBody();
                    errorStringSet = errorString.substring(errorString.indexOf('details')+10,errorString.indexOf('"},'));
                    
                    Account.Billing_Verification_Output__c = errorStringSet;
                }
                else{
                    Account.Billing_Verification_Output__c = ' '; 
                }                
            }
            
        } catch ( Exception ex ) {
            System.debug('*********** Exception :' + ex.getMessage());
        }
        return errorStringSet;
    }
    
    /**
    * Get body for Billing Address Verification
    **/
    @AuraEnabled
    public static String getBillingBody(Account Account, String BillingAddLine1, String BillingAddLine2){
        String getBillingAddressBody;
        String countryCode;
        
        if(String.isBlank(BillingAddLine1)){
            BillingAddLine1 = '';
        }
        if(String.isBlank(BillingAddLine2)){
            BillingAddLine2 = '';
        }
        if(String.isBlank(Account.Billing_Country_List__c)){
            Account.Billing_Country_List__c = '';
        }
        if(String.isBlank(Account.Billing_ZIP__c)){
            Account.Billing_ZIP__c = '';
        }
        if(String.isBlank(Account.Billing_City__c)){
            Account.Billing_City__c = '';
        }
        if(String.isBlank(Account.Billing_State_List__c)){
            Account.Billing_State_List__c = '';
        }
        if(BillingAddLine1 == '' && BillingAddLine2 == '' && Account.Billing_Country_List__c == '' && Account.Billing_ZIP__c == '' && Account.Billing_City__c == '' && Account.Billing_State_List__c == '' ){
            getBillingAddressBody = Null;
        }
        else{
            Country__c[] BillingCountryCode = [SELECT Country_2__c, Name FROM Country__c where Name LIKE: Account.Billing_Country_List__c limit 1];
            if (BillingCountryCode.size() > 0){
                countryCode = BillingCountryCode[0].Country_2__c;
            }
            getBillingAddressBody = '{ "address": { "address1": "'+BillingAddLine1+'", "address2": "'+BillingAddLine2+'", "city": "'+Account.Billing_City__c+'","country": "'+countryCode+'", "department": "", "faxNumber": "", "organization": "'+Account.Name+'", "phoneExtension": "", "phoneNumber": "", "postalCode": "'+Account.Billing_ZIP__c+'", "region": "" }, "customer": { "email": "mulesoft@informa.com" }, "person": { "firstName": "string", "lastName": "string", "title": "Mr" }, "sourceSystemId": "TF-EBOOK" }';
            system.debug(getBillingAddressBody);
            
        }
        return getBillingAddressBody;
    }
}