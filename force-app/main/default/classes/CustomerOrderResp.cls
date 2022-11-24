public class CustomerOrderResp{
    @AuraEnabled
    public metadata metadata{get;set;}
    
    @AuraEnabled
    public paginatedOrderResult paginatedOrderResult{get;set;}
    
    public class payment{
        @AuraEnabled public String paymentTerm{get;set;}
        @AuraEnabled public String paymentUrl{get;set;}
        @AuraEnabled public String paymentDueDate{get;set;}
        @AuraEnabled public String paymentDescription{get;set;}
        @AuraEnabled public String paymentMethod{get;set;}
        @AuraEnabled public Integer paymentId{get;set;}
    }
    public class paginatedOrderResult{
        @AuraEnabled public list<data> data{get;set;}
    }
    public class orderedItem{
        @AuraEnabled public Integer orderedQuantity{get;set;}
        @AuraEnabled public Decimal sellingPrice{get;set;}
        @AuraEnabled public Decimal price{get;set;}
        @AuraEnabled public String currencyy{get;set;}
        @AuraEnabled public String productId{get;set;}
        @AuraEnabled public String sellingCurrency{get;set;}
        @AuraEnabled public String id{get;set;}
        @AuraEnabled public Integer quantity{get;set;}
        @AuraEnabled public fulfillment fulfillment{get;set;}
        @AuraEnabled public String lineItemType{get;set;}
        @AuraEnabled public String discountCurrency{get;set;}
        @AuraEnabled public Decimal discountAmount{get;set;}
        @AuraEnabled public String discountCode{get;set;}
        @AuraEnabled public String taxCode{get;set;} 
        @AuraEnabled public Decimal discount{get;set;}
        @AuraEnabled public Decimal taxAmount{get;set;}
        @AuraEnabled public String description{get;set;}
    }
    public class metadata{
        @AuraEnabled public Integer code{get;set;}
        @AuraEnabled public Integer totalPagesize{get;set;}
        @AuraEnabled public String message{get;set;}
    }
    public class invoice{
        @AuraEnabled public String currencyy{get;set;}
        @AuraEnabled public String broker{get;set;}
        @AuraEnabled public Decimal freightCharge{get;set;}
        @AuraEnabled public String externalInvoiceRef{get;set;}
        @AuraEnabled public Decimal freightTax{get;set;}
        @AuraEnabled public String id{get;set;}
    }
    public class fulfillment{
        @AuraEnabled public list<String> grantType{get;set;}
        @AuraEnabled public String termStartDate{get;set;}
        @AuraEnabled public String termEndDate{get;set;}
        @AuraEnabled public String licenseType{get;set;}
        @AuraEnabled public String bundle{get;set;}
        @AuraEnabled public String description{get;set;}
        @AuraEnabled public String printOnDemand{get;set;}
        @AuraEnabled public String name{get;set;}
        @AuraEnabled public String catalogueNumber{get;set;}
        @AuraEnabled public String id{get;set;}
    }
    public class data{
        @AuraEnabled public String seller{get;set;}
        @AuraEnabled public String discountAmount{get;set;}
        @AuraEnabled public String discountCurrency{get;set;}
        @AuraEnabled public String orderDate{get;set;}
        @AuraEnabled public String discountCode{get;set;}
        @AuraEnabled public Decimal orderPrice{get;set;}
        @AuraEnabled public Decimal discount{get;set;}
        @AuraEnabled public String orderStatus{get;set;}
        @AuraEnabled public String productId{get;set;}
        @AuraEnabled public invoice invoice{get;set;}
        @AuraEnabled public String buyerId{get;set;}
        @AuraEnabled public billingAddress billingAddress{get;set;}
        @AuraEnabled public String customerId{get;set;}
        @AuraEnabled public list<orderedItem> orderedItem{get;set;}
        @AuraEnabled public Decimal confirmationNumber{get;set;}
        @AuraEnabled public String description{get;set;}
        @AuraEnabled public String orderNumber{get;set;}
        @AuraEnabled public String docDate{get;set;}
        @AuraEnabled public String quoteNumber{get;set;}
        @AuraEnabled public Decimal release{get;set;}
        @AuraEnabled public String notes{get;set;}
        @AuraEnabled public String webId{get;set;}
        @AuraEnabled public String opportunityId{get;set;}
        @AuraEnabled public String shipCustId{get;set;}
        @AuraEnabled public String externalOrderRef{get;set;}
        @AuraEnabled public String orderSource{get;set;}
        @AuraEnabled public String channel{get;set;}
        @AuraEnabled public Decimal rateOfExchange{get;set;}
        @AuraEnabled public String orderType{get;set;}
        @AuraEnabled public payment payment{get;set;}
        @AuraEnabled public String id{get;set;}
    }
    public class billingAddress{
        @AuraEnabled public String telephoneNo{get;set;}
        @AuraEnabled public String addressRegion{get;set;}
        @AuraEnabled public String addressContactName{get;set;}
        @AuraEnabled public String addressLocality{get;set;}
        @AuraEnabled public String addressContactEmail{get;set;}
        @AuraEnabled public String addressCountry{get;set;}
        @AuraEnabled public String addressOrganisation{get;set;}
        @AuraEnabled public String addressLine3{get;set;}
        @AuraEnabled public String postalCode{get;set;}
        @AuraEnabled public String addressLine2{get;set;}
        @AuraEnabled public String streetAddress{get;set;}
        @AuraEnabled public String addressLine1{get;set;}
        @AuraEnabled public String businessPartnerNo{get;set;}
        @AuraEnabled public Integer addressId{get;set;}
        @AuraEnabled public String countryCode{get;set;}
        @AuraEnabled public String id{get;set;}
    }
}