/*
 * Created by - Sourabh Goyal
 * Created on - 9 Nov 2020
 * Description - This Class is wrapper class for MergeAccountController
 				 to find whether to merge or not
                
 * Test Class - MergeAccountController_Test
 * Test class coverage - 100%
 * Modified On - 20 May 2021
 * Modified By - Sourabh
 */


public with sharing class AccountMergeData {
    
    public MetaData metadata{ get; set; }
    public Data data{ get; set; }
    public List<Data> dataList{ get; set; }
    public String status{ get; set; }
    
    public class MetaData{
        public String message;
        public String status;
    }
    public class Data{
        public String party_id;
        public String sfdc_id;
        public String name;
        public String ringgold_id;
        public String pt_id;
        public Integer bp_count;
        public Setup setup;
        public Integer contactList;
        public Integer child_accounts;
        public Integer parent_accounts;
        public Boolean usage;
        //public Integer license; 
        public License licenses;
        public String status;
        public Integer activeLicenseCount;
    }

	
    public class Setup{
        public Integer party_id;
        public String orgName;
        public Boolean ipEnabled;
        public Boolean idpEnabled;
        public Boolean mfaEnabledUsers;
        public Boolean validAddress;
        
    }
    public class License{
        public Integer activeLicenseCount;
        public Integer expiredLicenseCount;
        public Integer deactiveLicenseCount; 
    }
    
    

   /* public class License{
        public Integer id {get;set;} 
        public String createdOn {get;set;} 
        public String updatedOn {get;set;} 
        public String bundleId {get;set;} 
        public List<String> bundleIds {get;set;} 
        public String partyId {get;set;} 
        public Long startDate {get;set;} 
        public Long endDate {get;set;} 
        public Integer concurrenyCount {get;set;} 
        public LicenseType licenseType {get;set;} 
        public String env {get;set;} 
        public String srcPartyId {get;set;} 
        public String srcLicenseId {get;set;} 
        public String name {get;set;} 
        public String orderNumber {get;set;} 
        public String code {get;set;} 
        public Long purchaseDate {get;set;} 
        public String description {get;set;} 
        public Boolean expired {get;set;} 
        public String licenseSyncState {get;set;} 
        public List<HierarchyMappings> hierarchyMappings {get;set;} 
        public String status {get;set;} 
        public String applicationCode {get;set;} 
        public Boolean drmLicense {get;set;} 
        public Integer drmId {get;set;} 
        public Boolean drmFeatureEnabled {get;set;} 
        public String policies {get;set;} 
        public String licenseRestriction {get;set;} 
        public String restrictedIsbn {get;set;} 
        public List<GrantType> grantType {get;set;} 
    }
    
    public class GrantType{
        public String id {get;set;} 
        public String createdOn {get;set;} 
        public String updatedOn {get;set;} 
        public String type {get;set;} 
        public String description {get;set;} 
    }

    public class LicenseType{
        public String id {get;set;} 
        public String createdOn {get;set;} 
        public String updatedOn {get;set;} 
        public String accessType {get;set;} 
        public String licenseType {get;set;} 
        public String description {get;set;} 
        public Integer precedence {get;set;} 
    }
    public class HierarchyMappings{
		public Integer id {get;set;} 
		public Object createdOn {get;set;} 
		public Object updatedOn {get;set;} 
		public String type {get;set;}
		public Integer partyId {get;set;}
    }*/
}


/*public with sharing class MergeFinder {
    
    
    
    public String party_id {get;set;} 
    public String sfdc_id {get;set;} 
    public String name {get;set;} 
    public String ringgold_id {get;set;} 
    public String pt_id {get;set;} 
    public Integer bp_count {get;set;} 
    public Setup setup {get;set;} 
    public Integer contactList {get;set;} 
    public Integer child_accounts {get;set;} 
    public Integer parent_accounts {get;set;} 
    public Boolean usage {get;set;} 
    public Integer license {get;set;} 


    public class Setup{
        public Integer party_id {get;set;} 
        public String orgName {get;set;} 
        public Boolean ipEnabled {get;set;} 
        public Boolean idpEnabled {get;set;} 
        public Boolean mfaEnabledUsers{get;set;} 
        public Boolean validAddress {get;set;} 
    }
    
    

   /* public class License{
        public Integer id {get;set;} 
        public String createdOn {get;set;} 
        public String updatedOn {get;set;} 
        public String bundleId {get;set;} 
        public List<String> bundleIds {get;set;} 
        public String partyId {get;set;} 
        public Long startDate {get;set;} 
        public Long endDate {get;set;} 
        public Integer concurrenyCount {get;set;} 
        public LicenseType licenseType {get;set;} 
        public String env {get;set;} 
        public String srcPartyId {get;set;} 
        public String srcLicenseId {get;set;} 
        public String name {get;set;} 
        public String orderNumber {get;set;} 
        public String code {get;set;} 
        public Long purchaseDate {get;set;} 
        public String description {get;set;} 
        public Boolean expired {get;set;} 
        public String licenseSyncState {get;set;} 
        public List<HierarchyMappings> hierarchyMappings {get;set;} 
        public String status {get;set;} 
        public String applicationCode {get;set;} 
        public Boolean drmLicense {get;set;} 
        public Integer drmId {get;set;} 
        public Boolean drmFeatureEnabled {get;set;} 
        public String policies {get;set;} 
        public String licenseRestriction {get;set;} 
        public String restrictedIsbn {get;set;} 
        public List<GrantType> grantType {get;set;} 
    }
    
    public class GrantType{
        public String id {get;set;} 
        public String createdOn {get;set;} 
        public String updatedOn {get;set;} 
        public String type {get;set;} 
        public String description {get;set;} 
    }

    public class LicenseType{
        public String id {get;set;} 
        public String createdOn {get;set;} 
        public String updatedOn {get;set;} 
        public String accessType {get;set;} 
        public String licenseType {get;set;} 
        public String description {get;set;} 
        public Integer precedence {get;set;} 
    }
    public class HierarchyMappings{
		public Integer id {get;set;} 
		public Object createdOn {get;set;} 
		public Object updatedOn {get;set;} 
		public String type {get;set;}
		public Integer partyId {get;set;}
    }
}*/