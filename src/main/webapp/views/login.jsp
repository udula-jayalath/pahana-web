
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%-- Small HTML escape helper for safe echo --%>
<%!
    private static String esc(Object o){
        if (o == null) return "";
        String s = String.valueOf(o);
        return s.replace("&","&amp;").replace("<","&lt;")
                .replace(">","&gt;").replace("\"","&quot;");
    }
%>

<%
    String err = (String) request.getAttribute("error");
    String uname = request.getParameter("username");
    if (uname == null) uname = (String) request.getAttribute("username");
%>

<!doctype html>
<html>
<head>
    <title>Sign in • Pahana</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
        :root{
            --bg1: #0f172a;  /* slate-900 */
            --bg2: #1e293b;  /* slate-800 */
            --pri: #22c55e;  /* green-500 */
            --pri2:#16a34a;  /* green-600 */
            --err:#ef4444;   /* red-500 */
            --txt:#e5e7eb;   /* zinc-200 */
            --mut:#94a3b8;   /* slate-400 */
            --card: rgba(255,255,255,0.08);
            --card-border: rgba(255,255,255,0.18);
            --shadow: 0 20px 60px rgba(0,0,0,0.35);
        }
        *{box-sizing:border-box}
        html,body{height:100%}
        body{
            margin:0; color:var(--txt);
            font: 16px/1.5 system-ui, -apple-system, Segoe UI, Roboto, "Helvetica Neue", Arial;
            background:
                    radial-gradient(1200px 600px at 10% -10%, #10b98122, transparent 60%),
                    radial-gradient(1000px 500px at 110% 110%, #22c55e22, transparent 60%),
                    linear-gradient(130deg, var(--bg1), var(--bg2));
            display:flex; align-items:center; justify-content:center; padding:24px;
            animation: bgshift 12s ease-in-out infinite alternate;
        }
        @keyframes bgshift{ from{ filter:hue-rotate(0deg)} to{ filter:hue-rotate(-10deg)} }

        .wrap{ width:100%; max-width: 420px; }
        .card{
            background: var(--card);
            border: 1px solid var(--card-border);
            border-radius: 18px;
            box-shadow: var(--shadow);
            backdrop-filter: blur(10px);
            padding: 28px;
            animation: floatin .5s ease;
        }
        @keyframes floatin { from{ transform:translateY(8px); opacity:0 } to{ transform:translateY(0); opacity:1 } }
        .brand{
            display:flex; align-items:center; gap:12px; margin-bottom:10px;
        }
        .logo{
            width:44px; height:44px; border-radius:12px;
            background: linear-gradient(145deg, var(--pri), var(--pri2));
            display:grid; place-items:center; color:white; font-weight:700;
            box-shadow: inset 0 0 18px #ffffff22;
        }
        h1{ font-size:20px; margin:0 }
        .mut{ color:var(--mut); margin:6px 0 18px }

        .field{ position:relative; margin:12px 0; }
        .label{ display:block; font-size:13px; color:var(--mut); margin-bottom:6px; }
        .input{
            width:100%; padding:12px 44px 12px 40px;
            border-radius:12px; border:1px solid #ffffff2a; outline:none;
            background: rgba(255,255,255,0.06); color:var(--txt);
            transition: border-color .2s, background .2s, box-shadow .2s;
        }
        .input:focus{
            border-color: #22c55e80; background: rgba(255,255,255,0.10);
            box-shadow: 0 0 0 3px #22c55e33;
        }
        .icon{
            position:absolute; left:12px; top:50%; transform:translateY(-50%);
            color: var(--mut); width:18px; height:18px;
        }
        .toggle{
            position:absolute; right:10px; top:50%; transform:translateY(-50%);
            background:none; border:none; color:var(--mut); cursor:pointer; padding:6px; border-radius:8px;
        }
        .toggle:hover{ color:var(--txt); background:#ffffff12 }
        .caps{ font-size:12px; color:#fca5a5; margin-top:6px; display:none; }

        .actions{ display:flex; align-items:center; justify-content:space-between; margin-top:10px; }
        .remember{ display:flex; align-items:center; gap:8px; font-size:13px; color:var(--mut) }
        .btn{
            appearance:none; border:none; cursor:pointer;
            padding:12px 16px; border-radius:12px;
            background: linear-gradient(135deg, var(--pri), var(--pri2));
            color:white; font-weight:600; letter-spacing:.2px;
            box-shadow: 0 8px 20px rgba(34,197,94,.25);
            transition: transform .08s ease, opacity .2s ease;
        }
        .btn:active{ transform: translateY(1px) }
        .btn[disabled]{ opacity:.6; cursor:wait }

        .alert{
            border:1px solid #ef444477; background:#ef444433; color:#fecaca;
            padding:10px 12px; border-radius:12px; margin-bottom:12px; font-size:14px;
            display:flex; gap:8px; align-items:flex-start;
            animation: shake .3s ease-in-out;
        }
        @keyframes shake {
            0%,100%{ transform: translateX(0) }
            25%{ transform: translateX(-3px) }
            75%{ transform: translateX(3px) }
        }
        a.small{ color:#c7f9d4; text-decoration:none; font-size:13px }
        a.small:hover{ text-decoration:underline }
        footer{ text-align:center; margin-top:14px; color:var(--mut); font-size:12px }
    </style>
</head>
<body>

<div class="wrap">
    <div class="card" id="card">
        <div class="brand">
            <div class="logo">P</div>
            <div>
                <h1>Welcome back</h1>
                <div class="mut">Sign in to continue to Pahana</div>
            </div>
        </div>

        <% if (err != null && !err.isBlank()) { %>
        <div class="alert">
            <!-- error icon -->
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" class="icon" style="position:static">
                <path d="M12 9v4m0 4h.01M12 3l9 18H3L12 3z" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            <div><%= esc(err) %></div>
        </div>
        <% } %>

        <form id="loginForm" method="post" action="<%=request.getContextPath()%>/auth/login" autocomplete="on" novalidate>
            <div class="field">
                <label class="label" for="username">Username</label>
                <svg class="icon" viewBox="0 0 24 24" fill="none">
                    <path d="M12 12a5 5 0 1 0-5-5 5 5 0 0 0 5 5Zm7 9v-1a6 6 0 0 0-6-6H11a6 6 0 0 0-6 6v1" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
                <input class="input" id="username" name="username" required maxlength="50"
                       value="<%= esc(uname) %>" autofocus placeholder="e.g. admin" />
            </div>

            <div class="field">
                <label class="label" for="password">Password</label>
                <svg class="icon" viewBox="0 0 24 24" fill="none">
                    <path d="M17 11V8a5 5 0 0 0-10 0v3M6 11h12v9H6z" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
                <input class="input" id="password" type="password" name="password" required maxlength="100" placeholder="••••••••" />
                <button type="button" class="toggle" id="togglePwd" aria-label="Show password">
                    <!-- eye icon -->
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
                        <path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7S1 12 1 12Z" stroke="currentColor" stroke-width="1.6"/>
                        <circle cx="12" cy="12" r="3" stroke="currentColor" stroke-width="1.6"/>
                    </svg>
                </button>
                <div class="caps" id="capsHint">Caps Lock is ON</div>
            </div>

            <div class="actions">
                <label class="remember">
                    <input type="checkbox" id="remember" style="accent-color:#22c55e"> Remember me
                </label>
                <a class="small" href="#" onclick="return false;">Forgot password?</a>
            </div>

            <div style="margin-top:16px; display:flex; gap:10px">
                <button class="btn" id="submitBtn" type="submit" style="flex:1">Sign In</button>
            </div>
        </form>

        <footer>© <%= java.time.Year.now() %> Pahana</footer>
    </div>
</div>

<script>
    (function(){
        const pwd = document.getElementById('password');
        const toggle = document.getElementById('togglePwd');
        const capsHint = document.getElementById('capsHint');
        const form = document.getElementById('loginForm');
        const btn = document.getElementById('submitBtn');

        toggle.addEventListener('click', function(){
            const show = pwd.type === 'password';
            pwd.type = show ? 'text' : 'password';
            toggle.setAttribute('aria-label', show ? 'Hide password' : 'Show password');
        });

        pwd.addEventListener('keyup', function(e){
            const on = e.getModifierState && e.getModifierState('CapsLock');
            capsHint.style.display = on ? 'block' : 'none';
        });

        form.addEventListener('submit', function(){
            btn.disabled = true;
            btn.textContent = 'Signing in…';
        });
    })();
</script>


</body>
</html>
