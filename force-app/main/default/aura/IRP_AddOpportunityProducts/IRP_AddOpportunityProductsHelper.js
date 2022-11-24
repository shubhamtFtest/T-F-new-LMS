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
    
    createOpportunityLineItems : function (component, jsonstr) {
        console.log(JSON.parse(jsonstr).length+'@@@ jsonstr' + jsonstr);
                var opportunityRecordId = component.get("v.oppRecordId");

        var iscontinueclicked=component.get("v.iscontinueclicked");
        var incomminglist=JSON.parse(jsonstr);
        var outputArray = []; 
        var dupArray = []; 
        var count = 0; 
        var start = false; 
        var j;
        var k;
        for (j = 0; j < incomminglist.length; j++) { 
            for (k = 0; k < outputArray.length; k++) { 
                if ( incomminglist[j].ISBN == outputArray[k].ISBN && incomminglist[j].Quantity == outputArray[k].Quantity && incomminglist[j].Binding == outputArray[k].Binding ) { 
                   dupArray.push(incomminglist[j]);
                    start = true; 
                } 
            }
        count++; 
        if (count == 1 && start == false) { 
            outputArray.push(incomminglist[j]); 
        } 
        start = false; 
        count = 0; 
        }

        var actionsdub = component.get("c.checkCurrentProposalDuplicate"); 
        actionsdub.setParams({"jsonStr" : jsonstr, "oppId" : opportunityRecordId});
        actionsdub.setCallback(this, function(response) {
            var states = actionsdub.getState();
            if (states === "SUCCESS") {    
               var result = response.getReturnValue(); 
                if(result!=null || result.length()>0){
                  dupArray.push.apply(dupArray, result)
                }else{
                    
                }
            }
            else if (states === "ERROR") {
            }

        if(dupArray.length>0){
            component.set("v.isOpen", true);
            component.set("v.Dupdata", dupArray);
            
        }else{
            var actions = component.get("c.checkexistingProposal"); 

            actions.setParams({"jsonStr" : jsonstr, "oppId" : opportunityRecordId});
            actions.setCallback(this, function(response) {
                var states = response.getState();
                if (states === "SUCCESS") {              
                    var result = response.getReturnValue(); 
                    if(result!=null || result.length>0 ){
                        component.set("v.isOpenSec",result);
                        component.set("v.otherproposaldata",result);
                        if(iscontinueclicked==true){
                         this.Insertdata(component,jsonstr);
                        }
                    }
                    else{
                        this.Insertdata(component,jsonstr);
                    }

                }
                else if (states === "ERROR") {
                }
                
            }); 
            $A.enqueueAction(actions);
        }
        
        }); 

        $A.enqueueAction(actionsdub);
        component.set("v.showSelectSpinnerSec", false);
    },    
    
    Insertdata: function(component, jsonstr) {
        
        var opportunityRecordId = component.get("v.oppRecordId");
        var action = component.get("c.importOpportunityLineItems"); 
        action.setParams({"jsonStr" : jsonstr, "oppId" : opportunityRecordId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {              
                component.set("v.showLoadingSpinner", false);
                
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Success!",
                    "type": "success",
                    "message": "OpportunityLineItems have imported."
                });
                resultsToast.fire();      
                var wasDismissed = $A.get("e.force:closeQuickAction");
                wasDismissed.fire();
                
                component.set("v.isOpenAddOppProductModal", false);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                    alert('Unknown');
                }
            }
            
        }); 
        $A.enqueueAction(action);
        
    },
    
    getPriceBookEntryHelper : function(component) {
        var recordID = component.get("v.recordId");
        var productname = component.find("productName").get("v.value");
        var isbn = component.find("isbn").get("v.value");
        if((productname == '' || productname == null) && (isbn == '' || isbn == null)){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({ 
                'message' : 'Please product name or product ISBN.',
                'type':'error'
            });
            toastEvent.fire();            
        }else{
            component.set("v.showSearchSpinner", true);
            var action = component.get("c.getListOfPriceBookEntryNew");    
            action.setParams({ 
                "oppId":recordID,
                "productName": productname,
                "isbn": isbn,
            });        
            action.setCallback(this, function(response) { 
                var state = response.getState();
                if(state === 'SUCCESS' && component.isValid()){
                    var result = response.getReturnValue();   
                    //console.log('ProductResult::'+result[0].globalISBN);                    
                    component.set("v.products", result);                   
                    var msgApiFailedText = component.find("msgApiFailedText");
                    if(result.length < 1){                                         	
                    	msgApiFailedText.set("v.value", '<span style="color: #BF4040;"><b>Record Not Found.</b></span>');
                    }else{
                       msgApiFailedText.set("v.value", ''); 
                       component.set("v.globalISBN", result[0].globalISBN);
                       component.set("v.inrISBN", result[0].inrISBN);
                    }
                    component.set("v.showSearchSpinner", false);
                }else if (state == "INCOMPLETE") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Oops!",
                        "message": "No Internet Connection"
                    });
                    toastEvent.fire();                
                } else if (state == "ERROR") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "There was an issue while processing, please contact SFDC system admin."
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);            
        }
    },    
    getPriceBookEntryHelperOld : function(component) {
        var recordID = component.get("v.recordId");
        var productname = component.find("productName").get("v.value");
        var isbn = component.find("isbn").get("v.value");
        if((productname == '' || productname == null) && (isbn == '' || isbn == null)){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({ 
                'message' : 'Please product name or product ISBN.',
                'type':'error'
            });
            toastEvent.fire();            
        }else{
            var action = component.get("c.getListOfPriceBookEntry");    
            action.setParams({ 
                "oppId":recordID,
                "productName": productname,
                "isbn": isbn,
            });        
            action.setCallback(this, function(response) { 
                var state = response.getState();
                if(state === 'SUCCESS' && component.isValid()){
                    var result = response.getReturnValue();   
                    console.log('Productresult::'+result);
                    
                    component.set("v.products", result);
                    
                    //console.log('result.products.length::'+result.products.length);
                    var msgApiFailedText = component.find("msgApiFailedText");
                    if(result.length < 1){                                         	
                    	msgApiFailedText.set("v.value", '<span style="color: #BF4040;"><b>Record Not Found.</b></span>');
                    }else{
                       msgApiFailedText.set("v.value", ''); 
                    }
                }else if (state == "INCOMPLETE") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Oops!",
                        "message": "No Internet Connection"
                    });
                    toastEvent.fire();                
                } else if (state == "ERROR") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "There was an issue while processing, please contact SFDC system admin."
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);            
        }
    },
    fireSuccessToast : function(component) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({ 
            'title' : 'Success', 
            'message' : 'Record has updated sucessfully.' ,
            'type':'success'
        }); 
        toastEvent.fire(); 
    },
    
    fireFailureToast : function(component) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({ 
            'title' : 'Failed', 
            'message' : 'An error occurred. Please contact your administrator.',
            'type':'error'
        }); 
        toastEvent.fire(); 
    },
    
    fireRefreshEvt : function(component) {
        var refreshEvent = $A.get("e.force:refreshView");
        if(refreshEvent){
            refreshEvent.fire();
        }
    },    
})