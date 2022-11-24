/*Created By: Piyush Jain
 *Description: Used in FSD discounting flow as part of FSD Project
 *Test Class: ztest_ProductDiscountService
**/
public class PromoCodeInstitutionEligibiligyCheck extends AbstractAccountEligibilityCheck {
	
    //Updated by Shalini as part of SFSD- 1209
    public Boolean isAccountEligibleForDiscountBulk(List<Deal_Member__c> dealmemberListCommon,List<Deal_Member__c> dealmemberList,Sales_Deal__c salesDeal, DiscountRequest request){
        system.debug('@salesDeal.Promocode__c '+salesDeal.Promocode__c);
        system.debug('@salesDeal.Product__r.Hub_Id__c '+salesDeal.Product__r.Hub_Id__c);
        
        Boolean isEligible = false;
        if(String.isNotBlank(request.promoCode) && String.isNotBlank(salesDeal.Promocode__c) && String.isNotBlank(request.parentProduct) && request.parentProduct !='0' && String.isNotBlank(salesDeal.Product__r.Hub_Id__c)) {
            isEligible = (salesDeal.Promocode__c == request.promoCode && salesDeal.Product__r.Hub_Id__c == request.parentProduct ) ;
        }
        System.debug('Promocode Account eligibility Check result ' + isEligible);
        return isEligible;
    }
}