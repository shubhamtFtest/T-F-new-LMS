//Test class-Ztest_TF_PCMResponseNewModel
public class TF_PCMResponseNewModel {
    
    public class prices {
        public String price {get;set;} 
        public String X_currency {get;set;}		
        public String priceTypeCode {get;set;} 
        public String priceType {get;set;} 
        public Integer productsCount {get;set;}
        public String validFrom {get;set;}         
    }
    
    public class Counts {
        public Integer count {get;set;} 
        public String type_Z {get;set;} // in json: type
        public List<FormatsCount> formatsCount {get;set;} 
        //public Integer limit_Z {get;set;} // in json: limit
        //public Integer offset {get;set;} 	
        
    }
    
    public Metadata metadata {get;set;} 
    public List<Data> data {get;set;} 
    
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
    
    public class Data {	
        public Product product {get;set;} 
        public List<Availability> availability {get;set;} 
    }
    
    public class Product {
        public String x_id {get;set;} // in json: _id
        public String type_Z {get;set;} // in json: type
        public String subType {get;set;}
        public String title {get;set;} 
        public String status {get;set;} 
        public List<Contributors> contributors {get;set;} 
        public List<categories> categories {get;set;} 
        public List<Classifications> Classifications {get;set;} 
        public Book book {get;set;} 
        public identifiers identifiers {get;set;}
        public List<Prices> prices {get;set;} 
        public List<IsPartOf> isPartOf {get;set;} 
        public creativeWork creativeWork {get;set;}
        public scholarlyArticle scholarlyArticle {get;set;}
        public collection collection {get;set;}
        public Chapter chapter {get;set;}
        public entryVersion entryVersion {get;set;}
        public List<permissions> permissions  {get;set;} 
       // public List<impressionLocations> impressionLocations {get;set;} 
        
    }
    
    
    public class Contributors {		
        public List<Affiliations> affiliations {get;set;} 
        public String bio {get;set;} 
        public String collab {get;set;} 
        public String email {get;set;} 
        public String familyName {get;set;} 
        public String fullName {get;set;} 
        public String givenName {get;set;} 
        public String orcid {get;set;} 
        public Integer position {get;set;} 
        public List<String> roles {get;set;} 
    }
    
    
    /*public class impressionLocations {	
        public distributionCenter distributionCenter {get;set;}
        
    }
    
    public class distributionCenter {
        public String code {get;set;} 
        public String location {get;set;} 
        public String status {get;set;} 
        public String statuscode {get;set;} 
    }*/
    
    public class Book {		
        public String publisherImprint {get;set;} 
        public String publicationDate {get;set;} 
        public String format {get;set;}        
        public List<Abstracts> abstracts {get;set;} 
        public BibliographicSpecification bibliographicSpecification {get;set;} 
        public String bindingStyle {get;set;} 
        public String bindingStyleCode {get;set;} 
        public String citation {get;set;} 
        public Copyright copyright {get;set;} 
        public List<Counts> counts {get;set;} 
        public String description {get;set;} 
        public String division {get;set;} 
        public String divisionCode {get;set;} 
        public Boolean doiRegistrationStatus {get;set;} 
        public Integer edition {get;set;} 
        public String firstPublishedYear {get;set;} 
        public String formatCode {get;set;} 
        public List<Audience> formerImprints {get;set;} 
        public List<FundingGroups> fundingGroups {get;set;} 
        public String inLanguage {get;set;} 
        public String legacyDivision {get;set;} 
        public String legalOwner {get;set;} 
        public License license {get;set;} 
        public String plannedPublicationDate {get;set;} 
        public ProductionSpecification productionSpecification {get;set;}
        public String publicationLocation {get;set;} 
        public String publisherArea {get;set;} 
        public String publisherAreaCode {get;set;} 
        public String shortTitle {get;set;} 
        public String status {get;set;} 
        public String statusCode {get;set;} 
        public String subtitle {get;set;} 
        public String textType {get;set;} 
        public String textTypeCode {get;set;} 
        public String toc {get;set;} 
        
        
    }
    public class identifiers {          
        public String articleId {get;set;} 
        public String articleSectionId {get;set;} 
        public String chapterId {get;set;} 
        public String code {get;set;} 
        public String dacKey {get;set;} 
        public String doi {get;set;} 
        public String editionId {get;set;} 
        public String isbn {get;set;} 
        public String orderNumber {get;set;} 
        public String productId {get;set;} 
        public String seriesCode {get;set;} 
        public String sku {get;set;} 
        public String titleId {get;set;}         
    }
    
    public class creativeWork {		
        public String publisherImprint {get;set;} 
        public String publicationDate {get;set;} 
        public String format {get;set;}  	
    }
    
    public class scholarlyArticle {		             
        public List<Abstracts> abstracts {get;set;} 
        public String articleSection {get;set;} 
        public String articleType {get;set;} 
        public Copyright copyright {get;set;} 
        public List<Counts> counts {get;set;} 
        public String currentVersion {get;set;} 
        public Boolean dataAvailability {get;set;} 
        public Dates dates {get;set;} 
        public String description {get;set;} 
        public List<FundingGroups> fundingGroups {get;set;} 
        public String inLanguage {get;set;} 
        public License license {get;set;} 
        public Integer orderInIssue {get;set;} 
        public Integer pageEnd {get;set;} 
        public Integer pageStart {get;set;} 
        public String publicationDate {get;set;} 
        public String publisherImprint {get;set;} 
        public List<Stages> stages {get;set;} 
        public String subtitle {get;set;} 
    }
    
    public class collection {	       
        public String format {get;set;}          
        public List<Abstracts> abstracts {get;set;} 
        public Copyright copyright {get;set;} 
        public List<Counts> counts {get;set;} 
        public String description {get;set;} 
        public Integer firstPublishedYear {get;set;} 
        public String inLanguage {get;set;} 
        public String plannedPublicationDate {get;set;} 
        public String publicationDate {get;set;} 
        public String publisherImprint {get;set;} 
        public String subtitle {get;set;} 
        public String updatedFrom {get;set;} 
        public String updatedTo {get;set;} 
        public String validFrom {get;set;} 
        public String validTo {get;set;} 
    }
    
    public class entryVersion {		
        public String publisherImprint {get;set;} 
        public String publicationDate {get;set;} 
         	
    }
    
    public class Rights {
        public List<Area> area {get;set;} 
        public String category {get;set;} 
        public String iso2 {get;set;} 
        public String iso3 {get;set;} 
        public String isonum {get;set;} 
        public String name {get;set;} 
        public String type_Z {get;set;} // in json: type		
    }
    
    public class Abstracts {
        public String location {get;set;} 
        public String source {get;set;} 
        public String type_Z {get;set;} // in json: type
        public String value {get;set;} 		
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
    public class Set_Z {
        public List<Abstracts> abstracts {get;set;} 
        public BibliographicSpecification bibliographicSpecification {get;set;} 
        public String bindingStyle {get;set;} 
        public String bindingStyleCode {get;set;} 
        public String citation {get;set;} 
        public Copyright copyright {get;set;} 
        public List<Counts> counts {get;set;} 
        public String description {get;set;} 
        public String division {get;set;} 
        public String divisionCode {get;set;} 
        public Boolean doiRegistrationStatus {get;set;} 
        public Integer edition {get;set;} 
        public String firstPublishedYear {get;set;} 
        public String format {get;set;} 
        public String formatCode {get;set;} 
        public List<Audience> formerImprints {get;set;} 
        public Integer impressionNo {get;set;} 
        public String inLanguage {get;set;} 
        public String legacyDivision {get;set;} 
        public String legalOwner {get;set;} 
        public String plannedPublicationDate {get;set;} 
        public ProductionSpecification productionSpecification {get;set;} 
        public String publicationDate {get;set;} 
        public String publicationLocation {get;set;} 
        public String publisherArea {get;set;} 
        public String publisherAreaCode {get;set;} 
        public String publisherImprint {get;set;} 
        public String shortTitle {get;set;} 
        public String status {get;set;} 
        public String statusCode {get;set;} 
        public String subtitle {get;set;} 
        public String textType {get;set;} 
        public String textTypeCode {get;set;} 
        public String toc {get;set;} 		
    }
    
    public class Availability {
        public List<String> errors {get;set;} 
        public String name {get;set;} 
        public List<String> status {get;set;} 		
    }
    
    public class Classifications {
        public String code {get;set;} 
        public String group_Z {get;set;} // in json: group
        public Integer level {get;set;} 
        public String name {get;set;} 
        public Integer priority {get;set;} 
        public String type_Z {get;set;} // in json: type       
     }
    
    public class Audience {
        public String code {get;set;} 
        public String description {get;set;}     
    }
    
    public class Categories {
        public String code {get;set;} 
        public String name {get;set;} 
        public String type_Z {get;set;} // in json: type       
    }
    
    public class IsPartOf {
        public String x_id {get;set;} // in json: _id
        public Integer level {get;set;} 
        public Integer position {get;set;} 
        public String title {get;set;} 
        public String type_Z {get;set;} // in json: type    
        public identifiers identifiers {get;set;}

    }
    
    public class Stages {
        public String x_id {get;set;} // in json: _id
        public String type_Z {get;set;} // in json: type		
    }
    
    public class Chapter {
        public List<Abstracts> abstracts {get;set;} 
        public String citation {get;set;} 
        public Copyright copyright {get;set;} 
        public String description {get;set;} 
        public Boolean doiRegistrationStatus {get;set;} 
        public Integer edition {get;set;} 
        public String firstPublishedYear {get;set;} 
        public List<FundingGroups> fundingGroups {get;set;} 
        public String inLanguage {get;set;} 
        public License license {get;set;} 
        public Integer pageEnd {get;set;} 
        public Integer pageStart {get;set;} 
        public String plannedPublicationDate {get;set;} 
        public String publicationDate {get;set;} 
        public String publisherImprint {get;set;} 
        public String subtitle {get;set;}
        public String status {get;set;} 
    }
    
    public class FormatsCount {
        public Integer count {get;set;} 
        public String format {get;set;} 		
    }
    
    public class Series {
        public List<Abstracts> abstracts {get;set;} 
        public String citation {get;set;} 
        public Copyright copyright {get;set;} 
        public List<Counts> counts {get;set;} 
        public String description {get;set;} 
        public String division {get;set;} 
        public String divisionCode {get;set;} 
        public Boolean doiRegistrationStatus {get;set;} 
        public Integer edition {get;set;} 
        public String firstPublishedYear {get;set;} 
        public String format {get;set;} 
        public String formatCode {get;set;} 
        public String inLanguage {get;set;} 
        public String legalOwner {get;set;} 
        public String plannedPublicationDate {get;set;} 
        public String publicationDate {get;set;} 
        public String publicationLocation {get;set;} 
        public String publisherArea {get;set;} 
        public String publisherAreaCode {get;set;} 
        public String publisherImprint {get;set;} 
        public String shortTitle {get;set;} 
        public String status {get;set;} 
        public String statusCode {get;set;} 
        public String subtitle {get;set;}  
    }
    
    public class Area {
        public String code {get;set;} 
        public String name {get;set;}      
    }
    
    public class AwardGroupDetails {
        public String name {get;set;} 
        public String value {get;set;}      
    }
    
    public class Affiliations {
        public Address address {get;set;} 
        public String department {get;set;} 
        public String name {get;set;}  
        public String locality {get;set;} 
    }
    
    public class AssociatedMedia {
        public String x_id {get;set;} // in json: _id
        public String accessType {get;set;} 
        public String location {get;set;} 
        public Integer size {get;set;} 
        public String type_Z {get;set;} // in json: type		
    }
    
    
    public class BibliographicSpecification {
        public String format {get;set;} 
        public String height {get;set;} 
        public String weight {get;set;} 
        public String width {get;set;} 		
    }
    
    public class Copyright {
        public String holder {get;set;} 
        public String statement {get;set;} 
        public Integer year {get;set;} 		
    }
    
    public class FundingGroups {
        public List<AwardGroupDetails> awardGroupDetails {get;set;} 
        public String fundingStatement {get;set;} 		
    }
    
    public class Keywords {
        public String name {get;set;} 
        public Integer position {get;set;} 
        public String type_Z {get;set;} // in json: type
        public Integer weightage {get;set;} 		
    }
    
    public class License {
        public String description {get;set;} 
        public String location {get;set;} 
        public String type_Z {get;set;} // in json: type        
    }
    
    public class ProductionSpecification {
        public String basicColor {get;set;} 		
    }
    
    public class Dates {
        public String manuscriptAccepted {get;set;} 
        public String manuscriptReceived {get;set;} 
        public String manuscriptRevised {get;set;} 
        public String publishedOnline {get;set;} 
        public String publishedPrint {get;set;}		 
    }
    
    public static TF_PCMResponseNewModel parse(String json) {
        return (TF_PCMResponseNewModel) System.JSON.deserialize(json, TF_PCMResponseNewModel.class);
    }
}