({
	onLoad : function(component, event, helper) {
        debugger;
        component.set("v.mySpinner", true);
		var recId = component.get('v.recordId');
        var action = component.get("c.fetchQuote");
        component.set("v.mySpinner", true); 
        action.setParams({
            "quoteId" : recId,
        });
        action.setCallback(this, function(response) {
            component.set("v.mySpinner", false); 
            var state = response.getState();
            if (state === "SUCCESS") {
                var quoteData = response.getReturnValue();
                if(quoteData.SBQQ__Status__c == 'Ready for Invoice' || quoteData.SBQQ__Status__c == 'Order Failure'){
                    if(quoteData.Order_Hub_Number__c == null){
                        component.set('v.retryDeactivated',false);
                    }
                }
            }
        });
        $A.enqueueAction(action);
	},
    retryButton : function(component, event, helper) {
    	debugger;
        component.set("v.mySpinner", true);
		var recId = component.get('v.recordId');
        var action = component.get("c.quoteOrderCalloutRetry");
        component.set("v.mySpinner", true); 
        action.setParams({
            "quoteId" : recId,
        });
        action.setCallback(this, function(response) {
            component.set("v.mySpinner", false); 
            var state = response.getState();
            if (state === "SUCCESS") {
                var quoteData = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!",
                    message: "Request sent to Order Hub Successfully!",
                    type: "success"
                });
                toastEvent.fire();
                
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                  "recordId": recId,
                });
    			navEvt.fire();
            }
        });
        $A.enqueueAction(action);
	},
	
})