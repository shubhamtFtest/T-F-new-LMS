/*
 * Test Class:ztest_Quote_APIDataModels
*/public without sharing class Quote_APIDataModels {
    
    public class DealRequest {
       public Organization customer; 
       public Address billingAddress;
       public String billingCountry;
       public DiscountParam discountParam;
       public List<Service> services;
       public List<String> products;        
    }
    
    public class Deal {
        public Id dealId;
        public String dealName;
        public String description;
        public List<Discount> discount;
        public Discount getBestPercentageDiscount() {
            Discount bestDiscount = null;
            if (discount != null) {
                Decimal bestPercentageDiscount = 0;
                for(Discount dis : discount) {
                    if(dis.discountType.equalsIgnoreCase('% Discount')) {
                        if(dis.discountValuePercentage > bestPercentageDiscount) {
                            bestPercentageDiscount = dis.discountValuePercentage;
                            bestDiscount = dis;
                        }
                    }
                }
            }
            return bestDiscount;            
        }
    }
    
    public class Discount {
        public String discountType;
        public Decimal discountValuePercentage;
        public Decimal discountValueAmount;
        public String currencyISO;
    }
    
    public class CreateQuoteRequest {
        public String source;
        public Identifier Identifier;
        public Organization customer;
		public Address billingAddress;
		public Address shippintAddress;
        public DiscountParam discountParam; 
        public List<Service> services;
        public List<String> products;
        // --- APC Specific Inputs ----
        public String payerType;
        public String purchaseOrderNumber;
        public SubmissionDetails submissionDetails;
        public AuthorDetails leadAuthor;        
    }
    
    public class CreateQuoteResponse {
        public ID quoteID;
        public String quoteName;
    }
    
    public class Organization {
        public String partyId;
        public String name;
        public String customerType;
        public String campus;
        public String department;
        public Contact contact;
    }
        
    public class Contact {
        public String name;
        public String email;
        public String phoneNumber;
    }
    
    public class DiscountParam {
        public Boolean usePrepayBudget;
        public Boolean applyCountryDiscount;
        public String promoCode;
    }
    
    public class Address {
        public String name;
        public String street;
        public String city;
        public String state;
        public String country;
        public String postalCode;
        public String bpNumber;
    }
    
    public Class SubmissionDetails {
        public String articelTitle;
        public Boolean isArticleAccepted;
        public Boolean isAuthorAccepted;
    }
    
    public Class AuthorDetails {
        public String name;
        public String email;
        public String phoneNumber;
        public Organization organization;
    }
    
    public Class Service {
        public String serviceId;
        public String parentProductId;
    }
    public Class Identifier {
        public String manuscriptID;
        public String submissionID;
        public String doi;
        public String requestId;
        public String purchaseOrderNumber;
    }
}