/**************************************************************************************************
    CampusDepartmentController for page CustomLeadConversion to create Campus and Department pop-up
    Created Date: 2017/02/01
    Rishabh Singh: Modified on 2017/06/20 CHG0033760
**************************************************************************************************/
public class CampusController{
    public String accountId {get; set;}
    public String accountName {get; set;}
    public String campusName {get; set;}
    public Campus__c campObj{get;set;}
    public Department__c deptObj{get;set;}
    public String leadId {get; set;}
    public Boolean isCampus {get; set;}
    public String index {get; set;}
    public Boolean isNewCampusId {get; set;}
    
    public Campus__c oCampus{get;set;}
    public Account oAccount{get;set;}
 
        
    public CampusController(){
         
        accountId = apexpages.currentpage().getparameters().get('accountId');
        if(accountId != null){
             accountName = [select id, name from Account where id=:accountId limit 1].name;
        }
        campusName = apexpages.currentpage().getparameters().get('campusName');
        
        
        leadId = apexpages.currentpage().getparameters().get('leadId');
        isCampus = (apexpages.currentpage().getparameters().get('isCampus')=='Y') ? true : false;
        index = apexpages.currentpage().getparameters().get('index');
        campObj = new Campus__c();
        campObj.Account__c = accountId;
        deptObj = new Department__c();
        deptObj.Account__c = accountId;
        isNewCampusId = true;

        if(apexpages.currentpage().getparameters().get('campusId') != null && String.isNotBlank(apexpages.currentpage().getparameters().get('campusId')) && apexpages.currentpage().getparameters().get('campusId') !='-None-' && !apexpages.currentpage().getparameters().get('campusId').contains('NewCampus')){
             oCampus=[select id,Account__c,Mailing_City__c,Mailing_ZIP_Postal_Code__c,Mailing_Street__c,Mailing_State_Province_List__c,Mailing_Country_List__c from Campus__c where id=:apexpages.currentpage().getparameters().get('campusId') limit 1]; // - Updated CHG0033760
            try{
                deptObj.Campus__c = apexpages.currentpage().getparameters().get('campusId'); 
                if(deptObj.Campus__c !=null && deptObj.Account__c !=null){
                  deptObj.Mailing_City__c = oCampus.Mailing_City__c;
                  deptObj.Mailing_Country_List__c=oCampus.Mailing_Country_List__c;
                  deptObj.Mailing_State_Province_List__c=oCampus.Mailing_State_Province_List__c;
                  deptObj.Mailing_Street__c = oCampus.Mailing_Street__c;
                  deptObj.Mailing_ZIP_Postal_Code__c = oCampus.Mailing_ZIP_Postal_Code__c;
                }
              
            }// - Updated CHG0033760
            catch(Exception e){
                campusName = apexpages.currentpage().getparameters().get('campusId');
                isNewCampusId = false;
            }  
            
            
        }
        // - Updated CHG0033760
        else {
            oAccount = [select id, name,Billing_City__c,Billing_Country_List__c,Billing_State_List__c,Billing_Street__c,Billing_ZIP__c from Account where id=:accountId];
            if(deptObj.Campus__c ==null &&  deptObj.Account__c !=null){
            deptObj.Mailing_City__c = oAccount.Billing_City__c;
            deptObj.Mailing_Country_List__c = oAccount.Billing_Country_List__c;
            deptObj.Mailing_State_Province_List__c=oAccount.Billing_State_List__c;
            deptObj.Mailing_Street__c = oAccount.Billing_Street__c;
            deptObj.Mailing_ZIP_Postal_Code__c = oAccount.Billing_ZIP__c;
            }
        }   
    }
    
   /* public void save(){
        
    }
    
    public PageReference cancel(){
        /*PageReference pg = new PageReference('/'+leadId);
        pg.setRedirect(true);
        return pg;  
        return null;      
    }*/
}