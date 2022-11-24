@isTest
public class zTest_TFUnsiloDocument {
    
    private static testmethod void testConcepts_Z(){
        TFUnsiloDocument.Concepts_Z concepts = new TFUnsiloDocument.Concepts_Z();
        concepts.label = 'Poverty Law';
        concepts.state = 'DEFAULT';
        concepts.type_Z = 'MANUAL';
    }
    
    private static testmethod void testConcepts(){
        TFUnsiloDocument.Concepts concept = new TFUnsiloDocument.Concepts();
        concept.label = 'IC Development';
        concept.score = 12.395732;
    }
    
    private static testmethod void testAuthors(){
        TFUnsiloDocument.Authors authors = new TFUnsiloDocument.Authors();
        authors.firstName = 'Frank Ellis';
        authors.lastName = 'H. Ade Freeman';
    }
    
    private static testmethod void testExport_Z(){
        TFUnsiloDocument.Export_Z export_Z = new TFUnsiloDocument.Export_Z();
        export_Z.title = 'Goal 1 - No Poverty';
        export_Z.exportDate = '2019-01-28_11-07';
        export_Z.concepts = null ;
        export_Z.documents = null ;
    }
    
    private static testmethod void testDocuments(){
        TFUnsiloDocument fulldoc = new TFUnsiloDocument();
        fulldoc.export_Z = null;
        TFUnsiloDocument.Documents docs = new TFUnsiloDocument.Documents();
        TFUnsiloDocument.Authors author = new TFUnsiloDocument.Authors();
        author.firstName = 'Frank Ellis';
        author.lastName = 'H. Ade Freeman';
        List<TFUnsiloDocument.Authors> authors = new List<TFUnsiloDocument.Authors>();
        authors.add(author);
        TFUnsiloDocument.Concepts concept = new TFUnsiloDocument.Concepts();
        concept.label = 'IC Development';
        concept.score = 12.395732;
        List<TFUnsiloDocument.Concepts> concepts = new List<TFUnsiloDocument.Concepts>();
        concepts.add(concept);
        docs.authors = authors;
        docs.concepts = concepts;
        List<String> typesAry = new  List<String>();
        List<String> rightsAry = new  List<String>();
        typesAry.add('testType');
        rightsAry.add('testRights');
        
        docs.doi = '10.4324/9781315632445-12';
        docs.id = '9781317253051_10.4324/9781315632445-12';
        docs.journal = 'testjournal';
        docs.publicationDate = '2018-02-08' ;
        docs.publisher = 'Earthscan';
        docs.rights = rightsAry;
        docs.types = typesAry;
        docs.title = 'Concepts and Measurement';
        
    }
    
}