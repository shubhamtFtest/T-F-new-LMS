({
    init : function(component, event, helper) {
        var recordID = component.get("v.recordId"); 
        var action = component.get("c.parseRuleJson");
        var isDynamicUi = 'false';
        var noRule = 'true';
        var multiTypeRulesLst ;
        component.set('v.ruleValues',null); 
        component.set('v.filterObjectLst',null);
        component.set("v.multiTypeRulesLst",null);
        
        action.setParams({
            "bundleID":recordID,
        });
        action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS"){               
                var fullResult = response.getReturnValue(); 
                var rule={};
                var filterObjectLst={};
                
                if(fullResult!=null){
                    
                    multiTypeRulesLst = fullResult.multiTypeRulesLst;
                    isDynamicUi = fullResult.isDynamicUi;
                    component.set('v.isDynamicUi',isDynamicUi); 
                    console.log('rule display====='+JSON.stringify(multiTypeRulesLst));
                    if(multiTypeRulesLst){
                        component.set("v.multiTypeRulesLst",multiTypeRulesLst);
                    }
                    
                    var result = fullResult.filterObject ;
                    if(result){
                        rule = {
                            
                            title: result.title,             
                            ISBN: result.ISBN,
                            author:result.author,
                            doi:result.doi,
                            mediumData:result.mediumData,
                            publishData:result.publishData,
                            minPrice:result.minPrice,
                            maxPrice:result.maxPrice,
                            drmData:result.drmData,
                            currencyTypeData:result.currencyTypeData,
                            FirstPubYearDataFrom:result.firstPubYearDataFrom,
                            FirstPubYearDataTo:result.firstPubYearDataTo,
                            textType:result.textType,
                            publisherImprint:result.publisherImprint,
                            publcFromDate:result.publcFromDate,
                            publcToDate:result.publcToDate
                            
                        };
                        
                        filterObjectLst = [
                            
                            {label: 'Medium Data',value: result.mediumData},
                            {label: 'Publish Data',value: result.publishData},
                            {label: 'Drm Data',value: result.drmData},
                            {label: 'Currency',value: result.currencyTypeData},
                            {label: 'ISBN',value: result.ISBN},
                            {label: 'Title',value: result.title},
                            {label: 'DOI',value: result.doi},
                            {label: 'Text Type',value: result.textType},
                            {label: 'Publisher Imprint',value: result.publisherImprint},
                            {label: 'Author',value: result.author},
                            {label: 'First Published Year From',value: result.firstPubYearDataFrom},
                            {label: 'First Published Year To',value: result.firstPubYearDataTo},
                            {label: 'Pub From Date',value: result.publcFromDate},
                            {label: 'Pub To Date',value: result.publcToDate},
                            {label: 'Min Price',value: result.minPrice},
                            {label: 'Max Price',value: result.maxPrice}, 
                            {label: 'Netbase',value: JSON.stringify(result.netbase)},
                            {label: 'Subject List',value:  JSON.stringify(result.subjectList)}
                            
                        ];
                        
                        component.set('v.netBaseValues',result.netbase);
                        component.set('v.subjectValues',result.subjectList); 
                    }
                    
                }
                
                if(!isDynamicUi || (isDynamicUi && isDynamicUi == 'false')){
                    if(Object.keys(rule).length === 0 && rule.constructor === Object ){
                        component.set('v.ruleValues',null);  
                        noRule ='true'
                    }else{
                        noRule = 'false';
                        component.set('v.ruleValues',rule); 
                        component.set('v.filterObjectLst',filterObjectLst);
                    }
                }
                
                if(isDynamicUi && isDynamicUi == 'true' && multiTypeRulesLst){
                    noRule = 'false';
                }
                
                if(noRule == 'true'){
                    var msgForBlankRule = component.find("msgForBlankRule");
                    msgForBlankRule.set("v.value", '<span style="color: #bf4040;"><b>Rule does not exist for this collection!</b></span>');
                }
                component.set('v.noRule',noRule); 
            }
        });
        $A.enqueueAction(action); 
    }
    
    
})