/**************************************************
* Created by Tom Reed, 2018.05.23
* Tested By zTest_Set_Lead_Previous_Owner_trig @ 100%
* Commented the class as it is no longer needed By: Shefali Arora ( Case No : 01077663 ) on date 2019.10.04
**************************************************/

public class Set_Lead_Previous_Owner_trig implements TriggerInterface_Lead.Runnable {
    public void run(TriggerInterface_Lead.Trig trig) { 
        /*Map<ID, String> leadIdToOldOwnerUserMap = new  Map<ID, String>();
        Map<ID, String> leadIdToOldOwnerQueueMap = new  Map<ID, String>();
        Map<ID, String> leadIdToOldOwnerAllMap = new  Map<ID, String>();
        if (trig.isafter && trig.isUpdate) {
            for(Lead lds: trig.oldList){
                leadIdToOldOwnerAllMap.put(lds.id, lds.Ownerid);
                //If Owner Is A User
                if(String.Valueof(lds.ownerid).startswith('005')){
                    leadIdToOldOwnerUserMap.put(lds.id, lds.Ownerid);
                } else {
                    leadIdToOldOwnerQueueMap.put(lds.id, lds.Ownerid);
                } //If Owner Is A Queue                
            }
            //Get The Names Of The Lead Owner If They Are A User
            Map<ID, String> ownerIdToNameMap = new  Map<ID, String>();  
            for (User u: [SELECT Id, Name 
                          FROM User 
                          WHERE Id in: leadIdToOldOwnerUserMap.Values()]){         
                              ownerIdToNameMap.put(u.id, u.Name);
                          }
            //Get The Name Of The Lead Owner If They Are A Queue
            for (Group u: [SELECT Id, Name 
                           FROM Group 
                           WHERE Id in: leadIdToOldOwnerQueueMap.Values() AND Type = 'Queue']){         
                               ownerIdToNameMap.put(u.id, u.Name);
                           }                
            List<Lead> leadsToUpdate = new List<Lead>();
            for(Lead flds : [SELECT ID, OwnerId
                             FROM Lead 
                             WHERE ID in: leadIdToOldOwnerAllMap.keyset()]){
                                 flds.Previous_Owner__c = ownerIdToNameMap.get(leadIdToOldOwnerAllMap.get(flds.id));
                                 leadsToUpdate.add(flds);                                         
                             }
            if(leadsToUpdate.size()>0){
                Update leadsToUpdate;
            }
        }*/
    }
    public static void runTest() {
       
        
    }
}