({
    loadValues : function(component) {
        var action = component.get("c.getPrdsFromPCM_DynamicUI");
        var queryObjLst = component.get('v.queryObjectUnitLst');
        
        action.setParams({
            "bundleId": component.get('v.recordId'),
            "queryObj": JSON.stringify(queryObjLst)
        }); 
        
        action.setCallback(this, function(response) {
            console.log('# getvalues callback %f', (performance.now() - startTime));
            var state = response.getState();
            if (state === "SUCCESS"){                
                var result = response.getReturnValue();
                if(result){
                    console.log('result'+JSON.stringify(result));
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
                    "message": "There was an issue while processing, please contact SFDC system admin."
                });
                toastEvent.fire();
            }
        });        
        var startTime = performance.now();
        $A.enqueueAction(action);
        
    }
})