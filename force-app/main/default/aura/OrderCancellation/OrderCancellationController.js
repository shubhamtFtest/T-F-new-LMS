({
	doInit : function(component, event, helper) {
		var currOrderId = component.get("v.recordId");
        console.log('currOrderId->'+currOrderId);
        helper.checkOrderDetails(component, helper,currOrderId);//Checking current order type, status and opp stage
        helper.getOrderLineItems(component, helper,currOrderId);//Fetching current order olis
        helper.ordCancellationReason(component, event, helper);//Fetching cancel reason picklist value from setting's record
    },
    /**
     *If qtyToReduce greater than current quantity of oli, show error
     **/
    checkQuantityVal : function(component, event, helper) {
        var qLabel = event.getSource().get("v.label");
        var qInpVal = event.getSource().get("v.value");
        if(qInpVal>qLabel){
            component.set("v.dispCancelOrdrBtn",true);
            helper.showToastMessage(component, event, helper, qInpVal+' exceeded quantity','Error','Error');
        }else{
            component.set("v.dispCancelOrdrBtn",false);
        }
    },
    /**
     *Cancel order 
     **/
    cancelOLIs : function(component, event, helper) {
        var dataList = component.get("v.oliList");
        var cancelReason = component.get("v.cancelReason");
        helper.sendOLIData(component, event, helper,dataList,cancelReason);
    },
})