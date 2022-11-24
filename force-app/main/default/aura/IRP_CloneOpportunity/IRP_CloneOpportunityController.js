({
    doInit : function(component, event, helper) {
        var opportunityId = component.get("v.recordId");       
    }, 
    handleConfirmDialogYes : function(component, event, helper) {
        component.set("v.showLoadingSpinner", true);
        var opportunityId = component.get("v.recordId");
        var action = component.get("c.cloneOpportunity"); 
        action.setParams({"OpptyId" : opportunityId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                                              
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Success!",
                    "type": "success",
                    "message": "Opportunity clone has successfully done."
                });
                resultsToast.fire();                    
                component.set("v.showLoadingSpinner", false);
                $A.get("e.force:closeQuickAction").fire();
            }
        }); 
        $A.enqueueAction(action);        
    },
    handleConfirmDialogNo : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },    
})