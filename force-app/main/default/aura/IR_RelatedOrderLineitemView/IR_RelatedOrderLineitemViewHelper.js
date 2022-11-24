({
    fetchRecords: function(component,row,sortField) {
        row=component.get("v.recordId");
        let parameters = {
            action: "OrderLineItem:OrderLineItemList",
            parameters: {
                recordId: row 
            }
        };	
        
        let onSuccess = $A.getCallback(response => { // Custom success callback
            if(response[0].showrelatedlist==true){
              component.set("v.invoicenotthere",false);
        }
            if(response[0].OrderStatus==='Placed'){
            response.showClass = 'orangecolor';
            component.set("v.CreateButtDisabled",true);
        }else if(response[0].OrderStatus==='Approved' || response[0].OrderStatus==='Print Order Created'){
            component.set("v.ApprovedButtDisabled",true);
        }
        response.forEach(function(response){ 
            if(response.Status==='Approved'){
                response.showClass = 'bluecolor';
            }else if(response.Status==='Print Order Created'){
                response.showClass =  'greencolor';
            }
        });
        console.log('response'+JSON.stringify(response));
        
        component.set("v.OrderLineItemList",response);
        component.set("v.isOrderPlaced",response[0].isOrderPlaced);
        component.set("v.ProfileCheack",response[0].ProfileCheack);
        
        var commonActions;
        var isorderPlaced=response[0].isOrderPlaced;
        if(isorderPlaced==false){
            commonActions = [
                { label: 'Edit', name: 'edit'}                  
            ];
            component.set("v.columns", [
                {label:'Product', fieldName: 'Name', type: 'text',sortable: true, target:'_blank',"cellAttributes": {"class": {"fieldName": "showClass"}}},
                {label:'Reprint Type', fieldName: 'Type', type: 'text',sortable: true, target:'_blank',"cellAttributes": {"class": {"fieldName": "showClass"}}},
                {label:'Quantity', fieldName: 'Quantity', type: 'text',sortable: true, target:'_blank',"cellAttributes": {"class": {"fieldName": "showClass"}}},
                {label:'ReferenceNumber', fieldName: 'ReferenceNumber', type: 'text',sortable: true, target:'_blank',"cellAttributes": {"class": {"fieldName": "showClass"}}},
                {label:'Global ISBN', fieldName: 'ISBN', type: 'text',sortable: true, target:'_blank',"cellAttributes": {"class": {"fieldName": "showClass"}}},
                {label:'Indian ISBN', fieldName: 'IndianISBN', type: 'text',sortable: true, target:'_blank',"cellAttributes": {"class": {"fieldName": "showClass"}}},
                {label:'Author', fieldName: 'Author', type: 'text',sortable: true, target:'_blank',"cellAttributes": {"class": {"fieldName": "showClass"}}},
                {label:'UMC', fieldName: 'UMC', type: 'text',sortable: true, target:'_blank',"cellAttributes": {"class": {"fieldName": "showClass"}}},
                {label:'Binding Type', fieldName: 'Binding', type: 'text',sortable: true, target:'_blank',"cellAttributes": {"class": {"fieldName": "showClass"}}},
                {label:'Printer', fieldName: 'Printer', type: 'text',sortable: true, target:'_blank',"cellAttributes": {"class": {"fieldName": "showClass"}}},
                {type: 'action',typeAttributes: {rowActions: commonActions,menuAlignment: 'right'}},
            ]);
                }else{
                commonActions = [
                { label: 'Edit', name: 'edit'}                  
            ];
                          component.set("v.columns", [
                          {label:'Product', fieldName: 'Name', type: 'text',sortable: true, target:'_blank',"cellAttributes": {"class": {"fieldName": "showClass"}}},
                          {label:'Reprint Type', fieldName: 'Type', type: 'text',sortable: true, target:'_blank',"cellAttributes": {"class": {"fieldName": "showClass"}}},
                          {label:'Quantity', fieldName: 'Quantity', type: 'text',sortable: true, target:'_blank',"cellAttributes": {"class": {"fieldName": "showClass"}}},
                          {label:'ReferenceNumber', fieldName: 'ReferenceNumber', type: 'text',sortable: true, target:'_blank',"cellAttributes": {"class": {"fieldName": "showClass"}}},
                          {label:'Global ISBN', fieldName: 'ISBN', type: 'text',sortable: true, target:'_blank',"cellAttributes": {"class": {"fieldName": "showClass"}}},
                          {label:'Indian ISBN', fieldName: 'IndianISBN', type: 'text',sortable: true, target:'_blank',"cellAttributes": {"class": {"fieldName": "showClass"}}},
                          {label:'Author', fieldName: 'Author', type: 'text',sortable: true, target:'_blank',"cellAttributes": {"class": {"fieldName": "showClass"}}},
                          {label:'UMC', fieldName: 'UMC', type: 'text',sortable: true, target:'_blank',"cellAttributes": {"class": {"fieldName": "showClass"}}},
                          {label:'Binding Type', fieldName: 'Binding', type: 'text',sortable: true, target:'_blank',"cellAttributes": {"class": {"fieldName": "showClass"}}},
                          {label:'Printer', fieldName: 'Printer', type: 'text',sortable: true, target:'_blank',"cellAttributes": {"class": {"fieldName": "showClass"}}},
                          ]);
        }                     
        
    });
    let onError = $A.getCallback(errors => { // Custom error callback
});
this._invoke(component, parameters, onSuccess, onError);
},
    _invoke: function(component, parameters, onSuccessCallback, onErrorCallback) {
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
            var data = cmp.get("v.OrderLineItemList");
            var reverse = sortDirection !== 'asc';
            data.sort(this.sortBy(fieldName, reverse))
            cmp.set("v.OrderLineItemList", data);
        }, 
            sortBy: function (field, reverse, primer) {
                var key = primer ?
                    function(x) {return primer(x[field])} :
                function(x) {return x[field]};
                reverse = !reverse ? 1 : -1;
                return function (a, b) {
                    return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
                }
            },
                
                SendToProd:function(component,event,getInputkeyWord) {
                    var selectedids=component.get("v.SelectIds");
                    let parameters = {
                        action: "OrderLineItem:SendToProd",
                        parameters: {
                            SelectedList: selectedids
                        }
                    };
                    
                    // set param to method  
                    
                    // set a callBack    
                    let onSuccess = $A.getCallback(response => { // Custom success callback
                        console.log('#####'+JSON.stringify(response));
                        if(response=='NoInvoice'){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                        title : 'Error',
                        message:'Please Enter Invoice Or Select Iswithout Invoice On order',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                }else if(response=='AreadyApproved'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message:'Already Send To production!',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                }else{   
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "The record has been updated successfully."
                    });
                    toastEvent.fire();
                    location.reload();
                }
}

);
// enqueue the Action  
let onError = $A.getCallback(errors => { // Custom error callback
});
this._invoke(component, parameters, onSuccess, onError);
},
    
    searchHelper : function(component,event,getInputkeyWord) {
        $A.util.removeClass(component.find("mySpinner"), "slds-show");
        // call the apex class method 
        let parameters = {
            action: "OrderLineItem:fetchAccount",
            parameters: {
                searchKeyWord: getInputkeyWord
            }
        };
        
        // set param to method  
        
        // set a callBack    
        let onSuccess = $A.getCallback(response => { // Custom success callback
            
            var storeResponse = response;
            // if storeResponse size is equal 0 ,display No Result Found... message on screen.
            if (storeResponse.length == 0) {
            component.set("v.Message", 'No Result Found...');
        } else {
                                       component.set("v.Message", 'Search Result...');
    }

// set searchResult list with return value from server.
component.set("v.listOfSearchRecords", storeResponse);
console.log(JSON.stringify(storeResponse));
}

);
// enqueue the Action  
let onError = $A.getCallback(errors => { // Custom error callback
});
this._invoke(component, parameters, onSuccess, onError);
},     
    CreatePrintOrder: function(component,event,getInputkeyWord) {
        var selectedids=component.get("v.SelectIds");
        var SelectPrinterOrNot=component.get("v.SelectPrinterOrNot");
        if(selectedids.length==0){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message:'Please select an Order LineItem!',
                duration:' 5000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
        }else if(SelectPrinterOrNot.length>0){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message:'Please select an Order LineItem with Printer!',
                duration:' 5000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
        }
        
        
            else{
                component.set("v.spinner",true);
                
                let parameters = {
                    action: "OrderLineItem:CreatePrintOrder",
                    parameters: {
                        SelectedList: selectedids
                    }
                };
                
                // set a callBack    
                let onSuccess = $A.getCallback(response => { // Custom success callback
                    component.set("v.spinner",false);
                    if(response==true){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                    title : 'Error',
                    message:'Already Send For Printing!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
            }else{  
                console.log('$$$$$$$$$$');
                location.reload();
            }
        
    }                                                   
);
// enqueue the Action  
let onError = $A.getCallback(errors => { // Custom error callback
});
this._invoke(component, parameters, onSuccess, onError);
}
},    
    updateDistributor : function (cmp, event, helper) {
        var AccId=cmp.get("v.Idrec");
        var Oliid=cmp.get("v.OrliId");
        var selectedids=cmp.get("v.SelectIds");
        //  if(cmp.get("v.isOrderPlaced")==true){
        //  component.set("v.showErrors",true);
        //component.set("v.errorMessage","Order is Placed You cant Edit It Now");
        //}
        let parameters = {
            action: "OrderLineItem:updateAcc",
            parameters: {
                AccountId:AccId,
                recordId: Oliid,
                SelectedList:selectedids
            }
        };
        
        let onSuccess = $A.getCallback(response => { // Custom success callback
            window.location.reload()
        }
            
            );
            // enqueue the Action  
            let onError = $A.getCallback(errors => { // Custom error callback
        });
            this._invoke(cmp, parameters, onSuccess, onError);
        }
            
            
            
        })