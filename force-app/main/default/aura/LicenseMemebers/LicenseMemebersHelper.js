({
	updateConsortiumMemebersHelper : function(component,event,selectedOptionsList) {
		var action = component.get("c.updateConsortiumMemebers");
        action.setParams({
            "licenseID": component.get("v.recordId"),
            'selectedMembers':selectedOptionsList
        }); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state == 'SUCCESS') {
                var str = response.getReturnValue()[1];
                var newSelectedList = response.getReturnValue()[2];
                if ( str != null ) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error Message',
                        message:str[0],
                        duration:'10000',
                        type: 'Error'
                    });
                    toastEvent.fire();
                }
                if ( newSelectedList != null ) {
                    component.set("v.defaultOptions", newSelectedList);
                }
            }
            else if(state == "ERROR"){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                        console.log('Failed with state: ' + state);
                    }
                }
            } else {
                console.log('Failed with state: ' + state);
            }
        });
        $A.enqueueAction(action); 
	}
})