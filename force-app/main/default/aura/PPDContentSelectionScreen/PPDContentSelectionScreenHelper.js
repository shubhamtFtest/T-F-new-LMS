({
	//check if collection is original or cloned 
	checkForClonedProduct: function (component, event, helper) { 
        var recordID = component.get("v.recordId");
        var action = component.get("c.checkIfProductIsCloned");    
        action.setParams({
            "bundleID": recordID
        }); 
        
        action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();  
                if (result=='cloned') {               
                    component.set("v.IsClonedRecord",true);
                }
                else if (result=='original'){                
                    component.set("v.IsClonedRecord",false);
                       
                    var action = component.get("c.checkIfBusinessIdExist");
                    
                    var actionCollName = component.get("c.checkCollectionNameExist");
                    
                    action.setParams({
                        "bundleID":recordID,
                        "businessIdToValidate":component.get("v.busId"),
                        "calledFrom":'event'
                    });
                    
                    actionCollName.setParams({
                        "bundleId": recordID,
                        "collectionName":component.get("v.collectionName"),
                        "calledFrom":'event'
                    });
                    
                    
                    action.setCallback(this, function(response) {  
                        var state = response.getState();
                        if (state === "SUCCESS"){
                            var result = response.getReturnValue();  
                             if(result==202 || result==200){
                                component.set('v.IsBusinessIdExist','true');
                            }
                            else if(result==404){
                                component.set('v.IsBusinessIdExist','false')
                            }
                            //===
                        //	component.set('v.IsBusinessIdExist','true')
            //===
                            component.set("v.IsSpinner",false); 
                            var evt = $A.get("e.c:PPDBusinessIdCheckEvent");
                            evt.setParam("IsBusinessIdExist",component.get('v.IsBusinessIdExist'));
                            evt.fire(); 
                            
                            
                            }else if (state == "INCOMPLETE") {
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Oops!",
                                "message": "No Internet Connection"
                            });
                            toastEvent.fire();
                            component.set("v.IsSpinner",false); 
                            
                        } else if (state == "ERROR") {
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": "Some error has occurred,Please contact your administrator!"
                            });
                            toastEvent.fire();
                            component.set("v.IsSpinner",false); 
                        }
                                  
                    });
                    
                    actionCollName.setCallback(this, function(response) {  
                        var state = response.getState();
                        console.log('state123: ' + state + '  **  ' + response.getReturnValue());
                        if (state === "SUCCESS"){
                            var result = response.getReturnValue(); 
                            
                             if(result==202 || result==200){
                                component.set('v.IsCollectionNameExist','true');
                            }
                            else if(result==404){
                                component.set('v.IsCollectionNameExist','false')
                            }
                            console.log('collNameExist: ' + result + component.get('v.IsCollectionNameExist'));
                            component.set("v.IsSpinner",false); 
                            var evt = $A.get("e.c:PPDBusinessIdCheckEvent");
                            evt.setParam("IsCollectionNameExist",component.get('v.IsCollectionNameExist'));
                            evt.fire(); 
                            
                            
                            }else if (state == "INCOMPLETE") {
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Oops!",
                                "message": "No Internet Connection"
                            });
                            toastEvent.fire();
                            component.set("v.IsSpinner",false); 
                            
                        } else if (state == "ERROR") {
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": "Some error has occurred,Please contact your administrator!"
                            });
                            toastEvent.fire();
                            component.set("v.IsSpinner",false); 
                        }
                                  
                    });
                    
                    $A.enqueueAction(action);
                    $A.enqueueAction(actionCollName);
       // component.set("v.IsSpinner",true); 
                }
                
                
            }else if (state == "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "No Internet Connection"
                });
                toastEvent.fire();
                component.set("v.IsSpinner",false); 
                
            } else if (state == "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Some error has occurred,Please contact your administrator!"
                });
                toastEvent.fire();
                component.set("v.IsSpinner",false); 
            }   
            
        });
        var startTime = performance.now();
        $A.enqueueAction(action);  
       // component.set("v.IsSpinner",true); 
        
    },
    
    //save validated business ID
    saveBusinessIdwithPrefix:function(component, event, helper){
        var recordID = component.get("v.recordId"); 
        var businessIdToValidate='';
        if(component.get("v.businessIdToValidate")!=undefined){
              businessIdToValidate=component.get("v.businessIdToValidate");
        }
        else {
            businessIdToValidate=null;
        }
     
      var isBusinessIdValid= component.get("v.IsBusinessIdValidatedFromPCM");
        var action = component.get("c.saveBusinessIdwithPrefix"); 
        action.setParams({
            "bundleID":recordID
        });
        action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();  
                 
                 }else if (state == "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "No Internet Connection"
                });
                toastEvent.fire();
                
            } else if (state == "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Some error has occurred,Please contact your administrator!"
                });
                toastEvent.fire();
            }
                      
        });
        $A.enqueueAction(action);
    }
   
	
})