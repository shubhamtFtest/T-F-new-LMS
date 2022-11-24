public class TF_CallOhResponse {
    //  response  
    public metadata metadata{get;set;}
    public data data{get;set;}
    public class metadata{
        public Integer code{get;set;}
        public String message{get;set;}
    }
    public class data{
        public String orderNumber{get;set;}
        public String listOfOrderNumber{get;set;}
    }
}