global without sharing class LightningSelfRegisterController {
    
    public LightningSelfRegisterController() {
        
    }
    
    @TestVisible 
    private static boolean isValidPassword(String password, String confirmPassword) {
        return password == confirmPassword;
    }
    
    @TestVisible 
    private static boolean siteAsContainerEnabled(String communityUrl) {
        Auth.AuthConfiguration authConfig = new Auth.AuthConfiguration(communityUrl,'');
        return authConfig.isCommunityUsingSiteAsContainer();
    }
    
    @TestVisible 
    private static String validatePassword(User u, String password, String confirmPassword) { 
         if(!test.isRunningTest()){    
            try{
            Site.validatePassword(u, password, confirmPassword);
            }
            catch(exception e){
                return e.getMessage();
            }
        }
        return '';
    }
    
    @AuraEnabled
    public static String selfRegister(String firstname ,String lastname, String email, String password, String confirmPassword, String accountId, String regConfirmUrl, String extraFields, String startUrl, Boolean includePassword) {
        
        //System.debug('email:='+email);
        //List<Contact> lstContact=[Select Id,email from Contact Where email=:email];
        //System.debug('lstContact:='+lstContact);
          if(email != null) 
           email=email.trim();
        List<User> lstUser=[Select Id,email,contact.email,user.profile.name From User Where email=:email and contact.email=:email and user.profile.name='Agent Extranet Community User'];
        //System.debug('lstUser org:='+lstUser);
        Savepoint sp = null;
        String BMISAccountNumber;
        String phnNum;
        String zipCode;
        BMIS_Setting__c BMISsetting = BMIS_Setting__c.getOrgDefaults();
      //  try { 
            //return 'response.getStatus()';
            if(lstUser.size() > 0){
                return 'User already exist, Please contact support';
            }
            else{
                try {
                if(!test.isRunningTest()){
                   //  sp = Database.setSavepoint();
                }
               
                
                if (firstname == null || String.isEmpty(firstname )) {
                    return 'First name is required.';
                }
                if (lastname == null || String.isEmpty(lastname)) {
                    return Label.Site.lastname_is_required;
                }
                if (email == null || String.isEmpty(email)) {
                    return Label.Site.email_is_required;
                }
                User u = new User();
                u.Username = email + '.c' ;
                u.put('Email',email);
                
                u.FirstName = firstname;
                u.LastName = lastname;
                //u.BMIS_Account_Number__c='123';
                String networkId = Network.getNetworkId();
                
                // If using site to host the community the user should not hit s1 after logging in from mobile.
                if(networkId != null && siteAsContainerEnabled(Network.getLoginUrl(networkId))) {
                    u.put('UserPreferencesHideS1BrowserUI',true);
                }
                String nickname = ((firstname != null && firstname.length() > 0) ? firstname.substring(0,1) : '' ) + lastname.substring(0,1);
                nickname += String.valueOf(Crypto.getRandomInteger()).substring(1,7);
                u.put('CommunityNickname', nickname);
                if (extraFields != null) {
                    List<Object> extraFieldsList = (List<Object>) JSON.deserializeUntyped(extraFields);        
                    for (Object thisFieldObject : extraFieldsList) {
                        Map<String,Object> thisField = (Map<String,Object>) thisFieldObject;
                        Schema.SObjectField sof = Schema.SObjectType.User.fields.getMap().get((String) thisField.get('fieldPath'));
                        //System.debug('thisField.get(\'fieldPath\') =====>' + thisField.get('value'));
                        if((String) thisField.get('fieldPath') == 'BMIS_Account_Number__c'){                            
                            BMISAccountNumber=(String)thisField.get('value');
                            BMISAccountNumber=BMISAccountNumber.trim();
                        }
                        if((String) thisField.get('fieldPath') == 'BMIS_Phone__c'){
                            phnNum=(String)thisField.get('value');
                        }
                        if((String) thisField.get('fieldPath') == 'BMIS_Zipcode__c'){
                            zipCode=(String)thisField.get('value');
                            zipCode=zipCode.trim();
                        }
                        
                        if(thisField.get('value') !=null)
                            u.put(sof, thisField.get('value'));
                    }
                }
                //system.debug('BMISAccountNumber@@@@@'+BMISAccountNumber);
                //system.debug('phnNum@@@@@'+phnNum);
                //system.debug('zipCode@@@@@'+zipCode);
                if(String.isBlank(BMISAccountNumber)){
                    return 'Account number is required.';
                }
                 system.debug('phnNum'+phnNum);
                if(String.isBlank(phnNum)){
                    return 'Phone number is required.';
                }
                if(String.isBlank(zipCode)){
                    return 'Zip code is required.';
                }
               
                /*else {
                    password = null;
                }*/
                if(String.isNotBlank(BMISAccountNumber)){
                    //Only make the callout if not a test.
                    //system.debug('BMISAccountNumber&&&&122 '+ BMISAccountNumber);
                    //if (!test.isRunningTest()){
                        String getToken;
                        TF_PlatformExecuter  TAG = new TF_PlatformExecuter();
                        getToken=TF_PlatformExecuter.generateAccessToken();//To get TokenKey
                        String jsonStr;
                        //String endpoint = 'https://api-uat.taylorandfrancis.com/v1/bmis/salesforce/accountInfo/'+BMISAccountNumber+'/us';
                        String endpoint = '';
                        if (BMISsetting != null) { 
                            endpoint = (String) BMISsetting.get('BMIS_Endpoint__c');
                        }
                        endpoint += BMISAccountNumber+'/us';
                        HttpRequest bmisCallout = new HttpRequest();
                        bmisCallout.setEndpoint(endpoint);
                        bmisCallout.setMethod('GET');
                        bmisCallout.setHeader('X-Bmis-Api-Version', '5');
                        bmisCallout.setHeader('Authorization', 'idtoken '+getToken);
                        Http httpCall = new Http();
                        HttpResponse response;
                        response = httpCall.send(bmisCallout);
                       
                        BmisAccountInfoApi BMIS= new BmisAccountInfoApi(); 
                        if (response.getStatusCode() == 200 && response.getStatus() == 'OK') { 
                            if(test.isRunningTest()){
                                BmisAccountInfoApi.class_Data obj = new BmisAccountInfoApi.class_Data();
                                list<BmisAccountInfoApi.class_Data> objdataList = new list<BmisAccountInfoApi.class_Data>();
                                BmisAccountInfoApi obj2 = new BmisAccountInfoApi();
                                obj2.data = new list< BmisAccountInfoApi.class_Data>();
                                obj.saleRegion='US';
                                obj.accountId ='12324';
                                obj.address1 = 'UNIV OF MISSOURI';  
                                obj.address2='RELIGIOUS STUDIES';   
                                obj.address3='221 ARTS  ATN:C DUNN';    
                                obj.County='US';
                                obj.postCode='65211';   
                                obj.telephone='7878878787';   
                                obj.creditTerms='0';
                                obj.discountCode='p';   
                                objdataList.add(obj);
                                obj2.data =  objdataList;
                                BMIS = obj2;
                                //includePassword=true;
                            }else{
                                BMIS = (BmisAccountInfoApi) System.JSON.deserialize(String.ValueOf(response.getBody()), BmisAccountInfoApi.class);
                            }
                            jsonStr=response.getBody();
                            //system.debug('zipCode$%^167: ' + zipCode);  
                            if(zipCode != BMIS.data[0].postCode){
                                return 'Provide correct zipcode.';
                            }
                            system.debug('phnNum$%^172: ' + phnNum);
                            if(phnNum.replaceAll('\\D','')!= BMIS.data[0].telephone.replaceAll('\\D','')){
                                return 'Provide correct phone number.';
                            }
                            if (includePassword) {
                                if(String.isEmpty(password)){
                                    return 'Password Required';
                                }
                                
                                if (!isValidPassword(password, confirmPassword)) {
                                    return Label.site.passwords_dont_match;
                                }
                                
                                string s= validatePassword(u, password, confirmPassword);
                                if(String.isNotEmpty(s)){
                                    return s;
                                }    
                            }
                            u.Street = BMIS.data[0].address1;
                            u.City = BMIS.data[0].address2;
                            u.State = BMIS.data[0].address3;
                            u.PostalCode = BMIS.data[0].postCode;
                            u.BMIS_Zipcode__c = BMIS.data[0].postCode;
                            u.Credit_Terms__c = BMIS.data[0].creditTerms; 
                            u.BMIS_Customer_Discount_Code__c = BMIS.data[0].discountCode;  
                            u.BMIS_Phone__c = BMIS.data[0].telephone;
                        }
                            //system.debug('statuscode12345: ' + response.getStatusCode());
                        if(response.getStatusCode() == 404 && response.getStatus() == 'Not Found'){
                            
                            return 'Please input a valid Account ID';
                        }
                        if(response.getStatusCode() == 502){
                            return 'Sorry something went wrong, please try again later.';
                           // return response.getStatus()+response.getStatusCode();
                        }
                    else if(response.getStatusCode()>=300&&response.getStatusCode()<600){
                        return 'Sorry something went wrong, please try again later.'+response.getStatus();
                    }         
                    }
                  // }                
                 //if(lstContact.size()>1){
                //return 'Please contact to admin';
               //}
                
                // lastName is a required field on user, but if it isn't specified, we'll default it to the username
                List<contact> con =[select id,Accountid  from contact where email=:email];
                if(con.size()>0){
                  accountId=con[0].Accountid;  
                }
                String userId;
                sp = Database.setSavepoint();
                system.debug('@@@@@@@@@@@'+accountId);
                //accountid='0016E00000u4vtb';
                userId = Site.createExternalUser(u, accountId, password);
                
                // create a fake userId for test.
                if (Test.isRunningTest()) {
                    userId = 'fakeUserId';           
                }
                if (userId != null) {      
                    if (password != null && password.length() > 1) {
                        ApexPages.PageReference lgn = Site.login(u.username, password, startUrl);
                        if(!Test.isRunningTest()) {
                            aura.redirect(lgn);
                        }
                    }
                    else {
                        ApexPages.PageReference confirmRef = new PageReference(regConfirmUrl);
                        if(!Test.isRunningTest()) {
                            aura.redirect(confirmRef);
                        }        
                    }
                }
                return null;
            }
                catch (Exception ex) {
             //Database.rollback(sp);
                    if(ex.getMessage().containsIgnoreCase('User already')||ex.getMessage().containsIgnoreCase('Duplicate')){
                        return 'User already exists, Please contact support';
                    }
                    else{    /* Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                              SelfRegisterControllerError__c mailId = SelfRegisterControllerError__c.getOrgDefaults();
                              string mailingAddress = (String)mailId.get('Email__c');
                              String[] toAddresses = new String[] {mailingAddress};
                              mail.setToAddresses(toAddresses);
                              mail.setSubject('Exception in LightningSelfRegisterController');
                              mail.setPlainTextBody('EXCEPTION :'+ex.getMessage() );
                              try{
                              Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                              }
                              catch(Exception e){
                                return 'Some Problem Ocurred Please try After a while';
                              } */
                              return 'Some Problem Ocurred Please try After sometime'; 
                    //return 'Please Try Again Later'; 
                    }
        }
        }
        
    }
    
    @AuraEnabled
    public static List<Map<String,Object>> getExtraFields(String extraFieldsFieldSet) { 
        //System.debug('Hey extyrs');          
        List<Map<String,Object>> extraFields = new List<Map<String,Object>>();
        Schema.FieldSet fieldSet = Schema.SObjectType.User.fieldSets.getMap().get(extraFieldsFieldSet);
     
       // if(!Test.isRunningTest()) {
        system.debug('fieldSet'+fieldSet);
        if (fieldSet != null) {
                for (Schema.FieldSetMember f : fieldSet.getFields()) {
                    Map<String, Object> fieldDetail = new Map<String, Object>();
                    fieldDetail.put('dbRequired', f.getDBRequired()); 
                    fieldDetail.put('fieldPath', f.getFieldPath());
                    fieldDetail.put('label', f.getLabel());
                    fieldDetail.put('required', f.getRequired());
                    fieldDetail.put('type', f.getType());
                    fieldDetail.put('value', '');   // client will populate
                    extraFields.add(fieldDetail);
                }}
   //     }
        return extraFields;
    }
    
    @AuraEnabled
    global static String setExperienceId(String expId) {
        // Return null if there is no error, else it will return the error message 
        try {
            if (expId != null) {
                Site.setExperienceId(expId);   
            }
            return null; 
        } catch (Exception ex) {
            return ex.getMessage();            
        }        
    }  
}