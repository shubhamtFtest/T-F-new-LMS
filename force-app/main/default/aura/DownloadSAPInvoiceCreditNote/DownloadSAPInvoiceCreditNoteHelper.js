({        
    showToast : function( mssg , type) {
        console.log(' w');
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({           
            "message": mssg,
            "type" : type
        });
        toastEvent.fire();
        
        window.setTimeout(
            $A.getCallback(function() {
                if(mssg.includes('The SAP invoice has been downloaded in file section')){
                    window.location.reload();
                }
               
            }), 4000
        );
        
    }
})