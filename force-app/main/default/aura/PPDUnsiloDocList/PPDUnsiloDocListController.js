({
    init: function (cmp, event, helper) {
        //start change by Geetika- PCH-3886
        var recordID = cmp.get("v.recordId");
        var action = cmp.get("c.collectionStatus");
        action.setParams({ 
            "recordID":recordID
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('status: ' + state);
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                cmp.set("v.isCollectionFree", result);
                console.log('getCollectionStatus***: ' + result);
                if(cmp.get("v.isCollectionFree")==true){
                cmp.set('v.columns', [
                { label: 'DOI/UUID', fieldName: 'doi', type: 'text', sortable: true },
                { label: 'Book', fieldName: 'journal', type: 'text', sortable: true },
                { label: 'Publication Date', fieldName: 'publication_date', type: 'text', sortable: true },
                { label: 'Chapter', fieldName: 'title', type: 'text', sortable: true },
                { label: 'Authors', fieldName: 'authors', type: 'text', sortable: true },
                { label: 'Publisher', fieldName: 'publisher', type: 'text', sortable: true },
                { label: 'Free Access', fieldName: 'Open_access', type: 'boolean', sortable: false},
                { label: 'Type', fieldName: 'type', type: 'text',sortable: true },
                { label: 'Source', fieldName: 'source', type: 'text', sortable: true },
                { label: 'ValidationResult', fieldName: 'validationResult', type: 'text', sortable: true } ]);
          
           } else if(cmp.get("v.isCollectionFree")==false){
                cmp.set('v.columns', [
                { label: 'DOI/UUID', fieldName: 'doi', type: 'text', sortable: true },
                { label: 'Book', fieldName: 'journal', type: 'text', sortable: true },
                { label: 'Publication Date', fieldName: 'publication_date', type: 'text', sortable: true },
                { label: 'Chapter', fieldName: 'title', type: 'text', sortable: true },
                { label: 'Authors', fieldName: 'authors', type: 'text', sortable: true },
                { label: 'Publisher', fieldName: 'publisher', type: 'text', sortable: true },
                { label: 'Free Access', fieldName: 'Open_access', type: 'boolean', sortable: false, editable : 'true'},
                { label: 'Type', fieldName: 'type', type: 'text',sortable: true },
                { label: 'Source', fieldName: 'source', type: 'text', sortable: true },
                { label: 'ValidationResult', fieldName: 'validationResult', type: 'text', sortable: true } ]);
          
            }
                
            }
            
            
        });
        $A.enqueueAction(action); //end change- Geetika - PCH-3886
        
        if((cmp.get("v.IsRecordLocked")=='true') && (cmp.get("v.collectionType") == 'Rule based')){
            
            cmp.set("v.hideCheckbox",false); 
        }
        else if((cmp.get("v.IsRecordLocked")=='false')&& (cmp.get("v.collectionType") == 'Rule based'))
        {
            cmp.set("v.hideCheckbox",true);
        }     
        
        console.log("additionCalledFrom: " + cmp.get('v.additionType'));
        var resetPageIndex = true;
        cmp.set("v.pagesPerQuery", cmp.get("v.queryLimit")/cmp.get("v.pageSize"));
        cmp.set("v.showingProceed",'true');    
        helper.fetchTitles(cmp, resetPageIndex);
    },
    
    deleteAllUnsiloRecords : function(component, event, helper) { 
        var toggleTxt = component.find("dispMsg");        
        $A.util.addClass(toggleTxt, "hideCmp");
        $A.util.removeClass(toggleTxt, "showCmp"); 
        helper.deleteAllTitles(component, event);  
        component.set("v.showManage",'false');
        component.set("v.showingSelectiveDel",'false');
        component.set("v.radioValue",'option1')
        var newEvent = $A.get("e.c:PPDTitleRefreshEvent");
        newEvent.fire();
    },
    
    refreshChild: function(cmp, event, helper) {
        if (event.getParam("listToRefresh") !== undefined && event.getParam("listToRefresh") == "UnsiloList") {
            var resetPageIndex = true;
            cmp.set("v.isValidDone",'false');
            cmp.set("v.showingProceed",'true'); 
            cmp.set("v.showingConsent",'false');
            cmp.set("v.showingReorder",'false');
            cmp.set("v.showingSelectiveReorder",'false');
            helper.fetchTitles(cmp, resetPageIndex);
        }
        if (event.getParam("listToRefresh") !== undefined && event.getParam("listToRefresh") == "UnsiloListDelete") {
            var resetPageIndex = true;
            cmp.set("v.showingProceed",'true'); 
            cmp.set("v.showingConsent",'false');
            cmp.set("v.showingReorder",'false');
            cmp.set("v.showingSelectiveReorder",'false');
            helper.fetchTitles(cmp, resetPageIndex);
        }
        if (event.getParam("listToRefresh") !== undefined && event.getParam("listToRefresh") == "UnsiloListUpdate") {
            var resetPageIndex = false;
            cmp.set("v.showingProceed",'true'); 
            cmp.set("v.showingConsent",'false');
            cmp.set("v.showingReorder",'false');
            cmp.set("v.showingSelectiveReorder",'false');
            helper.fetchTitles(cmp, resetPageIndex);
        }
        cmp.set("v.pageNumber", 1);
        
    },
    
    showMsg: function(component, event, helper) {			            
        var toggleTxt = component.find("dispMsg");        
        $A.util.addClass(toggleTxt, "showCmp");
        $A.util.removeClass(toggleTxt, "hideCmp");
        component.set("v.showManage",'hideRadio');
        component.set("v.showingConsent",'true');
    },
    
    showMultiSelectMsg: function(component, event, helper) {
        helper.getAllSelectedIds(component, component.get("v.pageNumber"));
        var selcRows = component.get("v.selectedRows");
        var numOfRecsSelected = selcRows.length ;
        component.set("v.selectedRowCount",numOfRecsSelected); 
        
        if(numOfRecsSelected > 0){
            component.set("v.showManage",'hideRadio');
            component.set("v.showingConsent",'true');
            var toggleTxt = component.find("dispMultiMsg");        
            $A.util.addClass(toggleTxt, "showCmp");
            $A.util.removeClass(toggleTxt, "hideCmp");   
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "message": 'Select at least one record and try again.'
            });
            toastEvent.fire(); 
        }
        
    },
    
    showMultiSelectReorderMsg: function(component, event, helper) {
        helper.getAllSelectedIds(component, component.get("v.pageNumber"));
        var selcRows = component.get("v.selectedRows");
        var numOfRecsSelected = selcRows.length ;
        component.set("v.selectedRowCount",numOfRecsSelected); 
        
        if(numOfRecsSelected > 0){
            component.set("v.showManage",'hideRadio');
            component.set("v.showingConsent",'true');
            var toggleTxt = component.find("dispMultiReorderMsg");        
            $A.util.addClass(toggleTxt, "showCmp");
            $A.util.removeClass(toggleTxt, "hideCmp"); 
            //component.set("v.hideCheckbox",true);
        }else{
            var toastEvent = $A.get("e.force:showToast");
            // component.set("v.hideCheckbox",false);
            toastEvent.setParams({
                "message": 'Select at least one record and try again.'
            });
            toastEvent.fire(); 
        }
    },
    
    
    hideMsg: function(cmp, event, helper) {			            
        var toggleTxt = cmp.find("dispMsg");        
        $A.util.addClass(toggleTxt, "hideCmp");
        $A.util.removeClass(toggleTxt, "showCmp");
        var exitMng = cmp.get('c.exitManage');
        $A.enqueueAction(exitMng);
    },
    
    hideMsgDynamic : function(cmp, event, helper) {			            
        var toggleTxt = cmp.find("dispMsg");        
        $A.util.addClass(toggleTxt, "hideCmp");
        $A.util.removeClass(toggleTxt, "showCmp");
        var reset = [];
        cmp.set("v.allSelected",reset);
        cmp.set("v.selectedRows",reset);
        cmp.set("v.showingConsent",'false');
        var resetPageIndex = true;
        helper.fetchTitles(cmp, resetPageIndex);
    },
    
    hideMultiMsgDynamic: function(cmp, event, helper) {			            
        var toggleTxt = cmp.find("dispMultiMsg");        
        $A.util.addClass(toggleTxt, "hideCmp");
        $A.util.removeClass(toggleTxt, "showCmp");
        cmp.set("v.showingConsent",'false');
        var reset = [];
        cmp.set("v.allSelected",reset);
        cmp.set("v.selectedRows",reset);
        var resetPageIndex = true;
        helper.fetchTitles(cmp, resetPageIndex);
    },
    
    hideMultiMsg: function(cmp, event, helper) {			            
        var toggleTxt = cmp.find("dispMultiMsg");        
        $A.util.addClass(toggleTxt, "hideCmp");
        $A.util.removeClass(toggleTxt, "showCmp");
        cmp.set("v.showingConsent",'false');
        var exitMng = cmp.get('c.exitManage');
        $A.enqueueAction(exitMng);
        
    },
    
    hideMultiReorderMsg: function(cmp, event, helper) {			            
        var toggleTxt = cmp.find("dispMultiReorderMsg");        
        $A.util.addClass(toggleTxt, "hideCmp");
        $A.util.removeClass(toggleTxt, "showCmp");
        cmp.set("v.showingConsent",'false');
        cmp.set("v.showingSelectiveReorder",'false');
        var exitMng = cmp.get('c.exitManage');
        $A.enqueueAction(exitMng);
        
    },
    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    
    searchContentHandler: function(cmp, event, helper) {
        console.log('searchText: ' + event.getParam("searchText") + ' ' + event.getParam("calledFrom") + ' ' + cmp.get("v.additionType"));
        if (event.getParam("searchText") !== undefined && event.getParam("calledFrom") !== undefined && event.getParam("calledFrom") == cmp.get("v.additionType")) {
            var searchText=event.getParam("searchText");
            cmp.set("v.searchQueryText",searchText);
            
            if(searchText){
                cmp.set("v.showingAll","false");
                cmp.set("v.showingSearch","true");
                cmp.set("v.calledEvent","");
                cmp.set("v.pagesPerQuery",cmp.get("v.searchQueryLimit")/cmp.get("v.pageSize"));
                if(cmp.get("v.showingSelectiveDel") == 'true'){
                    cmp.set("v.calledEvent","selectAndDel");
                }else if(cmp.get("v.additionType") == 'Exclusion'){
                    cmp.set("v.calledEvent",'search');
                }else{
                    cmp.set("v.calledEvent",'');
                }
                helper.fetchSearchResult(cmp);
            }else{
                helper.resetSelectedIds(cmp);
                cmp.set("v.showingAll","true");
                cmp.set("v.showingSearch","false");
                cmp.set("v.pagesPerQuery", cmp.get("v.queryLimit")/cmp.get("v.pageSize"));
                cmp.set("v.pstn","0");
                cmp.set("v.paginationEvt","First");
                var resetPageIndex = true;
                if(cmp.get("v.showingSelectiveDel") == 'true'){
                    cmp.set("v.calledEvent","selectAndDel");
                }else{
                    cmp.set("v.calledEvent",'');
                }
                helper.fetchTitles(cmp, resetPageIndex);
            }
        }
    },
    
    
    handleSaveEdition: function (cmp, event, helper) {
        var draftValues = event.getParam('draftValues');  
        var IsRecordLocked=	cmp.get("v.IsRecordLocked");
        if(IsRecordLocked=='true'){
            helper.saveEdition(cmp, draftValues);
        }
        else
        {
            var msg = 'Record can not be updated since it is locked, Please contact system administrator!';
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "message": msg
            });
            toastEvent.fire(); 
            return;
            
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
    
    renderPage:function(cmp, event, helper)
    {
        var pgsPerQry = cmp.get("v.pagesPerQuery");
        var qryLimit = cmp.get("v.queryLimit");
        
        if(cmp.get("v.showingSearch") == "false"){
            if(cmp.get("v.pageNumber") == 1 && cmp.get("v.prevClked") == 'false') {
                cmp.set("v.pstn","0");
                cmp.set("v.paginationEvt","First");
                helper.fetchTitles(cmp, resetPageIndex);
            }else if(cmp.get("v.pageNumber") % pgsPerQry == 1 && cmp.get("v.nxtClked") == 'true') {
                var pos = cmp.get("v.nexPstn");
                cmp.set("v.pstn",pos);
                cmp.set("v.paginationEvt",'Next');
                var resetPageIndex = true;
                helper.fetchTitles(cmp, resetPageIndex);
            }else if(cmp.get("v.pageNumber") % pgsPerQry == 0 && cmp.get("v.prevClked") == 'true') {
                var pos = cmp.get("v.prvPstn");
                cmp.set("v.pstn",pos); 
                cmp.set("v.paginationEvt",'Prev');
                var resetPageIndex = true;
                helper.fetchTitles(cmp, resetPageIndex);
            }else if(cmp.get("v.pageNumber") == cmp.get("v.maxPage") && cmp.get("v.nxtClked") == 'false'){
                cmp.set("v.pstn", 0);
                cmp.set("v.paginationEvt",'Last');
                if(cmp.get("v.recordCount") % cmp.get("v.queryLimit") == 0){
                    cmp.set("v.lastPgLmt", cmp.get("v.queryLimit"));
                }else{
                    cmp.set("v.lastPgLmt", cmp.get("v.recordCount") % cmp.get("v.queryLimit"));
                }
                helper.fetchTitles(cmp, resetPageIndex);
            }else{
                helper.renderPage(cmp);
            }
        }else{
            helper.renderPage(cmp);
        }
    },
    
    submitUnsiloCollection : function(component, event, helper) { 
        helper.submitCollection(component, event);  
    },
    
    validateAllLineItm: function(component, event, helper) {
        if (event.getParam("calledFor") !== undefined && event.getParam("calledFor") == component.get('v.additionType')){
            helper.validateAllLineItmHlpr(component, event, helper);
            var valProgressEvt = $A.get("e.c:PPDProgressEvent");
            valProgressEvt.setParam("showStatusBar",true);
            valProgressEvt.setParam("progressPercent",0);
            valProgressEvt.setParam("progressFor",'Validation Progress Status :');
            
            valProgressEvt.fire();
        }
    },
    
    validateAllLineItmEvt: function(component, event, helper) {      
        if (event.getParam("validateAllItems") !== undefined && event.getParam("validateAllItems") == true && event.getParam("validationFor") !== undefined && event.getParam("validationFor") == component.get('v.additionType')){
            helper.validateAllLineItmHlpr(component, event, helper);
        }else if (event.getParam("showValidationResult") !== undefined && event.getParam("showValidationResult") == true) {
            var searchText="";
            component.set("v.searchQueryText",searchText);
            component.set("v.showingSearch","true");
            component.set("v.showingAll","false");
            component.set("v.calledEvent","Validation");
            component.set("v.pagesPerQuery",component.get("v.searchQueryLimit")/component.get("v.pageSize"));
            component.set("v.showingValidation", "true");
            
            helper.fetchSearchResult(component);
        }
    },
    
    showAllContent: function (cmp, event, helper) {
        
        var resetPageIndex = true;
        cmp.set("v.showingValidation", "false");
        cmp.set("v.showingAll","false");
        cmp.set("v.pagesPerQuery", cmp.get("v.queryLimit")/cmp.get("v.pageSize"));
        helper.fetchTitles(cmp, resetPageIndex);
    },
    
    rowSelected: function (cmp, event, helper) {
        var rowsSelected = event.getParam('selectedRows');
        //helper.getAllSelectedIds(cmp);
        var preselectedRows = cmp.get("v.selectedRows");
        if(cmp.get("v.showingConsent") == 'true'){
            cmp.set("v.selectedRows",preselectedRows);
        }
        if(rowsSelected.length > 0 || (preselectedRows != undefined && preselectedRows.length > 0)){
            cmp.set("v.disableDelSelected",false);
        } else{
            cmp.set("v.disableDelSelected",true);
        }
    },
    
    deleteSelectedContent: function (cmp, event, helper){
        var toggleTxt = cmp.find("dispMultiMsg");        
        $A.util.addClass(toggleTxt, "hideCmp");
        $A.util.removeClass(toggleTxt, "showCmp");
        cmp.set("v.showManage",'false');
        cmp.set("v.showingSelectiveDel",'false');
        cmp.set("v.radioValue",'option1');
        cmp.set("v.hideCheckbox",true);
        cmp.set("v.nxtClked", 'fasle');
        // cmp.set("v.pageNumber",1);
        cmp.set("v.pstn","0");
        cmp.set("v.paginationEvt","First");
        helper.delSelectedTitlesHlpr(cmp, event);
    },
    
    moveSelectedContent: function (cmp, event, helper){
        var toggleTxt = cmp.find("dispMultiReorderMsg");        
        $A.util.addClass(toggleTxt, "hideCmp");
        $A.util.removeClass(toggleTxt, "showCmp");
        cmp.set("v.showManage",'false');
        cmp.set("v.showingSelectiveDel",'false');
        cmp.set("v.radioValue",'option1');
        cmp.set("v.showingProceed",'true');
        cmp.set("v.hideCheckbox",true);
        cmp.set("v.nxtClked", 'fasle');
        // cmp.set("v.pageNumber",1);
        cmp.set("v.pstn","0");
        cmp.set("v.paginationEvt","First");
        helper.moveSelectedTitlesHlpr(cmp, event);
    },
    
    showManage: function(component, event, helper) {			            
        component.set("v.showManage",'true');
    },
    
    exitManage: function(cmp, event, helper) {	
        cmp.set("v.showManage",'false');
        cmp.set("v.showingSelectiveDel",'false');
        cmp.set("v.radioValue",'option1')
        cmp.set("v.hideCheckbox",true);
        cmp.set("v.showingConsent",'false');
        cmp.set("v.showingReorder",'false');
        cmp.set("v.showingProceed",'true');
        var reset = [];
        cmp.set("v.allSelected",reset);
        cmp.set("v.selectedRows",reset);
        
        var resetPageIndex = true;
        helper.fetchTitles(cmp, resetPageIndex);
    },
    
    exitReOrderManage: function(cmp, event, helper) {			            
        cmp.set("v.showManage",'false');
        cmp.set("v.showingSelectiveReorder",'false');
        cmp.set("v.radioValue",'option1')
        cmp.set("v.hideCheckbox",true);
        cmp.set("v.showingReorder",'false');
        cmp.set("v.showingProceed",'true');
        var reset = [];
        cmp.set("v.allSelected",reset);
        cmp.set("v.selectedRows",reset);
        var resetPageIndex = true;
        helper.fetchTitles(cmp, resetPageIndex);
    },
    
    proceedManageAction: function(cmp, event, helper) {
        if(cmp.get("v.radioValue") == 'option1'){
            cmp.set("v.hideCheckbox",true);
            cmp.set("v.showingSelectiveDel",'false');
            var consent = cmp.get('c.showMsg');
            $A.enqueueAction(consent);
        }else if(cmp.get("v.radioValue") == 'option2'){
            cmp.set("v.showingConsent",'false');
            cmp.set("v.hideCheckbox",false);
            cmp.set("v.showingSelectiveDel",'true');
            cmp.set("v.showManage",'hideRadio');
            var resetPageIndex = true;
            helper.fetchTitles(cmp, resetPageIndex);
        }        
    },
    
    proceedReorderAction: function(cmp, event, helper) {
        if(cmp.get("v.radioValue") == 'option3'){
            cmp.set("v.showingConsent",'false');
            cmp.set("v.hideCheckbox",false);
            cmp.set("v.showingSelectiveReorder",'true');
            cmp.set("v.showManage",'hideRadio');  
            cmp.set("v.showingReorder",'true');
            cmp.set("v.showingProceed",'false');
            
        } 
    },
    manageActionChange: function(cmp, event, helper) {
        if(cmp.get("v.radioValue") == 'option1'){
            cmp.set("v.showingReorder",'false');
            cmp.set("v.showingProceed",'true');          
        }else if(cmp.get("v.radioValue") == 'option2'){
            cmp.set("v.showingReorder",'false');
            cmp.set("v.showingProceed",'true');          
        } else if(cmp.get("v.radioValue") == 'option3'){
            cmp.set("v.showingReorder",'true');
            cmp.set("v.showingProceed",'false');
        }            
    },
    
    getPcmSearchDetails: function(component, event, helper) {         
            component.set("v.PCMSearchDetails",event.getParam("PCMSearchDetails"));
            console.log('###EventFiredFOrPCM###' + component.get("v.PCMSearchDetails"));
           
        }
 
    
})