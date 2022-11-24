({
    onInit : function(component, event, helper) {
        helper.checkprofile(component,'');
        
    }, Sendemail: function (component, event, helper) {
        component.set("v.spinner",true);  
        helper.fetchRecords(component,'');
    }
})