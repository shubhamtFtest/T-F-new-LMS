({
	onInitPage: function (cmp, event, helper) {
		// var orderNo = cmp.get("v.pageReference").state.c__orderNum;
		// var accntId = cmp.get("v.pageReference").state.c__accId;
		// cmp.set("v.orderNum", orderNo);
		// cmp.set("v.accId", accntId);

		var orderNum = cmp.get("v.orderNum");
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

					cmp.set("v.addressType", res.getReturnValue().metadata.addresMappg);
					cmp.set("v.orderDetailsFetchd", res.getReturnValue().order);
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
})