({
    doInit:function(component,event,helper){
        var prodData=component.get("v.priceBookData");
        console.log('prodData:='+JSON.stringify(prodData));
        //console.log('prodData:='+prodData.pricebook.Product2.ISBN__c);
        var isbn=prodData.pricebook.Product2.ISBN__c;
        var splitIsbn=isbn.split('-');
        var newIsbn='';
        var newSubIsbn='';
        var imageUrl=''; 
        if(splitIsbn.length>0){
            for(var i=0;i<splitIsbn.length;i++){
                newIsbn+=splitIsbn[i];
            }
        }
        newSubIsbn=newIsbn.slice(0,-4);
        imageUrl='http://images.tandf.co.uk/common/jackets/weblarge/'+newSubIsbn+'/'+newIsbn+'.jpg';
        imageChecker(imageUrl);
        
        function imageChecker(URL) {
            var tester=new Image();
            tester.onload=imageFound;
            tester.onerror=imageNotFound;
            tester.src=URL;
        }
        function imageFound() {
            //alert('That image is found and loaded');
            component.set('v.coverImageUrl',imageUrl);
        }
        
        function imageNotFound() {
            //alert('That image was not found.');
            
            //component.set('v.imageNotFound',true);
        }
        
        document.body.scrollTop = 0;
        document.documentElement.scrollTop = 0;
        
    },
    backToSearchProduct : function(component, event, helper) {
        var appEvent = $A.get("e.c:TF_AG_BackToResultEvt");
        appEvent.setParams({
            "backPageName" : "productSearch"});
        appEvent.fire();
    },
    IsbnRedirectLink : function(component, event, helper) {
        debugger;
        var prodData=component.get("v.priceBookData");
        var ISBNDtail = prodData.pricebook.Product2.ISBN__c.replace(new RegExp('-','g'),'');
        var poup = window.open('https://www.taylorfrancis.com/books/'+ISBNDtail);
    }
})