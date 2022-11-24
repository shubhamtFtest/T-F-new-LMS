global interface AccountRequestInterface {
	Account create(ResourceV1AccountRequest.AccountRequest input);
    void validateRequest(ResourceV1AccountRequest.AccountRequest input);
}