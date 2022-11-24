/************************************************************************************
    //This is the extension of VF page "LicenseAlertPage"
    //Created by Vikas for UBXC-222 on dated 30th March, 2020
    //Test coverage "zTest_TF_LicenseAlertPageExtension"
************************************************************************************/

public class TF_LicenseAlertPageExtension {
    public License__c LicenseRecord {get;set;}

    public TF_LicenseAlertPageExtension(ApexPages.StandardController controller) {
        LicenseRecord = (License__c)controller.getRecord();
    }
    
    public PageReference stopLicenseAlert () {
        PageReference requestPage = new pagereference('/'+LicenseRecord.id);
        License__c licnseRecord = [ SELECT id, Stop_Alert_Msg__c, Update_Type__c FROM License__c WHERE id =:LicenseRecord.id ];
        
        if ( licnseRecord.Stop_Alert_Msg__c == false ) {
            License__c licUpdate = new License__c();
            licUpdate.id = LicenseRecord.id;
            licUpdate.Stop_Alert_Msg__c = true;
            try {
                update licUpdate;
                requestPage.setRedirect(true);
                return requestPage;
            } catch ( Exception ex ) {
                System.debug('DML Exception =====>' + ex.getMessage());
            }
        }
        
        return NULL;
    }
}