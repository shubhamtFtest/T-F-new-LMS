global interface IndividualCustomerInterface {
  //create PersonAccount
  Account create(Map<String,Object> input);
  Account convert(String emailID, String partyId);
    void validateRequest(Map<String,Object> input);
    
}