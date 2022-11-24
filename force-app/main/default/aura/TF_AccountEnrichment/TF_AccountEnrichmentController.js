({
	calloutCtrl : function(component, event, helper) {
        var rinngoldId = component.get("v.ringgoldId");
        var recordId = component.get("v.recordId");
        component.set("v.Spinner", true);
        component.set("v.checkRetry", false);
        if(rinngoldId == null || rinngoldId == 'null'){
            helper.getRinggoldId(component);
        }
        helper.getResponse(component);
        
        var cols = [
            {label: 'Account Field', fieldName: 'fieldName', type: 'text'},
            {label: 'Salesforce Data', fieldName: 'sFData', type: 'text'},
            {label: '', fieldName: 'isEqualData', type: 'boolean', editable: true, initialWidth: 59},
            {label: 'Ringgold data', fieldName: 'ringGoldData', type: 'text'}
        ];
        component.set("v.tableCols", cols);
        
    },
    checkAllObject:function(component,event,helper){
        var lstObject=component.get("v.objectList");
        var lstCheckedValuesListBox=component.get("v.checkedValuesListBox");
        console.log('lstObject---->'+JSON.stringify(lstObject));
        var codeData=[];
        for(var i=0;i<lstObject.length;i++){
            lstObject[i].isEqualData=true;
            codeData.push(lstObject[i]);
        }
        console.log(codeData.length);
        component.set("v.objectList",codeData)
        component.set("v.draftValues",codeData);
       
    },
    clearDraftValues:function(component,event,helper){
        var lstObject=component.get("v.objectList");
        console.log('lstObject---->'+JSON.stringify(lstObject));
        var codeData=[];
        for(var i=0;i<lstObject.length;i++){
            if(lstObject[i].sFData == lstObject[i].ringGoldData){
                lstObject[i].isEqualData=true;
            }else{
                lstObject[i].isEqualData=false;
            }
            codeData.push(lstObject[i]);
        }
        console.log(codeData.length);
        component.set("v.objectList",codeData)
        component.set("v.draftValues",codeData);
        
    },
    updateAccountFields:function(component,event,helper){
        helper.updateAccountFields(component,event);
        
    },
     // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   },
    
 // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    }
})