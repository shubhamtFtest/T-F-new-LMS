/**
 - Created by Sidhant on 9/20/19.
 */
({
    handleErrors: function(component, errors) {
        const toast = component.find('toast');
        let isToastServiceDefined = (typeof toast !== 'undefined');
        let isUnknownError = true;

        // Retrieve and display the error message(s) sent by the server
        if (typeof errors !== 'undefined' && Array.isArray(errors) && errors.length > 0) {
            errors.forEach(error => {
                // Check for 'regular' errors
                if (typeof error.message != 'undefined') {
                    if (isToastServiceDefined) {
                        toast.error(error.message);
                    }
                    isUnknownError = false;
                }
                // Check for 'pageError' errors
                const pageErrors = error.pageErrors;
                if (typeof pageErrors !== 'undefined' && Array.isArray(pageErrors) && pageErrors.length > 0) {
                    pageErrors.forEach(pageError => {
                        if (typeof pageError.message !== 'undefined') {
                            if (isToastServiceDefined) {
                                toast.error(pageError.message);
                            }
                            isUnknownError = false;
                        }
                    });
                }

                // Check for 'fieldErrors' errors
                const fieldErrors = error.fieldErrors;
                if (typeof fieldErrors !== 'undefined') {
                    if (Array.isArray(fieldErrors) && fieldErrors.length > 0) {
                        fieldErrors.forEach(fieldError => {
                            if (typeof fieldError.message !== 'undefined') {
                                if (isToastServiceDefined) {
                                    toast.error(fieldError.message);
                                }
                                isUnknownError = false;
                            }
                        });
                    } else {
                        for (var k in fieldErrors) {
                            if (fieldErrors.hasOwnProperty(k)) {
                                let fieldError = fieldErrors[k];
                                fieldError.forEach(err => {
                                    if (typeof err.message !== 'undefined') {
                                        if (isToastServiceDefined) {
                                            toast.error(err.message);
                                        }
                                        isUnknownError = false;
                                    }
                                });
                            }
                        }
                    }
                }
            });
        }
        // Make sure that we display at least one error message
        if (isUnknownError) {
            if (isToastServiceDefined) {
                toast.error('Unknown error');
            }
        }

        // Display raw error stack in console
        console.error(JSON.stringify(errors));
    }
})