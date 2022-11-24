/***************************************************************************************
   This handler class is used for TF_productUpdateOnAffiliation trigger.
******************************************************************************************/
public class TF_ProductAffiliationTriggerHandler {
    
    /***************************************************************************************
    This method is used to prevent creating duplicate affiliation types for a product
    ******************************************************************************************/
    public static void preventDuplicateAffiliationType(List<Product_Affiliation__c> productAffiliationList){
        //Get all the unique values from new Affiliation Type records
        List<String> uniqueValueList = new List<String>();
        
        for(Product_Affiliation__c prodAffObject : productAffiliationList){
            //Extract the first 15 digits from 18 digits Account ID
            uniqueValueList.add((prodaffObject.Product__c+'').substring(0,15) + (prodAffObject.Affiliation_Type__c+'').substring(0,15));
        }
        
        //Find all the existing Affiliation Type records that contain given unique values and add them to a Map
        List<Product_Affiliation__c> prodAffList = [select id, Unique_Value__c from Product_Affiliation__c where Unique_Value__c IN :uniqueValueList];
        Map<String,Product_Affiliation__c > uniqueValueMap = new Map<String,Product_Affiliation__c >();
        
        for(Product_Affiliation__c prodAffObject : prodAffList){            
            uniqueValueMap.put(prodAffObject.Unique_Value__c,prodAffObject);   
        }
        
        //Loop through the new Affiliation Type records to see if the unique value is found.
        //If so, check whether we are inserting or updating.
        //Throw error if duplicate.
        for(Product_Affiliation__c prodAffObject : productAffiliationList){
            if(uniqueValueMap.containsKey((prodAffObject.Product__c+'').substring(0,15) + (prodAffObject.Affiliation_Type__c+'').substring(0,15))){
                //Second condition here is for the update. It allows you to update the record, but not another record.
                if(trigger.isInsert || (trigger.isUpdate && (prodAffObject.id<>uniqueValueMap.get((prodAffObject.Product__c+'').substring(0,15) + (prodAffObject.Affiliation_Type__c+'').substring(0,15)).id))){
                    prodAffObject.addError('Duplicate Affiliation Type records with same Product ID & Affiliation Type cannot be inserted.');
                }           
            }
        }
    }
    
    /****************************************************************************************
     This Method handles the afterInsert actions on ProductAffiliation records
     * **************************************************************************************/
    public static void onAfterInsert( List< Product_Affiliation__c > newprodAffs  ) {
        Set<Id> productidSet = new Set<Id> ();
        for(Product_Affiliation__c pfa : newprodAffs) {
            productidSet.add(pfa.product__c);
        }
        if(!productidSet.isEmpty()) {
            updateNesliVsnuOnProduct(productidSet);
        }
    }
    
    /****************************************************************************************
     This Method handles the afterUpdate actions on ProductAffiliation records
     * **************************************************************************************/
    public static void onAfterUpdate( List< Product_Affiliation__c > newprodAffs  ) {
        Set<Id> productidSet = new Set<Id> ();
        for(Product_Affiliation__c pfa : newprodAffs) {
            productidSet.add(pfa.product__c);
        }
        if(!productidSet.isEmpty()) {
            updateNesliVsnuOnProduct(productidSet);
        }
    }
    
    /****************************************************************************************
     This Method handles the afterdelete actions on ProductAffiliation records
     * **************************************************************************************/
    public static void onAfterDelete( List< Product_Affiliation__c > newprodAffs  ) {
        Set<Id> productidSet = new Set<Id> ();
        for(Product_Affiliation__c pfa : newprodAffs) {
            productidSet.add(pfa.product__c);
        }
        if(!productidSet.isEmpty()) {
            updateNesliVsnuOnProduct(productidSet);
        }
    }
    
    /****************************************************************************************
     This Method handles the afterUndelete actions on ProductAffiliation records
     * **************************************************************************************/
    public static void onAfterUnDelete( List< Product_Affiliation__c > newprodAffs  ) {
        Set<Id> productidSet = new Set<Id> ();
        for(Product_Affiliation__c pfa : newprodAffs) {
            productidSet.add(pfa.product__c);
        }
        if(!productidSet.isEmpty()) {
            updateNesliVsnuOnProduct(productidSet);
        }
    }
    
    /****************************************************************************************
     This Method is used to update Nesli and Vsnu checkboxes on product based on product affiliation records.
     * ***************************************************************************************/
    Public static void updateNesliVsnuOnProduct(Set<Id> productId) {
        List<Product2> Productlst = new List<Product2>();
        Map<Product2,Set<String>> productAffiliatedMap = new Map<Product2,Set<string>>();
        Map<Id,Product2> productMap = new Map<Id,Product2> ([select id,(select id,Affiliation_Type__r.name from Product_Affiliation__r ) from product2 where id in :productid ]);
        Map<String, TF_Product_Affiliation__c> affiliationTypes = TF_Product_Affiliation__c.getAll();
        for(Product2 Prod : productMap.values()) {
            set<String> strSet = new Set<String>();
            for(Product_Affiliation__c proAff : Prod.Product_Affiliation__r) {
                for(String affiType : affiliationTypes.keySet()){
                    if(proAff.Affiliation_Type__r.name == affiType){
                        strSet.add(affiType);
                    }
                }   
                
            }
            productAffiliatedMap.put(prod,strSet);      
            
        }
        
        for(product2 pro : productAffiliatedMap.keyset()) {
            Set<String> str_set = new Set<String>();
            str_set = productAffiliatedMap.get(pro);
        
            for(TF_Product_Affiliation__c prodAff : affiliationTypes.values()){
                if(str_set.contains(prodAff.Name)){
                    pro.put(prodAff.Proudct_Field_Name__c,true);
                }
                else{
                    pro.put(prodAff.Proudct_Field_Name__c,false);
                }
            }   
                
            productlst.add(pro);
        }
        if(!Productlst.isEmpty()) {
            update Productlst;
        }
    }
}