({
    CSV2JSON: function (component,csv) {
        console.log('@@@ Incoming csv = ' + csv);       
        var arr = [];         
        arr =  csv.split('\n');;
        //console.log('@@@ Array  = '+array);
        console.log('@@@ arr = '+arr);
        arr.pop();
        var jsonObj = [];
        var headers = arr[0].split(',');
        component.set("v.header", headers);
        var defaultHeader = component.get('v.defaultHeader');
        for(var i = 0; i < headers.length; ++i){
            headers[i] = headers[i].replace(/(\r\n|\n|\r)/gm,"");
        }        
        console.log(JSON.stringify(defaultHeader) === JSON.stringify(headers));
        if(JSON.stringify(defaultHeader) == JSON.stringify(headers)){
            console.log('true');
        }else{
            console.log('false');
        }
        console.log('@@@ defaultHeader = '+defaultHeader);
        console.log('@@@ header = '+headers);
        for(var i = 1; i < arr.length; i++) {
            var data = arr[i].split(',');           
            var obj = {};
            for(var j = 0; j < data.length; j++) {
                obj[headers[j].trim()] = data[j].trim();
                //console.log('@@@ obj headers = ' + obj[headers[j].trim()]);
            }
            jsonObj.push(obj);
        }
        var json = JSON.stringify(jsonObj);
        return json;        
    },    
    bulkUpdateOpportunityLineItems : function(component, jsonstr) {
        console.log('@@@ jsonstr' + jsonstr);
        var opportunityRecordId = component.get("v.opportunityId");
        var action = component.get("c.bulkUpdateOpportunityLineItems"); 
        action.setParams({"jsonStr" : jsonstr, "oppId" : opportunityRecordId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {              
                component.set("v.spinner", false);               
                var returnValue = response.getReturnValue();
                if(returnValue == 'UPDATE_DONE') {
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Success!",
                        "type": "success",
                        "message": "Bulk update has been completed."
                    }); 
                    resultsToast.fire();
                }
                component.set("v.spinner", false);
                component.set("v.isBulkUpdateModalOpen", false);
            }
        }); 
        $A.enqueueAction(action);	
    },
})