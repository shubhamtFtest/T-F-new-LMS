@IsTest
public class ztest_TFCollectionPartsDocNewModel {

static testMethod void testParse() {
	TFCollectionPartsDocNewModel getPrd=new TFCollectionPartsDocNewModel();
    getPrd.id='test';
    getPrd.type='test';
    getPrd.position=9;
    getPrd.level=8;
    getPrd.version='test';
    getPrd.isFree=true;
    getPrd.title='test';
    getPrd.format='test';
    getPrd.contributors=new List<TFCollectionPartsDocNewModel.Contributors>();
    getPrd.identifiers=new TFCollectionPartsDocNewModel.Identifiers();
    getPrd.book=new TFCollectionPartsDocNewModel.Book();
    getPrd.creativeWork=new TFCollectionPartsDocNewModel.creativeWork();
    getPrd.collection=new TFCollectionPartsDocNewModel.collection();
    getPrd.chapter=new TFCollectionPartsDocNewModel.chapter();
    getPrd.scholarlyArticle=new TFCollectionPartsDocNewModel.ScholarlyArticle();
    
    //Added by Geetika for PCH-3712
    getPrd.data=new List<TFCollectionPartsDocNewModel.Data>();
    getPrd.metadata=new TFCollectionPartsDocNewModel.Metadata();
    
    TFCollectionPartsDocNewModel.Data getData=new TFCollectionPartsDocNewModel.Data();
    getData.x_id='test';
    getData.type_Z='test';
    getData.subType='test';
    getData.title='test';
    getData.status='test';
    getData.isFree=false;
    getData.identifiers=new TFCollectionPartsDocNewModel.Identifiers();
    getData.book=new TFCollectionPartsDocNewModel.Book();
    getData.creativeWork=new TFCollectionPartsDocNewModel.creativeWork();
    getData.collection=new TFCollectionPartsDocNewModel.collection();
    getData.chapter=new TFCollectionPartsDocNewModel.chapter();
    getData.scholarlyArticle=new TFCollectionPartsDocNewModel.ScholarlyArticle();
    getData.contributors=new List<TFCollectionPartsDocNewModel.Contributors>();
    getData.entryVersion=new TFCollectionPartsDocNewModel.entryVersion();
    getData.permissions=new List<TFCollectionPartsDocNewModel.Permissions>();
    getData.prices=new List<TFCollectionPartsDocNewModel.prices>();
    
    TFCollectionPartsDocNewModel.Metadata getMetadata=new TFCollectionPartsDocNewModel.Metadata();
    getMetadata.counts=new List<TFCollectionPartsDocNewModel.Counts>();
    getMetadata.prices=new List<TFCollectionPartsDocNewModel.prices>();
    getMetadata.limit_Z=500;
    getMetadata.offset=0;
    getMetadata.nextPageCursor='next';
    getMetadata.prevPageCursor='previous';
    getMetadata.lastPageCursor='last';
    getMetadata.type_Z='total';
    
    TFCollectionPartsDocNewModel.Counts getCount=new TFCollectionPartsDocNewModel.Counts();
    getCount.count=200;
    getCount.type_Z='total';
    getCount.formatsCount=new List<TFCollectionPartsDocNewModel.FormatsCount>();
    
    
    TFCollectionPartsDocNewModel.FormatsCount getCountFormat=new TFCollectionPartsDocNewModel.FormatsCount();
    getCountFormat.count=2;
    getCountFormat.format='total';
    
    TFCollectionPartsDocNewModel.Permissions getPermissions=new TFCollectionPartsDocNewModel.Permissions();
    getPermissions.code='rfm';
    getPermissions.description='ready for marketing';
    getPermissions.name='rfm';
    getPermissions.text='rfm';
    getPermissions.type_Z='permission';
    getPermissions.validFrom='test';
    getPermissions.validTo='test';
    
    TFCollectionPartsDocNewModel.prices getPrices=new TFCollectionPartsDocNewModel.prices();
    getPrices.price='190';
    getPrices.priceType='BYO Library Price';
    getPrices.priceTypeCode='BYO';
    getPrices.productsCount=2;
    getPrices.validFrom='2021-06-16T00:00:00.000Z';
    getPrices.X_currency='USD';
    //end for PCH-3712
    
    TFCollectionPartsDocNewModel.Book getbook=new TFCollectionPartsDocNewModel.Book();
    getbook.subtitle='test';
    getbook.publisherImprint='test';
    getbook.publicationDate='test';
    getbook.format='test';
    
    TFCollectionPartsDocNewModel.creativeWork getcreativeWork=new TFCollectionPartsDocNewModel.creativeWork();
    getcreativeWork.subtitle='test';
    getcreativeWork.publisherImprint='test';
    getcreativeWork.publicationDate='test';
    getcreativeWork.format='test';
    
    
    TFCollectionPartsDocNewModel.collection getcollection=new TFCollectionPartsDocNewModel.collection();
    getcollection.subtitle='test';
    getcollection.publisherImprint='test';
    getcollection.publicationDate='test';
    
    TFCollectionPartsDocNewModel.scholarlyArticle getscholarlyArticle=new TFCollectionPartsDocNewModel.scholarlyArticle();
    getscholarlyArticle.subtitle='test';
    getscholarlyArticle.publisherImprint='test';
    getscholarlyArticle.publicationDate='test';
    
    
    TFCollectionPartsDocNewModel.chapter getchapter=new TFCollectionPartsDocNewModel.chapter();
    getchapter.subtitle='test';
    getchapter.publisherImprint='test';
    getchapter.publicationDate='test';
    
    
    
    TFCollectionPartsDocNewModel.Identifiers getIdentifiers=new TFCollectionPartsDocNewModel.Identifiers();
    getIdentifiers.doi='test';
    
    TFCollectionPartsDocNewModel.Contributors getContributors=new TFCollectionPartsDocNewModel.Contributors();
    getContributors.fullName='test';
    getContributors.roles=new List<String>();
    
    
    TFCollectionPartsDocNewModel.entryVersion getEntryVersion=new TFCollectionPartsDocNewModel.entryVersion();
    getEntryVersion.publisherImprint='test';
    getEntryVersion.publicationDate='test';
    
    
    //TFGetProductsFromPCMById.Keywords kws=new TFGetProductsFromPCMById.Keywords();
	}
}