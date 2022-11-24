public class TFUnsiloDocument {
    
    public class Authors {
        public String lastName {get;set;} 
		public String firstName {get;set;}

    }
    
    public class Concepts {
        public String label {get;set;} 
        public Double score {get;set;} 
    }
    
    public class Documents {
        public String publisher {get;set;} 
        public String doi {get;set;} 
        public String id {get;set;} 
        public String journal {get;set;} 
        public String publicationDate {get;set;} 
        public String title {get;set;} 
        public List<Authors> authors {get;set;} 
        public List<Concepts> concepts {get;set;} 
        public List<String> rights {get;set;}
		public list<String> types{get;set;}
    }
    
    public class Concepts_Z {
        public String label {get;set;} 
        public String state {get;set;} 
        public String type_Z {get;set;} // in json: type
    }
    
    public class Export_Z {
        public String title {get;set;} 
        public String exportDate {get;set;} 
        public List<Documents> documents {get;set;} 
        public List<Concepts_Z> concepts {get;set;} 
    }
    
    public Export_Z export_Z {get;set;} // in json: export
    
}