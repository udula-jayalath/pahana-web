<%@ page import="lk.icbt.pahana.model.Customer" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%-- Declare helper methods with <%! ... %> (NOT inside <% ... %>) --%>
<%!
    private static String esc(Object o){
        if (o == null) return "";
        String s = String.valueOf(o);
        return s.replace("&","&amp;")
                .replace("<","&lt;")
                .replace(">","&gt;")
                .replace("\"","&quot;");
    }
%>

<%  // Auth guard & page state
    Object username = session.getAttribute("username");
    if (username == null) { response.sendRedirect(request.getContextPath()+"/views/login.jsp"); return; }

    String mode = (String) request.getAttribute("mode");        // "create" or "edit"
    Customer c   = (Customer) request.getAttribute("customer"); // may be null on create
    boolean isEdit = "edit".equalsIgnoreCase(mode);
    String error = (String) request.getAttribute("error");
%>

<!doctype html>
<html>
<head>
    <title><%= isEdit ? "Edit" : "New" %> Customer</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
        body{font-family:Arial,Helvetica,sans-serif; margin:24px;}
        h2{margin:0 0 16px;}
        .card{max-width:720px; padding:20px; border:1px solid #ddd; border-radius:10px;}
        .banner{padding:10px 12px; border-radius:8px; margin-bottom:12px;}
        .banner.error{background:#ffecec; color:#a40000; border:1px solid #f5b5b5;}
        .rows{display:flex; flex-direction:column; gap:10px;}
        .row{display:flex; align-items:center; gap:12px;}
        .row label{width:160px; font-weight:bold;}
        .row input[type="text"], .row input[type="number"], .row textarea{
            flex:1; padding:8px; border:1px solid #ccc; border-radius:6px;
        }
        textarea{min-height:80px; resize:vertical;}
        .actions{display:flex; gap:10px; margin-top:16px;}
        .btn{padding:8px 14px; border:1px solid #1b5e20; color:#fff; background:#2e7d32; border-radius:8px; cursor:pointer;}
        .btn.secondary{border-color:#555; background:#777;}
        a{color:#2e7d32; text-decoration:none}
        a:hover{text-decoration:underline}
        @media (max-width:640px){ .row{flex-direction:column; align-items:stretch;} .row label{width:auto;} }
    </style>
</head>
<body>

<h2><%= isEdit ? "Edit" : "New" %> Customer</h2>
<p><a href="<%=request.getContextPath()%>/customers">&larr; Back to Customers</a></p>

<div class="card">
    <% if (error != null && !error.isBlank()) { %>
    <div class="banner error"><%= esc(error) %></div>
    <% } %>

    <form method="post" action="<%= isEdit ? (request.getContextPath()+"/customers/edit")
                                           : (request.getContextPath()+"/customers/create") %>">
        <% if (isEdit) { %>
        <input type="hidden" name="id" value="<%= c!=null ? c.getId() : 0 %>">
        <% } %>

        <div class="rows">
            <div class="row">
                <label for="account_no">Account No</label>
                <input id="account_no" name="account_no"
                       value="<%= c!=null ? esc(c.getAccountNo()) : "" %>"
                    <%= isEdit ? "readonly" : "" %>
                       required pattern="[A-Za-z0-9\-]{3,20}"
                       title="3-20 chars, letters/digits/hyphen">
            </div>

            <div class="row">
                <label for="name">Name</label>
                <input id="name" name="name"
                       value="<%= c!=null ? esc(c.getName()) : "" %>"
                       required minlength="3">
            </div>

            <div class="row">
                <label for="address">Address</label>
                <textarea id="address" name="address"><%= c!=null && c.getAddress()!=null ? esc(c.getAddress()) : "" %></textarea>
            </div>

            <div class="row">
                <label for="telephone">Telephone</label>
                <input id="telephone" name="telephone"
                       value="<%= c!=null && c.getTelephone()!=null ? esc(c.getTelephone()) : "" %>"
                       pattern="[0-9+]{7,15}"
                       title="Digits or +, length 7-15">
            </div>

            <div class="row">
                <label for="units">Units</label>
                <input id="units" name="units" type="number" min="0" value="<%= c!=null ? c.getUnits() : 0 %>">
            </div>
        </div>

        <div class="actions">
            <button type="submit" class="btn"><%= isEdit ? "Save Changes" : "Create Customer" %></button>
            <a class="btn secondary" href="<%=request.getContextPath()%>/customers"
               style="display:inline-block; text-align:center;">Cancel</a>
        </div>
    </form>
</div>

</body>
</html>
