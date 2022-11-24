public class TFContentCuratorDocument {

	
	
	public String x_id {get;set;} // in json: _id
	public String dateModified {get;set;} 
	public String id {get;set;} // in json: @id
	public String type {get;set;} // in json: @type
	public String additionalType {get;set;} 
	//public String name {get;set;} 
	public String title {get;set;} 
	public String isPartOf {get;set;} 
	public String format {get;set;} 
	public String edition {get;set;} 
	public String inLanguage {get;set;} 
	public String version {get;set;} 
	public String isAlignedTo {get;set;} 
	public String doi {get;set;} 
	public String chapterDOI {get;set;} 
	public String description {get;set;} 
	public String datePublished {get;set;} 
	public String CopyrightYear {get;set;} 
	public String publisher {get;set;} 
	public String abstract_Z {get;set;} // in json: abstract
	public Integer x_v {get;set;} // in json: __v
	public String url {get;set;} 
    public List<Contributor> contributor {get;set;} 
    public List<Keywords> keywords {get;set;} 
    public String mediaType {get;set;}


	public class Contributor {
		public String name {get;set;} 
		public String givenName {get;set;} 
		public String familyName {get;set;} 
		//public String role {get;set;} 
		public Integer position {get;set;} 
	
	}
    
    	public class Keywords {
		public String name {get;set;} 
		public String description {get;set;} 
		public Integer position {get;set;} 
        }
	
    
}