
<%@ page import="lk.icbt.pahana.model.Bill, lk.icbt.pahana.model.BillItem, java.util.*, java.math.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%-- Helpers (declare with <%! ... %>) --%>
<%!
    private static String esc(Object o){
        if (o == null) return "";
        String s = String.valueOf(o);
        return s.replace("&","&amp;").replace("<","&lt;")
                .replace(">","&gt;").replace("\"","&quot;");
    }
    private static String money(BigDecimal v){
        if (v == null) return "0.00";
        return v.setScale(2, RoundingMode.HALF_UP).toString();
    }
%>


<%
    Object username = session.getAttribute("username");
    if (username == null) { response.sendRedirect(request.getContextPath()+"/views/login.jsp"); return; }
    Bill b = (Bill) request.getAttribute("bill");

    String status = b.getStatus()==null ? "" : b.getStatus().toUpperCase(Locale.ENGLISH);
    String statusCls = "issued";
    if ("PAID".equals(status)) statusCls = "paid";
    else if ("CANCELLED".equals(status) || "VOID".equals(status)) statusCls = "cancelled";
%>

<!doctype html>
<html>
<head>
    <title>Invoice <%= esc(b.getBillNo()) %> • Pahana</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <style>
        :root{
            --bg1:#0f172a; --bg2:#1e293b; --txt:#0b1220; --mut:#6b7280;
            --g1:#22c55e; --g2:#16a34a;
            --card:#ffffff; --ink:#0f172a; --line:#e5e7eb;
            --ok:#16a34a; --warn:#f59e0b; --err:#dc2626;
        }
        *{box-sizing:border-box}
        html,body{height:100%}
        body{
            margin:0; font:16px/1.5 system-ui,-apple-system,"Segoe UI",Roboto,Arial;
            color:var(--ink);
            background:
                    radial-gradient(1200px 600px at 10% -10%, #10b98111, transparent 60%),
                    radial-gradient(1000px 500px at 110% 110%, #22c55e11, transparent 60%),
                    linear-gradient(130deg, var(--bg1), var(--bg2));
        }
        .wrap{max-width:980px; margin:0 auto; padding:22px}
        .toolbar{
            display:flex; gap:10px; align-items:center; margin-bottom:14px;
        }
        .btn{
            padding:10px 12px; border-radius:10px; border:1px solid #d1d5db;
            background:#ffffff; color:#111827; cursor:pointer; text-decoration:none;
            box-shadow:0 2px 10px rgba(0,0,0,.06);
        }
        .btn.primary{
            border-color:transparent; color:#fff;
            background:linear-gradient(135deg,var(--g1),var(--g2));
            box-shadow:0 8px 22px rgba(34,197,94,.25); font-weight:600;
        }
        .card{
            background:var(--card); border-radius:16px; padding:18px;
            box-shadow:0 24px 60px rgba(0,0,0,.25);
        }
        .head{
            display:flex; align-items:flex-start; justify-content:space-between; gap:16px; margin-bottom:8px;
            border-bottom:1px solid var(--line); padding-bottom:12px;
        }
        .brand{display:flex; align-items:center; gap:12px}
        .logo{width:44px; height:44px; border-radius:12px; display:grid; place-items:center; color:#fff; font-weight:700;
            background:linear-gradient(145deg,var(--g1),var(--g2)); box-shadow:inset 0 0 18px #ffffff22}
        .mut{color:var(--mut)}
        h1{margin:0; font-size:22px}
        .right{text-align:right}

        .badge{
            display:inline-block; padding:4px 10px; border-radius:999px; font-size:12px; border:1px solid;
        }
        .badge.issued{ color:#065f46; border-color:#a7f3d0; background:#ecfdf5 }
        .badge.paid{ color:#0c4a6e; border-color:#bae6fd; background:#e0f2fe }
        .badge.cancelled{ color:#7f1d1d; border-color:#fecaca; background:#fee2e2 }

        .cols{display:grid; grid-template-columns: 1fr 1fr; gap:14px; margin:12px 0 6px}
        @media (max-width:760px){ .cols{grid-template-columns:1fr} }
        .box{border:1px solid var(--line); border-radius:12px; padding:12px; background:#fafafa}

        table{width:100%; border-collapse:separate; border-spacing:0; margin-top:10px}
        thead th{
            text-align:left; background:#f8fafc; color:#111827; border-top:1px solid var(--line);
            border-bottom:1px solid var(--line); padding:10px;
        }
        thead th:first-child{border-top-left-radius:10px}
        thead th:last-child{border-top-right-radius:10px}
        tbody td{ padding:10px; border-bottom:1px solid var(--line) }
        tfoot td{ padding:8px 10px }
        tbody tr:last-child td{ border-bottom:1px solid var(--line) }
        .amt{ text-align:right; white-space:nowrap }
        .name{ max-width:520px }

        .totals{
            width:360px; margin-left:auto; margin-top:14px; border:1px solid var(--line); border-radius:12px; overflow:hidden;
        }
        .totals table{ margin:0 }
        .totals td{ padding:8px 10px; }
        .totals tr:nth-child(odd) td{ background:#fafafa }
        .totals .lab{ text-align:right; color:#374151 }
        .totals .grand{ font-weight:700; background:#f3f4f6 }

        footer{ color:#6b7280; font-size:12px; text-align:center; margin-top:12px }

        /* Print layout */
        @media print {
            body { background:#fff; }
            .noprint { display:none !important; }
            .wrap{ padding:0 }
            .card{ box-shadow:none; border:none }
            .box{ background:#fff }
            thead th{ background:#fff }
            .btn{ display:none !important }
            a{ color:#000 !important; text-decoration:none }
            @page { margin: 12mm }

        }
    </style>
    <script>
        function printBill(){ window.print(); }
    </script>
</head>
<body>

<div class="wrap">
    <div class="toolbar noprint">
        <a class="btn" href="<%=request.getContextPath()%>/bills">&larr; Back to Bills</a>
        <a class="btn" href="<%=request.getContextPath()%>/bills/new">+ New Bill</a>
        <button class="btn primary" type="button" onclick="printBill()">Print Bill</button>
    </div>

    <div class="card">
        <div class="head">
            <div class="brand">
                <div class="logo">P</div>
                <div>
                    <h1>Invoice</h1>
                    <div class="mut">Pahana Billing Management</div>
                </div>
            </div>
            <div class="right">
                <div style="font-weight:700"># <%= esc(b.getBillNo()) %></div>
                <div class="mut">Date: <%= esc(b.getBillDate()) %></div>
                <div style="margin-top:6px">
                    <span class="badge <%= statusCls %>"><%= status.isEmpty() ? "ISSUED" : status %></span>
                </div>
            </div>
        </div>

        <div class="cols">
            <div class="box">
                <div style="font-weight:700; margin-bottom:6px">Bill To</div>
                <div><%= esc(b.getCustomerName()) %></div>
                <%-- If you later add customer address/phone to Bill, render here --%>
            </div>
            <div class="box">
                <div style="font-weight:700; margin-bottom:6px">Summary</div>
                <div class="mut">Prepared by: <%= esc(username) %></div>
                <div class="mut">Status: <%= status.isEmpty() ? "ISSUED" : status %></div>
            </div>
        </div>

        <table aria-label="Invoice lines">
            <thead>
            <tr>
                <th>Item</th>
                <th class="amt">Qty</th>
                <th class="amt">Unit Price</th>
                <th class="amt">Line Total</th>
            </tr>
            </thead>
            <tbody>
            <% for (BillItem it : b.getItems()) { %>
            <tr>
                <td class="name"><%= esc(it.getItemName()) %></td>
                <td class="amt"><%= it.getQty() %></td>
                <td class="amt"><%= money(it.getUnitPrice()) %></td>
                <td class="amt"><%= money(it.getLineTotal()) %></td>
            </tr>
            <% } %>
            </tbody>
        </table>

        <div class="totals">
            <table>
                <tr>
                    <td class="lab" style="width:70%">Subtotal</td>
                    <td class="amt" style="width:30%"><%= money(b.getSubtotal()) %></td>
                </tr>
                <tr>
                    <td class="lab">Discount</td>
                    <td class="amt">- <%= money(b.getDiscount()) %></td>
                </tr>
                <tr>
                    <td class="lab">Tax</td>
                    <td class="amt"><%= money(b.getTax()) %></td>
                </tr>
                <tr>
                    <td class="lab grand">Total</td>
                    <td class="amt grand"><%= money(b.getTotal()) %></td>
                </tr>
            </table>
        </div>

        <footer class="noprint">Thank you for your business.</footer>
    </div>
</div>

</body>
</html>
