/**
Author : shubham kumar
Test class :  zTEST_TF_Licenses 
Description : This class is being used to serialise  the Asset Response that is being send  from salesforce.
**/

public class TF_Licenses {
    public String licenseId;
    public String customerId;
    public String licenseType;
    public String createdOn;
    //public String createdby;
    public String grantType;
    public String accessScope;
    public String salesChannel;
    public String productVersion;
    public String licenseVersion;
    public String orderNumber;
    public String purchaseDate;
    public String licenseName;
    public String startDate;
    public String endDate;
    public String status;
    public String partyId;
    Public List<licensePolicy> policies;
    
    public class licensePolicy {
        public String CreatedDate;
        public String policyId;
        public String Asset;
        public String policyName;
        public String scope;
        public String unit;
    }
    
}