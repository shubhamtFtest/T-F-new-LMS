public with sharing class TF_ProductAffiliation_PreventDup_Trig implements TriggerInterface_ProductAffiliation.Runnable {
	public void run(TriggerInterface_ProductAffiliation.Trig trig) {
        if((trig.isInsert && trig.isBefore) || (trig.isUpdate && trig.isBefore) || (trig.isUnDelete)){
	        //Get all the unique values from new Affiliation Type records
	        List<String> uniqueValueList = new List<String>();
	        
	        for(Product_Affiliation__c prodAffObject : trig.newList){
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
	        for(Product_Affiliation__c prodAffObject : trig.newList){
	            if(uniqueValueMap.containsKey((prodAffObject.Product__c+'').substring(0,15) + (prodAffObject.Affiliation_Type__c+'').substring(0,15))){
	                //Second condition here is for the update. It allows you to update the record, but not another record.
	                if(trigger.isInsert || (trigger.isUpdate && (prodAffObject.id<>uniqueValueMap.get((prodAffObject.Product__c+'').substring(0,15) + (prodAffObject.Affiliation_Type__c+'').substring(0,15)).id))){
	                    prodAffObject.addError('Duplicate Affiliation Type records with same Product ID & Affiliation Type cannot be inserted.');
	                }           
	            }
	        }
    	}
    }
}