({
    doInit : function(component, event, helper) {

    },
     closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    },
    closeModelsec: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpenSec", false);
    },
    continueAdd: function(component, event, helper) {

        component.set("v.iscontinueclicked",true);
        var issinglerec=component.get("v.issinglerec");
        if(issinglerec==true){
            var b = component.get('c.insertSinglerec');
            $A.enqueueAction(b);
        }else{
            let button = component.find('disablebuttonid');
            button.set('v.disabled',true);
            var a = component.get('c.importCsv');
            $A.enqueueAction(a);
            component.set("v.showSelectSpinner", true);

        }
    },
    
    resetProducts : function(component, event, helper) {
       component.set("v.products", null);
       component.set("v.productName", '');
       component.set("v.isbn", '');
       var msgApiFailedText = component.find("msgApiFailedText");
        msgApiFailedText.set("v.value", '');
    }, 
    searchProducts : function(component, event, helper) {
        helper.getPriceBookEntryHelper(component);
    },
    closeAddOppProductModal: function(component, event, helper) { 
        component.set("v.isOpenAddOppProductModal", false);
    },
    handleTabActive: function(component,event,helper) {
        var value = event.getSource().get("v.id");
    },
    onChangeRequiredQuantity: function(component, event, helper) {
        var oliQty = component.find('qty').get('v.value');
        component.set("v.requiredQuantity", oliQty);        
    },
    onChangeRequiredVersionType: function(component, event, helper) {
        var versionType = component.find('versionType').get('v.value');
        component.set("v.requiredVersionType", versionType);
    },
    selectOpportunityLineItem: function(component, event, helper) {        
        component.set("v.issinglerec",true);
        var prodId = event.getSource().get("v.value");
        var oppId = component.get("v.oppRecordId");         
        var qty = component.get("v.requiredQuantity");
        var versionType = component.get("v.requiredVersionType");
        var globalISBN = component.get("v.globalISBN");
        var indiaISBN = component.get("v.inrISBN");
        component.set("v.productId",prodId);

        //alert('globalISBN::'+globalISBN);
        //alert('indiaISBN::'+indiaISBN);
        if((qty == '' || qty == null) || (versionType == '' || versionType == null)){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({ 
                'message' : 'Quantity and Required Version Type both are mandatory fields.',
                'type':'error'
            });
            toastEvent.fire();            
        } else{
            var iscontinueclicked=component.get("v.iscontinueclicked");
            var actions = component.get("c.doesProductExistInActiveOpp"); 
            actions.setParams({ 
                  "productId":prodId,
                "opportunityId": oppId,
                "currencyISOCode":"INR",
                "requiredQty": qty,
                "requiredVersionType": versionType,
                "globalISBN" : globalISBN,
                "inrISBN" : indiaISBN
            });       
            actions.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {  
                    var result = response.getReturnValue(); 
                    if(result!=null || result.length>0){ 
                        component.set("v.isOpenSec",result);
                        component.set("v.otherproposaldata",result);
                       
                    }
                    else{
                        var b = component.get('c.insertSinglerec');
                        $A.enqueueAction(b);
                    }
                } else if (state === "ERROR") {
                }
                
            }); 
            $A.enqueueAction(actions);
        }
        
    },   
    insertSinglerec:function(component, event, helper) {
        component.set("v.issinglerec",true);
        var prodId = component.get("v.productId"); 
        var oppId = component.get("v.oppRecordId");         
        var qty = component.get("v.requiredQuantity");
        var versionType = component.get("v.requiredVersionType");
        var globalISBN = component.get("v.globalISBN");
        var indiaISBN = component.get("v.inrISBN");
      component.set("v.showSelectSpinner", true);
                        var action = component.get("c.createOpportunityLineItem");    
                        action.setParams({ 
                            "productId":prodId,
                            "opportunityId": oppId,
                            "currencyISOCode":"INR",
                            "requiredQty": qty,
                            "requiredVersionType": versionType,
                            "globalISBN" : globalISBN,
                            "inrISBN" : indiaISBN
                        });        
                        action.setCallback(this, function(response) { 
                            var state = response.getState();
                            if (state === "SUCCESS"){
                                var result = response.getReturnValue();
                                console.log(result);
                                if(result == 'Record inserted successfully'){
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({ 
                                        'title' : 'Success', 
                                        'message' : 'Product added sucessfully.' ,
                                        'type':'success'
                                    }); 
                                    component.set("v.isOpenAddOppProductModal", false);
                                    toastEvent.fire();                     
                                } else if(result == 'RECORD_EXIST') {
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({ 
                                        'title' : 'Error!!', 
                                        'message' : 'Product already exist with the same quantity and required version.' ,
                                        'type':'error'
                                    }); 
                                    component.set("v.showSelectSpinner", false);
                                    toastEvent.fire();                         
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
                                    "message": "Error found while inserting OLI."
                                });
                                toastEvent.fire();
                            }
                        });
                        $A.enqueueAction(action);            
                          
    },
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        var re = /(?:\.([^.]+))?$/;        
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
            var fileExt = re.exec(fileName)[1];
            (fileExt === 'csv') ? component.set("v.disableCSVImportBtn", false) : component.set("v.disableCSVImportBtn", true);
            if(fileExt !== 'csv'){fileName = 'Invalid file type. Only csv is allowed.';}
        }
        component.set("v.fileName", fileName);
    },
    importCsv: function (component, event, helper) {
        component.set("v.issinglerec",false);
        
        var fileInput = component.find("file").get("v.files");
        if(fileInput == null){
            component.set("v.fileName", 'Alert : Please select CSV file to import.');
        } else {
            component.set("v.showLoadingSpinner", true);
            var file = fileInput[0];
            console.log("File::"+file);
            var reader = new FileReader();            
            reader.readAsText(file, "UTF-8");
            reader.onload = function (evt) {
                console.log("EVT FN");
                var csv = evt.target.result;
                console.log('@@@ csv file contains'+ csv);
                var result = helper.CSV2JSON(component,csv);
                console.log('@@@ result = ' + result);
                //console.log('@@@ Result = '+JSON.parse(result));
                //helper.CreateAccount(component,result);
                window.setTimeout($A.getCallback(function(){
                    helper.createOpportunityLineItems(component,result);
                }), 10);                
            }
            reader.onerror = function (evt) {
                console.log("error reading file");
            }
        }        
    },    
})