package servlet;

import bean.User;
import dao.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String email = req.getParameter("email");

        try {
            UserDAO dao = new UserDAO();
            if (dao.isUsernameExist(username)) {
                req.setAttribute("error", "用户名已存在");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
                return;
            }

            User user = new User();
            user.setUsername(username);
            user.setPassword(password);
            user.setEmail(email);
            int id = dao.register(user);
            if (id > 0) {
                user.setId(id);
                req.getSession().setAttribute("user", user);
                resp.sendRedirect("index.jsp");
            } else {
                req.setAttribute("error", "注册失败，请重试");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            req.setAttribute("error", "数据库错误: " + e.getMessage());
            req.getRequestDispatcher("register.jsp").forward(req, resp);
        }
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("register.jsp").forward(req, resp);
    }
}
