@isTest
public class TF_AG_OrderHistorySearchJsonPush_test 
{
    @isTest
    private static void func1()
    {        
        TF_AG_OrderHistorySearchJsonPush.OrderData_Class obj1 = new TF_AG_OrderHistorySearchJsonPush.OrderData_Class();
        obj1.accountId = 'accountId';
        obj1.orderId = 'orderId';
        obj1.poNumber = 'poNumber';
        obj1.orderDate = 'orderDate';
        obj1.orderValue = 'orderValue';
        obj1.isbn = 'isbn';
        obj1.quantity = 'quantity';
        obj1.orderStatus = 'orderStatus';
        obj1.titleStatus = 'titleStatus';
        obj1.replenType = 'replenType';
        obj1.trackingNumber = 'trackingNumber';
        obj1.type = 'type';
        
        system.debug('object details '+obj1);
        
        TF_AG_OrderHistorySearchJsonPush obj = new TF_AG_OrderHistorySearchJsonPush();
        obj.page = 'page';
        obj.totalPages = 'totalPages';
        obj.pageSize = 'pageSize';
        //obj.data.add(obj1);
    }
    
}