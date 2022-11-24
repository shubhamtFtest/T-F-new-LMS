({
    init: function (component,event,helper) {
        /*var items = [];
        for (var i = 0; i < 15; i++) {
            var item = {
                "label": "Option " + i,
                "value": "opt" + i,
            };
            items.push(item);
        }
        cmp.set("v.options", items);
        // "values" must be a subset of values from "options"
        cmp.set("v.values", ["opt10", "opt5", "opt7"]);*/
        var value=component.get("v.backToProductDetail");
        console.log('data 123:='+value);
        
            helper.getNetbasesHelper(component, event);
        
        
    },
    
    handleChange: function (component,event,helper) {
        // This will contain an array of the "value" attribute of the selected options
        var selectedOptionValue = event.getParam("value").toString();
        var appEvent = $A.get("e.c:TF_AG_SendSelectNetbaseEvt");
        appEvent.setParams({
            "selectedNetbases" : selectedOptionValue});
        appEvent.fire();
    },
    searchNetbases:function(component,event,helper){
        //component.set("v.disableSearch",true);
        var values=component.get("v.values");
        component.set("v.selectedNetbaseValues",values);
        helper.getNetbasesFilterHelper(component,event);
    },
    filterNetbaseEnter:function(component,event,helper){
        helper.checkFilterDataValidationsOnEnter(component,event);
    },
    displayCount:function(component,event,helper){
        helper.getDisplayCount(component,event);
    },
    checkAllNetbase:function(component,event,helper){
        var lstNetbase=component.get("v.lstNetbases");
        var lstCheckedValuesListBox=component.get("v.checkedValuesListBox");
        console.log('lstNetbase---->'+JSON.stringify(lstNetbase));
        var codeData=[];
        for(var i=0;i<lstNetbase.length;i++){
            lstNetbase[i].isSelected=true;
            codeData.push(lstNetbase[i]);
        }
        console.log(codeData.length);
        //var gets=codeData.concat(lstCheckedValuesListBox);
        //console.log('listData--'+JSON.stringify(gets));
        component.set("v.lstNetbases",codeData)
       
        /*var appEvent = $A.get("e.c:TF_AG_SendSelectListValueEvt");
        appEvent.setParams({
            "selectedSubjectListValues" : gets});
        appEvent.fire();*/
        helper.getDisplayCount(component,event);
    },
    unCheckAllNetbase:function(component,event,helper){
        var lstNetbase=component.get("v.lstNetbases");
        var codeData=[];
        for(var i=0;i<lstNetbase.length;i++){
            lstNetbase[i].isSelected=false;
            codeData.push(lstNetbase[i]);
        }
        console.log('lstNetbase---->'+JSON.stringify(lstNetbase));
       
        component.set("v.lstNetbases",codeData)
    	helper.getDisplayCount(component,event);
    },
    viewSelectedCodes:function(component,event,helper){
        var isChecked=event.getSource().get("v.checked");
        if(component.get("v.countSelected") !== 0){
            component.set("v.isViewSelected",isChecked);
        }
        else{
            helper.showToastMessage(component,event,'Nothing is selected','Alert','error');
            event.getSource().set("v.checked",false)
        }
    },
    resetNetbase:function(component,event,helper){
         var action =component.get("c.unCheckAllNetbase");
         $A.enqueueAction(action);
         component.set("v.countSelected",'0');
         component.set("v.term",'');
         var getAction=component.get("c.searchNetbases");
          $A.enqueueAction(getAction);
    },
    
})