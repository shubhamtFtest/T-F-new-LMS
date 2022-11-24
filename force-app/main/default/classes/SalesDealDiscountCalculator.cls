/*Created By: Piyush Jain
 *Description: Used in FSD discounting flow as part of FSD Project
 *Test Class: ztest_ProductDiscountService
**/
public with sharing class SalesDealDiscountCalculator extends AbstractDiscountCalculator {
    
    private Id salesDealRecordTypeID;
    private Set<Id> salesDealRecordTypeIDSet;
    
    //FOR BULKIFICATION CHANGE
    public SalesDealDiscountCalculator(Set<Id> recordTypeIdSet) {
        salesDealRecordTypeIDSet = recordTypeIdSet;
        System.debug('SalesDeal Constructor');
    }
  
    //Shalini: Start changes for SFSD- 1202 
    /* BULKIFICATION CHANGES START */ 
    public override Map<String,List<Sales_Deal__c>> getDealCofigurationBulk(List<DiscountRequest> requestList) {
        System.debug('@getdeal sales deal method');
        Map<String,List<Sales_Deal__c>> recTypeIdToSalesDealListMap = new Map<String,List<Sales_Deal__c>>();
        Set<String> billingCountryCodeSet = new Set<String>();
        Map<String,Country__c> billingCountryCodeToCountryMap = new Map<String,Country__c>();
        Set<String> promoCodeSet = new Set<String>();
        Set<String> setOfApplicableListId=new Set<String>{'\''+ null + '\''};//Set<String> setOfApplicableListId=new Set<String>();
        Set<String> setOfEiflId=new Set<String>{'\''+ null + '\''};//Set<String> setOfEiflId=new Set<String>();
        Set<String> setPromoCode=new Set<String>();
    	Set<String> setparentProduct=new Set<String>();
        Set<String> setOfRequestCustimerId=new Set<String>();
        Set<String> setOfRequestRingoldId=new Set<String>();
    	Map<String,String> mapOfSalesdealIdToCustomerId=new Map<String,String>();
        
        for(DiscountRequest discountReq:requestList){
            system.debug('@discountReq.country.Applicable_List__c'+ discountReq.country.Applicable_List__c);
            system.debug('@promoCode '+discountReq.promoCode);
            system.debug('@parentProduct '+discountReq.parentProduct);
            
            if(discountReq.parentProduct != '0' && String.isNotBlank(discountReq.parentProduct))
            setparentProduct.add('\''+ discountReq.parentProduct + '\'');
            
            //If applycountryDiscount check box true in request or country.Applicable_List__c is a Sanctioned Country then fetch country deals
            if(String.isNotBlank(discountReq.country.Applicable_List__c) && (discountReq.applycountryDiscount==true || discountReq.country.Applicable_List__c=='Sanctioned Country'))
                setOfApplicableListId.add('\''+ discountReq.country.Applicable_List__c + '\'');
            
            //If eifl type is present the consider county sales deals
            if(String.isNotBlank(discountReq.country.EIFL_Type__c)  )
            {
                /*if(setOfEiflId.contains(null))
                    setOfEiflId.remove(null);*/
                setOfEiflId.add('\''+ discountReq.country.EIFL_Type__c + '\'');
            }
                
            //If promocode is available in request then only fetch promocode sales deals 
            if(String.isNotBlank(discountReq.promoCode))
                setPromoCode.add('\''+ discountReq.promoCode + '\'');
            
            if(String.isNotBlank(discountReq.customerID))
            setOfRequestCustimerId.add(discountReq.customerID);
            
            if(String.isNotBlank(discountReq.ringoldId))
            setOfRequestRingoldId.add(discountReq.ringoldId);
            //if(String.isNotBlank(discountReq.customerID))
            //setOfRequestCustimerId.add('\''+ discountReq.customerID +'\'');
        }
        
        system.debug('@setOfApplicableListId '+setOfApplicableListId);
        system.debug('@setparentProduct '+setparentProduct);
        system.debug('@setOfRequestCustimerId '+setOfRequestCustimerId);
        system.debug('@setOfRequestRingoldId '+setOfRequestRingoldId);
        
        //For consortium, institution and department sales deals  
        if(!setOfRequestCustimerId.isEmpty() || !setOfRequestRingoldId.isEmpty()){
            for(Deal_Member__c dealMemberObj:[Select id,sales_deal__c,Deal_Member__r.sales_deal__c,Deal_Member__r.Deal_Member__r.sales_deal__c,Account_Party_ID__c,Account_RingGold_ID__c from Deal_Member__c
                                              where (Account_Party_ID__c in:setOfRequestCustimerId or Account_RingGold_ID__c in:setOfRequestRingoldId)]){
                                                  system.debug('dealMemberObj '+dealMemberObj);
                                                  
                                                  if(dealMemberObj.sales_deal__c!=null){
                                                      mapOfSalesdealIdToCustomerId.put(dealMemberObj.sales_deal__c,dealMemberObj.Account_Party_ID__c);
                                                  }
                                                  else if(dealMemberObj.Deal_Member__r.sales_deal__c!=null)
                                                  {
                                                      mapOfSalesdealIdToCustomerId.put(dealMemberObj.Deal_Member__r.sales_deal__c,dealMemberObj.Account_Party_ID__c);
                                                  }
                                                  /*else if(dealMemberObj.Deal_Member__r.Deal_Member__r.sales_deal__c!=null)
                                                  {
                                                      mapOfSalesdealIdToCustomerId.put(dealMemberObj.Deal_Member__r.Deal_Member__r.sales_deal__c,dealMemberObj.Account_Party_ID__c);
                                                  }*///As we aren't considering department concept 
                                                  
                                              }
        }
        system.debug('mapOfSalesdealIdToCustomerId '+mapOfSalesdealIdToCustomerId);
        //Before Query convert all sets to list
        List<String> mapOfSalesdealIdToCustomerIdList = new List<String>();
        for(Id idsObj:mapOfSalesdealIdToCustomerId.keySet()){
            mapOfSalesdealIdToCustomerIdList.add('\''+ idsObj + '\'');
        }
        List<String> setparentProductList = new List<String>(setparentProduct);
        List<String> setPromoCodeList = new List<String>(setPromoCode);
        List<String> setOfApplicableListIdList = new List<String>(setOfApplicableListId);
        List<String> setOfEiflIdList = new List<String>(setOfEiflId);
        
        String query = 'SELECT isPrepay__c, recordtype.name,name,Active__c,Start_Date__c,Promocode__c,End_Date__c,CurrencyIsoCode,'+ 
            'Product_Inclusion__c, RecordTypeId,Apply_list_price_if_lower_than_discount__c, Type_of_Deal__c,Product__c,Netbase_Classifications__c,'+
            'Product_exclusion__c,  Product_APC_Price_Category__c,Product__r.Hub_Id__c,'+
            'Product_Open_Access_Category__c,EIFL_Type__c,Country_Applicable_List__c,Product_Code__c,Discount_Display_Name__c,'+
            '(SELECT Discount_Type__c,Sales_Deal__r.Discount_Display_Name__c,Discount_Value_Amount__c, Discount_Value_Percentage__c,CurrencyIsoCode FROM Deal_Discounts__r  ) '+
            ' FROM Sales_Deal__c where Active__c=true and  Start_Date__c <= today and End_Date__c >= today and ';
        query +='(';
        //To add country deals condition in query
        if((!setOfApplicableListIdList.isEmpty() &&  setOfApplicableListIdList!=null) || (!setOfEiflIdList.isEmpty() && setOfEiflIdList!=null))
        {
            System.debug('@In setOfApplicableListIdList'+setOfApplicableListIdList+' @In setOfEiflIdList'+setOfEiflIdList);
            //query += ' (Country_Applicable_List__c=\'Sanctioned Country\' or recordtype.name=\'Country Deal\') or ';
            query += ' ((Country_Applicable_List__c=\'Sanctioned Country\' or recordtype.name=\'Country Deal\') and (EIFL_Type__c in '+ setOfEiflIdList +' or Country_Applicable_List__c in  '+setOfApplicableListIdList+')) or ';
        }
        
        //To add promocode deals condition in query
        if(!setparentProductList.isEmpty() && !setPromoCodeList.isEmpty()){
            System.debug('@In setparentProduct '+setparentProduct+' and In setPromoCodeList '+setPromoCodeList);
            query += '(Product__r.Hub_Id__c in '+ setparentProductList +' and Promocode__c in '+ setPromoCodeList +' ) or ';
        }
         
        //To add consortium, institution and department sales deals  condition in query
        if(!mapOfSalesdealIdToCustomerId.isEmpty())
        {
            System.debug('@In Institution Or Consortitum mapOfSalesdealIdToCustomerId'+mapOfSalesdealIdToCustomerId);
            query +=' Id IN '+ mapOfSalesdealIdToCustomerIdList;
            /*String str='or Id IN  '+mapOfSalesdealIdToCustomerIdList;  
            system.debug('str '+str);
            if(str.contains('...'))
            query +='or Id IN  :mapOfSalesdealIdToCustomerIdList';     
            else
            query += str; */
        }
        query = query.removeEnd(' or ');
        query +=')';
        query = query.removeEnd(' and ()');
        
        system.debug('@==============query============='+query);
        Sales_Deal__c[] listSalesDeal = Database.query(query);
        system.debug('@listSalesDeal '+listSalesDeal.size()+' '+listSalesDeal);
        
        for(Sales_Deal__c salesDeal :listSalesDeal){
            if(salesDeal.Product_Open_Access_Category__c==null && 
               salesDeal.Product_Inclusion__c==null && salesDeal.Product_exclusion__c==null){
                   //Do Nothing
               }else{
                   if(!recTypeIdToSalesDealListMap.containsKey(salesDeal.RecordTypeId)){
                       recTypeIdToSalesDealListMap.put(salesDeal.RecordTypeId,new List<Sales_Deal__c>());
                   }
                   recTypeIdToSalesDealListMap.get(salesDeal.RecordTypeId).add(salesDeal);
               }
        }
        return recTypeIdToSalesDealListMap;   
    }
    /* BULKIFICATION CHANGES END */
    //Shalini: End changes for SFSD- 1202
}