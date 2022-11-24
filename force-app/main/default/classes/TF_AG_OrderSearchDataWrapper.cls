public class TF_AG_OrderSearchDataWrapper {
    
    @AuraEnabled  public List<Data> data;
    @AuraEnabled   public Integer page;
    @AuraEnabled  public Integer totalPages;
    @AuraEnabled  public Integer pageSize;
    
    public class Data {
        @AuraEnabled     public String accountId;
        @AuraEnabled    public String orderId;
        @AuraEnabled    public String orderValue;
        @AuraEnabled    public String orderStatus;
        @AuraEnabled    public String poNumber;
        @AuraEnabled    public String orderDate;
        @AuraEnabled    public String type;
        @AuraEnabled    public String trackingNumbers;
        @AuraEnabled    public String shipVia;
        @AuraEnabled     public String shippingAndHandling;
        @AuraEnabled    public String sundry;
        @AuraEnabled     public String prePaid;
    }
    
}