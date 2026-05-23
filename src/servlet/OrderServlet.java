package servlet;

import bean.Order;
import bean.User;
import dao.OrderDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        try {
            OrderDAO dao = new OrderDAO();
            List<Order> orders = dao.findByUser(user.getId());
            req.setAttribute("orders", orders);
        } catch (SQLException e) {
            req.setAttribute("error", "数据库错误: " + e.getMessage());
        }
        req.getRequestDispatcher("order.jsp").forward(req, resp);
    }
}
