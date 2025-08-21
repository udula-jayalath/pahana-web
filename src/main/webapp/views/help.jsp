<%@ page import="java.util.*, lk.icbt.pahana.model.ManualSection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Object username = session.getAttribute("username");
    if (username == null) { response.sendRedirect(request.getContextPath()+"/views/login.jsp"); return; }

    @SuppressWarnings("unchecked")
    List<ManualSection> sections = (List<ManualSection>) request.getAttribute("sections");
%>
<!doctype html>
<html>
<head>
    <title>Help & User Manual • Pahana</title>
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

        .container{max-width:1000px; margin:0 auto; padding:24px}

        .top{display:flex; align-items:center; justify-content:space-between; gap:12px; margin-bottom:14px;}
        h2{margin:0; font-size:22px}
        .mut{color:var(--mut)}
        .pill{padding:2px 8px; border-radius:999px; background:#eef5ee; color:#1a3d27;
            border:1px solid #cfe3cf; font-size:12px; margin-left:6px}

        .card{
            background:var(--card); border:1px solid var(--card-b); border-radius:16px;
            padding:16px; backdrop-filter: blur(8px);
            box-shadow: 0 20px 60px rgba(0,0,0,.35);
        }

        .shortcuts{display:flex; flex-wrap:wrap; gap:10px; margin:10px 0 16px}
        .btn{
            padding:10px 12px; border-radius:10px; border:1px solid rgba(255,255,255,.22);
            background:rgba(255,255,255,.08); color:var(--txt); text-decoration:none; cursor:pointer;
        }
        .btn.primary{
            border-color:transparent; color:#fff; font-weight:600;
            background:linear-gradient(135deg,var(--g1),var(--g2));
            box-shadow:0 8px 22px rgba(34,197,94,.25);
        }
        .btn.secondary{ background:#ffffff14 }
        .btn:active{ transform: translateY(1px) }

        .search{display:flex; gap:8px; align-items:center; margin:10px 0 16px}
        .input{
            flex:1; padding:10px 12px; border-radius:12px; border:1px solid #ffffff2a; outline:none;
            background:rgba(255,255,255,.06); color:var(--txt);
        }
        .input:focus{ border-color:#22c55e80; box-shadow:0 0 0 3px #22c55e33 }

        /* Accordion */
        .accordion{ border-radius:12px; overflow:hidden; border:1px solid var(--card-b) }
        .sec{ border-top:1px solid rgba(255,255,255,.12) }
        .sec:first-child{ border-top:none }
        .hdr{
            width:100%; text-align:left; background:rgba(255,255,255,.04);
            color:var(--txt); border:none; cursor:pointer; padding:12px 14px;
            font-weight:600; display:flex; align-items:center; justify-content:space-between;
        }
        .cnt{ padding:14px; display:none; background:rgba(0,0,0,.08) }
        .sec.open .cnt{ display:block }

        .back{display:inline-block; margin-top:12px}

        @media print {
            .noprint{ display:none !important; }
            body{ background:#fff; }
            .container{ padding:0 }
            .card{ box-shadow:none; border:none; background:#fff }
            a{ color:#000 !important; text-decoration:none }
            @page { margin: 12mm }
        }
    </style>
    <script>
        function toggle(id){
            const el = document.getElementById(id);
            if (el) el.classList.toggle('open');
        }
        function filterSections(){
            const q = (document.getElementById('q').value || '').toLowerCase();
            document.querySelectorAll('.sec').forEach(sec=>{
                const txt = sec.textContent.toLowerCase();
                sec.style.display = txt.includes(q) ? '' : 'none';
            });
        }
        function expandAll(){ document.querySelectorAll('.sec').forEach(s=>s.classList.add('open')); }
        function collapseAll(){ document.querySelectorAll('.sec').forEach(s=>s.classList.remove('open')); }
        function printManual(){ window.print(); }
    </script>
</head>
<body>

<div class="container">
    <div class="top">
        <div>
            <h2>Help & User Manual <span class="pill">v1.2.0</span></h2>
            <div class="mut">Quick shortcuts and step-by-step guides to use the system.</div>
        </div>
        <div class="noprint">
            <a class="btn" href="<%=request.getContextPath()%>/views/dashboard.jsp">&larr; Back to Dashboard</a>
        </div>
    </div>

    <div class="card noprint">
        <div class="shortcuts">
            <a class="btn primary" href="<%=request.getContextPath()%>/views/dashboard.jsp">Dashboard</a>
            <a class="btn" href="<%=request.getContextPath()%>/customers">Customers</a>
            <a class="btn" href="<%=request.getContextPath()%>/items">Items</a>
            <a class="btn" href="<%=request.getContextPath()%>/bills">Billing</a>
            <a class="btn secondary" href="<%=request.getContextPath()%>/bills/new">New Bill</a>
            <button class="btn" type="button" onclick="printManual()">Print Manual</button>
        </div>

        <div class="search">
            <input id="q" class="input" oninput="filterSections()" placeholder="Search in manual…">
            <button class="btn" type="button" onclick="expandAll()">Expand All</button>
            <button class="btn secondary" type="button" onclick="collapseAll()">Collapse All</button>
        </div>
    </div>

    <div class="card" style="margin-top:12px">
        <div class="accordion" id="manual" role="region" aria-label="User manual sections">
            <%
                if (sections != null) {
                    for (ManualSection s : sections) {
                        String id = s.getId();
                        if (id == null || id.isBlank()) id = "sec-" + UUID.randomUUID();
            %>
            <div class="sec" id="<%= id %>">
                <button class="hdr" type="button" onclick="toggle('<%= id %>')" aria-controls="<%= id %>-content" aria-expanded="false">
                    <span><%= s.getTitle() %></span>
                    <span>▾</span>
                </button>
                <div class="cnt" id="<%= id %>-content"><%= s.getHtml() %></div>
            </div>
            <%
                    }
                }
            %>
        </div>
    </div>

    <a class="back btn noprint" href="<%=request.getContextPath()%>/views/dashboard.jsp">&larr; Back to Dashboard</a>
</div>

</body>
</html>
