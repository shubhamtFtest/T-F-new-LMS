/* eslint-disable no-console */
import {
    LightningElement,
    track,
    api

} from 'lwc';
import getOppData from '@salesforce/apex/TF_OppDetailPgSapBpNumber.getOppData';
import setBpNumber from '@salesforce/apex/TF_OppDetailPgSapBpNumber.setBpNumber';
import copybilltoShip from '@salesforce/apex/TF_OppDetailPgSapBpNumber.copybilltoShip';
import getSelectedAddress from '@salesforce/apex/TF_OppDetailPgSapBpNumber.getSelectedAddress';
import getSelectedContactEmail from '@salesforce/apex/TF_OppDetailPgSapBpNumber.getSelectedContactEmail';
import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';
export default class OppDetailPgSapBpNumber extends LightningElement {
    @track isModalOpen = false;
    @track isAccountComboBoxSelected = false;
    @track isCampusComboBoxSelected = false;
    @track isDepartmentComboBoxSelected = false;
    @track isAccountForCampusDepartComboBox = false;
    @track refreshLds = true;
    @track modalHeader = '';
    @track selectedAddress = 'No address selected';
    @track showAddress = false;
    @track fetchedData;
    @track soldToBpUrl;
    @track shipToBpUrl;
    @track billToBpUrl;
    @track PayerBpUrl;
    @api selectRecordId;
    @api whichBp;
    @api selectRecordName;
    @api comboboxValue;
    @api recordId;
    @api conId;
    @api showErrorToast;
    @api sObjectIdSelected;
    @api sObjectApiNameSelected;
    @api accountForCampusDepartId;
    @api accountForCampusDepartApiName;
    @api isLoaded = false;
    @track showSpintrue = false;
    @api showCard = false;
    @api conAccntId;
    @track selectedContactInfo = 'No email selected';

    connectedCallback() {
        this.selectedAddress = 'No address selected';
        this.selectedContactInfo = 'No email selected';
        // initialize component
        // call to fetch data initailly 
        // this.selectedAddress = undefined;

        getOppData({
                recId: this.recordId,
            })
            .then(result => {
                //TODO:  Null changes will not be shown 
                if (result) {
                    this.fetchedData = result;
                    console.log('fetched data fresh - ' + JSON.stringify(this.fetchedData));
                    console.log('window.location.origin-' + window.location.origin);
                    this.showCard = true; // 
                    if (result.Sold_to_BP_Id) {
                        this.soldToBpUrl = window.location.origin + '/' + result.Sold_to_BP_Id;
                    }
                    if (result.Ship_to_BP_Id) {
                        this.shipToBpUrl = window.location.origin + '/' + result.Ship_to_BP_Id;
                    }
                    if (result.Bill_to_BP_Id) {
                        this.billToBpUrl = window.location.origin + '/' + result.Bill_to_BP_Id;
                    }
                    if (result.Payer_BP_Id) {
                        this.PayerBpUrl = window.location.origin + '/' + result.Payer_BP_Id;
                    }
                    console.log('this.soldToBpUrl-' + this.soldToBpUrl);

                }

            })
            .catch(error => {
                console.log('-------error-------------' + error);
                console.log(error);
            });

    }
    copybilltoShip(event) {
        console.log('copybilltoShip ');
        this.showSpintrue = true;
        copybilltoShip({
                oppId: this.recordId
            })
            .then(result => {

                this.showSpintrue = false;
                console.log('after save call -result -' + result);
                // close popup and refresh values 
                this.connectedCallback();

            })
            .catch(error => {
                this.showSpintrue = false;
                console.log('-------error-------------' + JSON.stringify(error));
                this.showToastMeth('Something went wrong : Please try again after sometime !', 'error');
            });
    }

    handleClick(event) {
        var btnIconName;
        this.isModalOpen = true;
        btnIconName = event.target.name;
        console.log('btnIconName-' + btnIconName);
        // modalHeader is being sent to 
        if (btnIconName === 'Sold to BP') {
            this.modalHeader = 'Sold to BP';
            this.whichBp = 'Sold to BP';
        } else if (btnIconName === 'Ship to BP') {
            this.modalHeader = 'Ship to BP';
            this.whichBp = 'Ship to BP';
        } else if (btnIconName === 'Bill to BP') {
            this.modalHeader = 'Bill to BP';
            this.whichBp = 'Bill to BP';
        } else if (btnIconName === 'Payer BP') {
            this.modalHeader = 'Payer BP';
            this.whichBp = 'Payer BP';
        }
    }

    closePopUP() {
        console.log('close event-');
        this.isModalOpen = false;
        this.isAccountComboBoxSelected = false;
        this.isCampusComboBoxSelected = false;
        this.isDepartmentComboBoxSelected = false;
        this.isAccountForCampusDepartComboBox = false;
        this.showAddress = false;


        this.sObjectIdSelected = undefined; // acc , departmnt , campus 
        this.sObjectApiNameSelected = undefined; // acc , departmnt , campus  
        this.conId = undefined;
        this.accountForCampusDepartId = undefined; // acc for campus & departmnt
        this.accountForCampusDepartApiName = undefined;
        this.selectedAddress = 'No address selected';
        this.selectedContactInfo = 'No email selected';

    }

    savePopUPBtn() {
        console.log('save pop up ');
        // eslint-disable-next-line no-console
        console.log('save this.conId-' + this.conId);
        console.log('save this.sObjectIdSelected-' + this.sObjectIdSelected);
        console.log('save this.sObjectApiNameSelected-' + this.sObjectApiNameSelected);
        console.log('save this.accountForCampusDepartApiName-' + this.accountForCampusDepartApiName);
        console.log('save this.accountForCampusDepartId-' + this.accountForCampusDepartId);
        console.log('save this.modalHeader-' + this.modalHeader);

        // if (lookupResult && lookupResult.sObjName && (lookupResult.sObjName.toLowerCase() === 'campus__c' || lookupResult.sObjName.toLowerCase() === 'department__c' || lookupResult.sObjName.toLowerCase() === 'account') && !lookupResult.accountForCampusDepartVar) 



        if ((this.conId && this.sObjectIdSelected && this.sObjectApiNameSelected && this.comboboxValue)) {
            this.showErrorToast = false;
            //  campus & depatrment ll always have a account 
            if ((this.sObjectApiNameSelected.toLowerCase() === 'campus__c' || this.sObjectApiNameSelected.toLowerCase() === 'department__c') && this.accountForCampusDepartId && this.accountForCampusDepartApiName) {
                this.callSetBpNumber();
            } else if (this.sObjectApiNameSelected.toLowerCase() === 'account') {
                this.callSetBpNumber();
            } else {
                this.showToastMeth('All fields are required', 'error');
            }
        } else {
            this.showToastMeth('All fields are required', 'error');
        }

    }

    // show toast 
    showToastMeth(messg, variant) {
        const evt = new ShowToastEvent({
            title: 'Error',
            message: messg,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    callSetBpNumber() {
        this.showSpintrue = true;
        // call apex method  setBpNumber(String conId ,String sobjectId , String sObjectName , String whichBpHearder )
        console.log('saving records ');
        setBpNumber({
                conId: this.conId,
                sobjectId: this.sObjectIdSelected,
                sObjectName: this.sObjectApiNameSelected,
                whichBpHearder: this.whichBp,
                addressType: this.comboboxValue,
                oppId: this.recordId
            })
            .then(result => {
                if (result) {
                    this.showSpintrue = false;
                    console.log('after save call -result -' + result);
                    // close popup and refresh values 
                    this.isModalOpen = false;
                    this.closePopUP();
                    this.connectedCallback();
                }
            })
            .catch(error => {
                this.showSpintrue = false;
                console.log('-------error-------------' + JSON.stringify(error));
                this.showToastMeth('Something went wrong : Please try again after sometime !', 'error');
            });

    }

    // when any lookup is selected 
    selectedRecords(event) {
        var lookupResult = event.detail;
        console.log('textVal-' + JSON.stringify(lookupResult));
        console.log('textVal-' + JSON.stringify(lookupResult.currentText));
        if (lookupResult && lookupResult.sObjName && lookupResult.sObjName.toLowerCase() === 'contact') {
            this.conId = lookupResult.currentText;
            this.setSelectedContactEmail(this.conId);
        }
        if (lookupResult && lookupResult.sObjName && (lookupResult.sObjName.toLowerCase() === 'campus__c' || lookupResult.sObjName.toLowerCase() === 'department__c' || (lookupResult.sObjName.toLowerCase() === 'account' && !lookupResult.accountForCampusDepartVar))) {
            //TODO: implement following 
            // if ((lookupResult.sObjName.toLowerCase() === 'campus__c' || lookupResult.sObjName.toLowerCase() === 'department__c') && !this.accountForCampusDepartId) {
            //     console.log('show error');
            //     this.template.querySelector('c-lwc-custom-lookup').resetData();
            //     this.showToastMeth('Select related account', 'error');
            //     // to reset all lookup
            //     return;
            // }

            this.sObjectIdSelected = lookupResult.currentText;
            this.sObjectApiNameSelected = lookupResult.sObjName;
            this.showSpintrue = true;
            this.showAddress = true;
            if(lookupResult.sObjName.toLowerCase() === 'account'){
                
                this.conAccntId = lookupResult.currentText;
            }

            // call the method
            this.setSelectedAddress();
            
        }
        // if account coming belogs to campus or department 
        else if (lookupResult && lookupResult.sObjName && lookupResult.sObjName.toLowerCase() === 'account' && lookupResult.accountForCampusDepartVar) {
            this.accountForCampusDepartId = lookupResult.currentText;
            this.accountForCampusDepartApiName = lookupResult.sObjName;
            this.conAccntId = lookupResult.currentText;
        }
    }

    // when the clear icon is click on any lookup
    lookUpCleared(event) {
        var lookupCleared = event.detail;
        if (lookupCleared && lookupCleared.sObjApiName && lookupCleared.lastRecId) {
            console.log('lookupCleared-' + JSON.stringify(lookupCleared));
            if (lookupCleared.sObjApiName.toLowerCase() === 'contact') {
                this.conId = undefined;
            }
            if (lookupCleared.sObjApiName.toLowerCase() === 'campus__c' || lookupCleared.sObjApiName.toLowerCase() === 'department__c' || (lookupCleared.sObjApiName.toLowerCase() === 'account' && !lookupCleared.accountForCampusDepartCleared)) {
                this.sObjectIdSelected = undefined;
                this.sObjectApiNameSelected = undefined;
                this.showAddress = false;
                this.selectedAddress = 'No address selected';
                // clear value & hide the slected addrtes 
                this.showAddress = false;
            } else if (lookupCleared.sObjApiName.toLowerCase() === 'account' && lookupCleared.accountForCampusDepartCleared) {
                this.accountForCampusDepartId = undefined;
                this.accountForCampusDepartApiName = undefined;
            }

            console.log('After clear this.conId-' + this.conId);
            console.log('After clear this.sObjectIdSelected-' + this.sObjectIdSelected);
            console.log('After clear this.sObjectApiNameSelected-' + this.sObjectApiNameSelected);
            console.log('save this.accountForCampusDepartApiName-' + this.accountForCampusDepartApiName);
            console.log('save this.accountForCampusDepartId-' + this.accountForCampusDepartId);

        }
    }

    setSelectedContactEmail(contactId){
        this.selectedContactInfo = 'No email selected';
        this.showSpintrue = true;
        getSelectedContactEmail({sobjectId: contactId})
        .then(result => {
            console.log('result-' + result);
            if (result) {

                console.log('after getSelectedEmail call -result -' + result);
                this.selectedContactInfo = result;
            } else {
                this.selectedContactInfo = 'No email found';
            }
        })
        .catch(error => {
            this.showSpintrue = false;
            console.log('-------error-------------' + JSON.stringify(error));
            this.showToastMeth('Something went wrong : Please try again after sometime !', 'error');
        });
        this.showSpintrue = false;
    }

    setSelectedAddress() {
        this.selectedAddress = 'No address selected';
        this.showSpintrue = true;
        // call to apex to fetch add  getSelectedAddress(String sobjectId , String sObjectName , String addressType)
        getSelectedAddress({
                sobjectId: this.sObjectIdSelected,
                sObjectName: this.sObjectApiNameSelected,
                addressType: this.comboboxValue,
            })
            .then(result => {
                console.log('result-' + result);
                if (result) {

                    console.log('after getSelectedAddress call -result -' + result);
                    this.selectedAddress = result;
                } else {
                    this.selectedAddress = 'No address found';
                }
            })
            .catch(error => {
                this.showSpintrue = false;
                console.log('-------error-------------' + JSON.stringify(error));
                this.showToastMeth('Something went wrong : Please try again after sometime !', 'error');
            });
        this.showSpintrue = false;

    }

    comboBoxChange(event) {
        this.comboboxValue = event.detail.value;
        console.log('this.comboboxValue-' + this.comboboxValue);

        this.sObjectIdSelected = undefined; // acc , departmnt , campus 
        this.sObjectApiNameSelected = undefined; // acc , departmnt , campus  
        this.accountForCampusDepartId = undefined; // acc for campus & departmnt
        this.accountForCampusDepartApiName = undefined;
        // clear value & hide the slected addrtes 
        this.showAddress = false;
        this.selectedAddress = 'No address selected';

        //  changing visiblity 
        if (this.comboboxValue && (this.comboboxValue === 'Account Mailing' || this.comboboxValue === 'Account Shipping' || this.comboboxValue === 'Account Billing')) {
            this.isAccountComboBoxSelected = true;
            this.isCampusComboBoxSelected = false;
            this.isDepartmentComboBoxSelected = false;
            this.isAccountForCampusDepartComboBox = false;
        } else if (this.comboboxValue && this.comboboxValue === 'Campus') {
            this.isAccountComboBoxSelected = false;
            this.isCampusComboBoxSelected = true;
            this.isDepartmentComboBoxSelected = false;
            this.isAccountForCampusDepartComboBox = true;
        } else if (this.comboboxValue && this.comboboxValue === 'Department') {
            this.isAccountComboBoxSelected = false;
            this.isCampusComboBoxSelected = false;
            this.isDepartmentComboBoxSelected = true;
            this.isAccountForCampusDepartComboBox = true;
        }
        //this.setSelectedAddress();
        // to reset all lookup
        this.template.querySelector('c-lwc-custom-lookup').resetData();


    }

    get options() {
        return [{
                label: 'Account Mailing',
                value: 'Account Mailing'
            },
            {
                label: 'Account Shipping',
                value: 'Account Shipping'
            },
            {
                label: 'Account Billing',
                value: 'Account Billing'
            },
            {
                label: 'Campus',
                value: 'Campus'
            },
            {
                label: 'Department',
                value: 'Department'
            },
        ];
    }

}