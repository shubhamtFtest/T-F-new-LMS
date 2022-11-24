({
	checkIfPriceEntryExist: function (component, event, helper) { 
        var parentProductID = component.get("v.recordId");
        var action = component.get("c.checkIfPriceBookEntryExist");    
        action.setParams({
            "bundleID": parentProductID            
        }); 
        
        action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS"){
               
                var result = response.getReturnValue();
                var status=result;
                 
                     if(status=='False'){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Price required!",
                            "message": "Please make the base price entry for this collection!",
                            "type": 'warning'
                        });
                        toastEvent.fire(); 
                         // component.set("v.selectedStep", "step3");
                        return;
                        
                    }
                else if(status=='True'){
                    //component.set("v.selectedStep", "step1");
                   /*  var navigateEvent = $A.get("e.force:navigateToComponent");
                    navigateEvent.setParams({
                        componentDef: "c:PPDProcessTabWizard",
                        componentAttributes: {
                            recordId : component.get("v.recordId"),
                            IsRecordLocked :component.get("v.IsRecordLocked"),
                            mainTabId:"Titles",
                            isFromFinishButton: "True"
                            
                        }
                    });
                    navigateEvent.fire();*/
                     var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Thank You!",
                            "message": "Please go to preview tab and validate!"
                        });
                        toastEvent.fire(); 
                    }
                      
                          
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
        var startTime = performance.now();
        $A.enqueueAction(action);   
        
    },
    
    checkIfValidityDatesExist: function (component, event, helper) { 
        var parentProductID = component.get("v.recordId");
        var action = component.get("c.checkIfValidityDatesExist");    
        action.setParams({
            "bundleID": parentProductID            
        }); 
        
        action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                var status=result;
                 
                     if(status=='False'){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Validity dates required!",
                            "message": "Please enter validity dates for this collection!",
                            "type": 'warning'
                        });
                        toastEvent.fire(); 
                         //component.set("v.selectedStep", "step3");
                        return;
                         
                    }
                else if(status=='True'){
                     //component.set("v.selectedStep", "step1");
                    /*var navigateEvent = $A.get("e.force:navigateToComponent");
                    navigateEvent.setParams({
                        componentDef: "c:PPDProcessTabWizard",
                        componentAttributes: {
                            recordId : component.get("v.recordId"),
                            IsRecordLocked :component.get("v.IsRecordLocked"),
                            mainTabId:"Titles",
                            isFromFinishButton: "True"
                        }
                    });
                    navigateEvent.fire();*/
                    var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Thank You!",
                            "message": "Please go to preview tab and validate!"
                        });
                        toastEvent.fire(); 
                }
                      
                          
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
        var startTime = performance.now();
        $A.enqueueAction(action);   
        
    },
})