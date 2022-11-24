public class ContactDataWrapper {
    @AuraEnabled
    public  integer TotalRecords {get; set;}
    @AuraEnabled
    public  String AccountName {get; set;}
    @AuraEnabled
    public  String CampusName {get; set;}
    @AuraEnabled
    public  String DepartmentName {get; set;}
    @AuraEnabled
    public  String Name {get; set;}
    @AuraEnabled
    public  String Title {get; set;}
    @AuraEnabled
    public  String MailingCountry {get; set;} 
    @AuraEnabled
    public  String MobilePhone {get; set;}
    @AuraEnabled
    public  String Email {get; set;} 
    @AuraEnabled
    public  String  Status {get; set;}
    @AuraEnabled
    public  String  ContactType {get; set;}
    @AuraEnabled
    public  Id Id {get; set;}
    @AuraEnabled
    public  String baseURL {get; set;}
}