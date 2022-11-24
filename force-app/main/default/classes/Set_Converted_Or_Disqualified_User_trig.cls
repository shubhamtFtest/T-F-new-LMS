/**************************************************
* Created by Tom Reed, 2018.05.23
* Tested By zTest_ConvertedOrDisqualifiedUser_trig @ 100%
**************************************************/

public class Set_Converted_Or_Disqualified_User_trig implements TriggerInterface_Lead.Runnable {
    public void run(TriggerInterface_Lead.Trig trig) { 
        Set<String> disqualifiedLeadStages = New Set<String>();
        Map<ID, String> leadIdToOldOwnerUserMap = new  Map<ID, String>();
        Map<ID, String> leadIdToOldOwnerQueueMap = new  Map<ID, String>();
        Map<ID, String> leadIdToOldOwnerAllMap = new  Map<ID, String>();
        
        //Initialize The Disqualified Lead Stages
        Setting__c settingRecord = [SELECT id FROM Setting__c WHERE Name = 'DisqualifiedLeadStages' LIMIT 1];
        List<Setting_Item__c> settingItemRecord = [SELECT Text_1__c FROM Setting_Item__c WHERE Setting__c =: settingRecord.id];
        for(Setting_Item__c si: settingItemRecord){       
            disqualifiedLeadStages.add(si.Text_1__c);
        }       
        if (trig.isafter && trig.isUpdate) {
            for(integer i = 0; i < trig.triggerSize; i++){   
                //If The Lead is Converted or Status is change to Disqualified
                if((trig.oldList[i].isConverted == False && trig.newList[i].isConverted == True)
                   || (trig.newList[i].status != trig.oldList[i].status && disqualifiedLeadStages.contains(trig.newList[i].Status))){                      
                       Lead lds = trig.oldList[i];
                       leadIdToOldOwnerAllMap.put(lds.id, lds.Ownerid);
                       //If Owner Is A User
                       if(String.Valueof(lds.ownerid).startswith('005')){
                           leadIdToOldOwnerUserMap.put(lds.id, lds.Ownerid);
                       } else {
                           leadIdToOldOwnerQueueMap.put(lds.id, lds.Ownerid);
                       } //If Owner Is A Queue 
                   }
            }
            //Get The Names Of The Lead Owner If They Are A User
            Map<ID, String> ownerIdToNameMap = new  Map<ID, String>();
            if(leadIdToOldOwnerUserMap.size()>0){
                for (User u: [SELECT Id, Name 
                              FROM User 
                              WHERE Id in: leadIdToOldOwnerUserMap.Values()]){         
                                  ownerIdToNameMap.put(u.id, u.Name);
                              }
            }
            //Get The Name Of The Lead Owner If They Are A Queue
            if(leadIdToOldOwnerQueueMap.size()>0){
                for (Group u: [SELECT Id, Name 
                               FROM Group 
                               WHERE Id in: leadIdToOldOwnerQueueMap.Values() AND Type = 'Queue']){         
                                   ownerIdToNameMap.put(u.id, u.Name);
                               }      
            }   
            if(leadIdToOldOwnerAllMap.size()>0){
                List<Lead> leadsToUpdate = new List<Lead>();
                for(Lead flds : [SELECT ID, OwnerId
                                 FROM Lead 
                                 WHERE ID in: leadIdToOldOwnerAllMap.keyset()]){
                                     flds.Converted_Disqualified_By__c = ownerIdToNameMap.get(leadIdToOldOwnerAllMap.get(flds.id));
                                     leadsToUpdate.add(flds);                                         
                                 }                
                if(leadsToUpdate.size()>0){
                    Update leadsToUpdate;
                }
            }
        }
    }
}