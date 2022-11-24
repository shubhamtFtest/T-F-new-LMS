({
    
    init : function(cmp, event, helper) {        
        //alert(cmp.get("v.consumer")+ ' ' + 'DynamicSearch');
        var list=cmp.get("v.itemsDefault"); 
        var defaultVal = [];
        // var impFilVal = [{name: 'Open Access',value: 'abc'}];
        //  cmp.set('v.implicitFltrValues', impFilVal); 
       // cmp.set('v.implicitFltrValues', [{name: 'defaultName',value: 'defaultValue',prdType: 'defaultValue'}]);
        
        cmp.set('v.items', list);     
        cmp.set('v.creteriaSize', '1'); 
        cmp.set('v.queryObjectLst', defaultVal); 
        
        //var queryObjectUnit={};
        var queryObjectUnit = {
            productType:cmp.get('v.selectedType'),
            queryObject:[{type: 'separatorBEGIN'},{type: 'separatorEND'}]
        }
        cmp.set('v.queryObjectUnit', queryObjectUnit); 
        console.log('c2======'+JSON.stringify(queryObjectUnit));
        console.log('consumer2======:'+cmp.get("v.consumer"));
        
        helper.loadValues(cmp); 
        
    },
    
    handleTypeChange: function (cmp, event) {      
        var selectedType = event.getParam("value");
        cmp.set("v.selectedType",selectedType);
        
        var queryObjectUnit = {
            productType:cmp.get('v.selectedType'),
            queryObject:[{type: 'separatorBEGIN'},{type: 'separatorEND'}]
        }
        cmp.set('v.queryObjectUnit', queryObjectUnit); 
        
        var list=cmp.get("v.itemsDefault");             
        cmp.set('v.items', list); 
    },
    
    handleAddClick: function (cmp, event) {      
        cmp.set("v.activeCmp","True");
    },
    
    handleOrClick: function (cmp, event) {      
        cmp.set("v.activeCmp","True");
    },
    
    handleRemoveClick: function (cmp, event) {      
        cmp.set("v.activeCmp","False");
    },
    
    // to be used with each criteria unit 
    handleAndOperatorClick: function (cmp, event) {   
        var operatorList=cmp.get("v.operatorValue"); 
        operatorList.push('AND');     
        cmp.set("v.operatorValue",operatorList);
        
        var listAdd=cmp.get("v.items");   
        var last = listAdd[listAdd.length - 1];
        last=++last;
        listAdd.push(last);        
        cmp.set("v.items",listAdd);  
        
    },
    handleOrOperatorClick: function (cmp, event) {    
        var operatorList=cmp.get("v.operatorValue"); 
        operatorList.push('OR');     
        cmp.set("v.operatorValue",operatorList);
        
        
        
        var listAdd=cmp.get("v.items");   
        var last = listAdd[listAdd.length - 1];
        last=++last;
        listAdd.push(last);        
        cmp.set("v.items",listAdd);  
        
    },
    
    handleRemoveOperatorClick: function (cmp, event) { 
        //  var val = event.target.value;
        var val = event.getSource().get('v.value');
        
        var listAdd=cmp.get("v.items");   
        var index = listAdd.indexOf(val);
        var length = listAdd.length;
        // alert(length);
        if(index>-1 && length!=1){
            listAdd.splice(index,1);      
        }
        
        cmp.set("v.items",listAdd);  
        
    },
    
    resetSearch: function (cmp, event) { 
        var list=cmp.get("v.itemsDefault");             
        cmp.set('v.items', list); 
    },
    
    loopChildComp: function (cmp, event) {         
        var queryObjectUnit = {            
            productType:cmp.get('v.selectedType'),
            queryObject:[]
        }
        cmp.set('v.queryObjectUnit', queryObjectUnit);        
        var cmpInstance = cmp.find("ProductSearchUnit");
        var IdentifierType = cmp.get('v.selectedType');
        
        var fullObjArr = [];
        console.log('===cmpInstance.length c2==='+cmpInstance.length);
        
        if(cmpInstance && !cmpInstance.length){
            var objArr = cmpInstance.get("v.queryObject");   
            var implicitFltrSetting = cmp.get("v.implicitObjLst");
            
            var queryElementLogical = {
                type: 'logical',
                logicalOpp: 'AND'                        
            }; 
            fullObjArr = fullObjArr.concat(objArr);           
            fullObjArr.push(queryElementLogical);
            if(cmp.get('v.selectedType') == 'Identifiers'){
                IdentifierType = cmp.get("v.identifier");
            }
            
            //for collection type
            if(cmp.get('v.selectedType')=='collection' && (cmp.get('v.hubId')!=null|| cmp.get('v.hubId')!=undefined)){
                var objArrCollection=[];
                var queryElementBegin = {
                    type: 'separatorBEGIN'
                };
                objArrCollection.push(queryElementBegin);
                var queryElementLogical = {
                    type: 'logical',
                    logicalOpp: 'AND'                        
                }; 
                var queryElement = {
                    type: '',
                    name: '',
                    operatior:'',
                    value: []                     
                };
                
                queryElement.type = 'criteria';
                queryElement.name = '_id';
                queryElement.queryLabel = 'Id';
                queryElement.operatior = 'NOT IN'; 
                queryElement.value=[cmp.get('v.hubId')];
                
                objArrCollection.push(queryElement);                
                
                var queryElementEnd = {
                    type: 'separatorEND'
                };				
                
                objArrCollection.push(queryElementEnd);
                fullObjArr = fullObjArr.concat(objArrCollection);           
                fullObjArr.push(queryElementLogical);
            }//end of if
            
            if(implicitFltrSetting && implicitFltrSetting.length > 0){
                
                for(var i = 0; i < implicitFltrSetting.length; i++){
                    var objArrImplicit=[];
                    
                    var  impFilValLst =  cmp.get('v.implicitFltrValues'); 
                    var selectedType = cmp.get('v.selectedType');
                    var fltrValType = implicitFltrSetting[i].prdType;
                    if(selectedType.toUpperCase() == fltrValType.toUpperCase()){
                        
                        var queryElementBegin = {
                            type: 'separatorBEGIN'
                        };
                        var queryElementEnd = {
                            type: 'separatorEND'
                        };	
                        var queryElementLogical = {
                            type: 'logical',
                            logicalOpp: 'AND'                        
                        }; 
                        
                        objArrImplicit.push(queryElementBegin);
                        var queryElement = {
                            type: '',
                            name: '',
                            operatior:'',
                            value: []                     
                        };
                        
                        queryElement.type = 'criteria';
                        queryElement.name =implicitFltrSetting[i].dotNotation ;
                        queryElement.queryLabel = implicitFltrSetting[i].qryLabel;
                        queryElement.operatior = implicitFltrSetting[i].operatior; 
                        if(implicitFltrSetting[i].value){
                            queryElement.value=[implicitFltrSetting[i].value];
                        }
                        console.log('===impFilValLst==='+JSON.stringify(impFilValLst));
                        if(impFilValLst && impFilValLst.length > 0){
                            for (var impFilVal of impFilValLst) {
                                var userPassedName = impFilVal.name;
                                var userPassedPrdType = impFilVal.prdType;
                                var allowedFilertVals = implicitFltrSetting[i].qryLabel ;
                                if(userPassedName && allowedFilertVals && userPassedPrdType && (userPassedName.toUpperCase() == allowedFilertVals.toUpperCase()) && (userPassedPrdType.toUpperCase() == selectedType.toUpperCase())){
                                    queryElement.value=[impFilVal.value];
                                }
                            }
                        }
                        if(queryElement.value.length > 0){
                            objArrImplicit.push(queryElement);
                            objArrImplicit.push(queryElementEnd);
                            fullObjArr = fullObjArr.concat(objArrImplicit);           
                            fullObjArr.push(queryElementLogical);
                        }                        
                    }
                    queryElement = null;
                }
            }
            
            
        }//end of !comp.length      
        
        //more than one AND condition
        if(cmpInstance.length){
            
            if(cmp.get('v.selectedType') == 'Identifiers'){
                IdentifierType = cmp.get("v.identifier");
            }
            
            var implicitFltrSetting = cmp.get("v.implicitObjLst");
            
            for(var i = 0; i < cmpInstance.length; i++){
                var objArr = cmpInstance[i].get("v.queryObject");
                if(objArr && objArr.length > 0){
                    console.log('===ProductSearchUnitobjArr===c2'+JSON.stringify(objArr));
                    var queryElementLogical = {
                        type: 'logical',
                        logicalOpp: 'AND'                        
                    }; 
                    fullObjArr = fullObjArr.concat(objArr);
                    fullObjArr.push(queryElementLogical);
                }              
            } 
            
            if(implicitFltrSetting && implicitFltrSetting.length > 0){
                for(var i = 0; i < implicitFltrSetting.length; i++){
                var objArrImplicit=[];
                    var  impFilValLst =  cmp.get('v.implicitFltrValues'); 
                    var selectedType = cmp.get('v.selectedType');
                    var fltrValType = implicitFltrSetting[i].prdType;
                    if(selectedType.toUpperCase() == fltrValType.toUpperCase()){
                        
                        var queryElementBegin = {
                            type: 'separatorBEGIN'
                        };
                        var queryElementEnd = {
                            type: 'separatorEND'
                        };	
                        var queryElementLogical = {
                            type: 'logical',
                            logicalOpp: 'AND'                        
                        }; 
                        
                        objArrImplicit.push(queryElementBegin);
                        var queryElement = {
                            type: '',
                            name: '',
                            operatior:'',
                            value: []                     
                        };
                        
                        queryElement.type = 'criteria';
                        queryElement.name =implicitFltrSetting[i].dotNotation ;
                        queryElement.queryLabel = implicitFltrSetting[i].qryLabel;
                        queryElement.operatior = implicitFltrSetting[i].operatior; 
                        if(implicitFltrSetting[i].value){
                            queryElement.value=[implicitFltrSetting[i].value];
                        }
                        console.log('===impFilValLst==='+JSON.stringify(impFilValLst));
                        if(impFilValLst && impFilValLst.length > 0){
                            for (var impFilVal of impFilValLst) {
                                var userPassedName = impFilVal.name;
                                var userPassedPrdType = impFilVal.prdType;
                                var allowedFilertVals = implicitFltrSetting[i].qryLabel ;
                                if(userPassedName && allowedFilertVals && userPassedPrdType && (userPassedName.toUpperCase() == allowedFilertVals.toUpperCase()) && (userPassedPrdType.toUpperCase() == selectedType.toUpperCase())){
                                    queryElement.value=[impFilVal.value];
                                }
                            }
                        }
                        if(queryElement.value.length > 0){
                            objArrImplicit.push(queryElement);
                            objArrImplicit.push(queryElementEnd);
                            fullObjArr = fullObjArr.concat(objArrImplicit);           
                            fullObjArr.push(queryElementLogical);
                        }                        
                    }
                    queryElement = null;
                }
                
            }
            //for collection type
            if(cmp.get('v.selectedType')=='collection' && (cmp.get('v.hubId')!=null|| cmp.get('v.hubId')!=undefined)){
                var objArrCollection=[];
                var queryElementBegin = {
                    type: 'separatorBEGIN'
                };
                objArrCollection.push(queryElementBegin);
                var queryElementLogical = {
                    type: 'logical',
                    logicalOpp: 'AND'                        
                }; 
                var queryElement = {
                    type: '',
                    name: '',
                    operatior:'',
                    value: []                     
                };
                
                queryElement.type = 'criteria';
                queryElement.name = '_id';
                queryElement.queryLabel = 'Id';
                queryElement.operatior = 'NOT IN'; 
                queryElement.value=[cmp.get('v.hubId')];
                
                objArrCollection.push(queryElement);
                //objArrCollection.push(queryElementLogical);
                
                
                var queryElementEnd = {
                    type: 'separatorEND'
                };				
                
                objArrCollection.push(queryElementEnd);
                fullObjArr = fullObjArr.concat(objArrCollection);           
                fullObjArr.push(queryElementLogical);
            }//end of if            
            
            
        }//end of component.length        
        fullObjArr.pop();
        var queryElementBegin = {
            type: 'separatorBEGIN'
        };
        
        var queryElementEnd = {
            type: 'separatorEND'
        };
        
        fullObjArr.splice(0, 0, queryElementBegin);
        fullObjArr.push(queryElementEnd);
        
        console.log('c2'+JSON.stringify(queryObjectUnit));
        queryObjectUnit.productType = IdentifierType;
        queryObjectUnit.queryObject = fullObjArr ;
        cmp.set('v.queryObjectUnit',queryObjectUnit);
        console.log('c2'+JSON.stringify(cmp.get('v.queryObjectUnit')));
        queryObjectUnit = [];
        cmpInstance = [];
    }
    
})