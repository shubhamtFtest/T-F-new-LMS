global class DiscountRequest {
    public String typeOfRequest; // APC, eBook, etc
    public String productID;
    public String parentProduct;
    public String customerID;
    public String BillingCountryCode;
    public String billingCountry;
    public String aPCPriceCategory;
    public String openAccessCategory;
    public String promoCode;
    public String CurrencyIsoCode;
    public String productCode;
    public String startDate;
    public String endDate;
    public String EIFLType;
    public boolean applycountryDiscount;
    public String quoteId;
    public String quoteLineId;
    public Decimal discountReceived;
    public Decimal discountAmountReceived;
    public List<Discount> discountList;
    public String SalesDeal;
    public String totalDiscountAmount;
    
    //New changes
    public Country__c country;
    public List<Sales_Deal__c> salesDealList;
    public PromoCode__c promoCodeRec;
    public SBQQ__QuoteLine__c quoteLine;
    public Decimal quoteLineListPrice;
    public Sales_Deal__c appliedSalesDeal;
    public boolean applyPrePayDiscount;
    public String CountryApplicableList;
    public boolean isEligibleForDiscount; //Added by Faiz as part of ticket no - https://taylorfrancis.atlassian.net/browse/SFSD-1205
	public String ringoldId;//Added by Shalini as part of ticket no - SFSD-1202
	public Decimal partnerDiscount;//Added by Shalini as part of partner dicount logic 
    
}