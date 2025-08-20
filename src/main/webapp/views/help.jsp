<%@ page import="java.util.*, lk.icbt.pahana.model.ManualSection" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    Object username = session.getAttribute("username");
    if (username == null) { response.sendRedirect(request.getContextPath()+"/views/login.jsp"); return; }

    @SuppressWarnings("unchecked")
    List<ManualSection> sections = (List<ManualSection>) request.getAttribute("sections");
%>
<!doctype html>
<html>
<head>
    <title>Help & User Manual</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <style>
        body{font-family:Arial,Helvetica,sans-serif;margin:24px;line-height:1.45;}
        h2{margin:0 0 8px;}
        .subtitle{color:#555;margin-bottom:18px;}
        .shortcuts{display:flex;flex-wrap:wrap;gap:10px;margin:10px 0 18px;}
        .btn{padding:8px 12px;border:1px solid #1b5e20;background:#2e7d32;color:#fff;border-radius:8px;text-decoration:none;}
        .btn.secondary{border-color:#555;background:#777;}
        .search{margin:10px 0 16px;}
        .accordion{border:1px solid #ddd;border-radius:10px;overflow:hidden;}
        .sec{border-top:1px solid #eee;}
        .sec:first-child{border-top:none;}
        .hdr{background:#f7f7f7;padding:12px 14px;cursor:pointer;font-weight:bold;}
        .cnt{padding:14px;display:none;}
        .open .cnt{display:block;}
        .pill{padding:2px 8px;border-radius:999px;background:#eef5ee;color:#2e7d32;border:1px solid #cfe3cf;margin-left:6px;font-size:12px;}
        @media print {.noprint{display:none !important;} body{margin:10mm;}}
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

<h2>Help & User Manual <span class="pill">v1.0</span></h2>
<p class="subtitle">Quick shortcuts and step-by-step guides to use the system.</p>

<div class="shortcuts noprint">
    <a class="btn" href="<%=request.getContextPath()%>/views/dashboard.jsp">Dashboard</a>
    <a class="btn" href="<%=request.getContextPath()%>/customers">Customers</a>
    <a class="btn" href="<%=request.getContextPath()%>/items">Items</a>
    <a class="btn" href="<%=request.getContextPath()%>/bills">Billing</a>
    <a class="btn secondary" href="<%=request.getContextPath()%>/bills/new">New Bill</a>
    <button class="btn" type="button" onclick="printManual()">Print Manual</button>
</div>

<div class="search noprint">
    <input id="q" oninput="filterSections()" placeholder="Search in manual…" style="width:60%;padding:8px;border:1px solid #ccc;border-radius:6px;">
    <button class="btn" type="button" onclick="expandAll()">Expand All</button>
    <button class="btn secondary" type="button" onclick="collapseAll()">Collapse All</button>
</div>

<div class="accordion" id="manual">
    <%
        if (sections != null) {
            for (ManualSection s : sections) {
    %>
    <div class="sec" id="<%= s.getId() %>">
        <div class="hdr" onclick="toggle('<%= s.getId() %>')"><%= s.getTitle() %></div>
        <div class="cnt"><%= s.getHtml() %></div>
    </div>
    <%
            }
        }
    %>
</div>

</body>
</html>
