({
	doHandleOnSave : function(component, event, helper) {
		component.find("editOpportunity").get("e.recordSave").fire();
	}
})