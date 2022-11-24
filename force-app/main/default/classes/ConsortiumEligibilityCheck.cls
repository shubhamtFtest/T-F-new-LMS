/*Created By: Piyush Jain
 *Description: Used in FSD discounting flow as part of FSD Project
 *Test Class: ztest_ProductDiscountService
**/
public class ConsortiumEligibilityCheck extends AbstractAccountEligibilityCheck {
    
    //Update by Shalini as part of SFSD- 1206                    
    public Boolean isAccountEligibleForDiscountBulk(List<Deal_Member__c> childDealMemberList, List<Deal_Member__c> parentDealMemberList, Sales_Deal__c salesDeal, DiscountRequest request) {
        System.debug('******* Checking for requested Account is eligigble for Consortium Discount *******');
        System.debug('@salesDeal '+salesDeal);
        System.debug('@request '+request);
       
        if(parentDealMemberList.size()>0)
            init(salesDeal,request,parentDealMemberList); 
        
        if(childDealMemberList.size()>0)
            init(salesDeal,request,childDealMemberList); 
        
        System.debug('@accountInclusionSet==> '+accountInclusionSet);//Setting Account party Id or ringGoldId
        //Check in Account Inclussion list
        /*if(String.isNotBlank(request.customerID) && accountInclusionSet.contains(request.customerID) && 
          request.applyPrePayDiscount == salesDeal.isPrepay__c){
            System.debug('Account eligibility Check result : true');
            return true; 
        }*/
        if((String.isNotBlank(request.customerID) && accountInclusionSet.contains(request.customerID) ||
            String.isNotBlank(request.ringoldId) && accountInclusionSet.contains(request.ringoldId)) && 
           request.applyPrePayDiscount == salesDeal.isPrepay__c){
               System.debug('Account eligibility Check result : true');
               return true; 
           }
        return false;
        
        
        /*System.debug('******* Checking for requested Account is eligigble for Consortium Discount *******');
        List<TandF_Account_to_Consortium__c> consortiumParentList = new List<TandF_Account_to_Consortium__c>();
        
        system.debug('@childDealMemberList '+childDealMemberList);
        system.debug('@parentDealMemberList '+parentDealMemberList);
        
        if(parentDealMemberList.size()>0 ){
            for(Deal_Member__c dealmemberObj:parentDealMemberList){
                if(salesDealAccountToConMemMap.containsKey(dealmemberObj.Account__c)){
                    if(!salesDealAccountToConMemMap.get(dealmemberObj.Account__c).isEmpty()){
                        consortiumParentList.addAll(salesDealAccountToConMemMap.get(dealmemberObj.Account__c));
                    }
                }
            }
            system.debug('@consortiumParentList '+consortiumParentList.size()+' '+consortiumParentList);
        }
        init(salesDeal,request,parentDealMemberList); //for account inclusion and exclusion set //Clear both set
        System.debug('@salesDeal '+salesDeal);
        System.debug('@request '+request);
        Set<String> consortiumMembersChild = new Set<String>();
        System.debug('@accountInclusionSet '+accountInclusionSet);//Setting parent Account party Id
        
        //Check in Account Inclussion list
        System.debug(accountInclusionSet.contains(request.customerID));
        if(String.isNotBlank(request.customerID) && accountInclusionSet.contains(request.customerID) && 
          request.applyPrePayDiscount == salesDeal.isPrepay__c){
            System.debug('Account eligibility Check result : true(Parent Case)');
            return true; 
        }
        
        if(consortiumParentList != null)
            for(TandF_Account_to_Consortium__c memeber : consortiumParentList) {
                consortiumMembersChild.add(memeber.Consortium_Member_Party_ID__c);//Setting party id of consortium child members
            }
        //consortiumMembersChild.removeAll(accountExclussionSet);
        System.debug('@Consortium Members Child'+consortiumMembersChild);
        
        //Checking if request.customerID(party id) present in consortium child members or not
        if(String.isNotBlank(request.customerID) && request.applyPrePayDiscount == salesDeal.isPrepay__c){
            System.debug('Account eligibility Check result(Child Case) : ' + consortiumMembersChild.contains(request.customerID));
            return consortiumMembersChild.contains(request.customerID); 
        }
        return false;*/
    }
}