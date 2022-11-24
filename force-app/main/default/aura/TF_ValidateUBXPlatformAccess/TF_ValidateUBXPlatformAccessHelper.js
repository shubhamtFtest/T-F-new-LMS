({
	getResponse: function(component) {
        // create a server side action.       
        var action = component.get("c.getCalloutResponseContents");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS" && (response.getReturnValue()) != null) {      
               
                component.set("v.objectList", response.getReturnValue());
                component.set("v.Spinner", false);
                component.set("v.showErrors", false);
                component.set("v.noErrors", true);
            }
            else{
                component.set("v.noErrors", false);
                component.set("v.Spinner", false); 
                component.set("v.showErrors", true);
            }
        });
        
 
        $A.enqueueAction(action);
    },
    getPartyId: function(component) {
        // create a server side action.
        var thisAction = component.get("c.returnPartyId");
        thisAction.setParams({
            "accId": component.get("v.recordId")
        });
        thisAction.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS" && response.getReturnValue() != null) {      
                component.set("v.partyId", response.getReturnValue());
            }
            else{
                alert('PartyId not present in Account. Action cannot be performed.');
                $A.get("e.force:closeQuickAction").fire();      
            }
        });
        
 
        $A.enqueueAction(thisAction);
    }
})