({
    init : function(component, event, helper) {
        var action1 = component.get("c.getCurrencyDetails");
        component.set("v.mySpinner", true); 
        action1.setParams({
            "quoteId" : component.get('v.RecordId'),
        });
        action1.setCallback(this, function(response) {
            component.set("v.mySpinner", false); 
            var state = response.getState();
            if (state === "SUCCESS") {
                var dataList = response.getReturnValue();
                component.set('v.quoteCurrencyCode',dataList[0]);
                var LicenceListData = [];
                for(var i in dataList){
                    if(i != 0){
                        LicenceListData.push(dataList[i]);
                    }
                }
                component.set('v.LicenceTypeList',LicenceListData); 
            }
        });
        $A.enqueueAction(action1);
        
        
        var action = component.get("c.fetchQuoteLines");
        component.set("v.mySpinner", true); 
        action.setParams({
            "quoteId" : component.get('v.RecordId'),
        });
        action.setCallback(this, function(response) {
            component.set("v.mySpinner", false); 
            var state = response.getState();
            if (state === "SUCCESS") {
                var JSONData = response.getReturnValue();
                var backendData = JSON.parse(JSONData);
                component.set("v.productListPCM",backendData);
                var emptyList = [];
                component.set("v.DeleteSyncProductDataWrapper",emptyList);
            }
        });
        $A.enqueueAction(action);
        
        //Shalini: changes regarding ticket SAL-4182(Frontlist Chapter)
        var action = component.get("c.fetchQuoteOrderType");
        component.set("v.mySpinner", true); 
        action.setParams({
            "quoteId" : component.get('v.RecordId'),
        });
        action.setCallback(this, function(response) {
            component.set("v.mySpinner", false); 
            var state = response.getState();
            if (state === "SUCCESS") {
                if(!$A.util.isEmpty(response.getReturnValue()) && !$A.util.isUndefinedOrNull(response.getReturnValue()))
                {
                    component.set("v.quoteOrderType",response.getReturnValue());
                }
            }
        });
        $A.enqueueAction(action);
        //Shalini: changes end regarding ticket SAL-4182
    },
    addProductUI : function(component, event, helper){
        debugger;
        var LicenceData = component.get('v.LicenceTypeList');
        var action = component.get("c.getProductDetails");
        action.setParams({
            "quoteId" : component.get('v.RecordId'),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.PricebkEntProductList",result);
                console.log('result-->'+result);
                
                var salesforceProdList = component.get("v.PricebkEntProductList");
                var prodRecString = event.getParam("PCMSearchDetails");
                var prodRecList = JSON.parse(prodRecString);
                console.log(prodRecList);
                var prodWrapperList = component.get('v.productListPCM');
                for(var i in prodRecList){
                    var alreadyAddedFlag = false;
                    for(var j in prodWrapperList){
                        if(prodRecList[i].doi != undefined || prodRecList[i].isbn != undefined){
                            if(prodRecList[i].doi == prodWrapperList[j].PCMDOI || (prodRecList[i].isbn == prodWrapperList[j].PCMISBN)){
                                alreadyAddedFlag = true;
                            }
                        }
                    }
                    
                    if(alreadyAddedFlag == false){
                        var listObj = {};
                        if(prodRecList[i].isbn != undefined){
                            listObj.PCMISBN = prodRecList[i].isbn;
                        }
                        if(prodRecList[i].author != undefined){
                            listObj.PCMAuthor = prodRecList[i].author;
                        }
                        if(prodRecList[i].name != undefined){
                            listObj.PCMProductName = prodRecList[i].name;
                        }
                        if(prodRecList[i].doi != undefined){
                            listObj.PCMDOI = prodRecList[i].doi;
                        }
                        //Shalini: changes regarding ticket SAL-4182(Frontlist Order)
                        if(prodRecList[i].id != undefined){
                            listObj.PCMUUID = prodRecList[i].id;
                        }
                        if(prodRecList[i].id != undefined){
                            listObj.PCMType = prodRecList[i].type;
                        }
                        /*if(prodRecList[i].priceBYOUSD != undefined){
                            listObj.UnitPrice = prodRecList[i].priceBYOUSD;
                        }*/ 
                        
                        if(salesforceProdList.length>0){
                            listObj.SFDCProdList = salesforceProdList; 
                        }
                        if(LicenceData.length>0){
                            listObj.SFDCLicenceData = LicenceData; 
                        }
                        prodWrapperList.push(listObj);
                    }
                }
                console.log('prodWrapperList--> '+JSON.stringify(prodWrapperList));
                component.set('v.productListPCM',prodWrapperList);
            }
        });
        $A.enqueueAction(action);
    },
    
    onChangeMasterProduct : function(component,event,helper){
        debugger;
        var selectedProductIndex = event.getSource().get("v.title");
        var prodToSync = component.get('v.productListPCM');
        for(var j in prodToSync[selectedProductIndex].SFDCProdList){
            if(prodToSync[selectedProductIndex].SFDCProdList[j].PricebkEntProduct.Name == prodToSync[selectedProductIndex].SalesforceProductName){
                prodToSync[selectedProductIndex].UnitPrice =  prodToSync[selectedProductIndex].SFDCProdList[j].PricebkEntProduct.UnitPrice;
            }
        }
        component.set('v.productListPCM',prodToSync);
    },
    onChangeLicenceType : function(component,event,helper){
        debugger;
        var selectedLicence = event.getSource().get("v.title"); 
    },
    syncToQuote : function(component,event,helper){
        debugger;
        var prodToSync = component.get('v.productListPCM');
        var deldata = component.get("v.DeleteSyncProductDataWrapper");
        var quoteOrderType = component.get("v.quoteOrderType");//Shalini
        var productNotSelectedFlag = false;
        var prodNameSelectError = "";
        
        for(var i in prodToSync){
            if(prodToSync[i].SalesforceProductName != null && prodToSync[i].SalesforceProductName != undefined && prodToSync[i].SalesforceProductName != ""){
                for(var j in prodToSync[i].SFDCProdList){
                    if(prodToSync[i].SalesforceProductName == prodToSync[i].SFDCProdList[j].PricebkEntProduct.Name){
                        prodToSync[i].SalesforceProductId = prodToSync[i].SFDCProdList[j].PricebkEntProduct.Product2Id;
                        prodToSync[i].SalesforcePriceBookEntry = prodToSync[i].SFDCProdList[j].PricebkEntProduct.Id;
                    }
                }
                console.log('prodToSync--> '+JSON.stringify(prodToSync));
                //Shalini: changes regarding ticket SAL-4182(Frontlist Order)
                if(!$A.util.isEmpty(prodToSync[i].PCMType) && !$A.util.isUndefinedOrNull(prodToSync[i].PCMType)
                   && !$A.util.isEmpty(quoteOrderType) && !$A.util.isUndefinedOrNull(quoteOrderType))
                {
                    if(quoteOrderType === 'Backlist Chapter' && prodToSync[i].PCMType !== 'chapter')
                    {
                        helper.showToastMessage(component, event, helper, 'For Backlist Chapter order type please select a chapter for '+ prodToSync[i].PCMProductName,'Error','Error');                                                                          
                        return;
                    }
                    else if(quoteOrderType === 'Backlist eBook' && prodToSync[i].PCMType !== 'book')
                    {
                        helper.showToastMessage(component, event, helper, 'For Backlist eBook order type please select a book for '+ prodToSync[i].PCMProductName,'Error','Error');                                                                          
                        return;
                    }
                        else if(quoteOrderType === 'Frontlist Chapter' && (prodToSync[i].PCMType !== 'book' && prodToSync[i].PCMType !== 'EBK-CHAPTER-FRONTLIST'))
                        {
                            helper.showToastMessage(component, event, helper, 'For Frontlist Chapter order type please select a book for '+ prodToSync[i].PCMProductName,'Error','Error');                                                                          
                            return;
                        }
                    //Shalini: changes for frontlist eBook ticket SAL-4328
                            else if(quoteOrderType === 'Frontlist eBook' && (prodToSync[i].PCMType !== 'book' && prodToSync[i].PCMType !== 'EBOOK-FRONTLIST'))
                            {
                                helper.showToastMessage(component, event, helper, 'For Frontlist eBook order type please select a book for '+ prodToSync[i].PCMProductName,'Error','Error');                                                                          
                                return;
                            }
                    //because for frontlist chapter order OH wants this value in lineItemType field
                    if(quoteOrderType === 'Frontlist Chapter' && prodToSync[i].PCMType === 'book')
                    {
                        prodToSync[i].PCMType = 'EBK-CHAPTER-FRONTLIST';
                    }
                    //Shalini: changes for frontlist eBook ticket SAL-4328
                    if(quoteOrderType === 'Frontlist eBook' && prodToSync[i].PCMType === 'book')
                    {
                        prodToSync[i].PCMType = 'EBOOK-FRONTLIST';
                    }
                }
                //Shalini: changes end regarding ticket SAL-4182
                
                
            }
            else{
                productNotSelectedFlag = true;
                prodNameSelectError = 'Please select Prodcuct Sub type for ' + prodToSync[i].PCMProductName;
            }
        }
        if(productNotSelectedFlag == false){
            console.log('prodToSync');
            console.log(prodToSync);
            component.set("v.mySpinner", true); 
            var action = component.get("c.syncDataToQuoteLine");
            action.setParams({
                "quoteId" : component.get('v.RecordId'),
                "DataToSync": JSON.stringify(prodToSync),
                "DataToDelete": JSON.stringify(deldata),
                "currencyCode" : component.get('v.quoteCurrencyCode')
            });
            action.setCallback(this, function(response) {
                component.set("v.mySpinner", false); 
                var state = response.getState();
                if (state === "SUCCESS") {
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
                        
                        var JSONData = response.getReturnValue();
                        var backendData = JSON.parse(JSONData);
                        component.set("v.productListPCM",backendData);
                        var emptyList = [];
                        component.set("v.DeleteSyncProductDataWrapper",emptyList);
                    }
                }
            });
            $A.enqueueAction(action);
            
            
            
            
            
            
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message: prodNameSelectError,
                duration:' 5000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
        }
        
        
    },
    syncToQuoteAndClose : function(component,event,helper){
        debugger;
        var prodToSync = component.get('v.productListPCM');
        var duplicateProds = component.get('v.DuplicateProductsList');
        var deldata = component.get("v.DeleteSyncProductDataWrapper");
        var quoteOrderType = component.get("v.quoteOrderType");//Shalini
        var productNotSelectedFlag = false;
        var prodNameSelectError = "";
        
        for(var i in prodToSync){
            if(prodToSync[i].SalesforceProductName != null && prodToSync[i].SalesforceProductName != undefined && prodToSync[i].SalesforceProductName != ""){
                for(var j in prodToSync[i].SFDCProdList){
                    if(prodToSync[i].SalesforceProductName == prodToSync[i].SFDCProdList[j].PricebkEntProduct.Name){
                        prodToSync[i].SalesforceProductId = prodToSync[i].SFDCProdList[j].PricebkEntProduct.Product2Id;
                        prodToSync[i].SalesforcePriceBookEntry = prodToSync[i].SFDCProdList[j].PricebkEntProduct.Id;
                    }
                }
                
                console.log('prodToSync--> '+JSON.stringify(prodToSync)); 
                //Shalini: changes regarding ticket SAL-4182(Frontlist Order)
                if(!$A.util.isEmpty(prodToSync[i].PCMType) && !$A.util.isUndefinedOrNull(prodToSync[i].PCMType)
                   && !$A.util.isEmpty(quoteOrderType) && !$A.util.isUndefinedOrNull(quoteOrderType))
                {
                    if(quoteOrderType === 'Backlist Chapter' && prodToSync[i].PCMType !== 'chapter')
                    {
                        helper.showToastMessage(component, event, helper, 'For Backlist Chapter order type please select a chapter for '+ prodToSync[i].PCMProductName,'Error','Error');                                                                          
                        return;
                    }
                    else if(quoteOrderType === 'Backlist eBook' && prodToSync[i].PCMType !== 'book')
                    {
                        helper.showToastMessage(component, event, helper, 'For Backlist eBook order type please select a book for '+ prodToSync[i].PCMProductName,'Error','Error');                                                                          
                        return;
                    }
                        else if(quoteOrderType === 'Frontlist Chapter' && (prodToSync[i].PCMType !== 'book' && prodToSync[i].PCMType !== 'EBK-CHAPTER-FRONTLIST'))
                        {
                            helper.showToastMessage(component, event, helper, 'For Frontlist Chapter order type please select a book for '+ prodToSync[i].PCMProductName,'Error','Error');                                                                          
                            return;
                        }
                    //Shalini: changes for frontlist eBook ticket SAL-4328
                            else if(quoteOrderType === 'Frontlist eBook' && (prodToSync[i].PCMType !== 'book' && prodToSync[i].PCMType !== 'EBOOK-FRONTLIST'))
                            {
                                helper.showToastMessage(component, event, helper, 'For Frontlist eBook order type please select a book for '+ prodToSync[i].PCMProductName,'Error','Error');                                                                          
                                return;
                            }
                    //because for frontlist chapter order OH wants this value in lineItemType field
                    if(quoteOrderType === 'Frontlist Chapter' && prodToSync[i].PCMType === 'book')
                    {
                        prodToSync[i].PCMType = 'EBK-CHAPTER-FRONTLIST';
                    }
                    //Shalini: changes for frontlist eBook ticket SAL-4328
                    if(quoteOrderType === 'Frontlist eBook' && prodToSync[i].PCMType === 'book')
                    {
                        prodToSync[i].PCMType = 'EBOOK-FRONTLIST';
                    }
                }
                //Shalini: changes end regarding ticket SAL-4182
                
            }
            else{
                productNotSelectedFlag = true;
                prodNameSelectError = 'Please select Prodcuct Sub type for ' + prodToSync[i].PCMProductName;
            }
            
        }
        if(productNotSelectedFlag == false){
            console.log('prodToSync');
            console.log(prodToSync);
            component.set("v.mySpinner", true); 
            var action = component.get("c.syncDataToQuoteLine");
            action.setParams({
                "quoteId" : component.get('v.RecordId'),
                "DataToSync": JSON.stringify(prodToSync),
                "DataToDelete": JSON.stringify(deldata),
                "currencyCode" : component.get('v.quoteCurrencyCode')
            });
            action.setCallback(this, function(response) {
                component.set("v.mySpinner", false); 
                var state = response.getState();
                if (state === "SUCCESS") {
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
                        
                        var JSONData = response.getReturnValue();
                        var backendData = JSON.parse(JSONData);
                        component.set("v.productListPCM",backendData);
                        var emptyList = [];
                        component.set("v.DeleteSyncProductDataWrapper",emptyList);
                        
                        
                        var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                            "recordId": component.get('v.RecordId'),
                            "slideDevName": "detail"
                        });
                        navEvt.fire();
                    }
                }
            });
            $A.enqueueAction(action);
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message: prodNameSelectError,
                duration:' 5000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
        }
    },
    
    removeAddedProduct : function(component, event, helper){
        debugger;
        var allProductData = component.get('v.productListPCM');
        var deldata = component.get("v.DeleteSyncProductDataWrapper");
        var removeIndex = event.getSource().get("v.value");
        if(allProductData[removeIndex].quoteLineRecId != null){
            deldata.push(allProductData[removeIndex].quoteLineRecId);
        }
        allProductData.splice(removeIndex, 1);
        component.set("v.productListPCM",allProductData);
        component.set("v.DeleteSyncProductDataWrapper",deldata);
        
    },
    deleteDataToQuote : function(component, event, helper){
        debugger;
        var allProductData = component.get('v.productListPCM');
        var deldata = component.get("v.DeleteSyncProductDataWrapper");
        for(var i in allProductData){
            if(allProductData[i].quoteLineRecId != null){
                deldata.push(allProductData[i].quoteLineRecId); 
            }
        }
        component.set("v.productListPCM",[]);
        component.set("v.DeleteSyncProductDataWrapper",deldata);
    },
    
    handleUploadFinished : function(component, event, helper){
        debugger;
        component.set("v.mySpinner", true);
        var quoteOrderType = component.get("v.quoteOrderType");
        
        var fileInput = event.getParam("files");
        var file = fileInput[0];
        if (file){
            var reader = new FileReader();
            reader.readAsText(file, "UTF-8");
            reader.onload = function (evt) {
                
                var csv = evt.target.result;
                console.log('csv file contains'+ csv);
                var result = helper.CSV2JSON(component,csv);
                console.log('result '+result);
                if(!$A.util.isEmpty(result) && !$A.util.isUndefinedOrNull(result))
                {
                    var resultParse = JSON.parse(result);
                    component.set('v.csvUploadedDataList',resultParse);
                    
                    var prodToSync = component.get('v.productListPCM');
                    var csvUploadedDataList = component.get('v.csvUploadedDataList');
                    
                    for(var i in prodToSync){
                        //Upload CSV only when product subtype is prsent otherwise through error
                        if(prodToSync[i].SalesforceProductName != null && prodToSync[i].SalesforceProductName != undefined && prodToSync[i].SalesforceProductName != "")
                        {
                            if(!$A.util.isEmpty(prodToSync[i].PCMISBN) && !$A.util.isUndefinedOrNull(prodToSync[i].PCMISBN))
                            {
                                for(var j in csvUploadedDataList){
                                    if(quoteOrderType === 'Backlist Chapter' && prodToSync[i].PCMDOI === csvUploadedDataList[j].DOI)
                                    {
                                        if(!$A.util.isEmpty(csvUploadedDataList[j].Price) && !$A.util.isUndefinedOrNull(csvUploadedDataList[j].Price) && csvUploadedDataList[j].Price != 0)
                                            prodToSync[i].UnitPrice = csvUploadedDataList[j].Price;    
                                        
                                        if(!$A.util.isEmpty(csvUploadedDataList[j].LineReference) && !$A.util.isUndefinedOrNull(csvUploadedDataList[j].LineReference))
                                            prodToSync[i].PONumber = csvUploadedDataList[j].LineReference;
                                    }
                                    else if(prodToSync[i].PCMISBN === csvUploadedDataList[j].ISBN)
                                    {
                                        if(!$A.util.isEmpty(csvUploadedDataList[j].Price) && !$A.util.isUndefinedOrNull(csvUploadedDataList[j].Price) && csvUploadedDataList[j].Price != 0)
                                            prodToSync[i].UnitPrice = csvUploadedDataList[j].Price;    
                                        
                                        if(!$A.util.isEmpty(csvUploadedDataList[j].LineReference) && !$A.util.isUndefinedOrNull(csvUploadedDataList[j].LineReference))
                                            prodToSync[i].PONumber = csvUploadedDataList[j].LineReference;
                                    }
                                }
                            }
                        }
                        else{
                            helper.showToastMessage(component, event, helper, 'Please select Prodcuct Sub type for ' + prodToSync[i].PCMProductName +' before uploading the CSV file.','Error','Error');                                                                          
                            return;
                        }
                        
                    }
                    component.set('v.productListPCM', prodToSync);
                }
                
            }
            reader.onerror = function (evt) {
                console.log('Error in reading file');
                helper.showToastMessage(component, event, helper, 'Something is wrong in CSV file, please check it and try again!!','Error','Error');                                                                          
                component.set("v.mySpinner", false); 
                return;
            }
        }
        component.set("v.mySpinner", false); 
        
    },
    
    //SFAL-20 changes added by shubham  for Entitlements starts:
     checkForEntitlements : function(component,event,helper){
        debugger;
        var prodToSync = component.get('v.productListPCM');
        var isbnSet = [];
        for(var i in prodToSync){
            isbnSet.push(prodToSync[i].PCMUUID);
        }
         
        isbnSet = isbnSet.slice(0,50);
        
        console.log('prodToSync');
        console.log(prodToSync);
        component.set("v.mySpinner", true); 
        var action = component.get("c.getEntitlementDetails");
        action.setParams({
            "quoteId" : component.get('v.RecordId'),
            "ProductType": 'BOOK',
            "ISBNNumbers": isbnSet,
        });
        action.setCallback(this, function(response) {
            component.set("v.mySpinner", false); 
            var state = response.getState();
            if (state === "SUCCESS") {
                var duplicateMess = '';
                if(response.getReturnValue() !== '' && response.getReturnValue() !== null && response.getReturnValue() !== undefined){
                    if(response.getReturnValue().length == 1)
                    {
                        duplicateMess = 'This customer has an existing entitlement for ' +response.getReturnValue()[0] +'. Are you sure you wish to add this item to the quote?';
                        component.set("v.DuplicateProductsList",response.getReturnValue());
                        
                        var duplicateProds = component.get('v.DuplicateProductsList');
                        for(let i = 0; i < duplicateProds.length; i++){
                            for (let j = 0; j < prodToSync.length; j++) {
                                if(prodToSync[j].PCMProductName == duplicateProds[i]){
                                    prodToSync[j].isDuplicate  = true;
                                }else{
                                    
                                }
                            }
                        }
                        component.set("v.productListPCM",prodToSync);
                        component.set("v.duplicateProductsMessage",duplicateMess);
                        component.set("v.duplicateProductsEntitled",true);
                        
                    }
                    else if(response.getReturnValue().length > 1){
                        duplicateMess = 'The customer has existing entitlements for some of the products you selected.  Are you sure you wish to add these products again?';
                        
                        component.set("v.DuplicateProductsList",response.getReturnValue());
                        
                        var duplicateProds = component.get('v.DuplicateProductsList');
                        for(let i = 0; i < duplicateProds.length; i++){
                            for (let j = 0; j < prodToSync.length; j++) {
                                if(prodToSync[j].PCMProductName == duplicateProds[i]){
                                    prodToSync[j].isDuplicate  = true;
                                }
                            }
                        }
                        component.set("v.productListPCM",prodToSync);
                        component.set("v.duplicateProductsMessage",duplicateMess);
                        component.set("v.duplicateProductsEntitled",true);
                    }
                        else{
                            $A.enqueueAction(component.get('c.syncToQuoteAndClose'));
                        }
                    
                }else{
                    $A.enqueueAction(component.get('c.syncToQuoteAndClose'));
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    
    handleConfirmDialog : function(component, event, helper) {
        component.set('v.duplicateProductsEntitled', true);
    },
    
    handleConfirmDialogYes : function(component, event, helper) {
        debugger;
        console.log('Yes');
        $A.enqueueAction(component.get('c.syncToQuoteAndClose'));
        component.set('v.duplicateProductsEntitled', false);
    },
    
    handleConfirmDialogNo : function(component, event, helper) {
        console.log('No');
        component.set('v.duplicateProductsEntitled', false);
    },
})