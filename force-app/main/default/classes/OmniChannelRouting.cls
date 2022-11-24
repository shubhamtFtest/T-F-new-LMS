/***************************************************************************
* Created by: Tom Reed, 2019.04.02
* Tested By: zTest_OmniChannel @ 97%
* Description: Class created to handle the Omni Channel logic. Cases are pushed to Omni Channel using this class once there is
* agent availablity.
* Modified By : Shefali Arora, 2019.08.30
* Modified By : Faiz Ali, 2019.10.21 - Made changes to fix the issue where the cases were not getting pushed with multiple queues to the user based on Target Date, cases were getting assigned only from one particular queue.
* **************************************************************************/


public class OmniChannelRouting implements TriggerInterface_Case.Runnable{
    
    public List<Case> caseListToRun = new List<Case>();
    public static Id testUserId;
    
    public void run(TriggerInterface_Case.Trig trig) {
        
        
        List<Case> casesToUpdate = new List<Case>();
        
        //Query for the queues because we're unable to get owner.name from the oldMap.
        Map<Id, String> queueIdToNameMap = new Map<Id, String>();
        for(Group g: [SELECT Id, Name FROM Group WHERE Type = 'Queue']){
           queueIdToNameMap.put(g.Id, g.Name); 
        }
        
        for(Case c: [SELECT Id, Isclosed,Omni_Last_Declined_User__c, Last_Queue_Owner__c, OwnerId, Owner.Name FROM Case WHERE id in: Trig.NewList]){
                      
            if(
                //If the case is being moved to a queue, created with a queue owner, being moved from a queue to a user or being closed/re-opened.
                //If the case is an insert and the owner is a queue.
                (Trig.IsInsert && String.ValueOf(c.OwnerId).StartsWith('00G') )
                ||
                //If the case is being moved to a queue.
                //(Trig.IsUpdate && c.OwnerId != Trig.OldMap.get(c.Id).OwnerId && String.ValueOf(c.OwnerId).StartsWith('00G')) //Commented by Shefali Arora as this condition is fulfilled by workflow.
                
                //If the case is being closed/re-opened and is owned by a queue.
                (Trig.IsUpdate && Trig.OldMap.get(c.Id).IsClosed != c.IsClosed && String.ValueOf(c.OwnerId).StartsWith('00G'))
                || 
                //If a case is going from a queue to a user.
                (Trig.IsUpdate && c.OwnerId != Trig.OldMap.get(c.Id).OwnerId && String.ValueOf(c.OwnerId).StartsWith('005') && String.ValueOf(Trig.OldMap.get(c.Id).OwnerId).StartsWith('00G'))                
            )
            {                 
                //If a case is going from a queue to a user.  
                if(Trig.IsUpdate && c.OwnerId != Trig.OldMap.get(c.Id).OwnerId && String.ValueOf(c.OwnerId).StartsWith('005') && String.ValueOf(Trig.OldMap.get(c.Id).OwnerId).StartsWith('00G'))
                {            
                //Stamp the case with the queue it has now been moved to.
                c.Last_Queue_Owner__c = queueIdToNameMap.get(Trig.OldMap.get(c.Id).OwnerId);
                } 
                else 
                {
                c.Last_Queue_Owner__c = c.Owner.Name;
                caseListToRun.add(c); 
                }
                casesToUpdate.add(c);
            }
        }
        if(casesToUpdate.size()>0){
            update casesToUpdate;
        }
        
        //Run the rest of the class if a case has been assigned to a queue or a case has been closed/re-opened.
        if(caseListToRun.size()>0){
            runOmniChannel();
        }
    }
    
    public static void runOmniChannel(){
  
        //From the Omni Channel Rules object locate a list of queues and the capacity each item of work takes.
        Map<String, Decimal> queueToWorkCapacityMap = new Map<String, Decimal>();
        for(Omni_Channel_Rules__c ocr: [SELECT Id, Queue__c, Owner.Name, Work_Capacity__c FROM Omni_Channel_Rules__c]){
            queueToWorkCapacityMap.put(ocr.Queue__c.ToLowerCase(), ocr.Work_Capacity__c);
        }
        
        //Locate any existing PSR records so we don't try to add them again.
        List<Id> casesWithExistingPSR = new List<Id>();
        for(PendingServiceRouting psr: [SELECT Id, WorkItemId FROM PendingServiceRouting]){
            system.debug('@psr.id@'+psr.Id+'****'+psr.WorkItemId );
            //Only add psr records relating to cases.
            if(String.ValueOf(psr.WorkItemId).StartsWith('500')){
            casesWithExistingPSR.add(psr.WorkItemId);  
            }
        }
        
        //Locate all of the users currently logged into Omni Channel and which queues they belong to.
        List<Id> availableUsers = new List<Id>();
        Set<Id> usersAvailableToTakeWork = new Set<Id>();
        Map<Id, Decimal> userIdToAvailableCapacityMap = new Map<Id, Decimal>();
       
        //If a test is running use the test user.
        if(test.isRunningTest()){
            availableUsers.add(testUserId);
            usersAvailableToTakeWork.add(testUserId);
            userIdToAvailableCapacityMap.put(testUserId, 10);
        }
        for(UserServicePresence usp: [SELECT UserId FROM UserServicePresence WHERE IsAway = false AND IsCurrentState = true]){
            availableUsers.add(usp.UserId);
            //Also add them to a set of users who are available to take work.
            usersAvailableToTakeWork.add(usp.UserId);
            //Add the users max capacity to be used later.
            system.debug('@usermap@'+usp.UserId);
            userIdToAvailableCapacityMap.put(usp.UserId, 10);
        }                    
        
        //Only continue if a user is logged into Omni Channel or if a test is running.    
        if(userIdToAvailableCapacityMap.keyset().size()>0 || test.isRunningTest()){
            
            //Create a map of Queues and which users belong to them.
            Map<String,Set<String>> queueNameToUsersMap = new Map<String,Set<String>>();
            //If running a test construct queueNameToUsersMap using the test data.
            
            if(test.isRunningTest()){queueNameToUsersMap.put('tomstestqueue', new Set<String>{String.ValueOf(testUserId)});}
            //Map to store all the skills of a particular service resource
            Map<Id, set<String>> ServiceResourceIdToSkillNameMap = new Map<Id, set<String>>();
            Map<Id, set<String>> UserIdToSkillNameMap = new Map<Id, set<String>>();
            Set<String> skillSet= new Set<String>();
            for(ServiceResourceSkill s: [SELECT ServiceResourceId,ServiceResource.RelatedRecordId, Skill.MasterLabel FROM ServiceResourceSkill WHERE Skill.MasterLabel in: queueToWorkCapacityMap.keyset()]){
                if(ServiceResourceIdToSkillNameMap.containsKey(s.ServiceResourceId) && UserIdToSkillNameMap.containsKey(s.ServiceResource.RelatedRecordId)){
                    skillSet = ServiceResourceIdToSkillNameMap.get(s.ServiceResourceId);
                }
                skillSet.add(s.Skill.MasterLabel);
                ServiceResourceIdToSkillNameMap.put(s.ServiceResourceId, skillSet);
                UserIdToSkillNameMap.put(s.ServiceResource.RelatedRecordId,skillSet); 
                skillSet = new Set<String>(); 
              //  system.debug('@userId@@'+s.ServiceResource.RelatedRecordId+'@skill@'+skillSet);  
            }
            
            for(ServiceResource sr: [SELECT RelatedRecordId,Id FROM ServiceResource WHERE Id in: ServiceResourceIdToSkillNameMap.keyset()]){
                Set<String> existingValues = new Set<String>();
                Set<String> SetOfUsers = new Set<String>();
                for(String sk : ServiceResourceIdToSkillNameMap.get(sr.Id)){
                    if(queueNameToUsersMap.containsKey(sk.tolowercase())){
                        SetOfUsers = queueNameToUsersMap.get(sk.tolowercase());
                    }
                    SetOfUsers.add(sr.RelatedRecordId);
                    queueNameToUsersMap.put(sk.tolowercase(), SetOfUsers);
                  //  system.debug('@skill@'+sk+'@serviceRes@'+SetOfUsers);             
                }
              /*  if(queueNameToUsersMap.containsKey(ServiceResourceIdToSkillNameMap.get(sr.Id).tolowercase())){
                    existingValues = queueNameToUsersMap.get(ServiceResourceIdToSkillNameMap.get(sr.Id).tolowercase());
                    system.debug('@existingInside@'+existingValues );
                }
                existingValues.add(sr.RelatedRecordId);
                queueNameToUsersMap.put(ServiceResourceIdToSkillNameMap.get(sr.Id).tolowercase(), existingValues);  */
                
            }
         //   system.debug('@caseNewCondition@'+queueNameToUsersMap.containskey('CSD Society'));
         //   system.debug('@caseNewCondition@'+queueNameToUsersMap.containskey('csd society'));
        /*    for(String sk :ServiceResourceIdToSkillNameMap.keyset()){
              //  system.debug('skill'+sk);
                if(sk == '0Hn2X000000blLySAI'){
                    for(string sr: ServiceResourceIdToSkillNameMap.get(sk)){
                     //   system.debug('skill@@'+ sr);
                    }
                }
                
            }*/
                                            
            //Locate the amount of work currently assigned to the available users and identify capacity availablity.
            //system.debug(availableUsers);           
            //Ignore any Spam cases.
            system.debug('@availableuser@'+availableUsers );
          //  system.debug('@quetoWORK@'+queueToWorkCapacityMap.keyset());
            for(Case c: [SELECT OwnerId,CaseNumber, Omni_Last_Declined_User__c,Last_Queue_Owner__c FROM Case WHERE isClosed = false AND Status != 'Spam' AND OwnerId in: availableUsers AND Last_Queue_Owner__c in: queueToWorkCapacityMap.keyset()]){
                system.debug(c.CaseNumber);
                system.debug(c.Last_Queue_Owner__c);
                //Locate the weighting for the existing cases.
                Integer capacityValue = 0;
                capacityValue = Integer.ValueOf(queueToWorkCapacityMap.get(c.Last_Queue_Owner__c.ToLowerCase()));
                
                //The maximum capacty for all users is 10.
                Decimal existingCapacity = 0;
                if(userIdToAvailableCapacityMap.keyset().contains(c.OwnerId)){
                    existingCapacity = userIdToAvailableCapacityMap.get(c.OwnerId);
                } else {
                    //Make the users available capacity 10 if they're not already in the map.
                    existingCapacity = 10;                          
                }
              //  system.debug('@before@'+c.ownerId+'***'+userIdToAvailableCapacityMap.get(c.OwnerId ));
                userIdToAvailableCapacityMap.put(c.OwnerId ,existingCapacity - capacityValue);
              //  system.debug('@after@'+c.ownerId+'***'+userIdToAvailableCapacityMap.get(c.OwnerId ));
                //If the users capacity goes below 0 they can't take on anymore work.
                if(existingCapacity - capacityValue < 0){
                    usersAvailableToTakeWork.remove(c.OwnerId); 
                }
                
            }
            
            //If a test is running ensure the test user has capacity to take on work.
            if(test.isRunningTest()){
                userIdToAvailableCapacityMap.put(testUserId, 10);
                usersAvailableToTakeWork.add(testUserId);
                    }
            
            //Loop through any open cases which are in the applicable queues and identify if there is already a PendingServiceRouting record.The looping
            //should stop once the current availablty number has been met for each of those queues. The loop should start with the case about to reach its SLA breach first.
            //Flag the PendingServiceRouting IsReadyforRouting = true and RoutingPriority = 1.
            
            List<PendingServiceRouting> psrListToUpdate = new List<PendingServiceRouting>();
            List<SkillRequirement> srList = new List<SkillRequirement>();
            List<Case> casesToUpdateLastQueueOwner = new List<Case>();
            Map<Id, String> caseIdToQueueNameMap = new Map<Id, String>();
          //  System.debug(userIdToAvailableCapacityMap.get('0052X000008WMy0QAG'));
          //  system.debug('@queMApkey@'+queueNameToUsersMap.keyset());
            //SOQL is ordering the cases by SlaExitDate so that sla breaches are routed first.
            for(Case c: [SELECT Id,CaseNumber, Owner.Name, Omni_Last_Declined_User__c,Target_Date__c FROM Case WHERE Status != 'Spam' AND isclosed = false AND Owner.Name in: queueToWorkCapacityMap.keyset() ORDER BY Target_Date__c ASC NULLS LAST]){
                
                //If a user is assigned to the Case's queue set its PendingServiceRouting record to true.
                //Locate the capacity weighting for the Cases queue.
                Decimal caseCapacity = queueToWorkCapacityMap.get(c.Owner.Name.ToLowerCase());
                //if(c.Id == '5002X00002aI5FbQAK'){
                //Loop through the users who are a member of the Case's queue.
                system.debug('@caseNumber@'+c.Id+'****'+c.CaseNumber);
                system.debug('@caseCONDITION@'+queueNameToUsersMap.containskey(c.Owner.Name.ToLowerCase()));
                if(queueNameToUsersMap.containskey(c.Owner.Name.ToLowerCase())){
                for(String s: queueNameToUsersMap.get(c.Owner.Name.ToLowerCase())){
                  //  system.debug('@caseNumberInside@'+c.Id+'****'+c.CaseNumber);
                /*  if(c.Id == '5002X00002aI5FbQAK'){
                    system.debug('@sring name@'+s);
                    system.debug('@usersAvailableToTakeWork.contains(s)@'+usersAvailableToTakeWork.contains(s));
                    system.debug('@userIdToAvailableCapacityMap.get(s)@'+userIdToAvailableCapacityMap.get(s));}*/
                  //  system.debug('@caseCapacity @'+caseCapacity );
                  //  system.debug('@casesWithExistingPSR.contains(c.id)@'+casesWithExistingPSR.contains(c.id));
                  //  system.debug('@c.Omni_Last_Declined_User__c != UserInfo.getName()@'+(c.Omni_Last_Declined_User__c != UserInfo.getName()));
                     for(String sk: UserIdToSkillNameMap.get(s)){
                         
                         
                             
                                  
                    //If the queue member is currently logged into omni channel and has enough capacity to take on the incoming case.
                    //Added condition to check the case getting assigned is having the queue from one of the skills of the logged in user
                    if(usersAvailableToTakeWork.contains(s) && userIdToAvailableCapacityMap.get(s) >= caseCapacity && !casesWithExistingPSR.contains(c.id) && c.Omni_Last_Declined_User__c != UserInfo.getName() && (sk.ToLowerCase() == c.Owner.Name.ToLowerCase()) ){
                       //system.debug('@224@'+sk+'##'+c.Owner.Name.ToLowerCase());
                        caseIdToQueueNameMap.put(c.Id, c.Owner.Name);
                       /* system.debug('inside'+c.Id+'###'+c.Owner.Name); 
                        system.debug('@sring name@'+s);
                        system.debug('@usersAvailableToTakeWork.contains(s)@'+usersAvailableToTakeWork.contains(s));
                        system.debug('@userIdToAvailableCapacityMap.get(s)@'+userIdToAvailableCapacityMap.get(s));
                        system.debug('@caseCapacity @'+caseCapacity );
                        system.debug('@casesWithExistingPSR.contains(c.id)@'+casesWithExistingPSR.contains(c.id));
                        system.debug('@c.Omni_Last_Declined_User__c != UserInfo.getName()@'+(c.Omni_Last_Declined_User__c != UserInfo.getName()));  */
                        PendingServiceRouting newServiceRouting = new PendingServiceRouting();
                        newServiceRouting.RoutingPriority = 1;
                        newServiceRouting.IsReadyforRouting = false;
                        newServiceRouting.CapacityWeight = queueToWorkCapacityMap.get(c.Owner.Name.ToLowerCase());//Get the work capacity from the Omni Channel Rules object.
                        newServiceRouting.RoutingModel = 'MostAvailable';
                        newServiceRouting.RoutingType = 'SkillsBased';
                        newServiceRouting.WorkItemId = c.id;
                        newServiceRouting.ServiceChannelId = [SELECT Id FROM Servicechannel WHERE Developername = 'Cases' LIMIT 1].Id;
                        psrListToUpdate.add(newServiceRouting);
                        //Update the users capacity
                        Decimal userCapacity = userIdToAvailableCapacityMap.get(s); 
                        userIdToAvailableCapacityMap.put(s, userCapacity - caseCapacity);
                        
                        //Also update the case so the last queue owner is populated for all cases entering Omni Channel.
                        c.Last_Queue_Owner__c = c.Owner.Name;
                        casesToUpdateLastQueueOwner.add(c);  
                        
                        break; 
                        //Break out of the loop because the PendingServiceRouting record for the case has been assigned to a user.
                    }  
                     
                     }                     
                }   
                }
            }
            system.debug('@psr ka size@'+psrListToUpdate.size());
            if(psrListToUpdate.size()>0){
                //Due to a salesforce bug not recognising if a PSR record is already present for a given case a try-catch had to be used.
                try{
                    Database.Insert(psrListToUpdate, false);
                } catch(exception e){
                    system.debug(e.getMessage());
                }
            }
            if(casesToUpdateLastQueueOwner.size()>0){
                update casesToUpdateLastQueueOwner;
            }            
            //Locate the skil required for the case.
            Map<String, Id> skillToIdMap = new Map<String, Id>();
            for(Skill s: [SELECT Id, MasterLabel FROM Skill WHERE MasterLabel in: queueToWorkCapacityMap.keyset()]){
                skillToIdMap.put(s.MasterLabel, s.Id);
            }

            for(PendingServiceRouting psr: psrListToUpdate){
                //To ensure the PSR record was inserted first.
                if(psr.Id != null){
                // Now add SkillRequirement(s) to the PendingServiceRouting
                SkillRequirement srObj = new SkillRequirement(
                    RelatedRecordId = psr.id,
                    SkillId = skillToIdMap.get(caseIdToQueueNameMap.get(psr.WorkItemId))             
                );
                srList.add(srObj);              
                }
                
            }            
            if(srList.size()>0){
                insert srList;
            }
            List<PendingServiceRouting> finalListOfPSRUpdates = new List<PendingServiceRouting>();
            for(PendingServiceRouting psr: psrListToUpdate){
                //Only update the record if it was successfully inserted.
                if(psr.Id != null){
                    psr.IsReadyForRouting=true; 
                    finalListOfPSRUpdates.add(psr);
                }
            }
            if(finalListOfPSRUpdates.size()>0){
            update finalListOfPSRUpdates;
            }
            
        }               
    }
}