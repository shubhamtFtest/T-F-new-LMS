({
    init: function (cmp, event, helper) {
        
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
        //helper.fetchTitles(cmp, resetPageIndex);
        helper.fetchProductFromPCM(cmp, resetPageIndex);        
    },
    
    renderPage:function(cmp, event, helper)
    {        
        var pgsPerQry = cmp.get("v.pagesPerQuery");
        var qryLimit = cmp.get("v.queryLimit");
        console.log('pageNumber=== pgsPerQry= )' + cmp.get("v.searchQueryText"));
        
        if(cmp.get("v.pageNumber") == 1 && cmp.get("v.firstClicked") == 'true') {
            cmp.set("v.pstn","0");
            if(cmp.get("v.searchQueryText")){
                helper.fetchSearchResult(cmp);
            }else {
                helper.fetchPartsFromPCM(cmp, resetPageIndex);
            }
            //helper.fetchTitles(cmp, resetPageIndex);
             
            
        }else if(cmp.get("v.pageNumber") % pgsPerQry == 1 && cmp.get("v.nxtClked") == 'true') {
            var pos = Number(cmp.get("v.pstn")) + Number(qryLimit);
            cmp.set("v.pstn",pos);
            if(cmp.get("v.searchQueryText")){
                //('query search');
                helper.fetchSearchResult(cmp);
            }else {
                //alert('normal search');
                var resetPageIndex = true;
            	helper.fetchPartsFromPCM(cmp, resetPageIndex);
            }
            
        }else if(cmp.get("v.pageNumber") % pgsPerQry == 0 && cmp.get("v.prevClked") == 'true') {
            var pos = cmp.get("v.pstn");
            if(pos > 0){
                pos = pos - qryLimit;
            }
            cmp.set("v.pstn",pos);  
            if(cmp.get("v.searchQueryText")){
                helper.fetchSearchResult(cmp);
            }else {
                var resetPageIndex = true;
            	helper.fetchPartsFromPCM(cmp, resetPageIndex);
            }
            
        }else if(cmp.get("v.pageNumber") == cmp.get("v.maxPage") && cmp.get("v.nxtClked") == 'false'){
            
            if(cmp.get("v.recordCount") % cmp.get("v.queryLimit") == 0){
                cmp.set("v.pstn", cmp.get("v.recordCount") - qryLimit);
                
            }else{
                cmp.set("v.pstn", cmp.get("v.recordCount") - (cmp.get("v.recordCount") % cmp.get("v.queryLimit")));                
            }
            
            if(cmp.get("v.searchQueryText")){
                helper.fetchSearchResult(cmp);
            }else {
                helper.fetchPartsFromPCM(cmp, resetPageIndex);
            }
             
        }else{
            helper.renderPage(cmp);
            
        }
        
    },
    
    
    handleProductTypeClick : function(cmp, event, helper) {        
        var productTypVal = event.getSource().get("v.value");
        var resetPageIndex = true;               
        cmp.set("v.pageNumber",1);
        cmp.set("v.pstn",0);
        cmp.set("v.productType",productTypVal);
        //cmp.set("v.returnProductType",productTypVal);
        //helper.fetchPartsFromPCM(cmp,resetPageIndex); 
        helper.fetchProductFromPCM(cmp,resetPageIndex); 
    },
    
    // added by Geetika for PCH- 3712
    searchContentHandler: function(cmp, event, helper) {
        console.log('searchText: ' + event.getParam("searchText"));
        if (event.getParam("searchText") !== undefined ) {
            var searchText=event.getParam("searchText");
            cmp.set("v.searchQueryText", searchText);
            
            if(searchText){
                //alert('query');
                cmp.set("v.pageNumber",1);
                helper.fetchSearchResult(cmp);
            }else{
                //alert('noquery');
                cmp.set("v.pageNumber",1);
                cmp.set("v.pstn","0");
                var resetPageIndex = true;
                helper.fetchProductFromPCM(cmp, resetPageIndex);
            }
        }
    }, //end for PCH-3712
    
})