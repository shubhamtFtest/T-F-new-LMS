({
helperMethod : function() {
    
},
getSearchOrderDataHelper:function(component,event){
    debugger;
    var FromDate=component.get("v.minDate");
    var ToDate=component.get("v.todayDate");
    var direction=component.get("v.sortOrder");
    var orderBy=component.get("v.sortOrderByField");
        var action = component.get("c.getOrderDetails");
    action.setParams({
        FromDate:FromDate,
        ToDate:ToDate,
        orderBy:orderBy,
        orderDirection:direction
        });
    action.setCallback(this, function(response){
        this.hideSpinner(component, event);
        var state = response.getState();
        if (state === 'SUCCESS') {
            var datawithcount = response.getReturnValue();   
            if(datawithcount===null||datawithcount.data.length===0){
                this.showModal(component,event);
            }
            component.set("v.lstOrderDataWrapper",datawithcount.data);
            var datacount= datawithcount.pageSize;
            if(datacount !== undefined && datacount>0){
                if(datacount>2000){
                    this.showToastMessage(component,event,'Return datacount is too large,Please refine your search.','Alert','error');
                    component.set("v.lstOrderDataWrapper",[]);
                    component.set("v.showSearchData",true);
                    
                    component.set("v.showResultCount",false);
                }
                 if(datacount<2000){
                        
                    this.displayPages(component,event,datacount);
                    var actualDataFromBackend= datawithcount.data;          
                    component.set("v.lstOrderTableData",actualDataFromBackend);
                        component.set("v.allOrderDataWrapper",actualDataFromBackend);
                    var data =[];
                    for(var i in actualDataFromBackend){
                        if(i<component.get("v.displayOnePageData")){
                            data.push(actualDataFromBackend[i]);
                        }
                    }
                    //this.dataFromController(component,event,data);
                    this.filterData(component,event);                    
                }
                
                
            }
            
            
        }
        else{
            console.log('State Not Success');
        }
        
    });
    $A.enqueueAction(action);
},
checkFilterDataValidations:function(component,event){
    var OrderId =component.get('v.OrderId');
    var PoNumber=component.get("v.PoNumber");
    var val = component.get("v.val");
    var FromDate=component.get("v.minDate");
    var ToDate=component.get("v.todayDate");
    
    if((OrderId === '' || OrderId === undefined) && (PoNumber === '' || PoNumber === undefined)&&((ToDate == null || ToDate === undefined) || (FromDate == null || FromDate === undefined))&&(val == null || val === undefined))
    {      
        component.set("v.showSearchData",false);
        component.set("v.lstOrderTableData",null);
            if((ToDate == null || ToDate === undefined) ^ (FromDate == null || FromDate === undefined)){
            this.showToastMessage(component,event,'if you are providing dates Please provide Both','Alert','error');   
        }
        else
        this.showToastMessage(component,event,'Please provide filter informations','Alert','error');
        
        }
    else{
            /* Console.log('getSearchOrderDataHelper with given order id'+OrderId);
            component.set("v.searchOrderTitle",'Searching......');
            
            component.set("v.noOfRecordValidationCheck",true); */
            component.set("v.searchOrderTitle",'Searching......');
            this.filterData(component,event);
        }
    
},
    showSpinner: function(component, event) {
    // make Spinner attribute true for display loading spinner 
    component.set("v.mySpinner", true); 
},
    hideSpinner : function(component,event,helper){
    component.set("v.mySpinner", false);
},
showToastMessage:function(component,event,message,title,type){
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        title : title,
        message:message,
        messageTemplate: 'Mode is pester ,duration is 2sec and Message is overrriden',
        duration:'50',
        key: 'info_alt',
        type: type,
        mode: 'Timed'
    });
    toastEvent.fire();
},
    displayPages:function(component,event,rtnValue){
    var getSelectedTabValue=component.get("v.setSelectedTab");
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
    if(getSelectedTabValue === 'OrderTab'){
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
        component.set("v.showOrderSearchPages",true);
        component.set("v.lstDisplayPages",lstDisplayPages);
        if(rtnValue>component.get("v.displayOnePageData")){
            // It set second page index when page loads first time or page value=1
            if(component.get("v.selectedValue") === 1){
                component.set("v.secondShowRangeIndex",component.get("v.displayOnePageData"));
            }
            }
        else{
            
            component.set("v.secondShowRangeIndex",rtnValue);
        }
        component.set("v.showResultCount",true);
    }
    },
dataFromController : function(component,event,data){
    var arr=[];
    var isSortingASC=component.get("v.isSortingAscOrderValue");
    if(data !== undefined && data.length>0){
            /*ASC sort data creation in discount price*/
                if(isSortingASC){
                    data.sort(function (a, b) {
                        return a.orderId - b.orderId;
                    });
                    component.set("v.lstOrderDataWrapper",data);
                    return false;
                }
                else{
                 arr= data.sort(function (a, b) {
                     
                     console.log('AAAAAAAAAA'+JSON.stringify(a));
                     console.log('BBBBBBBBBB'+b.orderId);
                        return a.orderValue - b.orderValue;
                    });
                    
                }
        
                component.set("v.lstOrderDataWrapper",data);
                //component.set("v.lstOrderTableData",data);
                component.set("v.showSearchData",true);
                    
                component.set("v.searchOrderTitle",'Search Order');
               // this.showToastMessage(component,event,'Data  Found and Displayed','Success','Success');
            }
            else{
                component.set("v.searchOrderTitle",'Search Order');
                //this.showToastMessage(component,event,'sorry No Match found please check all details .','Alert','error');
                component.set("v.lstOrderDataWrapper",[]);
                component.set("v.showSearchData",true);
                
                component.set("v.lstOrderTableData",[]);
            }
},
    handlePageDisplayHelper:function(component,event,value){
    var totalSearchResultCount=component.get("v.totalSearchResultCount");
    var fixShowPageValues=component.get("v.fixShowPageValues");
    var lstPageIterationCount=component.get("v.lstPageIterationCount");
    var showNextPageValues = Math.floor(fixShowPageValues/2);
    var newPagePopulateValues=[];
    var nextPages=value+showNextPageValues;
    var getSelectedTab=component.get("v.storeSelectedTabValue");
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
        //var actlordr=component.get("v.lstOrderTableData");
        var actualBankendWrapperData = component.get("v.lstOrderTableData");
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
    var actlordr=component.get("v.lstOrderTableData");
    var firstIndex=component.get("v.firstShowRangeIndex");
    var secondIndex=component.get("v.secondShowRangeIndex");
    secondIndex=value*component.get("v.displayOnePageData");
    firstIndex=(secondIndex-component.get("v.displayOnePageData"))+1;
    if(secondIndex>totalSearchResultCount){
        secondIndex=totalSearchResultCount;
    }
    /* var i=0;
        var data = [];
        for( i=firstIndex;i<=secondIndex;i++){
            data.push(actlordr[i]);
        }
        this.dataFromController(component,event,data); */
        component.set("v.firstShowRangeIndex",firstIndex);
        component.set("v.secondShowRangeIndex",secondIndex);
        
},
csvHelper:function(component,event,helper){

},
filterData : function(component,event){
    var vdo = component.get('v.searchOrderTitle');
    var Orde =component.get('v.OrderId');
    var PoNum=component.get("v.PoNumber");
    var  orderValue;
    //var vl = component.get("v.val");
    var orderValue1=component.get("v.orderValueFrom");
    var orderValue2=component.get("v.orderValueTo");
    if(orderValue1===''||orderValue1=== undefined){
        orderValue=0;
        orderValue=-100000;
    }
    if(orderValue2===''||orderValue2=== undefined){
        orderValue=0;
        orderValue=100000;
    }
    var FrmDate=component.get("v.minDate");
    var TDate=component.get("v.todayDate");
    var dataPresent =component.get("v.allOrderDataWrapper");
    
    var data =[];
    var newdata=[];
    let s = new Set();
    for(var i in dataPresent){
        if(i<component.get("v.allOrderDataWrapper")){
            data.push(dataPresent[i]);
        }
    }
    for(i in data){
        var add = false;
    /*    var obj = new Object();
            obj.orderId=data[i].orderId;
            obj.poNumber=data[i].poNumber;
            obj.orderValue=Math.abs(data[i].orderValue);
            obj.orderDate=data[i].orderDate;
            obj.flag="";  */

        if(!(Orde === '' || Orde === undefined)){
            if(data[i].orderId===(Orde.trim())){add=true;}
            else{add=false;continue;} 
        }
        if(!(PoNum === '' || PoNum === undefined)){
            if(data[i].poNumber===(PoNum.trim())){add=true;}
            else{add=false;continue;} 
        }
        if(orderValue1||orderValue2){
            var ordrVal = parseInt(data[i].orderValue,10);
            if(orderValue1<ordrVal&&orderValue2>ordrVal){
                add=true;
               /* if(parseInt(data[i].orderValue,0)<=0){
                    obj.flag='Credit';
                }
                else{
                    obj.flag='Invoice';
                } */
            }
            else{add=false;continue;} 
        }
        if(!((FrmDate === '' || FrmDate === undefined || FrmDate === null)||(TDate === ''|| TDate === undefined|| TDate === null))){
                var dte  = new Date(data[i].orderDate);
            var dte1  = new Date(FrmDate);
            var dte2  = new Date(TDate);
            if((dte>=dte1)&&(dte<=dte2)){add=true;}
            else{add=false;continue;} 
        }
        if(add===true){
            s.add(data[i]);
        }
    }
        var newData = []; 
        var lstOrderdata=[];
        var setIter = s.values();

        for(i=0;i<s.size;i++){
            lstOrderdata.push(setIter.next().value);
            if(i<50)
            newData.push(lstOrderdata[i]) ;
        }
    component.set("v.lstOrderTableData",lstOrderdata);
    var datacount=s.size;
    this.displayPages(component,event,datacount);
    this.dataFromController(component,event,newData);
    
},
sortingData:function(component,event,data){
    debugger;
    var sortByField=component.get("v.sortOrderByField");
    var sortOrder = component.get("v.sortOrder");
    var isSortingASC=component.get("v.isSortingAscOrderValue");
    if(data !== undefined && data.length>0){
        
        if(sortByField==='orderDate'){
            if(sortOrder==='asc'){
                data.sort(function (a, b) {
                    return new Date(a.orderDate) - new Date(b.orderDate); 
                });
                
                
            }
            if(sortOrder==='desc'){
                data.sort(function (a, b) {
                    return new Date(b.orderDate) - new Date(a.orderDate); 
                });
                
            }
        }
        else if(sortByField==='orderValue') { 
             if(sortOrder==='asc'){
                data.sort(function (a, b) {
                    return a.orderValue - b.orderValue; 
                });
                
                
            }
            if(sortOrder==='desc'){
                data.sort(function (a, b) {
                    return b.orderValue - a.orderValue; 
                });
                
            }
        }
            else {
                if(sortOrder==='asc'){
                    data.sort(function (a, b) {
                        var str1 = a[sortByField];
                        var str2 = b[sortByField];
                        return str1.localeCompare(str2);
                    });
                    
                    
                }
                if(sortOrder==='desc'){
                    data.sort(function (a, b) {
                        var str1 = a[sortByField];
                        var str2 = b[sortByField];
                        return str2.localeCompare(str1);
                    });
                    
                }
            }
           
     
     
     
                component.set("v.lstOrderDataWrapper",data);
               // component.set("v.lstOrderDataWrapper",data);
                //component.set("v.lstOrderTableData",data);
                component.set("v.showSearchData",true);
                    
                component.set("v.searchOrderTitle",'Search Order');
               // this.showToastMessage(component,event,'Data  Found and Displayed','Success','Success');
            }
            else{
                component.set("v.searchOrderTitle",'Search Order');
                //this.showToastMessage(component,event,'sorry No Match found please check all details .','Alert','error');
                component.set("v.lstOrderDataWrapper",[]);
                component.set("v.showSearchData",true);
                
                component.set("v.lstOrderTableData",[]);
            }
},    
errorMsg:function(component,event,msg){
    this.showToastMessage(component,event,msg,'Alert','error');
    component.set("v.lstOrderDataWrapper",[]);
    component.set("v.showSearchData",false);
    component.set("v.searchOrderTitle",'Search Order');
    
    },
    showModal :function(component,event){
        component.set("v.modalPopup",true);
    },
    hideModal:function(component,event){
        component.set("v.modalPopup",false);
    }
})