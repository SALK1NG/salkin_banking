$(document).ready(function () {
    let language = {};
    let formData = {};

    $.getJSON("config.json", function (data) {
        let lang = data.lang || "DE";
        language = data[lang]["LAUNGAGE"];
        formData = data[lang]["DYNAMIC_FORM_DATA"];
    });

    window.addEventListener("message", function (event) {
        if (event.data.showMenu) {
            $("#wrapper").fadeIn(200).css("display", "flex");
            renderUI(event.data.datas);
        } else if (event.data.updateData) {
            // IDs im HTML müssen money-bank und money-cash sein
            if (event.data.data.money !== undefined) {
                $("#money-cash").text("$ " + event.data.data.money.toLocaleString());
            }
            if (event.data.data.bankMoney !== undefined) {
                $("#money-bank").text("$ " + event.data.data.bankMoney.toLocaleString());
            }
        }
    });

    function renderUI(data) {
        $("#container").empty();
        
        let leftCol = $('<div class="column" style="width:320px;"></div>').appendTo("#container");
        let rightCol = $('<div class="column" style="width:400px; display:flex; flex-direction:column; gap:15px;"></div>').appendTo("#container");

        // Karte
        $(`<div id="bankcard">
            <div style="font-size:10px; opacity:0.5; margin-bottom:10px;">FLECCA DEBIT</div>
            <div style="font-size:20px; letter-spacing:3px; margin-bottom:20px;">${data.bankCardData.cardNumber}</div>
            <div style="display:flex; justify-content:space-between; font-size:12px; opacity:0.8;">
                <span>${data.bankCardData.name}</span>
                <span>${data.bankCardData.createdDate}</span>
            </div>
        </div>`).appendTo(leftCol);

        // Geld Panels mit IDs für Updates
        data.your_money_panel.accountsData.forEach(acc => {
            $(`<div class="panel" style="margin-bottom:10px;">
                <div style="font-size:11px; opacity:0.5; text-transform:uppercase;">${acc.name}</div>
                <div id="money-${acc.name}" class="money-val">$ ${acc.amount.toLocaleString()}</div>
            </div>`).appendTo(leftCol);
        });

        $('<button style="background:#fa5252; margin-top:10px; border:none;">SCHLIESSEN</button>').appendTo(leftCol).click(closeUI);

        // Aktionen
        formData.forEach(form => {
            if (form.elementID && form.elementID !== "body") {
                let p = $(`<div class="panel">
                    <h3>${form.title}</h3>
                    <input type="number" id="input-${form.name}" placeholder="Betrag...">
                    <button id="btn-${form.name}">${form.buttonText}</button>
                </div>`).appendTo(rightCol);

                p.find('button').click(function() {
                    let val = $(`#input-${form.name}`).val();
                    if(val > 0) {
                        $.post(`https://${GetParentResourceName()}/clickButton`, JSON.stringify({
                            [form.name]: val
                        }));
                        $(`#input-${form.name}`).val("");
                    }
                });
            }
        });
    }

    function closeUI() {
        $("#wrapper").fadeOut(200);
        $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}));
    }

    function GetParentResourceName() {
        return window.GetParentResourceName ? window.GetParentResourceName() : "esx_banking";
    }

    $(document).keyup(function (e) {
        if (e.which == 27) closeUI();
    });
});