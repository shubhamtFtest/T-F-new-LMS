/***************************************************************************
* Created by: Tom Reed & Matt Smith, 2019.11.22
* Tested By: "zTest_mapCaseFieldsFromCaseDescription" at 100% Test Coverage.
* Description: This class picks up cases which are inserted with a record type of 'T&F - Sales Companion Website Access'. It then deserializes the JSON which is 
* added to the case description and maps the values to the applicable case fields.
* **************************************************************************/
public class mapCaseFieldsFromCaseDescriptionJSON implements TriggerInterface_Case.Runnable{
    
    public void run(TriggerInterface_Case.Trig trig) {
        
        //Only run for an after insert.
        if(trig.IsInsert && trig.IsAfter){
            
            //Get the record type we want this process to run for.
            Id applicableCaseRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('T&F - Sales Companion Website Access').getRecordTypeId();
            List<Case> casesToUpdate = new List<Case>();
            Set<String> emailAddressSet = new Set<String>();  //set is a unique list
            //Loop through the incoming Case records.
            for(Case caseRecord: [SELECT Id, Description, ContactId, AccountId, RecordTypeId FROM Case WHERE Id in: Trig.NewList]){
                
                //Only process if the case record type is 'T&F - Sales Companion Website Access'.
                if(caseRecord.RecordTypeId==applicableCaseRecordTypeID){
                    //Call the method to handle the JSON deserialize but only add the record to the list to be updated if the deserialization was successful.
                    if(deserializeCaseDescription(caseRecord)){ 
                        if (caseRecord.SuppliedEmail != null){
                            emailAddressSet.add(caseRecord.SuppliedEmail);
                        } 
                        casesToUpdate.add(caseRecord);
                    }
                }
            } 
            
            if(casesToUpdate.size()>0){
            Map<String, Contact> emailAddressToContactMap = new Map<String, Contact>();
            //Query the Contact object to locate any matching records from the incoming Case.SuppliedEmail. Create a map to be used later.
            for(Contact contactRecord : [SELECT id, email, accountid FROM Contact WHERE email in : emailAddressSet]){
                emailAddressToContactMap.put(contactRecord.Email, contactRecord);            
            }
            for(Case caseRecord : casesToUpdate){
                if(emailAddressToContactMap.containsKey(caseRecord.SuppliedEmail)){
                    caseRecord.ContactId = emailAddressToContactMap.get(caseRecord.SuppliedEmail).id;
                    if(emailAddressToContactMap.get(caseRecord.SuppliedEmail).AccountId != null){
                        caseRecord.AccountId = emailAddressToContactMap.get(caseRecord.SuppliedEmail).AccountId; 
                    }  
                }           
            }       
            if(casesToUpdate.size()>0){update casesToUpdate;}
        }
        }
    }
    
    public Boolean deserializeCaseDescription(Case theCaseRecord){
        
        Boolean isSuccess = false;
        //Try-Catch block to handle if there is an error with deserializing the JSON in the case description.
        try{
            caseJSONWrapper emailData = new caseJSONWrapper();
            emailData = (caseJSONWrapper)JSON.deserialize(theCaseRecord.Description, caseJSONWrapper.class);   
            theCaseRecord.SuppliedName = emailData.Name;
            theCaseRecord.SuppliedEmail = emailData.Email;
            theCaseRecord.Journal_Name__c = emailData.Textbook_Title;
            theCaseRecord.Customer_Type111__c = emailData.Type_Of_User;
            //To be passed back by the method to indicate if the JSON was successfully deserialized.
            isSuccess = true;
        } catch (exception e) {
            //To be passed back by the method to indicate if the JSON was unsuccessfully deserialized.
            isSuccess = false;  
            system.debug(e.getMessage());
        }
        return isSuccess;
    } 
    
    public class caseJSONWrapper{
        String LegacyCaseNumber, Textbook_Title, Email, Name, Type_Of_User;
    }    
}