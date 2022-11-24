({
    //On load get current details of order
	orderDetails: function(component, event, helper) {
        component.set("v.spinner",true);
		var action = component.get("c.getOrderDetails");
        action.setParams({
            'orderId' : component.get("v.recordId")
        });	
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.spinner",false);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if(!$A.util.isEmpty(result) && !$A.util.isUndefinedOrNull(result))
                {
                    if(!$A.util.isEmpty(result.isCancelled) && !$A.util.isUndefinedOrNull(result.isCancelled))
                    {
                        component.set("v.isCancelled", result.isCancelled);
                    }
                    if(!$A.util.isEmpty(result.messageOnOrder) && !$A.util.isUndefinedOrNull(result.messageOnOrder))
                    {
                        if(result.messageOnOrder === 'This functionality has not been attempted once.')
                        {
                            component.set("v.isCancelled", true);
                            component.set("v.isNotAttempted", true);
                            component.set("v.messageOnOrder",'This functionality has not been attempted once. Please wait for some time and check again later!!');
                        }
                        else component.set("v.messageOnOrder",result.messageOnOrder);
                    }
                }
            }
            else{
                helper.showToastMessage(component, event, helper, 'Something went wrong. Please try again later','Error','Error');
            }
        });
        $A.enqueueAction(action);  
    },
    
    //Retry the order cancellation from hub logic
    cancelSelectedOrderRetryHelper: function(component, event, helper) {
        component.set("v.spinner",true);//Show spinner after clicking on proceed button
        var action = component.get("c.retryCancelSelectedOrder");
        action.setParams({
            'orderId' : component.get("v.recordId")
        });	
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.spinner",false);//Hide spinner
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('After Cancellation return result--> '+JSON.stringify(result));
                console.log('After Cancellation return result--> '+JSON.stringify(result[0]));
                if(!$A.util.isEmpty(result) && !$A.util.isUndefinedOrNull(result))
                {
                    if(!$A.util.isEmpty(result[0].messageOnOrder) && !$A.util.isUndefinedOrNull(result[0].messageOnOrder))
                    {
                        component.set("v.messageOnOrder",result[0].messageOnOrder);
                    }
                    if(!$A.util.isEmpty(result[0].isCancelled) && !$A.util.isUndefinedOrNull(result[0].isCancelled))
                    {
                        component.set("v.isCancelled", result[0].isCancelled);
                        if(result[0].isCancelled && !$A.util.isEmpty(result[0].orderCancellatioStatus) && !$A.util.isUndefinedOrNull(result[0].orderCancellatioStatus))
                            helper.showToastMessage(component, event, helper, result[0].orderCancellatioStatus,'Success','Success');
                        else helper.showToastMessage(component, event, helper, result[0].orderCancellatioStatus,'Error','Error');
                    }
                }
            }
            else{
                helper.showToastMessage(component, event, helper, 'Something went wrong. Please try again later','Error','Error');
            }
        });
        $A.enqueueAction(action);  
    },
    
    //show dynamic toast messages
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
})