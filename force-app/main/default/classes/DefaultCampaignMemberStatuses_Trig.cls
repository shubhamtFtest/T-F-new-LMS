/*
Created by		:Syam Nukilla
Created Date	:2020.02.27
Description		: After insertion on Campaign create CampaignMemberStatus sorting out records from CustomMetaData 'Default Campaign Member Status' based on Campaign record types.
Test Class		:Test_DefaultCampaignMemberStatuses_Trig
*/

public without sharing class DefaultCampaignMemberStatuses_Trig implements TriggerInterface_Campaign.Runnable {
    public void run(TriggerInterface_Campaign.Trig trig) {
        if (trig.isAfter && trig.isInsert) {
            Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Campaign.getRecordTypeInfosById(); //for fetching Recordtype name from Campaign RecordtypeId
            List<Default_Campaign_Member_Status__mdt> cmdtList = [SELECT Record_Type__c,Is_Default__c,Label,Responded__c 
                                                                  FROM Default_Campaign_Member_Status__mdt]; // getting all the records from CustomMetaData
            Map<String,List<Default_Campaign_Member_Status__mdt>> cmdtRecTypeNameToListMap= new Map<String,List<Default_Campaign_Member_Status__mdt>>();  
            List<CampaignMemberStatus> cmpStatusListToInsert = new List<CampaignMemberStatus>(); 
            // creating a map, key as recordtype name and values as its respective list of CustomMetaData records.
            for(Default_Campaign_Member_Status__mdt cmd:cmdtList){
                if(!cmdtRecTypeNameToListMap.containsKey(cmd.Record_Type__c)){
                    cmdtRecTypeNameToListMap.put(cmd.Record_Type__c,new List<Default_Campaign_Member_Status__mdt>{cmd});
                }else{
                    cmdtRecTypeNameToListMap.get(cmd.Record_Type__c).add(cmd);
                }
            }
            for(Campaign cmpgnObj:trig.newList){
                String recTypName = rtMap.get(cmpgnObj.RecordTypeId).getName();
                List<Default_Campaign_Member_Status__mdt> sortedDcmsList = cmdtRecTypeNameToListMap.get(recTypName); //fetching campaign recordtype related CustomMetaData records into list
                if(sortedDcmsList!=Null){
                    for(Default_Campaign_Member_Status__mdt dcms:sortedDcmsList){
                        CampaignMemberStatus cmpMemStatusObj = new CampaignMemberStatus();
                        cmpMemStatusObj.CampaignId = cmpgnObj.Id;
                        cmpMemStatusObj.Label = dcms.Label;
                        cmpMemStatusObj.IsDefault = dcms.Is_Default__c;
                        cmpMemStatusObj.HasResponded = dcms.Responded__c;
                        cmpStatusListToInsert.add(cmpMemStatusObj);
                    }
                }
            } // end of for loop
            //inserting CampaignMemberStatus records
            if(!cmpStatusListToInsert.isEmpty()){
                try{
                    insert cmpStatusListToInsert;
                }catch(Exception e){
                    System.debug(e);
                }
            }
        } // end of after insert loop
    } // end of run method loop

}