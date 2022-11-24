({
    
    init: function (component, event,helper) {
        helper.fetchNetBaseClassificationForProduct(component, event, helper);
    },
    saveNetBase : function(component, event, helper) {
        helper.updateNetBaseClassificationForProduct(component, event, helper);
    },
    
    fetchNetBase : function(component, event, helper) {
        helper.fetchNetBaseClassificationForProduct(component, event, helper);
    }
})