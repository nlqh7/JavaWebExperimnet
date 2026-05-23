package servlet;

import bean.CartItem;
import bean.Order;
import bean.User;
import dao.CartDAO;
import dao.OrderDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        HttpSession session = req.getSession();
        String msg = (String) session.getAttribute("msg");
        if (msg != null) {
            req.setAttribute("msg", msg);
            session.removeAttribute("msg");
        }
        String error = (String) session.getAttribute("error");
        if (error != null) {
            req.setAttribute("error", error);
            session.removeAttribute("error");
        }

        try {
            CartDAO dao = new CartDAO();
            List<CartItem> items = dao.findByUser(user.getId());
            double total = 0;
            for (CartItem item : items) {
                total += item.getBook().getPrice() * item.getQuantity();
            }
            req.setAttribute("cartItems", items);
            req.setAttribute("total", total);
        } catch (SQLException e) {
            req.setAttribute("error", "数据库错误: " + e.getMessage());
        }
        req.getRequestDispatcher("cart.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String action = req.getParameter("action");
        try {
            CartDAO dao = new CartDAO();

            if ("add".equals(action)) {
                int bookId = Integer.parseInt(req.getParameter("bookId"));
                int quantity = Integer.parseInt(req.getParameter("quantity"));
                dao.add(user.getId(), bookId, quantity);
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                int quantity = Integer.parseInt(req.getParameter("quantity"));
                if (quantity <= 0) {
                    dao.remove(id);
                } else {
                    dao.updateQuantity(id, quantity);
                }
            } else if ("remove".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                dao.remove(id);
            } else if ("clear".equals(action)) {
                dao.clear(user.getId());
            } else if ("checkout".equals(action)) {
                List<CartItem> items = dao.findByUser(user.getId());
                if (items.isEmpty()) {
                    req.getSession().setAttribute("error", "购物车为空，无法结算");
                } else {
                    String receiverName = req.getParameter("receiver_name");
                    String receiverPhone = req.getParameter("receiver_phone");
                    String receiverAddress = req.getParameter("receiver_address");
                    if (receiverName == null || receiverName.trim().isEmpty()
                            || receiverPhone == null || receiverPhone.trim().isEmpty()
                            || receiverAddress == null || receiverAddress.trim().isEmpty()) {
                        req.getSession().setAttribute("error", "请填写完整的收货信息");
                    } else {
                        Order order = new Order();
                        order.setUserId(user.getId());
                        order.setReceiverName(receiverName.trim());
                        order.setReceiverPhone(receiverPhone.trim());
                        order.setReceiverAddress(receiverAddress.trim());
                        OrderDAO orderDAO = new OrderDAO();
                        orderDAO.create(order, items);
                        req.getSession().setAttribute("msg", "结算成功！订单号：" + order.getOrderNo());
                    }
                }
            }
        } catch (SQLException e) {
            req.getSession().setAttribute("error", "操作失败: " + e.getMessage());
        }
        resp.sendRedirect("cart");
    }
}
