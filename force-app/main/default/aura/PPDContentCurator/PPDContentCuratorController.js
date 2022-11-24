({
    init: function (cmp, event, helper) {
        cmp.set('v.columns', [
            
            { label: 'DOI/UUID', fieldName: 'doi', type: 'text', sortable: true },
            { label: 'Goals', fieldName: 'keywords', type: 'text', sortable: true },
            { label: 'Publication Date', fieldName: 'publication_date', type: 'text', sortable: true },       
            { label: 'Title', fieldName: 'title', type: 'text', sortable: true },
            { label: 'Publisher', fieldName: 'publisher', type: 'text', sortable: true },
            { label: 'Author', fieldName: 'authors', type: 'text', sortable: true },
            { label: 'Type', fieldName: 'type', type: 'text', sortable: true },

        ]); 
    }, 
    
    getContentCurator : function(component, event, helper) {
        helper.getContentCurator(component, event, helper);
    },
    
    //Pagination and Sorting
    sortColumn: function(component, event, helper) {       
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    },
    
    //Render Page
    renderPage:function(component, event, helper)
    {
        helper.renderPage(component);
    },
    
    //Add Selected Curated Content
    addSelectedContent : function(component, event, helper) { 
        
        var selectedContentIdList =  component.get("v.selectedCuratedContentDetails");        
        if (selectedContentIdList== null || selectedContentIdList=='[]') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "",
                "message": "Please add atleast one item from the list!"
            });
            toastEvent.fire();
            return;
        }
        helper.addSelectedCuratedContent(component, event);             
                 
    },
    
    handleSelectedRow: function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        var arrSelectedContentIds = [];
       // for (var i = 0; i < selectedRows.length; i++) {
           // arrSelectedContentIds.push(selectedRows);         
        //}
        arrSelectedContentIds.push(selectedRows); 
       
        component.set("v.selectedCuratedContentDetails" ,arrSelectedContentIds );
        component.set("v.selectedRowsCount", selectedRows.length);      
        component.set("v.selectedRowsList", selectedRows);
    },
    
    filter: function(component, event, helper) {
        var data = component.get("v.fullData"),
            term = component.get("v.filter"),
            results = data, regex;
        try {
            if (term!='' || term !=null)
            {
            regex = new RegExp(term, "i");
            // filter checks each row, constructs new array where function returns true
            
                results = data.filter(row=>regex.test(row.title) || regex.test(row.publisher)|| regex.test(row.authors)|| regex.test(row.doi)|| regex.test(row.datePublished)|| regex.test(row.keywords) || regex.test(row.type));
                    }

        } catch(e) {
            // invalid regex, use full list
            results=data;
        }
        component.set("v.data", results);
        component.set("v.recordCount",results.length);
    }
})