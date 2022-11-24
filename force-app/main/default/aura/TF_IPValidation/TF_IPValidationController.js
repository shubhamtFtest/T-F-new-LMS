({
	getData : function(component, event, helper) {
		//helper.getAccountIPs(component);
		component.set("v.Spinner", true);
        component.set("v.validateClicked", true);
		helper.getResponse(component);
        
	},
    
    rejectRequest :  function(component, event, helper) {
    	helper.thirdPartyRejectRequest(component, event);
    }
})