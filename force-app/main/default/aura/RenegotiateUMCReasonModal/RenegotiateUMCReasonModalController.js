({
    doInit : function(component, event, helper) { 
       console.log('@@@@@RenegotiateUMCReasonModal@@@@@');
    },    
    closeRenegotiateUMCReasonModel: function(component, event, helper) { 
        component.set("v.isRenegotiateUMCReasonModalOpen", false);
    },
    submitRenegotiateUMCReason: function(component, event, helper) {
        var oppId = component.get("v.opportunityId");
		var listOfSelectedOlis = component.get("v.umcRenegotiateIdList");
		var commentVal = component.find('comment').get('v.value');
        if(commentVal == '' || commentVal == null ||commentVal == undefined) {
           helper.fireErrorToast(component);
           return false;
        }         
        var action = component.get("c.renegotiateUMCAction");
        action.setParams({ 
            				"lstId" : listOfSelectedOlis,
            				"opportunityId" : oppId,
            				"UMCRenegotiateReason" : commentVal
        				}); 
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue(); 
                //sconsole.log(ret);
                if(ret == 'Record has been updated successfully.') {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({ 
                        'title' : 'Success', 
                        'message' : 'Request has been submitted sucessfully.' ,
                        'type':'success'
                    });
                    location.reload();
                    toastEvent.fire(); 					                   
                }
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
                    "message": "There was an issue while processing, please contact SFDC system admin."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
})