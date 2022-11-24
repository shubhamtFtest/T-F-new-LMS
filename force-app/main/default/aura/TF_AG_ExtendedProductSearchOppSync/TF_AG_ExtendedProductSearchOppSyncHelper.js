({
    fetchPickListVal: function(component, fieldName, elementId) {
       // debugger;
       var action = component.get("c.getselectOptions");
       action.setParams({
           "objObject": component.get("v.objInfo"),
           "fld": fieldName
       });
       var opts = [];
       action.setCallback(this, function(response) {
           if (response.getState() == "SUCCESS") {
               var allValues = response.getReturnValue();
               var billingCountryList = component.get("v.billingCountryList");
               if (allValues != undefined && allValues.length > 0) {
                   if(billingCountryList != ''){
                       opts.push({
                       class: "optionClass",
                       label: billingCountryList,
                       value: billingCountryList
                   });
                   }else{
                   opts.push({
                       class: "optionClass",
                       label: "-- Select --",
                       value: ""
                   });
                   }
               }
               for (var i = 0; i < allValues.length; i++) {
                   opts.push({
                       class: "optionClass",
                       label: allValues[i],
                       value: allValues[i]
                   });
               }
               //alert(JSON.stringify(opts));
               component.set("v.countryList", opts);
           }
       });
       $A.enqueueAction(action);
   },
    
    getSearchProductDataHelper:function(component,event){
        debugger;
        //this.getProductSearchCount(component,event);
        component.set('v.showZeroData',false);
        var searchText=component.get('v.ISBNValue');
        var productTitle=component.get('v.productTitle');
        var productAuthor=component.get('v.productAuthor');
        var lstSelectedNetbase=component.get("v.lstSelectedNetbase");
        var lstSelectedMediumData=component.get("v.lstSelectedMedium");
        var selectedPublishedData=component.get("v.selectPublishedRadio");
        var selectedPricingData=component.get("v.selectPriceRadio");
        var selectedDRMData=component.get("v.selectDRMRadio");
        var publicationFromDate=component.get("v.pubFromDate");
        var publicationToDate=component.get("v.pubToDate");
        var isSortingASC=component.get("v.isSortingAscDiscountPrice");
        var isSortingDESC=component.get("v.isSortingDescDiscountPrice");
        var	isSortingAscDiscountPercent=component.get("v.isSortingAscDiscountPercent");
        var	isSortingDescDiscountPercent=component.get("v.isSortingDescDiscountPercent");
        var FirstPublishedYearValueList =[];
        if(component.get("v.FirstPublishedYearValue") != undefined && component.get("v.FirstPublishedYearValue") != ''){
            FirstPublishedYearValueList = component.get("v.FirstPublishedYearValue").split(",");
        }
        component.set("v.lstProductNotNullData",[]);
        component.set("v.lstProductData",[]);
        var action = component.get("c.getProductDetails");
        action.setParams({
            ISBN: searchText,
            title:productTitle,
            author:productAuthor,
            Netbase:component.get("v.multiResultCodes"),
            lstSubjectList:component.get("v.multiResultList"),
            lstMediumData:lstSelectedMediumData,
            publishData:selectedPublishedData,
            publcFromDate:publicationFromDate,
            publcToDate:publicationToDate,
            minPrice:component.get("v.minPrice"),
            maxPrice:component.get("v.maxPrice"),
            displayPageData:component.get("v.displayOnePageData"),
            offsetVal:component.get("v.offsetValue"),
            sortBy:component.get("v.sortOrder"),
            sortOrderFieldName:component.get("v.sortOrderByField"),
            drmData:component.get("v.selectDRMRadio"),
            currencyTypeData:component.get("v.selectPriceRadio"),
            firstPublishedYearData:FirstPublishedYearValueList,
            excludeCountryValue:component.get("v.selectCountryRadio")
        });
        
        action.setCallback(this, function(response) {
            this.hideSpinner(component, event);
            var state = response.getState();
            if (state === 'SUCCESS') {
                var datawithcount = JSON.parse(response.getReturnValue());
                component.set('v.moreThanTwoThousandRecord',false);
                component.set('v.moreThanFiftyThousandRecord',false);
                //console.log('length='+data[0].pricebook.Product2.POD__c);
                if(datawithcount !== undefined){
                    //console.log('Data-->'+JSON.stringify(data));
                    /*To Create format for decimal values*/
                    var RecordValidationCheck = component.get("v.noOfRecordValidationCheck");
                    var syncDataWrapper = component.get("v.syncProductDataWrapper");
                    for(var i in datawithcount.prodDataWrap){
                        for(var j in syncDataWrapper){
                            if(syncDataWrapper[j].productId == datawithcount.prodDataWrap[i].pricebook.Product2.Id){
                                datawithcount.prodDataWrap[i].addedSyncProduct = true; 
                                datawithcount.prodDataWrap[i].productChecked = true;
                            }
                        }   
                      }
                    if(RecordValidationCheck == false){
                        var actualDataFromBackend= datawithcount.prodDataWrap;
                        component.set("v.allProductDataWrapper",actualDataFromBackend);
                        var data =[];
                        for(var i in actualDataFromBackend){
                            if(i<component.get("v.displayOnePageData")){
                                data.push(actualDataFromBackend[i]);
                            }
                        }
                        this.dataFromController(component,event,data);
                    }
                    else{
                        component.set("v.noOfRecordValidationCheck",false);
                        var datacount = datawithcount.countRec;
                        console.log('No. of datacount->'+datacount);
                        var returnDataCount;
                        if(datacount !== undefined && datacount>0){
                            if(datacount>49999){
                                this.showToastMessage(component,event,'Return datacount is too large,Please refine your search.','Alert','error');
                                component.set("v.lstProductDataWrapper",[]);
                                component.set("v.showSearchData",false);
                                component.set("v.disableSearch",false);
                                component.set("v.lstProductTableData",[]);
                                component.set("v.showResultCount",false);
                                component.set("v.searchProductTitle","Search");
                            }
                            if(datacount<=49999 && datacount>2000){
                                //this.showToastMessage(component,event,'Return datacount is too large,Please refine your search to get the exact data.','Alert','Warning');
                                component.set('v.moreThanTwoThousandRecord',true);
                                debugger;
                                this.displayPages(component,event,datacount);
                                var actualDataFromBackend= datawithcount.prodDataWrap;
                                component.set("v.allProductDataWrapper",actualDataFromBackend);
                                var data =[];
                                for(var i in actualDataFromBackend){
                                    if(i<component.get("v.displayOnePageData")){
                                        data.push(actualDataFromBackend[i]);
                                    }
                                }
                                this.dataFromController(component,event,data);
                            }
                            if(datacount<2000){
                                debugger;
                                component.set('v.moreThanTwoThousandRecord',false);
                                this.displayPages(component,event,datacount);
                                var actualDataFromBackend= datawithcount.prodDataWrap;
                                component.set("v.allProductDataWrapper",actualDataFromBackend);
                                var data =[];
                                for(var i in actualDataFromBackend){
                                    if(i<component.get("v.displayOnePageData")){
                                        data.push(actualDataFromBackend[i]);
                                    }
                                }
                                this.dataFromController(component,event,data);                    
                            }
                        }
                        else{
                            component.set("v.lstProductDataWrapper",[]);
                            component.set("v.showSearchData",false);
                            component.set("v.disableSearch",false);
                            component.set("v.lstProductTableData",[]);
                            component.set("v.showResultCount",false);
                            component.set("v.searchProductTitle","Search");
                            component.set('v.showZeroData',true);
                            //this.showToastMessage(component,event,'No Match found.','Alert','error');
                        }
                    }
                }
                else{
                    //this.showToastMessage(component,event,'No Match found.','Alert','error');
                    component.set('v.showZeroData',true);
                    component.set("v.lstProductDataWrapper",[]);
                    component.set("v.showSearchData",false);
                    component.set("v.disableSearch",false);
                    component.set("v.lstProductTableData",[]);
                }
            }
            else{
                // this.showToastMessage(component,event,response.getError()[0],'Alert','error');
                component.set('v.moreThanFiftyThousandRecord',true);
                component.set('v.showZeroData',true);
                component.set("v.lstProductDataWrapper",[]);
                component.set("v.showSearchData",false);
                component.set("v.disableSearch",false);
                component.set("v.lstProductTableData",[]);
            }
            component.set("v.searchProductTitle","Search");
            //component.set("v.sortOrderByField","Name");
            //component.set("v.sortOrder","desc");
        });
        $A.enqueueAction(action);
    },
    checkFilterDataValidations:function(component,event){
        debugger;
        var isbnValue =component.get('v.ISBNValue');
        var productTitle=component.get('v.productTitle');
        var productAuthor=component.get('v.productAuthor');
        var subjectListValues = component.get("v.multiResultList");
        var NetbaseValues = component.get("v.multiResultCodes");
        var selectPublishedRadio = component.get("v.selectPublishedRadio");
        var lstSelectedMediumData = component.get('v.lstSelectedMedium');
        var minPrice=component.get("v.minPrice");
        var maxPrice=component.get("v.maxPrice");
        var pubToDate=component.get("v.pubToDate");
        var pubFromDate=component.get("v.pubFromDate");
        var getTabSelectedValue=component.get("v.storeSelectedTabValue");
        var getSelectedChildTab=component.get("v.setSelectedChildTab");
        if((isbnValue === '' || isbnValue === undefined) && (component.get("v.FirstPublishedYearValue") === '' || component.get("v.FirstPublishedYearValue") === undefined) && (productTitle === '' || productTitle === undefined) && (productAuthor==='' || productAuthor === undefined) && (subjectListValues===''||subjectListValues===undefined) && (NetbaseValues===''||NetbaseValues===undefined)
           && (selectPublishedRadio === '' || selectPublishedRadio === undefined) && (lstSelectedMediumData === true) && (minPrice === '' || minPrice === undefined) && (maxPrice === '' || maxPrice === undefined) && (pubToDate == null || pubToDate === undefined) && (pubFromDate == null || pubFromDate === undefined))
        {
            this.showToastMessage(component,event,'Please provide filter informations','Alert','error');
            component.set("v.showSearchData",false);
            component.set("v.lstProductTableData",null);
            
        }
        /*if(productTitle.length<3 && productTitle.length >0)
        {
            this.showToastMessage(component,event,'Please enter atleast 3 charecters for Title','Alert','error');
            component.set("v.showSearchData",false);
            component.set("v.lstProductTableData",null);
        }*/
        else{
            
            if(getTabSelectedValue === 'productTab'){
                component.get("v.showISBNArrownUp",false)
                component.set("v.showTitleArrownUp",false);
                component.set("v.showAuthorArrownUp",false);
                component.set("v.showPubDateArrownUp",false);
                component.set("v.showPlanPubArrownUp",false);
                component.set("v.showDiscountPercentArrownUp",false);
                component.set("v.showListPriceArrownUp",false);
                component.set("v.showCurrentAvailArrownUp",false);
                component.set("v.showDiscountPriceArrownUp",false);
                component.set("v.isSortingAscDiscountPrice",false);
                component.set("v.isSortingDescDiscountPrice",false);
                component.set("v.isSortingAscDiscountPercent",false);
                component.set("v.isSortingDescDiscountPercent",false);
                component.set("v.sortOrder",'Desc');
                component.set("v.sortOrderByField",'Name');
            }
            component.set("v.searchProductTitle","Searching......");
            component.set("v.disableSearch",true);
            //this.getSearchProductDataHelper(component,event);
            
            component.set("v.noOfRecordValidationCheck",true);
            this.getSearchProductDataHelper(component,event);
        }
    },
    checkFilterDataValidationsOnEnter:function(component,event){
        if(event.which === 13){
            this.checkFilterDataValidations(component,event);
        }
    },
    showToastMessage:function(component,event,message,title,type){
        debugger;
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title,
            message:message,
            messageTemplate: 'Mode is pester ,duration is 5sec and Message is overrriden',
            duration:' 5000',
            key: 'info_alt',
            type: type,
            mode: 'sticky'
        });
        toastEvent.fire();
    }, 
    getLoggedInUser:function(component,event){
        var action = component.get("c.getDetails");
        action.setCallback(this, function(response) {
            this.hideSpinner(component, event);
            var state = response.getState();
            if(state === 'SUCCESS'){

                if(response.getReturnValue() != undefined){
                    if(response.getReturnValue().userId !== ''){
                    this.showSpinner(component, event);
                    component.set("v.IsLoggedInUser",true);
                    component.set("v.loggedInUserId",response.getReturnValue());
                    console.log('response.getReturnValue():='+response.getReturnValue()); 
                    this.updateUserDetails(component,event,response.getReturnValue())
                    }                     
                        var lstCountryDetail=component.get("v.lstCountryCode");
                        var blankvalue = {'label':'None','value':'None'};
                        component.set("v.defaultCountryCode",'None');
                    	component.set("v.selectCountryRadio",'None');
                        lstCountryDetail.push(blankvalue);
                    if(response.getReturnValue().countryPickListValues.length>0){
                        for(var i in response.getReturnValue().countryPickListValues) {
                            if(response.getReturnValue().countryPickListValues[i].Text_1__c != undefined && response.getReturnValue().countryPickListValues[i].Text_1__c != undefined){
                                var countryDetail = {'label':response.getReturnValue().countryPickListValues[i].Text_1__c,'value':response.getReturnValue().countryPickListValues[i].Text_1__c};
                                lstCountryDetail.push(countryDetail);
                            }
                            
                        }
                    }
                    component.set("v.lstCountryCode",lstCountryDetail);
                }
            }
        });
        $A.enqueueAction(action);
    },
    updateUserDetails:function(component,event,userId){
        var action = component.get("c.updateUserDetailsFromBMIS");
        action.setParams({
            userId: userId
        });
        action.setCallback(this, function(response) {
            this.hideSpinner(component, event);
            var state = response.getState();
            if(state === 'SUCCESS'){
                if(response.getReturnValue() !== ''){
                    //alert('updatd='+response.getReturnValue().Credit_Terms__c);
                }
            }
        });
        $A.enqueueAction(action);
    },
    serachMultiIsbnList:function(component,event){
        debugger;
        component.set('v.showZeroData',false);
        var listData=component.find('multiIsbn').get("v.value").trim();
        var isSortingAscMultiISBNDiscountPrice=component.get("v.isSortingAscMultiISBNDiscountPrice");
        var isSortingDescMultiISBNDiscountPrice=component.get("v.isSortingDescMultiISBNDiscountPrice");
        var isSortingAscMultiISBNDiscountPercent=component.get("v.isSortingAscMultiISBNDiscountPercent");
        var isSortingDescMultiISBNDiscountPercent=component.get("v.isSortingDescMultiISBNDiscountPercent");
        if(listData !==null){
            if(component.get("v.paginationMultuIsbnDataSearch") == false){
                component.set("v.multiIsbnListData",listData);
                this.getSearchCount(component,event,listData);
                var action = component.get("c.getMultiIsbnList");
                action.setParams({
                    multiIsbn: listData,
                    displayPageData:component.get("v.displayOnePageData"),
                    offsetVal:component.get("v.offsetValue"),
                    sortBy:component.get("v.multiISBNTabSortOrder"),
                    sortOrderFieldName:component.get("v.multiISBNTabSortOrderByField"),
                    pricingData:component.get("v.selectPriceRadio")
                });
                action.setCallback(this, function(a){
                    var state = a.getState();
                    if(state === 'SUCCESS'){
                        var rtnValue = a.getReturnValue();
                        console.log('rtnValue'+JSON.stringify(rtnValue));
                        if(rtnValue.length>0){
                            component.set("v.allLstMultiIsbnProductData",rtnValue);
                            var dataFilter = [];
                            
                            
                            for(var i in rtnValue){
                                if(i<component.get("v.displayOnePageData")){
                                    dataFilter.push(rtnValue[i]);
                                }
                            }
                            
                            
                            this.dataSerachMultiIsbnList(component, event,dataFilter);
                        }  
                        if(rtnValue.length === 0){
                            console.log('rtnValue'+JSON.stringify(rtnValue));
                            this.showToastMessage(component,event,'No Match found.','Alert','error');
                            component.set("v.searchProductMultiISBN",'Search');
                        }
                    }
                    component.set("v.disableMultiIsbnSearchBtn",false);
                });
                $A.enqueueAction(action);
            }
        }
    },
    uploadHelper:function(component, event){
        component.set('v.showZeroData',false);
        var isSortingAscCSVDiscountPrice=component.get("v.isSortingAscCSVDiscountPrice");
        var isSortingDescCSVDiscountPrice=component.get("v.isSortingDescCSVDiscountPrice");
        var isSortingAscCSVDiscountPercent=component.get("v.isSortingAscCSVDiscountPercent");
        var isSortingDescCSVDiscountPercent=component.get("v.isSortingDescCSVDiscountPercent");
        var filename = component.get("v.fileObject");
        if(filename=== null){
            this.showToastMessage(component,event,'Please upload a valid file','Alert','error');
        }
        component.set("v.fileName",filename[0]['name']);
        var file = filename[0];
        var textdata;
        var action = component.get("c.readCSVFile");
        var reader = new FileReader();
        var infolst = [];
        var self=this;
        reader.onload =$A.getCallback( function() {
            var text = reader.result; /*Get the data stored in file*/
            textdata = text;
            if(textdata.length > 30000)
            {
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": 'Alert',
                    "message": "Upload a file less than 30 kb size " ,
                    "type":'error',
                    "mode":'sticky'
                });
                resultsToast.fire();
                component.set("v.searchProductCSV",'Search');
                component.set("v.disableCSVSearchBtn",false);
            }
            else
            {
                //component.set("v.searchProductCSV",'Searching.....');
                var rows = textdata.split("\n"); /*Spilt based on new line to get each row*/
                var tempRow=rows[0].split(',');
                var indexIsbn=tempRow.indexOf('ISBN');
                /* Ignore the first row (header)  and start from second*/
                for (var i = 0; i < rows.length; i = i + 1) {
                    if(rows[i] !== undefined){
                        infolst.push(rows[i]);
                    }
                    //component.set("v.disableCSVSearchBtn",true);
                    component.set("v.uploadCsvListData",infolst);
                }
                //console.log('infolst:='+infolst);
                //console.log('indexIsbn:='+indexIsbn);
                self.getUploadCSVCount(component,event,infolst,indexIsbn); // get count of upload CSV data
                action.setParams({ file : infolst,
                                  isbnIndex: indexIsbn,
                                  displayPageData:component.get("v.displayOnePageData"),
                                  offsetVal:component.get("v.offsetValue"),
                                  sortBy:component.get("v.multiISBNCsvTabSortOrder"),
                                  sortOrderFieldName:component.get("v.multiISBNCsvTabSortOrderByField")
                                 });
                action.setCallback(self, function(actionResult) {
                    var state = actionResult.getState();
                    if(state === 'SUCCESS'){
                        var rtnValue = actionResult.getReturnValue();
                        console.log('rtnValue:='+JSON.stringify(rtnValue));
                        if(rtnValue.length>0){
                            /*To Create format for decimal values*/
                            for(var i=0;i<rtnValue.length;i++){
                                if(typeof(rtnValue[i].discountValue)==='number' && (rtnValue[i].discountValue%1)!==0) {
                                    rtnValue[i].discountValue=rtnValue[i].discountValue.toFixed(2);	
                                }
                                if(typeof(rtnValue[i].pricebook.UnitPrice)==='number' && (rtnValue[i].pricebook.UnitPrice%1)!==0) {
                                    rtnValue[i].pricebook.UnitPrice=rtnValue[i].pricebook.UnitPrice.toFixed(2);	
                                }
                                if(rtnValue[i].discountValue === 0) {
                                    rtnValue[i].discountValue=rtnValue[i].pricebook.UnitPrice;
                                }
                            }
                            
                            /*ASC sort data creation*/
                            if(isSortingAscCSVDiscountPrice){
                                rtnValue.sort(function (a, b) {
                                    return a.discountValue - b.discountValue;
                                });
                                component.set("v.lstProductDataWrapper",rtnValue);
                                console.log("isSortingISBNCSVAsc-->"+component.get("v.isSortingISBNCSVAsc"));
                                //component.set("v.searchProductCSV",'Search');
                                //component.set("v.disableCSVSearchBtn",false);
                                component.set("v.showSearchData",true);
                                component.set("v.offsetValue",0);
                                return false;
                            }
                            
                            /*DESC sort data creation*/
                            if(isSortingDescCSVDiscountPrice){
                                rtnValue.sort(function (a, b) {
                                    return b.discountValue - a.discountValue;
                                });
                                component.set("v.lstProductDataWrapper",rtnValue);
                                console.log("isSortingISBNCSVDesc-->"+component.get("v.isSortingISBNCSVDesc"));
                                //component.set("v.searchProductCSV",'Search');
                                //component.set("v.disableCSVSearchBtn",false);
                                component.set("v.showSearchData",true);
                                component.set("v.offsetValue",0);
                                return false;
                            }
                            
                            /*ASC sort data creation in discount Percent*/
                            if(isSortingAscCSVDiscountPercent){
                                rtnValue.sort(function (a, b) {
                                    return a.discountPercent - b.discountPercent;
                                });
                                component.set("v.lstProductDataWrapper",rtnValue);
                                console.log("isSortingAscDiscountPercent-->"+component.get("v.isSortingAscCSVDiscountPercent"));
                                component.set("v.showSearchData",true);
                                component.set("v.offsetValue",0);
                                return false;
                            }
                            
                            /*DESC sort data creation in discount Percent*/
                            if(isSortingDescCSVDiscountPercent){
                                rtnValue.sort(function (a, b) {
                                    return b.discountPercent - a.discountPercent;
                                });
                                component.set("v.lstProductDataWrapper",rtnValue);
                                console.log("isSortingDescDiscountPercent-->"+component.get("v.isSortingDescCSVDiscountPercent"));
                                component.set("v.showSearchData",true);
                                component.set("v.offsetValue",0);
                                return false;
                            }
                            component.set("v.lstUploadCsvData",rtnValue);
                            component.set("v.lstProductDataWrapper",rtnValue);
                            component.set("v.showSearchData",true);
                            component.set("v.setSelectedTab",'multiIsbnTab');
                            component.set("v.setSelectedChildTab",'uploadCsvTab');
                            component.set("v.offsetValue",0);
                        }  
                        else{
                            this.showToastMessage(component,event,'No Match found.','Alert','error');
                            component.set("v.disableCSVSearchBtn",false);
                            component.set("v.lstUploadCsvData",[]);
                            //component.set("v.lstMultiIsbnProductData",[]);
                            component.set("v.lstProductDataWrapper",[]);
                            component.set("v.showSearchData",false);
                            component.set("v.setSelectedTab",'multiIsbnTab');
                            component.set("v.setSelectedChildTab",'uploadCsvTab');
                            component.set("v.offsetValue",0);
                        }
                    }
                    component.set("v.searchProductCSV",'Search');
                    component.set("v.disableCSVSearchBtn",false);
                });
                $A.enqueueAction(action); 
            }
        });
        
        if (filename[0] !== undefined && filename[0] !== null && filename[0] !== '') {
            reader.readAsText(filename[0]);
        }
        
    },
    getSearchCount:function(component,event,isbnList){
        component.set('v.showZeroData',false);
        var action = component.get("c.getCountOfSearchData");
        action.setParams({ multiIsbnSearchList : isbnList});
        action.setCallback(this, function(a){
            var state = a.getState();
            if(state === 'SUCCESS'){
                var rtnValue = a.getReturnValue();
                this.displayPages(component,event,rtnValue)
            }
        });
        $A.enqueueAction(action);
    },
    getProductSearchCount:function(component,event){
        component.set('v.showZeroData',false);
        var searchText=component.get('v.ISBNValue');
        var productTitle=component.get('v.productTitle');
        var productAuthor=component.get('v.productAuthor');
        var lstSelectedNetbase=component.get("v.lstSelectedNetbase");
        var lstSelectedMediumData=component.get("v.lstSelectedMedium");
        var selectedPublishedData=component.get("v.selectPublishedRadio");
        var publicationFromDate=component.get("v.pubFromDate");
        var publicationToDate=component.get("v.pubToDate");
        var action = component.get("c.getProductSearchCount");
        action.setParams({
            ISBN: searchText,
            title:productTitle,
            author:productAuthor,
            Netbase:component.get("v.multiResultCodes"),
            lstSubjectList:component.get("v.multiResultList"),
            lstMediumData:lstSelectedMediumData,
            publishData:selectedPublishedData,
            publcFromDate:publicationFromDate,
            publcToDate:publicationToDate,
            minPrice:component.get("v.minPrice"),
            maxPrice:component.get("v.maxPrice")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var data = response.getReturnValue();
                console.log('No. of data->'+data);
                var returnDataCount;
                if(data !== undefined && data>0){
                    if(data>2000){
                        this.showToastMessage(component,event,'Return data is too large,Please refine your search.','Alert','error');
                        component.set("v.lstProductDataWrapper",[]);
                        component.set("v.showSearchData",false);
                        component.set("v.disableSearch",false);
                        component.set("v.lstProductTableData",[]);
                        component.set("v.showResultCount",false);
                        component.set("v.searchProductTitle","Search");
                    }
                    if(data<2000){
                        this.displayPages(component,event,data);
                        this.getSearchProductDataHelper(component,event);
                    }
                }
                else{
                    component.set("v.lstProductDataWrapper",[]);
                    component.set("v.showSearchData",false);
                    component.set("v.disableSearch",false);
                    component.set("v.lstProductTableData",[]);
                    component.set("v.showResultCount",false);
                    component.set("v.searchProductTitle","Search");
                    this.showToastMessage(component,event,'No Match found.','Alert','error');
                }
            }
        });
        $A.enqueueAction(action);
    },
    getUploadCSVCount:function(component,event,infolst,indexIsbn){
        component.set('v.showZeroData',false);
        var action = component.get("c.getCsvUploadCount");
        action.setParams({
            ListcsvIsbn:infolst,
            indexIsbn:indexIsbn,
            sortBy:component.get("v.multiISBNCsvTabSortOrder"),
            sortOrderFieldName:component.get("v.multiISBNCsvTabSortOrderByField")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var rtnValue = response.getReturnValue();
                this.displayPages(component,event,rtnValue);
            }
        });
        $A.enqueueAction(action);
    },
    displayPages:function(component,event,rtnValue){
        component.set('v.showZeroData',false);
        var getSelectedTabValue=component.get("v.setSelectedTab");
        var getSelectedChildTabValue=component.get("v.setSelectedChildTab");
        var displayPageData=component.get("v.displayOnePageData");
        var quotient= Math.floor(rtnValue/displayPageData);
        var remainder= rtnValue % displayPageData;
        var iteration;
        if(remainder !== 0 && quotient !== 0){
            iteration=quotient+1;
        }
        else if(quotient !== 0){
            iteration=quotient;
        }
            else{
                iteration=rtnValue;
            }
        var listIterationValues=[];
        for(var i=1;i<=iteration;i++){
            listIterationValues.push(i);
        }
        if(getSelectedTabValue === 'productTab'){
            component.set("v.lstPageIterationCount",listIterationValues);
            var lstDisplayPages=component.get("v.lstDisplayPages");
            if(lstDisplayPages.length === 0){
                if(listIterationValues.length>9){
                    for(var j=0;j<9;j++){
                        lstDisplayPages.push(listIterationValues[j]);
                    }
                }
                else{
                    for(var j=0;j<listIterationValues.length;j++){
                        lstDisplayPages.push(listIterationValues[j]);
                    }
                }
            }
            component.set("v.totalSearchResultCount",rtnValue);
            component.set("v.showProductSearchPages",true);
            component.set("v.showMultiIsbnPages",false);
            component.set("v.showUploadCsvPages",false);
            component.set("v.lstDisplayPages",lstDisplayPages);
            if(rtnValue>component.get("v.displayOnePageData")){
                // It set second page index when page loads first time or page value=1
                if(component.get("v.selectedValue") === 1){
                    component.set("v.secondShowRangeIndex",component.get("v.displayOnePageData"));
                }
                //component.set("v.showPages",true);
            }
            else{
                component.set("v.secondShowRangeIndex",rtnValue);
                //component.set("v.showPages",false);
            }
            component.set("v.showResultCount",true);
            component.set("v.showMultiIsbnPages",false);
        }
        if(getSelectedTabValue === 'multiIsbnTab' && getSelectedChildTabValue !== 'uploadCsvTab'){
            component.set("v.lstMultiIsbnPageIterationCount",listIterationValues);
            var lstDisplayMultiIsbnPages=component.get("v.lstDisplayMultiIsbnPages");
            if(lstDisplayMultiIsbnPages.length === 0){
                if(listIterationValues.length>9){
                    for(var j=0;j<9;j++){
                        lstDisplayMultiIsbnPages.push(listIterationValues[j]);
                    }
                }
                else{
                    for(var j=0;j<listIterationValues.length;j++){
                        lstDisplayMultiIsbnPages.push(listIterationValues[j]);
                    }
                }
            }
            component.set("v.totalMultiIsbnSearchResultCount",rtnValue);
            component.set("v.showMultiIsbnPages",true);
            component.set("v.showProductSearchPages",false);
            component.set("v.lstDisplayMultiIsbnPages",lstDisplayMultiIsbnPages);
            if(rtnValue>component.get("v.displayOnePageData")){
                // It set second page index when page loads first time or page value=1
                if(component.get("v.selectedISBNValue") === 1){
                    component.set("v.secondMulltiIsbnShowRangeIndex",component.get("v.displayOnePageData"));
                }
            }
            else{
                component.set("v.secondMulltiIsbnShowRangeIndex",rtnValue);
            }
            component.set("v.showMultiIsbnResultCount",true);
            component.set("v.showResultCount",false);
        }
        if(getSelectedChildTabValue === 'uploadCsvTab' && getSelectedTabValue === 'multiIsbnTab'){
            component.set("v.lstUploadCSVPageIterationCount",listIterationValues);
            var lstDisplayUploadCsv=component.get("v.lstDisplayUploadCsv");
            if(lstDisplayUploadCsv.length === 0){
                if(listIterationValues.length>9){
                    for(var j=0;j<9;j++){
                        lstDisplayUploadCsv.push(listIterationValues[j]);
                    }
                }
                else{
                    for(var j=0;j<listIterationValues.length;j++){
                        lstDisplayUploadCsv.push(listIterationValues[j]);
                    }
                }
            }
            component.set("v.totalUploadCsvResultCount",rtnValue);
            component.set("v.showUploadCsvPages",true);
            component.set("v.showProductSearchPages",false);
            component.set("v.lstDisplayUploadCsv",lstDisplayUploadCsv);
            if(rtnValue>component.get("v.displayOnePageData")){
                // It set second page index when page loads first time or page value=1
                if(component.get("v.selectedCSVPageValue") === 1){
                    component.set("v.secondUploadCsvShowRangeIndex",component.get("v.displayOnePageData"));
                }
            }
            else{
                component.set("v.secondUploadCsvShowRangeIndex",rtnValue);
            }
            component.set("v.showUploadCsvResultCount",true);
            component.set("v.showResultCount",false);
        }
    },
    csvHelper:function(component,event,helper){
        component.set('v.showZeroData',false);
        var getSelectedChildTabValue=component.get("v.setSelectedChildTab");
        var getSelectedTabValue=component.get("v.setSelectedTab");
        var totalSearchCount=component.get("v.totalSearchResultCount");
        if(getSelectedTabValue ==='productTab'){
            if(totalSearchCount === 0){
                this.showToastMessage(component,event,'Download data not found please refine your search','Alert','error');
            }
            if(totalSearchCount<90000 && totalSearchCount !== 0){
                var searchText=component.get('v.ISBNValue');
                var productTitle=component.get('v.productTitle');
                var productAuthor=component.get('v.productAuthor');
                var lstSelectedNetbase=component.get("v.lstSelectedNetbase");
                var lstSelectedMediumData=component.get("v.lstSelectedMedium");
                var selectedPublishedData=component.get("v.selectPublishedRadio");
                var publicationFromDate=component.get("v.pubFromDate");
                var publicationToDate=component.get("v.pubToDate");
                var data='';
                var action = component.get("c.downloadCsvFileData");
                action.setParams({
                    ISBN: searchText,
                    title:productTitle,
                    author:productAuthor,
                    Netbase:component.get("v.multiResultCodes"),
                    lstSubjectList:component.get("v.multiResultList"),
                    lstMediumData:lstSelectedMediumData,
                    publishData:selectedPublishedData,
                    publcFromDate:publicationFromDate,
                    publcToDate:publicationToDate,
                    minPrice:component.get("v.minPrice"),
                    maxPrice:component.get("v.maxPrice"),
                    sortBy:component.get("v.sortOrder"),
                    sortOrderFieldName:component.get("v.sortOrderByField"),
                    drmData:component.get("v.selectDRMRadio"),
                    currencyTyp:component.get("v.selectPriceRadio"),
                    excludeCountryValue:component.get("v.selectCountryRadio")
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === 'SUCCESS') {
                        data=response.getReturnValue();
                        component.set("v.csvData",data);
                        if(data !== undefined && data.length>0){
                            this.downloadFileAsCsv(component,event,helper);
                        }
                        else{
                            this.showToastMessage(component,event,'No Match found.','Alert','error');
                            component.set("v.lstProductData",[]);
                            component.set("v.showSearchData",false);
                            component.set("v.disableSearch",false);
                        }
                    }
                    else{
                        console.log(response.getError());
                        this.showToastMessage(component,event,response.getError()[0],'Alert','error');
                    }
                });
                $A.enqueueAction(action);
            }
            else if(totalSearchCount > 90000){
                this.showToastMessage(component,event,'90,000 is the maximum number of titles that can be downloaded to Excel from this website, please refine your selection criteria.','Alert','error');
            }
        }
        if(getSelectedTabValue==='multiIsbnTab' && getSelectedChildTabValue==='isbnListTab' ){
            this.multicsvHelper(component,event,helper);
        }
        if(getSelectedTabValue==='multiIsbnTab' && getSelectedChildTabValue==='uploadCsvTab'){
            this.readDownloadFileHelper(component,event,helper);
        }
    },
    multicsvHelper:function(component,event,helper){
        component.set('v.showZeroData',false);
        var multiIsbnSearchResultCount=component.get("v.totalMultiIsbnSearchResultCount");
        console.log("multiIsbnSearchResultCount:"+multiIsbnSearchResultCount);
        if(multiIsbnSearchResultCount === 0){
            this.showToastMessage(component,event,'Download data not found please refine your search','Alert','error');
        }
        if(multiIsbnSearchResultCount<90000 && multiIsbnSearchResultCount !== 0){
            var listData=component.find('multiIsbn').get("v.value").trim();
            console.log("listdata:"+listData);
            if(listData !==null){
                component.set("v.multiIsbnListData",listData);
                //component.set("v.lstDisplayPages",[]);
                this.getSearchCount(component,event,listData);
                var action = component.get("c.downloadMultiFileData");
                action.setParams({
                    multiIsbn: listData,
                    sortBy:component.get("v.multiISBNTabSortOrder"),
                    sortOrderFieldName:component.get("v.multiISBNTabSortOrderByField")
                });
                action.setCallback(this, function(response){
                    var state = response.getState();
                    if(state === 'SUCCESS'){
                        var rtnValue = response.getReturnValue();
                        component.set("v.csvMultiData",rtnValue);
                        console.log("rtnValue"+rtnValue);
                        if(rtnValue !== undefined && rtnValue.length>0){
                            this.downloadFileAsMultiIsbnCsv(component,event,helper);
                        }  
                        if(rtnValue.length === 0){
                            this.showToastMessage(component,event,'No Match found.','Alert','error');
                        }
                    }
                    component.set("v.disableMultiIsbnSearchBtn",false);
                });
                $A.enqueueAction(action);
            }
        }
        else if(multiIsbnSearchResultCount > 90000){
            this.showToastMessage(component,event,'90,000 is the maximum number of titles that can be downloaded to Excel from this website, please refine your selection criteria.','Alert','error');
        }
    },
    readDownloadFileHelper:function(component,event,helper){
        component.set('v.showZeroData',false);
        var uploadCsvSearchResultCount=component.get("v.totalUploadCsvResultCount");
        if(uploadCsvSearchResultCount === 0){
            this.showToastMessage(component,event,'Download data not found please refine your search','Alert','error');
        }
        if(uploadCsvSearchResultCount<90000 && uploadCsvSearchResultCount !== 0){
            var filename = component.get("v.fileObject");
            component.set("v.fileName",filename[0]['name']);
            var file = filename[0];
            var textdata;
            var action = component.get("c.downloadReadCsvFileData");
            var reader = new FileReader();
            var infolst = [];
            var cells;
            var self=this;
            reader.onload =$A.getCallback( function() {
                var text = reader.result; /*Get the data stored in file*/
                textdata = text;
                if(textdata.length > 30000)
                {
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": 'Alert',
                        "message": "Upload a file less than 30 kb size " ,
                        "type":'error',
                        "mode": 'sticky'
                    });
                    resultsToast.fire();
                }
                else{
                    var rows = textdata.split("\n"); /*Spilt based on new line to get each row*/
                    var tempRow=rows[0].split(',');
                    var indexIsbn=tempRow.indexOf('ISBN');
                    /* Ignore the first row (header)  and start from second*/
                    for (var i = 0; i < rows.length; i = i + 1) {
                        if(rows[i] !== undefined){
                            cells = rows[i].split(',');
                            infolst.push(cells[0]);
                        }
                        component.set("v.downloadCsvListData",infolst);
                    }
                    action.setParams({ file : infolst,
                                      isbnIndex: indexIsbn,
                                      sortBy:component.get("v.multiISBNCsvTabSortOrder"),
                                      sortOrderFieldName:component.get("v.multiISBNCsvTabSortOrderByField")
                                     });
                    action.setCallback(self, function(response) {
                        var state = response.getState();
                        if(state === 'SUCCESS'){
                            var rtnValue = response.getReturnValue();
                            if(rtnValue.length>0 && rtnValue.length>0){
                                component.set("v.csvReadFileData",rtnValue);
                                //console.log('ReadCSVrtnValue'+rtnValue)
                                this.downloadFileAsReadFileCsv(component,event,helper);
                            }  
                        }
                    });
                    $A.enqueueAction(action); 
                }
            });
            
            if (filename[0] !== undefined && filename[0] !== null && filename[0] !== '') {
                reader.readAsText(filename[0]);
            }
        }
    },
    downloadFileAsCsv:function(component,event,helper){
        debugger;
        var param=component.get("v.csvData");
        var subjectList=JSON.parse(JSON.stringify(component.get("v.multiResultList")));
        var subjectListPushData=[];
        var value="";
        if(subjectList !== undefined){
            for(var i=0;i<subjectList.length;i++){
                console.log('subjectList inloop->'+subjectList[i]);
                if(subjectList[i].includes("&") !== -1 || subjectList[i].includes(",") !== -1){
                    subjectList[i]=subjectList[i].replace(/&/g, "~");
                    subjectList[i]=subjectList[i].replace(/,/g, "!");
                }
            }
        }  
        var Netbase = JSON.parse(JSON.stringify(component.get("v.multiResultCodes")));
        if(Netbase !== undefined){
            for(var i=0;i<Netbase.length;i++){
                if(Netbase[i].includes("&") !== -1 || Netbase[i].includes(",") !== -1){
                    Netbase[i]=Netbase[i].replace(/&/g, "~");
                    Netbase[i]=Netbase[i].replace(/,/g, "!");
                }
            }
        } 
        var lstSelectedMediumData=component.get("v.lstSelectedMedium");
        var minprice=component.get("v.minPrice");
        var maxprice=component.get("v.maxPrice");
        var encodedParam = encodeURIComponent(param);
        var topURL = window.location.href;
        var TandFApp = topURL.split('/');
        var poup = window.open('https://'+TandFApp[2]+'/apex/TF_AG_ExtendedExportcsv?paramdemo='+encodedParam+'&subjectList='+subjectList+'&Netbase='+Netbase+'&lstSelectedMediumData='+lstSelectedMediumData+'&minprice='+minprice+'&maxprice='+maxprice);
    },
    downloadFileAsMultiIsbnCsv:function(component,event,helper){
        var isbnLst=component.find('multiIsbn').get("v.value").trim();
        var listData=isbnLst.replace( /\n/g, " " ).split( " " );
        //console.log('listParameter'+listData.length);
        var param=component.get("v.csvMultiData");
        var encodedParam = encodeURIComponent(param);
        var topURL = window.location.href;
        var TandFApp = topURL.split('/');
        var poup = window.open('https://'+TandFApp[2]+'/apex/TF_AG_ExtendedExportcsv?paramdemo='+encodedParam+'&multiIsbnListData='+listData);
        
    },
    downloadFileAsReadFileCsv:function(component,event,helper){
        var param=component.get("v.csvReadFileData");
        //console.log("param--->"+param);
        var encodedParam = encodeURIComponent(param);
        var infoList=component.get("v.downloadCsvListData");
        var topURL = window.location.href;
        var TandFApp = topURL.split('/');
        var poup = window.open('https://'+TandFApp[2]+'/apex/TF_AG_ExtendedExportcsv?paramdemo='+encodedParam+'&infoList='+infoList);
    },
    handlePageDisplayHelper:function(component,event,value){
        debugger;
        var totalSearchResultCount=component.get("v.totalSearchResultCount");
        var fixShowPageValues=component.get("v.fixShowPageValues");
        var lstPageIterationCount=component.get("v.lstPageIterationCount");
        var showNextPageValues = Math.floor(fixShowPageValues/2);
        var newPagePopulateValues=[];
        var nextPages=value+showNextPageValues;
        var getSelectedTab=component.get("v.setSelectedTab");
        console.log(value+'**'+showNextPageValues);
        console.log('lstPageIterationCount:'+lstPageIterationCount);
        if(value>showNextPageValues){
            // Execute when selected value + showNextPageValues is less than total array size or page
            if(nextPages<=lstPageIterationCount.length){
                var iterMinValue=value-4<=0?1:value-4;
                var iterMaxValue=value+4>lstPageIterationCount.length?lstPageIterationCount.length:value+4;
                for(var i=iterMinValue;i<=iterMaxValue;i++){
                    newPagePopulateValues.push(i);
                }
                component.set("v.lstDisplayPages",[]);
                component.set("v.lstDisplayPages",newPagePopulateValues);
            }
            if(nextPages>lstPageIterationCount.length){
                
                var arraySize=lstPageIterationCount.length;
                var iterMinValue;
                if((arraySize-value) === 4){
                    iterMinValue=value-4<=0?1:value-4;
                }
                if((arraySize-value) === 3){
                    iterMinValue=value-5<=0?1:value-5;
                }
                if((arraySize-value) === 2){
                    iterMinValue=value-6<=0?1:value-6;
                }
                if((arraySize-value) === 1){
                    iterMinValue=value-7<=0?1:value-7;
                }
                if(arraySize-value === 0){
                    iterMinValue=value-8<=0?1:value-8;
                }
                for(var j=iterMinValue;j<=lstPageIterationCount.length;j++){
                    newPagePopulateValues.push(j);
                }
                component.set("v.lstDisplayPages",[]);
                component.set("v.lstDisplayPages",newPagePopulateValues);
            }
        }
        if(parseInt(value)<=showNextPageValues){
            var listIterationValues=[];
            if(lstPageIterationCount.length>9){
                component.set("v.lstDisplayPages",[]);
                for(var j=0;j<9;j++){
                    listIterationValues.push(lstPageIterationCount[j]);
                }
                component.set("v.lstDisplayPages",listIterationValues);
            }
        }
        component.set("v.selectedValue",value);
        
        // Get the index value of selected page and multiply by display page size
        if(lstPageIterationCount.indexOf(value)!== -1){
            var index=lstPageIterationCount.indexOf(value);
            var offsetVal=index*component.get("v.displayOnePageData");
            component.set("v.offsetValue",offsetVal);
            var actualBankendWrapperData = component.get("v.allProductDataWrapper");
            debugger;
            var count = component.get("v.displayOnePageData") + offsetVal;
            var data = [];
            for(var i in actualBankendWrapperData){ 
                if(count > offsetVal){
                    if(actualBankendWrapperData[offsetVal] != undefined){
                        data.push(actualBankendWrapperData[offsetVal]);
                    }
                }
                offsetVal ++;
            }
            this.dataFromController(component,event,data);
        }
        // Display Range index like showing result 1-5 
        var firstIndex=component.get("v.firstShowRangeIndex");
        var secondIndex=component.get("v.secondShowRangeIndex");
        secondIndex=value*component.get("v.displayOnePageData");
        firstIndex=(secondIndex-component.get("v.displayOnePageData"))+1;
        if(secondIndex>totalSearchResultCount){
            secondIndex=totalSearchResultCount;
        }
        component.set("v.firstShowRangeIndex",firstIndex);
        component.set("v.secondShowRangeIndex",secondIndex);
    },
    handleMultiIsbnPageDisplayHelper:function(component,event,value){
        var totalSearchResultCount=component.get("v.totalMultiIsbnSearchResultCount");
        var fixShowPageValues=component.get("v.fixShowPageValues");
        var lstPageIterationCount=component.get("v.lstMultiIsbnPageIterationCount");
        var showNextPageValues = Math.floor(fixShowPageValues/2);
        var newPagePopulateValues=[];
        var nextPages=value+showNextPageValues;
        var getSelectedTab=component.get("v.setSelectedTab");
        if(value>showNextPageValues){
            // Execute when selected value + showNextPageValues is less than total array size or page
            if(nextPages<=lstPageIterationCount.length){
                var iterMinValue=value-4<=0?1:value-4;
                var iterMaxValue=value+4>lstPageIterationCount.length?lstPageIterationCount.length:value+4;
                for(var i=iterMinValue;i<=iterMaxValue;i++){
                    newPagePopulateValues.push(i);
                }
                component.set("v.lstDisplayMultiIsbnPages",[]);
                component.set("v.lstDisplayMultiIsbnPages",newPagePopulateValues);
            }
            if(nextPages>lstPageIterationCount.length){
                var arraySize=lstPageIterationCount.length;
                var iterMinValue;
                if((arraySize-value) === 4){
                    iterMinValue=value-4<=0?1:value-4;
                }
                if((arraySize-value) === 3){
                    iterMinValue=value-5<=0?1:value-5;
                }
                if((arraySize-value) === 2){
                    iterMinValue=value-6<=0?1:value-6;
                }
                if((arraySize-value) === 1){
                    iterMinValue=value-7<=0?1:value-7;
                }
                if(arraySize-value === 0){
                    iterMinValue=value-8<=0?1:value-8;
                }
                for(var j=iterMinValue;j<=lstPageIterationCount.length;j++){
                    newPagePopulateValues.push(j);
                }
                component.set("v.lstDisplayMultiIsbnPages",[]);
                component.set("v.lstDisplayMultiIsbnPages",newPagePopulateValues);
            }
        }
        if(parseInt(value)<=showNextPageValues){
            var listIterationValues=[];
            if(lstPageIterationCount.length>9){
                component.set("v.lstDisplayMultiIsbnPages",[]);
                for(var j=0;j<9;j++){
                    listIterationValues.push(lstPageIterationCount[j]);
                }
                component.set("v.lstDisplayMultiIsbnPages",listIterationValues);
            }
        }
        component.set("v.selectedISBNValue",value);
        
        // Get the index value of selected page and multiply by display page size
        if(lstPageIterationCount.indexOf(value)!== -1){
            var index=lstPageIterationCount.indexOf(value);
            var offsetVal=index*component.get("v.displayOnePageData");
            component.set("v.offsetValue",offsetVal);
            component.set("v.paginationMultuIsbnDataSearch",true);
            var actualBankendWrapperData = component.get("v.allLstMultiIsbnProductData");
            debugger;
            var count = component.get("v.displayOnePageData") + offsetVal;
            var data = [];
            for(var i in actualBankendWrapperData){ 
                if(count > offsetVal){
                    if(actualBankendWrapperData[offsetVal] != undefined){
                        data.push(actualBankendWrapperData[offsetVal]);
                    }
                }
                offsetVal ++;
            }
            this.dataSerachMultiIsbnList(component,event,data);
            
            
            //this.serachMultiIsbnList(component,event);
        }
        // Display Range index like showing result 1-5 
        var firstIndex=component.get("v.firstMulltiIsbnShowRangeIndex");
        var secondIndex=component.get("v.secondMulltiIsbnShowRangeIndex");
        secondIndex=value*component.get("v.displayOnePageData");
        firstIndex=(secondIndex-component.get("v.displayOnePageData"))+1;
        if(secondIndex>totalSearchResultCount){ 
            secondIndex=totalSearchResultCount;
        }
        component.set("v.firstMulltiIsbnShowRangeIndex",firstIndex);
        component.set("v.secondMulltiIsbnShowRangeIndex",secondIndex);
    },
    handleUploadCSVPageDisplayHelper:function(component,event,value){
        var totalSearchResultCount=component.get("v.totalUploadCsvResultCount");
        var fixShowPageValues=component.get("v.fixShowPageValues");
        var lstPageIterationCount=component.get("v.lstUploadCSVPageIterationCount");
        var showNextPageValues = Math.floor(fixShowPageValues/2);
        var newPagePopulateValues=[];
        var nextPages=value+showNextPageValues;
        if(value>showNextPageValues){
            // Execute when selected value + showNextPageValues is less than total array size or page
            if(nextPages<=lstPageIterationCount.length){
                var iterMinValue=value-4<=0?1:value-4;
                var iterMaxValue=value+4>lstPageIterationCount.length?lstPageIterationCount.length:value+4;
                for(var i=iterMinValue;i<=iterMaxValue;i++){
                    newPagePopulateValues.push(i);
                }
                component.set("v.lstDisplayUploadCsv",[]);
                component.set("v.lstDisplayUploadCsv",newPagePopulateValues);
            }
            if(nextPages>lstPageIterationCount.length){
                var arraySize=lstPageIterationCount.length;
                var iterMinValue;
                if((arraySize-value) === 4){
                    iterMinValue=value-4<=0?1:value-4;
                }
                if((arraySize-value) === 3){
                    iterMinValue=value-5<=0?1:value-5;
                }
                if((arraySize-value) === 2){
                    iterMinValue=value-6<=0?1:value-6;
                }
                if((arraySize-value) === 1){
                    iterMinValue=value-7<=0?1:value-7;
                }
                if(arraySize-value === 0){
                    iterMinValue=value-8<=0?1:value-8;
                }
                for(var j=iterMinValue;j<=lstPageIterationCount.length;j++){
                    newPagePopulateValues.push(j);
                }
                component.set("v.lstDisplayUploadCsv",[]);
                component.set("v.lstDisplayUploadCsv",newPagePopulateValues);
            }
        }
        if(parseInt(value)<=showNextPageValues){
            var listIterationValues=[];
            if(lstPageIterationCount.length>9){
                component.set("v.lstDisplayUploadCsv",[]);
                for(var j=0;j<9;j++){
                    listIterationValues.push(lstPageIterationCount[j]);
                }
                component.set("v.lstDisplayUploadCsv",listIterationValues);
            }
        }
        component.set("v.selectedCSVPageValue",value);
        console.log("selectedCSVPageValue-"+component.get("v.selectedCSVPageValue"));
        // Get the index value of selected page and multiply by display page size
        if(lstPageIterationCount.indexOf(value)!== -1){
            var index=lstPageIterationCount.indexOf(value);
            var offsetVal=index*component.get("v.displayOnePageData");
            component.set("v.offsetValue",offsetVal);
            this.uploadHelper(component,event);
        }
        // Display Range index like showing result 1-5 
        var firstIndex=component.get("v.firstUploadCsvShowRangeIndex");
        var secondIndex=component.get("v.secondUploadCsvShowRangeIndex");
        secondIndex=value*component.get("v.displayOnePageData");
        firstIndex=(secondIndex-component.get("v.displayOnePageData"))+1;
        if(secondIndex>totalSearchResultCount){ 
            secondIndex=totalSearchResultCount;
        }
        component.set("v.firstUploadCsvShowRangeIndex",firstIndex);
        component.set("v.secondUploadCsvShowRangeIndex",secondIndex);
    },
    dataFromController : function(component,event,data){
        var isSortingASC=component.get("v.isSortingAscDiscountPrice");
        var isSortingDESC=component.get("v.isSortingDescDiscountPrice");
        var isSortingAscDiscountPercent=component.get("v.isSortingAscDiscountPercent");
        var isSortingDescDiscountPercent=component.get("v.isSortingDescDiscountPercent");
        if(data !== undefined && data.length>0){
            for(var i=0;i<data.length;i++){
                if(typeof(data[i].discountValue)==='number' && (data[i].discountValue%1)!==0) {
                    data[i].discountValue=data[i].discountValue.toFixed(2); 
                }
                if(typeof(data[i].pricebook.UnitPrice)==='number' && (data[i].pricebook.UnitPrice%1)!==0) {
                    data[i].pricebook.UnitPrice=data[i].pricebook.UnitPrice.toFixed(2); 
                }
                if(data[i].discountValue === 0) {
                    data[i].discountValue=data[i].pricebook.UnitPrice;
                }
            }  
            
            /*ASC sort data creation in discount price*/
            if(isSortingASC){
                data.sort(function (a, b) {
                    return a.discountValue - b.discountValue;
                });
                component.set("v.lstProductDataWrapper",data);
                console.log("isSortingASC-->"+component.get("v.isSortingAscDiscountPrice"));
                return false;
            }
            
            /*DESC sort data creation in discount price*/
            if(isSortingDESC){
                data.sort(function (a, b) {
                    return b.discountValue - a.discountValue;
                });
                component.set("v.lstProductDataWrapper",data);
                console.log("isSortingDESC-->"+component.get("v.isSortingDescDiscountPrice"));
                return false;
            }
            
            /*ASC sort data creation in discount Percent*/
            if(isSortingAscDiscountPercent){
                data.sort(function (a, b) {
                    return a.discountPercent - b.discountPercent;
                });
                component.set("v.lstProductDataWrapper",data);
                console.log("isSortingAscDiscountPercent-->"+component.get("v.isSortingAscDiscountPercent"));
                return false;
            }
            
            /*DESC sort data creation in discount Percent*/
            if(isSortingDescDiscountPercent){
                data.sort(function (a, b) {
                    return b.discountPercent - a.discountPercent;
                });
                component.set("v.lstProductDataWrapper",data);
                console.log("isSortingDescDiscountPercent-->"+component.get("v.isSortingDescDiscountPercent"));
                return false;
            }
            
            component.set("v.lstProductDataWrapper",data);
            component.set("v.lstProductTableData",data);
            component.set("v.showSearchData",true);
            window.scrollBy(0, 300);
            component.set("v.lstSelectedNetbase",[]);
            component.set("v.lstSelectedSubjectList",[]);
            component.set("v.disableSearch",false);
        }
        else{
            this.showToastMessage(component,event,'No Match found.','Alert','error');
            component.set("v.lstProductDataWrapper",[]);
            component.set("v.showSearchData",false);
            component.set("v.disableSearch",false);
            component.set("v.lstProductTableData",[]);
        }
    },
    dataSerachMultiIsbnList : function(component, event,data){
        debugger;
        var rtnValue = data
        var isSortingAscMultiISBNDiscountPrice=component.get("v.isSortingAscMultiISBNDiscountPrice");
        var isSortingDescMultiISBNDiscountPrice=component.get("v.isSortingDescMultiISBNDiscountPrice");
        var isSortingAscMultiISBNDiscountPercent=component.get("v.isSortingAscMultiISBNDiscountPercent");
        var isSortingDescMultiISBNDiscountPercent=component.get("v.isSortingDescMultiISBNDiscountPercent");
        /*To Create format for decimal values*/
        for(var i=0;i<rtnValue.length;i++){
            if(typeof(rtnValue[i].discountValue)==='number' && (rtnValue[i].discountValue%1)!==0) {
                rtnValue[i].discountValue=rtnValue[i].discountValue.toFixed(2); 
            }
            if(typeof(rtnValue[i].pricebook.UnitPrice)==='number' && (rtnValue[i].pricebook.UnitPrice%1)!==0) {
                rtnValue[i].pricebook.UnitPrice=rtnValue[i].pricebook.UnitPrice.toFixed(2); 
            }
            if(rtnValue[i].discountValue === 0) {
                rtnValue[i].discountValue=rtnValue[i].pricebook.UnitPrice;
            }
        }
        /*ASC sort data creation*/
        if(isSortingAscMultiISBNDiscountPrice){
            rtnValue.sort(function (a, b) {
                return a.discountValue - b.discountValue;
            });
            component.set("v.lstProductDataWrapper",rtnValue);
            component.set("v.allProductDataWrapper",rtnValue);
            console.log("isSortingISBNAsc-->"+component.get("v.isSortingAscMultiISBNDiscountPrice"));
            component.set("v.searchProductMultiISBN",'Search');
            component.set("v.showSearchData",true);
            component.set("v.offsetValue",0);
            return false;
        }
        
        /*DESC sort data creation*/
        if(isSortingDescMultiISBNDiscountPrice){
            rtnValue.sort(function (a, b) {
                return b.discountValue - a.discountValue;
            });
            component.set("v.lstProductDataWrapper",rtnValue);
            component.set("v.allProductDataWrapper",rtnValue);
            console.log("isSortingISBNDesc-->"+component.get("v.isSortingDescMultiISBNDiscountPrice"));
            component.set("v.searchProductMultiISBN",'Search');
            component.set("v.showSearchData",true);
            component.set("v.offsetValue",0);
            return false;
        }
        
        /*ASC sort data creation in discount Percent*/
        if(isSortingAscMultiISBNDiscountPercent){
            rtnValue.sort(function (a, b) {
                return a.discountPercent - b.discountPercent;
            });
            component.set("v.lstProductDataWrapper",rtnValue);
            component.set("v.allProductDataWrapper",rtnValue);
            console.log("isSortingAscDiscountPercent-->"+component.get("v.isSortingAscMultiISBNDiscountPercent"));
            component.set("v.searchProductMultiISBN",'Search');
            component.set("v.showSearchData",true);
            component.set("v.offsetValue",0);
            return false;
        }
        
        /*DESC sort data creation in discount Percent*/
        if(isSortingDescMultiISBNDiscountPercent){
            rtnValue.sort(function (a, b) {
                return b.discountPercent - a.discountPercent;
            });
            component.set("v.lstProductDataWrapper",rtnValue);
            component.set("v.allProductDataWrapper",rtnValue);
            console.log("isSortingDescDiscountPercent-->"+component.get("v.isSortingDescMultiISBNDiscountPercent"));
            component.set("v.searchProductMultiISBN",'Search');
            component.set("v.showSearchData",true);
            component.set("v.offsetValue",0);
            return false;
        }
        
        component.set("v.searchProductMultiISBN",'Search');
        console.log(JSON.stringify(rtnValue));
        component.set("v.lstMultiIsbnProductData",rtnValue);
        //component.set("v.lstProductData",rtnValue)
        component.set("v.lstProductDataWrapper",rtnValue);
        component.set("v.allProductDataWrapper",rtnValue);
        component.set("v.showSearchData",true);
        component.set("v.offsetValue",0);
    },
    showSpinner: function(component, event) {
        // make Spinner attribute true for display loading spinner 
        debugger;
        component.set("v.mySpinner", true); 
    },
    
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event){
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.mySpinner", false);
    },
    leaveHandler: function(event) {
        event.returnValue = "To navigate back to product search please use the “Back to results” button";
    },
    preventLeaving: function() {
        window.addEventListener("beforeunload", this.leaveHandler);
    },
    allowLeaving: function() {
        window.removeEventListener("beforeunload", this.leaveHandler);
    },
    syncDataToOpportunityHelper : function(component, event){
        this.showSpinner(component, event);
        var recId = component.get("v.recordId");
        var syncDataWrapper = component.get("v.syncProductDataWrapper");
        var deldata = component.get("v.DeleteSyncProductDataWrapper");
        var JSONDelData = JSON.stringify(deldata);
        var JSONData = JSON.stringify(syncDataWrapper);
        
        var action = component.get("c.syncProductsToOpportunity");
        action.setParams({
            frontEndData:JSONData,
            delOppItem:JSONDelData,
            oppId:recId
        });
        action.setCallback(this, function(response) {
            this.hideSpinner(component, event);
            var state = response.getState();
            if(state === 'SUCCESS'){
                $A.get('e.force:refreshView').fire();
                if(response.getReturnValue() !== ''){
                    
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Sync Completed',
                        message: 'All the selected products are synced to the current opportunity',
                        messageTemplate: 'Record {0} created! See it {1}!',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    
                    
                    //alert('Sync Complete');
                    var JSONData = response.getReturnValue();
                    var backendData = JSON.parse(JSONData);
                    component.set("v.syncProductDataWrapper",backendData);
                    var emptyList = [];
                    component.set("v.DeleteSyncProductDataWrapper",emptyList);
                }
            }
        });
        $A.enqueueAction(action);        
    },
    syncDataToOpportunityAndCloseHelper : function(component, event){
        this.showSpinner(component, event);
        var recId = component.get("v.recordId");
        var syncDataWrapper = component.get("v.syncProductDataWrapper");
        var deldata = component.get("v.DeleteSyncProductDataWrapper");
        var JSONDelData = JSON.stringify(deldata);
        var JSONData = JSON.stringify(syncDataWrapper);
        
        var action = component.get("c.syncProductsToOpportunity");
        action.setParams({
            frontEndData:JSONData,
            delOppItem:JSONDelData,
            oppId:recId
        });
        action.setCallback(this, function(response) {
            this.hideSpinner(component, event);
            var state = response.getState();
            if(state === 'SUCCESS'){
                $A.get('e.force:refreshView').fire();
                if(response.getReturnValue() !== ''){
                    
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Sync Completed',
                        message: 'All the selected products are synced to the current opportunity',
                        messageTemplate: 'Record {0} created! See it {1}!',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    
                    
                    //alert('Sync Complete');
                    //var JSONData = response.getReturnValue();
                    //var backendData = JSON.parse(JSONData);
                    //component.set("v.syncProductDataWrapper",backendData);
                    //var emptyList = [];
                    //component.set("v.DeleteSyncProductDataWrapper",emptyList);
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                      "recordId": recId,
                      "slideDevName": "detail"
                    });
                    navEvt.fire();
                    
                }
            }
        });
        $A.enqueueAction(action);        
    },
    fetchOpportunityLineOnPageLoad : function(component,event){
        var recId = component.get("v.recordId"); 
        var action = component.get("c.fetchOppLines");
        action.setParams({
            oppId:recId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                if(response.getReturnValue() !== ''){
                    var JSONData = response.getReturnValue();
                    var backendData = JSON.parse(JSONData);
                    component.set("v.billingCountryList",backendData.billingCountryList);
                    if(backendData.oppSyncDataList != undefined){
                    component.set("v.syncProductDataWrapper",backendData.oppSyncDataList);
                    }
                    if(backendData.currrencyISOCode == undefined){
                        component.set("v.CurrencyisOpen", true);
                    }
                    else{
                        component.set("v.selectPriceRadio",backendData.currrencyISOCode);
                    }
                }
            }
        });
        $A.enqueueAction(action); 
    }
})