({
    init: function(component,event,helper) {
        /*Creating Radio Button Data for Book Medium Section*/
        debugger;
        var recId = component.get("v.recordId");
        helper.showSpinner(component, event);
        var lstMediumData=component.get("v.lstMedium");
        var mediumAllData={'name':'All','value':'All','isChecked':false};
        var mediumEbookData={'name':'e-Book','value':'e-Book','isChecked':true};
        var mediumHardBackData={'name':'Hardback','value':'Hardback','isChecked':false};
        var mediumPaperbackData={'name':'Paperback','value':'Paperback','isChecked':false};
        lstMediumData.push(mediumAllData);
        lstMediumData.push(mediumEbookData);
        lstMediumData.push(mediumHardBackData);
        lstMediumData.push(mediumPaperbackData);
        component.set("v.lstMedium",lstMediumData);
        
        var lstPriceDetail=component.get("v.lstPublicationPrice");
        var USDPriceDetail={'label':'USD','value':'USD'};
        var GBPPriceDetail={'label':'GBP','value':'GBP'};
        lstPriceDetail.push(USDPriceDetail);
        lstPriceDetail.push(GBPPriceDetail);
        component.set("v.lstPublicationPrice",lstPriceDetail);
        
        var lstHasDRMData=component.get("v.lstHasDRM");
        var HasDRMBothData={'name':'All','value':'Both','isChecked':false};
        var HasDRMTrueData={'name':'DRM Protected','value':'True','isChecked':false};
        var HasDRMFalseData={'name':'DRM Free','value':'False','isChecked':true};
        lstHasDRMData.push(HasDRMBothData);
        lstHasDRMData.push(HasDRMTrueData);
        lstHasDRMData.push(HasDRMFalseData);
        component.set("v.lstHasDRM",lstHasDRMData);
        
        /*Creating Radio button Data for Not Yet Published Section*/
        var lstpublishData=component.get("v.lstPublished");
        var publishIncludeData={'name':'Include','value':'Include','isChecked':true};
        var publishexcludeData={'name':'Exclude','value':'Exclude','isChecked':false};
        var publishNYPData={'name':'Only NYP','value':'Only NYP','isChecked':false};
        lstpublishData.push(publishIncludeData);
        lstpublishData.push(publishexcludeData);
        lstpublishData.push(publishNYPData);
        helper.getLoggedInUser(component,event);
        helper.fetchOpportunityLineOnPageLoad(component,event);
        helper.fetchPickListVal(component, 'Billing_Country_List__c', 'SeriesValue');
        
    }, 
    onSeriesCountry : function(component,event,helper){
        var value = event.getSource().get("v.value");
        alert(value);
    },
    openProductDetailPage:function(component,event,helper){
        helper.preventLeaving();
        component.set("v.ProductText",'Product Detail');
        //var productSearchData=component.get("v.lstProductData");
        var productSearchData=component.get("v.lstProductDataWrapper");
        var productIndex=event.getSource().get("v.value");
        console.log(productSearchData[productIndex]);
        component.set("v.productDetailData",productSearchData[productIndex]);
        component.set("v.showproductSearch",true);
        component.set("v.showSearchData",false);
    },
    searchProduct:function(component,event,helper){
        debugger;
        helper.showSpinner(component, event);
        //component.set("v.disableSearch",true);
        component.set("v.offsetValue",0);
        component.set("v.lstDisplayPages",[]);
        component.set("v.secondShowRangeIndex",1);
        component.set("v.firstShowRangeIndex",1);
        component.set("v.selectedValue",1);
        //component.set("v.searchProductTitle","Searching......");
        helper.checkFilterDataValidations(component,event);
    },
    searchProductEnter:function(component,event,helper){
        helper.checkFilterDataValidationsOnEnter(component,event);
    },
    handleBackToResultEvt:function(component,event,helper){
        helper.allowLeaving();
        debugger;
        console.log(component.get("v.multiResultCodes"));
        var getSelectedTabValue=component.get("v.setSelectedTab")
        var getsetSelectedChildTab=component.get("v.setSelectedChildTab");
        var value = event.getParam("backPageName");
        if(getSelectedTabValue === 'productTab'){
            component.set("v.showproductSearch",false);
            component.set("v.showSearchData",true);
            component.set("v.ProductText",'Product Search');
            // make false of multiisbn pagination attribute
            component.set("v.showMultiIsbnPages",false);
            component.set("v.showMultiIsbnResultCount",false);
            // Enable attribute of product search pagination
            component.set("v.showProductSearchPages",true);
            component.set("v.showResultCount",true);
            component.set("v.eventFromProdDetail",true);
            //helper.getProductSearchCount(component,event);
            //helper.populatePageValues(component,event,component.get("v.lstDisplayPages"));
        }
        if(getSelectedTabValue === 'multiIsbnTab' && getsetSelectedChildTab === "isbnListTab"){
            component.set("v.showproductSearch",false);
            component.set("v.showSearchData",true);
            component.set("v.ProductText",'Product Search');
            var listData=component.get("v.multiIsbnListData");
            helper.getSearchCount(component,event,listData);
            // make true of multiisbn pagination attribute
            component.set("v.showMultiIsbnPages",true);
            component.set("v.showMultiIsbnResultCount",true);
            // make false attribute of product search pagination
            component.set("v.showProductSearchPages",false);
            component.set("v.showResultCount",false);
        }
        if(getSelectedTabValue === 'multiIsbnTab' && getsetSelectedChildTab === "uploadCsvTab"){
            component.set("v.showproductSearch",false);
            component.set("v.showSearchData",true);
            component.set("v.ProductText",'Product Search');
            component.set("v.showProductSearchPages",false);
            component.set("v.showResultCount",false);
        }
    },
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
    },
    
    hideSpinner : function(component,event,helper){
        component.set("v.Spinner", false);
    },
    selectNetbase:function(component, event, helper) {
        var selectVal = component.find("Netbase");
        var resultCmp = component.find("multiResult");
        //resultCmp.set("v.value", selectVal.get("v.value"));
    },
    selectSubjectList:function(component, event, helper) {
        var selectVal1 = component.find("subjectList");
        var resultCmp1 = component.find("multiResultList");
        resultCmp1.set("v.value", selectVal1.get("v.value"));
    },
    selectMedium:function(component, event, helper){
        debugger;
        /*var isTrue=event.getSource().get("v.checked");
        var lstSelectedItems=component.get("v.lstSelectedMedium");
        if(isTrue){
            var value=event.getSource().get("v.value");
            lstSelectedItems.push(value);
        }
        else{
            var value=event.getSource().get("v.value");
            if(lstSelectedItems.indexOf(value) !== -1){
                var index=lstSelectedItems.indexOf(value);
                lstSelectedItems.splice(index,1);
            }
        }*/
        var isTrue=event.getSource().get("v.checked");
        var value=event.getSource().get("v.value");
        component.set("v.lstSelectedMedium",value);
        //console.log('v.lstSelectedMedium----'+v.lstSelectedMedium);
        
        //component.set("v.lstSelectedMedium",lstSelectedItems);
    },
    selectpublish:function(component, event, helper){
        var isTrue=event.getSource().get("v.checked");
        var value=event.getSource().get("v.value");
        component.set("v.selectPublishedRadio",value);
    },
    selectCurrency:function(component, event, helper){
        debugger;
        var selectedOptionValue = event.getParam("value");
        //var isTrue=event.getSource().get("v.checked");
        //var value=event.getSource().get("v.value");
        component.set("v.selectPriceRadio",selectedOptionValue);
    },
    selectCountry:function(component, event, helper){
        debugger;
        var selectedOptionValue = event.getParam("value");
        //var isTrue=event.getSource().get("v.checked");
        //var value=event.getSource().get("v.value");
        component.set("v.selectCountryRadio",selectedOptionValue);
    },
    selectDRM:function(component, event, helper){
        var isTrue=event.getSource().get("v.checked");
        var value=event.getSource().get("v.value");
        component.set("v.selectDRMRadio",value);
    },
    handleSelectedListEvt:function (component, event){
        var value = event.getParam("selectedSubjectClassifys");
        for(var j in value){
            value[j]=value[j].labelValue;
        }
        console.log('event Listval='+JSON.stringify(value));
        component.set("v.multiResultList",value);
    },
    handleSelectedNetbaseEvt:function (component, event){
        debugger;
        var value = event.getParam("selectedNetbases");
        for(var j in value){
            value[j]=value[j].value;
        }
        console.log('event Codevalue='+JSON.stringify(value));
        component.set("v.multiResultCodes",value);
    },
    searchMultiIsbn:function(component,event,helper){
        debugger;
        var listData=component.find('multiIsbn').get("v.value");
        console.log('listData='+listData);
        if(listData !==undefined && listData!== ''){
            component.set("v.showMultiISBNTabISBNArrownUp",false);
            component.set("v.showMultiISBNTabTitleArrownUp",false);
            component.set("v.showMultiISBNTabAuthorArrownUp",false);
            component.set("v.showMultiISBNTabPubDateArrownUp",false);
            component.set("v.showMultiISBNTabPlanPubArrownUp",false);
            component.set("v.showMultiISBNTabDiscountArrownUp",false);
            component.set("v.showMultiISBNTabListPriceArrownUp",false);
            component.set("v.showMultiISBNTabCurrentAvailArrownUp",false);
            component.set("v.showMultiISBNTabEBookISBNArrownUp",false);
            component.set("v.showMultiISBNTabPaperbackISBNArrownUp",false);
            component.set("v.showMultiISBNTabHardbackISBNArrownUp",false);
            component.set("v.showMultiISBNTabEditionNumberArrownUp",false);
            component.set("v.showMultiISBNTabDiscountPriceArrownUp",false);
            component.set("v.showMultiISBNTabDiscountPercentArrownUp",false);
            component.set("v.isSortingAscMultiISBNDiscountPrice",false);
            component.set("v.isSortingDescMultiISBNDiscountPrice",false);
            component.set("v.isSortingAscMultiISBNDiscountPercent",false);
            component.set("v.isSortingDescMultiISBNDiscountPercent",false);
            component.set("v.multiISBNTabSortOrder",'desc');
            component.set("v.multiISBNTabSortOrderByField",'Name');
            component.set("v.disableMultiIsbnSearchBtn",true);
            component.set("v.searchProductMultiISBN",'Searching.....');
            component.set("v.firstMulltiIsbnShowRangeIndex",1);
            component.set("v.secondMulltiIsbnShowRangeIndex",1);
            component.set("v.selectedISBNValue",1);
            component.set("v.lstDisplayMultiIsbnPages",[]);
            component.set("v.paginationMultuIsbnDataSearch",false);
            helper.serachMultiIsbnList(component,event);
        }
        else{
            helper.showToastMessage(component,event,'Search box cannot be blank.','Alert','error');
        }
    },
    handleActive:function(component,event,helper){
        var value=event.getSource().get("v.id");
        var storeSelectedValue=component.get("v.storeSelectedTabValue");
        var getSelectedChildTabValue=component.get("v.setSelectedChildTab");
        var lstMultiIsbnTableData=component.get("v.lstMultiIsbnProductData");
        var lstproductTableData=component.get("v.lstProductTableData");
        var lstCsvData=component.get("v.lstUploadCsvData");
        component.set("v.offsetValue",0);
        console.log('lstproductTableData:='+lstproductTableData);
        //component.set("v.lstDisplayPages",[]);
        if(value !== storeSelectedValue){
            if(value === 'productTab' && lstproductTableData.length !==0){
                console.log('In product')
                component.set("v.lstProductDataWrapper",lstproductTableData)
                //helper.getProductSearchCount(component,event);
                component.set("v.showSearchData",true);
                // make false of multiisbn pagination attribute
                component.set("v.showMultiIsbnPages",false);
                component.set("v.showMultiIsbnResultCount",false);
                // Make false upload CSV data
                component.set("v.showUploadCsvPages",false);
                component.set("v.showUploadCsvResultCount",false);
                // Enable attribute of product search pagination
                component.set("v.showProductSearchPages",true);
                component.set("v.showResultCount",true);
            }
            if(value === 'multiIsbnTab' && lstMultiIsbnTableData.length!==0 && getSelectedChildTabValue === 'isbnListTab'){
                // make false attribute of product search pagination
                component.set("v.showProductSearchPages",false);
                component.set("v.showResultCount",false);
                // Make false upload csv data
                component.set("v.showUploadCsvPages",false);
                component.set("v.showUploadCsvResultCount",false);
                // make true of multiisbn pagination attribute
                component.set("v.showMultiIsbnPages",true);
                component.set("v.showMultiIsbnResultCount",true);
                component.set("v.lstProductDataWrapper",lstMultiIsbnTableData)
                // Call again multiisbn data pagination when click on multiisbn tab with already populated data
                var listData=component.get("v.multiIsbnListData");
                //helper.getSearchCount(component,event,listData);
                component.set("v.showSearchData",true);
                component.set("v.showUploadCsvPages",false);
                component.set("v.showUploadCsvResultCount",false);
            }
            console.log('@@@@@####'+lstCsvData.length);
            if(value === 'multiIsbnTab' && lstCsvData.length!==0 && getSelectedChildTabValue === 'uploadCsvTab'){
                component.set("v.showUploadCsvResultCount",true);
                component.set("v.showUploadCsvPages",true);
                component.set("v.lstProductDataWrapper",lstCsvData)
                component.set("v.showSearchData",true);
                component.set("v.showMultiIsbnPages",false);
                component.set("v.showProductSearchPages",false);
            }
            if(value === 'multiIsbnTab' && lstMultiIsbnTableData.length === 0){
                component.set("v.showProductSearchPages",false);
                component.set("v.showResultCount",false);
            }
            if(value === 'multiIsbnTab' && lstCsvData.length === 0){
                component.set("v.showProductSearchPages",false);
                component.set("v.showResultCount",false);
            }
            if(value === 'multiIsbnTab' && lstMultiIsbnTableData.length === 0 && getSelectedChildTabValue === 'isbnListTab'){
                component.set("v.showSearchData",false); 
                component.set("v.showProductSearchPages",false);
                component.set("v.showResultCount",false);
            }
            if(value === 'multiIsbnTab' && lstCsvData.length === 0 && getSelectedChildTabValue === 'uploadCsvTab'){
                component.set("v.showSearchData",false); 
                component.set("v.showProductSearchPages",false);
                component.set("v.showResultCount",false);
            }
            if(value === 'productTab' && lstproductTableData.length === 0 ){
                console.log('hiiiiiiiiiiiii');
                component.set("v.showSearchData",false);
                component.set("v.showUploadCsvResultCount",false);
                component.set("v.showUploadCsvPages",false);
                component.set("v.showMultiIsbnPages",false);
                component.set("v.showMultiIsbnResultCount",false);
            } 
        }
        component.set("v.storeSelectedTabValue",value);
    },
    handleFilesChange : function (component, event,helper) {
        //    component.set("v.disableMultiIsbnSearchBtn",true);
        var fileObj = component.find("fileId").get("v.files");
        if(fileObj !== null){
            component.set("v.showMultiISBNCsvTabISBNArrownUp",false);
            component.set("v.showMultiISBNCsvTabTitleArrownUp",false);
            component.set("v.showMultiISBNCsvTabAuthorArrownUp",false);
            component.set("v.showMultiISBNCsvTabPubDateArrownUp",false);
            component.set("v.showMultiISBNCsvTabPlanPubArrownUp",false);
            component.set("v.showMultiISBNCsvTabDiscountPercentArrownUp",false);
            component.set("v.showMultiISBNCsvTabListPriceArrownUp",false);
            component.set("v.showMultiISBNCsvTabCurrentAvailArrownUp",false);
            component.set("v.showMultiISBNCsvTabEBookISBNArrownUp",false);
            component.set("v.showMultiISBNCsvTabPaperbackISBNArrownUp",false);
            component.set("v.showMultiISBNCsvTabHardbackISBNArrownUp",false);
            component.set("v.showMultiISBNCsvTabEditionNumberArrownUp",false);
            component.set("v.showMultiISBNCsvTabDiscountPriceArrownUp",false);
            component.set("v.multiISBNCsvTabSortOrder",'desc');
            component.set("v.multiISBNCsvTabSortOrderByField",'name');
            component.set("v.disableCSVSearchBtn",true);
            component.set("v.selectedCSVPageValue",1);
            component.set("v.firstUploadCsvShowRangeIndex",1);
            component.set("v.secondUploadCsvShowRangeIndex",1);
            component.set("v.searchProductCSV",'Searching.....');
            component.set("v.isSortingAscCSVDiscountPrice",false);
            component.set("v.isSortingDescCSVDiscountPrice",false);
            component.set("v.isSortingAscCSVDiscountPercent",false);
            component.set("v.isSortingDescCSVDiscountPercent",false);
            component.set("v.lstDisplayUploadCsv",[]);
            component.set("v.fileObject",component.find("fileId").get("v.files"));
            helper.uploadHelper(component, event);
        }
        else{
            helper.showToastMessage(component,event,'Please upload CSV file.','Alert','error');
        }
    },
    handlePageDisplay:function(component, event,helper){
        var value=event.getSource().get("v.value");
        var getSelectedChildTabValue=component.get("v.setSelectedChildTab");
        var getSelectedTabValue=component.get("v.setSelectedTab");
        if(getSelectedTabValue ==='productTab'){
            helper.handlePageDisplayHelper(component, event,value);
        }
        if(getSelectedTabValue ==='multiIsbnTab' && getSelectedChildTabValue !== 'uploadCsvTab'){
            helper.handleMultiIsbnPageDisplayHelper(component, event,value);
        }
        if(getSelectedTabValue ==='multiIsbnTab' && getSelectedChildTabValue === 'uploadCsvTab'){
            helper.handleUploadCSVPageDisplayHelper(component, event,value);
        }
    },
    displayFile:function(component,event,helper){
        var filename = component.find("fileId").get("v.files");
        component.set("v.fileName",component.find("fileId").get("v.files")[0]['name']);
    },
    downloadExcel : function (component, event,helper) {
        helper.csvHelper(component, event);
    },
    showNextPage:function(component, event,helper){
        debugger;
        var getSelectedTabValue=component.get("v.setSelectedTab");
        var getSelectedChildTabValue=component.get("v.setSelectedChildTab");
        if(getSelectedTabValue ==='productTab'){
            var value=component.get("v.selectedValue");
            var nextPage=parseInt(value)+1;
            component.set("v.selectedValue",nextPage)
            helper.handlePageDisplayHelper(component, event,nextPage);
        }
        if(getSelectedTabValue ==='multiIsbnTab' && getSelectedChildTabValue !== 'uploadCsvTab'){
            var value=component.get("v.selectedISBNValue");
            var nextPage=parseInt(value)+1;
            component.set("v.selectedISBNValue",nextPage)
            helper.handleMultiIsbnPageDisplayHelper(component, event,nextPage);
        }
        if(getSelectedChildTabValue==='uploadCsvTab' && getSelectedTabValue ==='multiIsbnTab')
        {
            var value=component.get("v.selectedCSVPageValue");
            var nextPage=parseInt(value)+1;
            component.set("v.selectedCSVPageValue",nextPage)
            helper.handleUploadCSVPageDisplayHelper(component, event,nextPage);
        }
    },
    showPrevPage:function(component, event,helper){
        debugger;
        var getSelectedTabValue=component.get("v.setSelectedTab");
        var getSelectedChildTabValue=component.get("v.setSelectedChildTab");
        if(getSelectedTabValue ==='productTab'){
            var value=component.get("v.selectedValue");
            var prevPage=parseInt(value)-1;
            component.set("v.selectedValue",prevPage)
            helper.handlePageDisplayHelper(component, event,prevPage);
        }
        if(getSelectedTabValue ==='multiIsbnTab' && getSelectedChildTabValue !== 'uploadCsvTab'){
            var value=component.get("v.selectedISBNValue");
            var prevPage=parseInt(value)-1;
            component.set("v.selectedISBNValue",prevPage)
            helper.handleMultiIsbnPageDisplayHelper(component, event,prevPage);
        }
        if(getSelectedTabValue ==='multiIsbnTab' && getSelectedChildTabValue === 'uploadCsvTab'){
            var value=component.get("v.selectedCSVPageValue");
            var prevPage=parseInt(value)-1;
            component.set("v.selectedCSVPageValue",prevPage)
            helper.handleUploadCSVPageDisplayHelper(component, event,prevPage);
        }        
    },
    handleChildTabActive:function(component,event,helper){
        var value=event.getSource().get("v.id");
        var lstMultiIsbnTableData=component.get("v.lstMultiIsbnProductData");
        var lstCsvData=component.get("v.lstUploadCsvData");
        if(value === 'isbnListTab' && lstMultiIsbnTableData.length>0){
            component.set("v.showUploadCsvPages",false);
            component.set("v.showMultiIsbnPages",true);
            component.set("v.showMultiIsbnResultCount",true);
            component.set("v.showSearchData",true); 
            component.set("v.lstProductDataWrapper",lstMultiIsbnTableData)
        }
        if(value === 'uploadCsvTab' && lstCsvData.length>0){
            component.set("v.showMultiIsbnPages",false);
            component.set("v.showUploadCsvPages",true);
            component.set("v.showUploadCsvResultCount",true);
            component.set("v.showSearchData",true);
            component.set("v.showProductSearchPages",false);
            component.set("v.lstProductDataWrapper",lstCsvData)
        }
        if(value === 'isbnListTab' && lstMultiIsbnTableData.length === 0){
            component.set("v.showUploadCsvPages",false);
            component.set("v.showUploadCsvResultCount",false);
            component.set("v.showSearchData",false); 
        }
        if(value === 'uploadCsvTab' && lstCsvData.length === 0){
            component.set("v.showMultiIsbnPages",false);
            component.set("v.showSearchData",false); 
        }
    },
    sorting:function(component, event, helper) {
        var getTabSelectedValue=component.get("v.storeSelectedTabValue");
        var getSelectedChildTab=component.get("v.setSelectedChildTab");
        var data=event.currentTarget.getAttribute("data-id");/*To get clicked Attribute on which sorting will work*/
        if(data === 'isbn'){
            if(getTabSelectedValue === 'productTab'){
                if(component.get("v.showISBNArrownUp") === false){
                    component.set("v.showISBNArrownUp",true);
                    component.set("v.sortOrder",'asc');
                }
                else{
                    component.set("v.showISBNArrownUp",false);
                    component.set("v.sortOrder",'desc');
                }
                component.set("v.sortOrderByField",'ProductCode');
                component.set("v.showTitleArrownUp",false);
                component.set("v.showAuthorArrownUp",false);
                component.set("v.showPubDateArrownUp",false);
                component.set("v.showPlanPubArrownUp",false);
                component.set("v.showDiscountPercentArrownUp",false);
                component.set("v.showDiscountPriceArrownUp",false);
                component.set("v.showListPriceArrownUp",false);
                component.set("v.showCurrentAvailArrownUp",false);
                component.set("v.showEBookISBNArrownUp",false);
                component.set("v.showPaperbackISBNArrownUp",false);
                component.set("v.showHardbackISBNArrownUp",false);
                component.set("v.showEditionNumberArrownUp",false);
                component.set("v.isSortingAscDiscountPrice",false);
                component.set("v.isSortingDescDiscountPrice",false);
                component.set("v.isSortingAscDiscountPercent",false);
                component.set("v.isSortingDescDiscountPercent",false);
            }
            if(getTabSelectedValue ==='multiIsbnTab' && getSelectedChildTab === 'isbnListTab'){
                if(component.get("v.showMultiISBNTabISBNArrownUp") === false){
                    component.set("v.showMultiISBNTabISBNArrownUp",true);
                    component.set("v.multiISBNTabSortOrder",'asc');
                }
                else{
                    component.set("v.showMultiISBNTabISBNArrownUp",false);
                    component.set("v.multiISBNTabSortOrder",'desc');
                }
                component.set("v.multiISBNTabSortOrderByField",'ProductCode');
                component.set("v.showMultiISBNTabTitleArrownUp",false);
                component.set("v.showMultiISBNTabAuthorArrownUp",false);
                component.set("v.showMultiISBNTabPubDateArrownUp",false);
                component.set("v.showMultiISBNTabPlanPubArrownUp",false);
                component.set("v.showMultiISBNTabDiscountPercentArrownUp",false);
                component.set("v.showMultiISBNTabListPriceArrownUp",false);
                component.set("v.showMultiISBNTabCurrentAvailArrownUp",false);
                component.set("v.showMultiISBNTabEBookISBNArrownUp",false);
                component.set("v.showMultiISBNTabPaperbackISBNArrownUp",false);
                component.set("v.showMultiISBNTabHardbackISBNArrownUp",false);
                component.set("v.showMultiISBNTabEditionNumberArrownUp",false);
                component.set("v.showMultiISBNTabDiscountPriceArrownUp",false);
                component.set("v.isSortingAscMultiISBNDiscountPrice",false);
                component.set("v.isSortingDescMultiISBNDiscountPrice",false);
                component.set("v.isSortingAscMultiISBNDiscountPercent",false);
                component.set("v.isSortingDescMultiISBNDiscountPercent",false);
            }
            if(getTabSelectedValue ==='multiIsbnTab' && getSelectedChildTab === 'uploadCsvTab'){
                if(component.get("v.showMultiISBNCsvTabISBNArrownUp") === false){
                    component.set("v.showMultiISBNCsvTabISBNArrownUp",true);
                    component.set("v.multiISBNCsvTabSortOrder",'asc');
                }
                else{
                    component.set("v.showMultiISBNCsvTabISBNArrownUp",false);
                    component.set("v.multiISBNCsvTabSortOrder",'desc');
                }
                component.set("v.multiISBNCsvTabSortOrderByField",'ProductCode');
                component.set("v.showMultiISBNCsvTabTitleArrownUp",false);
                component.set("v.showMultiISBNCsvTabAuthorArrownUp",false);
                component.set("v.showMultiISBNCsvTabPubDateArrownUp",false);
                component.set("v.showMultiISBNCsvTabPlanPubArrownUp",false);
                component.set("v.showMultiISBNCsvTabDiscountArrownUp",false);
                component.set("v.showMultiISBNCsvTabListPriceArrownUp",false);
                component.set("v.showMultiISBNCsvTabCurrentAvailArrownUp",false);
                component.set("v.showMultiISBNCsvTabEBookISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabPaperbackISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabHardbackISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabEditionNumberArrownUp",false);
                component.set("v.showMultiISBNCsvTabDiscountPriceArrownUp",false);
                component.set("v.isSortingAscCSVDiscountPrice",false);
                component.set("v.isSortingDescCSVDiscountPrice",false);
                component.set("v.isSortingAscCSVDiscountPercent",false);
                component.set("v.isSortingDescCSVDiscountPercent",false);
            }
        }
        if(data === 'title'){
            console.log(component.get("v.showTitleArrownUp"))
            if(getTabSelectedValue === 'productTab'){
                if(component.get("v.showTitleArrownUp") === false){
                    component.set("v.showTitleArrownUp",true);
                    component.set("v.sortOrder",'asc');
                }
                else{
                    component.set("v.showTitleArrownUp",false);
                    component.set("v.sortOrder",'desc');
                }
                component.set("v.sortOrderByField",'Name');
                component.set("v.showISBNArrownUp",false);
                component.set("v.showAuthorArrownUp",false);
                component.set("v.showPubDateArrownUp",false);
                component.set("v.showPlanPubArrownUp",false);
                component.set("v.showDiscountPercentArrownUp",false);
                component.set("v.showDiscountPriceArrownUp",false);
                component.set("v.showListPriceArrownUp",false);
                component.set("v.showCurrentAvailArrownUp",false);
                component.set("v.showEBookISBNArrownUp",false);
                component.set("v.showPaperbackISBNArrownUp",false);
                component.set("v.showHardbackISBNArrownUp",false);
                component.set("v.showEditionNumberArrownUp",false);
                component.set("v.isSortingAscDiscountPrice",false);
                component.set("v.isSortingDescDiscountPrice",false);
                component.set("v.isSortingAscDiscountPercent",false);
                component.set("v.isSortingDescDiscountPercent",false);
            }
            if(getTabSelectedValue ==='multiIsbnTab' && getSelectedChildTab === 'isbnListTab'){
                if(component.get("v.showMultiISBNTabTitleArrownUp") === false){
                    component.set("v.showMultiISBNTabTitleArrownUp",true);
                    component.set("v.multiISBNTabSortOrder",'asc');
                }
                else{
                    component.set("v.showMultiISBNTabTitleArrownUp",false);
                    component.set("v.multiISBNTabSortOrder",'desc');
                }
                component.set("v.multiISBNTabSortOrderByField",'Name');
                component.set("v.showMultiISBNTabISBNArrownUp",false);
                component.set("v.showMultiISBNTabAuthorArrownUp",false);
                component.set("v.showMultiISBNTabPubDateArrownUp",false);
                component.set("v.showMultiISBNTabPlanPubArrownUp",false);
                component.set("v.showMultiISBNTabDiscountPercentArrownUp",false);
                component.set("v.showMultiISBNTabListPriceArrownUp",false);
                component.set("v.showMultiISBNTabCurrentAvailArrownUp",false);
                component.set("v.showMultiISBNTabEBookISBNArrownUp",false);
                component.set("v.showMultiISBNTabPaperbackISBNArrownUp",false);
                component.set("v.showMultiISBNTabHardbackISBNArrownUp",false);
                component.set("v.showMultiISBNTabEditionNumberArrownUp",false);
                component.set("v.showMultiISBNTabDiscountPriceArrownUp",false);
                component.set("v.isSortingAscMultiISBNDiscountPrice",false);
                component.set("v.isSortingDescMultiISBNDiscountPrice",false);
                component.set("v.isSortingAscMultiISBNDiscountPercent",false);
                component.set("v.isSortingDescMultiISBNDiscountPercent",false);
            }
            if(getTabSelectedValue ==='multiIsbnTab' && getSelectedChildTab === 'uploadCsvTab'){
                if(component.get("v.showMultiISBNCsvTabTitleArrownUp") === false){
                    component.set("v.showMultiISBNCsvTabTitleArrownUp",true);
                    component.set("v.multiISBNCsvTabSortOrder",'asc');
                }
                else{
                    component.set("v.showMultiISBNCsvTabTitleArrownUp",false);
                    component.set("v.multiISBNCsvTabSortOrder",'desc');
                }
                component.set("v.multiISBNCsvTabSortOrderByField",'Name');
                component.set("v.showMultiISBNCsvTabISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabAuthorArrownUp",false);
                component.set("v.showMultiISBNCsvTabPubDateArrownUp",false);
                component.set("v.showMultiISBNCsvTabPlanPubArrownUp",false);
                component.set("v.showMultiISBNCsvTabDiscountArrownUp",false);
                component.set("v.showMultiISBNCsvTabListPriceArrownUp",false);
                component.set("v.showMultiISBNCsvTabCurrentAvailArrownUp",false);
                component.set("v.showMultiISBNCsvTabEBookISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabPaperbackISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabHardbackISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabEditionNumberArrownUp",false);
                component.set("v.showMultiISBNCsvTabDiscountPriceArrownUp",false);
                component.set("v.isSortingAscCSVDiscountPrice",false);
                component.set("v.isSortingDescCSVDiscountPrice",false);
                component.set("v.isSortingAscCSVDiscountPercent",false);
                component.set("v.isSortingDescCSVDiscountPercent",false);
            }
        }
        if(data === 'author'){
            console.log(component.get("v.showAuthorArrownUp"))
            if(getTabSelectedValue === 'productTab'){
                if(component.get("v.showAuthorArrownUp") === false){
                    console.log('checkj');
                    component.set("v.showAuthorArrownUp",true);
                    component.set("v.sortOrder",'asc');
                    console.log(component.get("v.showAuthorArrownUp"));
                }
                else{
                    component.set("v.showAuthorArrownUp",false);
                    component.set("v.sortOrder",'desc');
                }
                component.set("v.sortOrderByField",'Lead_Author_Editor__c');
                component.set("v.showISBNArrownUp",false);
                component.set("v.showTitleArrownUp",false);
                component.set("v.showPubDateArrownUp",false);
                component.set("v.showPlanPubArrownUp",false);
                component.set("v.showDiscountPercentArrownUp",false);
                component.set("v.showDiscountPriceArrownUp",false);
                component.set("v.showListPriceArrownUp",false);
                component.set("v.showCurrentAvailArrownUp",false);
                component.set("v.showEBookISBNArrownUp",false);
                component.set("v.showPaperbackISBNArrownUp",false);
                component.set("v.showHardbackISBNArrownUp",false);
                component.set("v.showEditionNumberArrownUp",false);
                component.set("v.isSortingAscDiscountPrice",false);
                component.set("v.isSortingDescDiscountPrice",false);
                component.set("v.isSortingAscDiscountPercent",false);
                component.set("v.isSortingDescDiscountPercent",false);
            }
            if(getTabSelectedValue ==='multiIsbnTab' && getSelectedChildTab === 'isbnListTab'){
                if(component.get("v.showMultiISBNTabAuthorArrownUp") === false){
                    component.set("v.showMultiISBNTabAuthorArrownUp",true);
                    component.set("v.multiISBNTabSortOrder",'asc');
                }
                else{
                    component.set("v.showMultiISBNTabAuthorArrownUp",false);
                    component.set("v.multiISBNTabSortOrder",'desc');
                }
                component.set("v.multiISBNTabSortOrderByField",'Lead_Author_Editor__c');
                component.set("v.showMultiISBNTabISBNArrownUp",false);
                component.set("v.showMultiISBNTabTitleArrownUp",false);
                component.set("v.showMultiISBNTabPubDateArrownUp",false);
                component.set("v.showMultiISBNTabPlanPubArrownUp",false);
                component.set("v.showMultiISBNTabDiscountPercentArrownUp",false);
                component.set("v.showMultiISBNTabListPriceArrownUp",false);
                component.set("v.showMultiISBNTabCurrentAvailArrownUp",false);
                component.set("v.showMultiISBNTabEBookISBNArrownUp",false);
                component.set("v.showMultiISBNTabPaperbackISBNArrownUp",false);
                component.set("v.showMultiISBNTabHardbackISBNArrownUp",false);
                component.set("v.showMultiISBNTabEditionNumberArrownUp",false);
                component.set("v.showMultiISBNTabDiscountPriceArrownUp",false);
                component.set("v.isSortingAscMultiISBNDiscountPrice",false);
                component.set("v.isSortingDescMultiISBNDiscountPrice",false);
                component.set("v.isSortingAscMultiISBNDiscountPercent",false);
                component.set("v.isSortingDescMultiISBNDiscountPercent",false);
            }
            if(getTabSelectedValue ==='multiIsbnTab' && getSelectedChildTab === 'uploadCsvTab'){
                if(component.get("v.showMultiISBNCsvTabAuthorArrownUp") === false){
                    component.set("v.showMultiISBNCsvTabAuthorArrownUp",true);
                    component.set("v.multiISBNCsvTabSortOrder",'asc');
                }
                else{
                    component.set("v.showMultiISBNCsvTabAuthorArrownUp",false);
                    component.set("v.multiISBNCsvTabSortOrder",'desc');
                }
                component.set("v.multiISBNCsvTabSortOrderByField",'Lead_Author_Editor__c');
                component.set("v.showMultiISBNCsvTabISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabTitleArrownUp",false);
                component.set("v.showMultiISBNCsvTabPubDateArrownUp",false);
                component.set("v.showMultiISBNCsvTabPlanPubArrownUp",false);
                component.set("v.showMultiISBNCsvTabDiscountArrownUp",false);
                component.set("v.showMultiISBNCsvTabListPriceArrownUp",false);
                component.set("v.showMultiISBNCsvTabCurrentAvailArrownUp",false);
                component.set("v.showMultiISBNCsvTabEBookISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabPaperbackISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabHardbackISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabEditionNumberArrownUp",false);
                component.set("v.showMultiISBNCsvTabDiscountPriceArrownUp",false);
                component.set("v.isSortingAscCSVDiscountPrice",false);
                component.set("v.isSortingDescCSVDiscountPrice",false);
                component.set("v.isSortingAscCSVDiscountPercent",false);
                component.set("v.isSortingDescCSVDiscountPercent",false);
            }
        }
        if(data === 'pubDate'){
            console.log(component.get("v.showPubDateArrownUp"))
            if(getTabSelectedValue === 'productTab'){
                if(component.get("v.showPubDateArrownUp") === false){
                    console.log('checkj');
                    component.set("v.showPubDateArrownUp",true);
                    component.set("v.sortOrder",'asc');
                    console.log(component.get("v.showPubDateArrownUp"));
                }
                else{
                    component.set("v.showPubDateArrownUp",false);
                    component.set("v.sortOrder",'desc');
                }
                component.set("v.sortOrderByField",'US_Publication_Date__c');
                component.set("v.showISBNArrownUp",false);
                component.set("v.showTitleArrownUp",false);
                component.set("v.showAuthorArrownUp",false);
                component.set("v.showPlanPubArrownUp",false);
                component.set("v.showDiscountPercentArrownUp",false);
                component.set("v.showDiscountPriceArrownUp",false);
                component.set("v.showListPriceArrownUp",false);
                component.set("v.showCurrentAvailArrownUp",false);
                component.set("v.showEBookISBNArrownUp",false);
                component.set("v.showPaperbackISBNArrownUp",false);
                component.set("v.showHardbackISBNArrownUp",false);
                component.set("v.showEditionNumberArrownUp",false);
                component.set("v.isSortingAscDiscountPrice",false);
                component.set("v.isSortingDescDiscountPrice",false);
                component.set("v.isSortingAscDiscountPercent",false);
                component.set("v.isSortingDescDiscountPercent",false);
            }
            if(getTabSelectedValue ==='multiIsbnTab' && getSelectedChildTab === 'isbnListTab'){
                if(component.get("v.showMultiISBNTabPubDateArrownUp") === false){
                    component.set("v.showMultiISBNTabPubDateArrownUp",true);
                    component.set("v.multiISBNTabSortOrder",'asc');
                }
                else{
                    component.set("v.showMultiISBNTabPubDateArrownUp",false);
                    component.set("v.multiISBNTabSortOrder",'desc');
                }
                component.set("v.multiISBNTabSortOrderByField",'US_Publication_Date__c');
                component.set("v.showMultiISBNTabISBNArrownUp",false);
                component.set("v.showMultiISBNTabTitleArrownUp",false);
                component.set("v.showMultiISBNTabAuthorArrownUp",false);
                component.set("v.showMultiISBNTabPlanPubArrownUp",false);
                component.set("v.showMultiISBNTabDiscountPercentArrownUp",false);
                component.set("v.showMultiISBNTabListPriceArrownUp",false);
                component.set("v.showMultiISBNTabCurrentAvailArrownUp",false);
                component.set("v.showMultiISBNTabEBookISBNArrownUp",false);
                component.set("v.showMultiISBNTabPaperbackISBNArrownUp",false);
                component.set("v.showMultiISBNTabHardbackISBNArrownUp",false);
                component.set("v.showMultiISBNTabEditionNumberArrownUp",false);
                component.set("v.showMultiISBNTabDiscountPriceArrownUp",false);
                component.set("v.isSortingAscMultiISBNDiscountPrice",false);
                component.set("v.isSortingDescMultiISBNDiscountPrice",false);
                component.set("v.isSortingAscMultiISBNDiscountPercent",false);
                component.set("v.isSortingDescMultiISBNDiscountPercent",false);
            }
            if(getTabSelectedValue ==='multiIsbnTab' && getSelectedChildTab === 'uploadCsvTab'){
                if(component.get("v.showMultiISBNCsvTabPubDateArrownUp") === false){
                    component.set("v.showMultiISBNCsvTabPubDateArrownUp",true);
                    component.set("v.multiISBNCsvTabSortOrder",'asc');
                }
                else{
                    component.set("v.showMultiISBNCsvTabPubDateArrownUp",false);
                    component.set("v.multiISBNCsvTabSortOrder",'desc');
                }
                component.set("v.multiISBNCsvTabSortOrderByField",'US_Publication_Date__c');
                component.set("v.showMultiISBNCsvTabISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabTitleArrownUp",false);
                component.set("v.showMultiISBNCsvTabAuthorArrownUp",false);
                component.set("v.showMultiISBNCsvTabPlanPubArrownUp",false);
                component.set("v.showMultiISBNCsvTabDiscountArrownUp",false);
                component.set("v.showMultiISBNCsvTabListPriceArrownUp",false);
                component.set("v.showMultiISBNCsvTabCurrentAvailArrownUp",false);
                component.set("v.showMultiISBNCsvTabEBookISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabPaperbackISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabHardbackISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabEditionNumberArrownUp",false);
                component.set("v.showMultiISBNCsvTabDiscountPriceArrownUp",false);
                component.set("v.isSortingAscCSVDiscountPrice",false);
                component.set("v.isSortingDescCSVDiscountPrice",false);
                component.set("v.isSortingAscCSVDiscountPercent",false);
                component.set("v.isSortingDescCSVDiscountPercent",false);
            }
        }
        if(data === 'planPubDate'){
            console.log(component.get("v.showPlanPubArrownUp"))
            if(getTabSelectedValue === 'productTab'){
                if(component.get("v.showPlanPubArrownUp") === false){
                    console.log('checkj');
                    component.set("v.showPlanPubArrownUp",true);
                    component.set("v.sortOrder",'asc');
                    console.log(component.get("v.showPlanPubArrownUp"));
                }
                else{
                    component.set("v.showPlanPubArrownUp",false);
                    component.set("v.sortOrder",'desc');
                }
                component.set("v.sortOrderByField",'US_Planned_Publication_Date__c');
                component.set("v.showISBNArrownUp",false);
                component.set("v.showTitleArrownUp",false);
                component.set("v.showAuthorArrownUp",false);
                component.set("v.showPubDateArrownUp",false);
                component.set("v.showDiscountPercentArrownUp",false);
                component.set("v.showDiscountPriceArrownUp",false);
                component.set("v.showListPriceArrownUp",false);
                component.set("v.showCurrentAvailArrownUp",false);
                component.set("v.showEBookISBNArrownUp",false);
                component.set("v.showPaperbackISBNArrownUp",false);
                component.set("v.showHardbackISBNArrownUp",false);
                component.set("v.showEditionNumberArrownUp",false);
                component.set("v.isSortingAscDiscountPrice",false);
                component.set("v.isSortingDescDiscountPrice",false);
                component.set("v.isSortingAscDiscountPercent",false);
                component.set("v.isSortingDescDiscountPercent",false);
            }
            if(getTabSelectedValue ==='multiIsbnTab' && getSelectedChildTab === 'isbnListTab'){
                if(component.get("v.showMultiISBNTabPlanPubArrownUp") === false){
                    component.set("v.showMultiISBNTabPlanPubArrownUp",true);
                    component.set("v.multiISBNTabSortOrder",'asc');
                }
                else{
                    component.set("v.showMultiISBNTabPlanPubArrownUp",false);
                    component.set("v.multiISBNTabSortOrder",'desc');
                }
                component.set("v.multiISBNTabSortOrderByField",'US_Planned_Publication_Date__c');
                component.set("v.showMultiISBNTabISBNArrownUp",false);
                component.set("v.showMultiISBNTabTitleArrownUp",false);
                component.set("v.showMultiISBNTabPubDateArrownUp",false);
                component.set("v.showMultiISBNTabAuthorPubArrownUp",false);
                component.set("v.showMultiISBNTabDiscountPercentArrownUp",false);
                component.set("v.showMultiISBNTabListPriceArrownUp",false);
                component.set("v.showMultiISBNTabCurrentAvailArrownUp",false);
                component.set("v.showMultiISBNTabEBookISBNArrownUp",false);
                component.set("v.showMultiISBNTabPaperbackISBNArrownUp",false);
                component.set("v.showMultiISBNTabHardbackISBNArrownUp",false);
                component.set("v.showMultiISBNTabEditionNumberArrownUp",false);
                component.set("v.showMultiISBNTabDiscountPriceArrownUp",false);
                component.set("v.isSortingAscMultiISBNDiscountPrice",false);
                component.set("v.isSortingDescMultiISBNDiscountPrice",false);
                component.set("v.isSortingAscMultiISBNDiscountPercent",false);
                component.set("v.isSortingDescMultiISBNDiscountPercent",false);
            }
            if(getTabSelectedValue ==='multiIsbnTab' && getSelectedChildTab === 'uploadCsvTab'){
                if(component.get("v.showMultiISBNCsvTabPlanPubArrownUp") === false){
                    component.set("v.showMultiISBNCsvTabPlanPubArrownUp",true);
                    component.set("v.multiISBNCsvTabSortOrder",'asc');
                }
                else{
                    component.set("v.showMultiISBNCsvTabPlanPubArrownUp",false);
                    component.set("v.multiISBNCsvTabSortOrder",'desc');
                }
                component.set("v.multiISBNCsvTabSortOrderByField",'US_Planned_Publication_Date__c');
                component.set("v.showMultiISBNCsvTabISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabTitleArrownUp",false);
                component.set("v.showMultiISBNCsvTabPubDateArrownUp",false);
                component.set("v.showMultiISBNCsvTabAuthorPubArrownUp",false);
                component.set("v.showMultiISBNCsvTabDiscountArrownUp",false);
                component.set("v.showMultiISBNCsvTabListPriceArrownUp",false);
                component.set("v.showMultiISBNCsvTabCurrentAvailArrownUp",false);
                component.set("v.showMultiISBNCsvTabEBookISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabPaperbackISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabHardbackISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabEditionNumberArrownUp",false);
                component.set("v.showMultiISBNCsvTabDiscountPriceArrownUp",false);
                component.set("v.isSortingAscCSVDiscountPrice",false);
                component.set("v.isSortingDescCSVDiscountPrice",false);
                component.set("v.isSortingAscCSVDiscountPercent",false);
                component.set("v.isSortingDescCSVDiscountPercent",false);
            }
        }
        if(data === 'currentAvailability'){
            console.log(component.get("v.showCurrentAvailArrownUp"))
            if(getTabSelectedValue === 'productTab'){
                if(component.get("v.showCurrentAvailArrownUp") === false){
                    console.log('checkj');
                    component.set("v.showCurrentAvailArrownUp",true);
                    component.set("v.sortOrder",'asc');
                    console.log(component.get("v.showCurrentAvailArrownUp"));
                }
                else{
                    component.set("v.showCurrentAvailArrownUp",false);
                    component.set("v.sortOrder",'desc');
                }
                component.set("v.sortOrderByField",'US_Inventory_Status__c');
                component.set("v.showISBNArrownUp",false);
                component.set("v.showTitleArrownUp",false);
                component.set("v.showAuthorArrownUp",false);
                component.set("v.showPubDateArrownUp",false);
                component.set("v.showPlanPubArrownUp",false);
                component.set("v.showListPriceArrownUp",false);
                component.set("v.showEBookISBNArrownUp",false);
                component.set("v.showPaperbackISBNArrownUp",false);
                component.set("v.showHardbackISBNArrownUp",false);
                component.set("v.showEditionNumberArrownUp",false);
                component.set("v.showDiscountPercentArrownUp",false);
                component.set("v.showDiscountPriceArrownUp",false);
                component.set("v.isSortingAscDiscountPrice",false);
                component.set("v.isSortingDescDiscountPrice",false);
                component.set("v.isSortingAscDiscountPercent",false);
                component.set("v.isSortingDescDiscountPercent",false);
            }
            if(getTabSelectedValue ==='multiIsbnTab' && getSelectedChildTab === 'isbnListTab'){
                if(component.get("v.showMultiISBNTabCurrentAvailArrownUp") === false){
                    component.set("v.showMultiISBNTabCurrentAvailArrownUp",true);
                    component.set("v.multiISBNTabSortOrder",'asc');
                }
                else{
                    component.set("v.showMultiISBNTabCurrentAvailArrownUp",false);
                    component.set("v.multiISBNTabSortOrder",'desc');
                }
                component.set("v.multiISBNTabSortOrderByField",'US_Inventory_Status__c');
                component.set("v.showMultiISBNTabISBNArrownUp",false);
                component.set("v.showMultiISBNTabTitleArrownUp",false);
                component.set("v.showMultiISBNTabEBookISBNArrownUp",false);
                component.set("v.showMultiISBNTabPaperbackISBNArrownUp",false);
                component.set("v.showMultiISBNTabHardbackISBNArrownUp",false);
                component.set("v.showMultiISBNTabEditionNumberArrownUp",false);
                component.set("v.showMultiISBNTabDiscountPercentArrownUp",false);
                component.set("v.showMultiISBNTabPubDateArrownUp",false);
                component.set("v.showMultiISBNTabPlanPubArrownUp",false);
                component.set("v.showMultiISBNTabAuthorArrownUp",false);
                component.set("v.showMultiISBNTabListPriceArrownUp",false);
                component.set("v.showMultiISBNTabDiscountPriceArrownUp",false);
                component.set("v.isSortingAscMultiISBNDiscountPrice",false);
                component.set("v.isSortingDescMultiISBNDiscountPrice",false);
                component.set("v.isSortingAscMultiISBNDiscountPercent",false);
                component.set("v.isSortingDescMultiISBNDiscountPercent",false);
            }
            if(getTabSelectedValue ==='multiIsbnTab' && getSelectedChildTab === 'uploadCsvTab'){
                if(component.get("v.showMultiISBNCsvTabCurrentAvailArrownUp") === false){
                    component.set("v.showMultiISBNCsvTabCurrentAvailArrownUp",true);
                    component.set("v.multiISBNCsvTabSortOrder",'asc');
                }
                else{
                    component.set("v.showMultiISBNCsvTabCurrentAvailArrownUp",false);
                    component.set("v.multiISBNCsvTabSortOrder",'desc');
                }
                component.set("v.multiISBNCsvTabSortOrderByField",'US_Inventory_Status__c');
                component.set("v.showMultiISBNCsvTabISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabTitleArrownUp",false);
                component.set("v.showMultiISBNCsvTabPubDateArrownUp",false);
                component.set("v.showMultiISBNCsvTabPlanPubArrownUp",false);
                component.set("v.showMultiISBNCsvTabAuthorArrownUp",false);
                component.set("v.showMultiISBNCsvTabEBookISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabPaperbackISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabHardbackISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabEditionNumberArrownUp",false);
                component.set("v.showMultiISBNCsvTabListPriceArrownUp",false);
                component.set("v.showMultiISBNCsvTabDiscountArrownUp",false);
                component.set("v.showMultiISBNCsvTabDiscountPriceArrownUp",false);
                component.set("v.isSortingAscCSVDiscountPrice",false);
                component.set("v.isSortingDescCSVDiscountPrice",false);
                component.set("v.isSortingAscCSVDiscountPercent",false);
                component.set("v.isSortingDescCSVDiscountPercent",false);
            }
        }
        if(data === 'eBookISBN'){
            console.log(component.get("v.showEBookISBNArrownUp"))
            if(getTabSelectedValue === 'productTab'){
                if(component.get("v.showEBookISBNArrownUp") === false){
                    console.log('checkj');
                    component.set("v.showEBookISBNArrownUp",true);
                    component.set("v.sortOrder",'asc');
                    console.log(component.get("v.showEBookISBNArrownUp"));
                }
                else{
                    component.set("v.showEBookISBNArrownUp",false);
                    component.set("v.sortOrder",'desc');
                }
                component.set("v.sortOrderByField",'eBook_ISBN__c');
                component.set("v.showISBNArrownUp",false);
                component.set("v.showTitleArrownUp",false);
                component.set("v.showAuthorArrownUp",false);
                component.set("v.showPubDateArrownUp",false);
                component.set("v.showPlanPubArrownUp",false);
                component.set("v.showListPriceArrownUp",false);
                component.set("v.showCurrentAvailArrownUp",false);
                component.set("v.showPaperbackISBNArrownUp",false);
                component.set("v.showHardbackISBNArrownUp",false);
                component.set("v.showEditionNumberArrownUp",false);
                component.set("v.showDiscountPercentArrownUp",false);
                component.set("v.showDiscountPriceArrownUp",false);
                component.set("v.isSortingAscDiscountPrice",false);
                component.set("v.isSortingDescDiscountPrice",false);
                component.set("v.isSortingAscDiscountPercent",false);
                component.set("v.isSortingDescDiscountPercent",false);
            }
            if(getTabSelectedValue ==='multiIsbnTab' && getSelectedChildTab === 'isbnListTab'){
                if(component.get("v.showMultiISBNTabEBookISBNArrownUp") === false){
                    component.set("v.showMultiISBNTabEBookISBNArrownUp",true);
                    component.set("v.multiISBNTabSortOrder",'asc');
                }
                else{
                    component.set("v.showMultiISBNTabEBookISBNArrownUp",false);
                    component.set("v.multiISBNTabSortOrder",'desc');
                }
                component.set("v.multiISBNTabSortOrderByField",'eBook_ISBN__c');
                component.set("v.showMultiISBNTabISBNArrownUp",false);
                component.set("v.showMultiISBNTabTitleArrownUp",false);
                component.set("v.showMultiISBNTabCurrentAvailArrownUp",false);
                component.set("v.showMultiISBNTabPaperbackISBNArrownUp",false);
                component.set("v.showMultiISBNTabHardbackISBNArrownUp",false);
                component.set("v.showMultiISBNTabEditionNumberArrownUp",false);
                component.set("v.showMultiISBNTabDiscountPercentArrownUp",false);
                component.set("v.showMultiISBNTabPubDateArrownUp",false);
                component.set("v.showMultiISBNTabPlanPubArrownUp",false);
                component.set("v.showMultiISBNTabAuthorArrownUp",false);
                component.set("v.showMultiISBNTabListPriceArrownUp",false);
                component.set("v.showMultiISBNTabDiscountPriceArrownUp",false);
                component.set("v.isSortingAscMultiISBNDiscountPrice",false);
                component.set("v.isSortingDescMultiISBNDiscountPrice",false);
                component.set("v.isSortingAscMultiISBNDiscountPercent",false);
                component.set("v.isSortingDescMultiISBNDiscountPercent",false);
            }
            if(getTabSelectedValue ==='multiIsbnTab' && getSelectedChildTab === 'uploadCsvTab'){
                if(component.get("v.showMultiISBNCsvTabEBookISBNArrownUp") === false){
                    component.set("v.showMultiISBNCsvTabEBookISBNArrownUp",true);
                    component.set("v.multiISBNCsvTabSortOrder",'asc');
                }
                else{
                    component.set("v.showMultiISBNCsvTabEBookISBNArrownUp",false);
                    component.set("v.multiISBNCsvTabSortOrder",'desc');
                }
                component.set("v.multiISBNCsvTabSortOrderByField",'eBook_ISBN__c');
                component.set("v.showMultiISBNCsvTabISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabTitleArrownUp",false);
                component.set("v.showMultiISBNCsvTabPubDateArrownUp",false);
                component.set("v.showMultiISBNCsvTabPlanPubArrownUp",false);
                component.set("v.showMultiISBNCsvTabAuthorArrownUp",false);
                component.set("v.showMultiISBNCsvTabCurrentAvailArrownUp",false);
                component.set("v.showMultiISBNCsvTabPaperbackISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabHardbackISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabEditionNumberArrownUp",false);
                component.set("v.showMultiISBNCsvTabListPriceArrownUp",false);
                component.set("v.showMultiISBNCsvTabDiscountArrownUp",false);
                component.set("v.showMultiISBNCsvTabDiscountPriceArrownUp",false);
                component.set("v.isSortingAscCSVDiscountPrice",false);
                component.set("v.isSortingDescCSVDiscountPrice",false);
                component.set("v.isSortingAscCSVDiscountPercent",false);
                component.set("v.isSortingDescCSVDiscountPercent",false);
            }
        }
        
        if(data === 'PaperbackISBN'){
            console.log(component.get("v.showPaperbackISBNArrownUp"))
            if(getTabSelectedValue === 'productTab'){
                if(component.get("v.showPaperbackISBNArrownUp") === false){
                    console.log('checkj');
                    component.set("v.showPaperbackISBNArrownUp",true);
                    component.set("v.sortOrder",'asc');
                    console.log(component.get("v.showPaperbackISBNArrownUp"));
                }
                else{
                    component.set("v.showPaperbackISBNArrownUp",false);
                    component.set("v.sortOrder",'desc');
                }
                component.set("v.sortOrderByField",'Paperback_ISBN__c');
                component.set("v.showISBNArrownUp",false);
                component.set("v.showTitleArrownUp",false);
                component.set("v.showAuthorArrownUp",false);
                component.set("v.showPubDateArrownUp",false);
                component.set("v.showPlanPubArrownUp",false);
                component.set("v.showListPriceArrownUp",false);
                component.set("v.showCurrentAvailArrownUp",false);
                component.set("v.showEBookISBNArrownUp",false);
                component.set("v.showHardbackISBNArrownUp",false);
                component.set("v.showEditionNumberArrownUp",false);
                component.set("v.showDiscountPercentArrownUp",false);
                component.set("v.showDiscountPriceArrownUp",false);
                component.set("v.isSortingAscDiscountPrice",false);
                component.set("v.isSortingDescDiscountPrice",false);
                component.set("v.isSortingAscDiscountPercent",false);
                component.set("v.isSortingDescDiscountPercent",false);
            }
            if(getTabSelectedValue ==='multiIsbnTab' && getSelectedChildTab === 'isbnListTab'){
                if(component.get("v.showMultiISBNTabPaperbackISBNArrownUp") === false){
                    component.set("v.showMultiISBNTabPaperbackISBNArrownUp",true);
                    component.set("v.multiISBNTabSortOrder",'asc');
                }
                else{
                    component.set("v.showMultiISBNTabPaperbackISBNArrownUp",false);
                    component.set("v.multiISBNTabSortOrder",'desc');
                }
                component.set("v.multiISBNTabSortOrderByField",'Paperback_ISBN__c');
                component.set("v.showMultiISBNTabISBNArrownUp",false);
                component.set("v.showMultiISBNTabTitleArrownUp",false);
                component.set("v.showMultiISBNTabCurrentAvailArrownUp",false);
                component.set("v.showMultiISBNTabEBookISBNArrownUp",false);
                component.set("v.showMultiISBNTabHardbackISBNArrownUp",false);
                component.set("v.showMultiISBNTabEditionNumberArrownUp",false);
                component.set("v.showMultiISBNTabDiscountPercentArrownUp",false);
                component.set("v.showMultiISBNTabPubDateArrownUp",false);
                component.set("v.showMultiISBNTabPlanPubArrownUp",false);
                component.set("v.showMultiISBNTabAuthorArrownUp",false);
                component.set("v.showMultiISBNTabListPriceArrownUp",false);
                component.set("v.showMultiISBNTabDiscountPriceArrownUp",false);
                component.set("v.isSortingAscMultiISBNDiscountPrice",false);
                component.set("v.isSortingDescMultiISBNDiscountPrice",false);
                component.set("v.isSortingAscMultiISBNDiscountPercent",false);
                component.set("v.isSortingDescMultiISBNDiscountPercent",false);
            }
            if(getTabSelectedValue ==='multiIsbnTab' && getSelectedChildTab === 'uploadCsvTab'){
                if(component.get("v.showMultiISBNCsvTabPaperbackISBNArrownUp") === false){
                    component.set("v.showMultiISBNCsvTabPaperbackISBNArrownUp",true);
                    component.set("v.multiISBNCsvTabSortOrder",'asc');
                }
                else{
                    component.set("v.showMultiISBNCsvTabPaperbackISBNArrownUp",false);
                    component.set("v.multiISBNCsvTabSortOrder",'desc');
                }
                component.set("v.multiISBNCsvTabSortOrderByField",'Paperback_ISBN__c');
                component.set("v.showMultiISBNCsvTabISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabTitleArrownUp",false);
                component.set("v.showMultiISBNCsvTabPubDateArrownUp",false);
                component.set("v.showMultiISBNCsvTabPlanPubArrownUp",false);
                component.set("v.showMultiISBNCsvTabAuthorArrownUp",false);
                component.set("v.showMultiISBNCsvTabCurrentAvailArrownUp",false);
                component.set("v.showMultiISBNCsvTabEBookISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabHardbackISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabEditionNumberArrownUp",false);
                component.set("v.showMultiISBNCsvTabListPriceArrownUp",false);
                component.set("v.showMultiISBNCsvTabDiscountArrownUp",false);
                component.set("v.showMultiISBNCsvTabDiscountPriceArrownUp",false);
                component.set("v.isSortingAscCSVDiscountPrice",false);
                component.set("v.isSortingDescCSVDiscountPrice",false);
                component.set("v.isSortingAscCSVDiscountPercent",false);
                component.set("v.isSortingDescCSVDiscountPercent",false);
            }
        }
        
        if(data === 'HardbackISBN'){
            console.log(component.get("v.showHardbackISBNArrownUp"))
            if(getTabSelectedValue === 'productTab'){
                if(component.get("v.showHardbackISBNArrownUp") === false){
                    console.log('checkj');
                    component.set("v.showHardbackISBNArrownUp",true);
                    component.set("v.sortOrder",'asc');
                    console.log(component.get("v.showHardbackISBNArrownUp"));
                }
                else{
                    component.set("v.showHardbackISBNArrownUp",false);
                    component.set("v.sortOrder",'desc');
                }
                component.set("v.sortOrderByField",'Hardback_ISBN__c');
                component.set("v.showISBNArrownUp",false);
                component.set("v.showTitleArrownUp",false);
                component.set("v.showAuthorArrownUp",false);
                component.set("v.showPubDateArrownUp",false);
                component.set("v.showPlanPubArrownUp",false);
                component.set("v.showListPriceArrownUp",false);
                component.set("v.showCurrentAvailArrownUp",false);
                component.set("v.showEBookISBNArrownUp",false);
                component.set("v.showPaperbackISBNArrownUp",false);
                component.set("v.showEditionNumberArrownUp",false);
                component.set("v.showDiscountPercentArrownUp",false);
                component.set("v.showDiscountPriceArrownUp",false);
                component.set("v.isSortingAscDiscountPrice",false);
                component.set("v.isSortingDescDiscountPrice",false);
                component.set("v.isSortingAscDiscountPercent",false);
                component.set("v.isSortingDescDiscountPercent",false);
            }
            if(getTabSelectedValue ==='multiIsbnTab' && getSelectedChildTab === 'isbnListTab'){
                if(component.get("v.showMultiISBNTabHardbackISBNArrownUp") === false){
                    component.set("v.showMultiISBNTabHardbackISBNArrownUp",true);
                    component.set("v.multiISBNTabSortOrder",'asc');
                }
                else{
                    component.set("v.showMultiISBNTabHardbackISBNArrownUp",false);
                    component.set("v.multiISBNTabSortOrder",'desc');
                }
                component.set("v.multiISBNTabSortOrderByField",'Hardback_ISBN__c');
                component.set("v.showMultiISBNTabISBNArrownUp",false);
                component.set("v.showMultiISBNTabTitleArrownUp",false);
                component.set("v.showMultiISBNTabCurrentAvailArrownUp",false);
                component.set("v.showMultiISBNTabEBookISBNArrownUp",false);
                component.set("v.showMultiISBNTabPaperbackISBNArrownUp",false);
                component.set("v.showMultiISBNTabEditionNumberArrownUp",false);
                component.set("v.showMultiISBNTabDiscountPercentArrownUp",false);
                component.set("v.showMultiISBNTabPubDateArrownUp",false);
                component.set("v.showMultiISBNTabPlanPubArrownUp",false);
                component.set("v.showMultiISBNTabAuthorArrownUp",false);
                component.set("v.showMultiISBNTabListPriceArrownUp",false);
                component.set("v.showMultiISBNTabDiscountPriceArrownUp",false);
                component.set("v.isSortingAscMultiISBNDiscountPrice",false);
                component.set("v.isSortingDescMultiISBNDiscountPrice",false);
                component.set("v.isSortingAscMultiISBNDiscountPercent",false);
                component.set("v.isSortingDescMultiISBNDiscountPercent",false);
            }
            if(getTabSelectedValue ==='multiIsbnTab' && getSelectedChildTab === 'uploadCsvTab'){
                if(component.get("v.showMultiISBNCsvTabHardbackISBNArrownUp") === false){
                    component.set("v.showMultiISBNCsvTabHardbackISBNArrownUp",true);
                    component.set("v.multiISBNCsvTabSortOrder",'asc');
                }
                else{
                    component.set("v.showMultiISBNCsvTabHardbackISBNArrownUp",false);
                    component.set("v.multiISBNCsvTabSortOrder",'desc');
                }
                component.set("v.multiISBNCsvTabSortOrderByField",'Hardback_ISBN__c');
                component.set("v.showMultiISBNCsvTabISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabTitleArrownUp",false);
                component.set("v.showMultiISBNCsvTabPubDateArrownUp",false);
                component.set("v.showMultiISBNCsvTabPlanPubArrownUp",false);
                component.set("v.showMultiISBNCsvTabAuthorArrownUp",false);
                component.set("v.showMultiISBNCsvTabCurrentAvailArrownUp",false);
                component.set("v.showMultiISBNCsvTabEBookISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabPaperbackISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabEditionNumberArrownUp",false);
                component.set("v.showMultiISBNCsvTabListPriceArrownUp",false);
                component.set("v.showMultiISBNCsvTabDiscountArrownUp",false);
                component.set("v.showMultiISBNCsvTabDiscountPriceArrownUp",false);
                component.set("v.isSortingAscCSVDiscountPrice",false);
                component.set("v.isSortingDescCSVDiscountPrice",false);
                component.set("v.isSortingAscCSVDiscountPercent",false);
                component.set("v.isSortingDescCSVDiscountPercent",false);
            }
        }
        if(data === 'editionNumber'){
            console.log(component.get("v.showEditionNumberArrownUp"))
            if(getTabSelectedValue === 'productTab'){
                if(component.get("v.showEditionNumberArrownUp") === false){
                    console.log('checkj');
                    component.set("v.showEditionNumberArrownUp",true);
                    component.set("v.sortOrder",'asc');
                    console.log(component.get("v.showEditionNumberArrownUp"));
                }
                else{
                    component.set("v.showEditionNumberArrownUp",false);
                    component.set("v.sortOrder",'desc');
                }
                component.set("v.sortOrderByField",'Edition_Number__c');
                component.set("v.showISBNArrownUp",false);
                component.set("v.showTitleArrownUp",false);
                component.set("v.showAuthorArrownUp",false);
                component.set("v.showPubDateArrownUp",false);
                component.set("v.showPlanPubArrownUp",false);
                component.set("v.showListPriceArrownUp",false);
                component.set("v.showCurrentAvailArrownUp",false);
                component.set("v.showEBookISBNArrownUp",false);
                component.set("v.showHardbackISBNArrownUp",false);
                component.set("v.showPaperbackISBNArrownUp",false);
                component.set("v.showDiscountPercentArrownUp",false);
                component.set("v.showDiscountPriceArrownUp",false);
                component.set("v.isSortingAscDiscountPrice",false);
                component.set("v.isSortingDescDiscountPrice",false);
                component.set("v.isSortingAscDiscountPercent",false);
                component.set("v.isSortingDescDiscountPercent",false);
            }
            if(getTabSelectedValue ==='multiIsbnTab' && getSelectedChildTab === 'isbnListTab'){
                if(component.get("v.showMultiISBNTabEditionNumberArrownUp") === false){
                    component.set("v.showMultiISBNTabEditionNumberArrownUp",true);
                    component.set("v.multiISBNTabSortOrder",'asc');
                }
                else{
                    component.set("v.showMultiISBNTabEditionNumberArrownUp",false);
                    component.set("v.multiISBNTabSortOrder",'desc');
                }
                component.set("v.multiISBNTabSortOrderByField",'Edition_Number__c');
                component.set("v.showMultiISBNTabISBNArrownUp",false);
                component.set("v.showMultiISBNTabTitleArrownUp",false);
                component.set("v.showMultiISBNTabCurrentAvailArrownUp",false);
                component.set("v.showMultiISBNTabEBookISBNArrownUp",false);
                component.set("v.showMultiISBNTabPaperbackISBNArrownUp",false);
                component.set("v.showMultiISBNTabHardbackISBNArrownUp",false);
                component.set("v.showMultiISBNTabDiscountPercentArrownUp",false);
                component.set("v.showMultiISBNTabPubDateArrownUp",false);
                component.set("v.showMultiISBNTabPlanPubArrownUp",false);
                component.set("v.showMultiISBNTabAuthorArrownUp",false);
                component.set("v.showMultiISBNTabListPriceArrownUp",false);
                component.set("v.showMultiISBNTabDiscountPriceArrownUp",false);
                component.set("v.isSortingAscMultiISBNDiscountPrice",false);
                component.set("v.isSortingDescMultiISBNDiscountPrice",false);
                component.set("v.isSortingAscMultiISBNDiscountPercent",false);
                component.set("v.isSortingDescMultiISBNDiscountPercent",false);
            }
            if(getTabSelectedValue ==='multiIsbnTab' && getSelectedChildTab === 'uploadCsvTab'){
                if(component.get("v.showMultiISBNCsvTabEditionNumberArrownUp") === false){
                    component.set("v.showMultiISBNCsvTabEditionNumberArrownUp",true);
                    component.set("v.multiISBNCsvTabSortOrder",'asc');
                }
                else{
                    component.set("v.showMultiISBNCsvTabEditionNumberArrownUp",false);
                    component.set("v.multiISBNCsvTabSortOrder",'desc');
                }
                component.set("v.multiISBNCsvTabSortOrderByField",'Edition_Number__c');
                component.set("v.showMultiISBNCsvTabISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabTitleArrownUp",false);
                component.set("v.showMultiISBNCsvTabPubDateArrownUp",false);
                component.set("v.showMultiISBNCsvTabPlanPubArrownUp",false);
                component.set("v.showMultiISBNCsvTabAuthorArrownUp",false);
                component.set("v.showMultiISBNCsvTabCurrentAvailArrownUp",false);
                component.set("v.showMultiISBNCsvTabEBookISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabPaperbackISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabHardbackISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabListPriceArrownUp",false);
                component.set("v.showMultiISBNCsvTabDiscountArrownUp",false);
                component.set("v.showMultiISBNCsvTabDiscountPriceArrownUp",false);
                component.set("v.isSortingAscCSVDiscountPrice",false);
                component.set("v.isSortingDescCSVDiscountPrice",false);
                component.set("v.isSortingAscCSVDiscountPercent",false);
                component.set("v.isSortingDescCSVDiscountPercent",false);
            }
        }
        if(data === 'listPrice'){
            console.log(component.get("v.showListPriceArrownUp"))
            if(getTabSelectedValue === 'productTab'){
                if(component.get("v.showListPriceArrownUp") === false){
                    console.log('checkj');
                    component.set("v.showListPriceArrownUp",true);
                    component.set("v.sortOrder",'asc');
                    console.log(component.get("v.showListPriceArrownUp"));
                }
                else{
                    component.set("v.showListPriceArrownUp",false);
                    component.set("v.sortOrder",'desc');
                }
                component.set("v.sortOrderByField",'UnitPrice');
                component.set("v.showISBNArrownUp",false);
                component.set("v.showTitleArrownUp",false);
                component.set("v.showAuthorArrownUp",false);
                component.set("v.showPubDateArrownUp",false);
                component.set("v.showPlanPubArrownUp",false);
                component.set("v.showDiscountPercentArrownUp",false);
                component.set("v.showDiscountPriceArrownUp",false);
                component.set("v.showCurrentAvailArrownUp",false);
                component.set("v.showEBookISBNArrownUp",false);
                component.set("v.showPaperbackISBNArrownUp",false);
                component.set("v.showHardbackISBNArrownUp",false);
                component.set("v.showEditionNumberArrownUp",false);
                component.set("v.isSortingAscDiscountPrice",false);
                component.set("v.isSortingDescDiscountPrice",false);
                component.set("v.isSortingAscDiscountPercent",false);
                component.set("v.isSortingDescDiscountPercent",false);
            }
            if(getTabSelectedValue ==='multiIsbnTab' && getSelectedChildTab === 'isbnListTab'){
                if(component.get("v.showMultiISBNTabListPriceArrownUp") === false){
                    component.set("v.showMultiISBNTabListPriceArrownUp",true);
                    component.set("v.multiISBNTabSortOrder",'asc');
                }
                else{
                    component.set("v.showMultiISBNTabListPriceArrownUp",false);
                    component.set("v.multiISBNTabSortOrder",'desc');
                }
                component.set("v.multiISBNTabSortOrderByField",'UnitPrice');
                component.set("v.showMultiISBNTabISBNArrownUp",false);
                component.set("v.showMultiISBNTabTitleArrownUp",false);
                component.set("v.showMultiISBNTabPubDateArrownUp",false);
                component.set("v.showMultiISBNTabPlanPubArrownUp",false);
                component.set("v.showMultiISBNTabDiscountPercentArrownUp",false);
                component.set("v.showMultiISBNTabAuthorArrownUp",false);
                component.set("v.showMultiISBNTabCurrentAvailArrownUp",false);
                component.set("v.showMultiISBNTabEBookISBNArrownUp",false);
                component.set("v.showMultiISBNTabPaperbackISBNArrownUp",false);
                component.set("v.showMultiISBNTabHardbackISBNArrownUp",false);
                component.set("v.showMultiISBNTabEditionNumberArrownUp",false);
                component.set("v.showMultiISBNTabDiscountPriceArrownUp",false);
                component.set("v.isSortingAscMultiISBNDiscountPrice",false);
                component.set("v.isSortingDescMultiISBNDiscountPrice",false);
                component.set("v.isSortingAscMultiISBNDiscountPercent",false);
                component.set("v.isSortingDescMultiISBNDiscountPercent",false);
            }
            if(getTabSelectedValue ==='multiIsbnTab' && getSelectedChildTab === 'uploadCsvTab'){
                if(component.get("v.showMultiISBNCsvTabListPriceArrownUp") === false){
                    component.set("v.showMultiISBNCsvTabListPriceArrownUp",true);
                    component.set("v.multiISBNCsvTabSortOrder",'asc');
                }
                else{
                    component.set("v.showMultiISBNCsvTabListPriceArrownUp",false);
                    component.set("v.multiISBNCsvTabSortOrder",'desc');
                }
                component.set("v.multiISBNCsvTabSortOrderByField",'UnitPrice');
                component.set("v.showMultiISBNCsvTabISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabTitleArrownUp",false);
                component.set("v.showMultiISBNCsvTabPubDateArrownUp",false);
                component.set("v.showMultiISBNCsvTabPlanPubArrownUp",false);
                component.set("v.showMultiISBNCsvTabDiscountArrownUp",false);
                component.set("v.showMultiISBNCsvTabAuthorArrownUp",false);
                component.set("v.showMultiISBNCsvTabCurrentAvailArrownUp",false);
                component.set("v.showMultiISBNCsvTabEBookISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabPaperbackISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabHardbackISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabEditionNumberArrownUp",false);
                component.set("v.showMultiISBNCsvTabDiscountPriceArrownUp",false);
                component.set("v.isSortingAscCSVDiscountPrice",false);
                component.set("v.isSortingDescCSVDiscountPrice",false);
                component.set("v.isSortingAscCSVDiscountPercent",false);
                component.set("v.isSortingDescCSVDiscountPercent",false);
            }
        }
        if(data === 'discountPercent'){
            if(getTabSelectedValue === 'productTab'){
                if(component.get("v.showDiscountPercentArrownUp") === false){
                    component.set("v.showDiscountPercentArrownUp",true);
                    component.set("v.sortOrder",'desc');
                    component.set("v.isSortingAscDiscountPercent",true);
                    component.set("v.isSortingDescDiscountPercent",false);
                }
                else{
                    component.set("v.showDiscountPercentArrownUp",false);
                    component.set("v.sortOrder",'desc');
                    component.set("v.isSortingDescDiscountPercent",true);
                    component.set("v.isSortingAscDiscountPercent",false);
                }
                component.set("v.sortOrderByField",'Name');
                component.set("v.showISBNArrownUp",false);
                component.set("v.showTitleArrownUp",false);
                component.set("v.showAuthorArrownUp",false);
                component.set("v.showPubDateArrownUp",false);
                component.set("v.showPlanPubArrownUp",false);
                component.set("v.showListPriceArrownUp",false);
                component.set("v.showCurrentAvailArrownUp",false);
                component.set("v.showEBookISBNArrownUp",false);
                component.set("v.showPaperbackISBNArrownUp",false);
                component.set("v.showHardbackISBNArrownUp",false);
                component.set("v.showEditionNumberArrownUp",false);
                component.set("v.showDiscountPriceArrownUp",false);
                component.set("v.isSortingAscDiscountPrice",false);
                component.set("v.isSortingDescDiscountPrice",false);
            }
            if(getTabSelectedValue ==='multiIsbnTab' && getSelectedChildTab === 'isbnListTab'){
                if(component.get("v.showMultiISBNTabDiscountPercentArrownUp") === false){
                    component.set("v.showMultiISBNTabDiscountPercentArrownUp",true);
                    component.set("v.multiISBNTabSortOrder",'desc');
                    component.set("v.isSortingAscMultiISBNDiscountPercent",true);
                    component.set("v.isSortingDescMultiISBNDiscountPercent",false);
                }
                else{
                    component.set("v.showMultiISBNTabDiscountPercentArrownUp",false);
                    component.set("v.multiISBNTabSortOrder",'desc');
                    component.set("v.isSortingDescMultiISBNDiscountPercent",true);
                    component.set("v.isSortingAscMultiISBNDiscountPercent",false);
                }
                component.set("v.multiISBNTabSortOrderByField",'Name');
                component.set("v.showMultiISBNTabISBNArrownUp",false);
                component.set("v.showMultiISBNTabTitleArrownUp",false);
                component.set("v.showMultiISBNTabPubDateArrownUp",false);
                component.set("v.showMultiISBNTabPlanPubArrownUp",false);
                component.set("v.showMultiISBNTabAuthorArrownUp",false);
                component.set("v.showMultiISBNTabListPriceArrownUp",false);
                component.set("v.showMultiISBNTabCurrentAvailArrownUp",false);
                component.set("v.showMultiISBNTabEBookISBNArrownUp",false);
                component.set("v.showMultiISBNTabPaperbackISBNArrownUp",false);
                component.set("v.showMultiISBNTabHardbackISBNArrownUp",false);
                component.set("v.showMultiISBNTabEditionNumberArrownUp",false);
                component.set("v.showMultiISBNTabDiscountPriceArrownUp",false);
                component.set("v.isSortingAscMultiISBNDiscountPrice",false);
                component.set("v.isSortingDescMultiISBNDiscountPrice",false);
            }
            if(getTabSelectedValue ==='multiIsbnTab' && getSelectedChildTab === 'uploadCsvTab'){
                if(component.get("v.showMultiISBNCsvTabDiscountPercentArrownUp") === false){
                    component.set("v.showMultiISBNCsvTabDiscountPercentArrownUp",true);
                    component.set("v.multiISBNCsvTabSortOrder",'desc');
                    component.set("v.isSortingAscCSVDiscountPercent",true);
                    component.set("v.isSortingDescCSVDiscountPercent",false);
                }
                else{
                    component.set("v.showMultiISBNCsvTabDiscountPercentArrownUp",false);
                    component.set("v.multiISBNCsvTabSortOrder",'desc');
                    component.set("v.isSortingAscCSVDiscountPercent",false);
                    component.set("v.isSortingDescCSVDiscountPercent",true);
                }
                component.set("v.multiISBNCsvTabSortOrderByField",'Name');
                component.set("v.showMultiISBNCsvTabISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabTitleArrownUp",false);
                component.set("v.showMultiISBNCsvTabPubDateArrownUp",false);
                component.set("v.showMultiISBNCsvTabPlanPubArrownUp",false);
                component.set("v.showMultiISBNCsvTabAuthorArrownUp",false);
                component.set("v.showMultiISBNCsvTabListPriceArrownUp",false);
                component.set("v.showMultiISBNCsvTabCurrentAvailArrownUp",false);
                component.set("v.showMultiISBNCsvTabEBookISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabPaperbackISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabHardbackISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabEditionNumberArrownUp",false);
                component.set("v.showMultiISBNCsvTabDiscountPriceArrownUp",false);
                component.set("v.isSortingAscCSVDiscountPrice",false);
                component.set("v.isSortingDescCSVDiscountPrice",false);
            }
        }
        if(data === 'discountPrice'){
            if(getTabSelectedValue === 'productTab'){
                if(component.get("v.showDiscountPriceArrownUp") === false){
                    component.set("v.showDiscountPriceArrownUp",true);
                    component.set("v.sortOrder",'desc');
                    component.set("v.isSortingAscDiscountPrice",true);
                    component.set("v.isSortingDescDiscountPrice",false);
                }
                else{
                    component.set("v.showDiscountPriceArrownUp",false);
                    component.set("v.sortOrder",'desc');
                    component.set("v.isSortingDescDiscountPrice",true);
                    component.set("v.isSortingAscDiscountPrice",false);
                }
                component.set("v.sortOrderByField",'Name');
                component.set("v.showISBNArrownUp",false);
                component.set("v.showTitleArrownUp",false);
                component.set("v.showAuthorArrownUp",false);
                component.set("v.showPubDateArrownUp",false);
                component.set("v.showPlanPubArrownUp",false);
                component.set("v.showCurrentAvailArrownUp",false);
                component.set("v.showEBookISBNArrownUp",false);
                component.set("v.showPaperbackISBNArrownUp",false);
                component.set("v.showHardbackISBNArrownUp",false);
                component.set("v.showEditionNumberArrownUp",false);
                component.set("v.showListPriceArrownUp",false);
                component.set("v.showDiscountPercentArrownUp",false);
                component.set("v.isSortingAscDiscountPercent",false);
                component.set("v.isSortingDescDiscountPercent",false);
            }
            if(getTabSelectedValue ==='multiIsbnTab' && getSelectedChildTab === 'isbnListTab'){
                if(component.get("v.showMultiISBNTabDiscountPriceArrownUp") === false){
                    component.set("v.showMultiISBNTabDiscountPriceArrownUp",true);
                    component.set("v.multiISBNTabSortOrder",'desc');
                    component.set("v.isSortingAscMultiISBNDiscountPrice",true);
                    component.set("v.isSortingDescMultiISBNDiscountPrice",false);
                }
                else{
                    component.set("v.showMultiISBNTabDiscountPriceArrownUp",false);
                    component.set("v.multiISBNTabSortOrder",'desc');
                    component.set("v.isSortingDescMultiISBNDiscountPrice",true);
                    component.set("v.isSortingAscMultiISBNDiscountPrice",false);
                }
                component.set("v.multiISBNTabSortOrderByField",'Name');
                component.set("v.showMultiISBNTabISBNArrownUp",false);
                component.set("v.showMultiISBNTabTitleArrownUp",false);
                component.set("v.showMultiISBNTabPubDateArrownUp",false);
                component.set("v.showMultiISBNTabPlanPubArrownUp",false);
                component.set("v.showMultiISBNTabAuthorArrownUp",false);
                component.set("v.showMultiISBNTabListPriceArrownUp",false);
                component.set("v.showMultiISBNTabCurrentAvailArrownUp",false);
                component.set("v.showMultiISBNTabEBookISBNArrownUp",false);
                component.set("v.showMultiISBNTabPaperbackISBNArrownUp",false);
                component.set("v.showMultiISBNTabHardbackISBNArrownUp",false);
                component.set("v.showMultiISBNTabEditionNumberArrownUp",false);
                component.set("v.showMultiISBNTabDiscountPercentArrownUp",false);
                component.set("v.isSortingAscMultiISBNDiscountPercent",false);
                component.set("v.isSortingDescMultiISBNDiscountPercent",false);
            }
            if(getTabSelectedValue ==='multiIsbnTab' && getSelectedChildTab === 'uploadCsvTab'){
                if(component.get("v.showMultiISBNCsvTabDiscountPriceArrownUp") === false){
                    component.set("v.showMultiISBNCsvTabDiscountPriceArrownUp",true);
                    component.set("v.multiISBNCsvTabSortOrder",'desc');
                    component.set("v.isSortingAscCSVDiscountPrice",true);
                    component.set("v.isSortingDescCSVDiscountPrice",false);
                }
                else{
                    component.set("v.showMultiISBNCsvTabDiscountPriceArrownUp",false);
                    component.set("v.multiISBNCsvTabSortOrder",'desc');
                    component.set("v.isSortingAscCSVDiscountPrice",false);
                    component.set("v.isSortingDescCSVDiscountPrice",true);
                }
                component.set("v.multiISBNCsvTabSortOrderByField",'Name');
                component.set("v.showMultiISBNCsvTabISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabTitleArrownUp",false);
                component.set("v.showMultiISBNCsvTabPubDateArrownUp",false);
                component.set("v.showMultiISBNCsvTabPlanPubArrownUp",false);
                component.set("v.showMultiISBNCsvTabAuthorArrownUp",false);
                component.set("v.showMultiISBNCsvTabListPriceArrownUp",false);
                component.set("v.showMultiISBNCsvTabCurrentAvailArrownUp",false);
                component.set("v.showMultiISBNCsvTabEBookISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabPaperbackISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabHardbackISBNArrownUp",false);
                component.set("v.showMultiISBNCsvTabEditionNumberArrownUp",false);
                component.set("v.showMultiISBNCsvTabDiscountPercentArrownUp",false);
                component.set("v.isSortingAscCSVDiscountPercent",false);
                component.set("v.isSortingDescCSVDiscountPercent",false);
            }
        }
        if(getTabSelectedValue === 'productTab'){
            helper.getSearchProductDataHelper(component,event);
        }
        if(getTabSelectedValue === 'multiIsbnTab' && getSelectedChildTab==='isbnListTab'){
            helper.serachMultiIsbnList(component,event);
        }
        if(getTabSelectedValue === 'multiIsbnTab' && getSelectedChildTab==='uploadCsvTab'){
            helper.uploadHelper(component,event);
        }
        /* Redirect to first page */
        var value=1;
        var getSelectedChildTabValue=component.get("v.setSelectedChildTab");
        var getSelectedTabValue=component.get("v.setSelectedTab");
        if(getSelectedTabValue ==='productTab'){
            helper.handlePageDisplayHelper(component, event,value);
        }
        if(getSelectedTabValue ==='multiIsbnTab' && getSelectedChildTabValue === 'isbnListTab'){
            helper.handleMultiIsbnPageDisplayHelper(component, event,value);
        }
        if(getSelectedTabValue ==='multiIsbnTab' && getSelectedChildTabValue === 'uploadCsvTab'){
            helper.handleUploadCSVPageDisplayHelper(component, event,value);
        }
    },
    
    ResetAllData:function(component,event,helper){
        helper.showSpinner(component, event);
        
        component.set('v.ISBNValue',null);
        component.set('v.productTitle',null);
        component.set('v.productAuthor',null);
        component.set('v.minPrice',null);
        component.set('v.maxPrice',null);
        component.set('v.pubFromDate',null);
        component.set('v.pubToDate',null);
        component.set("v.FirstPublishedYearValue",null);
        component.set("v.showSearchData",false);
        
        var appEvent = $A.get("e.c:PPDSearchProductResetComp");
        appEvent.fire();
        
        var emptyList = [];
        component.set("v.multiResultCodes",emptyList);
        component.set("v.multiResultList",emptyList);
        
        
        
        var lstMediumData=[];
        var mediumAllData={'name':'All','value':'All','isChecked':false};
        var mediumEbookData={'name':'e-Book','value':'e-Book','isChecked':true};
        var mediumHardBackData={'name':'Hardback','value':'Hardback','isChecked':false};
        var mediumPaperbackData={'name':'Paperback','value':'Paperback','isChecked':false};
        lstMediumData.push(mediumAllData);
        lstMediumData.push(mediumEbookData);
        lstMediumData.push(mediumHardBackData);
        lstMediumData.push(mediumPaperbackData);
        component.set("v.lstMedium",lstMediumData);
        component.set("v.lstSelectedMedium",'e-Book');
        
        var lstPriceDetail=[];
        component.set("v.lstPublicationPrice",lstPriceDetail);
        var USDPriceDetail={'label':'USD','value':'USD'};
        var GBPPriceDetail={'label':'GBP','value':'GBP'};
        lstPriceDetail.push(USDPriceDetail);
        lstPriceDetail.push(GBPPriceDetail);
        component.set("v.lstPublicationPrice",lstPriceDetail);
        component.set("v.defaultPubPriceValue",'USD');
        component.set("v.selectPriceRadio",'USD');
        
        var lstHasDRMData=[];
        var HasDRMBothData={'name':'All','value':'Both','isChecked':false};
        var HasDRMTrueData={'name':'DRM Protected','value':'True','isChecked':false};
        var HasDRMFalseData={'name':'DRM Free','value':'False','isChecked':true};
        lstHasDRMData.push(HasDRMBothData);
        lstHasDRMData.push(HasDRMTrueData);
        lstHasDRMData.push(HasDRMFalseData);
        component.set("v.lstHasDRM",lstHasDRMData);
        component.set("v.selectDRMRadio",'False');
        
        /*Creating Radio button Data for Not Yet Published Section*/
        var lstpublishData=[];
        var publishIncludeData={'name':'Include','value':'Include','isChecked':true};
        var publishexcludeData={'name':'Exclude','value':'Exclude','isChecked':false};
        var publishNYPData={'name':'Only NYP','value':'Only NYP','isChecked':false};
        lstpublishData.push(publishIncludeData);
        lstpublishData.push(publishexcludeData);
        lstpublishData.push(publishNYPData);
        component.set("v.lstPublished",lstpublishData);
        component.set("v.selectPublishedRadio",null);
        
        helper.hideSpinner(component, event);
        
    },
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    },
    
    likenClose: function(component, event, helper) {
        // Display alert message on the click on the "Like and Close" button from Model Footer 
        // and set set the "isOpen" attribute to "False for close the model Box.
        component.set("v.isOpen", false);
    },
    
    addToSyncData : function(component, event, helper){
        var productId = event.getSource().get("v.value");
        var syncDataWrapper = component.get("v.syncProductDataWrapper");
        var boolFlag = false;
        for(var i in syncDataWrapper){
            if(syncDataWrapper[i].productId == productId){
                boolFlag = true;
            }
        }
        if(boolFlag == false){
            var allProductData = component.get("v.allProductDataWrapper");
            var displayedProductData = component.get("v.lstProductDataWrapper");
            for(var i in allProductData){
                if(allProductData[i].pricebook.Product2.Id == productId){
                    var oppSyncObj = {};
                    oppSyncObj.productId = productId;
                    oppSyncObj.isbnCode = allProductData[i].pricebook.Product2.ISBN__c;
                    oppSyncObj.productName = allProductData[i].pricebook.Product2.Name;
                    oppSyncObj.authorName = allProductData[i].pricebook.Product2.Lead_Author_Editor__c;
                    oppSyncObj.quantity = 1;
                    oppSyncObj.unitPrice = allProductData[i].pricebook.UnitPrice;
                    oppSyncObj.currencyISOCode = allProductData[i].pricebook.CurrencyIsoCode;
                    oppSyncObj.pricebookEntryId = allProductData[i].pricebook.Id;
                    allProductData[i].addedSyncProduct = true;
                    syncDataWrapper.push(oppSyncObj); 
                } 
            }
            for(var i in displayedProductData){
                if(displayedProductData[i].pricebook.Product2.Id == productId){
                    displayedProductData[i].addedSyncProduct = true; 
                }
            }
            component.set("v.allProductDataWrapper",allProductData);
            component.set("v.lstProductDataWrapper",displayedProductData);
            component.set("v.syncProductDataWrapper",syncDataWrapper);
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Duplicate Product',
                message: 'This product is already added to the sync items',
                messageTemplate: 'Record {0} created! See it {1}!',
                duration:'1000',
                key: 'info_alt',
                type: 'warning',
            });
            toastEvent.fire();
            
        }
        
        
    },
    finalSyncSelectedProds : function(component, event, helper){
        debugger;
        var checkboxSyncData = component.get("v.syncProductDataWrapperCheckboxAdd");
        var productId = event.getSource().get("v.value");
        var syncDataWrapper = component.get("v.syncProductDataWrapper");
        var boolFlag = false;
        for(var i in syncDataWrapper){
            for(var j in checkboxSyncData){
                if(syncDataWrapper[i].productId == checkboxSyncData[j].productId){
                    boolFlag = true;
                } 
            }
            
        }
        if(boolFlag == false){
            var allProductData = component.get("v.allProductDataWrapper");
            var displayedProductData = component.get("v.lstProductDataWrapper");
            for(var i in allProductData){
                for(var j in checkboxSyncData){
                    if(allProductData[i].pricebook.Product2.Id == checkboxSyncData[j].productId){
                        var oppSyncObj = {};
                        oppSyncObj.productId = checkboxSyncData[j].productId;
                        oppSyncObj.isbnCode = allProductData[i].pricebook.Product2.ISBN__c;
                        oppSyncObj.productName = allProductData[i].pricebook.Product2.Name;
                        oppSyncObj.authorName = allProductData[i].pricebook.Product2.Lead_Author_Editor__c;
                        oppSyncObj.quantity = 1;
                        oppSyncObj.unitPrice = allProductData[i].pricebook.UnitPrice;
                        oppSyncObj.currencyISOCode = allProductData[i].pricebook.CurrencyIsoCode;
                        oppSyncObj.pricebookEntryId = allProductData[i].pricebook.Id;
                        allProductData[i].addedSyncProduct = true;
                        syncDataWrapper.push(oppSyncObj); 
                    }  
                }
                
            }
            for(var i in displayedProductData){
                for(var j in checkboxSyncData){
                    if(displayedProductData[i].pricebook.Product2.Id == checkboxSyncData[j].productId){
                        displayedProductData[i].addedSyncProduct = true; 
                    }
                }
                
            }
             component.set("v.syncProductDataWrapperCheckboxAdd",[]);
            component.set("v.allProductDataWrapper",allProductData);
            component.set("v.lstProductDataWrapper",displayedProductData);
            component.set("v.syncProductDataWrapper",syncDataWrapper);
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Duplicate Product',
                message: 'This product is already added to the sync items',
                messageTemplate: 'Record {0} created! See it {1}!',
                duration:'1000',
                key: 'info_alt',
                type: 'warning',
            });
            toastEvent.fire();
            
        }
        
        
    },
    addToSyncDataCheckboxButton : function(component, event, helper){
        debugger;
        var productId = event.getSource().get("v.value");
        var isChecked = event.getSource().get("v.checked");
        var isDisabled = event.getSource().get("v.disabled");
        var checkboxSyncData = component.get("v.syncProductDataWrapperCheckboxAdd");
        var allProductData = component.get("v.allProductDataWrapper");
        if(isChecked == true && isDisabled != true){
            for(var i in allProductData){
                if(allProductData[i].pricebook.Product2.Id == productId){
                    var oppSyncObj = {};
                    oppSyncObj.productId = productId;
                    oppSyncObj.isbnCode = allProductData[i].pricebook.Product2.ISBN__c;
                    oppSyncObj.productName = allProductData[i].pricebook.Product2.Name;
                    oppSyncObj.authorName = allProductData[i].pricebook.Product2.Lead_Author_Editor__c;
                    oppSyncObj.quantity = 1;
                    oppSyncObj.unitPrice = allProductData[i].pricebook.UnitPrice;
                    oppSyncObj.currencyISOCode = allProductData[i].pricebook.CurrencyIsoCode;
                    oppSyncObj.pricebookEntryId = allProductData[i].pricebook.Id;
                    //allProductData[i].addedSyncProduct = true;
                    checkboxSyncData.push(oppSyncObj); 
                }
            }
        }
        if(isChecked == false && isDisabled != true){
            for(var i in checkboxSyncData){
                if(checkboxSyncData[i].productId == productId){
                    checkboxSyncData.splice(i, 1);
                }
            }
        }
        component.set("v.syncProductDataWrapperCheckboxAdd",checkboxSyncData);
    },
    removeAddedProduct : function(component, event, helper){
        debugger;
        var allProductData = component.get("v.allProductDataWrapper");
        var displayedProductData = component.get("v.lstProductDataWrapper");
        var deldata = component.get("v.DeleteSyncProductDataWrapper");
        var removeIndex = event.getSource().get("v.value");
        var syncDataWrapper = component.get("v.syncProductDataWrapper");
        if(syncDataWrapper[removeIndex].oppProductId != null){
            deldata.push(syncDataWrapper[removeIndex].oppProductId); 
        }
        for(var i in allProductData){
            if(allProductData[i].pricebook.Product2.Id == syncDataWrapper[removeIndex].productId){
                allProductData[i].addedSyncProduct = false; 
                allProductData[i].productChecked = false; 
            }
        }
        for(var i in displayedProductData){
            if(displayedProductData[i].pricebook.Product2.Id == syncDataWrapper[removeIndex].productId){
                displayedProductData[i].addedSyncProduct = false;
                allProductData[i].productChecked = false;
            }
        }
        syncDataWrapper.splice(removeIndex, 1);
        component.set("v.allProductDataWrapper",allProductData);
        component.set("v.lstProductDataWrapper",displayedProductData);
        component.set("v.syncProductDataWrapper",syncDataWrapper);
        component.set("v.DeleteSyncProductDataWrapper",deldata);
    },
    deleteDataToOpportunity : function(component, event, helper){
        var deldata = component.get("v.DeleteSyncProductDataWrapper");
        var syncDataWrapper = component.get("v.syncProductDataWrapper");
        var allProductData = component.get("v.allProductDataWrapper");
        var displayedProductData = component.get("v.lstProductDataWrapper");
        var deltempdata = [];
        for(var i in syncDataWrapper){
            deltempdata.push(syncDataWrapper[i].productId);
            if(syncDataWrapper[i].oppProductId != null){
                deldata.push(syncDataWrapper[i].oppProductId);
            } 
        }
        for(var j in deltempdata){
            for(var i in allProductData){
                if(allProductData[i].pricebook.Product2.Id == deltempdata[j]){
                    allProductData[i].addedSyncProduct = false;
                    allProductData[i].productChecked = false;
                }
            }
            for(var i in displayedProductData){
                if(displayedProductData[i].pricebook.Product2.Id == deltempdata[j]){
                    displayedProductData[i].addedSyncProduct = false; 
                    allProductData[i].productChecked = false;
                }
            }  
        }
        component.set("v.allProductDataWrapper",allProductData);
        component.set("v.lstProductDataWrapper",displayedProductData);
        component.set("v.syncProductDataWrapper",[]);
        component.set("v.DeleteSyncProductDataWrapper",deldata);
    },
    syncDataToOpportunity : function(component, event, helper){
        helper.syncDataToOpportunityHelper(component, event);
        
    },
    syncAndCancelDataToOpportunity : function(component, event, helper){
        helper.syncDataToOpportunityAndCloseHelper(component, event);
        //component.set("v.isOpen", false);
        
    },
    openProductDataReport : function(component, event, helper){
        window.open('/lightning/r/Report/00O1q000000KUMA/view');
        
    },
    openCurrencyModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.CurrencyisOpen", true);
    },
    
    closeCurrencyModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.CurrencyisOpen", false);
        window.location.reload();
    }
    
})