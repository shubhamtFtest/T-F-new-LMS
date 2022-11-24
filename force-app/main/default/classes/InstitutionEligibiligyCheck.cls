/*Created By: Piyush Jain
 *Description: Used in FSD discounting flow as part of FSD Project
 *Test Class: ztest_ProductDiscountService
**/
public class InstitutionEligibiligyCheck extends AbstractAccountEligibilityCheck {
	
    //Updated by Shalini as part of, SFSD-1207
    public Boolean isAccountEligibleForDiscountBulk(List<Deal_Member__c> dealmemberListCommon,List<Deal_Member__c> dealmemberList,Sales_Deal__c salesDeal, DiscountRequest request){
        System.debug('******* Checking for requested Account is eligigble for Institution Discount *******'+salesDeal);
        System.debug('Request ---> ' + request.customerID);
        List<String> customerIdList=new List<String>(); 
        
        if(dealmemberList.size()>0){
            for(Deal_Member__c dealmemberObj:dealmemberList){
                if(String.isNotBlank(dealmemberObj.Account__r.Customer_Id__c))
                    customerIdList.add(dealmemberObj.Account__r.Customer_Id__c);
                else if(String.isNotBlank(dealmemberObj.Account__r.Ringgold_Account_ID__c))//Added this condition to support ringGoldId concept
                    customerIdList.add(dealmemberObj.Account__r.Ringgold_Account_ID__c);
            }
        }
        System.debug('CustomerIdList '+customerIdList);
        if(customerIdList.size()>0){
            /*if(customerIdList.contains(request.customerID) && request.applyPrePayDiscount == salesDeal.isPrepay__c){
                return true;
            }*/ 
            if((customerIdList.contains(request.customerID) || customerIdList.contains(request.ringoldId)) && 
               request.applyPrePayDiscount == salesDeal.isPrepay__c){
                return true;
            }
        }
        return false;
    }
}