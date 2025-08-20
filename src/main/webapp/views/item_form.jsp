<%@ page import="lk.icbt.pahana.model.Item" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%!
    private static String esc(Object o){
        if (o == null) return "";
        String s = String.valueOf(o);
        return s.replace("&","&amp;").replace("<","&lt;")
                .replace(">","&gt;").replace("\"","&quot;");
    }
%>

<%
    Object username = session.getAttribute("username");
    if (username == null) { response.sendRedirect(request.getContextPath()+"/views/login.jsp"); return; }
    String mode = (String) request.getAttribute("mode");     // create | edit
    Item it = (Item) request.getAttribute("item");
    boolean isEdit = "edit".equalsIgnoreCase(mode);
    String error = (String) request.getAttribute("error");
%>

<!doctype html>
<html>
<head>
    <title><%= isEdit ? "Edit" : "New" %> Item</title>
    <style>
        body{font-family:Arial,Helvetica,sans-serif;margin:24px;}
        .card{max-width:640px;padding:20px;border:1px solid #ddd;border-radius:10px;}
        .row{display:flex;gap:12px;align-items:center;margin-bottom:10px;}
        .row label{width:140px;font-weight:bold;}
        .row input,.row select{flex:1;padding:8px;border:1px solid #ccc;border-radius:6px;}
        .actions{display:flex;gap:10px;margin-top:16px;}
        .btn{padding:8px 14px;border:1px solid #1b5e20;background:#2e7d32;color:#fff;border-radius:8px;cursor:pointer;}
        .btn.secondary{border-color:#555;background:#777;}
    </style>
</head>
<body>
<h2><%= isEdit ? "Edit" : "New" %> Item</h2>
<p><a href="<%=request.getContextPath()%>/items">&larr; Back to Items</a></p>

<div class="card">
    <% if (error != null && !error.isBlank()) { %>
    <div style="background:#ffecec;border:1px solid #f5b5b5;color:#a40000;padding:8px;border-radius:8px;margin-bottom:12px;">
        <%= esc(error) %>
    </div>
    <% } %>

    <form method="post" action="<%= isEdit ? (request.getContextPath()+"/items/edit")
                                         : (request.getContextPath()+"/items/create") %>">
        <% if (isEdit) { %>
        <input type="hidden" name="id" value="<%= it!=null?it.getId():0 %>">
        <% } %>

        <div class="row">
            <label for="name">Name</label>
            <input id="name" name="name" value="<%= it!=null?esc(it.getName()):"" %>" required minlength="2">
        </div>

        <div class="row">
            <label for="unit_price">Unit Price</label>
            <input id="unit_price" name="unit_price" type="number" step="0.01" min="0"
                   value="<%= it!=null && it.getUnitPrice()!=null ? it.getUnitPrice().setScale(2) : "" %>" required>
        </div>

        <div class="row">
            <label for="status">Status</label>
            <select id="status" name="status" required>
                <option value="ACTIVE"   <%= it!=null && "ACTIVE".equals(it.getStatus())?"selected":"" %>>ACTIVE</option>
                <option value="INACTIVE" <%= it!=null && "INACTIVE".equals(it.getStatus())?"selected":"" %>>INACTIVE</option>
            </select>
        </div>

        <div class="actions">
            <button class="btn" type="submit"><%= isEdit ? "Save Changes" : "Create Item" %></button>
            <a class="btn secondary" href="<%=request.getContextPath()%>/items" style="text-decoration:none;display:inline-block;">Cancel</a>
        </div>
    </form>
</div>
</body>
</html>
