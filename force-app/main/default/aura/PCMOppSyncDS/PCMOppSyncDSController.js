({
    init : function(component, event, helper) {
        debugger;
        //shalini: Changes start to use pcmImplicitFilter SAL-4494
        //component.set('v.implicitFltrValues', [{name: 'Restricted Country',value: 'IN',prdType: 'book'}]);
        component.set('v.activeTab', false);
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
                if(!$A.util.isEmpty(result) && !$A.util.isUndefinedOrNull(result))
                {
                    component.set('v.implicitFltrValues', [{name: 'Restricted Country',value: result,prdType: 'book'}]);
                    console.log('implicitFltrValues DS '+JSON.stringify(component.get('v.implicitFltrValues')));
                }
            }
        });
        $A.enqueueAction(action);
        
        var getDynamicQLIAction = component.get("c.getDynamicBespokeQLI");        
        getDynamicQLIAction.setParams({
            "quoteId" : component.get('v.recordId'),
        });
        debugger;
        getDynamicQLIAction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var bespokeQLI = response.getReturnValue();
                if ( bespokeQLI != null && bespokeQLI != '' && bespokeQLI != undefined && bespokeQLI.SBQQ__Product__r != null && bespokeQLI.SBQQ__Product__r != '' && bespokeQLI.SBQQ__Product__r != undefined) {
                    if ( bespokeQLI.SBQQ__Product__r.Product_Type_Author_Facing__c === 'Rule based' ) { //SFAL-281
                        component.set("v.isBespokeQLI", false);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Warning",
                            "message": "Already a dynamic Bespoke Collection exist. Please use it or contact your Admin."
                        });
                        toastEvent.fire();
                    }
                }
                console.log('isBespokeQLI =====>' + component.get('v.isBespokeQLI'));
        		
            }
        });
        $A.enqueueAction(getDynamicQLIAction);
    },
  
    handleComponentEvent : function(component, event, helper) {
        debugger;
        console.log('inpcmdscomponent');
        var activeT = event.getParam("isActiveTab");
        component.set("v.activeTab", activeT);
        var uuId = event.getParam("pcmUUID");
        component.set("v.uuID", uuId);
        component.set("v.selectedTab",'bundleItems');
        var inSalesforce = event.getParam("inSalesforce");
        component.set("v.inSalesforce",inSalesforce);
        var isBespokeQLI = event.getParam("isBespokeQLI");
        console.log('inpcmds' + isBespokeQLI);
        component.set("v.isBespokeQLI",isBespokeQLI);
        var istypeCollection= event.getParam("iscollection");
        component.set("v.istypeCollection", istypeCollection);
    }
})