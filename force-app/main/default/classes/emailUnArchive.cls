public class emailUnArchive {
               case c;

    string case_id;
    public emailUnArchive (ApexPages.StandardController controller){
        case_id = ApexPages.currentPage().getParameters().get('id');
        c = [Select id,IsArchived__c,Inbound__c,outbound__c from case where id =: case_id limit 1];
    }
    
    
    public PageReference Recover(){
       
        if(!c.IsArchived__c)
        {
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: You can not Unarchive the case which is not Archived...');
            ApexPages.addMessage(myMsg);
            return null;
        }
        else
        {
        FutureArchiveUnArchive.FutureUnArchive(c);
        PageReference pg = new PageReference ('/'+case_id) ;
       
        return pg ; 
        }
    }
    
    public PageReference exitpg(){
        PageReference pg = new PageReference ('/'+case_id) ;
        
        return pg ;
    }    
    
}