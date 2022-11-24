/*Created By: Piyush Jain
 *Description: Used in FSD discounting flow as part of FSD Project
 *Test Class: ztest_ProductDiscountService
**/
public abstract class AbstractProductEligibilityCheck implements ProductEligibilityCheck {
    protected Set<String> productExclussionSet = new Set<String>();
    protected Set<String> productInclussionSet = new Set<String>();

    protected void init(Sales_Deal__c salesDeal, DiscountRequest request) {
        System.debug('AbstractProductEligibilityCheck Request ---> ' + request.customerID); 
        String productInclussion = salesDeal.Product_Inclusion__c;
        String productExclussion = salesDeal.Product_exclusion__c;          
		if(!String.isEmpty(productInclussion)) {
        	List<String> productInclussionList = productInclussion.split(',');
            productInclussionSet.addAll(productInclussionList);
        }
        if(!String.isEmpty(productExclussion)) {
            List<String> productExclussionList = productExclussion.split(',');
            productExclussionSet.addAll(productExclussionList);
        }        
    }
}