import {
    LightningElement,
    api,
    track
} from 'lwc';
import getErrorMessage from '@salesforce/apex/TF_SAP_BP_ErrorHandling.getErrorMessage';
import retry from '@salesforce/apex/TF_SAP_BP_ErrorHandling.retry';
import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';
export default class SapBpErrorRetry extends LightningElement {
    @api renderedCallbackRanOnce = false;
    @api recordId;
    @api objectApiName;
    @api notAttemptedMsg = ' This functionality has not been attempted once.';
    @api lastAddValidationSuccess = false ;
    @api lastDirectSalesSuccess = false ;
    @track isButtonDisabled = false;
    @track isOrderObj = false;
    @track isOppObj = false;
    @track tickboxClass = '';
    @track fetchedData;
    @track showSpiner = false;
    @track showSpinerCls = 'test';
    @track showThirdRow = true;
    @track showProceedBtn = false;
    @track showTickbox0CheckIcon;
    @track showTickbox1CheckIcon;
    @track showTickbox2CheckIcon;

    @track showTickbox0CrossIcon;
    @track showTickbox1CrossIcon;
    @track showTickbox2CrossIcon;

    @track showTickbox0DashIcon;
    @track showTickbox1DashIcon;
    @track showTickbox2DashIcon;

    @track disableTickbox0;
    @track disableTickbox1;
    @track disableTickbox2;

    @track messageBox0;
    @track messageBox1;
    @track messageBox2;

    constructor() {
        super();
        console.log('In real Constructor');
        // var alltickBox = this.template.querySelectorAll('[data-id="tickBox"]');
        // console.log('after query selector In real Constructor' + JSON.stringify(alltickBox));
    }


    connectedCallback() {
        var allTickBox = this.template.querySelectorAll('[data-id="tickBox"]');
        console.log('connectedCallback-' + this.objectApiName);
        console.log('allTickBox.length-' + allTickBox.length);
        console.log('showSpiner-' + this.showSpiner);

        // displaying the right checkboxes 
        if (this.objectApiName === 'Order') {
            this.isOrderObj = true;
        } else if (this.objectApiName === 'Opportunity') {
            this.isOppObj = true;
        }
    }

    renderedCallback(event) {
        if (!this.renderedCallbackRanOnce) {
            this.renderedCallbackRanOnce = true;
            this.getStatusFromSobj(false);
        }
    }

    errorCallback(error, stack) {
        console.log('errorCallback-' + errorCallback);
        this.showToastMeth('Something went wrong !' + this.error, 'Error');
        this.closePopUp();

    }

    getStatusFromSobj(afterProceedResult) {
        console.log('rendered callback ');
        var i;
        var tickBox = this.template.querySelectorAll('[data-id="tickBox"]');
        console.log('renderedCallback-' + this.objectApiName);
        console.log('tickBox.length-' + tickBox.length);
        this.showSpiner = true;
        this.showSpinerCls = 'test';
        console.log('#### calling getErrorMessage ####');

        // get value from object
        getErrorMessage({
                Id: this.recordId,
                objectName: this.objectApiName
            })
            .then(result => {
                if (result) {
                    console.log('returned data - ' + JSON.stringify(result));
                    this.fetchedData = result;
                    /*    */
                    // displaying the right checkboxes 
                    if (this.objectApiName === 'Order' || this.objectApiName === 'Opportunity') {
                        this.isOrderObj = true;
                        for (i = 0; i < tickBox.length; i++) {
                            switch (i) {
                                case 0:
                                    // labels are being comapred to call the respective method . so change label in comparsion also if there is any changes here 
                                    tickBox[i].value = (this.objectApiName === 'Order' ? 'Post order to order hub' : 'Address validation');
                                    // setting the right icon or close icon     showTickbox0DashIcon  showTickbox0CrossIcon
                                    if (this.objectApiName === 'Opportunity') {
                                        if (this.fetchedData && (this.fetchedData.addressShipToValidationSuccess === 'success' && this.fetchedData.addressBillToValidationSuccess === 'success')) {
                                            this.disableTickbox0 = true;
                                            this.showTickbox0CheckIcon = true;
                                            this.showTickbox0CrossIcon = false;
                                            this.showTickbox0DashIcon = false;
                                            tickBox[i].checked = false;
                                            this.messageBox0 = 'Completed successfully';
                                            // show toasts if its an error after proceed 
                                            if (afterProceedResult && !this.lastAddValidationSuccess) {
                                                this.showToastMethSuccess(' Address validation successful !', 'success');
                                            }
                                            // when the pop is open
                                            else {
                                                this.lastAddValidationSuccess = true;
                                            }

                                        } else if (this.fetchedData && (this.fetchedData.addressShipToValidationSuccess === 'failed' || this.fetchedData.addressBillToValidationSuccess === 'failed')) {
                                            this.disableTickbox0 = false;
                                            this.showTickbox0CheckIcon = false;
                                            this.showTickbox0CrossIcon = true;
                                            this.showTickbox0DashIcon = false;
                                            this.messageBox0 = '';
                                            if (this.fetchedData.addressShipToValidationSuccess === 'failed') {
                                                this.messageBox0 = this.fetchedData.addressShipToValidationMessage;
                                            }
                                            if (this.fetchedData.addressBillToValidationSuccess === 'failed') {
                                                this.messageBox0 = this.messageBox0 + this.fetchedData.addressBillToValidationMessage;
                                            }

                                            // show toasts if its an error after proceed 
                                            if (afterProceedResult) {
                                                this.showToastMeth(' Address validation failed !', 'Error');
                                            }
                                            // when the pop up is open
                                            else {
                                                this.lastAddValidationSuccess = false;
                                            }

                                        } else if (this.fetchedData && (this.fetchedData.addressShipToValidationSuccess === 'notAttempted' && this.fetchedData.addressBillToValidationSuccess === 'notAttempted')) {
                                            this.disableTickbox0 = true;
                                            this.showTickbox0CheckIcon = false;
                                            this.showTickbox0CrossIcon = false;
                                            this.showTickbox0DashIcon = true;
                                            this.messageBox0 = this.notAttemptedMsg;
                                        } else if (this.fetchedData && (this.fetchedData.addressShipToValidationSuccess === 'success' && this.fetchedData.addressBillToValidationSuccess === 'notAttempted') || (this.fetchedData.addressShipToValidationSuccess === 'notAttempted' && this.fetchedData.addressBillToValidationSuccess === 'success')) {
                                            this.disableTickbox0 = true;
                                            this.showTickbox0CheckIcon = true;
                                            this.showTickbox0CrossIcon = false;
                                            this.showTickbox0DashIcon = false;
                                            this.messageBox0 = 'Completed successfully';
                                        }
                                    }
                                    break;
                                case 1:
                                    tickBox[i].value = (this.objectApiName === 'Order' ? 'Tax calculation' : 'Direct sales process');
                                    // setting the right icon or close icon 
                                    if (this.objectApiName === 'Opportunity' && this.fetchedData) {
                                        if (this.fetchedData.directSalesProcessSuccess === 'success') {
                                            this.disableTickbox1 = true;
                                            this.showTickbox1CheckIcon = true;
                                            this.showTickbox1CrossIcon = false;
                                            this.showTickbox1DashIcon = false;
                                            tickBox[i].checked = false;
                                            this.messageBox1 = 'Completed successfully';

                                            // show toasts if its an error after proceed 
                                            if (afterProceedResult && !this.lastDirectSalesSuccess) {
                                                this.showToastMethSuccess(' Direct sales process has completed successful !', 'success');
                                            }
                                            // when the pop up is open
                                            else {
                                                this.lastDirectSalesSuccess = true;
                                            }

                                        } else if (this.fetchedData.directSalesProcessSuccess === 'failed') {
                                            this.disableTickbox1 = false;
                                            this.showTickbox1CheckIcon = false;
                                            this.showTickbox1CrossIcon = true;
                                            this.showTickbox1DashIcon = false;
                                            this.messageBox1 = '';
                                            if (this.fetchedData.directSalesProcessSuccess === 'failed') {
                                                this.messageBox1 = this.fetchedData.directSalesProcessMessage;
                                            }
                                            // show toasts if its an error after proceed 
                                            if (afterProceedResult) {
                                                this.showToastMeth('Direct sales process failed !', 'Error');
                                            }
                                            // when the pop up is open
                                            else {
                                                this.lastDirectSalesSuccess = false;
                                            }

                                        } else if (this.fetchedData.directSalesProcessSuccess === 'notAttempted') {
                                            this.disableTickbox1 = true;
                                            this.showTickbox1CheckIcon = false;
                                            this.showTickbox1CrossIcon = false;
                                            this.showTickbox1DashIcon = true;
                                            this.messageBox1 = this.notAttemptedMsg;
                                        }
                                    }

                                    break;
                                case 2:
                                    // tickBox[i].value = (this.objectApiName === 'Opportunity' ? '' : '');
                                    // if (this.objectApiName === 'Order') {
                                    this.showThirdRow = false;
                                    // }
                                    break;

                                default:
                                    // code block
                            }
                            this.isButtonDisabled = true;
                        }
                    }
                    /*    */
                    this.showSpiner = false;
                    this.showSpinerCls = '';

                    if (this.fetchedData && ( (this.fetchedData.addressShipToValidationSuccess === 'success' && this.fetchedData.addressBillToValidationSuccess === 'success') || (this.fetchedData.addressShipToValidationSuccess === 'notAttempted' && this.fetchedData.addressBillToValidationSuccess === 'success')) && this.fetchedData.directSalesProcessSuccess === 'success') {
                       
                        if ( afterProceedResult ) {
                            this.closePopUp();
                        }
                    }
                    if(this.fetchedData && (this.fetchedData.addressShipToValidationSuccess === 'failed' || this.fetchedData.addressBillToValidationSuccess === 'failed'  || this.fetchedData.directSalesProcessSuccess === 'failed' ) )
                    {
                        this.showProceedBtn = true;
                    }

                    
                } else {
                    this.showSpiner = false;
                    this.showSpinerCls = '';
                }
            })
            .catch(error => {
                let errorMessage = 'Something went wrong!';
                if (error.body) {
                    console.log('eror-'+ error.body );
                    
                    errorMessage = errorMessage ;
                }
                this.showToastMeth(errorMessage, 'Error');
            });
    }



    retryClicked(event) {
        var labelStr;
        var retryMethodStr = [];
        console.log(' retry clicked -');
        var alltickBox = this.template.querySelectorAll('[data-id="tickBox"]');
        console.log('alltickBox.length' + alltickBox.length);
        for (let i = 0; i < alltickBox.length; i++) {
            labelStr = alltickBox[i].value;
            console.log('labelStr-' + labelStr + 'alltickBox[i].checked-' + alltickBox[i].checked);
            if (alltickBox[i].checked) {
                if (labelStr && labelStr.toLowerCase().includes('Post order to order hub'.toLowerCase())) {
                    console.log('Post order to order hub');
                    // remaining   // addressVerification  sapBpNumberCreation   orderTaxCalculation   postOrder
                    retryMethodStr.push('postOrder');
                }
                if (labelStr && labelStr.toLowerCase().includes('Tax calculation'.toLowerCase())) {
                    console.log('Tax calculation');
                    retryMethodStr.push('orderTaxCalculation');
                }
                // if (labelStr && labelStr.toLowerCase().includes('Sap bp creation'.toLowerCase())) {
                //     console.log('Sap bp creation');
                //     retryMethodStr = retryMethodStr  + 'sapBpNumberCreation';
                // }
                if (labelStr && labelStr.toLowerCase().includes('Address validation'.toLowerCase())) {
                    console.log('Address validation');
                    retryMethodStr.push('addressVerification');
                }
                if (labelStr && labelStr.toLowerCase().includes('Sap bp number updation'.toLowerCase())) {
                    console.log('Sap bp number updation');
                    retryMethodStr.push('sapBpNumberCreation');
                }
            }

        }
        //TODO: return error mssg on toast  , throw an exception add try catch 
        // calling retry method 

        // if (Array.isArray(retryMethodStr) && !retryMethodStr.length) {
        //     this.showToastMeth('Atleast choose one option ', 'Error');
        //     return;
        // }

        // only post order when tax calculation is successful 
        if (Array.isArray(retryMethodStr) && retryMethodStr.length) {
            if (retryMethodStr.includes('Post order to order hub'.toLowerCase()) && !retryMethodStr.includes('Tax calculation'.toLowerCase())) {
                if (this.objectApiName === 'Order' && this.fetchedData.orderTaxCalculationSuccess !== 'success') {
                    this.showToastMeth('Please calculate tax successfully before posting order.', 'Error');
                    return;
                }
            }
        }
        //

        this.showSpiner = true;
        this.showSpinerCls = 'test';
        console.log('#### calling retry ####');

        retry({
                //(List<String> retryMethodList, String opportunityId, String orderId){
                retryMethodList: retryMethodStr,
                opportunityId: (this.objectApiName === 'Opportunity' ? this.recordId : ''),
                orderId: (this.objectApiName === 'Order' ? this.recordId : '')
            })
            .then(result => {
                if (result) {
                    console.log('retry call success-' + JSON.stringify(result));
                    // this.showToastMeth(JSON.stringify(result), 'Info')

                    // refresh message from backend 
                    this.getStatusFromSobj(true);

                } else {
                    this.showSpiner = false;
                    this.showSpinerCls = '';
                    this.showToastMeth('Something went wrong ! Please try again later', 'Error');
                }
            })
            .catch(error => {
                let errorMessage = 'Something went wrong!';
                if (error.body) {
                    errorMessage = errorMessage ;
                }
                this.showToastMeth(errorMessage, 'Error');
            });


    }

    // show toast - failure
    showToastMeth(messg, variant) {
        const evt = new ShowToastEvent({
            title: 'Error',
            message: messg,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }


    // show toast in case of success
    showToastMethSuccess(messg, variant) {
        const evt = new ShowToastEvent({
            title: 'Success',
            message: messg,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    // close popoup
    closePopUp(event) {
        const closePopUpEvent = new CustomEvent('closePopUp');
        // fire the event 
        this.dispatchEvent(closePopUpEvent);

    }
}