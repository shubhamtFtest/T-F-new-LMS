({
    init: function (cmp, event, helper) {
        debugger;
        var inSalesforce = cmp.get("v.inSalesforce");
        //var uuids = cmp.get("v.uuId");
        var uuid = cmp.get("v.recordId");
       
        if(inSalesforce == true){
            cmp.set('v.columns', [
                { label: 'DOI/UUID', fieldName: 'Product_Doi__c', type: 'text', sortable: false },
                { label: 'Title', fieldName: 'Title__c', type: 'text', sortable: false },
                { label: 'Publication Date', fieldName: 'Publication_Date__c', type: 'text', sortable: false },
                { label: 'Authors', fieldName: 'Authors__c', type: 'text', sortable: false },
                { label: 'openAccess', fieldName: 'Open_access__c', type: 'text', sortable: false },
                { label: 'Publisher', fieldName: 'Publisher__c', type: 'text', sortable: false },
                { label: 'Type', fieldName: 'Type__c', type: 'text', sortable: false, editable : 'true'},
                { label: 'Source', fieldName: 'Source__c', type: 'text',sortable: false }]);
            var resetPageIndex = true; 
            helper.fetchBLIFromProduct(cmp, resetPageIndex);
        }else{
            cmp.set('v.columns', [
                { label: 'DOI/UUID', fieldName: 'doi', type: 'text', sortable: false },
                { label: 'Title', fieldName: 'title', type: 'text', sortable: false },
                { label: 'Publication Date', fieldName: 'publication_date', type: 'text', sortable: false },
                //{ label: 'Chapter/Article', fieldName: 'journal', type: 'text', sortable: false },
                { label: 'Authors', fieldName: 'authors', type: 'text', sortable: false },
                { label: 'Publisher', fieldName: 'publisher', type: 'text', sortable: false },
                { label: 'Free Access', fieldName: 'Open_access', type: 'boolean', sortable: false},
                //{ label: 'Free Access', fieldName: 'isFree', type: 'boolean', sortable: false, editable : 'true'},
                { label: 'Type', fieldName: 'type', type: 'text',sortable: false }]);
            //{ label: 'Source', fieldName: 'source', type: 'text', sortable: false }]);
            
            var resetPageIndex = true;   
            helper.fetchProductFromPCM(cmp, resetPageIndex); 
        }       
    },
    
    renderPage:function(cmp, event, helper)
    {
        debugger;
        console.log('prevClked == nxtClked  ' + cmp.get("v.prevClked") +'=='+ cmp.get("v.nxtClked"));
        
        var pgsPerQry = cmp.get("v.pagesPerQuery");
        var qryLimit = cmp.get("v.queryLimit");
        console.log('pageNumber=== pgsPerQry= )'+ cmp.get("v.pageNumber") +'=='+ pgsPerQry);
        
        if(cmp.get("v.pageNumber") == 1 && cmp.get("v.prevClked") == 'false') {
            cmp.set("v.pstn","0");
            
            //helper.fetchTitles(cmp, resetPageIndex);
            //helper.fetchPartsFromPCM(cmp, resetPageIndex);
            helper.renderPage(cmp);
        }else if(cmp.get("v.pageNumber") % pgsPerQry == 1 && cmp.get("v.nxtClked") == 'true') {
            var pos = Number(cmp.get("v.pstn")) + Number(qryLimit);
            cmp.set("v.pstn",pos);
            
            var resetPageIndex = true;
            helper.fetchPartsFromPCM(cmp, resetPageIndex);
        }else if(cmp.get("v.pageNumber") % pgsPerQry == 0 && cmp.get("v.prevClked") == 'true') {
            var pos = cmp.get("v.pstn");
            if(pos > 0){
                pos = pos - qryLimit;
            }
            cmp.set("v.pstn",pos);  
            
            var resetPageIndex = true;
            helper.fetchPartsFromPCM(cmp, resetPageIndex);
        }else if(cmp.get("v.pageNumber") == cmp.get("v.maxPage") && cmp.get("v.nxtClked") == 'false'){
            
            if(cmp.get("v.recordCount") % cmp.get("v.queryLimit") == 0){
                cmp.set("v.pstn", cmp.get("v.recordCount") - qryLimit);
                
            }else{
                cmp.set("v.pstn", cmp.get("v.recordCount") - (cmp.get("v.recordCount") % cmp.get("v.queryLimit")));                
            }
            //helper.fetchPartsFromPCM(cmp, resetPageIndex);
            helper.renderPage(cmp);
        }else{
            helper.renderPage(cmp);
        }
    },
    
    handleSelectedRow : function(cmp, event, helper){
        debugger;
        
        var rowsSelected = event.getParam('selectedRows');
        cmp.set("v.selectedData",rowsSelected);
        
        var preselectedRows = cmp.get("v.selectedRows");
        cmp.set("v.selectedRows",preselectedRows);
        
     
    },
    
    
    manageActionChange: function(cmp, event, helper) {
        debugger;
        if(cmp.get("v.radioValue") == 'option1'){
            cmp.set("v.showingProceed",'true');
            
        } else if(cmp.get("v.radioValue") == 'option2'){
            //cmp.set("v.hideCheckBox",false);
            cmp.set("v.showingProceed",'true');
        }            
    },
    deleteSelectedContent: function (component, event, helper){
        var toggleTxt = component.find("dispMultiMsg");        
        $A.util.addClass(toggleTxt, "hideCmp");
        $A.util.removeClass(toggleTxt, "showCmp");
        component.set("v.showManage",'false');
        component.set("v.showingSelectiveDel",'false');
        component.set("v.radioValue",'option1');
        component.set("v.hideCheckBox",true);
        component.set("v.nxtClked", 'fasle');
        component.set("v.pstn","0");
        component.set("v.paginationEvt","First");
        var showMng = component.get('c.showManage');
        $A.enqueueAction(showMng);   
        helper.delSelectedTitlesHlpr(component, event);
    },
    
    deleteAllRecords : function(component, event, helper) { 
        debugger;
        var toggleTxt = component.find("dispMsg");        
        $A.util.addClass(toggleTxt, "hideCmp");
        $A.util.removeClass(toggleTxt, "showCmp"); 
        helper.deleteAllTitles(component, event);
        component.set("v.showingRadio",'false');
        component.set("v.showManage",'true');
       
        component.set("v.showingSelectiveDel",'false');
        //component.set("v.radioValue",'option1')
        //var showMng = component.get('c.showManage');
        //$A.enqueueAction(showMng);  
        var newEvent = $A.get("e.c:PPDTitleRefreshEvent");
        newEvent.fire();
        component.set("v.showingProceed",'false');
    },
    showManage: function(component, event, helper) {			            
        component.set("v.showManage",'false');
        component.set("v.showingRadio",'true');
        component.set("v.showingBack",'true');
        component.set("v.showingProceed",'true');
        component.set("v.showingSelectiveDel",'false');
        
    },
    
    exitManage: function(component, event, helper) {			            
        component.set("v.showingBack",'false');
        component.set("v.showingRadio",'false');
        component.set("v.showingProceed",'false');
        component.set("v.showingSelectiveDel",'false');
        component.set("v.showManage",'true');
    },
    
    showMultiSelectReorderMsg: function(component, event, helper) {
        component.set("v.showManage",'hideRadio');
        component.set("v.showingConsent",'true');
        var toggleTxt = component.find("dispMultiReorderMsg");        
        $A.util.addClass(toggleTxt, "showCmp");
        $A.util.removeClass(toggleTxt, "hideCmp"); 
    },     
    
    proceedManageAction: function(cmp, event, helper) {
        if(cmp.get("v.radioValue") == 'option1'){
            debugger;
            cmp.set("v.hideCheckBox",true);
            cmp.set("v.showingRadio",'false');
            cmp.set("v.showingBack",'false');
            cmp.set("v.showingProceed",'false');
            var toggleTxt = cmp.find("dispMsg");        
            $A.util.addClass(toggleTxt, "showCmp");
            $A.util.removeClass(toggleTxt, "hideCmp");   
        }else if(cmp.get("v.radioValue") == 'option2'){
            cmp.set("v.hideCheckBox",false);
            cmp.set("v.showingProceed",'false');
            cmp.set("v.showingSelectiveDel",'true');
            cmp.set("v.showingRadio",'false');
        }        
    },
    
    showMultiSelectMsg: function(component, event, helper) {
        var selcRows = component.get("v.selectedData");
        var numOfRecsSelected = selcRows.length ;
        component.set("v.selectedRowCount",numOfRecsSelected); 
        
        if(numOfRecsSelected > 0){
            component.set("v.showManage",'false');
            component.set("v.showingBack",'false');
            component.set("v.showingRadio",'false');
            component.set("v.showingProceed",'false');
            component.set("v.showingSelectiveDel",'false');
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
    
    hideMultiMsg: function(cmp, event, helper) {			            
        var toggleTxt = cmp.find("dispMultiMsg");        
        $A.util.addClass(toggleTxt, "hideCmp");
        $A.util.removeClass(toggleTxt, "showCmp");
        cmp.set("v.hideCheckBox",true);
        var exitMng = cmp.get('c.exitManage');
        $A.enqueueAction(exitMng);        
    },
    refreshChild: function(cmp, event, helper) {
        debugger;
        if (event.getParam("listToRefresh") !== undefined && event.getParam("listToRefresh") == "UnsiloList") {
            var resetPageIndex = true;
            cmp.set("v.isValidDone",'false');
            cmp.set("v.showingProceed",'false'); 
            cmp.set("v.showingConsent",'false');
            cmp.set("v.showingReorder",'false');
            cmp.set("v.showingSelectiveReorder",'false');
            var resetPageIndex = true;   
            helper.fetchBLIFromProduct(cmp, resetPageIndex); 
        }
        if (event.getParam("listToRefresh") !== undefined && event.getParam("listToRefresh") == "UnsiloListDelete") {
            var resetPageIndex = true;
            cmp.set("v.showingProceed",'false'); 
            cmp.set("v.showingConsent",'false');
            cmp.set("v.showingReorder",'false');
            cmp.set("v.showingSelectiveReorder",'false');
            var resetPageIndex = true;   
            helper.fetchBLIFromProduct(cmp, resetPageIndex); 
        }
        if (event.getParam("listToRefresh") !== undefined && event.getParam("listToRefresh") == "UnsiloListUpdate") {
            var resetPageIndex = false;
            cmp.set("v.showingProceed",'false'); 
            cmp.set("v.showingConsent",'false');
            cmp.set("v.showingReorder",'false');
            cmp.set("v.showingSelectiveReorder",'false');
            var resetPageIndex = true;   
            helper.fetchBLIFromProduct(cmp, resetPageIndex); 
        }
        cmp.set("v.pageNumber", 1);
        
    },
    
    hideMsg: function(cmp, event, helper) {			            
        var toggleTxt = cmp.find("dispMsg");        
        $A.util.addClass(toggleTxt, "hideCmp");
        $A.util.removeClass(toggleTxt, "showCmp");
        cmp.set("v.hideCheckBox",true);
        var exitMng = cmp.get('c.exitManage');
        $A.enqueueAction(exitMng);        
    }
    
})