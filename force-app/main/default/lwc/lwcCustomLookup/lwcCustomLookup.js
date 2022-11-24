import {
    LightningElement,
    api,
    track
} from 'lwc';
import getResults from '@salesforce/apex/TF_OppDetailPgSapBpNumber.getResults';

export default class LwcCustomLookup extends LightningElement {
    @api objectName = 'Account';
    @api fieldName = 'Name';
    @api selectRecordId = '';
    @api selectRecordName;
    @api selectedLabel;
    @api searchRecords = [];
    @api required = false;
    @api iconName = 'action:new_account'
    @api LoadingText = false;
    @track txtclassname = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
    @track messageFlag = false;
    @track iconFlag = true;
    @track clearIconFlag = false;
    @track inputReadOnly = false;
    @api accountForCampusDepart = false;
    @api accountIdForCampusDepart; // doesnt working
    @api accountForCampusDepartId; // getting from parent 
    @api searchUnderAccount = false;
    @api conAccntId;



    searchField(event) {
        var currentText = event.target.value;
        var accountForCampusDepartVar = this.accountForCampusDepart;
        var accIdForCampusDepartVar = this.accountForCampusDepartId;
        var searchUnderAccountVar = this.searchUnderAccount;
        this.LoadingText = true;
        console.log('objectName-' + this.objectName);
        console.log('fieldName-' + this.fieldName);
        console.log('fieldName-' + this.accountForCampusDepart);
        console.log('fieldName-' + this.accountForCampusDepartId);
        console.log('fieldName-' + this.accountIdForCampusDepart);


        getResults({
                ObjectName: this.objectName,
                fieldName: this.fieldName,
                value: currentText,
                isAccountForCampusDepart: accountForCampusDepartVar,
                accountIdForCampusDepartment: accIdForCampusDepartVar,
                isSearchUnderAccount: searchUnderAccountVar,
                conAccntId : this.conAccntId


            })
            .then(result => {
                this.searchRecords = result;
                this.LoadingText = false;

                this.txtclassname = result.length > 0 ? 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open' : 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
                if (currentText.length > 0 && result.length == 0) {
                    this.messageFlag = true;
                } else {
                    this.messageFlag = false;
                }

                if (this.selectRecordId != null && this.selectRecordId.length > 0) {
                    this.iconFlag = false;
                    this.clearIconFlag = true;
                } else {
                    this.iconFlag = true;
                    this.clearIconFlag = false;
                }
            })
            .catch(error => {
                console.log('-------error-------------' + error);
                console.log(error);
            });

    }

    setSelectedRecord(event) {
        var currentText = event.currentTarget.dataset.id;
        var selectName = event.currentTarget.dataset.name;
        var sObjName = this.objectName;
        var accountForCampusDepartVar = this.accountForCampusDepart;
        this.selectRecordId = currentText;

        if (this.accountForCampusDepart) {
            this.accountIdForCampusDepart = event.currentTarget.dataset.id;
        }
        this.txtclassname = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
        this.iconFlag = false;
        this.clearIconFlag = true;
        this.selectRecordName = event.currentTarget.dataset.name;

        console.log('this.accountIdForCampusDepart-' + event.currentTarget.dataset.id);
        console.log('this.accountIdForCampusDepart-' + this.accountIdForCampusDepart);
        console.log('this.accountForCampusDepart-' + this.accountForCampusDepart);
        console.log('this.selectRecordId-' + this.selectRecordId);
        console.log('typeof  ' + typeof this.selectRecordId);
        console.log('selectName ' + selectName);
        console.log('this.objectName -' + this.objectName);

        this.inputReadOnly = true;
        const selectedEvent = new CustomEvent('selected', {
            detail: {
                currentText,
                selectName,
                sObjName,
                accountForCampusDepartVar

            },

        });
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }

    @api
    resetData(event) {
        // console.log('clear');

        var lastSobjectName = this.selectRecordName;
        var lastRecId = this.selectRecordId;
        var sObjApiName = this.objectName;
        var accountForCampusDepartCleared = this.accountForCampusDepart;
        this.selectRecordName = "";
        this.selectRecordId = "";
        if (this.accountForCampusDepart && this.accountIdForCampusDepart) {
            this.accountIdForCampusDepart = undefined;
        }

        this.inputReadOnly = false;
        this.iconFlag = true;
        this.clearIconFlag = false;


        //create a event sending that sobject name id to make them null 
        const clearEvent = new CustomEvent('clearselected', {
            detail: {
                lastSobjectName,
                lastRecId,
                sObjApiName,
                accountForCampusDepartCleared
            },
        });
        // Dispatches the event.
        this.dispatchEvent(clearEvent);
    }

}