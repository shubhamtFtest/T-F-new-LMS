/** Created By: Piyush Jain 
    Test Class: OrderHubCustomerDetailCancelCntrl_Test
**/
public class orderCancelJSONResp {
    
    @AuraEnabled public metadata metadata {get; set;}
    @AuraEnabled public order order {get; set;}
    
    public class metadata {
        @AuraEnabled public Integer code {get; set;}
        @AuraEnabled public String message {get; set;}
        @AuraEnabled public Integer totalPagesize {get; set;}
        @AuraEnabled public String addresMappg {get; set;}
    }
    
    public class order{
        @AuraEnabled public billingAddress billingAddress {get; set;}
        @AuraEnabled public Decimal orderPrice {get; set;}
        @AuraEnabled public String orderDate {get; set;}
        @AuraEnabled public String orderStatus {get; set;}
        @AuraEnabled public Decimal discountAmount {get; set;}
        @AuraEnabled public list<invoices> invoices {get; set;}
        @AuraEnabled public String discountCurrency {get; set;}
        @AuraEnabled public String seller {get; set;}
        @AuraEnabled public String discountCode {get; set;}
        @AuraEnabled public shippingAddress shippingAddress {get; set;}
        @AuraEnabled public Decimal discount {get; set;}
        @AuraEnabled public list<fulfillments> fulfillments {get; set;}
        @AuraEnabled public String buyerId {get; set;}
        @AuraEnabled public list<orderedItem> orderedItem {get; set;}
        @AuraEnabled public String customerId {get; set;}
        @AuraEnabled public String description {get; set;}
        @AuraEnabled public Decimal confirmationNumber {get; set;}
        @AuraEnabled public String docDate {get; set;}
        @AuraEnabled public String orderNumber {get; set;}
        @AuraEnabled public Decimal release {get; set;}
        @AuraEnabled public String quoteNumber {get; set;}
        @AuraEnabled public String webId {get; set;}
        @AuraEnabled public String notes {get; set;}
        @AuraEnabled public String shipCustId {get; set;}
        @AuraEnabled public String opportunityId {get; set;}
        @AuraEnabled public String orderSource {get; set;}
        @AuraEnabled public String externalOrderRef {get; set;}
        //@AuraEnabled public Decimal rateOfExchange {get; set;}
        @AuraEnabled public String channel {get; set;}
        //@AuraEnabled public Decimal subTotalPrice {get; set;}
        @AuraEnabled public String orderType {get; set;}
        //@AuraEnabled public Decimal totalTax {get; set;}
        @AuraEnabled public String id {get; set;}
    }
    
    public class shippingAddress {
        @AuraEnabled public String addressCountry {get; set;}
        @AuraEnabled public String addressLocality {get; set;}
        @AuraEnabled public String addressLine3 {get; set;}
        @AuraEnabled public String addressRegion {get; set;}
        @AuraEnabled public String addressLine2 {get; set;}
        @AuraEnabled public String addressContactName {get; set;}
        @AuraEnabled public String addressLine1 {get; set;}
        @AuraEnabled public String addressContactEmail {get; set;}
        @AuraEnabled public String id {get; set;}
        @AuraEnabled public String addressOrganisation {get; set;}
        @AuraEnabled public String externalCustomerAddressId {get; set;}
        @AuraEnabled public String addressType {get; set;}
        @AuraEnabled public String telephoneNo {get; set;}
        @AuraEnabled public String houseNumber {get; set;}
        @AuraEnabled public String countryCode {get; set;}
        @AuraEnabled public String taxRegistrationNumber {get; set;}
        @AuraEnabled public String businessPartnerNo {get; set;}
        @AuraEnabled public String taxCategory {get; set;}
        @AuraEnabled public String streetAddress {get; set;}
        @AuraEnabled public String postalCode {get; set;}
    }
    
    public class billingAddress {
        @AuraEnabled public String addressRegion {get; set;}
        @AuraEnabled public String postalCode {get; set;}
        @AuraEnabled public String streetAddress {get; set;}
        @AuraEnabled public String addressOrganisation {get; set;}
        @AuraEnabled public String businessPartnerNo {get; set;}
        @AuraEnabled public String addressContactEmail {get; set;}
        @AuraEnabled public String countryCode {get; set;}
        @AuraEnabled public String addressContactName {get; set;}
        @AuraEnabled public String telephoneNo {get; set;}
        @AuraEnabled public String addressLocality {get; set;}
        //@AuraEnabled public String externalCustomerAddressId {get; set;}
        @AuraEnabled public String addressCountry {get; set;}
        //@AuraEnabled public String addressType {get; set;}
        @AuraEnabled public String addressLine3 {get; set;}
        //@AuraEnabled public String houseNumber {get; set;}
        @AuraEnabled public String addressLine2 {get; set;}
        //@AuraEnabled public String taxRegistrationNumber {get; set;}
        @AuraEnabled public String addressLine1 {get; set;}
        //@AuraEnabled public String taxCategory {get; set;}
        @AuraEnabled public String id {get; set;}
    }
    
    public class orderedItem {
        @AuraEnabled public String id {get; set;}
        @AuraEnabled public String lineItemType {get; set;}
        @AuraEnabled public Integer orderedQuantity {get; set;}
        @AuraEnabled public Decimal discount {get; set;}
        @AuraEnabled public Integer quantity {get; set;}
        @AuraEnabled public String discountCode {get; set;}
        @AuraEnabled public String sellingCurrency {get; set;}
        @AuraEnabled public String discountCurrency {get; set;}
        @AuraEnabled public String currencyy {get; set;}
        @AuraEnabled public Decimal discountAmount {get; set;}
        @AuraEnabled public Decimal sellingPrice {get; set;}
        @AuraEnabled public String taxCode {get; set;}
        @AuraEnabled public Decimal price {get; set;}
        @AuraEnabled public Decimal taxAmount {get; set;}
        @AuraEnabled public String productId {get; set;}
        @AuraEnabled public String description {get; set;}
        @AuraEnabled public String status {get; set;}
    }
    
    public class invoices {
        //@AuraEnabled public list<payments> payments {get; set;}
        @AuraEnabled public String broker {get; set;}
        @AuraEnabled public Decimal freightCharge {get; set;}
        @AuraEnabled public String externalInvoiceRef {get; set;}
        @AuraEnabled public Decimal freightTax {get; set;}
        @AuraEnabled public String id {get; set;}
        @AuraEnabled public String currencyy {get; set;}
        @AuraEnabled public Boolean invoicePaymentPastDue {get; set;}
        @AuraEnabled public String paymentStatus {get; set;}
        @AuraEnabled public list<invoiceLineItems> invoiceLineItems {get; set;}
        @AuraEnabled public String paymentDueDate {get; set;}
        @AuraEnabled public String paymentUrl {get; set;}
        @AuraEnabled public String paymentTerm {get; set;}
    }
    /*public class payments {
@AuraEnabled public String id {get; set;}
@AuraEnabled public String paymentMethod {get; set;}
@AuraEnabled public String paymentDescription {get; set;}
@AuraEnabled public String paymentType {get; set;}
@AuraEnabled public Decimal paymentAmount {get; set;}
@AuraEnabled public String cardType {get; set;}
@AuraEnabled public String mcasId {get; set;}
@AuraEnabled public String authDate {get; set;}

}*/
    public class invoiceLineItems {
        @AuraEnabled public String productId {get; set;}
        @AuraEnabled public Integer quantity {get; set;}
        @AuraEnabled public String orderItemId {get; set;}
    }
    public class fulfillments {
        //@AuraEnabled public list<fulfillmentLineItems> fulfillmentLineItems {get; set;}
        @AuraEnabled public String termStartDate {get; set;}
        @AuraEnabled public String licenseType {get; set;}
        @AuraEnabled public String termEndDate {get; set;}
        @AuraEnabled public String description {get; set;}
        //@AuraEnabled public list<String> grantType {get; set;}
        @AuraEnabled public String name {get; set;}
        @AuraEnabled public String bundle {get; set;}
        @AuraEnabled public String id {get; set;}
        @AuraEnabled public String printOnDemand {get; set;}
        //@AuraEnabled public String shipmentStatus {get; set;}
        //@AuraEnabled public String status {get; set;}
        @AuraEnabled public String catalogueNumber {get; set;}
    }
    
    /*public class fulfillmentLineItems {
@AuraEnabled public Integer fulfillmentQuantity {get; set;}
@AuraEnabled public String productId {get; set;}
@AuraEnabled public String fulfillmentStatus {get; set;}
@AuraEnabled public String orderItemId {get; set;}
}*/
}