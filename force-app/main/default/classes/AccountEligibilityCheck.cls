global interface AccountEligibilityCheck {
	Boolean isAccountEligibleForDiscountBulk(List<Deal_Member__c> dealmemberListCommon,List<Deal_Member__c> dealmemberList,Sales_Deal__c salesDeal, DiscountRequest request);

}