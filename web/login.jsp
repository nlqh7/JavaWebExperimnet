<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="用户登录" scope="request"/>
<jsp:include page="header.jsp"/>
<div class="form-card">
    <h2>用户登录</h2>
    <c:if test="${not empty error}">
        <p class="error">${error}</p>
    </c:if>
    <form action="login" method="post">
        <div class="form-group">
            <label>用户名</label>
            <input type="text" name="username" required>
        </div>
        <div class="form-group">
            <label>密码</label>
            <input type="password" name="password" required>
        </div>
        <button type="submit" class="btn btn-primary" style="width:100%">登录</button>
    </form>
    <p class="link">没有账号？<a href="register">立即注册</a></p>
</div>

<jsp:include page="footer.jsp"/>
