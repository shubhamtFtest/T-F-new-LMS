({
    loadValues : function(component) {
        var action = component.get("c.getDynamicUIValues");        
        var getHubIdAction=component.get("c.getHubID");
        var getImplicitFltrVals=component.get("c.getImplicitFilters");
        
        
        action.setParams({
            "grandParent": '',
            "parent": 'Type',
            "consumer": component.get("v.consumer")
        }); 
        
        getHubIdAction.setParams({
            "bundleID": component.get("v.recordId")
        }); 
        
        getImplicitFltrVals.setParams({
            "consumer": component.get("v.consumer")
        }); 
        
        action.setCallback(this, function(response) {
            console.log('# getvalues callback %f', (performance.now() - startTime));
            var state = response.getState();
            if (state === "SUCCESS"){                
                var result = response.getReturnValue();
                if(result){
                    console.log('result'+JSON.stringify(result));
                    var typeValueLst = [];
                    
                    var valueLst = result.valueLst;
                    for(var val of valueLst){
                        var typeValue = {
                            label: '',
                            value: ''
                        }
                        typeValue.label = val.fieldLabel;
                        typeValue.value = val.fieldValue;
                        typeValueLst.push(typeValue);
                    }
                    component.set("v.optionsType",typeValueLst);
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
                    "message": "There was an issue while processing, please contact SFDC system admin."
                });
                toastEvent.fire();
                component.set("v.IsSpinner",false);
            }
        });   
        getHubIdAction.setCallback(this, function(response) {
            console.log('# getvalues callback %f', (performance.now() - startTime));
            var state = response.getState();
            if (state === "SUCCESS"){                
                var result = response.getReturnValue();
                if(result){
                    console.log('result'+JSON.stringify(result));                   
                    component.set("v.hubId",result);
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
                    "message": "There was an issue while processing, please contact SFDC system admin."
                });
                toastEvent.fire();
                component.set("v.IsSpinner",false);
            }
        });   
        var startTime = performance.now();
        $A.enqueueAction(action);
        $A.enqueueAction(getHubIdAction);
        
        getImplicitFltrVals.setCallback(this, function(response) {
            console.log('# getvalues callback %f', (performance.now() - startTime));
            var state = response.getState();
            if (state === "SUCCESS"){                
                var result = response.getReturnValue();
                if(result){
                    console.log('result_Implicit'+JSON.stringify(result)); 
                    component.set("v.implicitObjLst",result.valueLst);
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
                    "message": "There was an issue while processing, please contact SFDC system admin."
                });
                toastEvent.fire();
                component.set("v.IsSpinner",false);
            }
        });   
        $A.enqueueAction(getImplicitFltrVals);
        component.set("v.IsSpinner",true);     
    }
})