({
    init: function (component, event,helper) {
        helper.fetchSubjectClassificationForProduct(component, event, helper);
    },
	saveClassification : function(component, event, helper) {
        helper.updateSubjectClassificationForProduct(component, event, helper);
	}
})