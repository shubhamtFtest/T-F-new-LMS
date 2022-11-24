/**
Author : shubham kumar
Apex class :  TF_LicenseCreateRequestWrapper
**/
@isTest
public class zTEST_TF_LicenseCreateRequestWrapper {

    @isTest
    public static void LicenseDataWrapperTest(){
       
        TF_LicenseCreateRequestWrapper.LicensePolicy policies = new TF_LicenseCreateRequestWrapper.LicensePolicy();
        policies.concurrency = '1';
        policies.copyCount = '1';
        policies.drm = true;
        policies.printCount = '1';
        
        TF_LicenseCreateRequestWrapper.LicenseDetails license = new TF_LicenseCreateRequestWrapper.LicenseDetails();
        license.accessScope = 'Test';
        license.channel = 'Test';
        license.endDate = '11/02/2014';
        license.licenseType = 'Test';
        license.licenseUpdateType = 'Test';
        license.startDate = '11/02/2014';
        license.policies = policies;
        
        TF_LicenseCreateRequestWrapper.LicensedProduct prod = new TF_LicenseCreateRequestWrapper.LicensedProduct();
        prod.orderLineItemId = 'Test';
        prod.productUUID = 'Test';
        prod.version = 'Test';
        prod.licenseDetails = license;
        
        List<TF_LicenseCreateRequestWrapper.LicensedProduct> licenseProdList = new List<TF_LicenseCreateRequestWrapper.LicensedProduct>();
        licenseProdList.add(prod);
            
        TF_LicenseCreateRequestWrapper.Customer customer = new TF_LicenseCreateRequestWrapper.Customer();
        customer.partyId = 'TestId';
        customer.type = 'Customer';
        
        TF_LicenseCreateRequestWrapper.requestPayload payload = new TF_LicenseCreateRequestWrapper.requestPayload();
        payload.orderId = 'Test';
        payload.source = 'Test';
        payload.salesChannel = 'system.today()';
        payload.customer = customer;
        payload.products = licenseProdList;
        
        TF_LicenseCreateRequestWrapper licensereq = new TF_LicenseCreateRequestWrapper();
        licensereq.callBackurl= 'Test';
        licensereq.orderNumber= 'Test';
        licensereq.requestId= 'Test';
        licensereq.requestPayload = payload;
        
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        Licenseresponse.requestId = 'CreationReqId';//creationRequest.id;
        Licenseresponse.numberOfLicenses = 123;
        Licenseresponse.statuscode = 201;
        Licenseresponse.statusMessage = 'Licenses Have been Created Succesfully!!';
    }
    
}