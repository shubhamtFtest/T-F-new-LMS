/*
* Created by Jeff Lup - 2016.10.11 - part of JCM project
* Calls: TF_UpdateImplicitEmailOptOut_Batch
* Tested by: zTEST_TF_UpdateImplicitEmailOptOut
*
* Replaces inefficient workflow: "T&F - Update Implicit Email Opt Out to TRUE"
*/
global class TF_UpdateImplicitEmailOptOut_Schedule implements Schedulable {
    global boolean sendStatus = false;
    global void execute(SchedulableContext SC) {  
        TF_UpdateImplicitEmailOptOut_Batch tfBatch = new TF_UpdateImplicitEmailOptOut_Batch();

        tfBatch.isTesting = false;
        tfBatch.queryLimit = 5000;
        
        if (UserInfo.getOrganizationId() != '00D3B000000DaMBEA2')
            tfBatch.isTesting = true;
        
        Database.executeBatch(tfBatch);
    }
}