({
	getAccountDetails:function(component, event) {
        var accAction = component.get("c.getAccountDetails");
        accAction.setParams({
            "recordId": component.get("v.recordId")
        });
        accAction.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS" && response.getReturnValue() != null) {    
                component.set("v.AccRec", response.getReturnValue());
			}
        });
 		component.set("v.Spinner", false);
        $A.enqueueAction(accAction);
    }
})