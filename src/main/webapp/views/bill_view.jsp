<%@ page import="lk.icbt.pahana.model.Bill, lk.icbt.pahana.model.BillItem, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    Object username = session.getAttribute("username");
    if (username == null) { response.sendRedirect(request.getContextPath()+"/views/login.jsp"); return; }
    Bill b = (Bill) request.getAttribute("bill");
%>
<!doctype html>
<html>
<head>
    <title>Invoice <%= b.getBillNo() %></title>
    <style>
        body{font-family:Arial,Helvetica,sans-serif;margin:24px;}
        .toolbar{display:flex;gap:10px;align-items:center;margin-bottom:12px;}
        .btn{padding:8px 12px;border:1px solid #1b5e20;background:#2e7d32;color:#fff;border-radius:8px;text-decoration:none;cursor:pointer;}
        .link{color:#2e7d32;text-decoration:none}
        .link:hover{text-decoration:underline}
        table{border-collapse:collapse;width:100%;}
        th,td{border:1px solid #ddd;padding:6px;}
        th{background:#f3f3f3;}
        .right{text-align:right;}

        /* Hide buttons/links when printing; tighten margins */
        @media print {
            .noprint { display: none !important; }
            body { margin: 10mm; }
        }
    </style>
    <script>
        function printBill(){ window.print(); }
    </script>
</head>
<body>

<div class="toolbar noprint">
    <a class="link" href="<%=request.getContextPath()%>/bills">&larr; Back to Bills</a>
    <button class="btn" type="button" onclick="printBill()">Print Bill</button>
</div>

<h2>Invoice: <%= b.getBillNo() %></h2>

<p>
    <b>Customer:</b> <%= b.getCustomerName() %><br>
    <b>Date:</b> <%= b.getBillDate() %><br>
    <b>Status:</b> <%= b.getStatus() %>
</p>

<table>
    <tr><th>Item</th><th class="right">Qty</th><th class="right">Unit Price</th><th class="right">Line Total</th></tr>
    <% for (BillItem it : b.getItems()) { %>
    <tr>
        <td><%= it.getItemName() %></td>
        <td class="right"><%= it.getQty() %></td>
        <td class="right"><%= it.getUnitPrice().setScale(2) %></td>
        <td class="right"><%= it.getLineTotal().setScale(2) %></td>
    </tr>
    <% } %>
    <tr><td colspan="3" class="right"><b>Subtotal</b></td><td class="right"><%= b.getSubtotal().setScale(2) %></td></tr>
    <tr><td colspan="3" class="right"><b>Discount</b></td><td class="right"><%= b.getDiscount().setScale(2) %></td></tr>
    <tr><td colspan="3" class="right"><b>Tax</b></td><td class="right"><%= b.getTax().setScale(2) %></td></tr>
    <tr><td colspan="3" class="right"><b>Total</b></td><td class="right"><%= b.getTotal().setScale(2) %></td></tr>
</table>

</body>
</html>
