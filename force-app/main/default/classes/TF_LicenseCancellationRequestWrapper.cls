/**
Author : Radhikay Banerjee
Test class :  
Description : This class is being used to desrialise the Request coming from OMS for the License Cancellation Request.
**/
public class TF_LicenseCancellationRequestWrapper {
    public String orderNumber;
    public String requestId;
    public String requestType;
    public requestPayload requestPayload;
    public String callBackurl;
    public Class requestPayload {
        public String originalRequestID ;
        public String[] licenseID ;
    }
    public Class CancelLicenseResponse {
       
        public Integer statuscode;//statuscode
        public list<licensesWrapper> licenses; 
        
    }
    public class licensesWrapper{ //SFAl - 162
        
        public string licenseId;
        public string customerId;
        public string licenseVersion;
        public string status;
    }

}