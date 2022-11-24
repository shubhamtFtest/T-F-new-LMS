@isTest
public class ztest_TF_RuleBsedSearchResponseDocument {
    TFRuleBasedSearchResponseDocument.Metadata mt =new TFRuleBasedSearchResponseDocument.Metadata();
    private static testmethod void testcontributors(){
        TFRuleBasedSearchResponseDocument.Contributors cont = new TFRuleBasedSearchResponseDocument.Contributors();
        cont.email='TestName@gmail.com';
        cont.givenName='TestGivenName'; 
        cont.familyName ='TestFamilyName';
        cont.fullName='TestGivenName TestFamilyName';
        cont.bio='TestBio';
        cont.orcid='TestOrchid';
        //cont.role ='Editor';
        cont.position =1;
        cont.collab='Testcollab';
        TFRuleBasedSearchResponseDocument.Affiliation affs = new TFRuleBasedSearchResponseDocument.Affiliation();
        
    }
    
    private static testmethod void testcontributors_z(){
        TFRuleBasedSearchResponseDocument.Contributors_Z cont = new TFRuleBasedSearchResponseDocument.Contributors_Z();
        cont.email='TestName@gmail.com';
        cont.givenName='TestGivenName'; 
        cont.familyName ='TestFamilyName'; 
        cont.fullName='TestGivenName TestFamilyName';
        //cont.role ='Editor';
        cont.position =1;
        cont.bio='TestBio';
        cont.orcid='TestOrchid';
        cont.collab='Testcollab';
        TFRuleBasedSearchResponseDocument.Affiliation affs = new TFRuleBasedSearchResponseDocument.Affiliation();
    }
    
    
    private static testmethod void testQuery(){
        TFRuleBasedSearchResponseDocument.Query Query = new TFRuleBasedSearchResponseDocument.Query();
        Query.offset = 0;
        Query.limit_Z = 20;
        Query.type_Z = 'Book' ;
    }
    
    private static testmethod void testCounts(){
        TFRuleBasedSearchResponseDocument.Counts cnt = new TFRuleBasedSearchResponseDocument.Counts();
        cnt.x_id = '123';
        cnt.Count = 20;
        cnt.type_Z = 'Book' ;
    }
    
    
    private static testmethod void testMetaData(){
        TFRuleBasedSearchResponseDocument.MetaData mt = new TFRuleBasedSearchResponseDocument.MetaData();
        mt.application = 'SFDC';
        mt.isFromCache = true;
        mt.limit_Z = 30 ;
        mt.offset = 0 ;         
        mt.type_Z = 'Book' ;
    }
    
    private static testmethod void testPrices(){
        TFRuleBasedSearchResponseDocument.Prices price = new TFRuleBasedSearchResponseDocument.Prices();
        price.price = '3.89';
        price.X_currency = 'USD';
        price.validFrom = '12/10/18' ;
        price.priceType = 'BYO' ;         
        price.priceTypeCode = 'BYO' ;
    }    
    private static testmethod void testData(){ 
        TFRuleBasedSearchResponseDocument.Data TFContent= new TFRuleBasedSearchResponseDocument.Data();
        TFContent.id_Y='12345';
        TFContent.type_W='Book';
        TFContent.format ='chapter';
        TFContent.publicationDate ='22-11-12';
        TFContent.subtitle ='testSubtitle';
        TFContent.title ='testname';
        TFRuleBasedSearchResponseDocument.Prices prc = new TFRuleBasedSearchResponseDocument.Prices();
        TFRuleBasedSearchResponseDocument.contributors cnt = new TFRuleBasedSearchResponseDocument.contributors();
    }
    
    private static testmethod void testAffiliation(){ 
        TFRuleBasedSearchResponseDocument.Affiliation affl= new TFRuleBasedSearchResponseDocument.Affiliation();
        
        
    }
}