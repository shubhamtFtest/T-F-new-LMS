({
    addVoting: function(component, event, helper) {     
        //Call the apex method.
        var action = component.get("c.addVoting");
        //Get the vote value submitted through the UI.
        var voteValue = component.get("{!v.voteOutcome}");
        action.setParams({
            'articleId' : component.get("{!v.parentId}"),
            'vote' : voteValue
        });
        
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
            }
            else if (state === "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Sorry!",
                    message: "It has not been possible to process your request at this time, please try again later.",
                    type: "Error"
                });
                toastEvent.fire();
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                            toastEvent.setParams({
                                title: "Sorry!",
                                message: "It has not been possible to process your request at this time, please try again later.",
                                type: "Error"
                            });
                            toastEvent.fire()                       
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);               
    }
})