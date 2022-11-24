/***************************************************************************
* Created by: Radhikay Banerjee, 01.05.2022
* Test Class: 
* Description: This class is called by the Order hub whenever an License has to be cancelled.
* **************************************************************************/
@RestResource(urlMapping='/CancelLicenseRequestAPI/*')
global class TF_LicenseCancellationRequestAPI {
    @HttpPost
    global static void doPost() {
        Object result;  
        String jsonStr = RestContext.request.requestBody != null ? RestContext.request.requestBody.toString() : null;
        
        TF_LicenseCancellationRequestWrapper request = (TF_LicenseCancellationRequestWrapper)JSON.deserialize(jsonStr, TF_LicenseCancellationRequestWrapper.class);
        TF_licenseCreationService licenseService = new TF_licenseCreationService();
        TF_LicenseCancellationRequestWrapper.CancelLicenseResponse response = licenseService.validateCancelRequest(request);
          
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(response));
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.statusCode = response.statuscode;
        
        
    }

}