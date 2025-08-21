<%@ page import="java.util.*, lk.icbt.pahana.model.Customer" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%-- HTML escape helper --%>
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
    String q = (String) (request.getAttribute("q")==null ? "" : request.getAttribute("q"));
%>


<!doctype html>
<html>
<head>
    <title>Customers • Pahana</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <style>
        :root{
            --bg1:#0f172a; --bg2:#1e293b; --txt:#e5e7eb; --mut:#94a3b8;
            --g1:#22c55e; --g2:#16a34a; --card:rgba(255,255,255,.08); --card-b:rgba(255,255,255,.18);
            --ok:#22c55e; --err:#ef4444; --warn:#f59e0b;
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
        a{color:inherit; text-decoration:none}
        .container{max-width:1100px; margin:0 auto; padding:24px}
        .top{display:flex; align-items:center; justify-content:space-between; gap:12px; margin-bottom:14px;}
        h2{margin:0; font-size:22px}
        .actions{display:flex; gap:10px; flex-wrap:wrap}
        .btn{
            padding:10px 12px; border-radius:10px; border:1px solid rgba(255,255,255,.22);
            background:rgba(255,255,255,.08); color:var(--txt);
        }
        .btn.primary{
            border-color:transparent; color:#fff;
            background:linear-gradient(135deg,var(--g1),var(--g2));
            box-shadow:0 8px 22px rgba(34,197,94,.25); font-weight:600;
        }
        .btn.danger{ border-color:#ffb4b4; background:#ef444444; color:#ffecec }
        .searchbar{
            display:flex; gap:8px; align-items:center; background:var(--card);
            border:1px solid var(--card-b); border-radius:12px; padding:8px 10px; flex:1;
        }
        .searchbar input{
            background:transparent; border:none; outline:none; color:var(--txt); width:100%;
        }
        .card{
            background:var(--card); border:1px solid var(--card-b); border-radius:16px; padding:14px;
            box-shadow:0 20px 60px rgba(0,0,0,.35); backdrop-filter:blur(8px);
        }
        .banner{border:1px solid #4ade8044; background:#4ade8030; color:#dcfce7; padding:10px 12px; border-radius:10px; margin:10px 0}
        .banner.err{border-color:#ef444477; background:#ef444433; color:#fecaca}

        .tablewrap{overflow:auto; border-radius:12px; border:1px solid var(--card-b)}
        table{width:100%; border-collapse:separate; border-spacing:0; min-width:760px}
        thead th{
            position:sticky; top:0; z-index:1; background:rgba(15,23,42,.8); backdrop-filter:blur(6px);
            text-align:left; padding:10px; font-weight:600; color:#cbd5e1; border-bottom:1px solid var(--card-b);
        }
        tbody td{ padding:10px; border-bottom:1px solid rgba(255,255,255,.12) }
        tbody tr:hover{ background:rgba(255,255,255,.06) }
        .mut{color:var(--mut)}
        .units{display:inline-block; padding:2px 8px; border-radius:999px; border:1px solid #cfe3cf; color:#c7f9d4; font-size:12px; background:#1e293b}
        .right{text-align:right}
        .row-actions{display:flex; gap:8px; align-items:center}
        .empty{
            text-align:center; padding:28px; color:#cbd5e1;
        }
        .small{font-size:12px; color:#94a3b8}
        .back{display:inline-block; margin-top:12px}
        .inline-form{display:inline}
    </style>
</head>
<body>

<div class="container">

    <div class="top">
        <div>
            <h2>Customers</h2>
            <div class="small">Manage customer accounts and contact details.</div>
        </div>

        <div class="actions" style="flex:1; justify-content:flex-end">
            <form method="get" action="<%=request.getContextPath()%>/customers" class="searchbar">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
                    <circle cx="11" cy="11" r="7" stroke="currentColor" stroke-width="1.6"/>
                    <path d="M20 20l-3.2-3.2" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/>
                </svg>
                <input name="q" value="<%= esc(q) %>" placeholder="Search account no or name…" />
                <button class="btn" type="submit">Search</button>
            </form>
            <a class="btn primary" href="<%=request.getContextPath()%>/customers/new">+ New Customer</a>
        </div>
    </div>

    <% String okMsg = request.getParameter("msg"); String badMsg = request.getParameter("err"); %>
    <% if (okMsg != null && !okMsg.isBlank()) { %>
    <div class="banner"><%= esc(okMsg) %></div>
    <% } %>
    <% if (badMsg != null && !badMsg.isBlank()) { %>
    <div class="banner err"><%= esc(badMsg) %></div>
    <% } %>

    <div class="card tablewrap">
        <table aria-label="Customers">
            <thead>
            <tr>
                <th style="width:70px">ID</th>
                <th>Account No</th>
                <th>Name</th>
                <th>Telephone</th>
                <th class="right" style="width:100px">Units</th>
                <th style="width:180px">Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                if (customers != null && !customers.isEmpty()) {
                    for (Customer c : customers) {
            %>
            <tr>
                <td><%= c.getId() %></td>
                <td><%= esc(c.getAccountNo()) %></td>
                <td><%= esc(c.getName()) %></td>
                <td>
                    <%
                        String tel = c.getTelephone()==null ? "" : c.getTelephone();
                        if (!tel.isBlank()) {
                    %>
                    <a href="tel:<%= esc(tel) %>"><%= esc(tel) %></a>
                    <% } else { %>
                    <span class="mut">—</span>
                    <% } %>
                </td>
                <td class="right"><span class="units"><%= c.getUnits() %></span></td>
                <td>
                    <div class="row-actions">
                        <a class="btn" href="<%=request.getContextPath()%>/customers/edit?id=<%= c.getId() %>">Edit</a>
                        <form class="inline-form" method="post" action="<%=request.getContextPath()%>/customers/delete"
                              onsubmit="return confirm('Delete customer <%= esc(c.getAccountNo()) %>?');">
                            <input type="hidden" name="id" value="<%= c.getId() %>">
                            <button type="submit" class="btn danger">Delete</button>
                        </form>
                    </div>
                </td>
            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td colspan="6" class="empty">
                    No customers found
                    <% if (q != null && !q.isBlank()) { %>
                    for "<b><%= esc(q) %></b>"
                    <% } %>.
                    <div style="margin-top:10px">
                        <a class="btn" href="<%=request.getContextPath()%>/customers">Clear Search</a>
                        <a class="btn primary" href="<%=request.getContextPath()%>/customers/new">Add First Customer</a>
                    </div>
                </td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>

    <a class="back btn" href="<%=request.getContextPath()%>/views/dashboard.jsp">&larr; Back to Dashboard</a>
</div>


</body>
</html>
