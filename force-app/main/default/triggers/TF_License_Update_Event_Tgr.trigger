/**********************************************************************************
    //Trigger with handler class "TF_License_Update_Event_Tgr_Cls" is to send dynamic
    license update request to Entitlement hub for every product hub Id matches with
    license product's hub Id
    //Created by Vikas Varshney on dated 15-01-2019
    //Deactivated by Vikas Varshney on dated 11th Dec, 2020
**********************************************************************************/

trigger TF_License_Update_Event_Tgr on License_Update_Event__e ( after insert ) {
    System.debug('License Update Event Trigger ========>');
    //Calling class "TF_License_Update_Event_Tgr_Cls" and passing event list in method to create licence records in Salesforce
    TF_License_Update_Event_Tgr_Cls.updateDynamicRequest( Trigger.New );
}