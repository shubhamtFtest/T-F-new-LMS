@isTest
public class zTEST_TF_CallOhResponse {
    @isTest
    public static void callOhResponseTest(){
        
        TF_CallOhResponse.metadata  metadata = new TF_CallOhResponse.metadata();
        metadata.code =200;
        metadata.message='Test';
        
        TF_CallOhResponse.data  data = new TF_CallOhResponse.data();
        data.listOfOrderNumber ='Test';
        data.orderNumber='Test';
        
        TF_CallOhResponse TF_CallOhResponseObj = new TF_CallOhResponse();
        TF_CallOhResponse.metadata  metadataa=  TF_CallOhResponseObj.metadata;
        TF_CallOhResponse.data  dataa = TF_CallOhResponseObj.data;
        
    }
}