<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="购物车" scope="request"/>
<jsp:include page="header.jsp"/>

<c:if test="${not empty msg}">
    <p style="color:green;padding:20px;background:#fff;border-radius:8px;text-align:center;">${msg}</p>
</c:if>
<c:if test="${not empty error}">
    <p style="color:red;padding:20px;background:#fff;border-radius:8px;text-align:center;">${error}</p>
</c:if>

<div class="container" style="margin-top:30px;">
    <h2 class="section-title">我的购物车</h2>

    <c:if test="${empty cartItems}">
        <p style="text-align:center;padding:50px;color:#888;">购物车为空，<a href="bookList">去逛逛</a></p>
    </c:if>

    <c:if test="${not empty cartItems}">
        <table class="cart-table">
            <tr>
                <th>图书</th>
                <th>单价</th>
                <th>数量</th>
                <th>小计</th>
                <th>操作</th>
            </tr>
            <c:forEach items="${cartItems}" var="item">
                <tr>
                    <td>
                        <a href="bookDetail?id=${item.bookId}" style="color:#2c3e50;text-decoration:none;">
                            <strong>${item.book.title}</strong>
                        </a>
                    </td>
                    <td>¥${item.book.price}</td>
                    <td>
                        <form action="cart" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="${item.id}">
                            <input type="number" name="quantity" value="${item.quantity}" min="1" class="qty-input" onchange="this.form.submit()">
                        </form>
                    </td>
                    <td>¥<fmt:formatNumber value="${item.book.price * item.quantity}" pattern="#0.00"/></td>
                    <td>
                        <form action="cart" method="post" style="display:inline;" onsubmit="return confirm('确认删除？')">
                            <input type="hidden" name="action" value="remove">
                            <input type="hidden" name="id" value="${item.id}">
                            <button type="submit" class="btn btn-danger btn-sm">删除</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </table>
        <div class="cart-summary">
            <p>合计: <span class="total">¥<fmt:formatNumber value="${total}" pattern="#0.00"/></span></p>
            <form action="cart" method="post">
                <input type="hidden" name="action" value="checkout">
                <div style="background:#f9f9f9;border-radius:8px;padding:20px;margin:15px 0;">
                    <h4 style="margin:0 0 15px 0;">收货信息</h4>
                    <div style="display:flex;gap:15px;flex-wrap:wrap;">
                        <div style="flex:1;min-width:120px;">
                            <label style="display:block;margin-bottom:4px;color:#666;font-size:14px;">收货人</label>
                            <input type="text" name="receiver_name" required
                                   style="width:100%;padding:8px 12px;border:1px solid #ddd;border-radius:6px;box-sizing:border-box;">
                        </div>
                        <div style="flex:1;min-width:150px;">
                            <label style="display:block;margin-bottom:4px;color:#666;font-size:14px;">联系电话</label>
                            <input type="text" name="receiver_phone" required
                                   style="width:100%;padding:8px 12px;border:1px solid #ddd;border-radius:6px;box-sizing:border-box;">
                        </div>
                        <div style="flex:2;min-width:200px;">
                            <label style="display:block;margin-bottom:4px;color:#666;font-size:14px;">收货地址</label>
                            <input type="text" name="receiver_address" required
                                   style="width:100%;padding:8px 12px;border:1px solid #ddd;border-radius:6px;box-sizing:border-box;">
                        </div>
                    </div>
                </div>
                <div style="display:flex; gap:10px; justify-content:flex-end;">
                    <button type="submit" class="btn btn-primary">提交订单</button>
                    <button type="button" class="btn btn-danger btn-sm" onclick="if(confirm('确认清空购物车？')){document.getElementById('clearForm').submit();}">清空购物车</button>
                </div>
            </form>
            <form id="clearForm" action="cart" method="post" style="display:none;">
                <input type="hidden" name="action" value="clear">
            </form>
        </div>
    </c:if>
</div>

<jsp:include page="footer.jsp"/>
