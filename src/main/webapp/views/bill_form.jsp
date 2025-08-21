<%@ page import="java.util.*, lk.icbt.pahana.model.Customer, lk.icbt.pahana.model.Item" %>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%-- (optional) esc helper if you later echo any raw strings --%>
<%!
    private static String esc(Object o){
        if (o == null) return "";
        String s = String.valueOf(o);
        return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;");
    }
%>

<%
    Object username = session.getAttribute("username");
    if (username == null) { response.sendRedirect(request.getContextPath()+"/views/login.jsp"); return; }



    @SuppressWarnings("unchecked")
    List<Customer> customers = (List<Customer>) request.getAttribute("customers");
    @SuppressWarnings("unchecked")
    List<Item> items = (List<Item>) request.getAttribute("items");
    String error = (String) request.getAttribute("error");
%>


<!doctype html>
<html>
<head>
    <title>New Bill • Pahana</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <style>
        :root{
            --bg1:#0f172a; --bg2:#1e293b; --txt:#e5e7eb; --mut:#94a3b8;
            --g1:#22c55e; --g2:#16a34a; --card:rgba(255,255,255,.08); --card-b:rgba(255,255,255,.18);
        }
        *{box-sizing:border-box}
        html,body{height:100%}
        body{
            margin:0; color:var(--txt);
            font:16px/1.5 system-ui,-apple-system,"Segoe UI",Roboto,Arial;
            background:
                    radial-gradient(1200px 600px at 10% -10%, #10b98122, transparent 60%),
                    radial-gradient(1000px 500px at 110% 110%, #22c55e22, transparent 60%),
                    linear-gradient(130deg, var(--bg1), var(--bg2));
        }
        a{color:#c7f9d4; text-decoration:none}
        a:hover{text-decoration:underline}

        .container{max-width:1100px; margin:0 auto; padding:24px}
        .top{display:flex; align-items:center; justify-content:space-between; gap:12px; margin-bottom:12px;}
        h2{margin:0; font-size:22px}
        .mut{color:var(--mut)}

        .grid{display:grid; grid-template-columns: 1fr 360px; gap:16px}
        @media (max-width:980px){ .grid{grid-template-columns:1fr} }

        .card{
            background:var(--card); border:1px solid var(--card-b); border-radius:16px;
            padding:16px; backdrop-filter: blur(8px);
            box-shadow: 0 20px 60px rgba(0,0,0,.35);
        }
        .banner{padding:10px 12px; border-radius:10px; margin:10px 0;
            border:1px solid #ef444477; background:#ef444433; color:#fecaca}

        .field{display:flex; gap:10px; flex-wrap:wrap; align-items:center; margin-bottom:12px}
        .label{font-size:13px; color:var(--mut)}
        select,input{
            padding:10px 12px; border-radius:12px; border:1px solid #ffffff2a; outline:none;
            background:rgba(255,255,255,.06); color:var(--txt);
        }
        select:focus,input:focus{ border-color:#22c55e80; box-shadow:0 0 0 3px #22c55e33 }

        .btn{
            padding:10px 14px; border-radius:12px; border:1px solid rgba(255,255,255,.22);
            background:rgba(255,255,255,.08); color:var(--txt); cursor:pointer; text-decoration:none;
        }
        .btn.primary{
            border-color:transparent; color:#fff; font-weight:600;
            background:linear-gradient(135deg,var(--g1),var(--g2));
            box-shadow:0 8px 22px rgba(34,197,94,.25);
        }
        .btn.danger{ border-color:#ffb4b4; background:#ef444444; color:#ffecec }
        .btn:active{ transform: translateY(1px) }

        .tablewrap{overflow:auto; border-radius:12px; border:1px solid var(--card-b); margin-top:8px}
        table{width:100%; border-collapse:separate; border-spacing:0; min-width:760px}
        thead th{
            position:sticky; top:0; z-index:1; background:rgba(15,23,42,.8); backdrop-filter:blur(6px);
            text-align:left; padding:10px; color:#cbd5e1; border-bottom:1px solid var(--card-b);
        }
        tbody td{ padding:10px; border-bottom:1px solid rgba(255,255,255,.12) }
        tbody tr:hover{ background:rgba(255,255,255,.06) }
        .right{text-align:right}

        .totals .row{display:flex; align-items:center; justify-content:space-between; padding:6px 0; border-bottom:1px solid rgba(255,255,255,.12)}
        .totals .row:last-child{border-bottom:none}
        .totals .grand{ font-weight:700; }


    </style>

    <script>
        function toNum(x){ var n = parseFloat(x); return isNaN(n) ? 0 : n; }
        function fmt(n){ return toNum(n).toFixed(2); }

        function getPriceFromSelect(sel){
            var opt = sel.options[sel.selectedIndex];
            return toNum(opt ? opt.getAttribute('data-price') : 0);
        }

        function updateRowFromSelect(sel){
            const row = sel.closest('tr');
            const price = getPriceFromSelect(sel);
            const qtyInput = row.querySelector('input[name="qty"]');
            const qty = toNum(qtyInput && qtyInput.value);
            row.querySelector('.unit-price').textContent = fmt(price);
            row.querySelector('.amount').textContent = fmt(price * qty);
            updateTotals();
        }

        function updateRowFromQty(qtyInput){
            const row = qtyInput.closest('tr');
            const sel = row.querySelector('select[name="item_id"]');
            const price = getPriceFromSelect(sel);


            const qty = Math.max(1, toNum(qtyInput.value||"1"));
            qtyInput.value = qty; // normalize


            row.querySelector('.unit-price').textContent = fmt(price);
            row.querySelector('.amount').textContent = fmt(price * qty);
            updateTotals();
        }

        function addRow(){
            const tbody = document.getElementById('lines');
            const tpl = document.getElementById('row-template').content.cloneNode(true);
            tbody.appendChild(tpl);

            const newRow = tbody.lastElementChild;
            const sel = newRow.querySelector('select[name="item_id"]');
            const qty = newRow.querySelector('input[name="qty"]');
            sel.addEventListener('change', function(){ updateRowFromSelect(sel); });
            qty.addEventListener('input', function(){ updateRowFromQty(qty); });
            updateRowFromSelect(sel);
        }

        function removeRow(btn){

            const tbody = document.getElementById('lines');
            if (tbody.children.length <= 1){ alert('At least one line is required.'); return; }
            const tr = btn.closest('tr'); tr.parentNode.removeChild(tr);


            updateTotals();
        }

        function updateTotals(){



            let subtotal = 0;
            document.querySelectorAll('#lines .amount').forEach(td => subtotal += toNum(td.textContent));
            const discPct = toNum(document.querySelector('input[name="discount_pct"]').value);
            const taxPct  = toNum(document.querySelector('input[name="tax_pct"]').value);

            const discountAmt = subtotal * (discPct / 100.0);
            const taxable     = subtotal - discountAmt;
            const taxAmt      = taxable * (taxPct / 100.0);
            const total       = taxable + taxAmt;

            document.getElementById('subtotal').textContent     = fmt(subtotal);
            document.getElementById('discount_amt').textContent = fmt(discountAmt);
            document.getElementById('tax_amt').textContent      = fmt(taxAmt);
            document.getElementById('grand_total').textContent  = fmt(total);
        }

        document.addEventListener('DOMContentLoaded', function(){

            // wire first row + totals


            document.querySelectorAll('select[name="item_id"]').forEach(sel=>{
                sel.addEventListener('change', function(){ updateRowFromSelect(sel); });
                updateRowFromSelect(sel);
            });
            document.querySelectorAll('input[name="qty"]').forEach(qty=>{
                qty.addEventListener('input', function(){ updateRowFromQty(qty); });
                updateRowFromQty(qty);
            });
            ['discount_pct','tax_pct'].forEach(name=>{
                const el = document.querySelector('input[name="'+name+'"]');
                if (el) el.addEventListener('input', updateTotals);
            });



            // basic client validation to avoid empty items
            document.getElementById('billForm').addEventListener('submit', function(e){
                const selects = Array.from(document.querySelectorAll('select[name="item_id"]'));
                if (selects.some(s => !s.value)){
                    e.preventDefault();
                    alert('Please select an item on every line.');
                    return false;
                }
            });

        });
    </script>
</head>
<body>



<div class="container">
    <div class="top">
        <div>
            <h2>New Bill</h2>
            <div class="mut">Select a customer, add items, and confirm totals. Prices auto-fill from the item master.</div>
        </div>
        <div><a href="<%=request.getContextPath()%>/bills">&larr; Back to Bills</a></div>
    </div>

    <% if (error != null && !error.isBlank()) { %>
    <div class="banner"><%= esc(error) %></div>
    <% } %>

    <form id="billForm" method="post" action="<%=request.getContextPath()%>/bills/create">
        <div class="grid">
            <!-- Left: lines -->
            <div class="card">
                <div class="field">
                    <label class="label" for="customer_id">Customer</label>
                    <select id="customer_id" name="customer_id" required>
                        <option value="">-- select --</option>
                        <% for (Customer c : customers) { %>
                        <option value="<%= c.getId() %>"><%= esc(c.getAccountNo()) %> - <%= esc(c.getName()) %></option>
                        <% } %>
                    </select>
                </div>

                <div class="field" style="gap:8px">
                    <label class="label">Discount %</label>
                    <input name="discount_pct" type="number" step="0.01" min="0" value="0" style="width:140px">
                    <label class="label" style="margin-left:12px">Tax %</label>
                    <input name="tax_pct" type="number" step="0.01" min="0" value="0" style="width:140px">
                </div>

                <div class="tablewrap">
                    <table>
                        <thead>
                        <tr>
                            <th style="width:45%">Item</th>
                            <th class="right" style="width:15%">Unit Price</th>
                            <th style="width:15%">Qty</th>
                            <th class="right" style="width:15%">Amount</th>
                            <th style="width:10%">Actions</th>
                        </tr>
                        </thead>
                        <tbody id="lines">
                        <tr>
                            <td>
                                <select name="item_id" required>
                                    <option value="">-- item --</option>
                                    <% for (Item it : items) { %>
                                    <option value="<%= it.getId() %>" data-price="<%= it.getUnitPrice().setScale(2) %>">
                                        <%= esc(it.getName()) %>
                                    </option>
                                    <% } %>
                                </select>
                            </td>
                            <td class="unit-price right">0.00</td>
                            <td><input name="qty" type="number" min="1" value="1" required style="width:90px"></td>
                            <td class="amount right">0.00</td>
                            <td><button type="button" class="btn danger" onclick="removeRow(this)">Remove</button></td>
                        </tr>
                        </tbody>
                    </table>
                </div>

                <p style="margin-top:10px">
                    <button type="button" class="btn" onclick="addRow()">+ Add Line</button>
                </p>
            </div>

            <!-- Right: totals -->
            <div class="card totals">
                <div class="row"><span>Subtotal</span>     <span id="subtotal">0.00</span></div>
                <div class="row"><span>Discount</span>     <span id="discount_amt">0.00</span></div>
                <div class="row"><span>Tax</span>          <span id="tax_amt">0.00</span></div>
                <div class="row grand"><span>Total</span>  <span id="grand_total">0.00</span></div>

                <div style="margin-top:14px; display:flex; gap:10px; flex-wrap:wrap">
                    <button type="submit" class="btn primary">Create Bill</button>
                    <a class="btn" href="<%=request.getContextPath()%>/bills">Cancel</a>
                </div>
            </div>
        </div>
    </form>
</div>



<template id="row-template">
    <tr>
        <td>
            <select name="item_id" required>
                <option value="">-- item --</option>
                <% for (Item it : items) { %>
                <option value="<%= it.getId() %>" data-price="<%= it.getUnitPrice().setScale(2) %>">


                    <%= esc(it.getName()) %>


                </option>
                <% } %>
            </select>
        </td>
        <td class="unit-price right">0.00</td>


        <td><input name="qty" type="number" min="1" value="1" required style="width:90px"></td>
        <td class="amount right">0.00</td>
        <td><button type="button" class="btn danger" onclick="removeRow(this)">Remove</button></td>


    </tr>
</template>

</body>
</html>
