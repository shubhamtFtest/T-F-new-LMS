@IsTest
public class ztest_TFGetProductFromPCMById {
    static testMethod void testParse() {
        TFGetProductFromPCMById getPrd=new TFGetProductFromPCMById();
        
        getPrd.id='test';
        getPrd.type='test';
        getPrd.additionalType='test';
        getPrd.inLanguage='test';
        getPrd.version='test';
        getPrd.doi='test';
        getPrd.ean='test';
        getPrd.issn='test';
        getPrd.sku='test';
        getPrd.productID='test';
        getPrd.description='test';
        getPrd.dateCreated='07-11-80';
        getPrd.dateModified='07-11-80';
        getPrd.copyrightYear='2013';
        getPrd.publisher='test';
        getPrd.title='test';
        getPrd.subtitle='subtitle';
        getPrd.identifier=new list<TFGetProductFromPCMById.identifier>();
        getPrd.category=new list<TFGetProductFromPCMById.category>();
        getPrd.keywords=new list<TFGetProductFromPCMById.keywords>();
        getPrd.contributor=new list<TFGetProductFromPCMById.contributor>();
        getPrd.offers=new list<TFGetProductFromPCMById.offers>();
        getPrd.partsCount=new list<TFGetProductFromPCMById.partsCount>();
        
        TFGetProductFromPCMById.Contributor iws=new TFGetProductFromPCMById.Contributor();
        iws.familyName='1234';
        iws.familyName='sd43derrr';
        iws.name='sd43derrr';
        iws.role='sd43derrr';
        iws.position=1;
        
        
        TFGetProductFromPCMById.MediaTypeCount mtc=new TFGetProductFromPCMById.MediaTypeCount();
        mtc.mediaType='1234';
        mtc.count=4;
        
        TFGetProductFromPCMById.CopyrightHolder ctc=new TFGetProductFromPCMById.CopyrightHolder();
        ctc.name='test';
        
        TFGetProductFromPCMById.Offers ofc=new TFGetProductFromPCMById.Offers();
        ofc.price='34';
         ofc.priceCurrency='GBP';
         ofc.validFrom='07-10-88';
        
        TFGetProductFromPCMById.PartsCount ptc=new TFGetProductFromPCMById.PartsCount();
         ptc.type='34';
         ptc.count=6;
         ptc.mediaTypeCount=new List<TFGetProductFromPCMById.MediaTypeCount>();
        
        TFGetProductFromPCMById.Keywords ktc=new TFGetProductFromPCMById.Keywords();
         ktc.description='34';
         ktc.position=6;
         ktc.description='desc';
       
       
        
        
    }
}