public class TF_BatchHandlerFailureSendEmail implements Schedulable {
    public  void execute(SchedulableContext  SC) {
        try{ 
            list< Product2> ListProductItems = new list<Product2>();
            List<String> StatusLst = new List<String>{'Failure','Submit To PCM Failed'};
                ListProductItems =[SELECT Id, Name, APIStatus__c,MaxReAttempts__c,createdBy.Id,createdBy.name from Product2 where APIStatus__c in: StatusLst and MaxReAttempts__c=3];
            User usr;
            
            List<Product2> prdEmailToUpdate = new List<Product2>();
            String baseUrl=URL.getSalesforceBaseUrl().toExternalForm();
            String emailsToCC;
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            
            emailsToCC = (String) orgSpecificProps.get('GetEmailsForFailure__c');
            
            String[] toCcAddresses = new String[]{};
                for(String emailId:emailsToCC.split(';')){
                    if(emailId != null && emailId !=''&& emailId != ' '){
                        toCcAddresses.add(emailId.trim());
                    }
                }
            
            for (Product2 Pd : ListProductItems) {
                List<Product2> prdToUpdate = new List<Product2>();
                String productUrl=baseUrl+'/'+pd.Id;
                String Username=Pd.CreatedBy.name;
                String ProductName=Pd.Name;
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                usr= [SELECT Name,Email from User where Id =: Pd.CreatedBy.Id];
                System.debug(usr.Email);
                String[] toAddresses = new String[] {usr.email};
                    //String[] ccAddresses = new String[] {toCcAddresses};
                    mail.setToAddresses(toAddresses);
                mail.setCcAddresses(toCcAddresses);
                //mail.setBccAddresses(bccAddresses);
                mail.setSenderDisplayName('Salesforce Support');
                mail.setSubject('Need Attention!');          
                // mail.setPlainTextBody('Your Product has not been processed, Please contact SFDC administrator!');
                mail.setHtmlBody('Hello '+ ' ' +Username+', <br/><br/>This Product has not been processed due to some technical issue. Kindly contact SFDC administrator! Click the link below to view the product<br/>Name of product : <b> '+ProductName+' </b><br> '+productUrl+'<br/><br/>Regards<br/> Salesforce');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
                System.debug('Email sent');
                pd.MaxReAttempts__c=4;
                prdEmailToUpdate.add(pd);
            }
            update prdEmailToUpdate;
        }
        catch(Exception ex){
            System.debug('SenEmailToCreator' + ' ' + ex.getMessage());
        }
    }
    
}