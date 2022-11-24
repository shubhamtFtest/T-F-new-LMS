({
fetchRecords: function(component,row,sortField) { 
	let parameters = {
		action: "Printorder:PrintorderRecList",
		parameters: {
			recordId: row 
		}
	};
	
	let onSuccess = $A.getCallback(response => { // Custom success callback
		console.log('response'+JSON.stringify(response));
		component.set("v.PrintorderList",response);
		console.log(response[0].ProfileCheack);
		if(response[0].ProfileCheack==true){
		 component.set("v.columns", [
		{label:'Print order Id', fieldName: 'secLink', type: 'url',sortable: true,
		typeAttributes: {label: { fieldName: 'Name' },value:{fieldName: 'secLink'}, target: '_blank'}
	},           
                                   {label:'Reference Number', fieldName: 'ReferenceNumber', type: 'text',sortable: true, targer:'_blank'},
								   {label:'Status', fieldName: 'Status', type: 'text',sortable: true, targer:'_blank'},
								  // {label:'Invoice Number', fieldName: 'InvoiceNumber', type: 'text',sortable: true, targer:'_blank'},
								   {label:'Payment Terms', fieldName: 'PaymentTerm', type: 'text',sortable: true, targer:'_blank'},
								   {label:'Delivery Date', fieldName: 'DeliveryDate', type: 'text',sortable: true, targer:'_blank'},
								   {label:'Customer Name', fieldName: 'CustomerName', type: 'text',sortable: true, targer:'_blank'},
								   {label:'Special Instructions', fieldName: 'SpecialInstructions', type: 'text',sortable: true, targer:'_blank'},
								   {label:'Packing Instructions	', fieldName: 'PackingInstructions', type: 'text',sortable: true, targer:'_blank'},

								   ]);
	}else{
		component.set("v.columns", [
		{label:'Print Orders Id', fieldName: 'secLink', type: 'url',sortable: true,
		typeAttributes: {label: { fieldName: 'Name' },value:{fieldName: 'secLink'}, target: '_blank'}
	},           				   {label:'Reference Number', fieldName: 'ReferenceNumber', type: 'text',sortable: true, targer:'_blank'},
								   {label:'Status', fieldName: 'Status', type: 'text',sortable: true, targer:'_blank'},
								  // {label:'Invoice Number', fieldName: 'InvoiceNumber', type: 'text',sortable: true, targer:'_blank'},
								   {label:'Printer', fieldName: 'Printer', type: 'text',sortable: true, targer:'_blank'},
								   {label:'Payment Terms', fieldName: 'PaymentTerm', type: 'text',sortable: true, targer:'_blank'},
								   {label:'Delivery Date', fieldName: 'DeliveryDate', type: 'text',sortable: true, targer:'_blank'},
								   {label:'Customer Name', fieldName: 'CustomerName', type: 'text',sortable: true, targer:'_blank'},
								   {label:'Special Instructions', fieldName: 'SpecialInstructions', type: 'text',sortable: true, targer:'_blank'},
								   {label:'Packing Instructions	', fieldName: 'PackingInstructions', type: 'text',sortable: true, targer:'_blank'},

								   ]);
}
	for (var i = 0; i < response.length; i++) { 
		var row = response[i]; 
		row.secLink="/IR/s/print-order-record?recordId="+response[i].recordId; 
		component.set("v.secLink", row.secLink);
	}
});


let onError = $A.getCallback(errors => { // Custom error callback
});
this._invoke(component, parameters, onSuccess, onError);
},_invoke: function(component, parameters, onSuccessCallback, onErrorCallback) {
const server = component.find('server');
const serversideAction = component.get("c.invoke");
if (server) {
	server.invoke(
		serversideAction, // Server-side action
		parameters, // Action parameters
		false, // Disable cache if false
		onSuccessCallback,
		onErrorCallback,
		true //enable error notifications
	);
}
},
sortData: function (cmp, fieldName, sortDirection) {
	var data = cmp.get("v.PrintorderList");
	var reverse = sortDirection !== 'asc';
	data.sort(this.sortBy(fieldName, reverse))
	cmp.set("v.PrintorderList", data);
}, 
	sortBy: function (field, reverse, primer) {
		var key = primer ?
			function(x) {return primer(x[field])} :
		function(x) {return x[field]};
		reverse = !reverse ? 1 : -1;
		return function (a, b) {
			return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
		}
	},showToast : function(component, event, helper) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        "title": "Success!",
        "message": "Your File is Been Inserted Successfully."
    });
    toastEvent.fire();
}
})