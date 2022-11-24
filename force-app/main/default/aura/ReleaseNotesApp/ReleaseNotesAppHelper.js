({
    
    getCaseDataFunctionHelper : function(component, event) {
        //Setup the call to the apex controller.
        var action = component.get("c.getCaseData");
        var startDateValue = component.get("{!v.startDate}");
        var endDateValue = component.get("{!v.endDate}");
        
        action.setParams({
            "startDateValueInput" : startDateValue,
            "endDateValueInput" : endDateValue
        });
        
        //Set the callback.
        action.setCallback(this, function(response) { 
            var state = response.getState();
            
            if (state === "SUCCESS") {
  
                var dataItems = [] ;
                var results = response.getReturnValue();
                
                results.forEach(function(item) {
                    
                    var data = {
                        releaseNotesRow: item.releaseNotes,
                        departmentValueRow: item.department,
                        releaseDateRow: item.releaseDate,
                        caseNumberRow: item.caseNumber,
                        caseURLRow: '/' + item.caseId
                        
                    };                
                    dataItems.push(data);
                });
                component.set("v.caseData", dataItems);             
                
            }else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
                
            } else if (state === "ERROR") {
                alert(response);
            }
        });
        // enqueue the action
        $A.enqueueAction(action);         
    } 
})