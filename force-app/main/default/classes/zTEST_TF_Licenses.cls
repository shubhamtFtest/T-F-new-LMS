/**
Author : shubham kumar
Main class :  TF_Licenses 
**/
@isTest
public class zTEST_TF_Licenses {
    @isTest
    public static  void LicensesWrapper() {
        
        
        List<TF_Licenses.licensePolicy> policylist = new List<TF_Licenses.licensePolicy> ();
        
        TF_Licenses.licensePolicy lpo = new TF_Licenses.licensePolicy();
        lpo.Asset = 'Test';
        lpo.CreatedDate = 'Test';
        lpo.policyId = 'Test';
        lpo.policyName = 'Test';
        lpo.scope = 'Test';
        lpo.unit = 'Test';
        
        policylist.add(lpo);
        
        TF_Licenses tflic = new TF_Licenses();
        tflic.accessScope = 'Test';
        tflic.customerId = 'Test';
        tflic.licenseType = 'Test';
        tflic.createdOn = 'Test';
        tflic.grantType = 'Test';
        tflic.accessScope = 'Test';
        tflic.salesChannel = 'Test';
        tflic.productVersion = 'Test';
        tflic.licenseVersion = 'Test';
        tflic.orderNumber = 'Test';
        tflic.purchaseDate = 'Test';
        tflic.licenseName = 'Test';
        tflic.startDate = 'Test';
        tflic.endDate = 'Test';
        tflic.status = 'Test';
        tflic.partyId = 'Test';
        tflic.policies = policylist;
        
        
    }
}