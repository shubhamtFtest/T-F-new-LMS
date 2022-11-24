({
    
    init: function (cmp, event, helper) {
        
        cmp.set('v.columns', [
            { label: 'DOI', fieldName: 'doi', type: 'text', sortable: true , cellAttributes: { iconName: { fieldName: 'content_icon'}}},
            { label: 'Book', fieldName: 'journal', type: 'text', sortable: true },
            { label: 'Publication Date', fieldName: 'publication_date', type: 'text', sortable: true },
            { label: 'Chapter', fieldName: 'title', type: 'text', sortable: true },
            { label: 'Authors', fieldName: 'authors', type: 'text', sortable: true },
            { label: 'Publisher', fieldName: 'publisher', type: 'text', sortable: true }
            
        ]); 
        cmp.set("v.disableClasses",true);
        var action = cmp.get("c.getProductDetails");
        
        action.setParams({
            "prodId": cmp.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            
            cmp.set("v.prdDetails",result);          
            
            if(result != null && result.Unsilo_Class_Id__c != ''){
                cmp.set("v.classesId",result.Unsilo_Class_Id__c);
                cmp.set("v.storedClassesId",result.Unsilo_Class_Id__c);
            }
        });
        $A.enqueueAction(action);
        
        helper.loadCollections(cmp);
    },
    
    getUnsiloDocs : function (cmp, event,helper) {
        helper.getUnsiloXML(cmp, event);
    },
    
    addAllContent : function (cmp, event) {
        var action = cmp.get("c.addContents");
        var dataList = cmp.get("v.fullData");
        var clsId = cmp.get("v.classesId");
        var conType = cmp.get("v.contentType");
        
        action.setParams({
            "productID": cmp.get("v.recordId"),
            "contentsListJSON": JSON.stringify(dataList),
            "classId": clsId,
            "source": 'UNSILO',
            "type": conType
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                cmp.set("v.IsSpinner",false);
                cmp.set("v.storedClassesId",clsId);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Contents Added!",
                    "message": "All UNSILO Contents has been added "
                });
                toastEvent.fire(); 
                var enableButtonEvt = $A.get("e.c:PPDGenericEvent");
                enableButtonEvt.setParam("disableButton","ApprovalButton");
                enableButtonEvt.setParam("buttonValue",true);
                
                enableButtonEvt.fire();
                var newEvent = $A.get("e.c:PPDRefreshListEvent");
                newEvent.setParam("listToRefresh","UnsiloList");
                newEvent.fire();
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
        cmp.set("v.IsSpinner",true);
        
    },
    
    resetClassId : function (cmp, event){
        
        if (event.getParam("listToRefresh") !== undefined && event.getParam("listToRefresh") == "UnsiloListDelete") {
            cmp.set("v.storedClassesId",'');
        }
    },
    
    
    //Pagination and Sorting
    sortColumn: function(component, event, helper) {       
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    },
    
    renderPage:function(component, event, helper)
    {
        helper.renderPage(component);
    },
    
    onCollectionChange: function (cmp, evt, helper) {
        var selectedVal = cmp.find('collectionSelect').get('v.value');
        console.log('collectionId : '+selectedVal);
        if(selectedVal && selectedVal != '--None--'){
            helper.loadClasses(cmp, selectedVal);
            cmp.set("v.disableClasses",false);
        }else if(selectedVal && selectedVal == '--None--'){
            cmp.set("v.classesId",'');
            cmp.set("v.exportId",'');
            cmp.set("v.classes",[]);
            cmp.set("v.disableClasses",true);
        }
    },
    
    onClassChange: function (cmp, evt, helper) {
        var selectedVal = cmp.find('classSelect').get('v.value');
        if(selectedVal && selectedVal != '--None--'){
            // var valArr = selectedVal.split("||");
            
            cmp.set("v.classesId",selectedVal);
            //  cmp.set("v.exportId",valArr[1]);
            // console.log('classId1 : '+valArr[0]);
            console.log('classId : '+selectedVal);
            
            helper.getExportId(cmp, evt, selectedVal);
            
        }else if(selectedVal && selectedVal == '--None--'){
            cmp.set("v.classesId",'');
            cmp.set("v.exportId",'');
        }
    }
    
})