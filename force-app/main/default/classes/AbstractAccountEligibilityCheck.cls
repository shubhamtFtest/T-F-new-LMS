/*Created By: Piyush Jain
 *Description: Used in FSD discounting flow as part of FSD Project
 *Test Class: ztest_ProductDiscountService
**/
public abstract class AbstractAccountEligibilityCheck implements AccountEligibilityCheck {
    protected Set<String> accountInclusionSet = new Set<String>();
    
    protected void init(Sales_Deal__c salesDeal, DiscountRequest request,List<Deal_Member__c> dealmemberListCommon) {
        System.debug('@AbstractAccountEligibilityCheck ' +salesDeal);
        System.debug('Request.customerID ---> ' + request.customerID);
    
        if(dealmemberListCommon.size()>0){
            for(Deal_Member__c dealmemberObj:dealmemberListCommon){
                if(String.isNotBlank(dealmemberObj.Account__r.Customer_Id__c))
                    accountInclusionSet.add(dealmemberObj.Account__r.Customer_Id__c);
                else if(String.isNotBlank(dealmemberObj.Account__r.Ringgold_Account_ID__c))//added this condition to support ringGoldId concept
                    accountInclusionSet.add(dealmemberObj.Account__r.Ringgold_Account_ID__c);
            }
        }
    }
    
}