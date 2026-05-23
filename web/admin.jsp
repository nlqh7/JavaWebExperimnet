<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dao.BookDAO, bean.Book, bean.Category, bean.User, java.util.List, java.net.URLEncoder" %>
<%
    request.setCharacterEncoding("UTF-8");
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    String adminMsg = (String) session.getAttribute("adminMsg");
    if (adminMsg != null) {
        session.removeAttribute("adminMsg");
    }
    BookDAO dao = new BookDAO();
    String action = request.getParameter("action");
    Book editBook = null;

    try {
        if ("add".equals(action)) {
            Book b = new Book();
            b.setTitle(request.getParameter("title"));
            b.setAuthor(request.getParameter("author"));
            b.setPrice(Double.parseDouble(request.getParameter("price")));
            b.setDescription(request.getParameter("description"));
            b.setCover(request.getParameter("cover"));
            b.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
            b.setStock(Integer.parseInt(request.getParameter("stock")));
            dao.add(b);
            session.setAttribute("adminMsg", "《" + b.getTitle() + "》添加成功");
            response.sendRedirect("admin.jsp");
            return;
        }

        if ("update".equals(action)) {
            Book b = new Book();
            b.setId(Integer.parseInt(request.getParameter("id")));
            b.setTitle(request.getParameter("title"));
            b.setAuthor(request.getParameter("author"));
            b.setPrice(Double.parseDouble(request.getParameter("price")));
            b.setDescription(request.getParameter("description"));
            b.setCover(request.getParameter("cover"));
            b.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
            b.setStock(Integer.parseInt(request.getParameter("stock")));
            dao.update(b);
            session.setAttribute("adminMsg", "《" + b.getTitle() + "》更新成功");
            response.sendRedirect("admin.jsp");
            return;
        }

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.delete(id);
            session.setAttribute("adminMsg", "删除成功");
            response.sendRedirect("admin.jsp");
            return;
        }

        if ("fixEncoding".equals(action)) {
            dao.fixAllEncoding();
            session.setAttribute("adminMsg", "乱码修复完成");
            response.sendRedirect("admin.jsp?fixed=1");
            return;
        }

        // 搜索与排序
        String keyword = request.getParameter("keyword");
        String sort = request.getParameter("sort");
        List<Book> books;
        if (keyword != null && !keyword.trim().isEmpty()) {
            books = dao.search(keyword.trim());
        } else {
            books = dao.findAll();
        }
        if (sort != null) {
            switch (sort) {
                case "price_asc":  books.sort((a, b) -> Double.compare(a.getPrice(), b.getPrice())); break;
                case "price_desc": books.sort((a, b) -> Double.compare(b.getPrice(), a.getPrice())); break;
                case "stock_asc":  books.sort((a, b) -> Integer.compare(a.getStock(), b.getStock())); break;
                case "stock_desc": books.sort((a, b) -> Integer.compare(b.getStock(), a.getStock())); break;
                case "id_asc":     books.sort((a, b) -> Integer.compare(a.getId(), b.getId())); break;
                case "id_desc":    books.sort((a, b) -> Integer.compare(b.getId(), a.getId())); break;
            }
        }
        List<Category> categories = dao.findAllCategories();
        String encodedKeyword = (keyword != null && !keyword.trim().isEmpty()) ? URLEncoder.encode(keyword.trim(), "UTF-8") : "";
        request.setAttribute("books", books);
        request.setAttribute("categoryList", categories);
        request.setAttribute("keyword", keyword);
        request.setAttribute("encodedKeyword", encodedKeyword);
        request.setAttribute("sort", sort);
        String editId = request.getParameter("editId");
        if (editId != null) {
            editBook = dao.findById(Integer.parseInt(editId));
            request.setAttribute("editBook", editBook);
            request.setAttribute("editCategoryId", editBook.getCategoryId());
        }
    } catch (Exception e) {
        if (action != null) {
            session.setAttribute("adminMsg", "操作失败: " + e.getMessage());
            response.sendRedirect("admin.jsp");
            return;
        }
        request.setAttribute("dbError", e.getMessage());
    }
%>
<c:set var="pageTitle" value="后台管理" scope="request"/>
<jsp:include page="header.jsp"/>

<div class="container" style="margin-top:30px;">
    <% if (adminMsg != null) { %>
        <div style="<%= adminMsg.startsWith("操作失败") ? "background:#fff0f0;border:1px solid #e74c3c;color:#c0392b;" : "background:#f0fff0;border:1px solid #27ae60;color:#27ae60;" %>padding:12px 20px;border-radius:8px;margin-bottom:15px;display:flex;justify-content:space-between;align-items:center;">
            <span><%= adminMsg %></span>
            <button onclick="this.parentElement.remove()" style="background:none;border:none;color:inherit;cursor:pointer;font-size:18px;">&times;</button>
        </div>
    <% } %>
    <c:if test="${not empty dbError}">
        <p style="color:#c0392b;padding:12px 20px;background:#fff0f0;border:1px solid #e74c3c;border-radius:8px;margin-bottom:15px;">数据库错误: ${dbError}</p>
    </c:if>

    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;">
        <h2 class="section-title" style="margin:0;border:none;padding:0;">图书列表</h2>
        <button id="toggleFormBtn" class="btn btn-primary" onclick="toggleForm()">添加图书</button>
    </div>

    <div style="display:flex;gap:10px;align-items:center;margin-bottom:20px;padding:12px 16px;background:#fff;border-radius:8px;box-shadow:0 2px 6px rgba(0,0,0,0.06);flex-wrap:wrap;">
        <form action="admin.jsp" method="get" style="display:flex;gap:8px;align-items:center;flex:1;min-width:250px;">
            <input type="text" name="keyword" value="${keyword}" placeholder="搜索书名或作者..."
                   style="padding:8px 14px;border:1px solid #ddd;border-radius:6px;font-size:14px;flex:1;min-width:150px;">
            <button type="submit" class="btn btn-sm btn-primary">搜索</button>
            <c:if test="${not empty keyword}">
                <a href="admin.jsp" class="btn btn-sm" style="background:#eee;color:#666;">清除</a>
            </c:if>
        </form>
        <select name="sort" onchange="var u='admin.jsp?sort='+this.value;<c:if test="${not empty encodedKeyword}">u+='&amp;keyword=${encodedKeyword}';</c:if>location.href=u;"
                style="padding:8px 12px;border:1px solid #ddd;border-radius:6px;font-size:14px;background:#fff;">
            <option value="">默认排序</option>
            <option disabled>── 价格 ──</option>
            <option value="price_asc" ${sort == 'price_asc' ? 'selected' : ''}>价格 ↑</option>
            <option value="price_desc" ${sort == 'price_desc' ? 'selected' : ''}>价格 ↓</option>
            <option disabled>── 库存 ──</option>
            <option value="stock_asc" ${sort == 'stock_asc' ? 'selected' : ''}>库存 ↑</option>
            <option value="stock_desc" ${sort == 'stock_desc' ? 'selected' : ''}>库存 ↓</option>
            <option disabled>── ID ──</option>
            <option value="id_asc" ${sort == 'id_asc' ? 'selected' : ''}>ID ↑</option>
            <option value="id_desc" ${sort == 'id_desc' ? 'selected' : ''}>ID ↓</option>
        </select>
        <a href="admin.jsp?action=fixEncoding" class="btn btn-sm"
           style="background:#f0ad4e;color:#fff;white-space:nowrap;"
           onclick="return confirm('即将尝试修复乱码数据，继续？')">修复乱码</a>
        <c:if test="${not empty keyword}">
            <span style="color:#888;font-size:13px;">搜索"${keyword}"，找到 ${books.size()} 本</span>
        </c:if>
    </div>

    <div id="bookForm" style="display:<%= editBook != null ? "block" : "none" %>;background:#fff;padding:25px;border-radius:8px;box-shadow:0 2px 8px rgba(0,0,0,0.1);margin-bottom:20px;">
        <h3 style="margin:0 0 20px 0;color:#2c3e50;"><%= editBook != null ? "编辑图书" : "添加图书" %></h3>
        <form action="admin.jsp" method="post">
            <input type="hidden" name="action" value="<%= editBook != null ? "update" : "add" %>">
            <% if (editBook != null) { %>
                <input type="hidden" name="id" value="<%= editBook.getId() %>">
            <% } %>
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:15px;">
                <div class="form-group">
                    <label>书名</label>
                    <input type="text" name="title" value="<%= editBook != null ? editBook.getTitle() : "" %>" required>
                </div>
                <div class="form-group">
                    <label>作者</label>
                    <input type="text" name="author" value="<%= editBook != null ? editBook.getAuthor() : "" %>">
                </div>
                <div class="form-group">
                    <label>价格</label>
                    <input type="number" step="0.01" name="price" value="<%= editBook != null ? editBook.getPrice() : "" %>" required>
                </div>
                <div class="form-group">
                    <label>库存</label>
                    <input type="number" name="stock" value="<%= editBook != null ? editBook.getStock() : "" %>" required>
                </div>
                <div class="form-group">
                    <label>分类</label>
                    <select name="categoryId" required style="width:100%;padding:10px 12px;border:1px solid #ddd;border-radius:6px;font-size:14px;">
                        <option value="">请选择分类</option>
                        <c:forEach items="${categoryList}" var="cat">
                            <option value="${cat.id}" <c:if test="${editCategoryId == cat.id}">selected</c:if>>${cat.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group" style="grid-column:1/-1;">
                    <label>封面图片URL</label>
                    <div style="display:flex;gap:15px;align-items:flex-start;">
                        <div style="flex:1;">
                            <input type="text" id="coverInput" name="cover" value="<%= editBook != null && editBook.getCover() != null ? editBook.getCover() : "" %>" oninput="previewCover()">
                            <small style="color:#999;">支持图片URL，留空则显示默认封面</small>
                        </div>
                        <div id="coverPreview" style="width:80px;height:106px;border-radius:4px;overflow:hidden;background:#eee;flex-shrink:0;display:<%= editBook != null && editBook.getCover() != null && !editBook.getCover().isEmpty() ? "block" : "none" %>;">
                            <img id="coverPreviewImg" src="<%= editBook != null && editBook.getCover() != null ? editBook.getCover() : "" %>" style="width:100%;height:100%;object-fit:cover;" onerror="this.parentElement.style.display='none'">
                        </div>
                    </div>
                </div>
            </div>
            <div class="form-group" style="margin-top:5px;">
                <label>描述</label>
                <textarea name="description" rows="3"><%= editBook != null ? editBook.getDescription() : "" %></textarea>
            </div>
            <div style="display:flex;gap:10px;margin-top:10px;">
                <button type="submit" class="btn btn-primary"><%= editBook != null ? "保存修改" : "添加图书" %></button>
                <% if (editBook != null) { %>
                    <a href="admin.jsp" class="btn btn-sm" style="line-height:36px;">取消编辑</a>
                <% } else { %>
                    <button type="button" class="btn btn-sm" onclick="toggleForm()" style="line-height:36px;">收起</button>
                <% } %>
            </div>
        </form>
    </div>

    <c:if test="${param.fixed == '1'}">
        <p style="color:green;padding:15px;background:#fff;border-radius:8px;margin-bottom:20px;">乱码修复完成，请检查以下内容是否恢复正常。</p>
    </c:if>

    <c:if test="${empty books}">
        <p style="text-align:center;padding:50px;color:#888;">暂无图书</p>
    </c:if>

    <c:if test="${not empty books}">
        <div style="background:#fff;border-radius:8px;box-shadow:0 2px 8px rgba(0,0,0,0.1);overflow-x:auto;">
            <table class="admin-table">
                <tr>
                    <th>ID</th><th>封面</th><th>书名</th><th>作者</th><th>价格</th><th>库存</th><th>分类</th><th>操作</th>
                </tr>
                <c:forEach items="${books}" var="book">
                    <tr>
                        <td>${book.id}</td>
                        <td style="width:50px;">
                            <c:choose>
                                <c:when test="${empty book.cover}">
                                    <div style="width:40px;height:52px;background:linear-gradient(135deg,#667eea,#764ba2);border-radius:3px;display:flex;align-items:center;justify-content:center;font-size:10px;color:#fff;">无图</div>
                                </c:when>
                                <c:otherwise>
                                    <img src="${book.cover}" style="width:40px;height:52px;object-fit:cover;border-radius:3px;background:#eee;" onerror="this.style.display='none';this.nextSibling.style.display='flex';">
                                    <div style="display:none;width:40px;height:52px;background:#e8e8e8;border-radius:3px;align-items:center;justify-content:center;font-size:10px;color:#999;">加载失败</div>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td><strong>${book.title}</strong></td>
                        <td>${book.author}</td>
                        <td>¥${book.price}</td>
                        <td><span style="color:${book.stock <= 5 ? '#e74c3c' : '#27ae60'};font-weight:bold;">${book.stock}</span></td>
                        <td>${book.categoryName}</td>
                        <td style="white-space:nowrap;">
                            <a href="admin.jsp?editId=${book.id}#bookForm" class="btn btn-primary btn-sm">编辑</a>
                            <a href="admin.jsp?action=delete&id=${book.id}" class="btn btn-danger btn-sm" onclick="return confirm('确认删除《${book.title}》？')">删除</a>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </div>
    </c:if>
</div>

<script>
function toggleForm() {
    var form = document.getElementById('bookForm');
    var btn = document.getElementById('toggleFormBtn');
    if (form.style.display === 'none') {
        form.style.display = 'block';
        btn.textContent = '收起表单';
        form.scrollIntoView({ behavior: 'smooth' });
    } else {
        form.style.display = 'none';
        btn.textContent = '添加图书';
    }
}

function previewCover() {
    var url = document.getElementById('coverInput').value.trim();
    var preview = document.getElementById('coverPreview');
    var img = document.getElementById('coverPreviewImg');
    if (url) {
        img.src = url;
        preview.style.display = 'block';
    } else {
        preview.style.display = 'none';
        img.src = '';
    }
}

// 编辑模式自动展开表单并滚动
<% if (editBook != null) { %>
    window.onload = function() {
        document.getElementById('toggleFormBtn').textContent = '收起表单';
        document.getElementById('bookForm').scrollIntoView({ behavior: 'smooth' });
    };
<% } %>
</script>

<jsp:include page="footer.jsp"/>
