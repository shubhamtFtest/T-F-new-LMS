/**************************************************
* Created by: Tom Reed: 2018-07-30
* Tested by: zTest_ReleaseNotesPDF @ 100%
**************************************************/

public class ReleaseNotesPDF_ctr {
    public string valuestart {get;set;}
    public string valueend {get;set;}
    public list<Case> caseList {get;set;}
    
    public void getParameter(){
        
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Salesforce Internal Support').getRecordTypeId();        
        
        this.valuestart = ApexPages.currentPage().getParameters().get('startdate');
        this.valueend = ApexPages.currentPage().getParameters().get('enddate');
        
        if(valuestart == null) valueStart = '1900-01-01';
        
        if(valueEnd == null) valueEnd = '2199-01-01';
        
        system.debug('valuestart ' + valuestart );
        system.debug('valueend ' + valueend );
        
        list<Case> tempCaseList = new list<Case>();
        for(Case c: [SELECT Release_Notes_rich__c, Owner.Name, Application__c, Target_Resolution_Date__c, CaseNumber
                     FROM Case 
                     WHERE RecordTypeId =: devRecordTypeId 
                     AND Target_Resolution_Date__c > =: date.valueOf(valuestart)
                     AND Target_Resolution_Date__c < =: date.valueOf(valueend)
                     AND Add_to_Release_Notes__c = true
                     ORDER BY Application__c desc]){
                         if(!String.isBlank(c.Release_Notes_rich__c)){
                             tempCaseList.add(c);                            
                         }                                                
                     }
        this.caseList = tempCaseList;
    }
}