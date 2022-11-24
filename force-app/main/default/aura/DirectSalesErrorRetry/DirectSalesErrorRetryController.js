({
    doInit: function(component, event, helper) {
        //document.querySelector(".modal-body").classList.add('arun');
    },
     closePopUp: function(component, event, helper) {
       //alert('ergfdg');
        // Close the action panel
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
         
    }
    
})