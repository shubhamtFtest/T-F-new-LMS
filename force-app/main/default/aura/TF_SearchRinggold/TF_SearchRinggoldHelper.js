({
	getResponse: function(component) {
        // create a server side action.       
        var action = component.get("c.getSearchRinggoldCalloutResponse");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS" && response.getReturnValue() != null) {      
                component.set("v.objectList", response.getReturnValue());
                component.set("v.Spinner", false); 
            }
            else{
                component.set("v.Spinner", false); 
                component.set("v.objectList", null);
                component.set("v.ringgoldError", true);
            }
        });
        
 
        $A.enqueueAction(action);
    },
    getUIResponse: function(component) {
        // create a server side action.       
        var action = component.get("c.getUISearchRinggoldCalloutResponse");
        action.setParams({
            "name": component.get("v.AccRec.Name"),
            "website": component.get("v.AccRec.Website"),
            "city": component.get("v.AccRec.BillingCity"),
            "state": component.get("v.AccRec.BillingState"),
            "country": component.get("v.AccRec.BillingCountry"),
            "zipCode": component.get("v.AccRec.BillingPostalCode")
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS" && response.getReturnValue() != null) {      
                component.set("v.objectList", response.getReturnValue());
                component.set("v.Spinner", false);
                component.set("v.ringgoldError", false);
            }
            else{
                component.set("v.Spinner", false); 
                component.set("v.objectList", null);
                component.set("v.ringgoldError", true);
                     
            }
        });
        
 
        $A.enqueueAction(action);
    },
    findDupAccount: function(component, event) {
        var saveAction = component.get("c.findDupAccount");
        saveAction.setParams({
            "dataValueList": JSON.stringify(component.get("v.selectedRows"))
        });
        saveAction.setCallback(this, function(response) {
            var state = response.getState();
            var rgid = null;
            if (component.isValid() && state === "SUCCESS" && response.getReturnValue() != null) {      
                component.set("v.showErrors", true);
                component.set("v.errorMsg", response.getReturnValue());
                component.set("v.rgId", rgid);
                
            }else{
                component.set("v.showErrors", false);
            }
        });
 		
        $A.enqueueAction(saveAction);
    },
    getAccountDetails:function(component, event) {
        var accAction = component.get("c.getAccountDetails");
        accAction.setParams({
            "recordId": component.get("v.recordId")
        });
        accAction.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS" && response.getReturnValue() != null) {    
                component.set("v.AccRec", response.getReturnValue());
			}
        });
 		
        $A.enqueueAction(accAction);
    },
    rejectRequest :  function(component, event) {
		var saveAction = component.get("c.updateAccountStatus");
        saveAction.setParams({
            "recordId": component.get("v.recordId")
        });
 
        $A.enqueueAction(saveAction);
        $A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:refreshView').fire();
    },
    thirdPartyRejectRequest : function(component, event) {
		var updateAction = component.get("c.updateThirdPartyAccountRejStatus");
        updateAction.setParams({
            "recordId": component.get("v.recordId"),
            "dataValueList": JSON.stringify(component.get("v.selectedRows"))
        });
 
        $A.enqueueAction(updateAction);
        $A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:refreshView').fire();
    }
})