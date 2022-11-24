/*
* Created by Jeff Lup - 2016.10.11 - part of JCM project
* Calls: TF_SubjectInterestRoleInactive_Batch
* Tested by: zTEST_TF_SubjectInterestRoleInactive
*
* Replaces inefficient workflow: "T&F - Subject Interest Role Inactive Rule"
*/
global class TF_SubjectInterestRoleInactive_Schedule implements Schedulable {
    global boolean sendStatus = false;
    global void execute(SchedulableContext SC) {  
        TF_SubjectInterestRoleInactive_Batch tfBatch = new TF_SubjectInterestRoleInactive_Batch();

        tfBatch.isTesting = false;
        tfBatch.queryLimit = 50000;
        
        if (UserInfo.getOrganizationId() != '00D3B000000DaMBEA2')
            tfBatch.isTesting = true;
        
        Database.executeBatch(tfBatch);
    }
}