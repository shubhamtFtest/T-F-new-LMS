@IsTest
public class Ztest_TFGetProductsFromPCMById {
static testMethod void testParse() {
    
    TFGetProductsFromPCMById getPrd=new TFGetProductsFromPCMById();
    TFGetProductsFromPCMById.Keywords kws=new TFGetProductsFromPCMById.Keywords();
    kws.type_Z='book';
    kws.name='test';
    kws.position=1;
    kws.weightage='34';
    
    
    TFGetProductsFromPCMById.Categories cws=new TFGetProductsFromPCMById.Categories();
    cws.code='test';
    cws.name='test';
    cws.type_Z='chapter';
    
    TFGetProductsFromPCMById.Identifiers iws=new TFGetProductsFromPCMById.Identifiers();
    iws.doi='1234';
    iws.sku='sd43derrr';
    
    TFGetProductsFromPCMById.Prices prs=new TFGetProductsFromPCMById.Prices();
    prs.price=44;
    prs.currency_Z='GBP';
    prs.validFrom='07-10-89';
    prs.validTo='07-11-89';
    prs.priceType='Retail';
    prs.priceTypeCode='BYO';
    
    TFGetProductsFromPCMById.Copyright cpr=new TFGetProductsFromPCMById.Copyright();
    cpr.holder='India';
    cpr.year=1979;
    cpr.statement='test';
    
    TFGetProductsFromPCMById.Collection col=new TFGetProductsFromPCMById.Collection();
    col.subtitle='';
    col.description='';
    col.publisherImprint='';
    col.publicationDate='';
    col.edition='';
    col.doiRegistrationStatus=true;
    col.firstPublishedYear='test';
    col.plannedPublicationDate='test';
    col.inLanguage='test';
    col.citation='test';
    col.counts=new List<TFGetProductsFromPCMById.Counts>();
    col.copyright=new TFGetProductsFromPCMById.Copyright();
    col.abstracts=new List<TFGetProductsFromPCMById.FormatsCount>();
         
    TFGetProductsFromPCMById.Product prd=new TFGetProductsFromPCMById.Product();    
    prd.x_id='test';
    prd.type_Z='test';
    prd.version='test';
    prd.title='test';
    prd.collection=new TFGetProductsFromPCMById.Collection();
    prd.identifiers=new TFGetProductsFromPCMById.Identifiers();
    prd.prices=new List<TFGetProductsFromPCMById.prices>();
    prd.categories=new List<TFGetProductsFromPCMById.Categories>();
    prd.classifications=new List<TFGetProductsFromPCMById.FormatsCount>();
    prd.contributors=new List<TFGetProductsFromPCMById.FormatsCount>();
    prd.isPartOf=new List<TFGetProductsFromPCMById.FormatsCount>();
    prd.permissions=new List<TFGetProductsFromPCMById.FormatsCount>();
    prd.rights=new List<TFGetProductsFromPCMById.FormatsCount>();
    prd.audience=new List<TFGetProductsFromPCMById.FormatsCount>();
    prd.associatedMedia=new List<TFGetProductsFromPCMById.FormatsCount>();
    prd.keywords=new List<TFGetProductsFromPCMById.Keywords>();
    //prd.rights=new List<TFGetProductsFromPCMById.FormatsCount>();
    
    TFGetProductsFromPCMById.Counts cnt=new TFGetProductsFromPCMById.Counts(); 
    cnt.type_Z='test;';
    cnt.count=4;
    cnt.formatsCount=new List<TFGetProductsFromPCMById.FormatsCount>();
    //cnt.formatsCount=[];
    
    TFGetProductsFromPCMById.FormatsCount_Z fcnt=new TFGetProductsFromPCMById.FormatsCount_Z(); 
    fcnt.format='test';
    fcnt.count=4;
    
    TFGetProductsFromPCMById.FormatsCount fcn=new TFGetProductsFromPCMById.FormatsCount();
    
    }
}