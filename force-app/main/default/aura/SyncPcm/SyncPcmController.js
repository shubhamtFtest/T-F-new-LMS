({
    updateProduct: function(component, event, helper) { 
        var recordId =component.get("v.recordId");
        var action = component.get("c.updateProd");
        action.setParams({
            recordId : recordId
        })
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                component.set("v.showBottonContent",false);
                component.set("v.showMsg",true);
            } else if (state == "INCOMPLETE") {
                component.set("v.showError",true);  
            } else if (state == "ERROR") {
               component.set("v.showError",true); 
            }
        });
        $A.enqueueAction(action);
    },
    
    closePopup: function(component, event, helper) { 
    $A.get("e.force:closeQuickAction").fire()
    }
})