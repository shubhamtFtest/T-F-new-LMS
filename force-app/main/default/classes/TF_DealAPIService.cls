/*
Description		   : For accessing Deal records from Mulesoft Integration for Deal API. 
Created By		   : Syam N
Test Class		   : zTEST_DealAPIService
Methods			   : 
  Get Method	   
		Scenario 1 : From the input ringgoldId 
                        1. if we get salesdeal on the dealmember then send response salesdeal+ current dealmem+ child dealmem.
                        2. if we don't get salesdeal then we have to look for child dealmem with a salesdeal + current dealmem+ child dealmem. 
                        Response : Current Deal member+Salesdeal list +3 level deal members(current dm+firstchild dm+second child dm). 
                        Deal Member hierarchy could be Consortium->Institution->Department(3 levels).Here we have to fetch 3 level deal members in the response.
  		Scenario 2 : From the input ringgoldId and includeParentDeal is false, if this includeParentDeal is available then we need to check for 
				          the dealmember which is directly having salesdeal.
		Scenario 3 : From the input ringgoldId and inactive=true,if this queryparam exists then we need to retrieve 
						  both active & inactive deals and Current date > End date(all future salesdeals) should be sent as response.
		Scenario 4 : From the input ringgoldId,includeParentDeal = false and inactive=true, All three query params is available
						  return all data without children and also dealmember with direct salesdeal on it(Scenario 2)
  POST Method	   : Receiving the request body from Mulesoft, Insert first Salesdeal record. Next inserting all levels of deal members and deal discount record. 
  DELETE Method	   : From the input we will get dealmemberId by using this we can delete records. 
						1. If we get Consortium delamemberId, we have to delete this and all its children like Institution and its children Department dealmems.
						2. If we get Institution dealmemberId, we have to delete this and all its department dealmems.
						3. If we get Department dealmemberId, we have to delete the current record.
*/
@RestResource(urlMapping='/dealAPIService/*')
global with sharing class TF_DealAPIService {
    
	@HttpGet
    global static List<DealResponseData> doGet(){
        Boolean isNoSalesDealExists = false;
        Boolean isDeptRinggoldId = false;
        Boolean isConsortiumDM = false;
        Boolean isInstitutionDM = false;
        List<Deal_Member__c> mainDMList = new List<Deal_Member__c>();
        List<Deal_Member__c> dlMemList = new List<Deal_Member__c>();
        Set<String> dealMemCountIdSet = new Set<String>();
        Set<String> noSalesDealDMSet = new Set<String>();
        Set<String> noSDDepartmentDMSet = new Set<String>();
        Map<String,String> noSDDealMemMap = new Map<String,String>();
        Map<String,String> noSDDeptDMMap = new Map<String,String>();
        Map<String,Deal_Member__c> instDmMap = new Map<String,Deal_Member__c>();
        Map<Deal_Member__c, List<Deal_Member__c>> dealChildMemListMap = new Map<Deal_Member__c, List<Deal_Member__c>>();
        List<Sales_Deal__c> currSalesDealResList = new List<Sales_Deal__c>();
        List<Deal_Member__c> currDealMemResList = new List<Deal_Member__c>();
        String ringgoldId = null;
        Set<DealResponseData> resAllParamSet = new Set<DealResponseData>();
        List<DealResponseData> resList = new List<DealResponseData>();
        List<DealResponseData> tempIsParentResList = new List<DealResponseData>();
        String req = RestContext.request.toString();
        system.debug('req-->'+req);
        ringgoldId = RestContext.request.params.get('ringGoldId');
        system.debug('ringgoldId-->'+ringgoldId);
        String isParentDealParam = RestContext.request.params.get('includeParentDeal');//if includeParentDeal param is present then it is scenario 2 else scenario 1.
        system.debug('isParentDealParam-->'+isParentDealParam);
        String inactiveParam = RestContext.request.params.get('inactive');//if inactive param is present then it is scenario 3(all deals).
        system.debug('inactiveParam-->'+inactiveParam);
        List<Deal_Member__c> dealMemList = new List<Deal_Member__c>();
        Map<String,Sales_Deal__c> resultSalesdealMap = new Map<String,Sales_Deal__c>();
        Map<String,Deal_Member__c> resultParentDealMemMap = new Map<String,Deal_Member__c>();
        Map<Deal_Member__c,String> temp1DealMemMap = new Map<Deal_Member__c,String>();
        Map<String,String> temp2DealMemMap = new Map<String,String>();
        Map<String,List<Deal_Member__c>> resultFirstChildDealMemListMap = new Map<String,List<Deal_Member__c>>();
        Map<String,List<Deal_Member__c>> resultSecondChildDealMemListMap = new Map<String,List<Deal_Member__c>>();
        Map<String,String> dmSalesdealIdMap = new Map<String,String>();
        Map<String,Deal_Discount__c> resultDealDiscountMap = new Map<String,Deal_Discount__c>();
        //if(isParentDealParam == null){
            //For checking whether ringgold exists or not on Account Ringgold on Deal member, if no record found return null
            if(ringgoldId !=null){
                mainDMList = getDealMemberSOQL(null,null,null,ringgoldId,null);
                if(mainDMList == null){
                    mainDMList = getDealMemberSOQL(null,null,null,null,ringgoldId);// for department ringgoldId on Dealmember
                    if(!mainDMList.isEmpty()){
                        isDeptRinggoldId = true;
                    }else{
                        List<DealResponseData> emptyList = new List<DealResponseData>();
                        return emptyList;
                    }
                }else{
                    for(Deal_Member__c dm:mainDMList){
                        if(dm.Deal_Member__c != null || dm.Sales_Deal__c != null){
                            dealMemCountIdSet.add(dm.Id); // taking total count of dealmembers exist for input ringgoldId in scenario1                        
                            if(dm.Type__c == 'Consortium'){
                                isConsortiumDM = true;                                                        
                            }else if(dm.Type__c == 'Institution'){
                                isInstitutionDM = true;
                            }
                        }
                    }
                }
            }
            String currentDealMemWhrCond = 'Account_RingGold_ID__c =\''+ringgoldId+'\''; 
            dlMemList = getDealMemberSOQL(currentDealMemWhrCond,null,null,null,null);
            system.debug('dlMemList-->'+dlMemList);
            system.debug('dealMemCountIdSet-->'+dealMemCountIdSet);
            if(dlMemList.size()>0){
                for(Deal_Member__c dealMemRec: dlMemList){
                    if(dealMemCountIdSet.contains(dealMemRec.Id) && (dealMemRec.Sales_Deal__c !=null ||dealMemRec.Deal_Member__c != null)){
                        if(dealMemRec.Sales_Deal__c != null){
                            resultParentDealMemMap.put(dealMemRec.Id,dealMemRec); 
                            system.debug('inside salesdeal1');
                            dealMemList.add(dealMemRec);
                            resultSalesdealMap.put(dealMemRec.Id,dealMemRec.Sales_Deal__r);
                            dmSalesdealIdMap.put(dealMemRec.Sales_Deal__c,dealMemRec.Id);//for collecting resultant salesdeal to fetch dealdiscount records
                            currSalesDealResList.add(dealMemRec.Sales_Deal__r);
                        }else{
                            system.debug('outside salesdeal1');
                            noSalesDealDMSet.add(dealMemRec.Deal_Member__c);
                            noSDDealMemMap.put(dealMemRec.Deal_Member__c,dealMemRec.Id);
                            instDmMap.put(dealMemRec.Id,dealMemRec); //if the ringgold is inst dm having consortium as parent
                        }                      
                    }
                    //currDealMemResList.add(dealMemRec);//For displaying currDealMemResList, either scenario 1 or 2 both will be having same current deal member values.
                }
            }else{
                isNoSalesDealExists = true;
                if(!isDeptRinggoldId){
                    currentDealMemWhrCond = 'Account_RingGold_ID__c =\''+ringgoldId+'\'';
                    dlMemList = getDealMemberSOQL(currentDealMemWhrCond,null,null,null,null);
                }else{
                    system.debug('test inside Department_RinggoldId__c');
                    dlMemList = getDealMemberSOQL(null,null,null,null,ringgoldId);
                }
                system.debug('dlMemList-->'+dlMemList);
                for(Deal_Member__c dealMemRec: dlMemList){
                    //currDealMemResList.add(dealMemRec);
                    if(dealMemRec.Deal_Member__c != null){
                        //resultParentDealMemMap.put(dealMemRec.Id,dealMemRec);
                        noSalesDealDMSet.add(dealMemRec.Deal_Member__c); //segregating the deal name of deal mem record which doesn't have salesdeal on it.  
                        noSDDealMemMap.put(dealMemRec.Deal_Member__c,dealMemRec.Id);
                        noSDDeptDMMap.put(dealMemRec.Id,dealMemRec.Deal_Member__c);
                    }
                }
            }
            system.debug('noSDDeptDMMap-->'+noSDDeptDMMap);
            system.debug('noSDDealMemMap-->'+noSDDealMemMap);
            system.debug('resultParentDealMemMap-->'+resultParentDealMemMap);
            system.debug('instDmMap-->'+instDmMap);
            
            /*Finding SalesDeal on parent Deal member in scenario 2 = where deal member doesn't have saledeal on it and its a child to parent deal member*/
            if(noSalesDealDMSet !=null ){
                for(Deal_Member__c dmRec:getDealMemberSOQL(null,null,noSalesDealDMSet,null,null)){
                    system.debug('dmRec-->'+dmRec);
                    if(dmRec.Sales_Deal__c != null){
                        //In case of only institution ringgoldId as it's immediate parent will be having salesdeal then collecting salesdeal information here
                        dealMemList.add(dmRec);
                        if(dmRec.Type__c == 'Consortium'){
                            resultParentDealMemMap.put(noSDDealMemMap.get(dmRec.Id),dmRec);
                            resultSalesdealMap.put(noSDDealMemMap.get(dmRec.Id),dmRec.Sales_Deal__r);
                            dmSalesdealIdMap.put(dmRec.Sales_Deal__c,noSDDealMemMap.get(dmRec.Id));//for collecting total salesdeals to fetch dealdiscount records
                        }else{
                            resultParentDealMemMap.put(dmRec.Id,dmRec);
                            resultSalesdealMap.put(dmRec.Id,dmRec.Sales_Deal__r);
                            dmSalesdealIdMap.put(dmRec.Sales_Deal__c,dmRec.Id);//for collecting total salesdeals to fetch dealdiscount records
                        }
                        currSalesDealResList.add(dmRec.Sales_Deal__r);
                        if(isDeptRinggoldId){
                            noSDDepartmentDMSet.add(dmRec.Id); // if the dealmember structure is Institution --> Department
                            noSDDeptDMMap.put(dmRec.Id,dmRec.Deal_Member__c);
                        }
                    }else{
                        //if in case of department ringgoldId, we have to traverse to first childrenDealMem to parentDealMem to get salesdeal information
                        noSDDepartmentDMSet.add(dmRec.Deal_Member__c); // if the deal member structure is Consortium --> Institution --> Department
                        noSDDeptDMMap.put(dmRec.Id,dmRec.Deal_Member__c);
                    }
                }
            }
            system.debug('resultSalesdealMap-->'+resultSalesdealMap);
            system.debug('dmSalesdealIdMap-->'+dmSalesdealIdMap);
            system.debug('dealMemList-->'+dealMemList);
            system.debug('noSDDepartmentDMSet-->'+noSDDepartmentDMSet);
            system.debug('noSDDeptDMMap-->'+noSDDeptDMMap);
            if(noSDDepartmentDMSet != null ){
                for(Deal_Member__c dmRec:getDealMemberSOQL(null,null,noSDDepartmentDMSet,null,null)){
                    resultParentDealMemMap.put(dmRec.Id,dmRec);
                    if(dmRec.Sales_Deal__c != null){
                        dealMemList.add(dmRec);
                        resultSalesdealMap.put(dmRec.Id,dmRec.Sales_Deal__r);
                        dmSalesdealIdMap.put(dmRec.Sales_Deal__c,dmRec.Id);//for collecting total salesdeals to fetch dealdiscount records
                        currSalesDealResList.add(dmRec.Sales_Deal__r);
                    }
                }                        
            }
            system.debug('resultParentDealMemMap-->'+resultParentDealMemMap);
            /*After finding salesdeal+dealMem record then looking for children of existing deal member*/ 
            if(!dealMemList.isEmpty()){
                Set<String> dealMemIdSet = new Set<String>();
                /**dealMemList consists of dealmems with salesdeals but in some cases sd exists on Consortium level or on Institution level
                -> case1: if sd exists on Institution level, we can directly fetch children(dept).
                -> case2: if sd exists on Consortitum level, then we have to traverse to institution level and then to collect children(dept).
                **/
                for(Deal_Member__c dmRec:dealMemList){
                    if(dmRec.Type__c == 'Institution'){ //case1
                        dealMemIdSet.add(dmRec.Id); 
                    }else if(dmRec.Type__c == 'Consortium'){ //case2
                        //noSDDealMemMap contains nosddm child as key and parent as value
                        //dealMemIdSet.add(noSDDealMemMap.get(dmRec.Id)); 
                        dealMemIdSet.add(dmRec.Id);
                    }    
                }
                system.debug('dealMemIdSet-->'+dealMemIdSet);
                for(Deal_Member__c dm:getDealMemberSOQL(null,dealMemIdSet,null,null,null)){
                    temp1DealMemMap.put(dm,dm.Deal_Member__c);
                    if(!dealChildMemListMap.containsKey(dm)){
                        dealChildMemListMap.put(dm,new List<Deal_Member__c>{dm});
                    }else{
                        dealChildMemListMap.get(dm).add(dm);
                    }
                }
                
            }
            
            system.debug('temp1DealMemMap-->'+temp1DealMemMap);
            system.debug('dealChildMemListMap-->'+dealChildMemListMap);
            
            /*Finding child records for the current deal member->first level children*/
            if(dealChildMemListMap !=null){
                system.debug('isConsortiumDM-->'+isConsortiumDM);
                List<Deal_Member__c> newChildDLList = new List<Deal_Member__c>();
                Set<String> newChildIdSet = new Set<String>();
                for(Deal_Member__c dmObj:dealChildMemListMap.keySet() ){
                    for(Deal_Member__c dmChild:dealChildMemListMap.get(dmObj)){
                        system.debug('dmChild-->'+dmChild);
                        //newChildDLList.add(dmChild); // assigning first level children to the current deal member. 
                        newChildIdSet.add(dmChild.Id);// collecting Id's for getting second level children for the deal member.
                        temp2DealMemMap.put(dmChild.Id,dmChild.Deal_Member__c);
                        String firstChildMapKey = null;
                        if(dmChild.Type__c =='Institution' && !isConsortiumDM){
                            firstChildMapKey = dmChild.Id;
                        }else if(dmChild.Type__c =='Institution' && isConsortiumDM){
                            firstChildMapKey = dmChild.Deal_Member__c;
                        }else if(dmChild.Type__c =='Department' ){
                            system.debug('inside inst->dept structure');
                            firstChildMapKey = dmChild.Deal_Member__c;
                        }
                        if(isDeptRinggoldId){
                            system.debug('dept structure');
                            firstChildMapKey = noSDDeptDMMap.get(dmChild.Id);
                        }
                        system.debug('firstChildMapKey-->'+firstChildMapKey);
                        if(!resultFirstChildDealMemListMap.containsKey(firstChildMapKey) ){
                            resultFirstChildDealMemListMap.put(firstChildMapKey,new List<Deal_Member__c>{dmChild});                                        
                        }else{
                            resultFirstChildDealMemListMap.get(firstChildMapKey).add(dmChild);
                        }
                        
                    }  
                }
                system.debug('newChildIdSet-->'+newChildIdSet);
                system.debug('temp2DealMemMap-->'+temp2DealMemMap);
                system.debug('resultFirstChildDealMemListMap-->'+resultFirstChildDealMemListMap);
                /* Segregating second level children deal member children for example- first level child is "Institution" 
					now we have to get "Department" */
                dlMemList = getDealMemberSOQL(null,newChildIdSet,null,null,null);
                
                for(Deal_Member__c dmRec:dlMemList){
                    system.debug('dmRec-->'+dmRec);
                    String secondChildMapKey = null;
                    if(isDeptRinggoldId){
                        if(ringgoldId == dmRec.Department_RinggoldId__c){
                            secondChildMapKey = noSDDeptDMMap.get(dmRec.Deal_Member__c);
                        }                                                                                                                                                                                                  
                    }else{
                        secondChildMapKey = dmRec.Deal_Member__c;
                    }
                    if(isConsortiumDM){
                        secondChildMapKey = temp2DealMemMap.get(dmRec.Deal_Member__c);
                    }
                    system.debug('secondChildMapKey-->'+secondChildMapKey);
                    if(!resultSecondChildDealMemListMap.containsKey(secondChildMapKey) ){
                        resultSecondChildDealMemListMap.put(secondChildMapKey,new List<Deal_Member__c>{dmRec});    
                    }else{
                        resultSecondChildDealMemListMap.get(secondChildMapKey).add(dmRec);
                    }
                }
            }
            
            /*Fecthing Discount members from current Sales Deal*/
            for(Deal_Discount__c dealDiscRec:[SELECT Id,Sales_Deal__c,Discount_Type__c,Discount_Value_Amount__c,Discount_Value_Percentage__c FROM Deal_Discount__c WHERE Sales_Deal__c IN:dmSalesdealIdMap.keySet()]){
                resultDealDiscountMap.put(dmSalesdealIdMap.get(dealDiscRec.Sales_Deal__c),dealDiscRec);
            }
            
            List<String> resultDMList = new List<String>();
            if(isNoSalesDealExists){
                resultDMList.addAll(noSalesDealDMSet); // for scenario 2 we are taking noSalesDealDMSet as result deal members
                if(isDeptRinggoldId){
                    resultDMList.clear(); // to remove Id's which were added from noSalesDealDMSet which contains parent DealMem Id's of ringgoldId. Here we have to collect only input ringgoldId leve(Department)   
                    resultDMList.addAll(noSDDepartmentDMSet); //for department ringgoldId
                }
            }else{
                resultDMList.addAll(dealMemCountIdSet); // for scenario 1 we are taking dealMemCountIdSet as result deal members        
            }
            
            system.debug('resultParentDealMemMap-->'+resultParentDealMemMap);
            system.debug('resultSalesdealMap-->'+resultSalesdealMap);
            system.debug('resultFirstChildDealMemListMap-->'+resultFirstChildDealMemListMap);
            system.debug('resultSecondChildDealMemListMap-->'+resultSecondChildDealMemListMap);
            
            if(!resultDMList.isEmpty()){
                for(String dealMemId:resultDMList){
                    DealResponseData res = new DealResponseData();
                    
                    if(resultSalesdealMap.get(dealMemId) != null){
                        //scenario-3 : if this param is present then we need to retrieve active+inactive+valid enddate 
                        if(inactiveParam != null){
                            if(resultSalesdealMap.get(dealMemId).End_Date__c >= system.now().Date()){
                                system.debug('test inside salesdeal result scenario 3');
                                res.currentDealMem = resultParentDealMemMap.get(dealMemId);
                                res.currentSalesDeal= resultSalesdealMap.get(dealMemId);
                                res.firstChildDealMemRecords = resultFirstChildDealMemListMap.get(dealMemId); 
                                res.secondChildDealMemRecords = resultSecondChildDealMemListMap.get(dealMemId);
                                res.dealDiscountRecord = resultDealDiscountMap.get(dealMemId);
                                
                                if(isParentDealParam != null){	//scenario-4
                                    res.firstChildDealMemRecords = null;
                                    res.secondChildDealMemRecords = null;
                                    resAllParamSet.add(res);
                                }
                                
                            }  
                        }
                        //scenario 1
                        if(inactiveParam == null && isParentDealParam == null){
                            system.debug('resultSalesdealMap.get(dealMemId)-->'+resultSalesdealMap.get(dealMemId));
                            if(resultSalesdealMap.get(dealMemId).Active__c && (resultSalesdealMap.get(dealMemId).Start_Date__c <= system.now().Date() && resultSalesdealMap.get(dealMemId).End_Date__c >= system.now().Date() ) ){ // making sure by taking into response only if the salesdeal is active.
                                system.debug('resultSalesdealMap.get(dealMemId)-->'+resultSalesdealMap.get(dealMemId));
                                res.currentDealMem = resultParentDealMemMap.get(dealMemId);
                                res.currentSalesDeal= resultSalesdealMap.get(dealMemId);
                                res.firstChildDealMemRecords = resultFirstChildDealMemListMap.get(dealMemId); 
                                res.secondChildDealMemRecords = resultSecondChildDealMemListMap.get(dealMemId);
                                res.dealDiscountRecord = resultDealDiscountMap.get(dealMemId);  
                            }  
                        } 
                    }
                    
                    if(res.currentDealMem != null || res.currentSalesDeal != null || res.firstChildDealMemRecords != null || res.secondChildDealMemRecords != null || res.dealDiscountRecord != null){
                        resList.add(res);
                    }
                }
            }
            system.debug('resList-->'+resList);
        //}else{
        
        //scenario 2
        if(isParentDealParam != null){
            system.debug('inside scenario 2');
            Date currentDate = system.now().Date();
            currentDealMemWhrCond = null; // clearing the variable as we have used this in above logic.
            currentDealMemWhrCond = 'Account_RingGold_ID__c =\''+ringgoldId+'\' AND Sales_Deal__c != null'; 
            dlMemList = getDealMemberSOQL(currentDealMemWhrCond,null,null,null,null);
            system.debug('dlMemList-->'+dlMemList);
            for(Deal_Member__c dmRec:dlMemList){
                dmSalesdealIdMap.put(dmRec.Sales_Deal__c,dmRec.Id);//this map to collect dealMemId and salesdealId in order to fetch deal discount records.
            }
            system.debug('dmSalesdealIdMap-->'+dmSalesdealIdMap.values());
            for(Deal_Discount__c dealDiscRec:[SELECT Id,Sales_Deal__c,Discount_Type__c,Discount_Value_Amount__c,Discount_Value_Percentage__c FROM Deal_Discount__c WHERE Sales_Deal__c IN:dmSalesdealIdMap.keySet()]){
                resultDealDiscountMap.put(dmSalesdealIdMap.get(dealDiscRec.Sales_Deal__c),dealDiscRec);
            }
            system.debug('resultDealDiscountMap-->'+resultDealDiscountMap);
            for(Deal_Member__c dmRec:dlMemList){
                DealResponseData res = new DealResponseData();
                if(inactiveParam != null){ //Collecting data for scenario 4 
                    res.currentDealMem = dmRec;
                    res.currentSalesDeal= dmRec.Sales_Deal__r;
                    res.dealDiscountRecord = resultDealDiscountMap.get(dmRec.Id);
                    tempIsParentResList.add(res);
                }
                if(dmRec.Sales_Deal__r.Active__c && (dmRec.Sales_Deal__r.Start_Date__c <= currentDate && dmRec.Sales_Deal__r.End_Date__c >= currentDate) ){
                    
                    res.currentDealMem = dmRec;
                    res.currentSalesDeal= dmRec.Sales_Deal__r;
                    res.dealDiscountRecord = resultDealDiscountMap.get(dmRec.Id);
                    resList.add(res);
                    
                }
            }
            system.debug('tempIsParentResList-->'+tempIsParentResList);
            system.debug('resList-->'+resList);
        }     
        system.debug('resAllParamSet-->'+resAllParamSet);
        //scenario 4: isParentDealParam != null and inactiveParam != null then we need to display records without children as isParentDealParam is available in the url.
        if(isParentDealParam != null && inactiveParam != null){
            system.debug('inside scenario 4');
            resList.clear();
            List<String> tempSDList = new List<String>();
            for(DealResponseData res:resAllParamSet){
                tempSDList.add(res.currentSalesDeal.Id);
            }
            system.debug('tempSDList-->'+tempSDList);
            for(DealResponseData tempRes:tempIsParentResList){
                system.debug('tempRes.currentSalesDeal-->'+tempRes.currentSalesDeal.Id);
                if(tempSDList.contains(tempRes.currentSalesDeal.Id)){
                    system.debug('----->'+tempRes.currentSalesDeal.Id);
                    
                    resList.add(tempRes);
                }                                
            }
        }
        system.debug('resList-->'+resList);
        system.debug('CPU execution time in seconds-->'+Limits.getCPUTime()*0.001);
        return resList;
    }
    
    private static List<Deal_Member__c> getDealMemberSOQL(String whereCondition,Set<String> dealIds,Set<String> dealNames,String ringgoldId,String departmentRinggoldId){
        system.debug('inside get query');
        system.debug('whereCondition-->'+whereCondition);
        List<String> setToListStr = new List<String>();
        String query = 'SELECT Id,Name,Deal_Member__c,Account__c,Account__r.Billing_Country__c,Account_Name__c,Account_RingGold_ID__c,Department_RinggoldId__c,Department_name__c,Type__c,Sales_Deal__c,Sales_Deal__r.Active__c,Sales_Deal__r.Name,Sales_Deal__r.Deal_Name__c,Sales_Deal__r.Product_Inclusion__c,Sales_Deal__r.Description__c,Sales_Deal__r.Start_Date__c,Sales_Deal__r.End_Date__c,Sales_Deal__r.RecordType.Name,Sales_Deal__r.Type_of_Deal__c,Sales_Deal__r.Product_Open_Access_Category__c,Sales_Deal__r.Product_exclusion__c,Sales_Deal__r.isPrepay__c,Sales_Deal__r.Deal_Type__c FROM Deal_Member__c WHERE ';
        if(ringgoldId !=null && dealIds == null && whereCondition ==null && dealNames == null){
            query = query+'Account_RingGold_ID__c = \'' + ringgoldId + '\''; 
        }else if(departmentRinggoldId !=null){
            query = query+'Department_RinggoldId__c = \'' + departmentRinggoldId + '\'';                                                                                                                                                             
        }else if(whereCondition !=null && dealIds == null && dealNames == null){
            query = query + whereCondition;
        }else if(dealIds != null && whereCondition ==null && dealNames == null){
            setToListStr.addAll(dealIds);
            String idsString = String.join(setToListStr, '\',\''); //passing direct set<string> to dynamic soql is not possible so we have to pass the Ids as comma seperated values as a string.
            system.debug('idsString-->'+idsString);
            query = 'SELECT Id,Name,Deal_Member__c,Account__c,Account__r.Billing_Country__c,Account_Name__c,Account_RingGold_ID__c,Department_RinggoldId__c,Department_name__c,Type__c,Sales_Deal__c,Sales_Deal__r.Active__c,Sales_Deal__r.Name,Sales_Deal__r.Deal_Name__c,Sales_Deal__r.Product_Inclusion__c,Sales_Deal__r.Description__c,Sales_Deal__r.Start_Date__c,Sales_Deal__r.End_Date__c,Sales_Deal__r.RecordType.Name,Sales_Deal__r.Type_of_Deal__c,Sales_Deal__r.Product_Open_Access_Category__c,Sales_Deal__r.Product_exclusion__c,Sales_Deal__r.isPrepay__c,Sales_Deal__r.Deal_Type__c FROM Deal_Member__c WHERE Deal_Member__c IN(\'' + idsString + '\') ORDER BY Name ASC ';
        }else if(dealNames != null && dealIds == null && whereCondition == null ){
            setToListStr.addAll(dealNames);
            String idsString = String.join(setToListStr, '\',\''); 
            system.debug('idsString-->'+idsString);
            query = 'SELECT Id,Name,Deal_Member__c,Account__c,Account__r.Billing_Country__c,Account_Name__c,Account_RingGold_ID__c,Department_RinggoldId__c,Department_name__c,Type__c,Sales_Deal__c,Sales_Deal__r.Active__c,Sales_Deal__r.Name,Sales_Deal__r.Deal_Name__c,Sales_Deal__r.Product_Inclusion__c,Sales_Deal__r.Description__c,Sales_Deal__r.Start_Date__c,Sales_Deal__r.End_Date__c,Sales_Deal__r.RecordType.Name,Sales_Deal__r.Type_of_Deal__c,Sales_Deal__r.Product_Open_Access_Category__c,Sales_Deal__r.Product_exclusion__c,Sales_Deal__r.isPrepay__c,Sales_Deal__r.Deal_Type__c FROM Deal_Member__c  WHERE Id IN(\'' + idsString + '\')';
        } 
        system.debug('query-->'+query);
        List<Deal_Member__c> dealMemObjList = Database.query(query);
        system.debug('dealMemObjList-->'+dealMemObjList);
        
        //checking whether ringgold exists or not, if no record found return null else continue with the logic.
        if(dealMemObjList.size()==0 && ringgoldId !=null && dealIds == null && whereCondition ==null && dealNames == null){
            return null;
        }else{
            return dealMemObjList;
        }
    }
    
    global class DealResponseData{
        global Sales_Deal__c currentSalesDeal;
        global Deal_Member__c currentDealMem;
        global Deal_Discount__c dealDiscountRecord;
        global List<Deal_Member__c> firstChildDealMemRecords;
        global List<Deal_Member__c> secondChildDealMemRecords;
    }
        
    @HttpPost
    global static POSTResponseData doPost() {
        
        String jsonStr = RestContext.request.requestBody.toString();
        system.debug('testStr-->'+jsonStr);
        DealRequestData request = (DealRequestData)JSON.deserialize(jsonStr, DealRequestData.class);
        
        Sales_Deal__c salesDealRec = new Sales_Deal__c();
        List<Deal_Member__c> parentDealMemList = new List<Deal_Member__c>();
        List<Deal_Member__c> firstChildDealMemList = new List<Deal_Member__c>();
        List<Deal_Member__c> secondChildDealMemList = new List<Deal_Member__c>();
        Deal_Discount__c dealDiscRec = new Deal_Discount__c();
        
        /*Start of creation of Salesdeal record*/
        if(request.config != null){
            system.debug('request.config.startDate-->'+request.config.startDate);
            system.debug('request.config.startDate-->'+request.config.endDate);
            //system.debug('request.config.startDate-->'+Date.valueOf(request.config.startDate));
            salesDealRec.Deal_Name__c = request.config.dealName != null ? request.config.dealName:'';
            salesDealRec.Description__c = request.config.description != null ? request.config.description :'';
            salesDealRec.Start_Date__c = Date.parse(request.config.startDate);
            salesDealRec.End_Date__c = Date.parse(request.config.endDate);
            salesDealRec.RecordTypeId = Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get(request.config.type).getRecordTypeId();
            salesDealRec.Type_of_Deal__c = request.config.productType != null ? request.config.productType :'';
            //active would be boolean but we will get as String.
            Boolean activeBln = false;
            if(request.config.active.replace('"','') == 'true'){
                activeBln = true;
            }
            salesDealRec.Active__c = activeBln;
            salesDealRec.Deal_Type__c = request.config.dealType != null ? request.config.dealType:'';
            if(request.config.apcConfig != null){
                salesDealRec.Product_Open_Access_Category__c = request.config.apcConfig.openAccessCategory;
                salesDealRec.Product_Inclusion__c = string.join(request.config.apcConfig.productInclusion,',');
                salesDealRec.Product_exclusion__c = string.join(request.config.apcConfig.productExclusion,',');
            }
        }
        List<Sales_Deal__c> salesDealList = new List<Sales_Deal__c>();
        if(salesDealRec != null){
            try{
                insert salesDealRec;  
                system.debug('salesDealRec-->'+salesDealRec);
                //After inserting salesdeal need to fetch Name which is an autogenerated field.
                salesDealList = [SELECT Id,Active__c,Name,Deal_Name__c,Deal_Type__c,Description__c,Start_Date__c,End_Date__c,Type_of_Deal__c,RecordType.Name,
                                 		isPrepay__c,Product_Open_Access_Category__c,Product_Inclusion__c,Product_exclusion__c 
                                 FROM Sales_Deal__c
                                 WHERE Id=:salesDealRec.Id LIMIT 1];
            }catch(Exception e){
                System.debug('exception-->'+e);
            }
        }
        /*End of creation of Salesdeal record*/
        
        /*Insertion of discount record for the salesdeal */
        if(request.config.discountConfig != null){
            system.debug('inside discount ');
            
            dealDiscRec.Discount_Type__c = request.config.discountConfig.discountType;
            if(request.config.discountConfig.discountType == '% Discount'){
                dealDiscRec.Discount_Value_Percentage__c = Decimal.valueOf(request.config.discountConfig.discountValue);
            }else{
                dealDiscRec.Discount_Value_Amount__c = Decimal.valueOf(request.config.discountConfig.discountValue);
            }
            if(salesDealRec != null){
                dealDiscRec.Sales_Deal__c = salesDealRec.Id;
            }
            if(dealDiscRec != null){
                try{
                    insert dealDiscRec;
                }catch(Exception e){
                    system.debug('Exception-->'+e);
                }
            }
        }
        /*End of Insertion of discount record for the salesdeal */
        
        /*========Start of inserting deal members ==========*/
        Map<Deal_Member__c,List<Deal_Member__c>> parentChildDealMemListMap = new Map<Deal_Member__c,List<Deal_Member__c>>();
        Set<String> ringgoldIdSet = new Set<String>();
        Map<String,String> ringgoldAccountMap = new Map<String,String>();
        Map<String,String> reqDmRinggoldIdMap = new Map<String,String>();
        Map<String,List<TF_DealAPIService.children>> ringgoldDealMemChildrenListMap = new Map<String,List<TF_DealAPIService.children>>();
        Map<String,TF_DealAPIService.children> ringgoldSecondDealMemChildrenListMap = new Map<String,TF_DealAPIService.children>();
        
        if(!request.config.customerConfig.isEmpty() ){
            for(TF_DealAPIService.customerConfig dmRec:request.config.customerConfig){
                if(dmRec.isTnFAccount){
                    ringgoldIdSet.add(dmRec.ringGoldId);
                }
            }          
        }  
        system.debug('ringgoldIdSet-->'+ringgoldIdSet);

		reqDmRinggoldIdMap = getAccountByRinggoldId(ringgoldIdSet,request.config.customerConfig,false);        
        
        /*Preparing parent dealmember data for creation*/
        for(TF_DealAPIService.customerConfig dmRec:request.config.customerConfig){
            Deal_Member__c dealMemRec = new Deal_Member__c();
            dealMemRec.Type__c = dmRec.type != null ? dmRec.type :'';
            if(!dmRec.isTnFAccount){
                dealMemRec.Department_RinggoldId__c = dmRec.ringGoldId != null ? dmRec.ringGoldId :'' ;
                dealMemRec.Department_name__c = dmRec.name != null ? dmRec.name :'';
            }else{
                if(reqDmRinggoldIdMap != null){
                    dealMemRec.Account__c = reqDmRinggoldIdMap.get(dmRec.ringGoldId);
                }
            }
            if(salesDealRec.Id != null){
                dealMemRec.Sales_Deal__c =  salesDealRec.Id;
            }            
            parentDealMemList.add(dealMemRec);
            //collecting child dealmembers
            ringgoldDealMemChildrenListMap.put(dmRec.ringGoldId,dmRec.children);
            for(TF_DealAPIService.children child:dmRec.children){
                ringgoldSecondDealMemChildrenListMap.put(child.ringGoldId,child);
            }
            
        }/*end of for loop*/
        
        if(!parentDealMemList.isEmpty()){
            insertingDealMemberRecords(parentDealMemList);
        }
        /*End of code Creation of parent Deal member*/

        //Creation of First Child deal member
        firstChildDealMemList = createChildDealMemFromParentdealMem(parentDealMemList,ringgoldDealMemChildrenListMap,request.config.customerConfig,null);
        
        if(!firstChildDealMemList.isEmpty()){
            insertingDealMemberRecords(firstChildDealMemList);
        }
        
        //Creation of Second Child deal member
        secondChildDealMemList = createChildDealMemFromParentdealMem(firstChildDealMemList,ringgoldDealMemChildrenListMap,null,ringgoldSecondDealMemChildrenListMap);
        
        if(!secondChildDealMemList.isEmpty()){
            insertingDealMemberRecords(secondChildDealMemList);
        }
        
        
        POSTResponseData response = new POSTResponseData();
        if(!salesDealList.isEmpty() && salesDealList[0] != null){
            response.salesDeal = salesDealList[0];
        }
        
        response.parentDealMemList = getInsertedDealMemRecords(parentDealMemList);
        response.firstChildDealMemRecords = getInsertedDealMemRecords(firstChildDealMemList);
        response.secondChildDealMemRecords = getInsertedDealMemRecords(secondChildDealMemList);
        response.dealDiscountRecord = dealDiscRec;
        
        return response;
    }/*End of POST method*/
    
    /*Method to take inserted records as input and fetch Salesdealname and Dealname which are autogenerated in salesforce after creation of record */
    private static List<Deal_Member__c> getInsertedDealMemRecords(List<Deal_Member__c> dmList){
        Set<String> dmIdSet = new Set<String>();
        for(Deal_Member__c dm:dmList){
            dmIdSet.add(dm.Id);                                                            
        }
        List<Deal_Member__c> insertedDMList = getDealMemberSOQL(null,null,dmIdSet,null,null);  
        return insertedDMList;
    }
        
    /*Method for Fetching AccountId to the specified ringgold and assinging back for creating deal member when isTnFAccount = true*/
    private Static Map<String,String> getAccountByRinggoldId(Set<String> ringgoldIdSet,List<TF_DealAPIService.customerConfig> reqDmList,Boolean isChildRec){
        
        Map<String,String> ringgoldAccountMap = new Map<String,String>();
        Map<String,String> reqDmMap = new Map<String,String>();
        List<TF_DealAPIService.children> childDealMemsList = new List<TF_DealAPIService.children>();
        
        if(ringgoldIdSet != null){
            for(Account acc:[SELECT Id,Name,Ringgold_Account_ID__c FROM Account WHERE Ringgold_Account_ID__c IN:ringgoldIdSet]){
                //crating a map of ringgoldId with AccountId 
                ringgoldAccountMap.put(acc.Ringgold_Account_ID__c,acc.Id);
            }
        }
       
        if(reqDmList != null){
            for(TF_DealAPIService.customerConfig dmRec:reqDmList){
                reqDmMap.put(dmRec.ringGoldId,ringgoldAccountMap.get(dmRec.ringGoldId));// for Parent Deal member
                if(isChildRec){ 
                    //fetching children records 
                    for(TF_DealAPIService.children dmRecChildList : dmRec.children){
                        childDealMemsList.add(dmRecChildList);                                                                                                    
                    } 
                }
            }
            if(isChildRec){ 
                //iterating for children records only in case of children dealmembers
                for(TF_DealAPIService.children childDm:childDealMemsList){
                    reqDmMap.put(childDm.ringGoldId,ringgoldAccountMap.get(childDm.ringGoldId)); // for first Child deal member
                }
            }
        }
        
        return reqDmMap;
    }
    
    /**/
    private Static List<Deal_Member__c> createChildDealMemFromParentdealMem(List<Deal_Member__c> parentDealMemList,Map<String,List<TF_DealAPIService.children>> ringgoldDealMemChildrenListMap,List<TF_DealAPIService.customerConfig> reqDmList,Map<String,TF_DealAPIService.children> seconddDealMemChildrenMap){
        
        Map<String,String> reqFirstDmRinggoldIdMap = new Map<String,String>();
        List<Deal_Member__c> childDealMemList = new List<Deal_Member__c>();
        List<Deal_Member__c> secondChildDealMemList = new List<Deal_Member__c>();
        
        //For fetching required field values like Account_RingGold_ID__c for created parent dealmember records.
        Set<String> dmIdSet = new Set<String>();
        for(Deal_Member__c dm:parentDealMemList){
            dmIdSet.add(dm.Id);                        
        }
        List<Deal_Member__c> dlList = getDealMemberSOQL(null,null,dmIdSet,null,null);//parent deal member record
        
        /*Start of code creation of children deal member*/
        Map<List<TF_DealAPIService.children>,String> dealIdChildrenListMap = new Map<List<TF_DealAPIService.children>,String>();
        Map<TF_DealAPIService.children,String> seconddealIdChildrenMap = new Map<TF_DealAPIService.children,String>();
        for(Deal_Member__c dm:dlList){
            if(dm.Type__c =='Department' && dm.Department_RinggoldId__c != null){
                if(ringgoldDealMemChildrenListMap != null){
                    dealIdChildrenListMap.put(ringgoldDealMemChildrenListMap.get(dm.Department_RinggoldId__c),dm.Id);
                }
                if(seconddDealMemChildrenMap != null){
                    seconddealIdChildrenMap.put(seconddDealMemChildrenMap.get(dm.Department_RinggoldId__c),dm.Id);
                }
            }else{
                if(ringgoldDealMemChildrenListMap != null){
                    dealIdChildrenListMap.put(ringgoldDealMemChildrenListMap.get(dm.Account_RingGold_ID__c),dm.Id);
                }
                if(seconddDealMemChildrenMap != null){
                    seconddealIdChildrenMap.put(seconddDealMemChildrenMap.get(dm.Account_RingGold_ID__c),dm.Id);
                }
            }																							
        }
        Map<String,TF_DealAPIService.children> firstChildMap = new Map<String,TF_DealAPIService.children>();
        List<String> ringgoldList = new List<String>();
        Set<String> ringgoldIdSet = new Set<String>();
        if(ringgoldDealMemChildrenListMap != null){
            for(List<TF_DealAPIService.children> childMems:ringgoldDealMemChildrenListMap.values()){
                String dealMemId = dealIdChildrenListMap.get(childMems);
                for(TF_DealAPIService.children ch:childMems){
                    if(ch.isTnFAccount && !ringgoldList.contains(ch.ringGoldId)){
                        ringgoldList.add(ch.ringGoldId);
                    }
                }// end of second for loop
            }// end of first for loop            
        }
        
        ringgoldIdSet= new Set<String>(ringgoldList); //ringgoldIdSet is throwing exception while passing same ringgoldId in the above so added to List and assigned again to Set.
        if(ringgoldDealMemChildrenListMap != null){
            reqFirstDmRinggoldIdMap = getAccountByRinggoldId(ringgoldIdSet,reqDmList,true);
        }
        if(ringgoldDealMemChildrenListMap != null && seconddDealMemChildrenMap == null){ //for handling first deal members 
            for(List<TF_DealAPIService.children> childMems:ringgoldDealMemChildrenListMap.values()){
                String dealMemId = dealIdChildrenListMap.get(childMems);
                for(TF_DealAPIService.children ch:childMems){
                    Deal_Member__c dealMemRec = new Deal_Member__c();
                    dealMemRec.Deal_Member__c = dealMemId;
                    dealMemRec.Type__c = ch.type != null ? ch.type :'';
                    if(!ch.isTnFAccount){
                        dealMemRec.Department_RinggoldId__c = ch.ringGoldId != null ? ch.ringGoldId :'' ;
                        dealMemRec.Department_name__c = ch.name != null ? ch.name :'';
                    }else{
                        dealMemRec.Account__c = reqFirstDmRinggoldIdMap.get(ch.ringGoldId);
                    }
                    childDealMemList.add(dealMemRec);
                }//end of second for loop
            }//end of first for loop
        }
        if(seconddDealMemChildrenMap != null ){ //for handling second children deal members
            for(TF_DealAPIService.children childMems:seconddDealMemChildrenMap.values()){
                String dealMemId = seconddealIdChildrenMap.get(childMems);
                if(childMems.children != null){
                    for(TF_DealAPIService.children ch:childMems.children){
                        Deal_Member__c dealMemRec = new Deal_Member__c();
                        dealMemRec.Deal_Member__c = dealMemId;
                        dealMemRec.Type__c = ch.type != null ? ch.type :'';
                        if(!ch.isTnFAccount){
                            dealMemRec.Department_RinggoldId__c = ch.ringGoldId != null ? ch.ringGoldId :'' ;
                            dealMemRec.Department_name__c = ch.name != null ? ch.name :'';
                        }else{
                            dealMemRec.Account__c = reqFirstDmRinggoldIdMap.get(ch.ringGoldId);
                        } 
                        childDealMemList.add(dealMemRec);
                    }
                }
            }
        }
        /*End of code creation of children deal member*/
        
        return childDealMemList;
    }
    
    /*For inserting deal memeber records*/
    private static List<Deal_Member__c> insertingDealMemberRecords(List<Deal_Member__c> recordsList){
        List<Deal_Member__c> dealMemList = new List<Deal_Member__c>();
        try{
            insert recordsList;
            Set<String> dealMemIdSet = new Set<String>();
            for(Deal_Member__c dmRec:recordsList){
                dealMemIdSet.add(dmRec.Id);
            }
            dealMemList = [SELECT Id,Name,Type__c,Department_RinggoldId__c,Department_name__c,
                                                	   Account__c,Account_Name__c,Sales_Deal__c 
                                                FROM Deal_Member__c 
                                                WHERE Id IN:dealMemIdSet];
        }catch(Exception e){
            system.debug('Exception-->'+e);
        }          
        system.debug('dealMemList-->'+dealMemList);
        return dealMemList;
    }
    
    //wrapper class for POST response
    global class POSTResponseData{
        global Sales_Deal__c salesDeal;
        global List<Deal_Member__c> parentDealMemList;
        global Deal_Discount__c dealDiscountRecord;
        global List<Deal_Member__c> firstChildDealMemRecords;
        global List<Deal_Member__c> secondChildDealMemRecords;
    }
    
    //wrapper class POST request body
    global class DealRequestData {
        public config config;
        public String source;
    }
    global class config{
        public String dealName;
        public String shortDescription;
        public String description;
        public String startDate;
        public String endDate;
        public String type;
        public String productType;
        public String fundType;
        public String dealType;
        public String active;
        public apcConfig apcConfig;
        public List<customerConfig> customerConfig;
        public discountConfig discountConfig;
    }
    global class customerConfig {
        public String type;
        public String ringGoldId;
        public String name;
        public Boolean isTnFAccount;
        public List<children> children;
    }
    global class children{
        public String type;
        public String ringGoldId;
        public String name;
        public Boolean isTnFAccount;
        public List<children> children;
    }
    global class discountConfig{
        public String discountType;
        public String discountValue;
    }
    global class apcConfig{
        public String openAccessCategory;
        public String priceCategory;
        public List<String> productInclusion;
        public List<String> productExclusion;
    }
        
    @HttpDelete
    global static String doDelete(){
        system.debug('inside delete');
        Set<String> dealMemIdSetToDelete = new Set<String>();//Set to gather all dealmembers to delete
        
        String dealMemId = RestContext.request.requestURI.substringAfter('dealAPIService/');                  
        String dealType = RestContext.request.params.get('type');
        
        //Adding current dealmember Id to the Set to delete.
        dealMemIdSetToDelete.add(dealMemId);
        system.debug('dealMemIdSetToDelete111-->'+dealMemIdSetToDelete);
        //if the type is Consortium then need to fetch 
        if(dealType == 'Consortium'){
            Set<String> dealMemIds = new Set<String>();
            String whrCond1 = 'Deal_Member__c =\''+dealMemId+'\'';
            for(Deal_Member__c dm:getDealMemberSOQL(whrCond1,null,null,null,null)){
                if(dm.Type__c == 'Institution'){
                    dealMemIdSetToDelete.add(dm.Id); // fetching Institution dealmembers 
                    dealMemIds.add(dm.Id); //Collecting Ids to fetch its respective children
                }else{
                    return 'Inappropriate input dealmember type.';
                }
            } 
            system.debug('dealMemIds-->'+dealMemIds);
            for(Deal_Member__c dm:getDealMemberSOQL(null,dealMemIds,null,null,null)){
                dealMemIdSetToDelete.add(dm.Id); // fetching Department dealmembers 
            } 
        }
        //if the type is Institution then need to fetch child department records 
        if(dealType == 'Institution'){
            String whrCond = 'Deal_Member__c =\''+dealMemId+'\'';
            for(Deal_Member__c dm:getDealMemberSOQL(whrCond,null,null,null,null)){
                if(dm.Type__c == 'Department'){
                    dealMemIdSetToDelete.add(dm.Id); // fetching department dealmembers
                }else{
                    return 'Inappropriate input dealmember type.';
                }                 
            }                                                  
        }
           
        if(dealMemIdSetToDelete != null){
            try{
                List<Deal_Member__c> delList = getDealMemberSOQL(null,null,dealMemIdSetToDelete,null,null);
                system.debug('delList-->'+delList);
                if(!delList.isEmpty()){
                    delete delList;
                }else{
                    return 'Invalid dealmember Id';                    
                }
                //delete[SELECT Id FROM Deal_Member__c WHERE Id IN:dealMemIdSetToDelete];
            }catch(Exception e){System.debug('exception-->'+e);}
        }
        
        return 'Record deleted successfully';
    }
    
}