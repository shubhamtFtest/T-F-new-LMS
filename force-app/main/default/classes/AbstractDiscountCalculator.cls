/*Created By: Piyush Jain
 *Description: Used in FSD discounting flow as part of FSD Project
 *Test Class: ztest_ProductDiscountService
**/
public abstract class AbstractDiscountCalculator implements DiscountCalculator {
    
    protected EligibilityCheckFactory factory;
    
    /* BULKIFICATION CHANGES START */  
    public List<DiscountRequest> getDiscountBulk(List<DiscountRequest> requestList) {
        System.debug('***** Calculating  Discount *****');    
        Map<String,List<Sales_Deal__c>> salesDealMap = new Map<String,List<Sales_Deal__c>>();
        List<Sales_Deal__c> salesDealList = new List<Sales_Deal__c>();
		//Shalini: Start changes for SFSD- 1202  
		//salesDealMap = getDealCofigurationBulk();Removed this and added new one
		salesDealMap = getDealCofigurationBulk(requestList);
		//Shalini: End changes for SFSD- 1202
		
        //Map<String,List<TandF_Account_to_Consortium__c>> salesDealAccountToConMemMap = new Map<String,List<TandF_Account_to_Consortium__c>>();
        //Set<Id> salesDealAccountIdSet = new Set<Id>();
        Set<Id> salesDealIdSet = new Set<Id>();

        for(String keySet : salesDealMap.keySet()){
            salesDealList.addAll(salesDealMap.get(keySet));
        }
        for(Sales_Deal__c salesDeal : salesDealList){
            if(salesDeal.Id != null){
            	salesDealIdSet.add(salesDeal.Id);
            }
        }
        
        //Shalini: Start changes for SFSD- 1202  
        map<Id,List<Deal_Member__c>> mapParentsaleDealDealMemberMap=new map<Id,List<Deal_Member__c>>();
        map<Id,List<Deal_Member__c>> mapChildsaleDealDealMemberMap=new map<Id,List<Deal_Member__c>>();
        
        /*if(!salesDealIdSet.isEmpty() && salesDealIdSet != null){
            for(Deal_Member__c dm:[Select id,sales_deal__c,Deal_Member__r.sales_deal__c,Deal_Member__c.Account__c,Account__r.Customer_Id__c from Deal_Member__c
                                              where Sales_Deal__c=:salesDealIdSet]){
                                                  system.debug('dm '+dm);
                                                  
                                                  if(dm.sales_deal__c!=null){
                                                      if(mapParentsaleDealDealMemberMap.containsKey(dm.Sales_Deal__c)) {
                                                          mapParentsaleDealDealMemberMap.get(dm.Sales_Deal__c).add(dm);
                                                      } else {
                                                          mapParentsaleDealDealMemberMap.put(dm.Sales_Deal__c, new List<Deal_Member__c> { dm });
                                                      }
                                                      salesDealAccountIdSet.add(dm.Account__c);//To check these parent exists in Account to consortium object or not
                                                  }
                                                  else if(dm.Deal_Member__r.sales_deal__c!=null)
                                                  {
                                                      if(mapChildsaleDealDealMemberMap.containsKey(dm.Deal_Member__r.Sales_Deal__c)) {
                                                          mapChildsaleDealDealMemberMap.get(dm.Deal_Member__r.Sales_Deal__c).add(dm);
                                                      } else {
                                                          mapChildsaleDealDealMemberMap.put(dm.Deal_Member__r.Sales_Deal__c, new List<Deal_Member__c> { dm });
                                                      }
                                                  }
                                                  
                                              }
        }

		for(TandF_Account_to_Consortium__c consortiumMember : [SELECT Consortium_Member_Party_ID__c,ConsortiumParent__c FROM TandF_Account_to_Consortium__c WHERE ConsortiumParent__c IN :salesDealAccountIdSet]){
            system.debug('@consortiumMember(parent) '+consortiumMember);
            if(!salesDealAccountToConMemMap.containsKey(consortiumMember.ConsortiumParent__c)){
                salesDealAccountToConMemMap.put(consortiumMember.ConsortiumParent__c,new List<TandF_Account_to_Consortium__c>());
            }
            salesDealAccountToConMemMap.get(consortiumMember.ConsortiumParent__c).add(consortiumMember);//Map of counsortim parent(Account) and its record(Child Member)
        }*/
        if(!salesDealIdSet.isEmpty() && salesDealIdSet != null){
            for(Deal_Member__c dm:[Select id,sales_deal__c,Deal_Member__r.sales_deal__c,Deal_Member__c.Account__c,Account__r.Customer_Id__c,Account__r.Ringgold_Account_ID__c 
                                   from Deal_Member__c where Sales_Deal__c=:salesDealIdSet])
            {
                system.debug('dm parent===> '+dm);
                if(dm.sales_deal__c!=null){
                    if(mapParentsaleDealDealMemberMap.containsKey(dm.Sales_Deal__c)) {
                        mapParentsaleDealDealMemberMap.get(dm.Sales_Deal__c).add(dm);
                    } else {
                        mapParentsaleDealDealMemberMap.put(dm.Sales_Deal__c, new List<Deal_Member__c> { dm });
                    }
                }
            }
            
            for(Deal_Member__c dm:[Select id,Sales_Deal__c,Deal_Member__r.Sales_Deal__c,Deal_Member__c.Account__c,Account__r.Customer_Id__c,Account__r.Ringgold_Account_ID__c 
                                   from Deal_Member__c where Deal_Member__r.Sales_Deal__c in :salesDealIdSet])
            {
                system.debug('dm child===> '+dm);
                if(mapChildsaleDealDealMemberMap.containsKey(dm.Deal_Member__r.Sales_Deal__c)) {
                    mapChildsaleDealDealMemberMap.get(dm.Deal_Member__r.Sales_Deal__c).add(dm);
                } else {
                    mapChildsaleDealDealMemberMap.put(dm.Deal_Member__r.Sales_Deal__c, new List<Deal_Member__c> { dm });
                }
            }
            
        }
        //Shalini: End changes for SFSD- 1202
        
        
		system.debug('mapParentsaleDealDealMemberMap '+mapParentsaleDealDealMemberMap);
        system.debug('mapChildsaleDealDealMemberMap '+mapChildsaleDealDealMemberMap);
		//system.debug('salesDealAccountIdSet '+salesDealAccountIdSet);
		//system.debug('salesDealAccountToConMemMap '+salesDealAccountToConMemMap);

        
        for(DiscountRequest request : requestList){
            request.salesDealList = new List<Sales_Deal__c>();
            request.salesDealList.addAll(salesDealList);
        }
        system.debug(requestList+'@req@'+requestList.size());
        system.debug('@sd@'+salesDealList.size());
        
        for(DiscountRequest request : requestList){
            request.discountList = new List<Discount>();
            for (Sales_Deal__c salesDeal : salesDealList) {
                List<Deal_Member__c> childList=new List<Deal_Member__c>();
                List<Deal_Member__c> parentList=new List<Deal_Member__c>();
                if(mapChildsaleDealDealMemberMap.containsKey(salesDeal.id)){
                    childList.addAll(mapChildsaleDealDealMemberMap.get(salesDeal.id));
                }
                
                if(mapParentsaleDealDealMemberMap.containsKey(salesDeal.id)){
                    parentList.addAll(mapParentsaleDealDealMemberMap.get(salesDeal.id));
                }
                system.debug('childList '+ childList.size()+' '+childList);
                system.debug('parentList '+ parentList.size()+' '+parentList);
                
                factory = new EligibilityCheckFactory(salesDeal, request);
                if(factory.getAccountEligibilityCheck().isAccountEligibleForDiscountBulk(childList,parentList,salesDeal, request) && factory.getProductEligibilityCheck().isProductEligibleForDiscount(salesDeal, request)) {
                    System.debug('@call "getDiscountBulk" from discount class!! ');
                    request.discountList.add(Discount.getDiscountBulk(salesDeal, request, salesDeal.Deal_Discounts__r));
                }
        	}
            
        }
        System.debug('Request List in Abstract discount calc apex '+requestList);
        System.debug('@Number of Queries used in this apex code so far==> ' + Limits.getQueries());
        System.debug('@Number of rows queried in this apex code so far==> ' + Limits.getQueryRows());
        return requestList;
    }
    /* BULKIFICATION CHANGES END */
    
    //public abstract List<Sales_Deal__c> getDealCofiguration();
    public abstract Map<String,List<Sales_Deal__c>> getDealCofigurationBulk(List<DiscountRequest> requestList);
    
}