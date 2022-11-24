({
  init : function(component, event, helper) {
        //shalini: Changes start to use pcmImplicitFilter SAL-4494
        //component.set('v.implicitFltrValues', [{name: 'Restricted Country',value: 'IN',prdType: 'book'}]);
        var recordId = component.get('v.recordId');
        var action = component.get("c.getOppAndSapDetails");
        component.set("v.mySpinner", true); 
        action.setParams({
            "quoteId" : component.get('v.recordId'),
        });
        action.setCallback(this, function(response) {
            component.set("v.mySpinner", false); 
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if(!$A.util.isEmpty(result) && !$A.util.isUndefinedOrNull(result) &&
                  !$A.util.isEmpty(result.isoCodeForRestrictionCheck) && !$A.util.isUndefinedOrNull(result.isoCodeForRestrictionCheck) &&
                  !$A.util.isEmpty(result.bpcOrderType) && !$A.util.isUndefinedOrNull(result.bpcOrderType))
                {
                    component.set('v.implicitFltrValues', [{name: 'Restricted Country',value: result.isoCodeForRestrictionCheck,prdType: result.bpcOrderType}]);
                    console.log('implicitFltrValues BPC '+JSON.stringify(component.get('v.implicitFltrValues')));
                }
            }
        });
        $A.enqueueAction(action);
    }
    //shalini: Changes end to use pcmImplicitFilter SAL-4494
})