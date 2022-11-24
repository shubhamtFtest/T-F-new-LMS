/**
Author : shubham kumar
Test class :  zTEST_TF_LicenseCreateRequestWrapper
Description : This class is being used to desrialise the Response coming from OMS for the License Creation Request.
**/
public class TF_LicenseCreateRequestWrapper{
    public String orderNumber;
    public String requestId;
    public String requestType; //SFAL-168 Vikas Varshney
    public requestPayload requestPayload;
    public String callBackurl;
    
    public Class LicenseCreateResponse {
        public String requestId;
        public Integer numberOfLicenses;
        public Integer orderId;
        //public Customer customer;
        public String statusMessage;//statusMessage
        //public Boolean success;
        public Integer statuscode;//statuscode
        // Changes made by Sourabh - SFAl -77
        public list<licensesWrapper> licenses; //SFAl -77
    }
    public class licensesWrapper{ //SFAl -77
        public string orderLineItemId;
        public string licenseId;
        public string licenseVersion;
        public string status;
    }
    
    public Class requestPayload {
        public String source;
        public String orderId;
        public String salesChannel;
        public String requestJSON;
        public Customer customer;
        public LicensedProduct [] products = new List<LicensedProduct>();
    }
    
    public Class Customer {
        public String partyId;
        public String type;
        public String [] members = new List<String>();
    }
    
    public Class LicensedProduct {
        public String productUUID;
        public String version;
        public String productType; //SFAL-174 Vikas Varshney
        public String orderLineItemId;
        public LicenseDetails licenseDetails;
    }
    
    public Class LicenseDetails {
        public String channel;
        public String startDate;
        public String endDate;
        public String licenseType;
        public String licenseUpdateType;
        public String accessScope;
        public String licenseUpdateEndDate;//subscriptionEndDate
        public LicensePolicy policies;
    }
    
    public class LicensePolicy {
        public Boolean drm;
        public String concurrency;
        public String [] grantType = new List<String>();
        public String copyCount;
        public String printCount;
    }
}