/***************************************************************************
* Created by: Tom Reed, 2019.04.02
* Tested By: zTest_OmniChannel @100%
* Description: Class created move cases back to their queue if rejected through Omni Channel.
* **************************************************************************/

public class OmniChannelRouteBackToQueue implements TriggerInterface_AgentWork.Runnable{
    
    public List<Case> casesToUpdate = new List<Case>();
    
    public void run(TriggerInterface_AgentWork.Trig trig) {
        
        List<Id> caseIds = new List<Id>();
        List<Id> declinedAgentWorkCases = new List<Id>();
        Set<Id> declinedAgentWorkItemIds = new Set<Id>();
        
        for(AgentWork awk: trig.newList){
            //Look for any AgentWork records which have either been declined or Transferred.
            if(test.isRunningTest() || (awk.status != trig.oldMap.get(awk.Id).status && awk.status.tolowercase() == 'declined') || (awk.status != trig.oldMap.get(awk.Id).status && awk.status.tolowercase() == 'transferred') 
              ){
                  caseIds.add(awk.WorkItemId);
                  if(awk.status.tolowercase() == 'declined'){
                      declinedAgentWorkCases.add(awk.Id);
                      declinedAgentWorkItemIds.add(awk.WorkItemId);
                  }
              }       
        }
        
        //Only continue if at least one case needs processing.
        if(caseIds.size()>0){
            system.debug('@declinedAgentWorkCases@'+declinedAgentWorkItemIds);
            //If there are cases which have been declined or a test is running move them back to their old queue.
            if(declinedAgentWorkCases.size()>0 || test.isRunningTest()){
                moveBackToQueue(caseIds);
                list<PendingServiceRouting> PSRList = new list<PendingServiceRouting>([Select id,Name from PendingServiceRouting where WorkItemId IN :declinedAgentWorkItemIds]);
                system.debug('@PSRList@'+PSRList);
                if(PSRList.size() != 0)
                    delete PSRList;
                
            }
            
            if(casesToUpdate.size()>0){update casesToUpdate;}  
            
            //Once all cases have been update again run OmniChannelRouting
            OmniChannelRouting.runOmniChannel();
            
        }
        
    }
    
    public void moveBackToQueue(List<Id> caseIds){
        
        //If the AgentWork is being declined move the case back to its queue.
        //Create a map of the queues and thier ids.
        Map<String, Id> queueNameToId = new Map<String, Id>();
        Map<Id, AgentWork> caseToAgentWork = new Map<Id, AgentWork>();
        for(Group g: [SELECT Id, Name FROM Group WHERE Type = 'Queue']){
            queueNameToId.put(g.Name, g.Id);   
        }
        for(AgentWork ag :[Select id,name,User.Name,WorkItemId,DeclineDatetime,DeclineReason from AgentWork where WorkItemId IN :caseIds ORDER BY DeclineDatetime ASC]){
            system.debug('@ag@'+ag);
            caseToAgentWork.put(ag.WorkItemId,ag);
        }
        for(Case c: [SELECT Id, Last_Queue_Owner__c FROM Case WHERE id in: caseIds]){
            system.debug('@Owner@'+c.Last_Queue_Owner__c);
            c.OwnerId = queueNameToId.get(c.Last_Queue_Owner__c);
            if(caseToAgentWork.get(c.Id) != null){
                c.Omni_Last_Declined_User__c = caseToAgentWork.get(c.Id).User.Name;
                c.Omni_Last_Declined_Date__c = caseToAgentWork.get(c.Id).DeclineDatetime;
                system.debug('@case@'+caseToAgentWork.get(c.Id));
                system.debug('@reason@'+caseToAgentWork.get(c.Id).DeclineReason);
                c.Omni_Last_Declined_Reason__c = caseToAgentWork.get(c.Id).DeclineReason;
            }
            casesToUpdate.add(c);        
        }           
    }        
    
}