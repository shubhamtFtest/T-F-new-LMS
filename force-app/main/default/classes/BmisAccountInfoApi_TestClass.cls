@isTest
public class BmisAccountInfoApi_TestClass {
	@isTest
    public static void func1()
    {
		BmisAccountInfoApi bmis=new BmisAccountInfoApi();
        //List<BmisAccountInfoApi.class_Data> listClsData=bmis.data;
        bmis.totalPages =2;
        bmis.pageSize = 2;
    }
}