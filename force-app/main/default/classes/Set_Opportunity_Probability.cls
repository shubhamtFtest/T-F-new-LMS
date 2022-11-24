/************************************************************************
* 
*   Created by: Tom Reed - 2018-09-26
*   Test Class: tbc
*
*************************************************************************/
public class Set_Opportunity_Probability implements TriggerInterface_Opp.Runnable {
    
    public static void run(TriggerInterface_Opp.Trig trig){
        
        List<Opportunity> oppsToRun = new List<Opportunity>();
        for(Opportunity o : trig.newList){               
            if(trig.isInsert || (trig.isUpdate && (o.StageName != trig.oldmap.get(o.Id).StageName || o.RecordTypeId != trig.oldmap.get(o.Id).RecordTypeId))){   
                oppsToRun.add(o);
            }               
        }
        if(oppsToRun.size() > 0){
            Setting__c stageMappingsSetting = [SELECT Id FROM Setting__c WHERE Name = 'StageProbabilityMapping'];
            
            Map<String, Setting_Item__c> stageToProbMapping = new Map<String, Setting_Item__c>();
            for(Setting_Item__c s:[SELECT Text_1__c //Record Type Id.
                                   , Text_2__c //Stage Name.
                                   , Text_3__c //Probability.
                                   FROM Setting_Item__c 
                                   Where Setting__c =: stageMappingsSetting.Id]){
                                       stageToProbMapping.put(s.Text_2__c+s.Text_1__c, s);   
                                   }               
            for (Opportunity o : oppsToRun) {
                if(stageToProbMapping.containsKey(o.StageName+o.RecordTypeId)){
                    o.Probability = Decimal.ValueOf(stageToProbMapping.get(o.StageName+o.RecordTypeId).Text_3__c);
                }
            }                   
        }
    }
}