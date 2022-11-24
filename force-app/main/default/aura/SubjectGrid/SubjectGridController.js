({ // eslint-disable-line
    init: function (cmp) {
        var selecteddData = cmp.get("v.checkedValuesListBox");
        var columns = [
            {
                type: 'text',
                fieldName: 'labelValue',
                label: '',
                
            }
            
        ];
        
        cmp.set('v.gridColumns', columns);
        
        
        var expandedRows = [];
        
        cmp.set('v.gridExpandedRows', expandedRows);
        
        var action = cmp.get("c.TreeGetSubjectClassifications2");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                debugger;
                if(response.getReturnValue() !== ''){
                    var Backdata = response.getReturnValue();
                    var DataAndlabelString = Backdata.split('$$$$$$$$$$');
                    var data = DataAndlabelString[0];
                    cmp.set('v.backEndLabel',JSON.parse(DataAndlabelString[1]));
                    var temojson = JSON.parse(JSON.stringify(data).split('childTree').join('_children'));
                    console.log(JSON.parse(temojson));
                    cmp.set('v.gridData', JSON.parse(temojson));
                    cmp.set('v.gridDataAll', JSON.parse(temojson));
                    debugger;
                    //var selecteddData = component.get("v.checkedValuesListBox");
                    
                    var a = selecteddData;
                    //a.push('17th Century Literature');
                    //var b = JSON.parse(a);
                    cmp.set('v.selectedIds',a);
                    
                    //console.log(response.getReturnValue());
                }
            }
        });
        $A.enqueueAction(action);
    },
    getState: function(cmp, event, helper) {
        cmp.set('v.currentExpandedRows', "");
        var treeGridCmp = cmp.find('treeGrid');
        cmp.set('v.currentExpandedRows', treeGridCmp.getCurrentExpandedRows().toString());
    },
    getSelectedRows: function(cmp, event, helper) {
        debugger;
        var treeData = cmp.get("v.gridData");
        
        var curRows = event.getParam('selectedRows');
        //helper.selectChildTree(cmp,curRows[0].recId,treeData);
        var appEvent = $A.get("e.c:TF_AG_SendSelectSubjectClassifyEvt");
        appEvent.setParams({
            "selectedSubjectClassifys" : curRows});
        appEvent.fire();
        
    },
    filterNetbaseEnter : function(cmp,event,helper){
        var treeData = cmp.get("v.gridDataAll");
        var searchValue = cmp.get("v.term");
        if(searchValue != '' && searchValue != undefined){
            var a =[];
            cmp.set("v.gridData",a);
            for(var i in treeData){
			helper.searchTree(cmp,treeData[i],searchValue);
            }
        }
        else{
            cmp.set("v.gridData",treeData);  
        }
    },
    expandAll : function(cmp,event,helper){
        			debugger;
    				var expandedRows = cmp.get('v.backEndLabel');
                    cmp.set('v.gridExpandedRows',expandedRows);
	},
    collapseAll : function(cmp,event,helper){
    				var expandedRows = [];
                    cmp.set('v.gridExpandedRows',expandedRows);
	},
       resetSubject: function(cmp, event, helper) {
          var action =cmp.get("c.init");
         $A.enqueueAction(action);
         cmp.set("v.term",'');
         var getAction=cmp.get("c.filterNetbaseEnter");
          $A.enqueueAction(getAction);
    },
    
    
    

});