<%@ page contentType="text/html;charset=UTF-8" %>
<!doctype html>
<html>
<head><title>Login</title></head>
<body>
<h3>Login</h3>
<form method="post" action="<%=request.getContextPath()%>/auth/login">
    <label>Username: <input name="username" required></label><br>
    <label>Password: <input type="password" name="password" required></label><br>
    <button type="submit">Sign In</button>
</form>
<p style="color:red;"><%= request.getAttribute("error") == null ? "" : request.getAttribute("error") %></p>
</body>
</html>
