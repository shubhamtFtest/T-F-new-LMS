/**
Author : 
Test class :  zTEST_TF_PostOrderOnOrderHubWrapRequest
Description : This class is being used to create order on order HUb side . order will only get inserted 1 at a time so NO BULKIFICATION is done. The order once created will not get update. 
**/
public class TF_PostOrderOnOrderHubWrapRequest {
    // Request 
    public list<fulfillments> fulfillments{get;set;}
    //added by shubham story : SFAL - 33 (08/02/2022);
    public String invoiceFormat {get;set;}
    public String orderDate{get;set;}
    public String buyerId{get;set;}
    public Decimal orderPrice{get;set;}
    public String customerId{get;set;}
    public String orderStatus{get;set;}
    public String confirmationNumber{get;set;}
    public String seller{get;set;}
    public String quoteNumber{get;set;}
    public billingAddress billingAddress{get;set;}
    public String notes{get;set;}
    public shippingAddress shippingAddress{get;set;}
    public String externalSystemRefId{get;set;}
    public list<orderedItem> orderedItem{get;set;}
    public String externalOrderRef{get;set;}
    public Decimal subTotalPrice{get;set;}
    public String channel{get;set;}
    public Decimal totalTax{get;set;}
    public String orderType{get;set;}
    public String opportunityId{get;set;}
    
    public List<fundersponsor> sponsors{get;set;}
    public class orderedItem{
        public string salesOrg;
        public String productId{get;set;}
        public Decimal price{get;set;}
        public String discountCode{get;set;}
        public Decimal discount{get;set;}
        public String discountCurrency{get;set;}
        public String lineItemType{get;set;}
        public Decimal discountAmount{get;set;}
        public Decimal orderedQuantity{get;set;}
        public String taxCode{get;set;}
        public Decimal quantity{get;set;}
        public Decimal taxAmount{get;set;}
        public String currencyy{get;set;}
        public String description{get;set;}
        public Decimal sellingPrice{get;set;}
        //Siddhant
        public List<Integer> sponsorRefId{get;set;}
        public string altProductId{get;set;}
        public String salesType{get;set;}
    }
    public class fulfillments{
        public String termEndDate{get;set;}
        public String licenseType{get;set;}
        public String termStartDate{get;set;}
        public String description{get;set;}
        public list<String> grantType{get;set;}
        public String name{get;set;}
    }
    public class billingAddress{
        public String houseNumber{get;set;}
        public String addressOrganisation{get;set;}
        public String postalCode{get;set;}
        public String addressContactEmail{get;set;}
        public String streetAddress{get;set;}
        public String addressContactName{get;set;}
        public String businessPartnerNo{get;set;}
        public String addressRegion{get;set;}
        public String countryCode{get;set;}
        public String addressLocality{get;set;}
        public String telephoneNo{get;set;}
        public String addressCountry{get;set;}
        public String externalCustomerAddressId{get;set;}
        public String addressLine3{get;set;}
        public String taxRegistrationNumber{get;set;}
        public String addressLine2{get;set;}
        public String taxCategory{get;set;}
        public String addressLine1{get;set;}
        public String careOf{get;set;}
        public String addressContactFirstName{get;set;}
        public String addressContactLastName{get;set;}
    }
    public class shippingAddress{
        public String houseNumber{get;set;}
        public String addressOrganisation{get;set;}
        public String postalCode{get;set;}
        public String addressContactEmail{get;set;}
        public String streetAddress{get;set;}
        public String addressContactName{get;set;}
        public String businessPartnerNo{get;set;}
        public String addressRegion{get;set;}
        public String countryCode{get;set;}
        public String addressLocality{get;set;}
        public String telephoneNo{get;set;}
        public String addressCountry{get;set;}
        public String externalCustomerAddressId{get;set;}
        public String addressLine3{get;set;}
        public String taxRegistrationNumber{get;set;}
        public String addressLine2{get;set;}
        public String taxCategory{get;set;}
        public String addressLine1{get;set;}
        public String careOf{get;set;}
        public String addressContactFirstName{get;set;}
        public String addressContactLastName{get;set;}
    }
    //Siddhant
    public class fundersponsor{
        public integer refId{get;set;}
        public String fundingStatement{get;set;}
        public funderdetails details{get;set;}
        public funderlicense license{get;set;}
    }
    //Siddhant
    public class funderdetails{
        public String name{get;set;}
        public String awardId{get;set;}
        public String awardType{get;set;}
        public String sfCustomerId{get;set;}
        public String externalRefId{get;set;}
        public String orcidId{get;set;}
    }
    //Siddhant
    public class funderlicense{
        public String description{get;set;}
        public String type{get;set;}
        public String location{get;set;}
    }    
    
}



//  last code 
//     public class TF_PostOrderOnOrderHubWrapRequest {
//     // public static Boolean isFirstTime = true; 

//     public class OrderException extends Exception {}

//     // ----- Order hub mapping with Request object definition ------    
//     public  class OrderRequest {
//         public String id;
//         public String orderType;
//         public String channel;
//         public String externalOrderRef;
//         public String opportunityId;
//         public String notes;
//         public String quoteNumber;
//         public String orderNumber;
//         public String confirmationNumber;
//         public String customerId;
//         public String buyerId;    
//         public Decimal discount;
//         public String discountCode;
//         public String discountCurrency;
//         public Decimal discountAmount;
//         public Date orderDate;
//         public Double orderPrice;
//         public String orderStatus;
//         public List<Invoice> invoices;
//         public String seller;
//         public BillingAddresses billingAddress;
//         public ShippingAddress shippingAddress;
//         public List<OrderedItems> orderedItem;
//         public List<Fulfillment> fulfillments;
//         public String description;
//         public String docDate;
//         public String release;
//         public String webId;
//         public String shipCustId;
//         public String orderSource;
//         public String rateOfExchange;
//         public String subTotalPrice;
//         public String totalTax;

//         public void validate() {
//             if (string.isBlank(id)) {
//                 throw new OrderException('Id cannot be empty');
//             }
//         }
//     }
//     public  class Invoice {
//         public List<invoiceLineItem> invoiceLineItems;
//         public String invoicePaymentPastDue;
//         public String id;
//         public Integer externalInvoiceRef;
//         public String broker;
//         public String freightCharge;
//         public String freightTax;
//         // public String currencyy;
//         public string paymentStatus;
//         public string paymentDueDate;
//         public string paymentTerm;
//         public string paymentUrl;
//         public string salesOrg;
//         public string readyForDownload;
//         // public List<payment> payments;

//     }
//     public  class invoiceLineItem {    
//         public String orderItemId;
//         public Integer quantity;
//         public String productId;       
//     }
//     public   class ShippingAddress {
//         public String id;
//         public String addressLine1;
//         public String addressLine2;
//         public String addressLine3;
//         public String addressCountry;
//         public String addressLocality;
//         public String addressRegion;
//         public String addressContactName;
//         public String addressContactEmail;
//         public String addressOrganisation;
//         public String postalCode;
//         public String streetAddress;
//         public String businessPartnerNo;
//         public String countryCode;
//         public String telephoneNo;
//         public String externalCustomerAddressId;
//         public String addressType;
//         public String houseNumber;
//         public String taxRegistrationNumber;
//         public String taxCategory;
//         public String addressContactFirstName;
//         public String addressContactLastName;


//     }

//     public  class BillingAddresses {
//         public String id;
//         public String addressId;
//         public String addressLine1;
//         public String addressLine2;
//         public String addressLine3;
//         public String addressCountry;
//         public String addressLocality;
//         public String addressRegion;
//         public String addressContactName;
//         public String addressContactEmail;
//         public String addressOrganisation;
//         public String postalCode;
//         public String streetAddress;
//         public String businessPartnerNo;
//         public String countryCode;
//         public String telephoneNo;
//         public String externalCustomerAddressId;
//         public string addressType;
//         public string houseNumber;
//         public string taxRegistrationNumber;
//         public string taxCategory;
//         public string addressContactFirstName;
//         public string addressContactLastName;

//     }

//     public  class OrderedItems {
//         public String id;
//         public String productId;
//         public Double price;
//         public Decimal sellingPrice;
//         // public String currencyy;
//         public String sellingCurrency;
//         public String quantity;
//         public Integer orderedQuantity;
//         public String lineItemType;
//         public Decimal discount;
//         public String discountCode;
//         public String discountCurrency;
//         public String discountAmount;
//         public String taxCode;
//         public double taxAmount;
//         public String description;
//         public string status;
//         public string salesOrg;

//     }

//     public  class Fulfillment {
//         public List<FulfillmentLineItem> fulfillmentLineItems;
//         public String id;
//         public String name;
//         public String description;
//         public String licenseType;
//         public String termStartDate;
//         public String termEndDate;
//         public List<String> grantType;
//         public String bundle;
//         public String printOnDemand;
//         public String catalogueNumber;
//         public String shipmentStatus;
//         public String status;

//     }
//     public  class FulfillmentLineItem{
//         public String orderItemId;
//         public String productId;
//         public String fulfillmentStatus;
//         public String fulfillmentQuantity;
//     }


//     //  response  
//         public metadata metadata{get;set;}
//         public data data{get;set;}
//     public class metadata{
//         public Integer code{get;set;}
//         public String message{get;set;}
//     }
//     public class data{
//         public String orderNumber{get;set;}
//         public String listOfOrderNumber{get;set;}
//     }

// }