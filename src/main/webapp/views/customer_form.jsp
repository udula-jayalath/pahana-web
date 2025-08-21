<%@ page import="lk.icbt.pahana.model.Customer" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<%-- Helper: HTML-escape --%>

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


<%
    // Auth guard & page state
    Object username = session.getAttribute("username");
    if (username == null) { response.sendRedirect(request.getContextPath()+"/views/login.jsp"); return; }

    String mode   = (String) request.getAttribute("mode");        // "create" | "edit"
    Customer c    = (Customer) request.getAttribute("customer");  // may be null on create
    boolean isEdit = "edit".equalsIgnoreCase(mode);
    String error  = (String) request.getAttribute("error");

%>

<!doctype html>
<html>
<head>

    <title><%= isEdit ? "Edit" : "New" %> Customer • Pahana</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
        :root{
            --bg1:#0f172a; --bg2:#1e293b; --txt:#e5e7eb; --mut:#94a3b8;
            --g1:#22c55e; --g2:#16a34a; --card:rgba(255,255,255,.08); --card-b:rgba(255,255,255,.18);
            --err:#ef4444;
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

        .container{max-width:820px; margin:0 auto; padding:24px}
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
        @media (max-width:760px){ .grid{grid-template-columns: 1fr} }

        .field{position:relative; display:flex; flex-direction:column; gap:6px}
        .label{font-size:13px; color:var(--mut)}
        .label .req{color:#fca5a5}
        .input, textarea{
            width:100%; padding:12px 12px;
            border-radius:12px; border:1px solid #ffffff2a; outline:none;
            background: rgba(255,255,255,0.06); color:var(--txt);
            transition: border-color .2s, background .2s, box-shadow .2s;
        }
        textarea{min-height:104px; resize:vertical}
        .input:focus, textarea:focus{
            border-color:#22c55e80; background: rgba(255,255,255,.10);
            box-shadow:0 0 0 3px #22c55e33;
        }
        .hint{font-size:12px; color:var(--mut)}
        .badge{
            display:inline-block; padding:2px 8px; border-radius:999px; font-size:12px;
            border:1px solid #cfe3cf; color:#c7f9d4; background:#1e293b; margin-left:6px;
        }
        .icon{position:absolute; right:10px; top:36px; opacity:.7}

        .rowspan{grid-column: span 2}
        @media (max-width:760px){ .rowspan{grid-column: 1} }

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

    </style>
</head>
<body>


<div class="container">
    <div class="top">
        <div>
            <h2><%= isEdit ? "Edit" : "New" %> Customer
                <% if (isEdit) { %><span class="badge" title="Key cannot be changed">READONLY KEY</span><% } %>
            </h2>
            <div class="mut">Manage customer identity and contact details.</div>
        </div>
        <div><a href="<%=request.getContextPath()%>/customers">&larr; Back to Customers</a></div>
    </div>

    <div class="card">
        <% if (error != null && !error.isBlank()) { %>
        <div class="banner"><%= esc(error) %></div>
        <% } %>

        <form method="post" action="<%= isEdit ? (request.getContextPath()+"/customers/edit")
                                               : (request.getContextPath()+"/customers/create") %>">
            <% if (isEdit) { %>
            <input type="hidden" name="id" value="<%= c!=null ? c.getId() : 0 %>">
            <% } %>

            <div class="grid">
                <!-- Account No -->
                <div class="field">
                    <label class="label" for="account_no">Account No <span class="req">*</span></label>
                    <input class="input" id="account_no" name="account_no" maxlength="20"
                           value="<%= c!=null ? esc(c.getAccountNo()) : "" %>"
                        <%= isEdit ? "readonly" : "" %>
                           required pattern="[A-Za-z0-9\\-]{3,20}"
                           title="3–20 chars, letters/digits/hyphen"
                           placeholder="e.g. ACC-1001">
                    <div class="hint"><%= isEdit ? "Primary key is read-only in edit mode." : "Use letters, numbers, or '-' (3–20 chars)." %></div>
                </div>

                <!-- Name -->
                <div class="field">
                    <label class="label" for="name">Full Name <span class="req">*</span></label>
                    <input class="input" id="name" name="name" maxlength="120"
                           value="<%= c!=null ? esc(c.getName()) : "" %>"
                           required minlength="3" placeholder="Customer full name">
                </div>

                <!-- Telephone -->
                <div class="field">
                    <label class="label" for="telephone">Telephone</label>
                    <input class="input" id="telephone" name="telephone" maxlength="25"
                           value="<%= c!=null && c.getTelephone()!=null ? esc(c.getTelephone()) : "" %>"
                           pattern="[0-9+]{7,15}"
                           title="Digits or +, length 7–15"
                           placeholder="+94XXXXXXXXX">
                    <div class="hint">Digits or “+”, 7–15 characters.</div>
                </div>

                <!-- Units -->
                <div class="field">
                    <label class="label" for="units">Units</label>
                    <input class="input" id="units" name="units" type="number" min="0" step="1"
                           value="<%= c!=null ? c.getUnits() : 0 %>">
                    <div class="hint">Consumption/usage units (optional).</div>
                </div>

                <!-- Address (spans) -->
                <div class="field rowspan">
                    <label class="label" for="address">Address</label>
                    <textarea id="address" name="address" maxlength="255"
                              placeholder="Street, City, Postal Code"><%= c!=null && c.getAddress()!=null ? esc(c.getAddress()) : "" %></textarea>
                </div>
            </div>

            <div class="actions">
                <button type="submit" class="btn primary"><%= isEdit ? "Save Changes" : "Create Customer" %></button>
                <a class="btn secondary" href="<%=request.getContextPath()%>/customers">Cancel</a>
            </div>
        </form>
    </div>

</div>

</body>
</html>
