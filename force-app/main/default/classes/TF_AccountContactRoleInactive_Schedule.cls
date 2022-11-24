/*
* Created by Jeff Lup - 2016.10.11 - part of JCM project
* Calls: TF_AccountContactRoleInactive_Batch
* Tested by: zTEST_TF_AccountContactRoleInactive
*
* Replaces inefficient workflow: "T&F - Account Contact Role Inactive Rule"
*/
global class TF_AccountContactRoleInactive_Schedule implements Schedulable {
    global boolean sendStatus = false;
    global void execute(SchedulableContext SC) {  
        TF_AccountContactRoleInactive_Batch tfBatch = new TF_AccountContactRoleInactive_Batch();

        tfBatch.isTesting = false;
        tfBatch.queryLimit = 50000;
        
        if (UserInfo.getOrganizationId() != '00D2D0000008adbEA2')
            tfBatch.isTesting = true;
        
        Database.executeBatch(tfBatch);
    }
}