({
	onLoad : function(component, event, helper) {
		helper.orderDetails(component, event, helper);
	},
    
    closeAction: function(component, event, helper) {
        // Close the action panel
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    
    cancelSelectedOrderRetry: function(component, event, helper) {
        helper.cancelSelectedOrderRetryHelper(component, event, helper);
    },
})