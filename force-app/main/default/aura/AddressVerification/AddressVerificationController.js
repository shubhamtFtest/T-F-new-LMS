({
    verifyAddress: function(component, event, recordId, helper) { 
            var action = component.get('c.getaccountIdLightning');
            component.set("v.Spinner",true);
            action.setParams({"recordId": component.get('v.recordId')});
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS" && response.getReturnValue() == null){ 
                    component.set("v.Spinner",false); 
                    component.set("v.statusOk",true);
                }
                else if(response.getReturnValue() != null){
                    	component.set("v.Spinner",false); 
                        component.set("v.statusFail",true);
                    	component.set("v.statusFailError", response.getReturnValue());
                    	
                } 
                
            });
            
            $A.enqueueAction(action);
        	$A.get('e.force:refreshView').fire();
        
    },
})