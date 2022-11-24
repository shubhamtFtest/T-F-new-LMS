({
    doInit: function (cmp, event, helper) {

        var action = cmp.get("c.showMessg");
        action.setParams({
            recordId: cmp.get("v.recordId"),
            sObjectName: cmp.get("v.sObjectName")

        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('response-' + response.getReturnValue());
                cmp.set("v.show", response.getReturnValue());
            } else if (state === "INCOMPLETE") {

            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });


        $A.enqueueAction(action);
    }
})