public with sharing class TF_AccAffiliation_PreventDuplicate_Trig implements TriggerInterface_AccountAffiliation.Runnable{

    /***************************************************************************************
    This method is used to prevent creating duplicate affiliation types for an account
    ******************************************************************************************/
    public void run(TriggerInterface_AccountAffiliation.Trig trig) {
        if((trig.isInsert && trig.isBefore) || (trig.isUpdate && trig.isBefore) ){

            //Store all the unique values from new Affiliation Type records
            List<String> uniqueValueList = new List<String>();

            for(Account_Affiliation__c accaffObject : trig.newList){
                //Extract the first 15 digits from the 18 digits Account & Affiliation Type IDs
                uniqueValueList.add((accaffObject.Account__c+'').substring(0,15)+(accaffObject.Affiliation_Type__c+'').substring(0,15));
            }

            //Find all the existing Affiliation Type records that contain given unique values and add them to a Map
            List<Account_Affiliation__c> accAffList = [select id, Unique_Value__c from Account_Affiliation__c where Unique_Value__c IN :uniqueValueList];
            Map<String,Account_Affiliation__c > uniqueValueMap = new Map<String,Account_Affiliation__c >();
            for(Account_Affiliation__c accAffObject : accAffList){
                uniqueValueMap.put(accAffObject.Unique_Value__c,accAffObject);
            }

            //Loop through the new Affiliation Type records to see if the unique value is found.
            //If so, check whether we are inserting or updating.
            //Throw error if duplicate.
            for(Account_Affiliation__c accAffObject : trig.newList){

                if(uniqueValueMap.containsKey((accAffObject.Account__c+'').substring(0,15) + (accAffObject.Affiliation_Type__c+'').substring(0,15))){

                    //Second condition here is for the update. It allows you to update the record, but not another record.
                    if(trigger.isInsert || (trigger.isUpdate && (accAffObject.id<>uniqueValueMap.get((accAffObject.Account__c+'').substring(0,15)+accAffObject.Affiliation_Type__r.Name).id))){
                        accAffObject.addError('Duplicate Affiliation Type records with same Account ID & Affiliation Type cannot be inserted.');
                    }
                }
            }
        }
    }
}