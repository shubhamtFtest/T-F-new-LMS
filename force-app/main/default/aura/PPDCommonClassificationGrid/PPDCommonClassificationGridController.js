({ // eslint-disable-line
    init: function (cmp) {
        var selecteddData = cmp.get("v.checkedValuesListBox");
        var typeOfClassification=cmp.get("v.typeOfClassification");
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
        
        if(typeOfClassification=='Subject'){
            var action = cmp.get("c.TreeGetSubjectClassifications");
            action.setParams({
                "ClassificationType": typeOfClassification
            });
        } 
        else if(typeOfClassification=='Dewey'){
            var action = cmp.get("c.TreeGetDeweyClassifications");
        }else if(typeOfClassification=='WC_Code'){
            var action = cmp.get("c.TreeGetWC_Codes");
        } else if(typeOfClassification=='BISAC'){
            cmp.set("v.IsSpinner",true);
            var action = cmp.get("c.TreeGetSubjectClassifications");
            action.setParams({
                "ClassificationType": typeOfClassification
            });
        }
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            cmp.set("v.IsSpinner",false);
            if(state === 'SUCCESS'){
               
                if(response.getReturnValue() !== ''){
                    var Backdata = response.getReturnValue();
                    var DataAndlabelString = Backdata.split('$$$$$$$$$$');
                    var data = DataAndlabelString[0];
                    
                    cmp.set('v.backEndLabel',JSON.parse(DataAndlabelString[1]));
                    
    				var tempData = JSON.parse(JSON.stringify(data));
                    var temojson = JSON.parse(JSON.stringify(data).split('childTree').join('_children'));
                  	
                    cmp.set('v.gridData', JSON.parse(temojson));
                    cmp.set('v.gridDataAll', JSON.parse(temojson));
                    //var selecteddData = component.get("v.checkedValuesListBox");
                    
                    var a = selecteddData;
                    //a.push('17th Century Literature');
                    //var b = JSON.parse(a);
                    cmp.set('v.selectedIds',a);
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
        var treeData = cmp.get("v.gridData");
        var curRows = event.getParam('selectedRows');
        var typeOfClassification=cmp.get("v.typeOfClassification");
        var value=curRows;
		 var selectedData = [];
        
        for(var i in value){
             var subjectListval = value[i].labelValue;
            var subjectSplit = subjectListval.split(" - ");
            
            if(typeOfClassification=='Subject'){
               	value[i]=subjectSplit[0];
            } else if(typeOfClassification=='BISAC'){
            	selectedData[i]=subjectSplit[0];
            for ( var j = 0; j < treeData.length; j++ ){
                if (value[i].recId != undefined && treeData[j].recId != undefined && value[i].recId == treeData[j].recId ) {
                   
                    var childrenRecs = treeData[ j ][ '_children' ];
                    for ( var k = 0; k < childrenRecs.length; k++ ){
                        var codeList = childrenRecs[k].labelValue; 
                        var codesData = codeList.split(" - ") ;
                        selectedData.push(codesData[0]);  
                    }
                }
               
            }
            
        }
    }
        console.log('requestValue: ' + JSON.stringify(selectedData));
        if(typeOfClassification=='Subject'){
            cmp.set("v.valueInp",value.toString());
        }else if(typeOfClassification=='BISAC'){
            cmp.set("v.valueInp",selectedData.toString());
        }
        
        //alert("You Selected12:- " + value.toString()); 
        //helper.selectChildTree(cmp,curRows[0].recId,treeData);
        /*var appEvent = $A.get("e.c:TF_AG_SendSelectSubjectClassifyEvt");
        appEvent.setParams({
            "selectedSubjectClassifys" : curRows});
        appEvent.fire();*/
        
    },
    filterNetbaseEnter : function(cmp,event,helper){
        var treeData = cmp.get("v.gridDataAll");
        var searchValue = cmp.get("v.term");
        if(searchValue != '' && searchValue != undefined){
            var a =[];
            cmp.set("v.gridData",a);
            for(var i in treeData){
                helper.searchTree(cmp,treeData[i],searchValue,[]);
            }
        }
        else{
            cmp.set("v.gridData",treeData);  
        }
    },
    expandAll : function(cmp,event,helper){
        
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
        $A.enqueueAction(getAction);   },
    
    
    
    
});