
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    Object username = session.getAttribute("username");
    if (username == null) {
        response.sendRedirect(request.getContextPath()+"/views/login.jsp");
        return;
    }
%>
<!doctype html>
<html>

<head>
    <title>Dashboard • Pahana</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <style>
        :root{
            --bg1:#0f172a; --bg2:#1e293b; --txt:#e5e7eb; --mut:#94a3b8;
            --g1:#22c55e; --g2:#16a34a; --card:rgba(255,255,255,.08); --card-b:rgba(255,255,255,.18);
            --shadow:0 20px 60px rgba(0,0,0,.35);
            --warn:#ef4444;
        }
        *{box-sizing:border-box}
        html,body{height:100%}
        body{
            margin:0; color:var(--txt);
            font: 16px/1.5 system-ui,-apple-system,"Segoe UI",Roboto,Arial;
            background:
                    radial-gradient(1200px 600px at 10% -10%, #10b98122, transparent 60%),
                    radial-gradient(1000px 500px at 110% 110%, #22c55e22, transparent 60%),
                    linear-gradient(130deg, var(--bg1), var(--bg2));
            display:flex; flex-direction:column;
        }
        a{color:inherit; text-decoration:none}
        .container{max-width:1060px; width:100%; margin:0 auto; padding:22px}
        .topbar{
            display:flex; align-items:center; justify-content:space-between; gap:12px;
            padding:14px 22px; position:sticky; top:0; z-index:10;
            background: linear-gradient(180deg, rgba(15,23,42,.7), rgba(15,23,42,.35) 50%, transparent);
            backdrop-filter: blur(6px);
        }
        .brand{display:flex; align-items:center; gap:10px}
        .logo{width:34px; height:34px; border-radius:10px; display:grid; place-items:center;
            background:linear-gradient(145deg,var(--g1),var(--g2)); color:white; font-weight:700;}
        .logout{
            padding:8px 12px; border-radius:10px; background:rgba(255,255,255,.08);
            border:1px solid rgba(255,255,255,.18);
        }
        .logout:hover{background:rgba(255,255,255,.14)}
        .greet{
            display:flex; align-items:center; justify-content:space-between; gap:10px;
            margin:20px 0 14px;
        }
        .title{font-size:22px; margin:0}
        .mut{color:var(--mut)}
        .clock{font-size:13px; color:var(--mut)}
        .banner{
            border:1px solid rgba(255,255,255,.2); background:rgba(255,255,255,.06);
            padding:10px 12px; border-radius:12px; margin-bottom:12px;
        }
        .grid{
            display:grid; gap:16px;
            grid-template-columns: repeat(12, 1fr);
        }
        .card{
            grid-column: span 6; /* 2 per row on desktop */
            background:var(--card); border:1px solid var(--card-b); border-radius:16px;
            padding:18px; box-shadow:var(--shadow); backdrop-filter: blur(8px);
            transition: transform .08s ease, background .2s ease;
        }
        .card:focus-within, .card:hover{ background:rgba(255,255,255,.10); transform: translateY(-1px); }
        .card h3{ margin:0 0 6px; font-size:18px }
        .card p{ margin:0 0 12px; color:var(--mut) }
        .actions{ display:flex; flex-wrap:wrap; gap:10px; }
        .btn{
            padding:10px 12px; border-radius:10px; border:1px solid rgba(255,255,255,.22);
            background:rgba(255,255,255,.08); color:var(--txt);
        }
        .btn.primary{
            border-color:transparent;
            background:linear-gradient(135deg,var(--g1),var(--g2));
            color:white; font-weight:600; box-shadow: 0 8px 22px rgba(34,197,94,.25);
        }
        .kbd{font-family:ui-monospace, SFMono-Regular, Menlo, monospace; font-size:12px; padding:2px 6px;
            border:1px solid rgba(255,255,255,.25); border-bottom-width:2px; border-radius:6px; color:#c7f9d4;}
        @media (max-width:900px){ .card{ grid-column: span 12 } }
        footer{ text-align:center; color:var(--mut); font-size:12px; padding:16px 0 24px }
        .icon{ width:18px; height:18px; margin-right:6px; vertical-align:-3px; opacity:.9 }
        .hint{ font-size:12px; color:var(--mut); margin-top:8px }
    </style>
</head>
<body>

<header class="topbar">
    <div class="brand">
        <div class="logo">P</div>
        <div>
            <div style="font-weight:700">Pahana</div>
            <div class="mut" style="font-size:12px">Billing Management</div>
        </div>
    </div>
    <a class="logout" href="<%=request.getContextPath()%>/auth/logout" title="Logout">Logout</a>
</header>

<main class="container">
    <div class="greet">
        <div>
            <h1 class="title">Welcome, <%= username %></h1>
            <div class="mut">Use the tiles below or press the keyboard shortcuts.</div>
        </div>
        <div class="clock" id="clock">—</div>
    </div>

    <div class="banner">
        Tips: <span class="kbd">C</span> Customers, <span class="kbd">I</span> Items,
        <span class="kbd">B</span> Billing, <span class="kbd">H</span> Help, <span class="kbd">N</span> New Bill
    </div>

    <section class="grid" aria-label="Main modules">

        <!-- Customers -->
        <div class="card" tabindex="0">
            <h3>
                <svg class="icon" viewBox="0 0 24 24" fill="none">
                    <path d="M12 12a5 5 0 1 0-5-5 5 5 0 0 0 5 5Zm7 9v-1a6 6 0 0 0-6-6H11a6 6 0 0 0-6 6v1"
                          stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
                Customers
            </h3>
            <p>Manage customer accounts and contact information.</p>
            <div class="actions">
                <a class="btn primary" href="<%=request.getContextPath()%>/customers">Open</a>
                <a class="btn" href="<%=request.getContextPath()%>/customers/new">New Customer</a>
            </div>
            <div class="hint">Shortcut: <span class="kbd">C</span></div>
        </div>

        <!-- Items -->
        <div class="card" tabindex="0">
            <h3>
                <svg class="icon" viewBox="0 0 24 24" fill="none">
                    <path d="M4 7h16M4 12h16M4 17h16" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
                </svg>
                Items
            </h3>
            <p>Maintain billable items and unit pricing.</p>
            <div class="actions">
                <a class="btn primary" href="<%=request.getContextPath()%>/items">Open</a>
                <a class="btn" href="<%=request.getContextPath()%>/items/new">New Item</a>
            </div>
            <div class="hint">Shortcut: <span class="kbd">I</span></div>
        </div>

        <!-- Billing -->
        <div class="card" tabindex="0">
            <h3>
                <svg class="icon" viewBox="0 0 24 24" fill="none">
                    <path d="M4 6h16M4 12h16M4 18h10" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
                </svg>
                Billing
            </h3>
            <p>Create invoices, print bills, and review history.</p>
            <div class="actions">
                <a class="btn primary" href="<%=request.getContextPath()%>/bills">Open</a>
                <a class="btn" href="<%=request.getContextPath()%>/bills/new">New Bill</a>
            </div>
            <div class="hint">Shortcuts: <span class="kbd">B</span> (open), <span class="kbd">N</span> (new bill)</div>
        </div>

        <!-- Help -->
        <div class="card" tabindex="0">
            <h3>
                <svg class="icon" viewBox="0 0 24 24" fill="none">
                    <path d="M12 18h.01M12 14a4 4 0 1 1 3.5-6" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/>
                </svg>
                Help & Manual
            </h3>
            <p>Read the user manual, shortcuts, and troubleshooting.</p>
            <div class="actions">
                <a class="btn primary" href="<%=request.getContextPath()%>/help">Open Help</a>
            </div>
            <div class="hint">Shortcut: <span class="kbd">H</span></div>
        </div>

    </section>
</main>

<footer>© <%= java.time.Year.now() %> Pahana</footer>

<script>
    (function(){
        // Live clock & greeting nuance
        function pad(n){return n<10?('0'+n):n}
        function tick(){
            const d = new Date();
            const t = d.getHours()+':'+pad(d.getMinutes())+':'+pad(d.getSeconds());
            document.getElementById('clock').textContent = d.toDateString() + ' • ' + t;
        }
        setInterval(tick, 1000); tick();

        // Keyboard shortcuts (when not typing in input/textarea)
        function isTyping(){
            const a = document.activeElement;
            if(!a) return false;
            const tag = (a.tagName||'').toLowerCase();
            return tag === 'input' || tag === 'textarea' || a.isContentEditable;
        }
        document.addEventListener('keydown', function(e){
            if (isTyping() || e.ctrlKey || e.metaKey || e.altKey) return;
            const base = '<%=request.getContextPath()%>';
            switch(e.key.toLowerCase()){
                case 'c': window.location = base + '/customers'; break;
                case 'i': window.location = base + '/items'; break;
                case 'b': window.location = base + '/bills'; break;
                case 'n': window.location = base + '/bills/new'; break;
                case 'h': window.location = base + '/help'; break;
            }
        });
    })();
</script>


</body>
</html>
