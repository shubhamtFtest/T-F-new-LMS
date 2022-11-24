({
    /**
     *Fetching olis of order
     **/
	getOrderLineItems : function(component, helper,currOrderId) {
		var action = component.get("c.getOrderItems");
        action.setParams({
            'inputOrderId' : currOrderId
        });	
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
				component.set("v.oliList",result);
                console.log('result-->'+result);
            }
        });
        $A.enqueueAction(action);    
	},
    
    /**
     *Checking current order type
     **/
    checkOrderDetails: function(component, helper,currOrderId) {
        var action = component.get("c.checkCurrentOrderDetails");
        action.setParams({
            'inputOrderId' : currOrderId
        });	
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('result-->'+JSON.stringify(result));
                if(result.isOrdOppNotClosedWon){
                    component.set("v.showErrorOrdOppNotClosedWon",result.isOrdOppNotClosedWon);
                }
                else if(result.isOrdTypeNotExists){
                    component.set("v.showErrorOrdType",result.isOrdTypeNotExists);
                }
                else if(result.isOrdStatusCancelled){
                    component.set("v.showErrorCancelledOrdType",result.isOrdStatusCancelled);
                }
                else{
                    component.set("v.dispTabData",false);
                }
            }
        });
        $A.enqueueAction(action);   
    },
    
    /**
     *Show dynamic toast message 
     **/
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
    
    /**
     *Cancelling order from salesforce and order hub
     **/
    sendOLIData : function(component, event, helper,dataList,cancelReason){
        debugger;
        console.log('inside helper method');
        console.log('dataList->'+JSON.stringify(dataList));
        var currOrderId = component.get("v.recordId");
        //If cancel reason is empty then show error message and return 
        /*if($A.util.isEmpty(cancelReason) || $A.util.isUndefinedOrNull(cancelReason) || !cancelReason.replace(/\s/g, '').length) {
            component.find('cancelReason').showHelpMessageIfInvalid();
            helper.showToastMessage(component, event, helper, 'Cancellation reason is required','Error','Error');                                                                          
            return;
        }*/
        if($A.util.isEmpty(cancelReason) || $A.util.isUndefinedOrNull(cancelReason)){
            component.find('cancelReasons').showHelpMessageIfInvalid();
            helper.showToastMessage(component, event, helper, 'Cancellation reason is required','Error','Error');                                                                          
            return;
        }
        component.set("v.cancelOrderSpinner",true);//Show spinner after clicking on cancel order button
        var testData = JSON.stringify(dataList);
        var action = component.get("c.cancelSelectedOLIs");
        
        action.setParams({
            'selOliList' : testData,
            'cancelReason'  : cancelReason,
            'currOrderId' : currOrderId 
        });	
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                debugger;
                var result = response.getReturnValue();
                component.set("v.cancelOrderSpinner",false);
                console.log('result-->'+result);
                if(result === 'Select atleast 1 quantity to reduce'){
                     helper.showToastMessage(component, event, helper, result,'Error','Error');
                }
                else if(result === 'Order cancellation from order hub-Success'){
                    helper.showToastMessage(component, event, helper, result,'Success','Success');
                    window.location.reload(true);
                }
                else if(result === 'Order cancellation from order hub-Failed'){
                   helper.showToastMessage(component, event, helper, result,'Error','Error');  
                   window.location.reload(true);
                }
                
            }else if (state === "INCOMPLETE") {
                component.set("v.cancelOrderSpinner",false);
   				helper.showToastMessage(component, event, helper, 'Something went wrong. Please try again later','Error','Error');
				window.location.reload(true);
            }
            else if (state === "ERROR") {
                component.set("v.cancelOrderSpinner",false);
                helper.showToastMessage(component, event, helper, 'Something went wrong. Please try again later','Error','Error');
                window.location.reload(true);
            }
        });
        $A.enqueueAction(action);
    },
    
    ordCancellationReason : function(component, event, helper){
    	var action = component.get("c.getOrdCancellationReason");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
				component.set("v.ordCancellationReasonList",result);
                console.log('result-->'+result);
            }
        });
        $A.enqueueAction(action);     
    },
    
})