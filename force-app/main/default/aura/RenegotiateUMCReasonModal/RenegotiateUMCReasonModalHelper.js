({
    fireSuccessToast : function(component) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({ 
            'title' : 'Success', 
            'message' : 'Record has updated sucessfully.' ,
            'type':'success'
        }); 
        toastEvent.fire(); 
    },
    fireErrorToast : function(component) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({  
            'message' : 'Please provide your reason to renegotiate UMC.' ,
            'type':'error'
        }); 
        toastEvent.fire(); 
    },    
    fireFailureToast : function(component) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({ 
            'title' : 'Failed', 
            'message' : 'An error occurred. Please contact your administrator.',
            'type':'error'
        }); 
        toastEvent.fire(); 
    },
    
    fireRefreshEvt : function(component) {
        var refreshEvent = $A.get("e.force:refreshView");
        if(refreshEvent){
            refreshEvent.fire();
        }
    },
})