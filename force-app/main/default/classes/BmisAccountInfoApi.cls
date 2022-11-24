global class BmisAccountInfoApi{
    public List<class_Data> data;
    public Integer page;	//1
    public Integer totalPages;	//1
    public Integer pageSize;	//1
    public class class_Data {
        public String saleRegion;	//US
        public String accountId;	//C-703472
        public String address1;	//UNIV OF MISSOURI
        public String address2;	//RELIGIOUS STUDIES
        public String address3;	//221 ARTS  ATN:C DUNN
        public String County;
        public String postCode;	//65211
        public String telephone;	//573 882-4769
        public String creditTerms;	//0
        public String discountCode;	//P
    }
    global BmisAccountInfoApi(){
        
    }
    /*public static BmisAccountInfoApi parse(String json){
        return (BmisAccountInfoApi) System.JSON.deserialize(json, BmisAccountInfoApi.class);
    }*/
}