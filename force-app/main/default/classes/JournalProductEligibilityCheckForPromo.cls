/*Created By: Piyush Jain
 *Description: Used in FSD discounting flow as part of FSD Project
 *Test Class: ztest_ProductDiscountService
**/
public class JournalProductEligibilityCheckForPromo extends AbstractProductEligibilityCheck {
	
    //Updated by Shalini as part of SFSD-1209
    public Boolean isProductEligibleForDiscount(Sales_Deal__c salesDeal, DiscountRequest request) {
        System.debug('******* Checking for requested Product is eligigble for Promocode Discount *******');
        System.debug(request);
        System.debug(salesDeal);
        
        Boolean isEligible = false;
        
        if(String.isNotEmpty(request.promoCode) && String.isNotBlank(request.parentProduct) && request.parentProduct!='0' && String.isNotBlank(salesDeal.Product__r.Hub_Id__c) && String.isNotBlank(salesDeal.Promocode__c)){
            if(salesDeal.Product__r.Hub_Id__c.equalsIgnoreCase(request.parentProduct) && salesDeal.Promocode__c.equalsIgnoreCase(request.promocode)) {
                System.debug('Product eligibility Check result : true');
                isEligible = true; 
            } 
        }
        return isEligible;   
        
    } 
}