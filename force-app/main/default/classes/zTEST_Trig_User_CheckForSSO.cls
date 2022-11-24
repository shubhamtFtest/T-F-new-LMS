/*
*	Tests: Trig_User_CheckForSSO.cls	100%
*/
@isTest
private class zTEST_Trig_User_CheckForSSO {

    static testMethod void test_Trig_User_CheckForSSO() {
    	TriggerInterfaceHelper.runTrigger('Trig_User_CheckForSSO', 'User', 1, 'bi,bu,ai,au',  null, null);
    	//***** Reason required *****
    	try {
	    	User u1 = zTEST_Shared.insertUser(); //uses System Administartor, which is not SSO
    	} catch(Exception e) {
    	}
    	//***** Add Permission Set *****
		User u2 = zTEST_Shared.noinsertUser(); //uses System Administartor, which is not SSO
		u2.Reason_Not_SSO_Enabled__c = 'SSO Enabled by Permission Set';
    	insert u2;
    	//***** Permission Set Already Added*****
    	update u2;
    }
}