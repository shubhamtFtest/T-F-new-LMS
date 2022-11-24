({
    onInit: function (cmp, event, helper) {
        var action = cmp.get("c.getSalesType");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var serverRespo = response.getReturnValue();
                console.log('serverRespo-' + serverRespo);
                console.log('serverRespo.len-' + serverRespo.length);

                var settingValues = [{
                    id: 'Select Channel',
                    label: 'Select Channel',
                    selected: true
                }];


                for (let index = 0; index < serverRespo.length; index++) {
                    var element = {
                        id: serverRespo[index].Text_1__c,
                        label: serverRespo[index].Text_2__c
                    };
                    settingValues.push(element);
                }

                cmp.set("v.salesType", settingValues);
                cmp.set("v.selectedValue", 'Select Channel');

                console.log('settingValues-' + JSON.stringify(settingValues));
                console.log('settingValues.len-' + settingValues.length);


                var recordId = cmp.get("v.recordId");
                // console.log('recordId-' + recordId);
                // console.log('sObjectName-' + cmp.get("v.sObjectName"));
                if (recordId) {


                    cmp.set('v.Spinner', true);
                    var tabl = cmp.find("cmpContent");
                    $A.util.toggleClass(tabl, 'slds-transition-hide');
                    console.log('call () ');
                    console.log('drop down-' + cmp.find('select').get('v.value'));

                    /**
                     *  calling function getOrdersForCustomer() to fetch orders 
                     */
                    var action = cmp.get('c.getOrderForOpp');

                    action.setParams({
                        objId: recordId,
                        channel: cmp.find('select').get("v.value"),
                        sObjectName: cmp.get("v.sObjectName"),
                        pagesize: cmp.get("v.pagesize"),
                        pageno: cmp.get("v.pageno")

                    });

                    action.setCallback(this, function (res) {
                        if (res.getState() === 'SUCCESS') {
                            cmp.set('v.Spinner', false);
                            var tabl = cmp.find("cmpContent");
                            $A.util.toggleClass(tabl, 'slds-transition-hide');
                            console.log('return value -' + JSON.stringify(res.getReturnValue()));
                            if (!$A.util.isEmpty(res.getReturnValue()) && !$A.util.isEmpty(res.getReturnValue().paginatedOrderResult) && !$A.util.isEmpty(res.getReturnValue().paginatedOrderResult.data)) {
                                var arr = [];
                                arr = res.getReturnValue().paginatedOrderResult.data;
                                // console.log('total pages -'+res.getReturnValue().metadata.totalPagesize);
                                cmp.set("v.totalPageSize", res.getReturnValue().metadata.totalPagesize);
                                arr.sort(function (a, b) {
                                    a = new Date(a.orderDate);
                                    b = new Date(b.orderDate);
                                    return a > b ? -1 : a < b ? 1 : 0;
                                });
                                // console.log('arr-' + arr);
                                var len = arr.length;
                                cmp.set("v.recordsPerPage", len);
                                cmp.set('v.OrdersFetched', arr);
                                cmp.set('v.NoOrderFound', false);
                                if (cmp.get("v.recordsPerPage") === 4) {
                                    cmp.set("v.btnDisable", true);
                                }
                            } else {
                                cmp.set('v.NoOrderFound', true);
                                var emptylist = [];
                                cmp.set('v.OrdersFetched', emptylist);

                                // console.log('no order found -' + cmp.get('v.NoOrderFound'));
                            }
                        } else if (res.getState() === 'ERROR') {
                            cmp.set('v.Spinner', false);
                            var tabl = cmp.find("cmpContent");
                            $A.util.toggleClass(tabl, 'slds-hide');
                            var errors = res.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    // console.log(errors[0].message);
                                }
                            }
                        }
                    });
                    $A.enqueueAction(action);
                }
            }
        });
        $A.enqueueAction(action);




    },

    ToggleDropDownPanel: function (cmp, event, helper) {
        // rightIcon downIcon 
        // $A.togg // cmp.find("rightIcon")  NoOrderFoundId  OrdersFetchedId 
        $A.util.toggleClass(cmp.find("rightIcon"), 'slds-hide');
        $A.util.toggleClass(cmp.find("downIcon"), 'slds-hide');
        // document.getElementById("OrdersFetchedId").style.display
        $A.util.toggleClass(cmp.find("cmpContent"), 'slds-hide');
        $A.util.toggleClass(cmp.find("NoOrderFoundId"), 'slds-hide');
    },
    previousPg: function (cmp, event, helper) {
        // console.log('previous pg ');
        var pageno = cmp.get("v.pageno");
        if (pageno != 1) {
            pageno--;
            cmp.set("v.pageno", pageno);
            helper.processChange(cmp, event);
            // var act = cmp.get("c.onInit");
            // $A.enqueueAction(act);
        }


    },
    nextPg: function (cmp, event, helper) {
        // console.log('next pg ');
        var pageno = cmp.get("v.pageno");
        pageno++;
        cmp.set("v.pageno", pageno);
        helper.processChange(cmp, event);
        // var act = cmp.get("c.onInit");
        // $A.enqueueAction(act);
    },
    onChange: function (cmp, event, helper) {
        console.log((cmp.find('select').get('v.value') + ' selected'));
        cmp.set("v.pageno", 1);
        helper.processChange(cmp, event);
        // var act = cmp.get("c.onInit");
        // $A.enqueueAction(act);

    },
})