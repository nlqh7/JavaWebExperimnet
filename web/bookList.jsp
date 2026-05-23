<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="图书浏览" scope="request"/>
<jsp:include page="header.jsp"/>

<div class="search-bar">
    <form action="bookList" method="get" class="search-form-inline">
        <input type="text" name="keyword" placeholder="搜索书名或作者..." value="${keyword}">
        <button type="submit">搜索</button>
    </form>
</div>

<div class="category-nav">
    <div class="container">
        <a href="bookList" class="${empty categoryId ? 'active' : ''}">全部</a>
        <c:forEach items="${categories}" var="cat">
            <a href="bookList?categoryId=${cat.id}" class="${cat.id == categoryId ? 'active' : ''}">${cat.name}</a>
        </c:forEach>
    </div>
</div>

<c:if test="${not empty error}">
    <div class="container"><p style="color:red;padding:20px;background:#fff;border-radius:8px;">${error}</p></div>
</c:if>

<div class="container">
    <h2 class="section-title">
        <c:choose>
            <c:when test="${not empty keyword}">搜索: "${keyword}" 的结果</c:when>
            <c:otherwise>全部图书</c:otherwise>
        </c:choose>
    </h2>

    <c:if test="${empty books}">
        <p style="text-align:center;padding:50px;color:#888;">暂无图书</p>
    </c:if>

    <div class="book-grid">
        <c:forEach items="${books}" var="book">
            <div class="book-card" data-href="bookDetail?id=${book.id}">
                <c:choose>
                    <c:when test="${empty book.cover}">
                        <div class="cover-placeholder">${book.title}</div>
                    </c:when>
                    <c:otherwise>
                        <img class="cover-img" src="${book.cover}" alt="${book.title}" data-title="${book.title}">
                    </c:otherwise>
                </c:choose>
                <div class="info">
                    <h3><a href="bookDetail?id=${book.id}">${book.title}</a></h3>
                    <p class="author">${book.author} | ${book.categoryName}</p>
                    <p class="price">¥${book.price}</p>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<jsp:include page="footer.jsp"/>
