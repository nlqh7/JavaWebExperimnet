package servlet;

import bean.Book;
import dao.BookDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/bookDetail")
public class BookDetailServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String id = req.getParameter("id");
        if (id == null || id.isEmpty()) {
            resp.sendRedirect("bookList");
            return;
        }
        try {
            BookDAO dao = new BookDAO();
            Book book = dao.findById(Integer.parseInt(id));
            if (book == null) {
                resp.sendRedirect("bookList");
                return;
            }
            req.setAttribute("book", book);
        } catch (SQLException e) {
            req.setAttribute("error", "数据库错误: " + e.getMessage());
        }
        req.getRequestDispatcher("bookDetail.jsp").forward(req, resp);
    }
}
