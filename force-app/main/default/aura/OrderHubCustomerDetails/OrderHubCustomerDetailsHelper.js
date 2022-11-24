({
    applyFilter: function (cmp) {
        // console.log('in helper FILTER');
        cmp.set("v.Spinner", true);
        var ordersFiltered = new Array();
        var orders = cmp.get("v.OrdersFtchdSave");
        if (cmp.find('statusId').get('v.value') != 'choose') {
            for (let i = 0; i < orders.length; i++) {
                var element = orders[i];
                //filter by Status
                if (!$A.util.isEmpty(cmp.get("v.statusSelected"))) {
                    if (!$A.util.isEmpty(element) && element.orderStatus == cmp.find('statusId').get('v.value')) {
                        ordersFiltered.push(element);
                    }
                }
            }
            cmp.set("v.OrdersFetched", ordersFiltered);

        }
        cmp.set("v.Spinner", false);
    },
    setSearchList: function (cmp) {
        var actionToDo = cmp.get("v.actionToDo");
        // console.log("logLineH24->" + actionToDo);
        if (actionToDo === "previous") {
            // console.log('previous pg ');
            var pageno = cmp.get("v.pageno");
            if (pageno != 1) {
                pageno--;
                cmp.set("v.pageno", pageno);
            }
        }
        if (actionToDo === "next") {
            // console.log('next pg ');
            var pageno = cmp.get("v.pageno");
            pageno++;
            cmp.set("v.pageno", pageno);
        }
        if (actionToDo === "pageNoSelected") {
            var pageno = cmp.get("v.pageno");
        }


        var recId = cmp.get("v.recordID");
        cmp.set("v.showList", false);
        cmp.set("v.Spinner", true);

        // API callout  then save in OrdersFetched  getOrdersForCustomer(String accountId)
        var action = cmp.get('c.getOrdersForCustomer');
        //action.setStorable();

        action.setParams({
            accountId: recId,
            channel: cmp.find('channel').get('v.value'),
            pagesize: cmp.get("v.pagesize"),
            pageno: cmp.get("v.pageno")

        });
        action.setCallback(this, function (res) {
            if (res.getState() === 'SUCCESS') {
                cmp.set('v.Spinner', false);
                // console.log(JSON.stringify(res.getReturnValue()));
                if (!$A.util.isEmpty(res.getReturnValue()) && !$A.util.isEmpty(res.getReturnValue().paginatedOrderResult) && !$A.util.isEmpty(res.getReturnValue().paginatedOrderResult.data)) {
                    var arr = [];
                    arr = res.getReturnValue().paginatedOrderResult.data;
                    arr.sort(function (a, b) {
                        a = new Date(a.orderDate);
                        b = new Date(b.orderDate);
                        return a > b ? -1 : a < b ? 1 : 0;
                    });
                    // console.log('arr-' + arr);
                    cmp.set("v.addressType", res.getReturnValue().metadata.addresMappg);
                    var len = arr.length;
                    cmp.set("v.recordsPerPage", len);
                    cmp.set('v.OrdersFetched', arr);
                    cmp.set('v.OrdersFtchdSave', arr);
                    cmp.set('v.NoOrderFound', false);
                    if (cmp.get("v.recordsPerPage") !== 10) {
                        cmp.set("v.btnDisable", false);
                    }
                } else {
                    cmp.set('v.NoOrderFound', true);
                    cmp.set('v.showOrdersFetched', false);
                    // console.log('no order found -' + cmp.get('v.NoOrderFound', true));
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
    hidePgnBtn: function (cmp) {
        var totalPageSize = cmp.get("v.totalPageSize");
        // ftech all values of pgn btns then if they are greater than totalPageSize hide them.
        var pgn1Btn = document.getElementById("pgn1Btn");
        var pgn1BtnValue = Number(pgn1Btn.getAttribute("data-btnvalue"));
        if (pgn1BtnValue > totalPageSize) {
            // console.log('btn greter thn tot pg');
            pgn1Btn.style.display = 'none';
        } else {
            pgn1Btn.style.display = 'block';
            // console.log('qw');
        }

        var pgn2Btn = document.getElementById("pgn2Btn");
        var pgn2BtnValue = Number(pgn2Btn.getAttribute("data-btnvalue"));
        if (pgn2BtnValue > totalPageSize) {
            // console.log('btn greter thn tot pg');
            pgn2Btn.style.display = 'none';
        } else {
            pgn2Btn.style.display = 'block';
            // console.log('qw');
        }

        var pgn3Btn = document.getElementById("pgn3Btn");
        var pgn3BtnValue = Number(pgn3Btn.getAttribute("data-btnvalue"));
        if (pgn3BtnValue > totalPageSize) {
            // console.log('btn greter thn tot pg');
            pgn3Btn.style.display = 'none';
        } else {
            pgn3Btn.style.display = 'block';
            // console.log('qw');
        }

        var pgn4Btn = document.getElementById("pgn4Btn");
        var pgn4BtnValue = Number(pgn4Btn.getAttribute("data-btnvalue"));
        if (pgn4BtnValue > totalPageSize) {
            // console.log('btn greter thn tot pg');
            pgn4Btn.style.display = 'none';
        } else {
            pgn4Btn.style.display = 'block';
            // console.log('qw');
        }

        var pgn5Btn = document.getElementById("pgn5Btn");
        var pgn5BtnValue = Number(pgn5Btn.getAttribute("data-btnvalue"));
        if (pgn5BtnValue > totalPageSize) {
            // console.log('btn greter thn tot pg');
            pgn5Btn.style.display = 'none';
            cmp.find("nextPgnBtn").set("v.disabled", true);
        } else {
            pgn5Btn.style.display = 'block';
            // console.log('qw');
        }
        document.getElementById("paginationCompDiv").style.visibility = "visible";


    },
    /**
     * 
     * @param {*} cmp 
     * when a nxt or previous page is click then make the highlight background go away , when a xact page no is shown dn highlight it
     */
    removeHighlight: function (cmp) {
        var pageno = cmp.get("v.pageno");
        // console.log(' remove hight pageno-' + pageno);
        var pgn1Btn = document.getElementById("pgn1Btn");
        var pgn1BtnValue = Number(pgn1Btn.getAttribute("data-btnvalue"));
        if (pgn1BtnValue == pageno) {
            // console.log('pgn1BtnValue hightning-' + pgn1BtnValue);
            pgn1Btn.style.backgroundColor = "rgb(133, 187, 235)";
        } else {
            pgn1Btn.style.backgroundColor = 'white';
            // console.log('pgn1BtnValue white -' + pgn1BtnValue);
        }

        var pgn2Btn = document.getElementById("pgn2Btn");
        var pgn2BtnValue = Number(pgn2Btn.getAttribute("data-btnvalue"));
        if (pgn2BtnValue == pageno) {
            // console.log('pgn2BtnValue hightning-' + pgn2BtnValue);
            pgn2Btn.style.backgroundColor = "rgb(133, 187, 235)";
        } else {
            pgn2Btn.style.backgroundColor = 'white';
            // console.log('pgn2BtnValue white -' + pgn2BtnValue);
        }

        var pgn3Btn = document.getElementById("pgn3Btn");
        var pgn3BtnValue = Number(pgn3Btn.getAttribute("data-btnvalue"));
        if (pgn3BtnValue == pageno) {
            // console.log('pgn3BtnValue hightning-' + pgn3BtnValue);
            pgn3Btn.style.backgroundColor = "rgb(133, 187, 235)";
        } else {
            pgn3Btn.style.backgroundColor = 'white';
            // console.log('pgn3BtnValue white -' + pgn3BtnValue);
        }

        var pgn4Btn = document.getElementById("pgn4Btn");
        var pgn4BtnValue = Number(pgn4Btn.getAttribute("data-btnvalue"));
        if (pgn4BtnValue == pageno) {
            // console.log('pgn4BtnValue hightning-' + pgn4BtnValue);
            pgn4Btn.style.backgroundColor = "rgb(133, 187, 235)";
        } else {
            pgn4Btn.style.backgroundColor = 'white';
            // console.log('pgn4BtnValue white -' + pgn4BtnValue);
        }

        var pgn5Btn = document.getElementById("pgn5Btn");
        var pgn5BtnValue = Number(pgn5Btn.getAttribute("data-btnvalue"));
        if (pgn5BtnValue == pageno) {
            // console.log('pgn5BtnValue hightning-' + pgn5BtnValue);
            pgn5Btn.style.backgroundColor = "rgb(133, 187, 235)";
        } else {
            pgn5Btn.style.backgroundColor = 'white';
            // console.log('pgn5BtnValue white -' + pgn5BtnValue);
        }
    },
})