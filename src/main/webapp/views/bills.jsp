<%@ page import="java.util.*, lk.icbt.pahana.model.Bill" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    Object username = session.getAttribute("username");
    if (username == null) { response.sendRedirect(request.getContextPath()+"/views/login.jsp"); return; }
    @SuppressWarnings("unchecked")
    List<Bill> bills = (List<Bill>) request.getAttribute("bills");
    String q = (String) (request.getAttribute("q")==null? "" : request.getAttribute("q"));
%>
<!doctype html>
<html>
<head><title>Bills</title>
    <style>
        body{font-family:Arial,Helvetica,sans-serif;margin:24px;}
        table{border-collapse:collapse;width:100%;}
        th,td{border:1px solid #ddd;padding:8px;text-align:left;}
        th{background:#f3f3f3;}
        .toolbar{display:flex;gap:10px;align-items:center;margin-bottom:12px;}
        .pill{padding:6px 10px;border:1px solid #2e7d32;background:#2e7d32;color:#fff;border-radius:8px;text-decoration:none;}
    </style>
</head>
<body>
<h2>Bills</h2>
<div class="toolbar">
    <form method="get" action="<%=request.getContextPath()%>/bills">
        <input name="q" value="<%=q%>" placeholder="Search bill no / customer"/>
        <button type="submit">Search</button>
    </form>
    <a class="pill" href="<%=request.getContextPath()%>/bills/new">+ New Bill</a>
    <a href="<%=request.getContextPath()%>/views/dashboard.jsp">Back to Dashboard</a>
</div>

<p style="color:green;"><%= request.getParameter("msg")==null?"":request.getParameter("msg") %></p>
<p style="color:red;"><%= request.getParameter("err")==null?"":request.getParameter("err") %></p>

<table>
    <tr><th>ID</th><th>Bill No</th><th>Customer</th><th>Date</th><th>Total</th><th>Status</th><th></th></tr>
    <%
        if (bills != null) for (Bill b : bills) {
    %>
    <tr>
        <td><%= b.getId() %></td>
        <td><%= b.getBillNo() %></td>
        <td><%= b.getCustomerName() %></td>
        <td><%= b.getBillDate() %></td>
        <td><%= b.getTotal().setScale(2) %></td>
        <td><%= b.getStatus() %></td>
        <td><a href="<%=request.getContextPath()%>/bills/view?id=<%= b.getId() %>">View</a></td>
    </tr>
    <% } %>
</table>
</body>
</html>
