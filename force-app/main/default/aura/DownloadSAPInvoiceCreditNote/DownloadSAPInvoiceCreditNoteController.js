({
	doInit : function(cmp, event, helper) {
		 // in the server-side controller
        var action = cmp.get("c.downloadPDF");
        action.setParams({ orderId : cmp.get("v.recordId") });

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server  status 
                console.log("From server: " +JSON.stringify( response.getReturnValue()));
                cmp.set("v.fetchedResponse",response.getReturnValue());
                console.log('fetchedResponse-'+cmp.get("v.fetchedResponse") );
                var resp = cmp.get("v.fetchedResponse"); 
                if(resp){
                    helper.showToast(  resp.message ,resp.status );                	
                }
                            
            }
            else if (state === "INCOMPLETE") {
   				helper.showToast(  'Something went wrong. Please try again later' ,'error' );

            }
            else if (state === "ERROR") {
                helper.showToast(  'Something went wrong. Please try again later' ,'error' );
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0]) {
                        console.log("Error message: " + 
                                 errors[0]);
                        
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
            $A.get('e.force:closeQuickAction').fire();  
        });

        $A.enqueueAction(action);
    }
})