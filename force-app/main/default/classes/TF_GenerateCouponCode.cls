/*
* Apex Test class: zTest_TF_GeneratePromoCode
*/

public class TF_GenerateCouponCode { 
    public class configurationResult{
        @AuraEnabled public List<Sales_Deal__c> lstConfig{get;set;}
        @AuraEnabled public Integer configCount{get;set;}
        @AuraEnabled public String Msg {get;set;}        
    }

    @AuraEnabled 
    public static Map<String, String> getSDCurrFieldValue(){
        Map<String, String> options = new Map<String, String>();       
        Schema.DescribeFieldResult fieldResult = Sales_Deal__c.CurrencyIsoCode.getDescribe();        
        List<Schema.PicklistEntry> pValues = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pValues) {           
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }
    
    @AuraEnabled
    public static String getRecordTypeId() {
        Try
        {
            Id configRecordtypeId = MiscFunctions.getRecordtypeId('Sales_Deal__c', 'Promocode Deal');
            string recordTypeId = String.valueof(configRecordtypeId);    
            system.debug('PromoCode recordTypeId::'+recordTypeId);
            return recordTypeId;
        }
        catch(Exception ex){
            system.debug('getRecordTypeId Error debug::' + ex.getMessage());
            return null;
        }             
    } 
    
    @AuraEnabled
    public static List<String> getPickListValues(String ObjectApiName, String fieldApiName) {
        List<String> pickListValuesList= new List<String>();
        if(String.isNotBlank(ObjectApiName) && String.isNotBlank(fieldApiName)){
            List<String> objectLst = new List<String>();
            objectLst.add(ObjectApiName);
            Schema.DescribeSobjectResult[] descSobjLst = Schema.describeSObjects(objectLst);
            
            for(Schema.DescribeSobjectResult obj : descSobjLst) {
                for (Schema.PicklistEntry entry : obj.fields.getMap().get(fieldApiName).getDescribe().getPicklistValues()) {
                    if (entry.isActive()){
                        pickListValuesList.add(entry.getValue());
                    }
                }
            }
        }
        return pickListValuesList;
    }
    
    
    @AuraEnabled        
    public static List<Product2> getProductInfo(String productCode){
        List<Product2> productLst = new List<Product2>();
        if(String.isNotBlank(productCode)){
            productLst = [Select Id, Name from Product2 where ProductCode =: productCode AND Family = 'Journal Master Product' limit 1];            
            if(productLst.size() > 0){
                return productLst;
            }             
        }
        return productLst;
    } 
    
    @AuraEnabled
    public static List<Sales_Deal__c> doSaveRecord(String TF_productId, String TF_productCode, String TF_couponcategory, 
                                                   String TF_startdate, String TF_enddate, String TF_couponcodelength,                                                                     
                                                   String TF_discounttype, String TF_discountvalue, String TF_currency,  
                                                   String TF_singleuse, String TF_email                                                                  
                                                  )
    {                       
        Boolean isValidInput = true; 
        String productUid = String.valueOf(TF_productId);
        String productCode = String.valueOf(TF_productCode);
        String category = String.valueOf(TF_couponcategory);
        Date startDate = Date.valueOf(TF_startdate);
        Date endDate = Date.valueOf(TF_enddate);
        String numOfCodes = String.valueOf(TF_couponcodelength);
        String disType = String.valueOf(TF_discounttype);
        Decimal disValue = decimal.valueOf(TF_discountvalue);
        Boolean isSingleUse = TF_singleuse == 'YES' ? true : false;
        String email = String.valueOf(TF_email);
        
        //start validation
        Pattern productCodePattern= Pattern.compile('^[a-zA-Z0-9]{4}+$');
        Matcher productCodeStr = productCodePattern.matcher(productCode);    
        if(!productCodeStr.matches()){isValidInput = false;}
        if(startDate == null){isValidInput = false;}
        if(endDate == null){isValidInput = false;}  
        if(category == '' || category == null){isValidInput = false;}
        if(TF_singleuse == '' || TF_singleuse == null){isValidInput = false;}
        if(disType == '' || disType == null){isValidInput = false;}
        if(!numOfCodes.isNumeric()){isValidInput = false;}         
        Boolean singleuse = TF_singleuse == 'YES' ? true : false;
        if(String.isNotBlank(email) && ValidateEmail(email)==false){isValidInput = false;}         
        system.debug('category::'+category);
        if(isValidInput == true){ 
            String saved = saveRecord(productUid,productCode,category,
                                      startDate,endDate,numOfCodes,
                                      disType,disValue,TF_currency,
                                      singleuse,email); 
            Set<Id> recordIds = (Set<Id>)JSON.deserialize(saved, Set<Id>.class);
            configurationResult wrap = new configurationResult();
            wrap = getConfigList(recordIds);
            return wrap.lstConfig;
        }else{
            return null;
        }
    }
    
    public static String saveRecord(String productUid, String productCode, String category, Date startDate, Date endDate, String numOfCodes,
                                    String disType, Decimal disValue, String curr, Boolean singleuse, String TF_email)
    {
        //logic to save record
        String promoCode;
        String idStrs;
        Id CPQDisConfigRecordTypeId = getRecordTypeId();
        List<Sales_Deal__c> salesDealList = new List<Sales_Deal__c>();        
        Set<Id> configIds = new Set<Id>();
        Integer num = Integer.valueOf(numOfCodes);
        Date today = system.today();
        Integer expYear = endDate.year();
        try{
            for(integer i=0;i<num;i++)
            {
                Sales_Deal__c objDiscConf = new Sales_Deal__c();
                promoCode = productCode.toUppercase()+'-'+expYear+'-'+'TEST';                
                //objDiscConf.Product_Code__c = productCode.toUppercase();                
                objDiscConf.Deal_Name__c = (singleuse == true) ? 'Promocode- single use' : 'Promocode- multi use';
                objDiscConf.Type_of_Deal__c = 'APC Deal';                
                objDiscConf.Product__c = productUid;
                objDiscConf.Promocode__c  = promoCode;
                objDiscConf.Discount_Category__c = category;
                objDiscConf.Single_Use__c = singleuse;
                if(category == 'EDW'){
                   objDiscConf.Discount_Display_Name__c = 'Invited submission'; 
                }else if(category == 'Ad hoc'){
                    objDiscConf.Discount_Display_Name__c = 'Discretionary';
                }else if(category == 'Editorial Board'){
                    objDiscConf.Discount_Display_Name__c = 'Editorial Board';
                }else if(category == 'Society Discount Promo code'){
                    objDiscConf.Discount_Display_Name__c = 'Society Member';
                }else if(category == 'Conference/Marketing/Special Issue'){
                    objDiscConf.Discount_Display_Name__c = 'Special Offer';
                }
                else if(category == 'Agent'){
                    objDiscConf.Discount_Display_Name__c = 'Special OfferA';
                }
                objDiscConf.Start_Date__c = startDate;
                objDiscConf.End_Date__c = endDate;
                objDiscConf.RecordTypeId    = CPQDisConfigRecordTypeId; 
                objDiscConf.CurrencyIsoCode = curr;
                objDiscConf.Active__c = true;               
                
                salesDealList.add(objDiscConf);               
            } 
            
            
            //insert record
            if(!salesDealList.isEmpty()){
                insert salesDealList; 
                for(Sales_Deal__c sd : salesDealList){
                    createDealDiscountRecord(sd.Id, startDate, endDate, category, disType, disValue, curr);
                }                  
            } 
                        
            
            for(Sales_Deal__c config : salesDealList){
                configIds.add(config.id);
            }   

            idStrs = JSON.serialize(configIds);            
            Set<Id> ids = (Set<Id>)JSON.deserialize(idStrs, Set<Id>.class);          
            
            //update promocode with unique string
            updatePromoCodes(ids);          
            //send email notification
            sendEmail(ids,productCode,category,disType,disValue,num,singleuse,TF_email);
        } catch (Exception ex){
            system.debug('Exception message::'+ex.getMessage());            
        }        
        return idStrs;              
    }  

    public static String createDealDiscountRecord(String productUid, Date startDate, Date endDate, String category, String disType, Decimal disValue, String curr){
        List<Deal_Discount__c> dealDiscountList = new List<Deal_Discount__c>();
        Deal_Discount__c objDealDiscount = new Deal_Discount__c();
        objDealDiscount.Sales_Deal__c = productUid;
        //objDealDiscount.Start_Date__c = startDate;
        //objDealDiscount.End_Date__c = endDate; 
        objDealDiscount.Discount_Category__c = category;
        objDealDiscount.Discount_Type__c = disType;
        objDealDiscount.CurrencyIsoCode = curr;
        if(disType == '% Discount') {
            objDealDiscount.Discount_Value_Percentage__c = disValue;
        } else {
            objDealDiscount.Discount_Value_Amount__c = disValue;  
        }   
        dealDiscountList.add(objDealDiscount);
        if(!dealDiscountList.isEmpty()){
            insert dealDiscountList;  
        }    
        return '';
    }   
    
    public static configurationResult getConfigList(Set<ID> recordIds)
    {   
        configurationResult configWrap = new configurationResult();  
        configWrap.lstConfig = [SELECT Id, Name, Product_Code__c, Promocode__c FROM Sales_Deal__c WHERE Id IN :recordIds];
        configWrap.configCount = configWrap.lstConfig.size(); 
        configWrap.Msg = 'Success';
        return configWrap;
    }
        
    /**
     * Method to send email notification 
     */    
    public static void sendEmail(Set<Id> recordIds, String productCode, String category, String disTyp, Decimal disValue, Integer numOfCodes, Boolean singleUse, String toEmail){
        if(String.isNotBlank(toEmail)){
            messaging.SingleEmailMessage email = new messaging.SingleEmailMessage();
            string[]toAdd=new string[]{toEmail};
            string []ccAdd=new string[]{};
            email.setToAddresses(toAdd);
            email.setCcAddresses(ccAdd);
            email.setSubject('Generate CPQ Coupon Code');                    
            String messageBody = '<html><body>Hello,</br>';
            messageBody +='<p>Please find attached your discount codes, as requested.</p>';
            messageBody +='<p>As a reminder, the following criteria apply to your codes:</p>';
            messageBody +='<p>Journal: '+productCode+'</p>';
            messageBody +='<p>Category: '+category+'</p>';
            messageBody +='<p>Single-Use: '+singleUse+'</p>';
            messageBody +='<p>Discount Type: '+disTyp+'</p>';
            messageBody +='<p>Discount value: '+disValue+'</p>';
            messageBody +='<p>Number of codes: '+numOfCodes+'</p>';
            messageBody +='<p>List of coupon code: '+string.join(getPromocodes(recordIds),'<br/>')+'</p>';
            messageBody +='<p>Please retain this email for your records.</p>';
            messageBody +='</body></html>';
            email.setHtmlBody(messageBody);
            email.setSenderDisplayName('Generate Coupon Code');
            messaging.Email[] emails = new messaging.Email[]{email};
            try {
                messaging.sendEmail(emails);
                return;
            } catch (Exception e) {
                System.debug(e.getMessage());
            } 
        }
    }
    
    @AuraEnabled
    public static Boolean checkUserHasCustomPermissionAccess() {
        Id userId = userInfo.getUserId();
        Set < Id > permissionSetIds = new Set < Id >();
        List < User > userList = new List < User >();
        for ( SetupEntityAccess access : [ SELECT ParentId FROM SetupEntityAccess 
                                          WHERE SetupEntityId IN ( SELECT Id 
                                                                  FROM CustomPermission 
                                                                  WHERE DeveloperName = 'Hide_CPQ_Admin' )
                                         ]) 
            permissionSetIds.add(access.ParentId);
            userList = [ SELECT Username FROM User WHERE Id IN (
            SELECT AssigneeId FROM PermissionSetAssignment
            WHERE PermissionSetId IN :permissionSetIds AND AssigneeId =: userId ) ];
        return userList.isEmpty() ? false : true;
    } 
    
    /**
     * Method to validate inserted email Id 
     * @param emailId determines the email id
     */     
    public static Boolean ValidateEmail(String emailId) {
        Boolean result = false;
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
        Pattern EmailPattern = Pattern.compile(emailRegex);
        Matcher EmailMatcher = EmailPattern.matcher(emailId);
        if(EmailMatcher.matches()){
            result = true;
        }
        return result;
    } 
    
    /**
     * Method to get list of promo code 
     * @param recordIds determines list ids of inserted promo codes
     */    
    public static List<String> getPromocodes(Set<ID> recordIds) {   
        List<String> promoCodes = new List<String>();
        List<Sales_Deal__c> confList = [SELECT Promocode__c FROM Sales_Deal__c WHERE Id IN :recordIds];   
        for(Sales_Deal__c config : confList){
            promoCodes.add(config.Promocode__c);
        } 
        return promoCodes;
    }

    /**
     * Method to update existing coupon code with unique number 
     * @param recordIds determines list ids of inserted records
     */
    public static void updatePromoCodes(Set<ID> recordIds) {   
        list<Sales_Deal__c> conflst = new list<Sales_Deal__c>();
        for(Sales_Deal__c confObj:[select Id,Name,Promocode__c from Sales_Deal__c where Id IN:recordIds])
        {
            system.debug('@@Existing PromoCode:'+ confObj.Promocode__c);
            if (confObj.Promocode__c != '' || confObj.Promocode__c != null){                          
                String promoCode = confObj.Promocode__c;
                String name = confObj.Name.replace('-','');
                String promoCodeModified = promoCode.replace('TEST','C'+name.right(5)); 
                confObj.Promocode__c = promoCodeModified; 
            }        
            conflst.add(confObj);
        }    
        update conflst;
    }    
}