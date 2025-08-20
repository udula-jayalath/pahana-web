<%@ page import="java.util.*, java.math.BigDecimal, lk.icbt.pahana.model.Item" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    Object username = session.getAttribute("username");
    if (username == null) { response.sendRedirect(request.getContextPath()+"/views/login.jsp"); return; }
    @SuppressWarnings("unchecked")
    List<Item> items = (List<Item>) request.getAttribute("items");
    String q = (String) (request.getAttribute("q")==null ? "" : request.getAttribute("q"));
%>
<!doctype html>
<html>
<head><title>Items</title>
    <style>
        body{font-family:Arial,Helvetica,sans-serif;margin:24px;}
        table{border-collapse:collapse;width:100%;}
        th,td{border:1px solid #ddd;padding:8px;text-align:left;}
        th{background:#f3f3f3;}
        .toolbar{display:flex;gap:10px;align-items:center;margin-bottom:12px;}
        .pill{padding:6px 10px;border:1px solid #2e7d32;background:#2e7d32;color:#fff;border-radius:8px;text-decoration:none;}
        .danger{border-color:#8b0000;background:#b22222;}
    </style>
</head>
<body>
<h2>Items</h2>

<div class="toolbar">
    <form method="get" action="<%=request.getContextPath()%>/items">
        <input name="q" value="<%=q%>" placeholder="Search name"/>
        <button type="submit">Search</button>
    </form>
    <a class="pill" href="<%=request.getContextPath()%>/items/new">+ New Item</a>
    <a href="<%=request.getContextPath()%>/views/dashboard.jsp">Back to Dashboard</a>
</div>

<p style="color:green;"><%= request.getParameter("msg")==null?"":request.getParameter("msg") %></p>
<p style="color:red;"><%= request.getParameter("err")==null?"":request.getParameter("err") %></p>

<table>
    <tr>
        <th>ID</th><th>Name</th><th>Unit Price</th><th>Status</th><th>Actions</th>
    </tr>
    <%
        if (items != null) {
            for (Item it : items) {
    %>
    <tr>
        <td><%= it.getId() %></td>
        <td><%= it.getName() %></td>
        <td><%= it.getUnitPrice()==null?"":it.getUnitPrice().setScale(2) %></td>
        <td><%= it.getStatus() %></td>
        <td>
            <a href="<%=request.getContextPath()%>/items/edit?id=<%= it.getId() %>">Edit</a>
            <form method="post" action="<%=request.getContextPath()%>/items/delete" style="display:inline"
                  onsubmit="return confirm('Delete item <%=it.getName()%>?');">
                <input type="hidden" name="id" value="<%= it.getId() %>">
                <button class="pill danger" type="submit">Delete</button>
            </form>
        </td>
    </tr>
    <%
            }
        }
    %>
</table>
</body>
</html>
