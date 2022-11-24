({
    doInit : function(component, event, helper) {
        helper.setInit(component,event);
        var today = new Date();
        component.set('v.startDate', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate()); 
        component.set('v.endDate', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
    	helper.getSDCurrPicklistValues(component, event);
    },
    performSearch : function(component, event, helper) {
        helper.searchProduct(component);       
    },     
    handleSubmit : function(component, event, helper) {
        event.preventDefault();       
        helper.createCPQDisConfig(component);
    },
    handleSuccess : function(component, event, helper) {
        var payload = event.getParams().response;
        console.log(payload.id);
    }    
})