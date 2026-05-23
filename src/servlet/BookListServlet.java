package servlet;

import bean.Book;
import dao.BookDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/bookList")
public class BookListServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        try {
            BookDAO dao = new BookDAO();
            List<Book> books;

            String categoryId = req.getParameter("categoryId");
            String keyword = req.getParameter("keyword");

            if (keyword != null && !keyword.trim().isEmpty()) {
                books = dao.search(keyword.trim());
                req.setAttribute("keyword", keyword);
            } else if (categoryId != null && !categoryId.isEmpty()) {
                books = dao.findByCategory(Integer.parseInt(categoryId));
                req.setAttribute("categoryId", categoryId);
            } else {
                books = dao.findAll();
            }

            req.setAttribute("books", books);
            req.setAttribute("categories", dao.findAllCategories());
        } catch (SQLException e) {
            req.setAttribute("error", "数据库错误: " + e.getMessage());
        }
        req.getRequestDispatcher("bookList.jsp").forward(req, resp);
    }
}
