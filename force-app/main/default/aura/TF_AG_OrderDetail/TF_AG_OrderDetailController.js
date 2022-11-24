({
    doInit:function(component,event,helper){
      /*  component.set('v.mycolumns', [
            {label: 'Order Id', fieldName: 'orderId', type: 'text'},
                {label: 'ISBN', fieldName: 'isbn', type: 'text'},
                {label: 'Title', fieldName: 'titleFull', type: 'text'},
                {label: 'Quantity', fieldName: 'quantity', type: 'text '},
                {label: 'Title Status', fieldName: 'isbn', type: 'text'},
                {label: 'Tracking Numbers', fieldName: 'titleStatus', type: 'text'},
                {label: 'Quantity', fieldName: 'trackingNumbers', type: 'text '},
                {label: 'Order Status', fieldName: 'orderStatus', type: 'text'},
                {label: 'Order Value',fieldName: 'orderValue', type: 'text '}
            ]); */
        helper.showSpinner(component,event,helper);    
        var url = window.location.href;
        var locationSplit=url.split("=");
        var orderid=locationSplit[1];
        helper.getOrderDetailsHelper(component,event,orderid);
    },
    refreshPage:function(component,event,helper){
    location.reload();
    } 
})