({
    handleClick : function(component, event, helper) {
        var searchText = component.get('v.searchText');
        console.log('searchText'+searchText)
        component.set("v.spinner", true); 
        
        var action = component.get('c.searchForIds');
        action.setParams({searchText: searchText});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                component.set("v.spinner", false); 
                var ids = response.getReturnValue();
                component.set("v.recordIds" , ids);
                console.log(ids);
            }else{
                component.set("v.spinner", false); 
            }
        });
        
        $A.enqueueAction(action);
    },
    // function automatic called by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.spinner", true); 
    },
    
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
    },
    selectRecord : function(component,event,helper){
        var indexvar = event.currentTarget.dataset.id;
        console.log("indexvar:::" + indexvar);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "print-order-record?recordId="+indexvar
        });
        urlEvent.fire();
    }
    
})