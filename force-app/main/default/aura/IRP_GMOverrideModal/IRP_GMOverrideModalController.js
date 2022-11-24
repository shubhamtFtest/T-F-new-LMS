({   
    closeGMOverrideModel: function(component, event, helper) { 
        component.set("v.isGMOverrideModalOpen", false);
    },
    approveGrossMargin: function(component, event, helper) {
        var oliId = component.get("v.opportunityLineItemId");
        var commentVal = component.find('comment').get('v.value');
        if(commentVal=='' || commentVal==null ||commentVal==undefined) {
           helper.fireErrorToast(component);
           return false;
        }        
        var action = component.get("c.saveGrossMarginApproval");
        action.setParams({ "oliId":oliId, "comment" : commentVal });       
        action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if(result == 'RECORD_UPDATED'){
                  component.set("v.isGMOverrideModalOpen", false);
                  helper.fireSuccessToast(component);
                  parent.location.reload();  
                }else{
                    helper.fireErrorToast(component);
                }                
                helper.fireRefreshEvt(component);
            } else if (state === "ERROR") {
                var errors = response.getError();
                helper.fireFailureToast(component);  
            }            
        });
        $A.enqueueAction(action);
    },    
})