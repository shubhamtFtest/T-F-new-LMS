@isTest
public class zTest_SFDCCustomExceptionTest {
    
    public static testmethod void SFDCCustomException_String(){
       String testStr = 'test';
        Test.startTest();
        SFDCCustomException ex = new SFDCCustomException(testStr);
        Test.stopTest();
    }

}