public class OpportunityDataWrapper {
    @AuraEnabled
    public  string OwnerName {get; set;}
    @AuraEnabled
    public  integer TotalRecords {get; set;}
    @AuraEnabled
    public  String AccountName {get; set;}
    @AuraEnabled
    public  String StageName {get; set;}
    @AuraEnabled
    public  String CampusName {get; set;}
    @AuraEnabled
    public  String DepartmentName {get; set;}
    @AuraEnabled
    public  String Name {get; set;}
    @AuraEnabled
    public  String Type {get; set;}
    @AuraEnabled
    public  Decimal Amount {get; set;} 
    @AuraEnabled
    public  date CloseDate {get; set;}
    @AuraEnabled
    public  date CourseStartDate {get; set;} 
    @AuraEnabled
    public  Decimal NumberofStudents {get; set;}
    @AuraEnabled
    public  Id Id {get; set;}
    @AuraEnabled
    public  String baseURL {get; set;}
    public OpportunityDataWrapper(){
        
    }
}