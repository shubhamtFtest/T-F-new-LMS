({   
    CreatePriceBookEntry: function(component, event, helper) {          
        var action = component.get("c.runPriceBookEntryBatch");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var retVal = response.getReturnValue();
                $A.get("e.force:closeQuickAction").fire();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "",
                    "message": "The operation is under process. Please check after some time."
                });
                toastEvent.fire();                 
               $A.get('e.force:refreshView').fire();                
            } else if (state == "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "No Internet Connection"
                });
                toastEvent.fire();
            } else if (state == "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please contact your administrator"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
})