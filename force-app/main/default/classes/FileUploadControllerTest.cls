@istest
private class FileUploadControllerTest
 {
   static testMethod void saveChunk()
   {
       test.startTest();
        Case cas = new Case();
        cas.Status = 'New';       
        insert cas;
        test.stopTest();
       
   }
     
     
    static testMethod void testSaveTheFile_ReturnId() {
        test.startTest();
        Case cas = new Case();
        cas.Status = 'New';       
        insert cas;
        string fileid='';
        Blob b = Blob.valueOf('Test Data');   
       fileid=  FileUploadController.saveTheFile(cas.id,'Test Attachment for Parent','Test Data','text/css');     
        
        System.assert(fileid!= null);
        test.stopTest();
        
        
    } 
    
    
     static testMethod void testappendToFile() {
        test.startTest();
         String base64Data='';
        Case cas = new Case();
        cas.Status = 'New';       
        insert cas;
        string fileid='';
        Blob b = Blob.valueOf('Test Data');   
       fileid=  FileUploadController.saveTheFile(cas.id,'test2','Test Data1','text/css');  
         FileUploadController.appendToFile(fileid, 'Testingappend');
         base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8'); 
        
        
        System.assert(fileid!= null);
        test.stopTest();
        
        
    } 
    
    
    
   
       
       
}