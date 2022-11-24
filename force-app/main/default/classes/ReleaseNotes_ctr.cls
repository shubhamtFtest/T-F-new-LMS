/**************************************************
* Created by: Tom Reed: 2018-07-30
* Test method: zTest_ReleaseNotes_ctr @100%
**************************************************/
public class ReleaseNotes_ctr {
    
    @AuraEnabled
    public static list<caseRecord> getCaseData(string startDateValueInput, string endDateValueInput){
        
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Salesforce Internal Support').getRecordTypeId();
               
        list<Case> caseList = new list<Case>();
        caseList = [SELECT Id, Release_Notes_rich__c, Owner.Name, Application__c, Target_Resolution_Date__c, CaseNumber
                    FROM Case 
                    WHERE RecordTypeId =: devRecordTypeId 
                    AND Target_Resolution_Date__c > =: date.valueOF(startDateValueInput)
                    AND Target_Resolution_Date__c < =: date.valueOF(endDateValueInput)
                    AND Add_to_Release_Notes__c = true
                    ORDER BY Application__c desc];
        
        list<caseRecord> casesToReturnToLC = new list<caseRecord>();
        for(Case c: caseList){
            if(!String.isBlank(c.Release_Notes_rich__c)){
            caseRecord casesToReturn = new caseRecord();
            casesToReturn.releaseNotes = c.Release_Notes_rich__c;
            casesToReturn.department = c.Application__c;
            casesToReturn.caseId = c.Id;
            casesToReturn.caseNumber = c.CaseNumber;
            date formattedDate = Date.newInstance(c.Target_Resolution_Date__c.year(),c.Target_Resolution_Date__c.month(),c.Target_Resolution_Date__c.day());
            casesToReturn.releaseDate = formattedDate;
            casesToReturnToLC.add(casesToReturn);    
            }
        }
        system.debug(casesToReturnToLC);
        return casesToReturnToLC;
        
    }
    
    public class caseRecord {
        
        @AuraEnabled
        public String releaseNotes{ get;set; }
        
        @AuraEnabled
        public Date releaseDate { get; set; }
        
        @AuraEnabled
        public String department { get; set; }
        
        @AuraEnabled
        public String caseNumber { get; set; }
        
        @AuraEnabled
        public Id caseId { get; set; }
            
    }    
}