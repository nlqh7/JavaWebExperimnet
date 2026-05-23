<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="我的订单" scope="request"/>
<jsp:include page="header.jsp"/>

<div class="container" style="margin-top:30px;">
    <h2 class="section-title">我的订单</h2>

    <c:if test="${not empty error}">
        <p style="color:red;padding:20px;background:#fff;border-radius:8px;text-align:center;">${error}</p>
    </c:if>

    <c:if test="${empty orders}">
        <p style="text-align:center;padding:50px;color:#888;">暂无订单，<a href="bookList">去逛逛</a></p>
    </c:if>

    <c:if test="${not empty orders}">
        <c:forEach items="${orders}" var="order">
            <div style="background:#fff;border-radius:8px;padding:20px;margin-bottom:20px;box-shadow:0 2px 8px rgba(0,0,0,0.1);">
                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;padding-bottom:10px;border-bottom:1px solid #eee;">
                    <div>
                        <strong>订单号：</strong>${order.orderNo}
                    </div>
                    <div style="display:flex;gap:20px;align-items:center;">
                        <span style="color:#e67e22;font-weight:bold;">${order.status}</span>
                        <span style="color:#888;">
                            <fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                        </span>
                    </div>
                </div>
                <div style="display:flex;justify-content:space-between;align-items:center;">
                    <div style="color:#666;">
                        <span>收货人：${order.receiverName}</span>
                        <span style="margin-left:15px;">${order.receiverPhone}</span>
                    </div>
                    <div style="font-size:18px;color:#e74c3c;font-weight:bold;">
                        ¥<fmt:formatNumber value="${order.totalAmount}" pattern="#0.00"/>
                    </div>
                </div>
            </div>
        </c:forEach>
    </c:if>
</div>

<jsp:include page="footer.jsp"/>
