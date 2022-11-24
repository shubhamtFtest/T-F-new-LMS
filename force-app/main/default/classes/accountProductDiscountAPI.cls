@RestResource(urlMapping='/accountProductDiscountAPI/*') 
global with sharing class accountProductDiscountAPI {
    @HttpPost
    global static Map<String,List<DiscountRuleWrapper>> doPost(dataWrapper str){ 
        dataWrapper dw = new dataWrapper();
        dw = str;  
        List<DiscountRuleWrapper> disRulWrapList = new List<DiscountRuleWrapper>();
        List<CPQ_Discount_Configuration__c> cpqDisConfig = new List<CPQ_Discount_Configuration__c>();
        cpqDisConfig = [select id,Account__c,Discount_Display_Name__c,Product__c,Discount_Category__c,Discount_Type__c,Discount_Value_Percentage__c,Discount_Value_Amount__c,Account__r.Name,Product__r.Name,Account__r.Customer_Id__c,Product__r.ProductCode,Product__r.Netbase_Classifications__c from CPQ_Discount_Configuration__c where (Account__r.Customer_Id__c =: dw.customerId or Product__r.ProductCode IN: dw.ISBNCode) and RecordType.Name = 'T&F - UBX Self Service' and Discount_Display_Name__c ='UBX Self Service'];
        List<Product2> isNetbaseProduct = new List<Product2>();
        isNetbaseProduct = [select ProductCode from Product2 where ProductCode IN: dw.ISBNCode and Netbase_Classifications__c != null];
        set<string> netbaseProductCodeset = new set<string>();
        for(Product2 prod : isNetbaseProduct){
            netbaseProductCodeset.add(prod.ProductCode);
        }
        Map<String,List<DiscountRuleWrapper>> UniqueISBNMapData = new Map<String,List<DiscountRuleWrapper>>();
        DiscountRuleWrapper accountSpecificDisRulWrap = new DiscountRuleWrapper();
        DiscountRuleWrapper netbaseAccountSpecificDisRulWrap = new DiscountRuleWrapper();
        Boolean addAccoutSpecificDisRule = False;
        Boolean netbaseAddAccoutSpecificDisRule = False;
        for(CPQ_Discount_Configuration__c disConfig : cpqDisConfig){
            List<DiscountRuleWrapper> disRulWrapListIns = new List<DiscountRuleWrapper>();
            if(disConfig.Product__c != null || disConfig.Account__c != null){
                if(disConfig.Product__c != null){
                    if(UniqueISBNMapData.containskey(disConfig.Product__r.ProductCode)){
                        disRulWrapListIns =  UniqueISBNMapData.get(disConfig.Product__r.ProductCode);
                        DiscountRuleWrapper disRulWrap = new DiscountRuleWrapper();
                        if(disConfig.Account__c != null){
                            disRulWrap.AccountCustomerId = disConfig.Account__r.Customer_Id__c;
                            disRulWrap.accountName = disConfig.Account__r.Name;
                            disRulWrap.productAccoutTypeCode = '2';
                        }
                        else{
                            disRulWrap.productAccoutTypeCode = '3';
                        }
                        disRulWrap.ISBNCode = disConfig.Product__r.ProductCode;
                        if(disConfig.Discount_Type__c == '% Discount'){
                            disRulWrap.discountType = 'Percent Discount';
                        }
                        else{
                            disRulWrap.discountType = disConfig.Discount_Type__c;
                        }
                        disRulWrap.discountDisplayName = disConfig.Discount_Display_Name__c;
                        disRulWrap.discountPercent = string.valueOf(disConfig.Discount_Value_Percentage__c);
                        disRulWrap.discountAmount = string.valueOf(disConfig.Discount_Value_Amount__c);
                        if(disConfig.Account__c != null){}
                        disRulWrap.productName = disConfig.Product__r.Name;
                        disRulWrapListIns.add(disRulWrap);
                    }
                    else{
                        DiscountRuleWrapper disRulWrap = new DiscountRuleWrapper();
                        if(disConfig.Account__c != null){
                            disRulWrap.AccountCustomerId = disConfig.Account__r.Customer_Id__c;
                            disRulWrap.accountName = disConfig.Account__r.Name;
                            disRulWrap.productAccoutTypeCode = '2';
                        }
                        else{
                            disRulWrap.productAccoutTypeCode = '3';
                        }
                        disRulWrap.ISBNCode = disConfig.Product__r.ProductCode;
                        if(disConfig.Discount_Type__c == '% Discount'){
                            disRulWrap.discountType = 'Percent Discount';
                        }
                        else{
                            disRulWrap.discountType = disConfig.Discount_Type__c;
                        }
                        disRulWrap.discountDisplayName = disConfig.Discount_Display_Name__c;
                        disRulWrap.discountPercent = string.valueOf(disConfig.Discount_Value_Percentage__c);
                        disRulWrap.discountAmount = string.valueOf(disConfig.Discount_Value_Amount__c);
                        disRulWrap.productName = disConfig.Product__r.Name;
                        disRulWrapListIns.add(disRulWrap); 
                    }
                    UniqueISBNMapData.put(disConfig.Product__r.ProductCode,disRulWrapListIns);
                }
                else if(disConfig.Account__c != null){
                    if(disConfig.Discount_Category__c == 'Netbase'){
                        netbaseAddAccoutSpecificDisRule = True;
                        netbaseAccountSpecificDisRulWrap.AccountCustomerId = disConfig.Account__r.Customer_Id__c;
                        netbaseAccountSpecificDisRulWrap.productAccoutTypeCode = '4';
                        if(disConfig.Discount_Type__c == '% Discount'){
                            netbaseAccountSpecificDisRulWrap.discountType = 'Percent Discount';
                        }
                        else{
                            netbaseAccountSpecificDisRulWrap.discountType = disConfig.Discount_Type__c;
                        }
                        netbaseAccountSpecificDisRulWrap.discountDisplayName = disConfig.Discount_Display_Name__c;
                        netbaseAccountSpecificDisRulWrap.discountPercent = string.valueOf(disConfig.Discount_Value_Percentage__c);
                        netbaseAccountSpecificDisRulWrap.discountAmount = string.valueOf(disConfig.Discount_Value_Amount__c);
                        netbaseAccountSpecificDisRulWrap.accountName = disConfig.Account__r.Name;
                        netbaseAccountSpecificDisRulWrap.isNetbase = true;  
                    }
                    else{
                        addAccoutSpecificDisRule = True;
                        accountSpecificDisRulWrap.AccountCustomerId = disConfig.Account__r.Customer_Id__c;
                        accountSpecificDisRulWrap.productAccoutTypeCode = '1';
                        if(disConfig.Discount_Type__c == '% Discount'){
                            accountSpecificDisRulWrap.discountType = 'Percent Discount';
                        }
                        else{
                            accountSpecificDisRulWrap.discountType = disConfig.Discount_Type__c;
                        }
                        accountSpecificDisRulWrap.discountDisplayName = disConfig.Discount_Display_Name__c;
                        accountSpecificDisRulWrap.discountPercent = string.valueOf(disConfig.Discount_Value_Percentage__c);
                        accountSpecificDisRulWrap.discountAmount = string.valueOf(disConfig.Discount_Value_Amount__c);
                        accountSpecificDisRulWrap.accountName = disConfig.Account__r.Name;
                    }
                }
            }
            
            
        }
        if(addAccoutSpecificDisRule == True || netbaseAddAccoutSpecificDisRule == True){
            for(String prodKey : dw.ISBNCode){
                List<DiscountRuleWrapper> disRulWrapListIns = new List<DiscountRuleWrapper>();
                if(UniqueISBNMapData.containsKey(prodKey)){
                    disRulWrapListIns = UniqueISBNMapData.get(prodKey);
                }
                if(netbaseProductCodeset.contains(prodKey) && netbaseAddAccoutSpecificDisRule == True){
                    disRulWrapListIns.add(netbaseAccountSpecificDisRulWrap);
                }
                if(addAccoutSpecificDisRule == True){
                disRulWrapListIns.add(accountSpecificDisRulWrap);
                }
                UniqueISBNMapData.put(prodKey,disRulWrapListIns);
            }
        }
        //String JsonString = JSON.serialize(UniqueISBNMapData);
        return UniqueISBNMapData;
    }
    
    global class dataWrapper{
        global string customerId;
        global List<string> ISBNCode;
    }
    global class DiscountRuleWrapper{
        global string AccountCustomerId;
        global string ISBNCode;
        global string productAccoutTypeCode;
        global string discountType;
        global string discountPercent; 
        global string discountAmount;
        global string accountName;
        global string productName;
        global string discountDisplayName;
        global boolean isNetbase;
        
    }
}