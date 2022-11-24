({
    init : function(component, event, helper) {
        debugger;
        var action1 = component.get("c.getCurrencyDetails");
        component.set("v.mySpinner", true); 
        action1.setParams({
            "quoteId" : component.get('v.RecordId'),
        });
        action1.setCallback(this, function(response) {
            component.set("v.mySpinner", false); 
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('result14' + JSON.stringify(result));
                component.set('v.quoteCurrencyCode',result);
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
                console.log('result14' + JSON.stringify(backendData));
                component.set("v.productListPCM",backendData);
                if(backendData != undefined && backendData != null && backendData.length > 0){
                    if(backendData[0].BundleLineItems != null && backendData[0].BundleLineItems != undefined){
                        component.set("v.BundleLineItems",backendData[0].BundleLineItems);
                    }    
                }
                var emptyList = [];
                component.set("v.DeleteSyncProductDataWrapper",emptyList);
            }
        });
        $A.enqueueAction(action);
        
        var getThresholdValueFunction = component.get("c.getCustomSettingData");
        getThresholdValueFunction.setParams({
            "quoteId" : component.get('v.RecordId'),
        });
        getThresholdValueFunction.setCallback(this, function(response) {
            if (component.isValid() && response !== null && response.getState() == 'SUCCESS') {
                if(response.getReturnValue() != null && response.getReturnValue() != undefined){
                    component.set("v.threshHoldVal", response.getReturnValue().threshHold);
                    component.set("v.productRecordType", response.getReturnValue().recordTypeId);
                    component.set("v.BespokeBusinessId", response.getReturnValue().bespokeBusinessId);
                    component.set("v.salesType", response.getReturnValue().salesType);
                }
            } else {
                console.log("Failed to load Custom Setting.");
            }
        });
        $A.enqueueAction(getThresholdValueFunction);
    },
    
    addProductUI : function(component, event, helper){
        debugger;
        var existingProducts = component.get("v.productListPCM");
        var salesforceProdList = component.get("v.PricebkEntProductList");
        var bundleExisting = false;
        var ProductType = '';
        var newBundleLIPrice = 0;
        if(existingProducts.length > 0){
            for(var i in existingProducts){
                if(existingProducts[i].Bundled == true){
                    bundleExisting = true;
                    component.set("v.BundleProductId",existingProducts[i].Product__c);
                }
            }
        }
        //Added By shubham Kumar - SFAL 379
        if(bundleExisting == true){
            debugger;
            //To be checked For Duplicacy : doi__c  &  uuid__c || 
            var existingBundles = component.get("v.BundleLineItems");
            var prodRecString = event.getParam("PCMSearchDetails");
            var prodRecList = JSON.parse(prodRecString);
            
            var similarBundles = [];
            var nonSimilarBundles = [];
            for(var i in prodRecList){
                var alreadyAddedFlag = false;
                for(var j in existingBundles){
                    if(prodRecList[i].doi != undefined || prodRecList[i].id != undefined){
                        if((prodRecList[i].doi == existingBundles[j].doi__c) || (prodRecList[i].id == existingBundles[j].uuid__c)){
                            alreadyAddedFlag = true;
                            if(prodRecList[j] != undefined){
                                similarBundles.push(prodRecList[j].name);    
                            }
                        }
                    }
                }
                if(alreadyAddedFlag == false){
                    if(prodRecList[i] != undefined){
                        //notSimilar.push(prodRecList[i].name);
                        var listObj = {};
                        if(prodRecList[i].priceISUSD != undefined && prodRecList[i].priceISUSD != undefined){
                            newBundleLIPrice = newBundleLIPrice + prodRecList[i].priceISUSD;    
                            listObj.UnitPrice = prodRecList[i].priceISUSD;
                        }
                        if(prodRecList[i].isbn != undefined){
                            listObj.PCMISBN = prodRecList[i].isbn;
                        }
                        if(prodRecList[i].author != undefined){
                            listObj.PCMAuthor = prodRecList[i].author;
                        }
                        if(prodRecList[i].name != undefined){
                            listObj.PCMProductName = prodRecList[i].name;
                        }
                        if(prodRecList[i].id  != undefined){
                            listObj.PCMUUID = prodRecList[i].id;
                        }
                        if(prodRecList[i].doi != undefined){
                            listObj.PCMDOI = prodRecList[i].doi;
                        }
                        //Added by shubham kumar for mapping to Bundle Line Items..
                        if(prodRecList[i].type != undefined){
                            listObj.type = prodRecList[i].type;
                        }
                        if(prodRecList[i].format != undefined){
                            listObj.format = prodRecList[i].format;
                        }
                        if(prodRecList[i].openAccess != undefined){
                            listObj.openAccess  = prodRecList[i].openAccess;
                        }
                        if(prodRecList[i].publicationDate != undefined){
                            listObj.publicationDate  = prodRecList[i].publicationDate;
                        }
                        if(prodRecList[i].status != undefined){
                            listObj.status  = prodRecList[i].status ;
                        }
                        if(prodRecList[i].publisherImprint  != undefined){
                            listObj.publisher  = prodRecList[i].publisherImprint  ;
                        }
                        if(prodRecList[i].sku  != undefined){
                            listObj.sku  = prodRecList[i].sku;
                            //listObj.sku ='01t7Y0000094XauQAE';
                        }
                        nonSimilarBundles.push(listObj);
                    }
                }
            }
            component.set("v.NewBundleLineItems",nonSimilarBundles);
            component.set("v.newBundleLIPrice",newBundleLIPrice);
            $A.enqueueAction(component.get('c.updateBundleMethod'));
            //this.updateBundleMethod(component, event, helper);
        }else{
            
            var action = component.get("c.getProductDetailsByType");
            var prodRecString = event.getParam("PCMSearchDetails");
            var prodRecList = JSON.parse(prodRecString);
            console.log('prodRecList##'+prodRecList);
            //var prodType=  prodRecList[i].type;  //'book';
            //console.log('prodType159' + prodType);
            var isbnSet = [];
            var uuidsSet=[];
            var numOfRecsSelected = 0;
            var prodType;
            for(var i in prodRecList){
                // changes made by rohit for SFAL -628 
                 prodType=  prodRecList[i].type;
                if(prodRecList[i].type == 'collection'){
                    console.log('prodRecList##id##'+prodRecList[i].id);
                    uuidsSet.push(prodRecList[i].id);
                    numOfRecsSelected = numOfRecsSelected+1;   
                }else if(prodRecList[i].type == 'book'){
                    isbnSet.push(prodRecList[i].isbn);
                    numOfRecsSelected = numOfRecsSelected+1;   
                }
            }
            component.set("v.selectedProdCount", numOfRecsSelected);
            action.setParams({
                "quoteCurrencyCode" : component.get('v.quoteCurrencyCode'),
                "isbnSet" : isbnSet,
                "productType":prodType,
                "uuidsSet":uuidsSet
            }); 
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log('insuccess');
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    component.set("v.PricebkEntProductList",result);
                    console.log('result-->'+result);
                    var salesforceProdList = component.get("v.PricebkEntProductList");
                    console.log('prodRecList '+ JSON.stringify(prodRecList));
                    
                    var prodWrapperList = component.get('v.productListPCM');
                    for(var i in prodRecList){//Selected checkbox records
                        var alreadyAddedFlag = false;
                        for(var j in prodWrapperList){//fetchQuoteLines existing in salesforce records
                            if(prodRecList[i].isbn != undefined){
                                if(prodRecList[i].isbn == prodWrapperList[j].PCMISBN){
                                    alreadyAddedFlag = true;
                                }
                            }
                        }
                        console.log('at201');
                        if(alreadyAddedFlag == false){
                            var listObj = {};
                            
                            if(prodRecList[i].isbn != undefined){
                                listObj.PCMISBN = prodRecList[i].isbn;
                            }
                            if(prodRecList[i].priceISUSD != undefined){
                                listObj.UnitPrice = prodRecList[i].priceISUSD;
                            }
                            if(prodRecList[i].author != undefined){
                                listObj.PCMAuthor = prodRecList[i].author;
                            }
                            if(prodRecList[i].name != undefined){
                                listObj.PCMProductName = prodRecList[i].name;
                            }
                            if(prodRecList[i].id  != undefined){
                                listObj.PCMUUID = prodRecList[i].id;
                            }
                            if(prodRecList[i].doi != undefined){
                                listObj.PCMDOI = prodRecList[i].doi;
                            }
                            //Added by shubham kumar for mapping to Bundle Line Items..
                            if(prodRecList[i].type != undefined){
                                listObj.type = prodRecList[i].type;
                            }
                            if(prodRecList[i].format != undefined){
                                listObj.format = prodRecList[i].format;
                            }
                            if(prodRecList[i].openAccess != undefined){
                                listObj.openAccess  = prodRecList[i].openAccess;
                            }
                            if(prodRecList[i].publicationDate != undefined){
                                listObj.publicationDate  = prodRecList[i].publicationDate;
                            }
                            if(prodRecList[i].status != undefined){
                                listObj.status  = prodRecList[i].status ;
                            }
                            //chages made by rohit dua 
                            if(prodRecList[i].sku != undefined){
                                listObj.sku  = prodRecList[i].sku ;
                                listObj.SalesforceProductId  = prodRecList[i].sku ;
                                
                            }
                            if(prodRecList[i].priceBYOGBP != undefined){
                                listObj.priceBYOGBP = prodRecList[i].priceBYOGBP;
                            }
                            if(prodRecList[i].priceBYOUSD != undefined){
                                listObj.priceBYOUSD = prodRecList[i].priceBYOUSD;
                            }
                            // end rohit dua
                            if(prodRecList[i].publisherImprint  != undefined){
                                listObj.publisher  = prodRecList[i].publisherImprint  ;
                            }
                            console.log('salesforceProdList253' + JSON.stringify(salesforceProdList));
                            if(salesforceProdList.length>0){
                                listObj.SFDCProdList = salesforceProdList;
                                if(prodType=='book'){
                                    console.log('prodRecList[i].isbn' + prodRecList[i].isbn);
                                    if(prodRecList[i].isbn != null && prodRecList[i].isbn != undefined && prodRecList[i].isbn != ""){
                                        for(var j in salesforceProdList){
                                            console.log('alesforceProdList[j].PricebkEntProduct.Product2.ISBN__c)' + salesforceProdList[j].PricebkEntProduct.Product2.ISBN__c);
                                          // changes made by rohit dua for SFAL - 628
                                            if(prodRecList[i].isbn == salesforceProdList[j].PricebkEntProduct.Product2.ISBN__c){
                                                listObj.OriginalListPrice = salesforceProdList[j].OriginalListPrice1;
                                                listObj.UnitPrice = salesforceProdList[j].PricebkEntProduct.UnitPrice;
                                            }
                                        }
                                    }
                                }
                                else if(prodType=='collection'){
                                    if(prodRecList[i].id != null && prodRecList[i].id != undefined && prodRecList[i].id != ""){
                                        for(var j in salesforceProdList){
                                            //added by rohit
                                            listObj.Bundled = true;
                                            listObj.isBespokeQLI = false;
                                            listObj.iscollection = true;
                                            // rohit tetsing
                                            //prodRecList[i].sku ='01t9E00000E82dIQAR';
                                            console.log('(prodRecList[i].id' + (prodRecList[i].sku));
                                            console.log('salesforceProdList[j].PricebkEntProduct.Product2.id' + salesforceProdList[j].productId);
                                            //if(prodRecList[i].id == salesforceProdList[j].PricebkEntProduct.Product2.id){
                                              if(prodRecList[i].sku == salesforceProdList[j].productId){
                                                listObj.OriginalListPrice = salesforceProdList[j].OriginalListPrice1;
                                                listObj.UnitPrice = salesforceProdList[j].PricebkEntProduct.UnitPrice;
                                            }
                                        }
                                    }
                                }
                            }
                            prodWrapperList.push(listObj);
                        }
                    }
                    component.set('v.productListPCM',prodWrapperList);
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    syncToQuote : function(component,event,helper){
        debugger;
        var prodToSync = component.get('v.productListPCM');//List of already available and new line items
        var deldata = component.get("v.DeleteSyncProductDataWrapper");
        var productNotSelectedFlag = false;
        var prodNameSelectError = "";
        for(var i in prodToSync){
            if(prodToSync[i].PCMISBN != null && prodToSync[i].PCMISBN != undefined && prodToSync[i].PCMISBN != ""){
                for(var j in prodToSync[i].SFDCProdList){
                    if(prodToSync[i].PCMISBN == prodToSync[i].SFDCProdList[j].PricebkEntProduct.Product2.ISBN__c){
                        prodToSync[i].SalesforceProductId = prodToSync[i].SFDCProdList[j].PricebkEntProduct.Product2Id;
                        prodToSync[i].SalesforcePriceBookEntry = prodToSync[i].SFDCProdList[j].PricebkEntProduct.Id;
                    }
                }
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
    
    //added by shubham
    refreshComp : function(component,event,helper){
        debugger;
        $A.get('e.force:refreshView').fire();  
    },
    
    syncToQuoteAndClose : function(component,event,helper){
        debugger;
        
        var prodToSync = component.get('v.productListPCM');
        var duplicateProds = component.get('v.DuplicateProductsList');
        var deldata = component.get("v.DeleteSyncProductDataWrapper");
        var productNotSelectedFlag = false;
        var prodNameSelectError = "";
        
        for(var i in prodToSync){
            //alert(prodToSync[i].PCMISBN);
            //alert(prodToSync[i].type);
            
            if(prodToSync[i].type=='book'){
                if(prodToSync[i].PCMISBN != null && prodToSync[i].PCMISBN != undefined && prodToSync[i].PCMISBN != ""){
                    //alert('inside');
                    for(var j in prodToSync[i].SFDCProdList){
                        if(prodToSync[i].PCMISBN == prodToSync[i].SFDCProdList[j].PricebkEntProduct.Product2.ISBN__c){
                            prodToSync[i].SalesforceProductId = prodToSync[i].SFDCProdList[j].PricebkEntProduct.Product2Id;
                            prodToSync[i].SalesforcePriceBookEntry = prodToSync[i].SFDCProdList[j].PricebkEntProduct.Id;
                        }
                    }
                }
            }
           //rohit prodToSync[i].type=='collection'
            else if(prodToSync[i].type=='collection'){
                for(var j in prodToSync[i].SFDCProdList){
                    prodToSync[i].SalesforceProductId = prodToSync[i].SFDCProdList[j].PricebkEntProduct.Product2Id;
                    prodToSync[i].SalesforcePriceBookEntry = prodToSync[i].SFDCProdList[j].PricebkEntProduct.Id;
                }
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
    
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
        
    },
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.showFields", false);
    },
    
    //To read the CSV file
    handleUploadFinished : function(component, event, helper){
        debugger;
        component.set("v.mySpinner", true);
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
                        if(!$A.util.isEmpty(prodToSync[i].PCMISBN) && !$A.util.isUndefinedOrNull(prodToSync[i].PCMISBN))
                        {
                            for(var j in csvUploadedDataList){
                                if(prodToSync[i].PCMISBN === csvUploadedDataList[j].ISBN)
                                {
                                    if(!$A.util.isEmpty(csvUploadedDataList[j].Price) && !$A.util.isUndefinedOrNull(csvUploadedDataList[j].Price) && csvUploadedDataList[j].Price != 0)
                                        prodToSync[i].UnitPrice = csvUploadedDataList[j].Price;    
                                    
                                    if(!$A.util.isEmpty(csvUploadedDataList[j].LineReference) && !$A.util.isUndefinedOrNull(csvUploadedDataList[j].LineReference))
                                        prodToSync[i].PONumber = csvUploadedDataList[j].LineReference;
                                }
                            }
                        }
                    }
                    component.set('v.productListPCM', prodToSync);
                }
                
            }
            reader.onerror = function (evt) {
                console.log('Error in reading file');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: 'Something is wrong in CSV file, please check it and try again!!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
        }
        component.set("v.mySpinner", false); 
        
    },
    
    top: function(component, event, helper){
        window.scrollTo(0, 0);
    },
    
    //SFAL-20 changes added by shubham  for Entitlements starts:
    checkForEntitlements  : function(component,event,helper){
        debugger;
        var salesType = component.get("v.salesType");
        var productType = component.get('v.ProductType'); 
        var currentdate = new Date();
        
        var datetime = "CustomStatic-" + currentdate.getDate() + "/"
        + (currentdate.getMonth()+1)  + "/" 
        + currentdate.getFullYear() + " - "  
        + currentdate.getHours() + ":"  
        + currentdate.getMinutes() + ":" 
        + currentdate.getSeconds();
        console.log('v.productListPCM' +  component.get('v.productListPCM'));
        var prodToSync = component.get('v.productListPCM');
        console.log('prodToSync1'+ JSON.stringify( prodToSync));
        component.set("v.selectedProdsLength",prodToSync.length);
        var priceOfSelProds = 0;
      
        for(var i in prodToSync){
            if(prodToSync[i].OriginalListPrice != undefined && prodToSync[i].OriginalListPrice != '' && !isNaN(prodToSync[i].OriginalListPrice) && prodToSync[0].type != 'collection'){
                priceOfSelProds = priceOfSelProds + prodToSync[i].OriginalListPrice ;    
            }else if(prodToSync[0].type == 'collection'){
                productType = 'Collection';
                console.log(prodToSync[i].OriginalListPrice);
            }
        }
        if(salesType != null && salesType != undefined && salesType != ''){
            
        }else{
            salesType = productType;
        }
        component.set("v.productBundleName",datetime);
        component.set("v.productBundle.List_Price__c", Math.round(priceOfSelProds));
        component.set("v.totalsalePrice", Math.round(priceOfSelProds)); 
        component.set("v.totalListPrice", Math.round(priceOfSelProds)); 
        
        var pcmUUIDs = [];
        var thresholdValue = component.get("v.threshHoldVal");
        var numOfRecsSelected = component.get("v.selectedProdCount");
        console.log('salesTypesalesType575' + salesType);
        if ( component.get("v.isBespoke") == false &&  salesType != 'Collection' ){
            for(var i in prodToSync){
                if(prodToSync[i].PCMUUID != null && prodToSync[i].PCMUUID != undefined){
                    pcmUUIDs.push(prodToSync[i].PCMUUID);    
                }
            }
            console.log('prodToSync');
            console.log(prodToSync);
            component.set("v.mySpinner", true); 
            var action = component.get("c.getEntitlementDetails");
            action.setParams({
                "quoteId" : component.get('v.RecordId'),
                "ProductType": 'BOOK',
                "PCMUUIDS": pcmUUIDs,
            });
            action.setCallback(this, function(response) {
                component.set("v.mySpinner", false); 
                var state = response.getState();
                if (state === "SUCCESS") {
                    var duplicateMess = '';
                    if(response.getReturnValue() !== '' && response.getReturnValue() !== null && response.getReturnValue() !== undefined){
                        if(response.getReturnValue().length == 1){
                            duplicateMess = 'This customer has an existing entitlement for ' +response.getReturnValue()[0] +'. Are you sure you wish to add this item to the quote?';
                            component.set("v.DuplicateProductsList",response.getReturnValue());
                            
                            var duplicateProds = component.get('v.DuplicateProductsList');
                            for(let i = 0; i < duplicateProds.length; i++){
                                for (let j = 0; j < prodToSync.length; j++) {
                                    if(prodToSync[j].PCMISBN  == duplicateProds[i]){
                                        prodToSync[j].isDuplicate  = true;
                                    }else{
                                        //
                                    }
                                }
                            }
                            component.set("v.productListPCM",prodToSync);
                            component.set("v.duplicateProductsMessage",duplicateMess);
                            component.set("v.duplicateProductsEntitled",true);
                            
                        }else if(response.getReturnValue().length > 1){
                            duplicateMess = 'The customer has existing entitlements for some of the products you selected.  Are you sure you wish to add these products again?';
                            
                            component.set("v.DuplicateProductsList",response.getReturnValue());
                            
                            var duplicateProds = component.get('v.DuplicateProductsList');
                            for(let i = 0; i < duplicateProds.length; i++){
                                for (let j = 0; j < prodToSync.length; j++) {
                                    if(prodToSync[j].PCMISBN == duplicateProds[i]){
                                        prodToSync[j].isDuplicate  = true;
                                    }
                                }
                            }
                            component.set("v.productListPCM",prodToSync);
                            component.set("v.duplicateProductsMessage",duplicateMess);
                            component.set("v.duplicateProductsEntitled",true);
                        }else{
                            if(prodToSync.length > thresholdValue){
                                component.set("v.showFields","true");
                            }else{
                                $A.enqueueAction(component.get('c.syncToQuoteAndClose'));    
                            }
                        }
                    }else{
                        if(prodToSync.length > thresholdValue){
                            component.set("v.showFields","true");
                        }else{
                            $A.enqueueAction(component.get('c.syncToQuoteAndClose'));    
                        }
                        //$A.enqueueAction(component.get('c.syncToQuoteAndClose'));
                    }
                }
            });
            $A.enqueueAction(action);
        }else{
            $A.enqueueAction(component.get('c.syncToQuoteAndClose'));
        }
    },
    
    //Added By shubham Kumar to manipulate the fields when creating a product2 (Bespoke Collection)
    handleSubmit : function(component, event, helper) {
        debugger;
        var currentTime = new Date();
        var year = String(currentTime.getFullYear());
        
        var dateTime = new Date().toISOString();
        
        component.set("v.bundleSpinner",true);
        const fields = event.getParam('fields');
        fields.List_Price__c = component.get('v.totalListPrice');//parseInt("10.00");
        fields.Sales_Price__c = component.get('v.totalsalePrice');
        fields.businessId__c = 'BD.EBOOK';
        fields.copyrightyear__c = year;
        fields.Applicable_Channels__c = 'UBX_Delivery';
        fields.Sales_Channels__c = 'UBX';
        fields.Collection_Subject_Area__c='Mixed';
        fields.Product_Type_Author_Facing__c='Manual Curation';
        fields.version__c = '1.0.0';
        fields.Collection_Valid_From__c =dateTime;
        fields.Family  = 'Collection';
        fields.IsActive   = true;
		fields.copyrightyear__c =year;
    },
    //Added By shubham Kumar - SFAL 147
    handleError : function(component, event, helper) {
        debugger;
        component.set("v.mySpinner_2", true); 
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message: event.getParam("message"),
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
        component.set("v.mySpinner_2", false); 
    },
    //Added By shubham Kumar - SFAL 147
    createBundleMethod : function(component, event, helper) {
        debugger;
        var productId = event.getParam("response").id;
        component.set("v.mySpinner_2", true); 
        var createBundleContt = component.get("c.createBundle");
        var prodToSync = component.get('v.productListPCM');
        
        //createBundleContt.setStorable();
        createBundleContt.setParams({
            "quoteId" : component.get('v.RecordId'),
            "bundleProdId": productId,
            "lineItems" : JSON.stringify(prodToSync),
            "totalsalePrice" : component.get('v.totalsalePrice'),
            "referenceNum" : component.get('v.refValue'), 
        });
        createBundleContt.setCallback(this, function(response) {
            if (component.isValid() && response !== null && response.getState() == 'SUCCESS') {
                component.set("v.mySpinner_2", false); 
                //$A.get('e.force:refreshView').fire();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Bundle Has been Created Succesfully!!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                //this.init(component, event, helper);
                component.set("v.bundleSpinner",false);
                component.set("v.showFields", false);
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": component.get('v.RecordId'),
                    "slideDevName": "detail"
                });
                navEvt.fire();
            } else {
                component.set("v.mySpinner_2", false); 
                component.set("v.bundleSpinner",false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: 'Something is wrong Bundle is not Created Succesfully!!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                component.set("v.showFields", false); 
            }
        });
        $A.enqueueAction(createBundleContt); 
        //$A.enqueueAction(component.get('c.syncToQuoteAndClose'));
    },
    
    handleConfirmDialog : function(component, event, helper) {
        component.set('v.duplicateProductsEntitled', true);
    },
    
    handleConfirmDialogYes : function(component, event, helper) {
        debugger;
        console.log('Yes');
        var selectedPrdLength = component.get('v.selectedProdsLength');
        var thresholdValue = component.get("v.threshHoldVal"); 
        if(selectedPrdLength > thresholdValue){
            component.set('v.duplicateProductsEntitled', false);    
            component.set("v.showFields","true");
        }else{
            $A.enqueueAction(component.get('c.syncToQuoteAndClose'));
            component.set('v.duplicateProductsEntitled', false);
        }
    },
    
    handleConfirmDialogNo : function(component, event, helper) {
        console.log('No');
        component.set('v.duplicateProductsEntitled', false);
        
    },
    
    HideMe: function(component, event, helper) {
        component.set("v.showFields", false);
    },
    
    showBundleItems : function(component, event, helper){
        debugger;
        //00480875-127c-4b07-9e3d-01f85d932fb7
        //Product_Type_Author_Facing__c
        console.log('getsource' + event.getSource());
        console.log('productListPCM =====>' + JSON.stringify(component.get('v.productListPCM')));        
        var recId = event.getSource().get("v.name");
        var isBespokeQLI = event.getSource().get("v.title");
        var isCollectionType =event.getSource().get("v.type");
       
        console.log('recId =====>' + recId);
        if(isCollectionType == undefined){
            isCollectionType = false;
        }
        var inSalesforce = false;
        if(recId.length == 18){
            inSalesforce = true;
        }
        if(isCollectionType == true){
            inSalesforce = true;
            
        }
        
        var compEvent = component.getEvent("showBundleData");
        compEvent.setParams({
            "isActiveTab" : true,
            "inSalesforce" : inSalesforce,
            "pcmUUID" : recId,
            "isBespokeQLI": isBespokeQLI,
            "iscollection":isCollectionType
        });
        compEvent.fire();
    },
    //Added By shubham Kumar - SFAL 379
    updateBundleMethod : function(component, event, helper) {
        debugger;
        component.set("v.mySpinner", true); 
        var createBundleContt = component.get("c.updateExistingBundle");
        var prodToSync = component.get('v.NewBundleLineItems');
        var bundleProdId = component.get('v.BundleProductId');
        //createBundleContt.setStorable();
        createBundleContt.setParams({
            "quoteId" : component.get('v.RecordId'),
            "lineItems" : JSON.stringify(prodToSync),
            "newBundleLIPrice" : component.get('v.newBundleLIPrice'),
            "bundleProdId" : bundleProdId
        });
        createBundleContt.setCallback(this, function(response) {
            if (component.isValid() && response !== null && response.getState() == 'SUCCESS') {
                $A.enqueueAction(component.get('c.init'));
                component.set("v.activeTab", false); 
                component.set("v.mySpinner", false); 
                component.set("v.bundleSpinner",false);
                /*var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Bundle Has been Updated Succesfully!!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();*/
                
                /*var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": component.get('v.RecordId'),
                    "slideDevName": "related"
                });
                navEvt.fire();*/
            } else {
                component.set("v.mySpinner", false); 
                component.set("v.bundleSpinner",false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: 'Something is wrong Bundle is not Updated Succesfully!!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                component.set("v.showFields", false); 
            }
        });
        $A.enqueueAction(createBundleContt); 
    },
})