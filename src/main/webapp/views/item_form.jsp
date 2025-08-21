<%@ page import="lk.icbt.pahana.model.Item" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%-- Helper: HTML-escape --%>
<%!
    private static String esc(Object o){
        if (o == null) return "";
        String s = String.valueOf(o);
        return s.replace("&","&amp;").replace("<","&lt;")
                .replace(">","&gt;").replace("\"","&quot;");
    }
%>

<%
    // Auth + page state
    Object username = session.getAttribute("username");
    if (username == null) { response.sendRedirect(request.getContextPath()+"/views/login.jsp"); return; }

    String mode = (String) request.getAttribute("mode"); // "create" | "edit"
    Item it     = (Item) request.getAttribute("item");   // may be null in create
    boolean isEdit = "edit".equalsIgnoreCase(mode);
    String error = (String) request.getAttribute("error");
%>

<!doctype html>
<html>
<head>
    <title><%= isEdit ? "Edit" : "New" %> Item • Pahana</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <style>
        :root{
            --bg1:#0f172a; --bg2:#1e293b; --txt:#e5e7eb; --mut:#94a3b8;
            --g1:#22c55e; --g2:#16a34a; --card:rgba(255,255,255,.08); --card-b:rgba(255,255,255,.18);
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
        a{color:#c7f9d4; text-decoration:none}
        a:hover{text-decoration:underline}

        .container{max-width:720px; margin:0 auto; padding:24px}
        .top{display:flex; align-items:center; justify-content:space-between; gap:12px; margin-bottom:12px;}
        h2{margin:0; font-size:22px}
        .mut{color:var(--mut)}

        .card{
            background:var(--card); border:1px solid var(--card-b); border-radius:16px;
            padding:18px; backdrop-filter: blur(8px);
            box-shadow: 0 20px 60px rgba(0,0,0,.35);
        }
        .banner{padding:10px 12px; border-radius:10px; margin-bottom:12px;
            border:1px solid #ef444477; background:#ef444433; color:#fecaca}

        .grid{display:grid; grid-template-columns: 1fr 1fr; gap:14px}
        @media (max-width:720px){ .grid{grid-template-columns: 1fr} }

        .field{display:flex; flex-direction:column; gap:6px}
        .label{font-size:13px; color:var(--mut)}
        .label .req{color:#fca5a5}
        .input, select{
            width:100%; padding:12px 12px;
            border-radius:12px; border:1px solid #ffffff2a; outline:none;
            background: rgba(255,255,255,0.06); color:var(--txt);
            transition: border-color .2s, background .2s, box-shadow .2s;
        }
        .input:focus, select:focus{
            border-color:#22c55e80; background: rgba(255,255,255,.10);
            box-shadow:0 0 0 3px #22c55e33;
        }
        .rowspan{grid-column: span 2}
        @media (max-width:720px){ .rowspan{grid-column: 1} }

        .actions{display:flex; gap:10px; margin-top:16px; flex-wrap:wrap}
        .btn{
            padding:10px 14px; border-radius:12px; border:1px solid rgba(255,255,255,.22);
            background:rgba(255,255,255,.08); color:var(--txt); cursor:pointer;
        }
        .btn.primary{
            border-color:transparent; font-weight:600; color:#fff;
            background:linear-gradient(135deg,var(--g1),var(--g2));
            box-shadow:0 8px 22px rgba(34,197,94,.25);
        }
        .btn.secondary{ background:#ffffff14 }
        .btn:active{ transform: translateY(1px) }
        .hint{font-size:12px; color:var(--mut)}
    </style>
</head>
<body>

<div class="container">
    <div class="top">
        <div>
            <h2><%= isEdit ? "Edit" : "New" %> Item</h2>
            <div class="mut">Maintain billable items and unit prices.</div>
        </div>
        <div><a href="<%=request.getContextPath()%>/items">&larr; Back to Items</a></div>
    </div>

    <div class="card">
        <% if (error != null && !error.isBlank()) { %>
        <div class="banner"><%= esc(error) %></div>
        <% } %>

        <form method="post" action="<%= isEdit ? (request.getContextPath()+"/items/edit")
                                               : (request.getContextPath()+"/items/create") %>">
            <% if (isEdit) { %>
            <input type="hidden" name="id" value="<%= it!=null?it.getId():0 %>">
            <% } %>

            <div class="grid">
                <!-- Name -->
                <div class="field rowspan">
                    <label class="label" for="name">Item Name <span class="req">*</span></label>
                    <input class="input" id="name" name="name" maxlength="120"
                           value="<%= it!=null?esc(it.getName()):"" %>"
                           required minlength="2" placeholder="e.g. Service Charge">
                    <div class="hint">Minimum 2 characters.</div>
                </div>

                <!-- Unit Price -->
                <div class="field">
                    <label class="label" for="unit_price">Unit Price <span class="req">*</span></label>
                    <input class="input" id="unit_price" name="unit_price" type="number"
                           step="0.01" min="0"
                           value="<%= it!=null && it.getUnitPrice()!=null ? it.getUnitPrice().setScale(2) : "" %>"
                           required placeholder="0.00">
                    <div class="hint">Two decimals, non-negative.</div>
                </div>

                <!-- Status -->
                <div class="field">
                    <label class="label" for="status">Status <span class="req">*</span></label>
                    <select id="status" name="status" class="input" required>
                        <option value="ACTIVE"   <%= it!=null && "ACTIVE".equals(it.getStatus())?"selected":"" %>>ACTIVE</option>
                        <option value="INACTIVE" <%= it!=null && "INACTIVE".equals(it.getStatus())?"selected":"" %>>INACTIVE</option>
                    </select>
                </div>
            </div>

            <div class="actions">
                <button class="btn primary" type="submit"><%= isEdit ? "Save Changes" : "Create Item" %></button>
                <a class="btn secondary" href="<%=request.getContextPath()%>/items">Cancel</a>
            </div>
        </form>
    </div>
</div>

</body>
</html>
