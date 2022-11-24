({  
    init:function(component, event, helper){
        var today = new Date();
        var monthDigit = today.getMonth() + 1;
        //var minDate=today.getMonth()
        if (monthDigit <= 9) {
            monthDigit = '0' + monthDigit;
        }
        component.set('v.todayDate', today.getFullYear() + "-" + monthDigit + "-" + today.getDate());
        component.set('v.maxDate', today.getFullYear() + "-" + monthDigit + "-" + today.getDate());
        var minDate=new Date();
        minDate.setDate(minDate.getDate()-90);
        var minMonthDigit = minDate.getMonth() + 1;
        //var minDate=today.getMonth()
        if (minMonthDigit <= 9) {
            minMonthDigit = '0' + minMonthDigit;
        }
        component.set('v.minDate', minDate.getFullYear() + "-" + minMonthDigit + "-" + minDate.getDate());
        /*var fromDate= new Date();
        fromDate.setDate(fromDate.getDate()-7);
        var fromDateMonthDigit = fromDate.getMonth() + 1;
        var minDate=today.getMonth()
        if (fromDateMonthDigit <= 9) {
            fromDateMonthDigit = '0' + fromDateMonthDigit;
        } */
        //component.set('v.fromdate', fromDate.getFullYear() + "-" + fromDateMonthDigit + "-" + fromDate.getDate());
       // component.set('v.showOrderSearch',true);
         helper.showSpinner(component, event);
        //component.set("v.disableSearch",true);
        component.set("v.offsetValue",0);
        component.set("v.lstDisplayPages",[]);
        component.set("v.secondShowRangeIndex",1);
        component.set("v.firstShowRangeIndex",1);
        component.set("v.selectedValue",1);
        //component.set("v.searchProductTitle","Searching......");
        helper.getSearchOrderDataHelper(component,event);
       
    },
    searchOrder:function(component,event,helper){
       // helper.showSpinner(component, event);
        //component.set("v.disableSearch",true);
        component.set("v.offsetValue",0);
        component.set("v.lstDisplayPages",[]);
        component.set("v.secondShowRangeIndex",1);
        component.set("v.firstShowRangeIndex",1);
        component.set("v.selectedValue",1);
        //component.set("v.searchOrderTitle","Searching......");
        helper.checkFilterDataValidations(component,event);  
    },
    handleActive:function(component,event,helper){
        var value=event.getSource().get("v.id");
        var storeSelectedValue=component.get("v.storeSelectedTabValue");
        component.set("v.offsetValue",0);
        var lstOrderTableData=component.get("v.lstOrderTableData");  
        if(value !== storeSelectedValue){
            if(value === 'OrderTab' && lstproductTableData.length !==0){
                component.set("v.lstOrderDataWrapper",lstproductTableData)
                component.set("v.showSearchData",true);
                // Enable attribute of oOrder search pagination
                component.set("v.showOrderSearchPages",true);
                component.set("v.showResultCount",true);
            }
            
            if(value === 'OrderTab' && lstproductTableData.length === 0 ){
                component.set("v.showSearchData",false);
            } 
        }
        component.set("v.storeSelectedTabValue",value);
    },
    showNextPage:function(component, event,helper){
        var getSelectedTabValue=component.get("v.setSelectedTab");
        if(getSelectedTabValue ==='OrderTab'){
            var value=component.get("v.selectedValue");
            var nextPage=parseInt(value)+1;
            component.set("v.selectedValue",nextPage)
            helper.handlePageDisplayHelper(component, event,nextPage);
        }
    },
    showPrevPage:function(component, event,helper){
        var getSelectedTabValue=component.get("v.setSelectedTab");
        if(getSelectedTabValue ==='OrderTab'){
            var value=component.get("v.selectedValue");
            var prevPage=parseInt(value)-1;
            component.set("v.selectedValue",prevPage)
            helper.handlePageDisplayHelper(component, event,prevPage);
        }
        
    },
    downloadExcel : function (component, event,helper) {
        //helper.csvHelper(component, event);
        
    },
    sorting : function(component, event, helper) {
        debugger;
        var getTabSelectedValue=component.get("v.storeSelectedTabValue");
        var data=event.currentTarget.getAttribute("data-id");
        if(data==='orderId'){
            if(getTabSelectedValue === 'OrderTab'){
               if(component.get("v.showOrderIDArrownUp") === false){
                    component.set("v.showOrderIDArrownUp",true);
                    component.set("v.sortOrder",'asc');
                }
                else{
                    component.set("v.showOrderIDArrownUp",false);
                    component.set("v.sortOrder",'desc');
                }  
                component.set("v.sortOrderByField",'orderId');
                component.set("v.showOrderDateArrownUp",false);
                component.set("v.showPONumberArrownUp",false);
                component.set("v.showOrderValueArrownUp",false);
                component.set("v.showTrackingNoArrownUp",false);
            }
        }
        if(data==='poNumber'){
            if(getTabSelectedValue === 'OrderTab'){
                if(component.get("v.showPONumberArrownUp") === false){
                    component.set("v.showPONumberArrownUp",true);
                    component.set("v.sortOrder",'asc');
                }
                else{
                    component.set("v.showPONumberArrownUp",false);
                    component.set("v.sortOrder",'desc');
                }
                component.set("v.sortOrderByField",'poNumber');
                 component.set("v.showOrderDateArrownUp",false);
                component.set("v.showOrderIDArrownUp",false);
                component.set("v.showOrderValueArrownUp",false);
                component.set("v.showTrackingNoArrownUp",false);
                component.set("v.showOrderStatusArrownUp",false);
            }
        }
        if(data==='orderDate'){
            if(getTabSelectedValue === 'OrderTab'){
             if(component.get("v.showOrderDateArrownUp") === false){
                    component.set("v.showOrderDateArrownUp",true);
                    component.set("v.sortOrder",'asc');
                }
                else{
                    component.set("v.showOrderDateArrownUp",false);
                    component.set("v.sortOrder",'desc');
                } 
                component.set("v.sortOrderByField",'orderDate');
                component.set("v.showPONumberArrownUp",false);
                component.set("v.showOrderIDArrownUp",false);
                component.set("v.showOrderValueArrownUp",false);
                component.set("v.showTrackingNoArrownUp",false);
                component.set("v.showOrderStatusArrownUp",false);
            }
        }
        if(data==='orderValue'){
            if(getTabSelectedValue === 'OrderTab'){
               if(component.get("v.showOrderValueArrownUp") === false){
                    component.set("v.showOrderValueArrownUp",true);
                    component.set("v.sortOrder",'asc');
                }
                else{
                    component.set("v.showOrderValueArrownUp",false);
                    component.set("v.sortOrder",'desc');
                }
                component.set("v.sortOrderByField",'orderValue');
                component.set("v.showPONumberArrownUp",false);
                component.set("v.showOrderIDArrownUp",false);
                component.set("v.showOrderDateArrownUp",false);
                component.set("v.showTrackingNoArrownUp",false);
                component.set("v.showOrderStatusArrownUp",false);
            }
        }
         if(data==='trackingNumbers'){
            if(getTabSelectedValue === 'OrderTab'){
               if(component.get("v.showTrackingNoArrownUp") === false){
                    component.set("v.showTrackingNoArrownUp",true);
                    component.set("v.sortOrder",'asc');
                }
                else{
                    component.set("v.showTrackingNoArrownUp",false);
                    component.set("v.sortOrder",'desc');
                }
                component.set("v.sortOrderByField",'trackingNumbers');
                component.set("v.showPONumberArrownUp",false);
                component.set("v.showOrderIDArrownUp",false);
                component.set("v.showOrderDateArrownUp",false);
                component.set("v.showOrderStatusArrownUp",false);
            }
        }
        if(data==='OrderStatus'){
            if(getTabSelectedValue === 'OrderTab'){
               if(component.get("v.showOrderStatusArrownUp") === false){
                    component.set("v.showOrderStatusArrownUp",true);
                    component.set("v.sortOrder",'asc');
                }
                else{
                    component.set("v.showOrderStatusArrownUp",false);
                    component.set("v.sortOrder",'desc');
                }
                component.set("v.sortOrderByField",'OrderStatus');
                component.set("v.showPONumberArrownUp",false);
                component.set("v.showOrderIDArrownUp",false);
                component.set("v.showOrderDateArrownUp",false);
                component.set("v.showTrackingNoArrownUp",false);
            }
        }

        if(getTabSelectedValue === 'OrderTab'){
            
            	helper.sortingData(component,event,component.get("v.lstOrderDataWrapper"));
        }
                    
    },
    refreshPage :function(){
        location.reload();
    }  
});