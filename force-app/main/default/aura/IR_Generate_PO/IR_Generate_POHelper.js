({
    onInit: function(component, event, helper){		
        let parameters = {
            action: "Printorder:CheckProfileforUk",
            parameters: {
                recordId: component.get("v.recordId") 
            }
        };
        let onSuccess = $A.getCallback(response => { // Custom success callback
            if(response=='Disabled' || response=='AddMessage'){
            component.set("v.isdisabled",true); 
            if(response=='AddMessage'){
           component.set("v.showmessage",true);  
        }
        }else{
            component.set("v.isdisabled",false);  
        
    }
});


let onError = $A.getCallback(errors => { // Custom error callback
});
this._invoke(component, parameters, onSuccess, onError);
},
    GeneratePO: function(component, event, helper){	
        let parameters = {
            action: "Printorder:GeneratePO",
            parameters: {
                recordId: component.get("v.recordId") 
            }
        };
        component.set("v.spinner",true); 
        let onSuccess = $A.getCallback(response => { // Custom success callback
            component.set("v.spinner",false); 
            location.reload();
            
        });
            
            
            let onError = $A.getCallback(errors => { // Custom error callback
        });
            this._invoke(component, parameters, onSuccess, onError);
        }, _invoke: function(component, parameters, onSuccessCallback, onErrorCallback) {
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
        }
        })