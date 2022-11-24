/*
 * Created By: Faiz
 * Test Class: zTEST_DiscretionaryWaiverTemplate
 */
public class DiscretionaryWaiverTemplateController {
    
    //private final List<Account> accounts;
    public string documentlink{get; set;}
  //  public string documentId{get; set;}
    public String imageURL  {
        get {
            return generateImageUrl();
        }
        private set;
    }
    
    
    public String generateImageURL()
    {
        Contentversion cvlink  = [select Id,PathOnClient,TagCsv,ContentUrl from Contentversion where ContentDocumentId =:this.documentlink ];
        String imageURL = null;
        imageURL = cvlink.ContentUrl;
        
        return imageURL;
    }
    
    
}