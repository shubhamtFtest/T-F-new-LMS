public class OpportunityLineItemWrapper {
    @AuraEnabled
    public String Id;
    @AuraEnabled
    public Boolean isActive;
    @AuraEnabled
    public String productName;
    @AuraEnabled
    public String globalISBN;
    @AuraEnabled
    public String indiaISBN;    
    @AuraEnabled
    public String type;
    @AuraEnabled
    public String productType;    
    @AuraEnabled
    public String requiredBinding;
    @AuraEnabled
    public Decimal unitPrice;
    @AuraEnabled
    public Decimal quantity;
    @AuraEnabled
    public Decimal listPrice;
    @AuraEnabled
    public Decimal customerRate;    
    @AuraEnabled
    public Decimal mrp;
    @AuraEnabled
    public Decimal gm;    
    @AuraEnabled
    public Decimal UMC;
    @AuraEnabled
    public Date dateofLastUMC;
    @AuraEnabled
    public Decimal discount;
    @AuraEnabled
    public Decimal totalPrice;
    @AuraEnabled
    public String reprintEligibility;
    @AuraEnabled
    public String status;
    @AuraEnabled
    public String distributor;
    @AuraEnabled
    public Boolean isSalesUser;
    @AuraEnabled
	public Boolean isApproved;
    @AuraEnabled
	public String showClass;
    public OpportunityLineItemWrapper() {
        
    }    
}