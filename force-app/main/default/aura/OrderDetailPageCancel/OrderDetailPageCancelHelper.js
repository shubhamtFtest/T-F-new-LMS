({
	cancelOrderHelper: function (component, event, helper) {
		console.log('cancel order clicked');
        debugger;
        //Shalini: changes start regarding credit note(ticket SAL-3501), validate here whether cancellation reason is selected or not
        var cancelReason = component.get("v.cancelReason");
        if($A.util.isEmpty(cancelReason) || $A.util.isUndefinedOrNull(cancelReason)){
            component.find('cancelReasons').showHelpMessageIfInvalid();
            helper.showToastMessage(component, event, helper, 'Cancellation reason is required','Error','Error');                                                                          
            return;
        }
        //Shalini: changes end regarding credit note(ticket SAL-3501)
        component.set("v.Spinner",true);//Show spinner after clicking on cancel order button
        var action = component.get("c.cancelSelectedOrder");
        action.setParams({
            'orderNum': component.get("v.orderNum"),
            'orderedItems': component.get("v.orderedItems"), 
            'originalOrderDetails': component.get("v.orderDetailsFetchd"), 
            'cancelReason'  : cancelReason,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.Spinner",false);
                console.log('result-->'+result);
                
                //Shalini: changes start regarding credit note(ticket SAL-3501)
                if(!$A.util.isEmpty(result) && !$A.util.isUndefinedOrNull(result))
                {
                    if(!$A.util.isEmpty(result.orderCancellatioStatus) && !$A.util.isUndefinedOrNull(result.orderCancellatioStatus) &&
                       result.orderCancellatioStatus === 'Order insertion in SF-Success'){
                        component.set("v.orderCancel",true);
                        
                        if(!$A.util.isEmpty(result.originalOrdId) && !$A.util.isUndefinedOrNull(result.originalOrdId))
                        {
                            component.set('v.isOriginalOrdPresentInSF', true);
                        	component.set('v.originalOrdId', result.originalOrdId);  
                            component.set('v.originalOrdUrl', window.location.origin + '/' + result.originalOrdId);
                        }
                        helper.showToastMessage(component, event, helper, result.orderCancellatioStatus,'Success','Success');
                    }
                    else if(!$A.util.isEmpty(result.orderCancellatioStatus) && !$A.util.isUndefinedOrNull(result.orderCancellatioStatus) && 
                            result.orderCancellatioStatus === 'Order insertion in SF-Failed'){
                        helper.showToastMessage(component, event, helper, result.orderCancellationMessage,'Error','Error');  
                    }
                }
                //Shalini: changes end regarding credit note(ticket SAL-3501)
                        
            }else if (state === "INCOMPLETE") {
                component.set("v.Spinner",false);
                helper.showToastMessage(component, event, helper, 'Something went wrong. Please try again later','Error','Error');
			}
            else if (state === "ERROR") {
                component.set("v.Spinner",false);
                helper.showToastMessage(component, event, helper, 'Something went wrong. Please try again later','Error','Error');
			}
        });
        $A.enqueueAction(action);
	},
    
    showToastMessage:function(component,event,helper,message,title,type){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title,
            message:message,
            messageTemplate: 'Mode is pester ,duration is 2sec and Message is overrriden',
            duration:'100',
            key: 'info_alt',
            type: type,
            mode: 'Timed'
        });
        toastEvent.fire();
    }, 
    
    //Fetch list of cancellation reason from setting record
    ordCancellationReason : function(cmp, event, helper){
    	var action = cmp.get("c.getOrdCancellationReason");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
				cmp.set("v.ordCancellationReasonList",result);
                console.log('result-->'+result);
            }
        });
        $A.enqueueAction(action);     
    },
})