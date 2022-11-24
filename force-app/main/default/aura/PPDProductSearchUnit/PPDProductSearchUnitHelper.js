({
    loadValues : function(component, levelCalled) {
        var action = component.get("c.getDynamicUIValues");
        var gParent = '';
        if(levelCalled != 'level1'){
            gParent = component.get("v.selectedType");
        }
        //alert(component.get("v.selectedFieldVal"));
        //alert(gParent);
        //alert(component.get("v.selectedFieldVal"));
        action.setParams({
            "grandParent": gParent,
            "parent": component.get("v.selectedFieldVal"),
            "consumer": component.get("v.consumer")
        }); 
        
        action.setCallback(this, function(response) {
            console.log('# getvalues callback %f', (performance.now() - startTime));
            var state = response.getState();
            if (state === "SUCCESS"){                
                var result = response.getReturnValue();
                if(result){
                    console.log('result'+JSON.stringify(result));
                    var pickValueLst = [];
                    var formatVal = {};
                    var valueLst = result.valueLst;
                    for(var val of valueLst){
                        var pickValue = {
                            label: '',
                            value: '',
                            hasChild:'',
                            dataType:'',
                            supportedOperator:'',
                            dotNotation:'',
                            useValueFrom:'',
                            fileUpload:'',
                            hasChild:'',
                            hasOperator:'',
                            queryLabel:''
                        }
                        pickValue.label = val.fieldLabel;
                        pickValue.value = val.fieldValue;
                        pickValue.hasChild = val.hasChild;
                        pickValue.dataType = val.dataType;
                        pickValue.supportedOperator = val.supportedOperator;
                        pickValue.dotNotation = val.dotNotation;
                        pickValue.useValueFrom = val.useValueFrom;
                        pickValue.fileUpload = val.fileUpload;
                        pickValue.hasChild = val.hasChild;
                        pickValue.hasOperator = val.hasOperator;
                        pickValue.queryLabel = val.queryLabel;

                        pickValueLst.push(pickValue);
                        if(val.fieldValue == 'Format'){
                            formatVal = pickValue;
                        }
                    }
                    if(levelCalled == 'level1'){
                        component.set("v.optionsLevel1",pickValueLst);
                        
                        if(component.get("v.typeChangedToBook") == true && ((component.get("v.consumer") == 'Collections')||(component.get("v.consumer") == 'OPC_External'))){
                            pickValueLst = [];
                            pickValueLst.push(formatVal);
                            component.set("v.optionsLevel1",pickValueLst);

                            component.set("v.value1","Format");
                            
                            var cmpEvent = component.getEvent("autoPopulate");
                            cmpEvent.setParams({
                                "bookRequiredField": "Format",
                                "value": "Format"
                            });        
                            cmpEvent.fire();
                        }else{
                            component.set("v.value1",'');
                        }
                    }
                    console.log("LevelCalled: " + levelCalled + "  value: " + pickValueLst);
                    if(levelCalled == 'level2'){
                        component.set("v.optionsLevel2",pickValueLst);
                    }
                    if(levelCalled == 'level3'){
                        component.set("v.optionsLevel3",pickValueLst);
                    }
                    if(levelCalled == 'finalValue'){
                        component.set("v.inputOptions",pickValueLst);
                    }
                }
                

            }else if (state == "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "No Internet Connection"
                });
                toastEvent.fire();
                component.set("v.IsSpinner",false);
                
            } else if (state == "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "There was an issue while processing, please contact SFDC system admin."
                });
                toastEvent.fire();
                component.set("v.IsSpinner",false);
            }
        });        
        var startTime = performance.now();
        $A.enqueueAction(action);
        component.set("v.IsSpinner",true);     
    },
    
    
})