<%@ page import="java.util.*, lk.icbt.pahana.model.Customer, lk.icbt.pahana.model.Item" %>
<%@ page contentType="text/html;charset=UTF-8" %>
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
    <title>New Bill</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
        body{font-family:Arial,Helvetica,sans-serif;margin:24px;}
        table{border-collapse:collapse;width:100%;}
        th,td{border:1px solid #ddd;padding:6px;}
        th{background:#f3f3f3;}
        .btn{padding:8px 12px;border:1px solid #1b5e20;background:#2e7d32;color:#fff;border-radius:8px;cursor:pointer;}
        .danger{border-color:#8b0000;background:#b22222;}
        .row{margin:8px 0;}
        .right{text-align:right;}
        .totals{max-width:480px;margin-left:auto;}
        .totals td{border:none;padding:4px 6px;}
        .totals .label{font-weight:bold;}
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
            const qty = toNum(qtyInput.value);
            row.querySelector('.unit-price').textContent = fmt(price);
            row.querySelector('.amount').textContent = fmt(price * qty);
            updateTotals();
        }

        function addRow(){
            const tbody = document.getElementById('lines');
            const tpl = document.getElementById('row-template').content.cloneNode(true);
            tbody.appendChild(tpl);
            // initialize just-added row
            const newRow = tbody.lastElementChild;
            const sel = newRow.querySelector('select[name="item_id"]');
            const qty = newRow.querySelector('input[name="qty"]');
            sel.addEventListener('change', function(){ updateRowFromSelect(sel); });
            qty.addEventListener('input', function(){ updateRowFromQty(qty); });
            updateRowFromSelect(sel);
        }

        function removeRow(btn){
            const tr = btn.closest('tr');
            tr.parentNode.removeChild(tr);
            updateTotals();
        }

        function updateTotals(){
            // subtotal = sum of amounts
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
            // wire up first row + totals inputs
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
        });
    </script>
</head>
<body>
<h2>New Bill</h2>
<p><a href="<%=request.getContextPath()%>/bills">&larr; Back to Bills</a></p>

<% if (error != null && !error.isBlank()) { %>
<div style="background:#ffecec;border:1px solid #f5b5b5;color:#a40000;padding:8px;border-radius:8px;margin-bottom:12px;"><%= error %></div>
<% } %>

<form method="post" action="<%=request.getContextPath()%>/bills/create">
    <div class="row">
        <label>Customer:
            <select name="customer_id" required>
                <option value="">-- select --</option>
                <% for (Customer c : customers) { %>
                <option value="<%= c.getId() %>"><%= c.getAccountNo() %> - <%= c.getName() %></option>
                <% } %>
            </select>
        </label>
    </div>

    <div class="row">
        <label>Discount %: <input name="discount_pct" type="number" step="0.01" min="0" value="0"></label>
        <label>Tax %: <input name="tax_pct" type="number" step="0.01" min="0" value="0"></label>
    </div>

    <table>
        <thead>
        <tr>
            <th style="width:45%;">Item</th>
            <th style="width:15%;" class="right">Unit Price</th>
            <th style="width:15%;">Qty</th>
            <th style="width:15%;" class="right">Amount</th>
            <th style="width:10%;">Actions</th>
        </tr>
        </thead>
        <tbody id="lines">
        <tr>
            <td>
                <select name="item_id" required>
                    <option value="">-- item --</option>
                    <% for (Item it : items) { %>
                    <option value="<%= it.getId() %>" data-price="<%= it.getUnitPrice().setScale(2) %>">
                        <%= it.getName() %>
                    </option>
                    <% } %>
                </select>
            </td>
            <td class="unit-price right">0.00</td>
            <td><input name="qty" type="number" min="1" value="1" required></td>
            <td class="amount right">0.00</td>
            <td><button type="button" class="danger btn" onclick="removeRow(this)">Remove</button></td>
        </tr>
        </tbody>
    </table>

    <p><button type="button" class="btn" onclick="addRow()">+ Add Line</button></p>

    <table class="totals">
        <tr><td class="label right" style="width:60%;">Subtotal</td><td class="right" id="subtotal">0.00</td></tr>
        <tr><td class="label right">Discount</td><td class="right" id="discount_amt">0.00</td></tr>
        <tr><td class="label right">Tax</td><td class="right" id="tax_amt">0.00</td></tr>
        <tr><td class="label right">Grand Total</td><td class="right" id="grand_total">0.00</td></tr>
    </table>

    <p><button type="submit" class="btn">Create Bill</button></p>
</form>

<template id="row-template">
    <tr>
        <td>
            <select name="item_id" required>
                <option value="">-- item --</option>
                <% for (Item it : items) { %>
                <option value="<%= it.getId() %>" data-price="<%= it.getUnitPrice().setScale(2) %>">
                    <%= it.getName() %>
                </option>
                <% } %>
            </select>
        </td>
        <td class="unit-price right">0.00</td>
        <td><input name="qty" type="number" min="1" value="1" required></td>
        <td class="amount right">0.00</td>
        <td><button type="button" class="danger btn" onclick="removeRow(this)">Remove</button></td>
    </tr>
</template>

</body>
</html>
