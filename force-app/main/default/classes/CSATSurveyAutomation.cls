/**************************************************
* Created by: Tom Reed: 2018-11-05
* Tested by: zTest_CSATSurveyAutomation @ 91%
* This class is called by CSATSurveyAutomationBatch
* This class updates the Survey_Status__c = "Send" which causes wfr "CSAT Survey Send" to send the CSAT Survey email.
* Updated: Tom Reed: 2018-11-06
*		 : Changed from TrigClass to Scheduled Class due to a time based wfr which starts the process causing delays with an existing time based wfr.
**************************************************/

global class CSATSurveyAutomation{
    
    public static void CSATSurveyAutomation(List<Id> caseIds){      
        
        CSAT_Configuration__c csat_Configuration = [SELECT Contact_Exclusion_Range__c
                                                    , Run_in_Sandboxes__c
                                                    , Closed_Date_Range__c
                                                    , Closed_Date_Range_Length__c
                                                    FROM CSAT_Configuration__c LIMIT 1];  
                 
            
            List<Case> casesToUpdate = new List<Case>();
            
            for(Case c: [SELECT Ready_For_CSAT_Survey__c FROM Case WHERE Id in: caseIds]){
                c.Ready_for_CSAT_Survey__c = True;
                casesToUpdate.add(c);        
            }
            
            if(casesToUpdate.size()>0){
                update casesToUpdate; 
            }
            
            if(caseIds.size()>0){
                //Initialize the list of email addresses, queues and query types to exclude.
                Map<String, List<String>> exclusionTypeToValueMap = new Map<String, List<String>> ();
                //Add at least one value for each exclusion type.		       
                exclusionTypeToValueMap.put('email', new string[] { 'This is a placeholder' });  
                exclusionTypeToValueMap.put('queue', new string[] { 'This is a placeholder' });
                exclusionTypeToValueMap.put('query type', new string[] { 'This is a placeholder' });
                exclusionTypeToValueMap.put('query category', new string[] { 'This is a placeholder' });
                
                //Add at least one value for each exclusion type into the contains list.
                Map<String, List<String>> exclusionTypeToValueMapContains = new Map<String, List<String>> ();       
                exclusionTypeToValueMapContains.put('email', new string[] { 'This is a placeholder' });  
                exclusionTypeToValueMapContains.put('queue', new string[] { 'This is a placeholder' });
                exclusionTypeToValueMapContains.put('query type', new string[] { 'This is a placeholder' });
                exclusionTypeToValueMapContains.put('query category', new string[] { 'This is a placeholder' });
                
                
                List<Setting_Item__c> recordsToRemove = new List<Setting_Item__c>();
                for(Setting_Item__c si: [SELECT Id, Text_1__c, Text_2__c,  Text_3__c, Text_4__c, Text_5__c
                                         FROM Setting_Item__c 
                                         WHERE Setting__r.Name = 'CSATSurveyRules']){
                                             if(si.Text_4__c == 'external survey' && Date.ValueOf(si.Text_3__c) < system.today().adddays(-1 * Integer.ValueOf(csat_Configuration.Contact_Exclusion_Range__c))){
                                                 recordsToRemove.add(si);
                                             } else {               
                                                 
                                                 List<String> existingValues = new List<String>();
                                                 
                                                 //If the value is a contains.
                                                 if(si.Text_5__c == 'contains'){
                                                     if(exclusionTypeToValueMapContains.get(si.Text_1__c.toLowerCase()) != null){
                                                         existingValues = exclusionTypeToValueMapContains.get(si.Text_1__c.toLowerCase());
                                                     }                                              
                                                     //If the search needs to be a contains.
                                                     existingValues.add(si.Text_2__c.toLowerCase()); 
                                                     exclusionTypeToValueMapContains.put(si.Text_1__c.toLowerCase(), existingValues);
                                                     
                                                 } 
                                                 
                                                 //If the value is an exact match.
                                                 if(si.Text_5__c != 'contains'){
                                                     if(exclusionTypeToValueMap.get(si.Text_1__c.toLowerCase()) != null){
                                                         existingValues = exclusionTypeToValueMap.get(si.Text_1__c.toLowerCase());
                                                     }                                                                                                                         
                                                     existingValues.add(si.Text_2__c.toLowerCase()); 
                                                     exclusionTypeToValueMap.put(si.Text_1__c.toLowerCase(), existingValues);
                                                 }
                                             }
                                         }
                if(recordsToRemove.size()>0){
                    delete recordsToRemove;
                }
                
                List<String> caseNumbers = new List<String>();
                //Locate the case details.
                Map<String, Case> emailToCaseMap = new Map<String, Case>();
                for(Case c: [SELECT Id, SuppliedEmail, Contact.Email, Query_Type__c, Query_Category__c, 
                             Owner.Name, toLabel(Product_Platform__c), Case_Last_Closed_By__c, ClosedDate, Origin, CaseNumber
                             FROM Case WHERE Id in: caseIds 
                             AND (Contact.Email != null OR SuppliedEmail != null)]){
                                 
                                 //Set the values to lower case so they can be matached in the map.
                                 string owner = c.Owner.Name != null ? c.Owner.Name.toLowerCase() : 'No Search Required';
                                 string queryType = c.Query_Type__c != null ? c.Query_Type__c.toLowerCase() : 'No Search Required';
                                 string queryCategory = c.Query_Category__c != null ? c.Query_Category__c.toLowerCase() : 'No Search Required';
                                 string suppliedEmail = c.SuppliedEmail != null ? c.SuppliedEmail.toLowerCase() : 'No Search Required';
                                 string contactEmail = c.Contact.Email != null ? c.Contact.Email.toLowerCase() : 'No Search Required';
                                 
                                 Boolean doProcess = true;
                                 for(String s : exclusionTypeToValueMapContains.get('queue')){
                                     if(owner.containsIgnoreCase(s)){
                                         doProcess = false;
                                         break;
                                     }         
                                 }
                                 if(!doProcess) continue;
                                 
                                 for(String s : exclusionTypeToValueMapContains.get('query type')){
                                     if(queryType.containsIgnoreCase(s)){
                                         doProcess = false;
                                         break;
                                     }
                                 }  
                                 if(!doProcess) continue;
                                 
                                 for(String s : exclusionTypeToValueMapContains.get('query category')){
                                     if(queryCategory.containsIgnoreCase(s)){
                                         doProcess = false;
                                         break;
                                     }
                                 }  
                                 if(!doProcess) continue;        
                                 
                                 for(String s : exclusionTypeToValueMapContains.get('email')){
                                     if(suppliedEmail.containsIgnoreCase(s)){
                                         doProcess = false;
                                         break;
                                     }
                                 }  
                                 if(!doProcess) continue;         
                                 
                                 for(String s : exclusionTypeToValueMapContains.get('email')){
                                     if(contactEmail.containsIgnoreCase(s)){
                                         doProcess = false;
                                         break;
                                     }
                                 }  
                                 if(!doProcess) continue;                              
                                 
                                 
                                 if(
                                     //Exact match.
                                     !exclusionTypeToValueMap.get('queue').contains(owner)
                                     && !exclusionTypeToValueMap.get('query type').contains(queryType)
                                     && !exclusionTypeToValueMap.get('query category').contains(queryCategory)
                                     && !exclusionTypeToValueMap.get('email').contains(suppliedEmail)
                                     && !exclusionTypeToValueMap.get('email').contains(contactEmail)                               
                                 ){                      
                                     String EmailAddress;
                                     if(c.Contact.Email != null){
                                         EmailAddress = c.Contact.Email;
                                     } else {
                                         EmailAddress = c.SuppliedEmail;
                                     }
                                     emailToCaseMap.put(EmailAddress, c);
                                     //Record the case numbers.
                                     caseNumbers.add(c.CaseNumber);
                                 }
                             }
                //Check to see if any of the customer identified above have had a CSAT in the last 30 days.
                Integer exclusionDate = -1 * Integer.ValueOf(csat_Configuration.Contact_Exclusion_Range__c);
                Date todayMinusExclusionDate = system.today().adddays(exclusionDate);
                for(CSAT__c c: [SELECT Id, Survey_Date__c, Customer_Email_Address__c
                                FROM CSAT__c 
                                WHERE Survey_Date__c >=: todayMinusExclusionDate
                                AND Customer_Email_Address__c in: emailToCaseMap.keyset()]){
                                    emailToCaseMap.remove(c.Customer_Email_Address__c);
                                }
                
                //Check to make sure the case hasn't already been sent a CSAT survey.
                List<String> casesWithAnExistingCSAT = new List<String>();
                for(CSAT__c c: [SELECT Case__r.CaseNumber FROM CSAT__c WHERE Case__r.CaseNumber in: caseNumbers]){
                    casesWithAnExistingCSAT.add(c.Case__r.CaseNumber);
                }
                
                //Create a CSAT record
                List<CSAT__c> csatList = new List<CSAT__c>();
                for(Case c: emailToCaseMap.values()){
                    //If the case doesn't already have a csat record attached to it.
                    if(!casesWithAnExistingCSAT.contains(c.CaseNumber)){
                        CSAT__c newCSAT = new CSAT__c();
                        newCSAT.Name = c.CaseNumber;
                        newCSAT.Agent_Name__c = c.Case_Last_Closed_By__c;
                        newCSAT.Case__c = c.Id;
                        newCSAT.Case_Close_Date__c = c.ClosedDate;
                        newCSAT.Case_Origin__c = c.Origin;
                        if(c.ContactId != null){
                            newCSAT.Customer_Email_Address__c = c.Contact.email;
                        } else {
                            newCSAT.Customer_Email_Address__c = c.SuppliedEmail;   
                        }
                        newCSAT.Product_Platform__c = c.Product_Platform__c;
                        newCSAT.Query_Category__c = c.Query_Category__c;
                        newCSAT.Query_Type__c = c.Query_Type__c;
                        newCSAT.Queue__c = c.Owner.Name;
                        newCSAT.Survey_Status__c = 'Send';
                        newCSAT.Survey_Date__c = system.now();                        
                        csatList.add(newCSAT);        
                    }
                }
                if(csatList.size()>0){
                    insert csatList; 
                }
            }
        }
}