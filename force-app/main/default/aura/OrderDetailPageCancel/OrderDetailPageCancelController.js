({
	onInitPage: function (cmp, event, helper) {
		// var orderNo = cmp.get("v.pageReference").state.hub__orderNum;
		// var accntId = cmp.get("v.pageReference").state.hub__accId;
		// cmp.set("v.orderNum", orderNo);
		// cmp.set("v.accId", accntId);
		
        // Shalini: To fetch order cancellation list regarding credit note(ticket SAL-3501)
		helper.ordCancellationReason(cmp, event, helper);

		var orderNum = cmp.get("v.orderNum");
        console.log('orderNum-- '+orderNum)
		console.error('order detail init');
		// calling function 
		var act = cmp.get('c.callOrderAPI');
		$A.enqueueAction(act);
	}, // orderNum fetchSpecificOrder()

	callOrderAPI: function (cmp) {
		// Spinner
		cmp.set("v.Spinner", true);
		var action = cmp.get('c.fetchSpecificOrder');
		action.setParams({
			orderNum: cmp.get("v.orderNum"),
			AccountId: cmp.get("v.accId")
		});
		action.setCallback(this, function (res) {
			if (res.getState() === 'SUCCESS') {
				cmp.set("v.Spinner", false);
				console.log('response-' + JSON.stringify(res.getReturnValue()));
				if (!$A.util.isEmpty(res.getReturnValue()) && !$A.util.isEmpty(res.getReturnValue().order)) {
					// orderDetailsFetchd

                    //Shalini: Start changes regarding credit note(ticket SAL-3501)
					if(!$A.util.isEmpty(res.getReturnValue().originalOrdId) && !$A.util.isUndefinedOrNull(res.getReturnValue().originalOrdId)) 
                    {
                        console.log('originalOrdId--> '+ res.getReturnValue().originalOrdId);
                        cmp.set('v.isOriginalOrdPresentInSF', true);
                        cmp.set('v.originalOrdId', res.getReturnValue().originalOrdId);  
                        cmp.set('v.originalOrdUrl', window.location.origin + '/' + res.getReturnValue().originalOrdId);
                        cmp.set("v.orderCancel", true);
                    }
                    if(!$A.util.isEmpty(res.getReturnValue().order.orderType) && !$A.util.isUndefinedOrNull(res.getReturnValue().order.orderType)
                      && (res.getReturnValue().order.orderType == 'REVISED_SALES_RETURN'|| res.getReturnValue().order.orderType == 'RETURN' || res.getReturnValue().order.orderType == 'REVISED_SALES')){
                        cmp.set("v.isOriginalOrderOnHub", false);
                    }
                    //Shalini: End changes regarding credit note(ticket SAL-3501)
                    
					cmp.set("v.addressType", res.getReturnValue().metadata.addresMappg);
					cmp.set("v.orderDetailsFetchd", res.getReturnValue().order);
                    //Shalini
                    if( res.getReturnValue().order.orderStatus === 'CANCELLED'){
                        cmp.set("v.orderCancel", true);
                    }
					var order = cmp.get("v.orderDetailsFetchd");
					if (!$A.util.isEmpty(order) && !$A.util.isEmpty(order.orderedItem)) {
						cmp.set("v.orderedItems", order.orderedItem);
					}
					if (!$A.util.isEmpty(order) && !$A.util.isEmpty(order.invoices[0]) && !$A.util.isEmpty(order.invoices[0].currencyy)) {
						cmp.set("v.currency", order.invoices[0].currencyy);
					}
					//order.orderedItem
					console.log(JSON.stringify(res.getReturnValue().order));
				}
			} else if (res.getState() === 'ERROR') {
				cmp.set("v.Spinner", false);
				var errors = res.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						// console.log(errors[0].message);
					}
				}
			}
		});
		$A.enqueueAction(action);
	},
	backclicked: function (cmp, event, helper) {
		console.log('back clicked ');
		cmp.set("v.showForm", true);
		cmp.set("v.showOrderdetailPage", false);

	},
    
    cancelOrder: function (component, event, helper) {
        component.set("v.isModalOpen", false);
        helper.cancelOrderHelper(component, event, helper);
	},
    
    openModel: function(component, event, helper) {
      // Set isModalOpen attribute to true
      component.set("v.isModalOpen", true);
   },
  
   closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
   },
    
})