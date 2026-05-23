<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="用户注册" scope="request"/>
<jsp:include page="header.jsp"/>
<div class="form-card">
    <h2>用户注册</h2>
    <c:if test="${not empty error}">
        <p class="error">${error}</p>
    </c:if>
    <form action="register" method="post">
        <div class="form-group">
            <label>用户名</label>
            <input type="text" name="username" required>
        </div>
        <div class="form-group">
            <label>密码</label>
            <input type="password" name="password" required>
        </div>
        <div class="form-group">
            <label>邮箱</label>
            <input type="email" name="email" required>
        </div>
        <button type="submit" class="btn btn-primary" style="width:100%">注册</button>
    </form>
    <p class="link">已有账号？<a href="login">立即登录</a></p>
</div>

<jsp:include page="footer.jsp"/>
