<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${requestScope.pageTitle} - 网上书店</title>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>📚</text></svg>">
    <link rel="stylesheet" href="css/style.css">
    <script src="js/script.js" defer></script>
</head>
<body>
<div class="header">
    <div class="container">
        <h1><a href="index.jsp">网上书店</a></h1>
        <div class="nav">
            <a href="index.jsp">首页</a>
            <a href="bookList">全部图书</a>
            <a href="cart">购物车</a>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="order">我的订单</a>
                    <span class="user-info">欢迎, ${sessionScope.user.username}</span>
                    <c:if test="${sessionScope.user.role == 'admin'}">
                        <a href="admin.jsp">后台管理</a>
                    </c:if>
                    <a href="logout.jsp">退出</a>
                </c:when>
                <c:otherwise>
                    <a href="login">登录</a>
                    <a href="register">注册</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
