({
    checkprofile: function(component,row,sortField){
        let parameters = {
            action: "Printorder:CheckProfileforUk",
            parameters: {
                recordId: component.get("v.recordId") 
            }
        };
        let onSuccess = $A.getCallback(response => { // Custom success callback
            if(response==true){
            component.set("v.isdisabled",false);  
        }else{
                                       component.set("v.isdisabled",true);  
    }
});


let onError = $A.getCallback(errors => { // Custom error callback
});
this._invoke(component, parameters, onSuccess, onError);
},
    fetchRecords: function(component,row,sortField) { 
        let parameters = {
            action: "Printorder:SendEmailToUK",
            parameters: {
                recordId: component.get("v.recordId") 
            }
        };
        
        let onSuccess = $A.getCallback(response => { // Custom success callback
            console.log('Success');
            component.set("v.spinner",false);  
            window.location.reload();
            console.log('response'+response);
        });
            
            
            let onError = $A.getCallback(errors => { // Custom error callback
        });
            this._invoke(component, parameters, onSuccess, onError);
        },
            _invoke: function(component, parameters, onSuccessCallback, onErrorCallback) {
                const server = component.find('server');
                const serversideAction = component.get("c.invoke");
                if (server) {
                    server.invoke(
                        serversideAction, // Server-side action
                        parameters, // Action parameters
                        false, // Disable cache if false
                        onSuccessCallback,
                        onErrorCallback,
                        true //enable error notifications
                    );
                }
            },
            
            
            
        })