<%@ page contentType="text/html;charset=UTF-8" %>
<%
    Object username = session.getAttribute("username");
    if (username == null) {
        response.sendRedirect(request.getContextPath()+"/views/login.jsp");
        return;
    }
%>
<!doctype html>
<html>
<head><title>Dashboard</title></head>
<body>
<h2>Welcome, <%= username %></h2>
<ul>
    <li><a href="<%=request.getContextPath()%>/views/customers.jsp">Manage Customers</a></li>
    <li><a href="<%=request.getContextPath()%>/views/items.jsp">Manage Items</a></li>
    <li><a href="<%=request.getContextPath()%>/views/billing.jsp">Billing</a></li>
</ul>
<p><a href="<%=request.getContextPath()%>/auth/logout">Logout</a></p>
</body>
</html>
