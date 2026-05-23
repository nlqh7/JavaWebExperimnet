package servlet;

import bean.User;
import dao.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try {
            UserDAO dao = new UserDAO();
            User user = dao.login(username, password);
            if (user != null) {
                req.getSession().setAttribute("user", user);
                resp.sendRedirect("index.jsp");
            } else {
                req.setAttribute("error", "用户名或密码错误");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            req.setAttribute("error", "数据库错误: " + e.getMessage());
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("login.jsp").forward(req, resp);
    }
}
