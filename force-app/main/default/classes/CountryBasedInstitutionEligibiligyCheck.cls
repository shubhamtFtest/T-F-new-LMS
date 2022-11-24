/*Created By: Piyush Jain
 *Description: Used in FSD discounting flow as part of FSD Project
 *Test Class: ztest_ProductDiscountService
**/
public class CountryBasedInstitutionEligibiligyCheck extends AbstractAccountEligibilityCheck {
    
    public Boolean isAccountEligibleForDiscountBulk(List<Deal_Member__c> childDealMemberList, List<Deal_Member__c> parentDealMemberList, Sales_Deal__c salesDeal, DiscountRequest request){
        System.debug('******* Checking for requested Account is eligigble for Country Discount *******');
        System.debug('@request.applycountryDiscount ' + request.applycountryDiscount); 
        System.debug('@request.BillingCountryCode ' + request.BillingCountryCode);
        System.debug('@request.country.EIFL_Type__c '+request.country.EIFL_Type__c);
        System.debug('@salesDeal.EIFL_Type__c ' + salesDeal.EIFL_Type__c);
        System.debug('@salesDeal.Country_Applicable_List__c ' + salesDeal.Country_Applicable_List__c);
        Boolean isEligible = false;
        
        if(request.country != null) {
            
            isEligible = ((request.applycountryDiscount==true || (String.isNotBlank(request.country.Applicable_List__c) && request.country.Applicable_List__c=='Sanctioned Country'))
                          && ((String.isNotBlank(request.country.EIFL_Type__c) && request.country.EIFL_Type__c == salesDeal.EIFL_Type__c) || request.country.Applicable_List__c == salesDeal.Country_Applicable_List__c)); 
            system.debug('@isEligible '+isEligible);
        }
        
        return isEligible;
    }
}