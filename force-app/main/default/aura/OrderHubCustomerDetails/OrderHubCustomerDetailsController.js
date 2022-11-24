({
    onInit: function (cmp, event, helper) {

        //console.error('hola');
        console.log('helloINIT mainn page ');
        var orderNum = cmp.get("v.pageReference").state.c__orderNum;
        var accId = cmp.get("v.pageReference").state.c__accId;
        cmp.set("v.accId", accId);
        console.log('pg ref - ' + orderNum);
        // orderNum = ($A.util.isEmpty(cmp.get("v.pageReference").state) && cmp.get("v.pageReference").state.orderNum); oder 
        if ($A.util.isEmpty(orderNum)) {
            cmp.set("v.showForm", true);
            cmp.set("v.showOrderdetailPage", false);
            var k = cmp.get("v.showForm");
            // for test following 
            // var act = cmp.get('c.searchItemSelected');
            // $A.enqueueAction(act);
        } else {
            cmp.set("v.showOrderdetailPage", true);
            cmp.set("v.showForm", false);
            cmp.set("v.orderNum", orderNum);
        }
    },
    handleKeyUp: function (cmp, evt) {
        // console.log('handleKeyUp');
        var isEnterKey = evt.keyCode === 13;
        var queryTerm = cmp.find('enter-search').get('v.value');
        cmp.set("v.pageno", 1);
        cmp.set("v.btnDisable", false);
        if (isEnterKey) {
            cmp.set('v.issearching', true);
            var emptyarr = [];
            cmp.set("v.server_result", emptyarr);
            // cmp.set("v.showList", true);
            //setTimeout(function() {
            // console.log('Searched for "' + queryTerm + '"!');
            var action = cmp.get('c.searchDB');
            //action.setStorable();

            action.setParams({
                objectName: 'Account',
                fld_API_Text: 'Name',
                fld_API_Val: 'Id',
                lim: cmp.get("v.limit"),
                fld_API_Search: 'Name',
                searchText: queryTerm
            });

            action.setCallback(this, function (res) {
                if (res.getState() === 'SUCCESS') {
                    cmp.set('v.issearching', false);
                    var retObj = JSON.parse(res.getReturnValue());
                    if (retObj.length <= 0) {
                        var noResult = JSON.parse('[{"text":"No Results Found"}]');
                        cmp.set("v.server_result", noResult);
                        cmp.set("v.showList", true);
                        //cmp.set("v.last_ServerResult",noResult);
                    } else {
                        cmp.set("v.server_result", retObj);
                        cmp.set("v.showList", true);
                        // console.log('return ' + JSON.stringify(cmp.get("v.server_result")));
                    }
                } else if (res.getState() === 'ERROR') {
                    cmp.set('v.issearching', false);
                    var errors = res.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            // console.log(errors[0].message);
                        }
                    }
                }
            });
            $A.enqueueAction(action);
            //}, 2000);
        }
    },
    hideList: function (cmp, evt) {
        cmp.set("v.showList", false);
    },
    hisfsfdeList: function (cmp, evt) {
        cmp.set("v.showList", false);
    },
    closeAccountList: function (cmp) {
        cmp.set("v.searchValue", "");
        cmp.set("v.showList", false);
    },
    searchItemSelected: function (cmp, event, helper) {
        cmp.set('v.OrdersFetched', []);
        cmp.set('v.showOrdersFetched', false);
        var target = event.target;
        var recId = target.getAttribute("data-recordid");
        var recName = target.getAttribute("data-text");
        cmp.find('enter-search').set('v.value', recName);
        cmp.set("v.recordID", recId);
        cmp.set("v.showList", false);
        cmp.set("v.recName", recName);


    },
    searchButtonSelected: function (cmp, event, helper) {
        // document.getElementById("pgn1Btn").style.backgroundColor = "white";
        var recName = cmp.get("v.recName");
        var recID = cmp.get("v.recordID");
        console.log("v.recName" + recName);
        console.log("v.recId" + recID);
        var target = event.target;
        var btnValueNo = target.getAttribute("data-btnvalue");
        //    document.getElementById(event.target.id).style.backgroundColor = "rgb(133, 187, 235)";
        // console.log('btnValueNo-' + btnValueNo);
        // console.log('event.target.id-' + event.target.id);


        //set page no = 1 every time a new customer id is selected  & btn1Pgn to show right btn 
        cmp.set("v.pageno", 1);
        cmp.set("v.btn1Pgn", 0);
        console.log('setting 1 pageno - ' + cmp.get("v.pageno"));


        // API callout  then save in OrdersFetched  getOrdersForCustomer(String accountId)
        var action = cmp.get('c.getOrdersForCustomer');
        //action.setStorable();

        action.setParams({
            accountId: recID,
            channel: cmp.find('channel').get('v.value'),
            pagesize: cmp.get("v.pagesize"),
            pageno: cmp.get("v.pageno")

        });
        cmp.set('v.Spinner', true);
        action.setCallback(this, function (res) {
            if (res.getState() === 'SUCCESS') {
                cmp.set('v.Spinner', false);
                console.log(JSON.stringify(res.getReturnValue()));
                if (!$A.util.isEmpty(res.getReturnValue()) && !$A.util.isEmpty(res.getReturnValue().paginatedOrderResult) && !$A.util.isEmpty(res.getReturnValue().paginatedOrderResult.data)) {
                    var arr = [];
                    arr = res.getReturnValue().paginatedOrderResult.data;
                    // console.log('total pages -' + res.getReturnValue().metadata.totalPagesize);
                    cmp.set("v.totalPageSize", res.getReturnValue().metadata.totalPagesize);
                    cmp.set("v.addressType", res.getReturnValue().metadata.addresMappg);
                    arr.sort(function (a, b) {
                        a = new Date(a.orderDate);
                        b = new Date(b.orderDate);
                        return a > b ? -1 : a < b ? 1 : 0;
                    });
                    // console.log('arr-' + arr);
                    var len = arr.length;
                    cmp.set("v.recordsPerPage", len);
                    // console.log("recordsPerPage--" + len);
                    cmp.set('v.OrdersFetched', arr);
                    cmp.set('v.showOrdersFetched', true);
                    // console.log('order-->' + JSON.stringify(cmp.get('v.OrdersFetched')));  showOrdersFetched
                    cmp.set('v.OrdersFtchdSave', arr);
                    cmp.set('v.NoOrderFound', false);
                    // disable previous btn and highlight 1st page btn 
                    cmp.find("previousPgnBtn").set("v.disabled", true);

                    cmp.set('v.showPgntbtns', true);
                    window.setTimeout(
                        $A.getCallback(function () {
                            document.getElementById("pgn1Btn").style.backgroundColor = "rgb(133, 187, 235)";
                            document.getElementById("pgn2Btn").style.backgroundColor = "white";
                            document.getElementById("pgn3Btn").style.backgroundColor = "white";
                            document.getElementById("pgn4Btn").style.backgroundColor = "white";
                            document.getElementById("pgn5Btn").style.backgroundColor = "white";
                            helper.hidePgnBtn(cmp);
                            // disable next btn if total page is = to or < than last btn
                            var pgn5Btn = document.getElementById("pgn5Btn");
                            var pgn5BtnValuedev = Number(pgn5Btn.getAttribute("data-btnvalue"));
                            var totalPageSize = cmp.get("v.totalPageSize");
                            if (totalPageSize <= pgn5BtnValuedev) {
                                cmp.find("nextPgnBtn").set("v.disabled", true);
                            }
                        }), 500
                    );



                } else {
                    cmp.set('v.NoOrderFound', true);
                    cmp.set('v.showOrdersFetched', false);
                    // console.log('no order found -' + cmp.get('v.NoOrderFound'));
                }
            } else if (res.getState() === 'ERROR') {
                cmp.set('v.Spinner', false);
                var errors = res.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        // console.log(errors[0].message);
                    }
                }
            }
        });
        $A.enqueueAction(action);

    },
    openOrderDetail: function (cmp, event, helper) {
        window.open('/hello', '_blank');
    },
    FilterClicked: function (cmp, event, helper) {
        // console.log('filter clicked s');
        var showFiltr = cmp.get("v.showFilter");
        // console.log('showFiltr-' + showFiltr);
        if (showFiltr) {
            cmp.set("v.showFilter", false);
        } else {
            cmp.set("v.showFilter", true);
        }

    },
    onChngStatus: function (cmp, event, helper) {
        var status = cmp.find('statusId').get('v.value');
        // console.log('status - ' + status);
        cmp.set("v.statusSelected", status);
    },
    applyFilter: function (cmp, evt, helper) {
        // console.log('in contoller FILTER');
        helper.applyFilter(cmp);
    },
    clearFilter: function (cmp, event, helper) {
        cmp.set("v.Spinner", true);
        cmp.set("v.OrdersFetched", cmp.get("v.OrdersFtchdSave"));
        cmp.find("statusId").set("v.value", 'choose');
        cmp.set("v.Spinner", false);
    },
    previousPg: function (cmp, event, helper) {
        var pgn1Btn = document.getElementById("pgn1Btn");
        var pgn1BtnValue = Number(pgn1Btn.getAttribute("data-btnvalue"));
        // console.log('pgn1BtnValue-' + pgn1BtnValue);
        // if  pgn1 Btn Value != 1  - less 6 numbers
        if (pgn1BtnValue != 1) {
            document.getElementById("paginationCompDiv").style.visibility = "hidden";
            cmp.set("v.btn1Pgn", pgn1BtnValue - 6);
            cmp.find("nextPgnBtn").set("v.disabled", false);
            window.setTimeout(
                $A.getCallback(function () {
                    helper.removeHighlight(cmp);
                    helper.hidePgnBtn(cmp);
                }), 150
            );
            if (pgn1BtnValue == 6) {
                cmp.find("previousPgnBtn").set("v.disabled", true);
            }
        }

    },
    nextPg: function (cmp, event, helper) {
        var msglist = document.getElementById("pgn5Btn");
        var pgn5BtnValuedev = Number(msglist.getAttribute("data-btnvalue"));
        // console.log('pgn5BtnValuedev-' + typeof pgn5BtnValuedev);
        var totalPageSize = cmp.get("v.totalPageSize");
        // console.log('totalPageSize-' + totalPageSize);
        if (totalPageSize > pgn5BtnValuedev) {
            document.getElementById("paginationCompDiv").style.visibility = "hidden";
            cmp.set("v.btn1Pgn", pgn5BtnValuedev);
            cmp.find("previousPgnBtn").set("v.disabled", false);
            window.setTimeout(
                $A.getCallback(function () {
                    helper.removeHighlight(cmp);
                    helper.hidePgnBtn(cmp);
                }), 150
            );

        } else {
            // nextPgnBtn previousPgnBtn
            cmp.find("nextPgnBtn").set("v.disabled", true);
        }


    },
    pgNumClicked: function (cmp, event, helper) {

        var target = event.target;
        var btnValueNo = target.getAttribute("data-btnvalue");
        // console.log('btnValueNo-' + btnValueNo);
        // console.log('event.target.id-' + event.target.id);
        document.getElementById("pgn1Btn").style.backgroundColor = "white";
        document.getElementById("pgn2Btn").style.backgroundColor = "white";
        document.getElementById("pgn3Btn").style.backgroundColor = "white";
        document.getElementById("pgn4Btn").style.backgroundColor = "white";
        document.getElementById("pgn5Btn").style.backgroundColor = "white";
        document.getElementById(event.target.id).style.backgroundColor = "rgb(133, 187, 235)";
        // calling the selected page api  
        cmp.set("v.pageno", btnValueNo);
        var actionToDo = 'pageNoSelected';
        cmp.set("v.actionToDo", actionToDo);
        helper.setSearchList(cmp, event, helper);

    },
});