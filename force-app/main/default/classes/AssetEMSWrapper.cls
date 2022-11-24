/***************************************************************************
Author : Vikas Varshney
Description : This wrapper sends LMS notification to SNS for AddLicense/UpdateLicense
****************************************************************************/

public class AssetEMSWrapper {
    public Header header;
    public Body body;

    public class Header {
        public String id;
        public String timestamp;
        public String source;
        public String application;
        public String action;
        public String version;
    }

    public class Body {
        public String status;
        public String licenseId;
        public String licenseName;
        public String licenseVersion;
        public String licenseType;
        public String licenseStartDate;
        public String licenseEndDate;
        public List<String> grantType;
        public String licenseUpdateEndDate;
        public String billingCountry;
        public String productId;
        public String oldproductversion;
        public String latestproductVersion;
        public String productType;
        public String customerId;
        public String customerType;
        public String accessScope;
        public String updateType;
        public Policy policy;
    }
    
    public class Policy {
        public String drm;
        public String Concurrency;
        public String copycount;
        public String printcount;
    }
}