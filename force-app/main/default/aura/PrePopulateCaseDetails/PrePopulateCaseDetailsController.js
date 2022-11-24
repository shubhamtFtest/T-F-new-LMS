({   
    fetchMyCaseDetails: function(component, event, helper) {
        var action = component.get("c.fetchCaseDetails");
        action.setParams({
            "caseId": component.get("{!v.recordId}") 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var caseRecord = response.getReturnValue();
                //console.log(caseRecord);
                var createRecordEvent = $A.get("e.force:createRecord");
                if(caseRecord != null ){	          
                    createRecordEvent.setParams({
                        "entityApiName": "Contact",
                        "recordTypeId" : caseRecord.recordTypeId,
                        "defaultFieldValues": {
                            'AccountId' : caseRecord.AccountId, 
                            'LastName' : caseRecord.SuppliedName,
                            'Email' : caseRecord.SuppliedEmail, 
                            'Phone' : caseRecord.SuppliedPhone,
                        }
                    });
                    createRecordEvent.fire();
                }else{
                    createRecordEvent.setParams({
                        "entityApiName": "Contact",
                        "recordTypeId" : caseRecord.recordTypeId,
                        "defaultFieldValues": {
                            'AccountId' : caseRecord.AccountId, 
                            
                        }
                    });
                    createRecordEvent.fire();   
                }
                //  $A.get("e.force:closeQuickAction").fire();
            } else if (state == "INCOMPLETE") {
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
                    "message": "Please contact your administrator"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
})