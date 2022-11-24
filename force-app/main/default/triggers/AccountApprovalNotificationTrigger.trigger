trigger AccountApprovalNotificationTrigger on Account_Approval_Notification__e (after insert) {
  for (Account_Approval_Notification__e event : Trigger.New) {
      System.debug('** New account approval event **');
      System.debug('Request ID : ' + event.Request_ID__c);
      System.debug('Account ID : ' + event.Account_ID__c);
      System.debug('Party ID : ' + event.Party_ID__c);
      System.debug('BP Recored ID : ' + event.BP_Record_ID__c);
      // Update the Account Request log
      Account_Request_Log__c reqLog = [SELECT id, Status__c from Account_Request_Log__c WHERE Request_ID__c = :event.Request_ID__c limit 1];
      reqLog.Account_ID__c  = event.Account_ID__c;
      reqLog.BP_Numbers__c	= event.BP_Record_ID__c;
      reqLog.Party_ID__c	= event.Party_ID__c;
      reqLog.Status__c = 'APPROVED';
      update reqLog;
      System.debug('Log Request has been updated. LogReq ID : ' + reqLog.Id);
      if(!Test.isRunningTest()){
      	//handover the event to Notification hanlder 
      	AccountApprovalNotificationHandler.handleAccountApprovalNotification(event.Request_ID__c, event.Account_ID__c, event.Party_ID__c, event.BP_Record_ID__c);
      	System.debug('** The new Account notification for Party ID :' + event.Party_ID__c + ' has been handover to Notification handler **');
       
      }
   }
}