public with sharing class OppTrialEmailController {

	private ApexPages.StandardController controller {get; set;}
	private final Opportunity opp;

	public String errorMessage {get; set;}
	public Boolean showErrorMessage {get; set;}
	public Boolean showSendButton {get; set;}

	public OppTrialEmailController(ApexPages.StandardController controller) {
		this.controller = controller;
		this.opp = (Opportunity)controller.getRecord();
		if (opp.Date_Sent__c == null)
			showSendButton = true;
	}
	
	public Pagereference sendTrialEmail() {
		if (opp.Trial_Start__c == null || Date.today().daysBetween(opp.Trial_Start__c) < 7
		|| opp.Fees_Amount_GBP__c == null || opp.Fees_Amount_GBP__c == 0) {
			errorMessage = 'You must have a fees product, primary contact and a start date not within the next 7 days.';
			showErrorMessage = true;
		} else {
			List<OpportunityContactRole> ocrs = [SELECT Id FROM OpportunityContactRole WHERE OpportunityId = :opp.Id AND IsPrimary = true];
			if (ocrs.size() == 0) {
				errorMessage = 'You must have a fees product, primary contact and a start date not within the next 7 days.';
				showErrorMessage = true;
			} else {
				opp.Date_Sent__c = system.now();
				update opp; //workflow will send the email
				showSendButton = false;
			}
		}
		return null;
	}

}