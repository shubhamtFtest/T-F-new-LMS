/**************************************************
*	Author:		William Cobbett
*	Date:		10/09/2010 (UK date)
**************************************************/

trigger UserMgrSync on User (before insert, before update) {
	   
    /* 
    Keep the fields in sync on update (UI only) 
    */
    if (Trigger.new.size() == 1) {	
    	
    	if (Trigger.isInsert) {
    		
    		//Custom field populated, standard not
    		if (Trigger.new[0].Manager__c != null && Trigger.new[0].ManagerId == null) {
    			Trigger.new[0].ManagerId = Trigger.new[0].Manager__c;
    		}
    		//Standard field populated, custom not
    		if (Trigger.new[0].ManagerId != null && Trigger.new[0].Manager__c == null) {
    			Trigger.new[0].Manager__c = Trigger.new[0].ManagerId;
    		}
    	}
    	
    	if (Trigger.isUpdate) {
							
			//Custom field has been modified and standard has not
			if ((Trigger.new[0].Manager__c != Trigger.old[0].Manager__c) && (Trigger.new[0].ManagerId == Trigger.old[0].ManagerId)) {
				Trigger.new[0].ManagerId = Trigger.new[0].Manager__c;
			}
			//Standard field has been modified and custom has not
			if ((Trigger.new[0].ManagerId != Trigger.old[0].ManagerId) && (Trigger.new[0].Manager__c == Trigger.old[0].Manager__c)) {
				Trigger.new[0].Manager__c = Trigger.new[0].ManagerId;
			}
    	
    	}

	}
	
}