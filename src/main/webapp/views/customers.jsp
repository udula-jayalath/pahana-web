<%@ page import="java.util.*, lk.icbt.pahana.model.Customer" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    Object username = session.getAttribute("username");
    if (username == null) { response.sendRedirect(request.getContextPath()+"/views/login.jsp"); return; }
    @SuppressWarnings("unchecked")
    List<Customer> customers = (List<Customer>) request.getAttribute("customers");
    String q = (String) (request.getAttribute("q")==null ? "" : request.getAttribute("q"));
%>
<!doctype html>
<html>
<head><title>Customers</title></head>
<body>
<h2>Customers</h2>

<form method="get" action="<%=request.getContextPath()%>/customers">
    <input name="q" value="<%=q%>" placeholder="Search account/name"/>
    <button type="submit">Search</button>
    <a href="<%=request.getContextPath()%>/customers/new">+ New Customer</a>
</form>

<p style="color:green;"><%= request.getParameter("msg") == null ? "" : request.getParameter("msg") %></p>
<p style="color:red;"><%= request.getParameter("err") == null ? "" : request.getParameter("err") %></p>

<!-- ...header, search form... -->
<table border="1" cellpadding="6" cellspacing="0">
    <tr>
        <th>ID</th><th>Account No</th><th>Name</th><th>Telephone</th><th>Units</th><th>Actions</th>
    </tr>
    <%
        if (customers != null) {
            for (Customer c : customers) {
    %>
    <tr>
        <td><%= c.getId() %></td>
        <td><%= c.getAccountNo() %></td>
        <td><%= c.getName() %></td>
        <td><%= c.getTelephone()==null?"":c.getTelephone() %></td>
        <td><%= c.getUnits() %></td>
        <td>
            <a href="<%=request.getContextPath()%>/customers/edit?id=<%= c.getId() %>">Edit</a>
            <form method="post" action="<%=request.getContextPath()%>/customers/delete" style="display:inline"
                  onsubmit="return confirm('Delete <%=c.getAccountNo()%>?');">
                <input type="hidden" name="id" value="<%= c.getId() %>">
                <button type="submit">Delete</button>
            </form>
        </td>
    </tr>
    <%
            }
        }
    %>
</table>


<p><a href="<%=request.getContextPath()%>/views/dashboard.jsp">Back to Dashboard</a></p>
</body>
</html>
