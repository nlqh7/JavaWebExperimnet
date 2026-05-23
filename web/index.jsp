<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dao.BookDAO, bean.Book, bean.Category, java.util.List" %>
<%
    try {
        BookDAO dao = new BookDAO();
        List<Book> books = dao.findAll();
        List<Category> categories = dao.findAllCategories();
        request.setAttribute("books", books);
        request.setAttribute("categories", categories);
    } catch (Exception e) {
        request.setAttribute("dbError", e.getMessage());
    }
%>
<c:set var="pageTitle" value="首页" scope="request"/>
<jsp:include page="header.jsp"/>

<div class="hero">
    <div class="hero-content">
        <h2>发现你的下一本好书</h2>
        <p>海量图书，优惠价格，正版保障</p>
        <form action="bookList" method="get" class="search-form-inline">
            <input type="text" name="keyword" placeholder="搜索书名或作者...">
            <button type="submit">搜索</button>
        </form>
    </div>
</div>

<c:if test="${not empty categories}">
<div class="category-nav">
    <div class="container">
        <c:forEach items="${categories}" var="cat">
            <a href="bookList?categoryId=${cat.id}">${cat.name}</a>
        </c:forEach>
    </div>
</div>
</c:if>

<div class="container">
    <c:if test="${not empty dbError}">
        <p style="color:red;padding:20px;background:#fff;border-radius:8px;">数据库错误: ${dbError}<br><small>请确保 MySQL 已启动、bookstore 库已创建，且 mysql-connector JAR 已放入 WEB-INF/lib</small></p>
    </c:if>

    <div class="section-header">
        <h2 class="section-title">推荐图书</h2>
        <a href="bookList" class="view-all">查看全部 &raquo;</a>
    </div>
    <div class="book-grid">
        <c:forEach items="${books}" var="book" begin="0" end="7">
            <div class="book-card" data-href="bookDetail?id=${book.id}">
                <c:choose>
                    <c:when test="${empty book.cover}">
                        <div class="cover-placeholder">
                            <div class="cover-placeholder-icon">📖</div>
                            <div class="cover-placeholder-title">${book.title}</div>
                            <div class="cover-placeholder-author">${book.author}</div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <img class="cover-img" src="${book.cover}" alt="${book.title}" data-title="${book.title}">
                    </c:otherwise>
                </c:choose>
                <div class="info">
                    <h3><a href="bookDetail?id=${book.id}">${book.title}</a></h3>
                    <p class="author">${book.author}</p>
                    <p class="price">¥${book.price}</p>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<jsp:include page="footer.jsp"/>
