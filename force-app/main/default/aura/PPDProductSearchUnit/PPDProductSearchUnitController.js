({  
    
    init: function (cmp, event,helper) {
        cmp.set("v.selectedFieldVal",cmp.get("v.selectedType"));
        //alert( cmp.get("v.selectedFieldVal"));
        console.log('consumer3======:'+cmp.get("v.consumer"));
        var resetObj = [];
        cmp.set("v.hasChild1",'false');
        cmp.set("v.hasChild2",'false');
        cmp.set("v.fileUpload",'false');
        cmp.set("v.hasOperator",'false');
        cmp.set("v.typeOfField",'');
        
        cmp.set("v.optionsLevel1",resetObj);
        cmp.set("v.optionsLevel2",resetObj);
        cmp.set("v.optionsLevel3",resetObj);
        cmp.set("v.inputOptions",resetObj);
        cmp.set("v.condition",resetObj);
        cmp.set("v.queryObject",resetObj);
        cmp.set("v.value1",'');
        cmp.set("v.value2",'');
        cmp.set("v.value3",'');
        cmp.set("v.valueOp",'');
        cmp.set("v.selectedList",resetObj);
        
        console.log("selectedType has changed");
        console.log("old value: " + event.getParam("oldValue"));
        console.log("current value: " + event.getParam("value"));
        if(event.getParam("value") == 'book'){
            cmp.set("v.typeChangedToBook",true);
        }else{
             cmp.set("v.typeChangedToBook",false);
        }
        
        helper.loadValues(cmp,'level1'); 
    },
    
    handleChangelevel1: function (cmp, event,helper) { 
        var resetObj = [];
        cmp.set("v.selectedList",resetObj);
        cmp.set("v.value2",'');
        cmp.set("v.value3",'');
        cmp.set("v.hasChild2",'false');
        cmp.set("v.valueInp",'');
        cmp.set("v.AllSelectedOptions",resetObj);
        
        var selectedOption = event.getParam("value");
        var level1data = cmp.get("v.optionsLevel1");
        var selectedOpts = cmp.get("v.AllSelectedOptions");
        console.log('SelectedType: ' , selectedOpts);
        var getLevel = 'level2';
        for(var attr of level1data){
            if(attr.value == selectedOption){
                if(cmp.get("v.selectedType") == 'Identifiers'){
                    cmp.set("v.identifier", attr.label);
                }
                selectedOpts.push(attr);
                cmp.set("v.typeOfField",attr.dataType);
                console.log('TypeOfField: ' , cmp.get("v.selectedType") + ' ' + attr.label);
                
                if(attr.dataType){
                    getLevel = 'finalValue' ;
                }
                if(attr.hasChild == true){
                    cmp.set("v.hasChild1",'true');
                }else{
                    cmp.set("v.hasChild1",'false');
                }
                if(attr.hasOperator == true){
                    cmp.set("v.hasOperator",'true');
                    var pickValueLst = [];
                    var valueStr = attr.supportedOperator;
                    var valueLst = valueStr.split(",");
                    for(var val of valueLst){
                        var pickValue = {
                            label: '',
                            value: ''
                        }
                        pickValue.label = val;
                        pickValue.value = val;                    
                        pickValueLst.push(pickValue);
                    }
                    cmp.set("v.condition",pickValueLst);
                    cmp.set("v.valueOp",pickValueLst[0].value);
                }else{
                    cmp.set("v.hasOperator",'false');
                    if(attr.supportedOperator && attr.supportedOperator != ''){
                        cmp.set("v.valueOp",attr.supportedOperator);
                    }
                }
                if(attr.fileUpload == true){
                    
                    cmp.set("v.fileUpload",'true');
                }else{
                    cmp.set("v.fileUpload",'false');
                }
                
                /*   if(dotnotation is present){
                    var queryObject = [];
                    queryObject = component.get("v.queryObject");
                    var queryElement = {
                        type: 'criteria',
                        name: '',
                        value: [valueInp],
                        operatior: valueOp,
                    };
                    var queryElementLogical = {
                        type: 'logical',
                        logicalOpp: 'AND',
                    };
                    queryObject.push(queryElement);
                    queryObject.push(queryElementLogical);
                    component.set("v.queryObject",queryObject);


                }*/
            }
        }
        cmp.set("v.selectedFieldVal",selectedOption);
        cmp.set("v.AllSelectedOptions",selectedOpts);
        if(selectedOption == cmp.get("v.selectedType")){
            cmp.set("v.valueOp",'Equals');
            cmp.set("v.valueInp", selectedOption);
        }
        helper.loadValues(cmp,getLevel); 
    },
    
    handleChangelevel2: function (cmp, event,helper) { 
        var resetObj = [];
        cmp.set("v.value3",'');
        cmp.set("v.valueInp",'');
        cmp.set("v.selectedList",resetObj);
        var selectedOption = event.getParam("value");
        cmp.set("v.valueOp",'');
        var level2data = cmp.get("v.optionsLevel2");
        var getLevel = 'level3';
        var selectedOpts = cmp.get("v.AllSelectedOptions");
        var selectedOptstemp = [];
        selectedOptstemp.push(selectedOpts[0]);
        cmp.set("v.AllSelectedOptions",selectedOptstemp);
        selectedOpts = cmp.get("v.AllSelectedOptions");
        
        for(var attr of level2data){
            if(attr.value == selectedOption){
                selectedOpts.push(attr);
                if(attr.dataType){
                    getLevel = 'finalValue' ;
                }
                cmp.set("v.typeOfField",attr.dataType);
                if(attr.hasChild == true){
                    cmp.set("v.hasChild2",'true');
                }else{
                    cmp.set("v.hasChild2",'false');
                }
                if(attr.hasOperator == true){
                    cmp.set("v.hasOperator",'true');
                    var pickValueLst = [];
                    var valueStr = attr.supportedOperator;
                    var valueLst = valueStr.split(",");
                    for(var val of valueLst){
                        var pickValue = {
                            label: '',
                            value: ''
                        }
                        pickValue.label = val.trim();
                        pickValue.value = val.trim();                    
                        pickValueLst.push(pickValue);
                    }
                    cmp.set("v.condition",pickValueLst);
                    cmp.set("v.valueOp",pickValueLst[0].value);
                }else{
                    cmp.set("v.hasOperator",'false');
                }
                if(attr.fileUpload == true){
                    cmp.set("v.fileUpload",'true');
                }else{
                    cmp.set("v.fileUpload",'false');
                }
            }
        }
        
        cmp.set("v.selectedFieldVal",selectedOption);
        cmp.set("v.AllSelectedOptions",selectedOpts);
        
        helper.loadValues(cmp,getLevel); 
        
    },
    handleChangelevel3: function (cmp, event,helper) {
        var resetObj = [];
        cmp.set("v.selectedList",resetObj);
        cmp.set("v.valueOp",'');
        cmp.set("v.valueInp",'');
        var selectedOption = event.getParam("value");
        var level2data = cmp.get("v.optionsLevel3");
        var getLevel = 'finalValue';
        
        var selectedOpts = cmp.get("v.AllSelectedOptions");
        var selectedOptstemp = [];
        selectedOptstemp.push(selectedOpts[0]);
        selectedOptstemp.push(selectedOpts[1]);
        
        cmp.set("v.AllSelectedOptions",selectedOptstemp);
        selectedOpts = cmp.get("v.AllSelectedOptions");
        
        for(var attr of level2data){
            if(attr.value == selectedOption){
                selectedOpts.push(attr);
                
                if(attr.dataType){
                    getLevel = 'finalValue' ;
                }
                cmp.set("v.typeOfField",attr.dataType);
                if(attr.hasOperator == true){
                    cmp.set("v.hasOperator",'true');
                    var pickValueLst = [];
                    var valueStr = attr.supportedOperator;
                    var valueLst = valueStr.split(",");
                    for(var val of valueLst){
                        var pickValue = {
                            label: '',
                            value: ''
                        }
                        pickValue.label = val;
                        pickValue.value = val;                    
                        pickValueLst.push(pickValue);
                    }
                    cmp.set("v.condition",pickValueLst);
                    cmp.set("v.valueOp",pickValueLst[0].value);
                }else{
                    cmp.set("v.hasOperator",'false');
                }
                if(attr.fileUpload == true){
                    cmp.set("v.fileUpload",'true');
                }else{
                    cmp.set("v.fileUpload",'false');
                }
            }
        }
        
        cmp.set("v.selectedFieldVal",selectedOption);
        cmp.set("v.AllSelectedOptions",selectedOpts);
        
        helper.loadValues(cmp,getLevel); 
        
    },
    
    handleConditionChange: function (cmp, event) {      
        var selectedOptionValue = event.getParam("value");
         cmp.set("v.valueOp",selectedOptionValue);
        
        if(cmp.get("v.valueOp") != ''){
            var action = cmp.get('c.buildQuery');
            $A.enqueueAction(action);
        }
        //alert("Option selected with value: '" + selectedOptionValue + "'");
        //cmp.set("v.typeOfField",selectedOptionValue);
    },
    
    handleDependChange: function (cmp, event) {      
        var selectedOptionValue = event.getParam("value");
        //alert("Option selected with value: '" + selectedOptionValue + "'");
        //cmp.set("v.typeOfField",selectedOptionValue);
    },
    
    handleMultiSelectChange: function (component, event, helper) {
        //Get the Selected values   
        var selectedValues = event.getParam("value");
        
        component.set("v.valueInp", selectedValues.toString()); 
    },
    
    onMultiSelectChange: function(cmp) {
        var selectCmp = cmp.find("InputSelectMultiple");
        //var resultCmp = cmp.find("multiResult");
        //resultCmp.set("v.value", selectCmp.get("v.value"));
    },    
    
    handleSelectedListEvt:function (component, event){
        var value = event.getParam("selectedSubjectClassifys");
        for(var j in value){
            value[j]=value[j].labelValue;
        }
        console.log('event Listval='+JSON.stringify(value));
        //alert(JSON.stringify(value));
        component.set("v.multiResultList",value);
    },
    
    handleSelectedNetbaseEvt:function (component, event){
        var value = event.getParam("selectedNetbases");
        for(var j in value){
            value[j]=value[j].value;
        }
        component.set("v.multiResultCodes",value);
        //alert(value);
        console.log('event Codevalue='+JSON.stringify(value));
        console.log('event Codevalue get='+JSON.stringify(component.get("v.multiResultCodes")));
        
    },
    
    handleFilesChange : function (cmp, event) {
        
        var files = event.getSource().get("v.files");
        var reader = new FileReader();
        var base64 = 'base64,';
        var resetLst = [];
        
        reader.onload = function () {
            var fileContents = reader.result;
            var dataStart = fileContents.indexOf(base64) + base64.length;
            fileContents = fileContents.substring(dataStart);
            
            var jsonObject = atob(fileContents);
            var nonNullIds = [];
            // jsonObject = jsonObject.replace(/-/g,"");
            jsonObject = jsonObject.split(/\r?\n|\r/);
            for(var strId of jsonObject){
                if(strId.trim() != ""){
                    nonNullIds.push(strId.trim());
                }
            }
            if(nonNullIds && nonNullIds.length > 0 && nonNullIds.length <= 500){
                var val1 = cmp.get("v.valueInp");
                var val1and2 = '';
                if(val1){
                    var val1and2 = val1.concat(nonNullIds.toString());
                    cmp.set("v.valueInp",val1and2);
                }else{
                    cmp.set("v.valueInp",nonNullIds.toString());
                }
                val1 = null;
                val1and2 =null;
            }else if(nonNullIds && nonNullIds.length > 500){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "warning",
                    "message": "File contains more than 500 Ids."
                });
                toastEvent.fire();       
            }else if(!nonNullIds && nonNullIds.length == 1 && nonNullIds[0] == ""){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "warning",
                    "message": "No content in file."
                });
                toastEvent.fire();       
                errorMessage.set("v.value", 'No content in file'); 
            }
        };
        reader.readAsDataURL(files[0]);
        
    },
    
    handleAndOperatorClick: function (cmp, event) { 
        if(cmp.get("v.valueInp") && cmp.get("v.valueInp") != ''){
            var listAdd=cmp.get("v.items");   
            var last = listAdd[listAdd.length - 1];
            last=++last;
            listAdd.push(last);        
            cmp.set("v.items",listAdd);  
            //alert(cmp.get("v.valueInp"));
            //Building the query           
            
            //   $A.enqueueAction(cmp.get('c.BuildQueryOnAndClick'));
            
            
        }else{
            var msg = 'Please enter the value.';
            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "warning",
                "message": msg
            });
            toastEvent.fire();       
        }
        
    },
    
    handleRemoveOperatorClick: function (cmp, event) { 
        var val=cmp.get("v.index");   
        var listAdd=cmp.get("v.items");   
        var index = listAdd.indexOf(val);
        var length = listAdd.length;
        // alert(length);
        if(index>-1 && length!=1){
            listAdd.splice(index,1);   
        }
        cmp.set("v.items",listAdd);
        
        var queryObject = [];   
        cmp.set("v.queryObject",queryObject);
        var cmpEvent = cmp.getEvent("inputChangeEvt");
        cmpEvent.fire();
        
    },    
    
    buildQuery: function (cmp, event) { 
        console.log('=====v.valueInp====='+cmp.get("v.valueInp"));
        //alert(cmp.get("v.valueInp"));
        if(cmp.get("v.valueInp") && cmp.get("v.valueInp") != ''){
            var queryObject = [];   
            
            var queryElementBegin = {
                type: 'separatorBEGIN'
            };
            queryObject.push(queryElementBegin);
            cmp.set("v.queryObject",queryObject);
            
            var selectedOpts = cmp.get("v.AllSelectedOptions");
            var queryElementLogical = {
                type: 'logical',
                logicalOpp: 'AND'                        
            }; 
            for(var attr of selectedOpts){
                
                if(attr.dotNotation && attr.dotNotation != ''){
                    var queryElement = {
                        type: '',
                        name: '',
                        value: []                     
                    };
                    
                    queryElement.type = 'criteria';
                    queryElement.name = attr.dotNotation;
                    queryElement.queryLabel = attr.queryLabel;
                    queryElement.operatior = cmp.get("v.valueOp");
                   
                    if(attr.useValueFrom && (attr.useValueFrom == 'Self')){
                        queryElement.value = [attr.value];
                        queryElement.operatior = 'Equals';
                    }
                    else if(cmp.get("v.valueInp")=='drmy'){
                        queryElement.value=["drm"];
                        queryElement.operatior = 'Not Equals';
                    }
                    else{
                        /*if(cmp.get("v.typeOfField") == 'BISAC-Select'){
                            //alert('BISAC');
                            var action = cmp.get("c.getBISACList");
                            action.setParams({
                				"values": cmp.get("v.valueInp")
            				});
                        }*/
                        queryElement.value = [cmp.get("v.valueInp")];
                    }
                    
                    console.log('componentValue** ' , cmp.get("v.valueInp") + ' AttributeValue: ' + attr.value);
                    console.log('TypeOfField: ' + cmp.get("v.typeOfField"));
                    queryObject.push(queryElement);
                    queryObject.push(queryElementLogical);
                }
               
                
                
            }
            queryObject.pop();
            
            if(queryObject && queryObject.length > 0){
                var queryElementEnd = {
                    type: 'separatorEND'
                };
                queryObject.push(queryElementEnd);
            }
            
            cmp.set("v.queryObject",queryObject);
            
            /*   var queryObjectUnit = {
            productType:'',
            queryObject:[]
        }
        
        var queryObjectUnit = []; 
        
        queryObjectUnit.productType = cmp.get("v.selectedType");
        queryObjectUnit.queryObject = cmp.get("v.queryObject");
        
        cmp.set("v.queryObjectUnit",queryObjectUnit);*/
            
            console.log('=====queryObject12306====='+JSON.stringify(queryObject));
            var cmpEvent = cmp.getEvent("inputChangeEvt");
            cmpEvent.fire();
        }
        
        else{
            var queryObject = [];   
            cmp.set("v.queryObject",queryObject);
            var cmpEvent = cmp.getEvent("inputChangeEvt");
            cmpEvent.fire();
        }
    },
    
    onChangeInput: function(component, event, helper) {
       
        component.set("v.valueInp", component.get("v.valueInp") + component.get("v.timeStamp"));
}

    
})