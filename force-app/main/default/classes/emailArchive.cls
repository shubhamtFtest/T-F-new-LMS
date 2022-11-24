public class emailArchive {
    public case casevar{get;set;}
    string case_id;
    public boolean PagePriBut;
    
    public emailArchive(ApexPages.StandardController controller){
        case_id = ApexPages.currentPage().getParameters().get('id');
        casevar= [select id , Status, ClosedDate from case where id=: case_id];
        system.debug('*****'+casevar.ClosedDate);
        PagePriBut= false;
    }
    
    
    public PageReference  Archive(){ 
        PagePriBut= true;

        if (!casevar.Status.contains('Closed')) {                     
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: You can not archive the case which is not closed..');
            ApexPages.addMessage(myMsg);
            return null;

        } 
        else{
            FutureArchiveUnArchive.FutureArchive(case_id);
            
            PageReference pg = new PageReference ('/'+case_id) ;
            return pg ; 
        }   
    } 
    
    public PageReference exitpg(){
        PageReference pg = new PageReference ('/'+case_id) ;
        return pg ;
    }
    
    
}