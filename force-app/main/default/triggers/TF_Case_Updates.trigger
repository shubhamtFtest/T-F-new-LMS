/*
* Tested by zTest_TF_Case_Updates @ 100%
* Created by Tom Reed - 2017.09.15 - CHG0036476
*/

trigger TF_Case_Updates on EmailMessage (after insert, After Update) {
    
    
    Map<Id,Id> caseEmailIdMap = new Map<Id,Id>();
    MAP<String,String> EmailPlatformMap = New MAP<String,String>();
    for(Setting_Item__c si : [Select Text_1__c,Text_2__c from Setting_Item__c where Setting__r.Name='TF_Case_Product_Platform_Emails']){
        EmailPlatformMap.put(si.Text_2__c,si.Text_1__c);
        
    }
    for(EmailMessage em : Trigger.new){
    	    //Get the case information if the email message relates to a Case
        if (em.ParentId !=null && String.valueOf(em.ParentId).Left(3) == '500' && EmailPlatformMap.containsKey(em.ToAddress)){
            caseEmailIdMap.put(em.ParentId,em.id);
        }
    }
    if(caseEmailIdMap !=null && caseEmailIdMap.size()>0){
        Map<Id,Case> cases = new Map<Id,Case>();
        List<String> LstRecordTypeIDs = label.T_F_Record_Type_IDs.split(',');
        cases = new Map<Id,Case>([Select id, recordtypeid, Product_Platform__c From Case where id =: caseEmailIdMap.keyset() and RecordTypeid in: LstRecordTypeIDs]);

        //check if we have any record for T&F cases..
        if(cases !=null && cases.size()>0){
            
            
            List<Case> caseToUpdate = new List<Case>();
            
            for(Case c : cases.values()){
                
                if(EmailPlatformMap !=null && EmailPlatformMap.containsKey(Trigger.newMap.get(caseEmailIdMap.get(c.id)).ToAddress)){
                    c.Product_Platform__c = EmailPlatformMap.get(Trigger.newMap.get(caseEmailIdMap.get(c.id)).ToAddress);
                    
                    caseToUpdate.add(c); 
                }
            }
            
            if(caseToUpdate !=null && caseToUpdate.size()>0){
                update caseToUpdate;
            }
        }
        
    }
    
    
}