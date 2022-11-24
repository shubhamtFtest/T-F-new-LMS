/*
* Created By gopinath.punniakotti@taylorandfrancis.com(Gopinath Punniakotti) 2022-03-04
* Benjamin Smith wants to display the Cases with Attachments Title.(https://taylorfrancis.atlassian.net/browse/BAU-14320)
* Test_CaseWithAttachment -- 100% code coverage.
* Note: Used in Lightning component CasesWithAttachment, and also added the custom button to export all detail into .CSV files.
* It will visible only for Benjamin Smith User.
* */
public class CasesWithAttachment {
    
    @AuraEnabled
    public static Map<string,List<Case>> getData(){
        
        List<Case> listCases = new List<Case>();
        set<Id> caseId = new set<Id>();
        set<Id> parentId = new set<Id>();
        List<string> titleName = new List<string>();
        Map<Id,string> getCaseIdAndAttachName = new Map<Id,string>();
        Map<string,List<Case>> getCaseAndFileName = new Map<string,List<Case>>();
        
        listCases = [SELECT Id,Subject,Priority,Status,CreatedDate,Owner.name,CaseNumber FROM Case WHERE Subject LIKE '%Scheduled Report: OA Article Publishing Charges%' AND Status = 'New'];
        
        for(case cas: listCases){
            caseId.add(cas.Id);
        }
        system.debug('caseId '+caseId);
        List<EmailMessage> emailMessageList = new List<EmailMessage>();
        emailMessageList = [Select Id,ParentId,(SELECT Id, Name FROM Attachments) from EmailMessage where HasAttachment = true AND ParentId =: caseId];
        for(EmailMessage em : emailMessageList){
            for(Attachment at : em.Attachments){
                system.debug('***'+em.parentID);
                system.debug('***'+at.Name);
                getCaseIdAndAttachName.put(em.parentID,at.Name);
                List<Case> caseList = new List<Case>();
                caseList = [SELECT Id,Subject,Priority,Status,CreatedDate,Owner.name,CaseNumber FROM Case WHERE Id =: em.parentID ];
                system.debug(caseList);
                getCaseAndFileName.put(at.Name, caseList);
            } 
        }
        system.debug('getCaseAndFileName '+getCaseAndFileName);
        return getCaseAndFileName; 
    }
}