({
    calloutController : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        helper.getPartyId(component);
        helper.getResponse(component);
    }
})