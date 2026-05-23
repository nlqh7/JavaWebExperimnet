<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="${book.title}" scope="request"/>
<jsp:include page="header.jsp"/>

<div class="container" style="margin-top:30px;">
    <c:if test="${not empty error}">
        <p style="color:red;padding:20px;background:#fff;border-radius:8px;">${error}</p>
    </c:if>
    <div class="detail-box">
        <c:choose>
            <c:when test="${empty book.cover}">
                <div class="cover-placeholder">${book.title}</div>
            </c:when>
            <c:otherwise>
                <img class="cover-img" src="${book.cover}" alt="${book.title}" data-title="${book.title}">
            </c:otherwise>
        </c:choose>
        <div class="detail-info">
            <h2>${book.title}</h2>
            <p class="meta">作者: ${book.author} | 分类: ${book.categoryName} | 库存: ${book.stock}</p>
            <p class="price">¥${book.price}</p>
            <p class="desc">${book.description}</p>
            <form action="cart" method="post" class="add-cart">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="bookId" value="${book.id}">
                <input type="number" name="quantity" value="1" min="1" max="${book.stock}">
                <button type="submit" class="btn btn-danger">加入购物车</button>
            </form>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp"/>
