public class PublicVariables {

    public static boolean OLI_isBefore_FirstRun = true;
    public static boolean OLI_isAfter_FirstRun = true;

    public static boolean Opp_isBefore_FirstRun = true;
    public static boolean Opp_isAfter_FirstRun = true;
    
    public static boolean ITM_AutoCloneOpp_FirstRun = true;
    
    public static boolean ContactRole_EditReverseRole_FirstRun = true;

    public static boolean ProductAvailability_AutoUpdate = false;

    public static boolean Billing_UpdatedThroughVF = false;
    
    public static map<String, Id> mapRecordtype = new map<String, Id>();

    public static boolean OLI_UpdatedThroughApex = false;

    public static boolean Contact_UpdatedThroughApex = false;
    
    public static boolean RoleHistory_UpdatedThroughVF = false;

    public static boolean OppRoleHistory_UpdatedThroughVF = false;
    
    public static boolean BP_UpdatedSAPOrderNumberThroughCode = false;
    
    public static boolean RunTestInBatch = false;
    
    public static boolean IBI_Contact_NotifySAP_FirstRun = true;

    public static boolean OLI_ReplaceInProgress = false;
    
    public static boolean Opp_UpdateCurrencyInProgress = false;
    
    public static boolean TestingButRunAnyway = false;
    
    public static boolean BillingRenewalInProgress = false;
    
    public static boolean IBI_Opportunity_NotifySAP_FirstRun = true;
    
    public static boolean IBI_OptyProduct_NotifySAP_FirstRun = true;
    
    public static boolean IBI_Account_NotifySAP_FirstRun = true;
    
    public static boolean Opp_StageUpdatedThroughCode = false; //CHG0070249
    
    public static boolean EmailPreferenceUpdated = false;
    
}