({
    fireSuccessToast : function(component) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({ 
            'title' : 'Success', 
            'message' : 'The request has sucessfully approved.' ,
            'type':'success'
        }); 
        toastEvent.fire(); 
    },
    fireErrorToast : function(component) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({ 
            'message' : 'Approval comment is mandatory filed.' ,
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