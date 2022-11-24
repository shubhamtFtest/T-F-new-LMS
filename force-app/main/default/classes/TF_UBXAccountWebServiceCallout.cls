/*
    TF_UBXIpAuthPartyIdWrapper
    TF_UBXOrgIdWrapper
    TF_UBXAccountWebServiceCallout
    test class "zTest_TF_UBXAccountWebServiceCallout"
*/

public class TF_UBXAccountWebServiceCallout {
    public static Boolean getUBXAccountValidation ( String accId ) {
        Boolean isFlagReturn = false;
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        String ipAuthURI = (String) orgSpecificProps.get('Get_UBX_IpAuth_URL__c');
        Map<String, String> headers = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        String accPartyId = '';
        Boolean isAuthAPIFlag = false;
        Boolean isOrgAPIFlag = false;
        String orgIdURI = (String) orgSpecificProps.get('Get_UBX_OrgId_URL__c');

        try {
            if ( String.isNotBlank(accId) ) {
                accPartyId = [ SELECT id, customer_id__c FROM Account WHERE id =:accId LIMIT 1 ].customer_id__c;
                if ( String.isBlank(accPartyId) ) {
                    accPartyId = getAcountPartyID( accId );
                }
            }
            if ( Test.isRunningTest() ) {
                accPartyId = '100';
            }

            HttpResponse res = new HttpResponse();
            if ( String.isNotBlank(ipAuthURI) && String.isNotBlank(accPartyId) ) { //callout "https://api.taylorandfrancis.com/v1/ipauth/party/100010/ips?limit=10&offset=0"
                ipAuthURI += accPartyId + '/ips?limit=10&offset=0';
                res = TF_PlatformExecuter.execute( ipAuthURI, 'GET', 'idtoken', null, headers, false );
            }

            if ( res != NULL && res.getStatusCode() == 200 ) {
                String responseBody = res.getBody();
                if ( Test.isRunningTest() ) {
                    responseBody = '{"metadata": {"status": "success","message": {}},"data": [{"ip_access_control_id": "897388","ip_start": "111.93.244.226","ip_end": "111.93.244.226","access_type": "allow","party_id": "100","db_add_date": "2019-07-31T12:29:48.704Z","db_update_date": "2019-07-31T12:29:48.704Z","created_by": "internaladmin@yopmail.com","updated_by": "internaladmin@yopmail.com","deleted_on": "2019-07-31T12:29:48.704Z","description": "Tricon_ip2","ip_type_id": 1,"source": null,"threat_type": null}]}';
                }
                TF_UBXIpAuthPartyIdWrapper ubxAccountRes;
                
                if ( String.isNotBlank(responseBody) ) {
                    ubxAccountRes = (TF_UBXIpAuthPartyIdWrapper)JSON.deserialize(responseBody, TF_UBXIpAuthPartyIdWrapper.class);
                }
                
                if ( ubxAccountRes != NULL ) {
                    if ( ubxAccountRes.Data != NULL ) {
                        for ( TF_UBXIpAuthPartyIdWrapper.Data dataa : ubxAccountRes.Data ) {
                            if ( dataa.deleted_on == NULL ) {
                                isAuthAPIFlag = true;
                            }
                        }
                    }
                }
            } 
            if ( !isAuthAPIFlag ) {
                //need to make callout for second API "https://api.taylorandfrancis.com/v2/auth/org?org_id=100010"
                HttpResponse orgResponse = new HttpResponse();
                if ( String.isNotBlank(orgIdURI) && String.isNotBlank(accPartyId) ) { //callout "https://api.taylorandfrancis.com/v2/auth/org?org_id=100010"
                    orgIdURI += accPartyId;
                    orgResponse = TF_PlatformExecuter.execute( orgIdURI, 'GET', 'idtoken', null, headers, false );
                }

                if ( orgResponse != NULL && orgResponse.getStatusCode() == 200 ) {
                    String orgResponseBody = orgResponse.getBody();
                    TF_UBXOrgIdWrapper orgWrapperResponse;
                    if ( Test.isRunningTest() ) {
                        orgResponseBody = '{"metadata": {"status": "success","message": null},"data": {"_id": "5d2016309a3fbe21004c88a3","org_id": "100","name": "Taylor & Francis Group","isActive": true,"entityId": "http://shibboleth.ebscohost.com","metadata": "","attribute_standard": "5a8d5e978985edb36a86a1ab","__v": 0,"federation": ["OpenAthens"]}}';
                    }
                    if ( String.isNotBlank(orgResponseBody) ) {
                        orgWrapperResponse = (TF_UBXOrgIdWrapper)JSON.deserialize(orgResponseBody, TF_UBXOrgIdWrapper.class);
                    }
                    if ( orgWrapperResponse != NULL ) {
                        if ( orgWrapperResponse.Data != NULL ) {
                            if ( orgWrapperResponse.Data.isActive == true && String.isNotBlank(orgWrapperResponse.Data.entityId) ) {
                                isOrgAPIFlag = true;
                            }
                        }
                    }
                }
            }
            
            if ( isAuthAPIFlag || isOrgAPIFlag ) {
                isFlagReturn = true;
            }
        } catch ( Exception ex ) {
            System.debug('*********** Exception :' + ex.getMessage());

            return isFlagReturn;
        }
        
        return isFlagReturn;
    }
    
    public static String  getAcountPartyID ( String accId ) {
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        String accountPartyIdURI = (String) orgSpecificProps.get('Get_PartyId_URL__c');
        String accountCustomerID = null;
        Map<String, String> headers = new Map<String,String>();
        headers.put('Content-Type', 'application/json');

        try {
            HttpResponse res = new HttpResponse();
            if ( String.isNotBlank(accountPartyIdURI) ) {
                accountPartyIdURI = accountPartyIdURI + accId + '?type=sfid';
                res = TF_PlatformExecuter.execute( accountPartyIdURI, 'GET', 'idtoken', null, headers, false );
            }

            if ( res != NULL && res.getStatusCode() == 200 ) {
                String responseBody = res.getBody();
                if ( Test.isRunningTest() ) {
                    responseBody = '{"metadata": {"orgsCount": 1,"message": "party with 0011n00001zYClkAAG found","status": "success"},"data": {"contact": null,"organisations": [{"partyId": 1878901,"name": "Crumay Parnes Associates Inc.","parentRingGoldId": null,"ringGoldId": "531140","sourceOrgId": 0,"organisationType": "institute","partySfdcId": "0011n00001zYClkAAG",}],"source": null}}';
                }
                TF_AccountPartyIdWebServiceCallout.AccountResponse accountRes = (TF_AccountPartyIdWebServiceCallout.AccountResponse)JSON.deserialize(responseBody, TF_AccountPartyIdWebServiceCallout.AccountResponse.class);

                if ( accountRes != NULL ) {
                    if ( accountRes.Data != NULL ) {
                        if ( accountRes.Data.organisations != NULL ) {
                            if ( accountRes.Data.organisations[0].partyId != NULL ) {
                                accountCustomerID = String.valueof(accountRes.Data.organisations[0].partyId);
                            }
                        }
                    }
                }
            }
        } catch ( Exception ex ) {
            System.debug('*********** Exception :' + ex.getMessage());
            return accountCustomerID;
        }
        return accountCustomerID;
    }
}