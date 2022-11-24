({    
    init : function(component, event, helper) {
        var action = component.get("c.getPickListValues"); 
        action.setParams({
            "ObjectApiName": 'product2',
            "fieldApiName": 'family'
        });
        
        action.setCallback(this, function(response) {        
            var result = response.getReturnValue();
            result.sort();
            result.unshift('choose one...');
            component.set('v.productFamilyLst', result);
            component.set("v.IsSpinner",false);
        });
        $A.enqueueAction(action);
        component.set("v.IsSpinner",true);
        
        helper.loadPicklistValues(component, event,'TextTypeValues'); 
        helper.loadPicklistValues(component, event,'PublisherImprint');   
        
        
    },
    
    searchProduct : function(component, event, helper) {
        
        var allValid = component.find('field').reduce(function (validSoFar, inputCmp) {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        if (allValid) {
            var productSearchEvent = $A.get("e.c:PPDProductSearchEvent");
            component.set("v.activeAccordion",'result');
            //                'publishData': component.get("v.selectPublishedRadio"),
            
            productSearchEvent.setParams({
                'ISBN': component.get("v.ISBNValue"),
                'title': component.get("v.productTitle"),
                'author': component.get("v.productAuthor"),
                'doi': component.get("v.productDOI"),
                'netbase':component.get("v.multiResultCodes"),
                'subjectList': component.get("v.multiResultList"),
                'mediumData': component.get("v.SelectedMedium"),
                'minPrice': component.get("v.minPrice"),
                'maxPrice': component.get("v.maxPrice"),
                'sortBy': component.get("v.sortOrder"),
                'sortOrderFieldName': 'UnitPrice',
                'drmData': component.get("v.SelectedDRM"),
                'currencyTypeData': component.get("v.SelPubCurrency"),
                'firstPubYearDataFrom': component.get("v.FirstPubYearValueFrom"),
                'firstPubYearDataTo': component.get("v.FirstPubYearValueTo"),
                'textType': component.get("v.textType"),
                'publisherImprint': component.get("v.publisherImprint"),
                'publcFromDate': component.get("v.pubFromDate"),
                'publcToDate': component.get("v.pubToDate")
            });
            productSearchEvent.fire();
            component.set("v.activeAccordion",'');
        } else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "warning",
                "message": "Please update the invalid form entries and try again."
            });
            toastEvent.fire();            
        } 
    },
    
    handleChange : function (component, event) {
        var selectedOptionsList = event.getParam("value");
        component.set("v.selectedVersionTypes" , selectedOptionsList);
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
        var value = event.getParam("selectedNetbases");
        for(var j in value){
            value[j]=value[j].value;
        }
        component.set("v.multiResultCodes",value);
        console.log('event Codevalue='+JSON.stringify(value));
        console.log('event Codevalue get='+JSON.stringify(component.get("v.multiResultCodes")));
        
    },
    
    getResetState : function(component, event, helper) {
        //location.reload();
        component.set("v.ISBNValue",'');
        component.set("v.productTitle",'');
        component.set("v.productAuthor",'');
        component.set("v.productDOI",''); 
        component.set("v.SelectedDRM",'Both');
        component.set("v.SelectedMedium",'e-Book');
        component.set("v.minPrice",'');
        component.set("v.maxPrice",'');
        component.set("v.pubFromDate",null);
        component.set("v.pubToDate",null);        
        component.set("v.SelPubCurrency",'USD');
        component.set("v.FirstPubYearValueFrom",''),
        component.set("v.FirstPubYearValueTo",''),
        component.set("v.textType",'choose one...'),
        component.set("v.publisherImprint",'choose one...'),
        component.set("v.multiResultCodes",[] );
        component.set("v.multiResultList",[]); 
        
        
        var evt = $A.get("e.c:PPDSearchProductResetComp");
        evt.fire();
        var event = $A.get("e.c:productSearchResetEvent");
        event.fire();
        
        
    }
    
})