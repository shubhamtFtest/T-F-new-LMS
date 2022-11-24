/* Tested by: zTest_Case_Support_Team_Trig at 93%
* 
*  Created by Tom Reed / Jeff Lup - 2018.04.26
*  Update by Tom Reed 2019.05.14
*  Updated by Matt Smith 2020.05.04 - Let the trigger only run for Platform Support. As CSD are now using Support Team. 
*
*/
public class Case_Support_Team_Trig implements TriggerInterface_CaseComment.Runnable {
    
    public Map<String, Id> supportTeamNameToGroupId = new Map<String, Id>();
    //Create a map of the users in the public group.
    public Map<String, List<Id>> groupToUsersMap = new Map<String, List<Id>>();
    Map<String, List<Id>> supportTeamGroupToUserListMap = New Map<String, List<Id>>();
    
    public void run(TriggerInterface_CaseComment.Trig trig) {
        if (trig.isAfter && trig.isInsert) {
            //Get maps of CaseIds and CreatedByIds, to be used later
            Map<Id, Id> mapCcIdToCaseId = new Map<Id, Id>();
            Map<Id, Id> mapCcIdToCreatedById = new Map<Id, Id>();           
            for (CaseComment cc : trig.newList) {
                mapCcIdToCaseId.put(cc.Id, cc.ParentId);
                mapCcIdToCreatedById.put(cc.Id, cc.CreatedById);
            }
            
            //Get parent Cases, so we know the Support Team per Case
            Map<Id, Case> mapCases = new Map<Id, Case>([SELECT Id, RecordTypeId, RecordType.Name, Support_Team_Owner__r.Email, Subject, CaseNumber, Support_Team__c, Support_Team_Owner__c FROM Case WHERE Id IN :mapCcIdToCaseId.values() AND Support_Team__c!=null]);
            Set<String> supportTeamSet = new Set<String>();
            for (Case cc : mapCases.values()){                
                supportTeamSet.add(String.ValueOf(cc.Support_Team__c));      
            }                       
            
            
            //Only continue if there is a support team assigned to the case.
            if(mapCases.keyset().size()>0){
                
                Set<Id> activeUsers = new Set<Id>();
                //Make sure only active users are considered.
                
                for(Groupmember gm: [SELECT Groupid, UserOrGroupId, Group.Name FROM Groupmember 
                                     WHERE Group.Name in: supportTeamSet AND Group.Type='Regular']){
                                         //Only process if the member is a user.
                                         if(String.ValueOf(gm.UserOrGroupId).StartsWith('005')){
                                             activeUsers.add(gm.UserOrGroupId);
                                         }
                                     }
                
                for(User u: [SELECT Id, IsActive FROM User WHERE Id in: activeUsers]){
                    if(!u.IsActive){
                        activeUsers.remove(u.Id);
                    }                   
                }                
                
                for(Groupmember gm: [SELECT Groupid, UserOrGroupId, Group.Name FROM Groupmember 
                                     WHERE Group.Name in: supportTeamSet AND Group.Type='Regular' AND UserOrGroupId in: activeUsers]){
                                         //Only process if the member is a user.
                                         if(String.ValueOf(gm.UserOrGroupId).StartsWith('005')){
                                             List<Id> groupMembersList = New List<Id>();
                                             if(groupToUsersMap.containskey(gm.GroupId)){groupMembersList = groupToUsersMap.get(gm.GroupId);}
                                             groupMembersList.add(gm.UserOrGroupId);
                                             this.groupToUsersMap.put(gm.GroupId, groupMembersList);
                                             this.supportTeamGroupToUserListMap.put(gm.Group.Name, groupMembersList);
                                             supportTeamNameToGroupId.put(gm.Group.Name, gm.GroupId);
                                         }
                                     }
                
                //Now proceed, since we have all we need.
                List<Case> casesToUpdate = new List<Case>();
                for (CaseComment cc : trig.newList) {
                    Case cse = mapCases.get(mapCcIdToCaseId.get(cc.Id));
                    String supportTeamValue = cse.Support_Team__c;
                    if(supportTeamValue.startswith('Platform Support')){ //only run if support team is platform support
                        id createdById = mapCcIdToCreatedById.get(cc.Id);
                        //If the owner of the case is part of platform support re-open the case for CSD.
                        //Only re-open if the case record type is csd.
                        if (cse.RecordType.Name.startswith('T&F - CSD') &&  supportTeamGroupToUserListMap.get(cse.Support_Team__c).contains(createdById)) { //check to see if the user is part of platform support.
                            cse.Status = 'Re - Opened';
                            casesToUpdate.add(cse);
                        } else {
                            //If the owner of the case is not platform support send them an email to notify that someone else has added
                            // a case comment.
                            constructEmail(cse, cc.Id);      
                        }
                    }
                }            
                if (casesToUpdate.size() > 0)
                    update casesToUpdate;
            }
        }
    }
    
    
    public void constructEmail(Case theCase, Id theCaseCommentId){
        
        List<String> toAddresses = New List<String>();
        //If a Support_Team_Owner__c is populated send to that user, otherwise use the list of users in the support team group.
        if(theCase.Support_Team_Owner__c != null){
            toAddresses.add(theCase.Support_Team_Owner__r.Email);
        } else {
            if(this.supportTeamGroupToUserListMap.containskey(theCase.Support_Team__c)){
                toAddresses = this.supportTeamGroupToUserListMap.get(theCase.Support_Team__c);
            }
        }
        //only send the email if support team and support team owner fields aren't both blank.
        if(toAddresses.size()>0){        
            
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
            mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName('Salesforce');
            mail.setSubject('New Case Comments: '+theCase.CaseNumber);
            String body = 'Platform Support,' + '<br />';
            body+= 'Comments have been added to case ' +  theCase.CaseNumber +': '+ theCase.Subject +'. Please click the link below to view the Case comments:' + '<br />';
            body+= System.Url.getSalesforceBaseURL().toExternalForm() + '/' + theCase.Id + '<br />';
            body+='Regards,' + '<br />';
            body+='Salesforce';
            mail.setHtmlBody(body);           
            mail.setSaveAsActivity(false);
            
            if(!Test.isRunningTest()){
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   
            }
        }
    }
}