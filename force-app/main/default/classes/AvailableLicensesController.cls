public class AvailableLicensesController {   
    
    public AvailableLicensesController() {
        Map<String, UserLicense> mapLicenses = new Map<String, UserLicense>();
        List<UserLicense> licenses = [SELECT Name, TotalLicenses, UsedLicenses FROM UserLicense];
        for (UserLicense license : licenses) {
            mapLicenses.put(license.Name, license);
        }
        
        List<Setting_Item__c> settingLicenses = [SELECT Text_1__c FROM Setting_Item__c WHERE Setting__r.Name = 'Limited Licenses'];
        integer purchasedLimitedLicenses = 0;
        for (Setting_Item__c si : settingLicenses) {
            purchasedLimitedLicenses += integer.valueOf(si.Text_1__c);
        }

        List<Setting_Item__c> settingProfiles = [SELECT Text_1__c FROM Setting_Item__c WHERE Setting__r.Name = 'Limited License Profiles'];
        Set<Id> limitedProfileIDs = new Set<Id>();
        for (Setting_Item__c si : settingProfiles) {
            limitedProfileIDs.add(si.Text_1__c);
        }
        integer numUsed = [SELECT Id FROM User WHERE ProfileId IN :limitedProfileIDs AND isActive = True].size();
        
        sfFull_Total = mapLicenses.get('Salesforce').TotalLicenses - purchasedLimitedLicenses;
        sfFull_Used = mapLicenses.get('Salesforce').UsedLicenses - numUsed;
        sfFull_Remaining = sfFull_Total - sfFull_Used;

        sfLimited_Total = purchasedLimitedLicenses;
        sfLimited_Used = numUsed;
        sfLimited_Remaining = sfLimited_Total - sfLimited_Used;

        fc_Total = mapLicenses.get('Force.com - App Subscription').TotalLicenses;
        fc_Used = mapLicenses.get('Force.com - App Subscription').UsedLicenses;
        fc_Remaining = fc_Total - fc_Used;

        cp_Total = mapLicenses.get('Customer Community Plus').TotalLicenses;
        cp_Used = mapLicenses.get('Customer Community Plus').UsedLicenses;
        cp_Remaining = cp_Total - cp_Used;
    }
    
    private integer sfFull_Total;
    private integer sfFull_Used;
    private integer sfFull_Remaining;
    
    private integer sfLimited_Total;
    private integer sfLimited_Used;
    private integer sfLimited_Remaining;  
    
    private integer fc_Total;
    private integer fc_Used;
    private integer fc_Remaining;
    
    private integer cp_Total;
    private integer cp_Used;
    private integer cp_Remaining; 
    
    public integer SalesforceFull_Total {
        get {
            return sfFull_Total;
        }
    }
    public integer SalesforceFull_Used {
        get {
            return sfFull_Used;
        }
    }
    public integer SalesforceFull_Remaining {
        get {
            return sfFull_Remaining;
        }
    }
        
    public integer SalesforceLimited_Total {
        get {
            return sfLimited_Total;
        }
    }
    public integer SalesforceLimited_Used {
        get {
            return sfLimited_Used;
        }
    }
    public integer SalesforceLimited_Remaining {
        get {
            return sfLimited_Remaining;
        }
    }
        
    public integer ForceCom_Total {
        get {
            return fc_Total;
        }
    }
    public integer ForceCom_Used {
        get {
            return fc_Used;
        }
    }
    public integer ForceCom_Remaining {
        get {
            return fc_Remaining;
        }
    }
        
    public integer CommunityPlus_Total {
        get {
            return cp_Total;
        }
    }
    public integer CommunityPlus_Used {
        get {
            return cp_Used;
        }
    }
    public integer CommunityPlus_Remaining {
        get {
            return cp_Remaining;
        }
    }
}