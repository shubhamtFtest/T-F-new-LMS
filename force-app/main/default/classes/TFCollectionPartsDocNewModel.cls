//test class-- ztest_TFCollectionPartsDocNewModel
public class TFCollectionPartsDocNewModel {
    public String id {get;set;} // in json: _id
    public String type {get;set;} // in json: type
    public Integer position {get;set;} 
    public Integer level {get;set;} 
    public String version {get;set;} 
    public Boolean isFree {get;set;}
    public String title {get;set;}
    public Identifiers identifiers {get;set;} 
    public List<Contributors> contributors {get;set;} 
    public Book book {get;set;} 
    public creativeWork creativeWork {get;set;} 
    public collection collection {get;set;} 
    public chapter chapter {get;set;} 
    public entryVersion entryVersion {get;set;}
    public scholarlyArticle scholarlyArticle {get;set;} 
    public String format {get;set;} 
    
    //Added by Geetika for PCH-3712
    public List<Data> data {get;set;} 
    public Metadata metadata {get;set;}
    
    public class Data {	
        public String x_id {get;set;} // in json: _id
        public String type_Z {get;set;} // in json: type
        public String subType {get;set;}
        public String title {get;set;} 
        public String status {get;set;} 
        public Boolean isFree {get;set;}
        public List<Contributors> contributors {get;set;}  
        public Book book {get;set;} 
        public identifiers identifiers {get;set;}
        public List<Prices> prices {get;set;}  
        public creativeWork creativeWork {get;set;}
        public scholarlyArticle scholarlyArticle {get;set;}
        public collection collection {get;set;}
        public Chapter chapter {get;set;}
        public entryVersion entryVersion {get;set;}
        public List<permissions> permissions  {get;set;} 
    }
    
    public class Metadata {
        public List<Counts> counts {get;set;} 
        public List<Prices> prices {get;set;} 
        public Integer limit_Z {get;set;} // in json: limit
        public Integer offset {get;set;} 	
        public String nextPageCursor {get;set;}
        public String prevPageCursor {get;set;}
        public String lastPageCursor {get;set;}
        public String type_Z {get;set;} // in json: type		
    }
    
    public class Counts {
        public Integer count {get;set;} 
        public String type_Z {get;set;} // in json: type
        public List<FormatsCount> formatsCount {get;set;}  	
        
    }
    
    public class FormatsCount {
        public Integer count {get;set;} 
        public String format {get;set;} 		
    }
    
    public class Permissions {
        public String code {get;set;} 
        public String description {get;set;} 
        public String name {get;set;} 
        public String text {get;set;} 
        public String type_Z {get;set;} // in json: type
        public String validFrom {get;set;} 
        public String validTo {get;set;} 		
    }
    
    public class prices {
        public String price {get;set;} 
        public String X_currency {get;set;}		
        public String priceTypeCode {get;set;} 
        public String priceType {get;set;} 
        public Integer productsCount {get;set;}
        public String validFrom {get;set;}         
    } // end for PCH-3712
    
    public class Book {
        public String subtitle {get;set;} 
        public String publisherImprint {get;set;} 
        public String publicationDate {get;set;} 
        public String format {get;set;} 
    }
    
    public class creativeWork{
        public String subtitle {get;set;} 
        public String publisherImprint {get;set;} 
        public String publicationDate {get;set;} 
        public String format {get;set;} 
    }
    
    public class collection{
        public String subtitle {get;set;} 
        public String publisherImprint {get;set;} 
        public String publicationDate {get;set;} 
    }
    
    public class scholarlyArticle{
        public String subtitle {get;set;} 
        public String publisherImprint {get;set;} 
        public String publicationDate {get;set;} 
    }
    
     public class chapter{
        public String subtitle {get;set;} 
        public String publisherImprint {get;set;} 
        public String publicationDate {get;set;} 
    }
    
    public class entryVersion {		
        public String publisherImprint {get;set;} 
        public String publicationDate {get;set;} 
         	
    }
    
    public class Contributors {
        public List<String> roles {get;set;} 
        public String fullName {get;set;} 		
    }
    
    public class Identifiers {
        public String doi {get;set;} 		
    }
    
    
    public static TFCollectionPartsDocNewModel parse(String json) {
        return (TFCollectionPartsDocNewModel) System.JSON.deserialize(json, TFCollectionPartsDocNewModel.class);
    }
}