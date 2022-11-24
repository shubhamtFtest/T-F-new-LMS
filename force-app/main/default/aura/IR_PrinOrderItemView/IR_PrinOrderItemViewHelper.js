({
fetchRecords: function(component,row,sortField) { 
    row='a3d6E000000DPjk';
	let parameters = {
		action: "Printorder:PrintOrderItemList",
		parameters: {
			recordId: row 
		}
	};
	
	let onSuccess = $A.getCallback(response => { // Custom success callback
		console.log('response'+JSON.stringify(response));
		component.set("v.PrintorderList",response);
		 component.set("v.columns", [
								   {label:'Name', fieldName: 'title', type: 'text',sortable: true, targer:'_blank'},
								  
								   ]);
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
	}
})