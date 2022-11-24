({
    init : function(cmp, event, helper) {        
        var list=cmp.get("v.itemsDefault");             
        cmp.set('v.items', list);            
        //alert(cmp.get('v.consumer')+ ' ' + 'LandingPage');
        //cmp.set('v.implicitFltrValues', [{name: 'defaultName',value: 'defaultValue',prdType: 'defaultType'}]);
        
    },
    
    handleChange: function (cmp, event) {      
        
    },
    handleAddClick: function (cmp, event) {      
        var listAdd=cmp.get("v.items");   
        var last = listAdd[listAdd.length - 1];
        last=++last;
        listAdd.push(last);        
        cmp.set("v.items",listAdd);  
    },
    handleOrClick: function (cmp, event) {      
        var listAdd=cmp.get("v.items");   
        var last = listAdd[listAdd.length - 1];
        last=++last;
        listAdd.push(last);        
        cmp.set("v.items",listAdd);  
    },
    handleRemoveClick: function (cmp, event) {      
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
    handleSearchClick: function (cmp, event) {
        alert('Coming Soon!');
        //alert(cmp.get("v.items"));
    },
    
    handleResetClick: function (cmp, event) {
        var list=cmp.get("v.itemsDefault"); 
        var reset = [];
        cmp.set('v.items', reset);   
        cmp.set('v.items', list);   
        
        var event = $A.get("e.c:productSearchResetEvent");
        event.fire();
    },
    
    loopChildComp: function (cmp, event, helper) {         
        var queryObjectUnitLst = [];
        var defaultRtntype = 'book';
        var hasValidationError = 'false';
        var identifierValues='';
        
        
        
        cmp.set('v.queryObjectUnitLst', queryObjectUnitLst);  
        
        var cmpInstance = cmp.find("ProductDynamicSearch");
        var fullObjArr = [];
        console.log('===cmpInstance.length==='+cmpInstance.length);
        
        if(cmpInstance && !cmpInstance.length){
            var objArr = cmpInstance.get("v.queryObjectUnit");
            
            if(objArr.productType){    
                queryObjectUnitLst.push(objArr); 
            }
            if(!objArr.productType || objArr.queryObject.length <= 2){
                cmpInstance.set("v.missingValue",true);
                hasValidationError = 'true'
            }else{
                cmpInstance.set("v.missingValue",false);
            }
        }
        
        if(cmpInstance && cmpInstance.length){
            for(var i = 0; i < cmpInstance.length; i++){
                var objArr = cmpInstance[i].get("v.queryObjectUnit");
                if(!objArr.productType || objArr.queryObject.length <= 2){
                    cmpInstance[i].set("v.missingValue",true);
                    hasValidationError = 'true'
                }else{
                    cmpInstance[i].set("v.missingValue",false);
                }
            }
        }
        
        if(cmpInstance && cmpInstance.length){
            for(var i = 0; i < cmpInstance.length; i++){
                var objArr = cmpInstance[i].get("v.queryObjectUnit");
                console.log('===objArr1==='+JSON.stringify(objArr));
                console.log(objArr.productType + ' iteration number ' + i);
                if(objArr.productType){
                    console.log('===objArr==='+JSON.stringify(objArr));
                    console.log('===objArrproductType==='+JSON.stringify(objArr.productType));
                    queryObjectUnitLst.push(objArr);
                }
            }
        }
        console.log('queryObjectUnitLst======='+JSON.stringify(queryObjectUnitLst));
        
        if(queryObjectUnitLst.length>0 && hasValidationError == 'false'){
            defaultRtntype = queryObjectUnitLst[0].productType ;
            //alert(JSON.stringify(queryObjectUnitLst));
            for(var i = 0; i < queryObjectUnitLst[0].queryObject.length; i++){
                if(queryObjectUnitLst[0].queryObject[i].name=='identifiers.doi' || queryObjectUnitLst[0].queryObject[i].name=='identifiers.isbn'){
                    identifierValues=queryObjectUnitLst[0].queryObject[i].value;
                    
                }
                
            }
            if(identifierValues.toString().includes(',')){
                var identifierValuesList= identifierValues.toString().split(',');
            }
            else{
                var identifierValuesList= identifierValues.toString().split(/\r?\n|\r/);
            }
            cmp.set('v.queryObjectUnitLst',queryObjectUnitLst);
            queryObjectUnitLst = [];
            cmpInstance = [];
            
            var productSearchEvent = $A.get("e.c:PPDDynamicUiSearchEvent");
            cmp.set("v.activeAccordion",'result');
            
            productSearchEvent.setParams({
                'multiTypeQueryObject': cmp.get('v.queryObjectUnitLst'),
                'returnType': defaultRtntype,
                'identifierValues':identifierValuesList
            });
            productSearchEvent.fire();
            cmp.set("v.activeAccordion",'');
        }
        else{var toastEvent = $A.get("e.force:showToast");
             toastEvent.setParams({
                 "message": "Please select some criteria.",
                 "type": "warning"
             });
             toastEvent.fire();
            }
        
    }
    
})