({
	/**
	 * 
	 * @param {*} cmp 
	 * @param {*} event 
	 * @description : on next,previous,channel change btn 
	 */
	processChange: function (cmp, event) {
		var recordId = cmp.get("v.recordId");
		// console.log('recordId-' + recordId);
		// console.log('sObjectName-' + cmp.get("v.sObjectName"));
		if (recordId) {
			/**
			 *  calling function getOrdersForCustomer() to fetch orders 
			 */

			cmp.set('v.Spinner', true);
			var tabl = cmp.find("cmpContent");
			$A.util.toggleClass(tabl, 'slds-transition-hide');
			console.log('call () ');
			console.log('drop down-' + cmp.find('select').get('v.value'));

			var action = cmp.get('c.getOrderForOpp');

			action.setParams({
				objId: recordId,
				channel: cmp.find('select').get('v.value'),
				sObjectName: cmp.get("v.sObjectName"),
				pagesize: cmp.get("v.pagesize"),
				pageno: cmp.get("v.pageno")

			});

			action.setCallback(this, function (res) {
				if (res.getState() === 'SUCCESS') {
					cmp.set('v.Spinner', false);
					var tabl = cmp.find("cmpContent");
					$A.util.toggleClass(tabl, 'slds-transition-hide');
					console.log(JSON.stringify(res.getReturnValue()));
					if (!$A.util.isEmpty(res.getReturnValue()) && !$A.util.isEmpty(res.getReturnValue().paginatedOrderResult) && !$A.util.isEmpty(res.getReturnValue().paginatedOrderResult.data)) {
						var arr = [];
						arr = res.getReturnValue().paginatedOrderResult.data;
						// console.log('total pages -'+res.getReturnValue().metadata.totalPagesize);
						cmp.set("v.totalPageSize", res.getReturnValue().metadata.totalPagesize);
						arr.sort(function (a, b) {
							a = new Date(a.orderDate);
							b = new Date(b.orderDate);
							return a > b ? -1 : a < b ? 1 : 0;
						});
						// console.log('arr-' + arr);
						var len = arr.length;
						cmp.set("v.recordsPerPage", len);
						cmp.set('v.OrdersFetched', arr);
						cmp.set('v.NoOrderFound', false);
						if (cmp.get("v.recordsPerPage") === 4) {
							cmp.set("v.btnDisable", true);
						}
					} else {
						cmp.set('v.NoOrderFound', true);
						var emptylist = [];
						cmp.set('v.OrdersFetched', emptylist);

						// console.log('no order found -' + cmp.get('v.NoOrderFound'));
					}
				} else if (res.getState() === 'ERROR') {
					cmp.set('v.Spinner', false);
					var tabl = cmp.find("cmpContent");
					$A.util.toggleClass(tabl, 'slds-hide');
					var errors = res.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							// console.log(errors[0].message);
						}
					}
				}
			});
			$A.enqueueAction(action);
		}

	},
})