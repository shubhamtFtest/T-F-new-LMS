@isTest
public class ztest_TFContentCuratorDocument {
    
    private static testmethod void testcontributors(){
        TFContentCuratorDocument.Contributor cont = new TFContentCuratorDocument.Contributor();
        cont.name='TestName';
        cont.givenName='TestGivenName'; 
        cont.familyName ='TestFamilyName';
        //cont.role ='Editor';
        cont.position =1;
    }
    
    private static testmethod void testKeyWords(){
        TFContentCuratorDocument.Keywords keyWords = new TFContentCuratorDocument.Keywords();
        keyWords.description = 'test';
        keyWords.name = 'test';
        keyWords.position = 1 ;
    }
    
    private static testmethod void testbasicfields(){ 
        TFContentCuratorDocument TFContent= new TFContentCuratorDocument();
        TFContent.x_id='12345';
        TFContent.dateModified='22-11-12';
        TFContent.id ='567';
        TFContent.type ='static';
        TFContent.additionalType ='alt';
        TFContent.title ='testname';
        TFContent.isPartOf='UNSDG';
        TFContent.format ='test';
        TFContent.edition='first';
        TFContent.inLanguage='eng';
        TFContent.version ='1.0.0';
        TFContent.isAlignedTo ='test';
        TFContent.doi='123';
        TFContent.chapterDOI='456';
        TFContent.description='desc';
        TFContent.datePublished='22-11-12';
        TFContent.CopyrightYear='2018';
        TFContent.publisher='T&F';
        TFContent.abstract_Z='abs';
        TFContent.x_v=124;
        TFContent.url='www.test.com';    
        TFContent.contributor = null;
        TFContent.keywords = null;
        TFContent.mediaType='doc';
    }
}