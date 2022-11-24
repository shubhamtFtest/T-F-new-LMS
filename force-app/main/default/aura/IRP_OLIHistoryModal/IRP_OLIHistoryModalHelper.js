({
    getOLIHistory : function(component) {
        var recordID = component.get("v.opportunityLineItemId");
        var action = component.get("c.getOLIHistories");    
        action.setParams({ 
            "oppId":recordID
        });        
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.history", result.products);
            }else if (state == "INCOMPLETE") {
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
    saveFinalUMCHelper: function(component,event){
        var historyRecordId = event.getSource().get("v.value");                     
        var action = component.get("c.updateOpportunityLineItemUMC");
        action.setParams({ 
            "historyId":historyRecordId
        });
        action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                if(result == 'UPDATE_DONE'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({ 
                        'title' : 'Success', 
                        'message' : 'Request has been submitted sucessfully.' ,
                        'type':'success'
                    });                     
                    toastEvent.fire();                    
                    component.set("v.isHistoryModalOpen", false);
                }
            }else if (state == "INCOMPLETE") {   
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "No Internet Connection"
                });
                toastEvent.fire();               
            } else if (state == "ERROR") {
                this.fireFailureToast(component, event, helper);
            }
        });
        $A.enqueueAction(action);        
    },
    deleteOliHistory: function(component,event){
        var historyRecordId = event.getSource().get("v.value");                     
        var action = component.get("c.deleteOlihistory");
        action.setParams({ 
            "historyId":historyRecordId
        });
        action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                if(result == 'UPDATE_DONE'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({ 
                        'title' : 'Success', 
                        'message' : 'Request has been submitted sucessfully.' ,
                        'type':'success'
                    });                     
                    toastEvent.fire();                    
                    component.set("v.isHistoryModalOpen", false);
                }
            }else if (state == "INCOMPLETE") {   
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "No Internet Connection"
                });
                toastEvent.fire();               
            } else if (state == "ERROR") {
                this.fireFailureToast(component, event, helper);
            }
        });
        $A.enqueueAction(action);        
    },
})