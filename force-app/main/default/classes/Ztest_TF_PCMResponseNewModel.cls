@isTest
public class Ztest_TF_PCMResponseNewModel {

	TF_PCMResponseNewModel.Metadata mt =new TF_PCMResponseNewModel.Metadata();
    private static testmethod void testBook(){
        TF_PCMResponseNewModel.Book cont = new TF_PCMResponseNewModel.Book();
        cont.publisherImprint='TestName@gmail.com';
        cont.publicationDate='TestGivenName'; 
        cont.format ='TestFamilyName';
        cont.bindingStyle='TestGivenName TestFamilyName';
        cont.bindingStyleCode='TestBio';
        cont.citation='TestOrchid';
        cont.edition =1;
        cont.description='Testcollab';
        cont.firstPublishedYear='TestBio';
        cont.formatCode ='TestBio';  
        cont.toc='test';
        List<TF_PCMResponseNewModel.FundingGroups> fds = new List<TF_PCMResponseNewModel.FundingGroups>();
        List<TF_PCMResponseNewModel.Audience> ads = new List<TF_PCMResponseNewModel.Audience>();
        cont.inLanguage ='TestBio';
        cont.legacyDivision ='TestBio';
        cont.legalOwner='TestBio';
        TF_PCMResponseNewModel.License lcs = new TF_PCMResponseNewModel.License();
        cont.plannedPublicationDate ='TestBio';
        TF_PCMResponseNewModel.ProductionSpecification pds = new TF_PCMResponseNewModel.ProductionSpecification();
        cont.publicationLocation ='TestBio'; 
        cont.publisherArea ='TestBio';
        cont.publisherAreaCode ='TestBio'; 
        cont.shortTitle='TestBio';
        cont.status ='TestBio';
        cont.statusCode ='TestBio';
        cont.subtitle ='TestBio';
        cont.textType ='TestBio';
        cont.textTypeCode ='TestBio';
        cont.division='TestBio';
        cont.divisionCode='TestBio';
        cont.doiRegistrationStatus =true;
        cont.divisionCode ='TestBio';
        cont.abstracts=new List<TF_PCMResponseNewModel.Abstracts>(); 
        cont.counts=new List<TF_PCMResponseNewModel.Counts>(); 
        cont.copyright=new TF_PCMResponseNewModel.Copyright();
        cont.productionSpecification=new TF_PCMResponseNewModel.ProductionSpecification(); 
        cont.bibliographicSpecification=new TF_PCMResponseNewModel.BibliographicSpecification();
        cont.formerImprints=  new List<TF_PCMResponseNewModel.Audience>(); 
        cont.fundingGroups=new List<TF_PCMResponseNewModel.FundingGroups>(); 
        cont.license= new TF_PCMResponseNewModel.license(); 
        
        
    }
    
    private static testmethod void testContributors(){
        TF_PCMResponseNewModel.Contributors cont = new TF_PCMResponseNewModel.Contributors();
        cont.email='TestName@gmail.com';
        cont.givenName='TestGivenName'; 
        cont.familyName ='TestFamilyName'; 
        cont.fullName='TestGivenName TestFamilyName';
        //cont.role ='Editor';
        cont.position =1;
        cont.bio='TestBio';
        cont.orcid='TestOrchid';
        cont.collab='Testcollab';
        cont.affiliations=new List<TF_PCMResponseNewModel.Affiliations>();
        cont.roles=new List<String>();
    }
    
    
    
    private static testmethod void testCounts(){
        TF_PCMResponseNewModel.Counts cnt = new TF_PCMResponseNewModel.Counts();
        cnt.Count = 20;
        cnt.type_Z = 'Book' ;
        cnt.formatsCount=new List<TF_PCMResponseNewModel.FormatsCount>();
       
    }
    
    
    private static testmethod void testMetaData(){
        TF_PCMResponseNewModel.MetaData mt = new TF_PCMResponseNewModel.MetaData();
        mt.limit_Z = 30 ;
        mt.offset = 0 ;         
        mt.type_Z = 'Book' ;
        mt.counts= new List<TF_PCMResponseNewModel.Counts>();
        mt.prices= new List<TF_PCMResponseNewModel.Prices>();
       
    }
    
    private static testmethod void testPrices(){
        TF_PCMResponseNewModel.Prices price = new TF_PCMResponseNewModel.Prices();
        price.price = '3.89';
        price.X_currency = 'USD';
        price.validFrom = '12/10/18' ;
        price.priceType = 'BYO' ;         
        price.priceTypeCode = 'BYO' ;
        price.productsCount=100;
    }    
    private static testmethod void testData(){ 
        TF_PCMResponseNewModel.Data TFContent= new TF_PCMResponseNewModel.Data();
        TF_PCMResponseNewModel.Product prd = new TF_PCMResponseNewModel.Product();
        
        List<TF_PCMResponseNewModel.Availability> avb = new List<TF_PCMResponseNewModel.Availability>();
    }
    
    private static testmethod void testAffiliation(){ 
        TF_PCMResponseNewModel.Affiliations affl= new TF_PCMResponseNewModel.Affiliations();       
        
    }
    
     private static testmethod void testProduct(){
         TF_PCMResponseNewModel.Product prd = new TF_PCMResponseNewModel.Product();
         prd.x_id='123';
         prd.type_Z='type'; 
         prd.title ='TestFamily';
         prd.contributors=new List<TF_PCMResponseNewModel.Contributors>();
         prd.book=new TF_PCMResponseNewModel.Book();
         prd.identifiers= new TF_PCMResponseNewModel.identifiers();
         prd.prices= new List<TF_PCMResponseNewModel.prices>();
         prd.creativeWork= new TF_PCMResponseNewModel.creativeWork();
         prd.scholarlyArticle= new TF_PCMResponseNewModel.scholarlyArticle();
         prd.collection= new TF_PCMResponseNewModel.collection();
         prd.chapter= new TF_PCMResponseNewModel.chapter();
         //prd.impressionLocations=new List<TF_PCMResponseNewModel.impressionLocations>();
         }
    
     private static testmethod void testidentifiers(){
        TF_PCMResponseNewModel.identifiers Idf = new TF_PCMResponseNewModel.identifiers();
         Idf.articleId='123';
         Idf.articleSectionId='type'; 
         Idf.chapterId ='TestFamily';
         Idf.code='test';
         Idf.dacKey='test';
         Idf.doi='test';
         Idf.editionId='test';
         Idf.isbn='test';
         Idf.orderNumber='test';
         Idf.productId='test';
         Idf.seriesCode='test';
         Idf.sku='test';
         Idf.titleId='test';      
        
    }
    
     private static testmethod void testcreativeWork(){
        TF_PCMResponseNewModel.creativeWork cw = new TF_PCMResponseNewModel.creativeWork();
         cw.publisherImprint='123';
         cw.publicationDate='type'; 
         cw.format ='TestFamily';
     }
    
     private static testmethod void testscholarlyArticle(){
         TF_PCMResponseNewModel.scholarlyArticle sa = new TF_PCMResponseNewModel.scholarlyArticle();
         sa.articleSection='123';
         sa.articleType='type'; 
         sa.currentVersion ='TestFamily';
         sa.dataAvailability=true;
         sa.description='type'; 
         sa.inLanguage='type'; 
         sa.orderInIssue=1;
         sa.pageEnd=1;
         sa.pageStart=1;
         sa.publicationDate ='type';  
         sa.publisherImprint='type'; 
         sa.subtitle ='type'; 
         sa.copyright= new TF_PCMResponseNewModel.Copyright();
         sa.abstracts= new List<TF_PCMResponseNewModel.Abstracts>();
         sa.fundingGroups= new List<TF_PCMResponseNewModel.FundingGroups>();
         sa.stages= new List<TF_PCMResponseNewModel.Stages>();
         sa.counts=new List<TF_PCMResponseNewModel.Counts>(); 
         sa.dates=new TF_PCMResponseNewModel.Dates();
         sa.license=new TF_PCMResponseNewModel.License();
         
     }
    
    
     private static testmethod void testcollection(){
         TF_PCMResponseNewModel.collection cls = new TF_PCMResponseNewModel.collection();
         cls.format='123';
         cls.subtitle='type'; 
         cls.updatedFrom ='TestFamily';
         cls.updatedTo='TestFamily';
         cls.description='type'; 
         cls.inLanguage='type'; 
         cls.validFrom='type'; 
         cls.validTo='type';
         List<TF_PCMResponseNewModel.Counts> cnts = new List<TF_PCMResponseNewModel.Counts>();
         cls.firstPublishedYear =2019;
         cls.plannedPublicationDate ='type';
         cls.publicationDate='type';
         cls.publisherImprint ='type';
         cls.copyright= new TF_PCMResponseNewModel.Copyright();
         cls.counts= new List<TF_PCMResponseNewModel.Counts>();
         cls.abstracts= new List<TF_PCMResponseNewModel.Abstracts>();
             
         
     }
	
     private static testmethod void testRights(){
         TF_PCMResponseNewModel.Rights rhg = new TF_PCMResponseNewModel.Rights();
         rhg.category='123';
         rhg.iso2='type'; 
         rhg.iso3 ='TestFamily';
         rhg.isonum='TestFamily';
         rhg.name='type'; 
         rhg.type_Z='type';                   
     }
    
    private static testmethod void testAbstracts(){
         TF_PCMResponseNewModel.Abstracts rhg = new TF_PCMResponseNewModel.Abstracts();
         rhg.location='123';
         rhg.source='type'; 
         rhg.type_Z ='TestFamily';
         rhg.value='TestFamily';                            
     }
    
    private static testmethod void testPermissions(){
        TF_PCMResponseNewModel.Permissions rhg = new TF_PCMResponseNewModel.Permissions();
        rhg.code='123';
        rhg.description='type'; 
        rhg.name ='TestFamily';
        rhg.text='TestFamily';  
        rhg.type_Z='TestFamily'; 
        rhg.validFrom='TestFamily'; 
        rhg.validTo='TestFamily'; 
     }
    
     private static testmethod void testSet_Z(){
         TF_PCMResponseNewModel.Set_Z rhg = new TF_PCMResponseNewModel.Set_Z();
         List<TF_PCMResponseNewModel.Abstracts> abs = new List<TF_PCMResponseNewModel.Abstracts>();
         TF_PCMResponseNewModel.BibliographicSpecification bbl = new TF_PCMResponseNewModel.BibliographicSpecification();
         rhg.bindingStyle ='test';
         rhg.bindingStyleCode ='test';
         rhg.citation ='test';
         rhg.abstracts=new List<TF_PCMResponseNewModel.Abstracts>();
         rhg.bibliographicSpecification=new TF_PCMResponseNewModel.BibliographicSpecification();
         rhg.copyright=new TF_PCMResponseNewModel.copyright();
         rhg.counts=new list<TF_PCMResponseNewModel.Counts>();
         TF_PCMResponseNewModel.Copyright cpt = new TF_PCMResponseNewModel.Copyright();
         List<TF_PCMResponseNewModel.Counts> cnts = new List<TF_PCMResponseNewModel.Counts>();        
         rhg.description ='test';
         rhg.division ='test';
         rhg.divisionCode ='test';
         rhg.doiRegistrationStatus =true;
         rhg.edition  =1;
         rhg.firstPublishedYear='test';
         rhg.format='test';
         rhg.formatCode ='test';
         List< TF_PCMResponseNewModel.Audience> formerImprints = new List<TF_PCMResponseNewModel.Audience>();
         rhg.impressionNo =1;
         rhg.inLanguage ='test';
         rhg.legacyDivision ='test';
         rhg.legalOwner ='test';
         rhg.plannedPublicationDate ='test';
         TF_PCMResponseNewModel.ProductionSpecification pds = new TF_PCMResponseNewModel.ProductionSpecification();        
         rhg.publicationDate ='test';
         rhg.publicationLocation  ='test';
         rhg.publisherArea ='test';
         rhg.publisherAreaCode ='test';
         rhg.publisherImprint  ='test';
         rhg.shortTitle='test';
         rhg.status='test';
         rhg.statusCode ='test';
         rhg.subtitle ='test';
         rhg.textType ='test';
         rhg.textTypeCode ='test';
         rhg.toc='test';         
     }
    
     private static testmethod void testClassifications(){
        TF_PCMResponseNewModel.Classifications rhg = new TF_PCMResponseNewModel.Classifications();
        rhg.code='123';
        rhg.group_Z='type'; 
        rhg.level =1;
        rhg.name='TestFamily';  
        rhg.priority=1; 
        rhg.type_Z='TestFamily'; 
     }
      private static testmethod void testAudience(){
        TF_PCMResponseNewModel.Audience rhg = new TF_PCMResponseNewModel.Audience();
        rhg.code='123';
        rhg.description='type'; 
           
    }
    
    private static testmethod void testCategories(){
        TF_PCMResponseNewModel.Categories rhg = new TF_PCMResponseNewModel.Categories();
        rhg.code='123';
        rhg.name='type'; 
        rhg.type_Z='yui';
           
    }
    
     private static testmethod void testIsPartOf(){
         TF_PCMResponseNewModel.IsPartOf rhg = new TF_PCMResponseNewModel.IsPartOf();
         rhg.x_id='123';
         rhg.level=1; 
         rhg.position=1;
         rhg.title='uii';
         rhg.type_Z='test';        
         }
    
    private static testmethod void testStages(){
         TF_PCMResponseNewModel.Stages rhg = new TF_PCMResponseNewModel.Stages();
         rhg.x_id='123';
         rhg.type_Z='test';        
         }
    
    private static testmethod void testChapter(){
         TF_PCMResponseNewModel.Chapter rhg = new TF_PCMResponseNewModel.Chapter();
         rhg.description='123';
         rhg.doiRegistrationStatus=true; 
         rhg.edition=1;
         rhg.firstPublishedYear='uii';
         rhg.pageEnd=1; 
        rhg.pageStart=1; 
        rhg.plannedPublicationDate='123';
         rhg.publicationDate='123';
         rhg.publisherImprint='123';
         rhg.subtitle='123';
        TF_PCMResponseNewModel.Copyright cpr = new TF_PCMResponseNewModel.Copyright();
        TF_PCMResponseNewModel.License lcs = new TF_PCMResponseNewModel.License();
        List<TF_PCMResponseNewModel.FundingGroups> fng = new List<TF_PCMResponseNewModel.FundingGroups>();
        List<TF_PCMResponseNewModel.Abstracts> abs = new List<TF_PCMResponseNewModel.Abstracts>();        
        
         }
    
    private static testmethod void testFormatsCount(){
         TF_PCMResponseNewModel.FormatsCount rhg = new TF_PCMResponseNewModel.FormatsCount();
         rhg.count=2;
         rhg.format='true'; 
    }
    
    
    private static testmethod void testSeries(){
        TF_PCMResponseNewModel.Series rhg = new TF_PCMResponseNewModel.Series();
        rhg.description='123';
        rhg.doiRegistrationStatus=true; 
        rhg.edition=1;
        rhg.firstPublishedYear='uii';
        rhg.citation='eee'; 
        rhg.inLanguage='eng'; 
        rhg.division='eng'; 
        rhg.divisionCode='eng'; 
        rhg.plannedPublicationDate='123';
        rhg.publicationDate='123';
        rhg.publisherImprint='123';
        rhg.subtitle='123';
        rhg.shortTitle='uii';
        rhg.status='uii';
        rhg.statuscode='uii';
        rhg.publisherAreaCode='uii';
        rhg.legalOwner='uii';
        rhg.formatCode='uii';
        rhg.publicationLocation='uii';
        rhg.publisherArea ='uii';
        TF_PCMResponseNewModel.Copyright cpr = new TF_PCMResponseNewModel.Copyright();
        List<TF_PCMResponseNewModel.Counts> cs = new List<TF_PCMResponseNewModel.Counts>();
        List<TF_PCMResponseNewModel.FundingGroups> fng = new List<TF_PCMResponseNewModel.FundingGroups>();
        List<TF_PCMResponseNewModel.Abstracts> abs = new List<TF_PCMResponseNewModel.Abstracts>();        
        
         }
    
    private static testmethod void testArea() {
        TF_PCMResponseNewModel.Area rhg = new TF_PCMResponseNewModel.Area ();
        rhg.code='test';
        rhg.name='test';       
    }
    
    private static testmethod void testAwardGroupDetails() {
        TF_PCMResponseNewModel.AwardGroupDetails  rhg = new TF_PCMResponseNewModel.AwardGroupDetails ();
        rhg.name='test';
        rhg.value='test';      
    }
    
    private static testmethod void testAffiliations() {
        TF_PCMResponseNewModel.Affiliations  rhg = new TF_PCMResponseNewModel.Affiliations();
        //TF_PCMResponseNewModel.Address ad = new TF_PCMResponseNewModel.Address();
        rhg.department='test';
        rhg.name ='test';
        rhg.locality ='test';
    }
    
    private static testmethod void testAssociatedMedia() {
        TF_PCMResponseNewModel.AssociatedMedia  rhg = new TF_PCMResponseNewModel.AssociatedMedia ();
        rhg.x_id='test';
        rhg.accessType ='test';
        rhg.location ='test';
        rhg.size =1;
        rhg.type_Z ='test';
    }
     private static testmethod void testBibliographicSpecification() {
         TF_PCMResponseNewModel.BibliographicSpecification  rhg = new TF_PCMResponseNewModel.BibliographicSpecification ();
        rhg.format ='test';  
        rhg.height ='test'; 
        rhg.weight ='test'; 
        rhg.width ='test'; 		
    }
    
    private static testmethod void testCopyright() {
        TF_PCMResponseNewModel.Copyright  rhg = new TF_PCMResponseNewModel.Copyright ();
        rhg.holder='test'; 
        rhg.statement ='test'; 
        rhg.year=2012; 		
    }
    
    private static testmethod void testFundingGroups() {
        TF_PCMResponseNewModel.FundingGroups  rhg = new TF_PCMResponseNewModel.FundingGroups ();
        TF_PCMResponseNewModel.AwardGroupDetails  aws = new TF_PCMResponseNewModel.AwardGroupDetails (); 
         rhg.fundingStatement ='test'; 		
    }
    
    private static testmethod void testKeywords() {
        TF_PCMResponseNewModel.Keywords  rhg = new TF_PCMResponseNewModel.Keywords ();
        rhg.name ='test';
         rhg.position =1; 
         rhg.type_Z ='test';
         rhg.weightage =1; 		
    }
    
    private static testmethod void testLicense() {
        TF_PCMResponseNewModel.License  rhg = new TF_PCMResponseNewModel.License ();
        rhg.description ='test';
        rhg.location ='test';
        rhg.type_Z ='test';        
    }
    
    private static testmethod void testProductionSpecification() {
        TF_PCMResponseNewModel.ProductionSpecification  rhg = new TF_PCMResponseNewModel.ProductionSpecification ();
        rhg.basicColor ='test';		
    }
    
    private static testmethod void testDates() {
        TF_PCMResponseNewModel.Dates  rhg = new TF_PCMResponseNewModel.Dates ();
        rhg.manuscriptAccepted ='test';
        rhg.manuscriptReceived='test';
        rhg.manuscriptRevised ='test';
        rhg.publishedOnline='test';
        rhg.publishedPrint ='test';		 
    }
      private static testmethod void testAvailability() {
        TF_PCMResponseNewModel.Availability  rhg = new TF_PCMResponseNewModel.Availability ();
        rhg.name ='test';
        //rhg.errors='test';
        //rhg.status ='test';
        }
}