({
    doInit: function(component, event, helper) {
        component.set('v.columns', [{ label: 'Title', fieldName: 'Name', type: 'text'}]);
        helper.checkIfProductIsCloned(component, event, helper);
        helper.getTableColumns(component, event, helper);
        console.log('ConsumerName: ' , component.get("v.calledFrom"));
        if(component.get("v.calledFrom") == 'Titles'){
            //alert('called from title');
            helper.loadProducts(component,true); 
        }
        
        if(component.get("v.hideCheckboxColumn") == true && component.get("v.consumer") != 'Collections'){
            component.set("v.hideCheckbox",true);
        }
        
        
        var filterObject = {
            ISBN: '',
            title: '',
            author: '',
            doi: '',
            netbase: [],
            subjectList: [],
            mediumData: '',
            publishData: '',
            minPrice: '',
            maxPrice: '',
            sortBy: '',
            sortOrderFieldName: 'UnitPrice',
            drmData: '',
            currencyTypeData: '',
            firstPubYearDataFrom: '',
            firstPubYearDataTo: '',
            textType: '',
            publisherImprint: '',
            publcFromDate: '',
            publcToDate: ''
        };
        
        var queryElement = {
            type: '',
            name: '',
            value: [],
            operatior: '',
            position: 1,
            logicalOpp: '',
            logicalOppStartPosLeft: 0,
            logicalOppEndPosLeft: 0,
            logicalOppStartPosRight: 0,
            logicalOppEndPosRight: 0
        };
        
        var querySaveElement = {
            filterObject: {},
            ruleElementLst : [],
            multiTypeRulesLst : [],
            queryString: '',
            jsonString: '',
            isDynamicUi:'true'
            //savedCurrentStep:''
            
        };
        
        component.set("v.querySaveElement", querySaveElement);
        component.set("v.filterObject", filterObject);
        component.set("v.queryElement", queryElement);
        
        if(component.get("v.typeOfCollection") == 'Manual Curation'){
            component.set("v.isStatic",true);
        }else if(component.get("v.typeOfCollection") == 'Rule based'){
            component.set("v.isStatic",false);
            component.set("v.hideCheckbox",true);
        }
        
    },
    
    productFilterChangeHandler : function(component, event, helper) {
        var clldFrom = component.get("v.calledFrom");
        if(clldFrom == 'ContentSelection'){
            var filterObject = component.get("v.filterObject");
            //var queryObject = component.get("v.queryObject");
            var queryObject = [];
            var filterObjectLst = component.get("v.filterObjectLst");
            
            var position = 0 ;
            var isbn = event.getParam("ISBN");
            var title = event.getParam("title");
            var doi = event.getParam("doi");
            var author = event.getParam("author");
            var netbase = event.getParam("netbase");
            var subjectList = event.getParam("subjectList");
            var mediumData = event.getParam("mediumData");
            var publishData = event.getParam("publishData");
            var sortOrderFieldName = event.getParam("sortOrderFieldName");
            var drmData = event.getParam("drmData");
            var currencyTypeData = event.getParam("currencyTypeData");
            var firstPubYearDataFrom = event.getParam("firstPubYearDataFrom");
            var firstPubYearDataTo = event.getParam("firstPubYearDataTo");
            var textType = event.getParam("textType") != 'choose one...' ? event.getParam("textType") : '';
            var publisherImprint = event.getParam("publisherImprint") != 'choose one...' ? event.getParam("publisherImprint") : '';
            var publcFromDate = event.getParam("publcFromDate");
            var publcToDate = event.getParam("publcToDate");
            var minPrice = event.getParam("minPrice");
            var sortBy = event.getParam("sortBy");
            var maxPrice = event.getParam("maxPrice");
            var netbaseCodeLst = [];
            var subjectCodeLst = [];            
            
            component.set("v.searchCurrency",currencyTypeData);
            
            //{name: 'sortBy',value: String(sortBy)},
            //{name: 'sortOrderFieldName',value: String(sortOrderFieldName)},
            
            component.set("v.productType",mediumData == 'e-Book' ? 'book' : mediumData == 'Collection' ? 'Collection' : 'book');
            mediumData = mediumData == 'e-Book' ? 'e-Book' : null;
            if(netbase != null && netbase.length > 0){
                for (var netbaseval of netbase) {
                    var netbaseSplit = netbaseval.split(" - ");
                    netbaseval = netbaseSplit[0];
                    netbaseCodeLst.push(netbaseval);
                }
            }
            
            if(subjectList != null && subjectList.length > 0){
                for (var subjectListval of subjectList) {
                    var subjectSplit = subjectListval.split(" - ");
                    subjectListval = subjectSplit[0];
                    subjectCodeLst.push(subjectListval);
                }
            }
            
            var filterObjectLst = [{name: 'isbn',value: String(isbn)},
                                   {name: 'title',value: String(title)},
                                   {name: 'doi',value: String(doi)},
                                   {name: 'author',value: String(author)},
                                   {name: 'netbase',value: netbaseCodeLst},
                                   {name: 'subject',value: subjectCodeLst},
                                   {name: 'format',value: String(mediumData)},
                                   {name: 'firstPubYearFrom',value: String(firstPubYearDataFrom)},
                                   {name: 'firstPubYearTo',value: String(firstPubYearDataTo)},
                                   {name: 'textType',value: String(textType)},
                                   {name: 'publisherImprint',value: String(publisherImprint)},
                                   {name: 'publcFromDate',value: String(publcFromDate)},
                                   {name: 'publcToDate',value: String(publcToDate)}
                                  ];
            
            if(drmData != 'Both'){
                var drm = {name: 'drm',value: String(drmData)} ;
                filterObjectLst.push(drm);
            }
            
            if((minPrice != null && minPrice) || (maxPrice != null && maxPrice)){
                var currencyType = {name: 'currency',value: String(currencyTypeData)};
                var minPriceObj = {name: 'minPrice',value: String(minPrice)};
                var maxPriceObj = {name: 'maxPrice',value: String(maxPrice)};
                filterObjectLst.push(minPriceObj);
                filterObjectLst.push(maxPriceObj);
                filterObjectLst.push(currencyType);
            }
            
            
            for (var filterElement of filterObjectLst) {
                if(filterElement.value != undefined && filterElement.value != 'undefined' && filterElement.value && filterElement.value != null && filterElement.value != '' && filterElement.value != 'null'){
                    // alert(filterElement.name +':'+ filterElement.value);
                    var queryElement = {
                        type: '',
                        name: '',
                        value: [],
                        operatior: '',
                        position: 1,
                        logicalOpp: '',
                        logicalOppStartPosLeft: 0,
                        logicalOppEndPosLeft: 0,
                        logicalOppStartPosRight: 0,
                        logicalOppEndPosRight: 0
                    };
                    var queryElementLogical = {
                        type: '',
                        name: '',
                        value: [],
                        operatior: '',
                        position: 1,
                        logicalOpp: '',
                        logicalOppStartPosLeft: 0,
                        logicalOppEndPosLeft: 0,
                        logicalOppStartPosRight: 0,
                        logicalOppEndPosRight: 0
                    };
                    
                    queryElement.type = 'criteria' ;
                    queryElement.name = filterElement.name ;
                    queryElement.value = [filterElement.value] ;
                    queryElement.operatior = "EQ"
                    
                    if(filterElement.name == 'netbase' || filterElement.name == 'subject'){
                        queryElement.value = filterElement.value ;
                        queryElement.operatior = "IN"
                    }
                    if(filterElement.name == 'minPrice'){
                        queryElement.value = [filterElement.value] ;
                        queryElement.operatior = "GE"
                    }
                    if(filterElement.name == 'maxPrice'){
                        queryElement.value = [filterElement.value] ;
                        queryElement.operatior = "LE"
                    }
                    if(filterElement.name == 'publcFromDate' || filterElement.name == 'firstPubYearFrom'){
                        queryElement.value = [filterElement.value] ;
                        queryElement.operatior = "GE"
                    }
                    if(filterElement.name == 'publcToDate' || filterElement.name == 'firstPubYearTo'){
                        queryElement.value = [filterElement.value] ;
                        queryElement.operatior = "LE"
                    }
                    queryElement.position = ++position ;
                    queryElement.logicalOpp = "" ;
                    queryElement.logicalOppStartPosLeft = 0;
                    queryElement.logicalOppEndPosLeft = 0;
                    queryElement.logicalOppStartPosRight = 0;
                    queryElement.logicalOppEndPosRight = 0;
                    queryObject.push(queryElement);
                    
                    queryElementLogical.type = 'logical' ;
                    queryElementLogical.name = '';
                    queryElementLogical.value = [];
                    queryElementLogical.operatior = '';
                    queryElementLogical.position = ++position ;
                    queryElementLogical.logicalOpp = "AND" ;
                    queryElementLogical.logicalOppStartPosLeft = 0;
                    queryElementLogical.logicalOppEndPosLeft = 0;
                    queryElementLogical.logicalOppStartPosRight = 0;
                    queryElementLogical.logicalOppEndPosRight = 0;
                    
                    queryObject.push(queryElementLogical);
                    
                }
            }
            queryObject.pop();
            
            
            console.log('queryObject1===='+JSON.stringify(queryObject));
            if (isbn !== undefined) {
                filterObject.ISBN = event.getParam("ISBN");
            }
            if (title !== undefined) {
                filterObject.title = event.getParam("title");
            }
            if (author !== undefined) {
                filterObject.author = event.getParam("author");
            }
            if (doi !== undefined) {
                filterObject.doi = event.getParam("doi");
            }
            if (netbase !== undefined) {
                filterObject.netbase = event.getParam("netbase");
            }
            if (subjectList !== undefined) {
                filterObject.subjectList = event.getParam("subjectList");
            }
            if (mediumData !== undefined) {
                filterObject.mediumData = event.getParam("mediumData");
            }
            if (publishData !== undefined) {
                filterObject.publishData = event.getParam("publishData");
            }
            if (minPrice !== undefined) {
                filterObject.minPrice = event.getParam("minPrice");
            }
            if (maxPrice !== undefined) {
                filterObject.maxPrice = event.getParam("maxPrice");
            }
            if (sortBy !== undefined) {
                filterObject.sortBy = event.getParam("sortBy");
            }
            if (sortOrderFieldName !== undefined) {
                filterObject.sortOrderFieldName = event.getParam("sortOrderFieldName");
            }
            if (drmData !== undefined) {
                filterObject.drmData = event.getParam("drmData");
            }
            if (currencyTypeData !== undefined) {
                filterObject.currencyTypeData = event.getParam("currencyTypeData");
            }
            if (firstPubYearDataFrom !== undefined) {
                filterObject.firstPubYearDataFrom = event.getParam("firstPubYearDataFrom");
            }
            if (firstPubYearDataTo !== undefined) {
                filterObject.firstPubYearDataTo = event.getParam("firstPubYearDataTo");
            }
            if (publcFromDate !== undefined) {
                filterObject.publcFromDate = event.getParam("publcFromDate");
            }
            if (publcToDate !== undefined) {
                filterObject.publcToDate = event.getParam("publcToDate");
            }
            if (publcToDate !== undefined) {
                filterObject.textType = textType;
            }
            if (publisherImprint !== undefined) {
                filterObject.publisherImprint = publisherImprint;
            }
            component.set("v.filterObject",filterObject);
            component.set("v.queryObject",queryObject);
            var resetPageIndex = true;   
            //resetting attributes for pagination
            component.set("v.pageNumber",1);
            component.set("v.pstn",0);
            component.set("v.isDynamicUI",'false');
            //alert('called from filter change');
            helper.loadProducts(component,resetPageIndex); 
        } 
    },
    
    dynamicUISearch : function(cmp, event, helper) {
        console.log("==========inside dynamicUISearch========="+JSON.stringify(event.getParam("multiTypeQueryObject")));
        console.log("==========inside dynamicUISearch========="+JSON.stringify(event.getParam("returnType")));
        var resetLst = [];
        cmp.set("v.availableIds",resetLst);
        cmp.set("v.uploadedIds",resetLst);   
        cmp.set("v.unAvailableIds",'');
        cmp.set("v.nxtClked", false);
        cmp.set("v.prevClked", false);
        cmp.set("v.lastClicked", false);
        cmp.set("v.firstClicked", false);
        cmp.set("v.showDownloadBtn","false");
        var infoMessage=cmp.find("infoMessage");
        infoMessage.set("v.value",'');
        var errorMessage= cmp.find("errorMessage");
        errorMessage.set("v.value", ''); 
        
        
        if(cmp.get("v.calledFrom") != 'Titles'){
            if(event.getParam("multiTypeQueryObject")){
                var resetPageIndex = true;   
                cmp.set("v.isDynamicUI",'true');
                cmp.set("v.pageNumber",1);
                cmp.set("v.pstn",0);
                cmp.set("v.queryObject",event.getParam("multiTypeQueryObject"));
                cmp.set("v.productType",event.getParam("returnType"));
                cmp.set("v.uploadedIds",event.getParam("identifierValues"));
                //alert('called from dynamic UI search');
                helper.loadProducts(cmp,resetPageIndex);
            }
        }
    },
    
    saveRule: function (component, event, helper) {
        var action = component.get("c.updateDynamicProductRule"); 
        //    var dynamicRule = component.get("v.filterObject");
        var querySaveElement = component.get("v.querySaveElement"); 
        querySaveElement.isDynamicUi = component.get("v.isDynamicUI");
        component.set("v.querySaveElement",querySaveElement);
        var recordID = component.get("v.recordId"); 
        console.log('=====querySaveElement======'+JSON.stringify(component.get("v.querySaveElement")));
        action.setParams({
            "bundleID":recordID,
            "rule": JSON.stringify(querySaveElement)
        });
        
        action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log('=======result===='+JSON.stringify(result));
                if(result != 'Error'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success",
                        "message": result
                    });
                    toastEvent.fire();
                    console.log('beforeevent');
                    var newEvent = $A.get("e.c:PPDRuleRefresh");
                    newEvent.fire();
                    
                    var totalPriceEvt = $A.get("e.c:PPDTotalPriceRefreshEvent");
                    console.log('totalPriceEvttotalPriceEvt' + totalPriceEvt);
                    console.log('component.get("v.totalPriceUSD")' + component.get("v.totalPriceUSD"));
                    console.log('component.get("v.totalPriceGBP")' + component.get("v.totalPriceGBP"));
                    totalPriceEvt.setParam("totalPriceUSD",component.get("v.totalPriceUSD"));
                    totalPriceEvt.setParam("totalPriceGBP",component.get("v.totalPriceGBP"));
                    totalPriceEvt.setParam("isStatic",'false');
                    
                    totalPriceEvt.fire();
                    
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Some error has occurred,Please contact your administrator!"
                    });
                    toastEvent.fire();
                }
                
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
                    "message": "Some error has occurred,Please contact your administrator!"
                });
                toastEvent.fire();
            }         
        });
        $A.enqueueAction(action);
        
    },
    
    refreshDynamicTitleList: function(component, event, helper) {
        if(component.get("v.calledFrom") == 'Titles'){
            //alert('called from refresh titles');
            helper.loadProducts(component,true); 
        }
    },//ContentSelection
    
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        switch (action.name) {
            case 'add':
                helper.addProduct(component, event);
                //To refresh PPDTileList
                var newEvent = $A.get("e.c:PPDTitleRefreshEvent");
                newEvent.fire();
                break;
        }
    },
    
    addMultipleProducts : function(component, event, helper) {
        var toggleTxt = component.find("dispMultiMsg");        
        $A.util.addClass(toggleTxt, "hideCmp");
        $A.util.removeClass(toggleTxt, "showCmp");
        
        component.set("v.showingConsent",'false');
        helper.addMultipleProducts(component, event);   
    },
    
    addAllProducts : function(component, event, helper) {
        
        var toggleTxtAll = component.find("dispMultiMsgAll");        
        $A.util.addClass(toggleTxtAll, "hideCmp");
        $A.util.removeClass(toggleTxtAll, "showCmp");
        
        component.set("v.showingConsent",'false');
        // hideMultiMsg(component, event, helper);
        helper.addMultipleProducts(component, event,'true');   
        
    },
    
    handleSelectedRow: function(component, event, helper) {
        var preselectedRows = component.get("v.selectedRows");
        if(component.get("v.showingConsent") == 'true'){
            component.set("v.selectedRows",preselectedRows);
        }
        component.set("v.selectedRowsCount", preselectedRows.length);
    },
    
    //Render Page
    renderPage:function(component, event, helper)
    {
        
        /*var checkSearch= component.get("v.IsSearch");
         alert(checkSearch);
        if(checkSearch == 'true'){
            helper.renderPageForSearch(component);
        }
        else if(checkSearch == 'false'){
            helper.renderPage(component);
        }*/
        /* if(component.get("v.isStatic")==true){
            helper.renderPage(component);
        }*/
        //For Rule Based Collections
        //  else if(component.get("v.isStatic")==false){           
        console.log('LastClicked: ', component.get("v.lastClicked") + '  **  ' + component.get("v.pageNumber") % pgsPerQry);
        console.log('prevClked == nxtClked  ' + component.get("v.prevClked") +'=='+ component.get("v.nxtClked"));            
        var pgsPerQry = component.get("v.pagesPerQuery");
        var qryLimit = component.get("v.queryLimit");
        //component.set("v.nxtClked", false);
        console.log('pageNumber=== pgsPerQry= )'+ component.get("v.pageNumber") +'=='+ pgsPerQry);
        
        if(component.get("v.pageNumber") == 1 && component.get("v.firstClicked") == 'true' ) {
			//alert('called from page1 Prev-False **  ' + component.get("v.pstn"));            
            component.set("v.pstn","0");   
            
            helper.loadProducts(component, resetPageIndex,'NoCount');
        }else if(component.get("v.pageNumber") % pgsPerQry == 1 && component.get("v.nxtClked") == 'true') {
            var pos = Number(component.get("v.pstn")) + Number(qryLimit);
            console.log('NextPayload: ' + JSON.stringify(component.get("v.queryObject")));
            component.set("v.pstn",pos);
            var resetPageIndex = true;   
			//alert('called from division1 and Next-True');            
            helper.loadProducts(component, resetPageIndex,'NoCount');
        }else if(component.get("v.pageNumber") % pgsPerQry == 0 && component.get("v.prevClked") == 'true') {
            var pos = component.get("v.pstn");
            if(pos > 0){
                pos = pos - qryLimit;
            }
            //alert('postion' + pos);
            component.set("v.pstn",pos);                
            var resetPageIndex = true;
            //alert('called from division0 and Prev-True');
            helper.loadProducts(component, resetPageIndex,'NoCount');
        }else if(component.get("v.pageNumber") == component.get("v.maxPage") && component.get("v.nxtClked") == 'false'){
            console.log('LastPageReached' , resetPageIndex);
            if(component.get("v.recordCount") % component.get("v.queryLimit") == 0){
                component.set("v.pstn", component.get("v.recordCount") - qryLimit);
                console.log('LastPageReached123' , resetPageIndex);
            }else{
                component.set("v.pstn", component.get("v.recordCount") - (component.get("v.recordCount") % component.get("v.queryLimit")));                
                console.log('LastPageReached456' , resetPageIndex);
            }
            //alert('called from maxPage and Next-False');
            helper.loadProducts(component, resetPageIndex,'NoCount');
        }else{
            //alert('else')
            helper.renderPage(component);
            
        }
        
        // }
    },
    
    
    
    showMultiSelectMsg: function(component, event, helper) {
        helper.getAllSelectedIds(component, component.get("v.pageNumber"));
        var selcRows = component.get("v.selectedRows");
        var numOfRecsSelected = selcRows.length ;
        component.set("v.selectedRowsCount",numOfRecsSelected); 
        
        if(numOfRecsSelected > 0){
            component.set("v.showingConsent",'true');
            var toggleTxt = component.find("dispMultiMsg");        
            $A.util.addClass(toggleTxt, "showCmp");
            $A.util.removeClass(toggleTxt, "hideCmp");   
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "message": "Please add atleast one product from the list!"
            });
            toastEvent.fire(); 
        }
        
    },
    
    showMultiSelectMsgAll: function(component, event, helper) {
        // alert('Add All Prd');
        helper.getAllSelectedIds(component, component.get("v.pageNumber"));
        var selcRows = component.get("v.selectedRows");
        var numOfRecsSelected = selcRows.length ;
        component.set("v.selectedRowsCount",numOfRecsSelected); 
        component.set("v.showingConsent",'true');
        var toggleTxt = component.find("dispMultiMsgAll");        
        $A.util.addClass(toggleTxt, "showCmp");
        $A.util.removeClass(toggleTxt, "hideCmp");   
    },
    
    hideMultiMsg: function(cmp, event, helper) {                        
        var toggleTxt = cmp.find("dispMultiMsg");        
        $A.util.addClass(toggleTxt, "hideCmp");
        $A.util.removeClass(toggleTxt, "showCmp");
        
        var toggleTxtAll = cmp.find("dispMultiMsgAll");        
        $A.util.addClass(toggleTxtAll, "hideCmp");
        $A.util.removeClass(toggleTxtAll, "showCmp");
        
        cmp.set("v.showingConsent",'false');
        
    },
    
    filter: function(component, event, helper) {   
        
        helper.filterSearch(component, event, helper);
        component.set("v.IsSearch", 'true');
    },
    
    resetSearch: function(component, event, helper) { 
        var clldFrom = component.get("v.calledFrom");
        
        if(clldFrom == 'ContentSelection'){
            var empty=[];
            component.set("v.data", empty);
            component.set("v.fullData",empty);
            component.set("v.OriginalfullData", empty);
            component.set("v.totalRecordCount",0);
            component.set("v.pageNumber",1);
            component.set("v.totalRowsMsg",'');
            component.set("v.maxPage",1);
        }
    },
    
    addAllItems: function(component, event, helper) {
        var toggleTxtAll = component.find("dispMultiMsgAll");        
        $A.util.addClass(toggleTxtAll, "hideCmp");
        $A.util.removeClass(toggleTxtAll, "showCmp");
        
        component.set("v.showingConsent",'false');
        component.set("v.addAllFromPCM",'true');
        component.set("v.paginationPstn",component.get("v.pstn"));
        component.set("v.pstn",0);
        //alert('called from addAll');
        helper.loadProducts(component, event, helper);
        var addAllEvt = $A.get("e.c:PPDProgressEvent");
        addAllEvt.setParam("showStatusBar",true);
        addAllEvt.setParam("progressPercent",0);
        addAllEvt.setParam("progressFor",'Progress Status :');
        
        addAllEvt.fire();
    },
    
    addAllItemsEvt: function(component, event, helper) {      
        if (event.getParam("addAllItems") !== undefined && event.getParam("addAllItems") == true ){
            //alert('called from allEvents');
            helper.loadProducts(component, event, helper);
        }
    },
    
    handleProductTypeClick : function(cmp, event, helper) {
        
        var productTypVal = event.getSource().get("v.value");
        var resetPageIndex = true;               
        cmp.set("v.pageNumber",1);
        cmp.set("v.pstn",0);
        cmp.set("v.productType",productTypVal);
        //alert('called from productTypeClick');
        helper.loadProducts(cmp,resetPageIndex,'NoCount'); 
    },
    
    assignColumns : function(cmp, event, helper) {
        
        var retType =  cmp.get("v.returnProductType");
        console.log('retType======='+ retType);
        
        if(retType.toUpperCase() == 'BOOK'){
            cmp.set("v.columns", cmp.get("v.columns_Book"));
            cmp.set("v.colOptions", cmp.get("v.columns_Book_Optns"));
            cmp.set("v.selected_Optns", cmp.get("v.selected_Book_Optns"));
        }
        if(retType.toUpperCase() == 'COLLECTION'){
            cmp.set("v.columns", cmp.get("v.columns_Collections"));
            cmp.set("v.colOptions", cmp.get("v.columns_Collections_Optns"));
            cmp.set("v.selected_Optns", cmp.get("v.selected_Collections_Optns"));
        }
        if(retType.toUpperCase() == 'CHAPTER'){
            cmp.set("v.columns", cmp.get("v.columns_Chapters"));
            cmp.set("v.colOptions", cmp.get("v.columns_Chapters_Optns"));
            cmp.set("v.selected_Optns", cmp.get("v.selected_Chapters_Optns"));
        }
        if(retType.toUpperCase() == 'CREATIVEWORK'){
            cmp.set("v.columns", cmp.get("v.columns_CreativeWs"));
            cmp.set("v.colOptions", cmp.get("v.columns_CreativeWs_Optns"));
            cmp.set("v.selected_Optns", cmp.get("v.selected_CreativeWs_Optns"));
            
        }
        if(retType.toUpperCase() == 'SCHOLARLYARTICLE'){
            cmp.set("v.columns", cmp.get("v.columns_Articles"));
            cmp.set("v.colOptions", cmp.get("v.columns_Articles_Optns"));
            cmp.set("v.selected_Optns", cmp.get("v.selected_Articles_Optns"));
        }
        if(retType.toUpperCase() == 'SET'){
            cmp.set("v.columns", cmp.get("v.columns_Set"));
            cmp.set("v.colOptions", cmp.get("v.columns_Set_Optns"));
            cmp.set("v.selected_Optns", cmp.get("v.selected_Set_Optns"));
        }
        if(retType.toUpperCase() == 'SERIES'){
            cmp.set("v.columns", cmp.get("v.columns_Series"));
            cmp.set("v.colOptions", cmp.get("v.columns_Series_Optns"));
            cmp.set("v.selected_Optns", cmp.get("v.selected_Series_Optns"));
        }
        
        if(retType.toUpperCase() == 'ENTRYVERSION'){
            cmp.set("v.columns", cmp.get("v.columns_EntryVersion"));
            cmp.set("v.colOptions", cmp.get("v.columns_EntryVersion_Optns"));
            cmp.set("v.selected_Optns", cmp.get("v.selected_EntryVersion_Optns"));
        }
    },
    
    HideMe: function(cmp, event, helper) {
        cmp.set("v.ShowModal", false);
        
        var selectedVals = cmp.get("v.selected_Optns");
        var retType = cmp.get("v.returnProductType");
        
        if(retType.toUpperCase() == 'BOOK'){
            var fullColumns = cmp.get("v.columns_Book_full");
            var newColumns = [];
            cmp.set("v.selected_Book_Optns", cmp.get("v.selected_Optns"));
            
            if(selectedVals.length > 0){
                selectedVals.forEach(function(parVal, parIndex){
                    fullColumns.forEach(function(childVal, childIndex){
                        if(parVal == childVal.fieldName){
                            newColumns.push(childVal);
                        }
                    }); 
                }); 
            }
            cmp.set("v.columns", newColumns);
            cmp.set("v.columns_Book", newColumns);
            
        }
        
        if(retType.toUpperCase() == 'COLLECTION'){
            var fullColumns = cmp.get("v.columns_Collections_full");
            var newColumns = [];
            cmp.set("v.selected_Collections_Optns", cmp.get("v.selected_Optns"));
            
            if(selectedVals.length > 0){
                selectedVals.forEach(function(parVal, parIndex){
                    fullColumns.forEach(function(childVal, childIndex){
                        if(parVal == childVal.fieldName){
                            newColumns.push(childVal);
                        }
                    }); 
                }); 
            }
            cmp.set("v.columns", newColumns);
            cmp.set("v.columns_Collections", newColumns);
            
        }
        if(retType.toUpperCase() == 'CHAPTER'){
            var fullColumns = cmp.get("v.columns_Chapters_full");
            var newColumns = [];
            cmp.set("v.selected_Chapters_Optns", cmp.get("v.selected_Optns"));
            
            if(selectedVals.length > 0){
                selectedVals.forEach(function(parVal, parIndex){
                    fullColumns.forEach(function(childVal, childIndex){
                        if(parVal == childVal.fieldName){
                            newColumns.push(childVal);
                        }
                    }); 
                }); 
            }
            cmp.set("v.columns", newColumns);
            cmp.set("v.columns_Chapters", newColumns);
            
        }
        if(retType.toUpperCase() == 'CREATIVEWORK'){
            var fullColumns = cmp.get("v.columns_CreativeWs_full");
            var newColumns = [];
            cmp.set("v.selected_CreativeWs_Optns", cmp.get("v.selected_Optns"));
            
            if(selectedVals.length > 0){
                selectedVals.forEach(function(parVal, parIndex){
                    fullColumns.forEach(function(childVal, childIndex){
                        if(parVal == childVal.fieldName){
                            newColumns.push(childVal);
                        }
                    }); 
                }); 
            }
            cmp.set("v.columns", newColumns);
            cmp.set("v.columns_CreativeWs", newColumns);
            
            
        }
        if(retType.toUpperCase() == 'SCHOLARLYARTICLE'){
            var fullColumns = cmp.get("v.columns_Articles_full");
            var newColumns = [];
            cmp.set("v.selected_Articles_Optns", cmp.get("v.selected_Optns"));
            
            if(selectedVals.length > 0){
                selectedVals.forEach(function(parVal, parIndex){
                    fullColumns.forEach(function(childVal, childIndex){
                        if(parVal == childVal.fieldName){
                            newColumns.push(childVal);
                        }
                    }); 
                }); 
            }
            cmp.set("v.columns", newColumns);
            cmp.set("v.columns_Articles", newColumns);
            
        }
        if(retType.toUpperCase() == 'SET'){
            var fullColumns = cmp.get("v.columns_Set_full");
            var newColumns = [];
            cmp.set("v.selected_Set_Optns", cmp.get("v.selected_Optns"));
            
            if(selectedVals.length > 0){
                selectedVals.forEach(function(parVal, parIndex){
                    fullColumns.forEach(function(childVal, childIndex){
                        if(parVal == childVal.fieldName){
                            newColumns.push(childVal);
                        }
                    }); 
                }); 
            }
            cmp.set("v.columns", newColumns);
            cmp.set("v.columns_Set", newColumns);
            
        }
        if(retType.toUpperCase() == 'SERIES'){
            var fullColumns = cmp.get("v.columns_Series_full");
            var newColumns = [];
            cmp.set("v.selected_Series_Optns", cmp.get("v.selected_Optns"));
            
            if(selectedVals.length > 0){
                selectedVals.forEach(function(parVal, parIndex){
                    fullColumns.forEach(function(childVal, childIndex){
                        if(parVal == childVal.fieldName){
                            newColumns.push(childVal);
                        }
                    }); 
                }); 
            }
            cmp.set("v.columns", newColumns);
            cmp.set("v.columns_Series", newColumns);
            
        }
    },
    
    ShowModal: function(cmp, event, helper) {
        cmp.set("v.ShowModal", true);
    },
    
    showSelectedRecordDetails: function(component, event, helper) {       
        helper.getAllSelectedIds(component, component.get("v.pageNumber"));
        var selcRows = component.get("v.selectedRows");
        var numOfRecsSelected = selcRows.length ;
        component.set("v.selectedRowsCount",numOfRecsSelected); 
        if(numOfRecsSelected > 0){
            var ppdPcmSearchEvent = $A.get("e.c:PPDPCMSearchEvent");
            ppdPcmSearchEvent.setParams({
                'PCMSearchDetails': JSON.stringify(component.get("v.selectedFullRows"))
            });
            console.log('StartEvent = '+ppdPcmSearchEvent);
            console.log('selectedFullRows'+JSON.stringify(component.get("v.selectedFullRows")));
            ppdPcmSearchEvent.fire();
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Success!",
                type : "success",
                mode : "pester",
                message: "Selected Products Added!"
            });
            toastEvent.fire();
            
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "message": "Please select atleast one product from the list!"
            });
            toastEvent.fire(); 
        }
        
    },
    
    /*
     *  var a = component.get('c.bar');
        $A.enqueueAction(a); 
     */
    
    
    downloadSearchResults: function(component, event, helper) {
        helper.downloadSearchResultFromPCM(component, event, helper);
         
    },
    
      downloadIds: function(component, event, helper) {
        
        var hiddenElement = document.createElement('a');
        hiddenElement.href = component.get("v.unAvailableIds");
        console.log('csfcontent'+component.get("v.unAvailableIds"));
        hiddenElement.target = '_self'; 
        hiddenElement.download = 'ExportData.csv'; 
        document.body.appendChild(hiddenElement);
        hiddenElement.click();
    },
    
    
   
})