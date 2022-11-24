/*Created By: Piyush Jain
 *Description: Used in FSD discounting flow as part of FSD Project
 *Test Class: ztest_ProductDiscountService
**/
public class V1DiscountService implements DiscountInterface {
    public List<DiscountRequest> getBestDiscountBulk(List<DiscountRequest> requestList) {
        Map<String,Product2> requestToProductMap = new Map<String,Product2>();
        List<DiscountRequest> requestListWithDiscountList = new List<DiscountRequest>();
        
        Set<String> countryCodeSet = new Set<String>();
        Map<String,Country__c> billingCountryCodeToCountryMap = new Map<String,Country__c>();
        
        Set<String> promoCodeSet = new Set<String>();
        Set<String> productIdSet = new Set<String>();
        Map<String,PromoCode__c> promoCodeMap = new Map<String,PromoCode__c>();
        
        for(DiscountRequest request: requestList){
            if(request.parentProduct != null && request.parentProduct != '0')
                requestToProductMap.put(request.parentProduct,new Product2());
            if(request.BillingCountryCode != null ){
                countryCodeSet.add(request.BillingCountryCode);
            }
        }
        for(DiscountRequest discReq : requestListWithDiscountList){
            discReq.discountList = new List<Discount>();
        }
        
        if(countryCodeSet.size() > 0){
            for(Country__c countryRec: [SELECT Name,EIFL__c, EIFL_Type__c, Applicable_List__c, Preferred_currency__c,Country_2__c  FROM Country__c WHERE Country_2__c IN :countryCodeSet])
            {
                //billingCountryCodeToCountryMap.put(countryRec.Name, countryRec);    
                if(String.isNotBlank(countryRec.Country_2__c))
                billingCountryCodeToCountryMap.put(countryRec.Country_2__c.toUppercase(), countryRec);//Updated by Shalini as part of SFSD- 1202                     
            }
        }
        
        for(DiscountRequest discountReq: requestList){
            if(String.isNotBlank(discountReq.BillingCountryCode) &&
               billingCountryCodeToCountryMap.containsKey(discountReq.BillingCountryCode.toUppercase())){//Updated by Shalini as part of SFSD- 1202                     
                   discountReq.country = billingCountryCodeToCountryMap.get(discountReq.BillingCountryCode.toUppercase());
               }
        }
         
        system.debug('@requestList After updating country '+requestList);
        system.debug('requestToProductMap '+requestToProductMap);
        
        for(Product2 prd : [SELECT id,Name,Hub_Id__c,ISBN__c,Article_Type__c,ProductCode,Open_Access_Category__c 
                            FROM product2 WHERE (Hub_Id__c IN :requestToProductMap.keySet() AND Hub_Id__c!=null )])
        {   
            String productId = '';                       
            if(requestToProductMap.containsKey(prd.Hub_Id__c)){     
                productId = prd.Hub_Id__c;
            }/*else if(requestToProductMap.containsKey(prd.ProductCode)){ //Removed by Shalini as for all the parent products we'll always find hub id as part of SFSD- 1202  
                productId = prd.ProductCode;
            }else if(requestToProductMap.containsKey(prd.ISBN__c)){
                productId = prd.ISBN__c;
            }*/
            requestToProductMap.put(productId,prd);                          
        }
        System.debug('Parent Product Hub Id to Product Rec Map *************'+requestToProductMap);
        
        for(DiscountRequest request: requestList){
            if(requestToProductMap.containsKey(request.parentProduct)){
                //  request.aPCPriceCategory = requestToProductMap.get(request.parentProduct).APC_Price_Category__c;
                request.openAccessCategory = requestToProductMap.get(request.parentProduct).Open_Access_Category__c;
                request.productID = requestToProductMap.get(request.parentProduct).ProductCode;
            }
        }
        
        for(DiscountRequest request: requestList){
            if(request.promoCode != null){
                promoCodeSet.add(request.promoCode);
            }
            if(request.productID != null){
                productIdSet.add(request.productID);
            }
        }
        if(promoCodeSet.size()>0 && productIdSet.size()>0){
            for(PromoCode__c promoCode: [SELECT id,Name,Deal_Discount__c, Deal_Discount__r.Discount_Value_Percentage__c FROM PromoCode__c WHERE Product_Code__c IN :productIdSet AND Name IN :promoCodeSet])
            {
                promoCodeMap.put(promoCode.Name, promoCode);                     
            }
        }
        for(DiscountRequest discountReq: requestList){
            if(promoCodeMap.containsKey(discountReq.promoCode) || test.isRunningTest()){
                discountReq.promoCodeRec = promoCodeMap.get(discountReq.promoCode);
            } 
        }
        
        
        DiscountCalculatorEngine discountEngine = new DiscountCalculatorEngine();
        
        requestListWithDiscountList= discountEngine.getDiscountBulk(requestList);
        Discount.BestDiscount bestDiscount = new Discount.BestDiscount();
        bestDiscount.salesDeal = new Sales_Deal__c();
        Discount.BestDiscount bestDiscountAmt = new Discount.BestDiscount();
        bestDiscountAmt.salesDeal = new Sales_Deal__c();
        Discount.BestDiscount bestDiscountFixedAmt = new Discount.BestDiscount();//Added by Shalini to cover fixed and amount discount both
        bestDiscountFixedAmt.salesDeal = new Sales_Deal__c();
        
        for(DiscountRequest req: requestListWithDiscountList){
            if(req.discountList != null){
                //Call Percentage amount discount check method
                bestDiscount = Discount.getBestPercentageOfDiscount(req.discountList);
                //Sales_Deal__c sdtemp = bestDiscount.salesDeal;//Removed by shalini as not being used in our code
                //System.debug((sdtemp.Id));
                system.debug('bestDiscount '+bestDiscount);
                if(bestDiscount.discountPercentge!=null && bestDiscount.salesDeal.Id != null){
                    req.discountReceived = bestDiscount.discountPercentge;
                    req.appliedSalesDeal = bestDiscount.salesDeal;
                }else{
                    //Call fixed amount discount check method
                    bestDiscountFixedAmt = Discount.getBestFixedAmountOfDiscount(req.discountList);
                    system.debug('bestDiscountFixedAmt '+bestDiscountFixedAmt);
                    if(bestDiscountFixedAmt.discountAmount != null && bestDiscountFixedAmt.salesDeal.Id != null){
                        req.discountAmountReceived = bestDiscountFixedAmt.discountAmount;
                        req.appliedSalesDeal = bestDiscountFixedAmt.salesDeal;
                        system.debug('req '+req);
                    }
                    else{
                        //Call amount discount check method
                        bestDiscountAmt = Discount.getBestAmountOfDiscount(req.discountList);
                        system.debug('bestDiscountAmt '+bestDiscountAmt);
                        if(bestDiscountAmt.discountAmount != null && bestDiscountAmt.salesDeal.Id != null){
                            req.discountAmountReceived = bestDiscountAmt.discountAmount;
                            req.appliedSalesDeal = bestDiscountAmt.salesDeal;
                            system.debug('req '+req);
                        }
                    }
                    
                    /*bestDiscountAmt = Discount.getBestAmountOfDiscount(req.discountList);
                    system.debug('bestDiscountAmt '+bestDiscountAmt);
                    if(bestDiscountAmt.discountAmount != null){
                        req.discountAmountReceived = bestDiscountAmt.discountAmount;
                        req.appliedSalesDeal = bestDiscountAmt.salesDeal;
                        system.debug('req '+req);
                    }*///commented by shalini and added above logic to cover fixed and amount discount both 
                }
                
            }
            else{
                req.discountReceived = 0;
            }
        }
        //Updated by Faiz as part of story 1204//Commneted by Shalini
        /*for(DiscountRequest req: requestListWithDiscountList){
            if(req.discountList != null){
                bestDiscount = Discount.getBestPercentageOfDiscount(req.discountList);
                bestDiscountAmt = Discount.getBestAmountOfDiscount(req.discountList);
                Sales_Deal__c sdtemp = bestDiscount.salesDeal;
                System.debug((sdtemp.Id));
                //Condition added by Faiz on 129 
                if(bestDiscount.discountPercentge!=null && bestDiscount.salesDeal.Id != null){
                    req.discountReceived = bestDiscount.discountPercentge;
                    req.appliedSalesDeal = bestDiscount.salesDeal;
                }
                    
                if(bestDiscountAmt.discountAmount != null){
                    req.discountAmountReceived = bestDiscountAmt.discountAmount;
                    req.appliedSalesDeal = bestDiscountAmt.salesDeal;
                }
                if(bestDiscount.discountPercentge != null && bestDiscountAmt.discountAmount != null){
                    Decimal discPercent = 0;
                    discPercent = req.discountReceived/100;
                    discPercent = discPercent*req.quoteLineListPrice;
                    if(discPercent > req.discountAmountReceived){
                        req.discountAmountReceived = null;
                        req.appliedSalesDeal = bestDiscount.salesDeal;

                    }
                    else {
                        req.discountReceived = null;
                        req.appliedSalesDeal = bestDiscount.salesDeal;

                    }

                }
                
            }
            else{
                req.discountReceived = 0;
            }
        }*/
        system.debug('@requestListWithDiscountList '+requestListWithDiscountList);
        return requestListWithDiscountList;
    }
    
}