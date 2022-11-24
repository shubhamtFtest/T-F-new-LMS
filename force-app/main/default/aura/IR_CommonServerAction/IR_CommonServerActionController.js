/**
 - Created by Sidhant on 9/20/19.
 */
({
    invoke : function(component, event, helper) {
        const params = event.getParam('arguments');
        const invokeAction = params.action;

        // Pass action parameters if applicable
        if (params.parameters) {
            invokeAction.setParams({action:params.parameters.action,parameters:JSON.stringify(params.parameters.parameters)});
        }

        invokeAction.setCallback(this, function(response) {
            let state = response.getState();
            switch (state) {
                case "SUCCESS": {
                    if (params.onSuccess) {
                        let returnValue = response.getReturnValue();
                        params.onSuccess(returnValue);
                    }

                    break;
                }
                case "ERROR": {
                    const errors = response.getError();

                    if (params.enableErrorNotifications) {
                        helper.handleErrors(component, errors);
                    }

                    if (params.onError) {
                        params.onError(errors);
                    }

                    break;
                }
                default: {
                    if (params.enableErrorNotifications) {
                        let errors = response.getError();
                        let msg = 'Unknown problem, state: ' + state + ', error: ' + errors[0].message;
                        console.error(msg);
                    }

                    break;
                }
            }
        });

        // Set action as storable if applicable
        if (params.isStorable) {
            invokeAction.setStorable();
        }

        // Call server-side action
        $A.enqueueAction(invokeAction);
    }
})