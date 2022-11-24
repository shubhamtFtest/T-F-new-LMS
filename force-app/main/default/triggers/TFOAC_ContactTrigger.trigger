trigger TFOAC_ContactTrigger on Contact (before insert) {
	TFOAC_ContactTriggerClass.alignTFAcqusitionContactsToDefaultAccount(Trigger.New);
}