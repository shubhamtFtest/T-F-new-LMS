/*Created By: Piyush Jain
 *Description: Used in FSD discounting flow as part of FSD Project
 *Test Class: ztest_ProductDiscountService
**/
public class JournalProductEligibilityCheckForAPC extends AbstractProductEligibilityCheck {
   
    //Updated method by Faiz as part of story 1205
    public Boolean isProductEligibleForDiscount(Sales_Deal__c salesDeal, DiscountRequest request) {
        System.debug('******* Checking for requested Product is eligigble for APC Discount *******');
        system.debug('@request.parentProduct '+request.parentProduct);
        if(String.isNotBlank(request.parentProduct) && request.parentProduct!='0')//Checking hub id
        { 
            init(salesDeal,request); 
            Boolean isEligibleForDiscount = false;
            Boolean isOpenAccessConditionMet = false;
            Boolean isPriceConditionMet = false;
            Boolean allOpenAccessCategory = false;
            system.debug('productInclussionSet '+productInclussionSet);
            system.debug('productExclussionSet '+productExclussionSet);
            system.debug('request.productID(ProductCode) '+request.productID);
            
            if(salesDeal.Product_Open_Access_Category__c == 'All') {
                isOpenAccessConditionMet = true;
                allOpenAccessCategory = true;
            } else {
                system.debug('salesDeal.Product_Open_Access_Category__c '+salesDeal.Product_Open_Access_Category__c);
                system.debug('request.openAccessCategory '+request.openAccessCategory);
                
                if(String.isNotBlank(salesDeal.Product_Open_Access_Category__c) && String.isNotBlank(request.openAccessCategory))
                isOpenAccessConditionMet = (salesDeal.Product_Open_Access_Category__c.equalsIgnoreCase(request.openAccessCategory));//need to apply null check
            	system.debug('isOpenAccessConditionMet '+isOpenAccessConditionMet);
            }
            //If Open Access Cathegory is All and Product is not excluded
            if(allOpenAccessCategory && !productExclussionSet.contains(request.productID)){
                return true;
            }
            //If Open Access Cathegory is Not All and Product is not included
            if(productInclussionSet.contains(request.productID)) {
                System.debug('Product eligibility Check result : true');
                return true;
            }
            return isEligibleForDiscount = (isOpenAccessConditionMet) && !productExclussionSet.contains(request.productID);
       
        }
        return false;
        
    }
}