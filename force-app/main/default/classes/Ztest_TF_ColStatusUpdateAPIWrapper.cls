@isTest
public class Ztest_TF_ColStatusUpdateAPIWrapper {
TF_CollectionStatusUpdateAPIWrapper colstatus=new TF_CollectionStatusUpdateAPIWrapper();
   
    
    static testMethod void testParse() {
        TF_CollectionStatusUpdateAPIWrapper.Messages msg=new TF_CollectionStatusUpdateAPIWrapper.Messages();
        msg.code='test';
        msg.description='test';
        msg.dataPath='test';
        
        
        TF_CollectionStatusUpdateAPIWrapper.Metadata meta=new TF_CollectionStatusUpdateAPIWrapper.Metadata();
        meta.status='test';
        meta.transactionId='test';
        meta.id='test';
        meta.type_Z='test';
        meta.transactionDate='test';
        meta.messages=new List<TF_CollectionStatusUpdateAPIWrapper.Messages>();
        meta.isPartOf=new List<String>();
        
        TF_CollectionStatusUpdateAPIWrapper.Collection col=new TF_CollectionStatusUpdateAPIWrapper.Collection();
        col.version='test';
        col.status='test';
        
        TF_CollectionStatusUpdateAPIWrapper.Data dt=new TF_CollectionStatusUpdateAPIWrapper.Data();
        dt.id='test';
        dt.type_Z='test';
        dt.identifiers=new TF_CollectionStatusUpdateAPIWrapper.identifiers();
        dt.collection=new TF_CollectionStatusUpdateAPIWrapper.collection();
        
        TF_CollectionStatusUpdateAPIWrapper.Identifiers Idt=new TF_CollectionStatusUpdateAPIWrapper.Identifiers();
        Idt.doi='test';
        Idt.sku='test';
        Idt.collectionId='test';
        
       
        
        
        
        
    }
}