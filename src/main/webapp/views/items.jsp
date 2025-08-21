<%@ page import="java.util.*, lk.icbt.pahana.model.Item" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%-- Helpers --%>
<%!
    private static String esc(Object o){
        if (o == null) return "";
        String s = String.valueOf(o);
        return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;");
    }
    private static String money(java.math.BigDecimal v){
        if (v == null) return "0.00";
        return v.setScale(2, java.math.RoundingMode.HALF_UP).toString();
    }
%>

<%
    Object username = session.getAttribute("username");
    if (username == null) { response.sendRedirect(request.getContextPath()+"/views/login.jsp"); return; }
    @SuppressWarnings("unchecked")
    List<Item> items = (List<Item>) request.getAttribute("items");
    String q = (String) (request.getAttribute("q")==null ? "" : request.getAttribute("q"));
%>

<!doctype html>
<html>
<head>
    <title>Items • Pahana</title>
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
        .small{font-size:12px; color:var(--mut)}

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
        .btn:active{ transform: translateY(1px) }
        .inline-form{ display:inline }

        .searchbar{
            display:flex; gap:8px; align-items:center; background:var(--card);
            border:1px solid var(--card-b); border-radius:12px; padding:8px 10px; flex:1;
        }
        .searchbar input{
            background:transparent; border:none; outline:none; color:var(--txt); width:100%;
        }

        .banner{border:1px solid #4ade8044; background:#4ade8030; color:#dcfce7; padding:10px 12px; border-radius:10px; margin:10px 0}
        .banner.err{border-color:#ef444477; background:#ef444433; color:#fecaca}

        .card{
            background:var(--card); border:1px solid var(--card-b); border-radius:16px; padding:14px;
            box-shadow:0 20px 60px rgba(0,0,0,.35); backdrop-filter:blur(8px);
        }
        .tablewrap{overflow:auto; border-radius:12px; border:1px solid var(--card-b)}
        table{width:100%; border-collapse:separate; border-spacing:0; min-width:720px}
        thead th{
            position:sticky; top:0; z-index:1; background:rgba(15,23,42,.8); backdrop-filter:blur(6px);
            text-align:left; padding:10px; font-weight:600; color:#cbd5e1; border-bottom:1px solid var(--card-b);
        }
        tbody td{ padding:10px; border-bottom:1px solid rgba(255,255,255,.12) }
        tbody tr:hover{ background:rgba(255,255,255,.06) }

        .status{
            display:inline-block; padding:2px 8px; border-radius:999px; font-size:12px; border:1px solid;
        }
        .status.active{ color:#dcfce7; border-color:#c9f7d0; background:#1e3a2f }
        .status.inactive{ color:#ffe7e7; border-color:#ffc9c9; background:#3a1e1e }

        .right{text-align:right}
        .empty{text-align:center; padding:28px; color:#cbd5e1}
        .back{display:inline-block; margin-top:12px}
    </style>
</head>
<body>

<div class="container">
    <div class="top">
        <div>
            <h2>Items</h2>
            <div class="small">Maintain billable items and unit prices.</div>
        </div>
        <div class="actions" style="flex:1; justify-content:flex-end">
            <form method="get" action="<%=request.getContextPath()%>/items" class="searchbar">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
                    <circle cx="11" cy="11" r="7" stroke="currentColor" stroke-width="1.6"/>
                    <path d="M20 20l-3.2-3.2" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/>
                </svg>
                <input name="q" value="<%= esc(q) %>" placeholder="Search item name…" />
                <button class="btn" type="submit">Search</button>
            </form>
            <a class="btn primary" href="<%=request.getContextPath()%>/items/new">+ New Item</a>
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
        <table aria-label="Items">
            <thead>
            <tr>
                <th style="width:80px">ID</th>
                <th>Name</th>
                <th class="right" style="width:160px">Unit Price</th>
                <th style="width:130px">Status</th>
                <th style="width:200px">Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                if (items != null && !items.isEmpty()) {
                    for (Item it : items) {
                        String status = it.getStatus()==null ? "" : it.getStatus().toUpperCase(Locale.ENGLISH);
            %>
            <tr>
                <td><%= it.getId() %></td>
                <td><%= esc(it.getName()) %></td>
                <td class="right"><%= money(it.getUnitPrice()) %></td>
                <td>
                        <span class="status <%= "ACTIVE".equals(status) ? "active" : "inactive" %>">
                            <%= status.isEmpty() ? "—" : status %>
                        </span>
                </td>
                <td>
                    <div class="actions">
                        <a class="btn" href="<%=request.getContextPath()%>/items/edit?id=<%= it.getId() %>">Edit</a>
                        <form class="inline-form" method="post" action="<%=request.getContextPath()%>/items/delete"
                              onsubmit="return confirm('Delete item &quot;<%= esc(it.getName()) %>&quot;?');">
                            <input type="hidden" name="id" value="<%= it.getId() %>">
                            <button class="btn danger" type="submit">Delete</button>
                        </form>
                    </div>
                </td>
            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td colspan="5" class="empty">
                    No items found
                    <% if (q != null && !q.isBlank()) { %>
                    for "<b><%= esc(q) %></b>"
                    <% } %>.
                    <div style="margin-top:10px">
                        <a class="btn" href="<%=request.getContextPath()%>/items">Clear Search</a>
                        <a class="btn primary" href="<%=request.getContextPath()%>/items/new">Add First Item</a>
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
