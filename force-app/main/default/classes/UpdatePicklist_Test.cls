@isTest
public class UpdatePicklist_Test {
    static String str = 'Name,AccountNumber,Type,Accountsource,Industry\n Esha Patharabe,10001,Prospect,Test,Banking\n Esha Patharabe1,10001,Prospect,Test,Banking\n Trupti Nimje,10002,Prospect,Test,Banking';       
    
    public static String[] csvFileLines;
    public static Blob csvFileBody;
    
    static testmethod void testfileupload(){
        try{
            Test.startTest();       
            csvFileBody = Blob.valueOf(str);
            String csvAsString = csvFileBody.toString();
            csvFileLines = csvAsString.split('\n'); 
            
            UpdatePicklist importData = new UpdatePicklist();
            importData.csvFileBody = csvFileBody;
            importData.updatePicklistField_Product_Line();
            Test.stopTest();
        }catch(System.Exception e){
            
        }
    } 
    
    static testmethod void testfileuploadNegative(){
        try{
            Test.startTest();       
            csvFileBody = Blob.valueOf(str);
            String csvAsString = csvFileBody.toString();
            csvFileLines = csvAsString.split('\n'); 
            
            UpdatePicklist importData = new UpdatePicklist();
            importData.updatePicklistField_Product_Line();
            Test.stopTest();
        }catch(System.Exception e){
            
        }
    }
}