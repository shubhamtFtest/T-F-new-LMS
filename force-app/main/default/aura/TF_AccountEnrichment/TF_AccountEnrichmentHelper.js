({
    getResponse: function(component) {
        // create a server side action.       
        var action = component.get("c.getCalloutResponseContents");
        action.setParams({
            "recordId": component.get("v.recordId"),
            "ringgoldId": component.get("v.ringgoldId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS" && (response.getReturnValue()) != null) {      
                component.set("v.objectList", response.getReturnValue());
                component.set("v.Spinner", false);
                component.set("v.checkRetry", false);
            }
            else{
                component.set("v.Spinner", false); 
                component.set("v.checkRetry", true);
                alert('Error to fetch Ringgold Data. Please try again after some time.');
            }
        });
        $A.enqueueAction(action);
        $A.get('e.force:refreshView').fire();
    },
    getRinggoldId: function(component) {
        // create a server side action.       
        var action = component.get("c.returnRinggoldId");
        action.setParams({
            "accId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS" && response.getReturnValue() != null) {      
                component.set("v.ringgoldId", response.getReturnValue());
            }
            else{
                alert('Ringgold Id not present in account');
                $A.get("e.force:closeQuickAction").fire();      
            }
        });
        
 
        $A.enqueueAction(action);
    },
    
    updateAccountFields: function(component,event) { 
        var saveAction = component.get("c.updateAccFields");
        // set the url parameter for getCalloutResponseContents method (to use as endPoint) 
        saveAction.setParams({
            "dataValueList": JSON.stringify(event.getParam('draftValues')),
            "recordId": component.get("v.recordId"),
            "thisObjectList": JSON.stringify(component.get("v.objectList"))
        });
 		component.set("v.statusOk", true);
        $A.enqueueAction(saveAction);
        $A.get('e.force:refreshView').fire();
    },
})