package dao;

import bean.Book;
import bean.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {

    public List<Book> findAll() throws SQLException {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT b.*, c.name AS category_name FROM book b LEFT JOIN category c ON b.category_id=c.id ORDER BY (b.cover IS NOT NULL AND b.cover != '') DESC, b.id DESC";
        try (Connection conn = DBHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapBook(rs));
            }
        }
        return list;
    }

    public List<Book> findByCategory(int categoryId) throws SQLException {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT b.*, c.name AS category_name FROM book b LEFT JOIN category c ON b.category_id=c.id WHERE b.category_id=? ORDER BY b.id DESC";
        try (Connection conn = DBHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBook(rs));
                }
            }
        }
        return list;
    }

    public Book findById(int id) throws SQLException {
        String sql = "SELECT b.*, c.name AS category_name FROM book b LEFT JOIN category c ON b.category_id=c.id WHERE b.id=?";
        try (Connection conn = DBHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBook(rs);
                }
            }
        }
        return null;
    }

    public int add(Book book) throws SQLException {
        String sql = "INSERT INTO book(title, author, price, description, cover, category_id, stock) VALUES(?,?,?,?,?,?,?)";
        try (Connection conn = DBHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, book.getTitle());
            ps.setString(2, book.getAuthor());
            ps.setDouble(3, book.getPrice());
            ps.setString(4, book.getDescription());
            ps.setString(5, book.getCover());
            ps.setInt(6, book.getCategoryId());
            ps.setInt(7, book.getStock());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    public boolean update(Book book) throws SQLException {
        String sql = "UPDATE book SET title=?, author=?, price=?, description=?, cover=?, category_id=?, stock=? WHERE id=?";
        try (Connection conn = DBHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, book.getTitle());
            ps.setString(2, book.getAuthor());
            ps.setDouble(3, book.getPrice());
            ps.setString(4, book.getDescription());
            ps.setString(5, book.getCover());
            ps.setInt(6, book.getCategoryId());
            ps.setInt(7, book.getStock());
            ps.setInt(8, book.getId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM book WHERE id=?";
        try (Connection conn = DBHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    public List<Category> findAllCategories() throws SQLException {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT c.id, c.name FROM category c INNER JOIN book b ON c.id=b.category_id GROUP BY c.id, c.name ORDER BY c.name";
        try (Connection conn = DBHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Category(rs.getInt("id"), rs.getString("name")));
            }
        }
        return list;
    }

    public List<Book> search(String keyword) throws SQLException {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT b.*, c.name AS category_name FROM book b LEFT JOIN category c ON b.category_id=c.id WHERE b.title LIKE ? OR b.author LIKE ?";
        try (Connection conn = DBHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBook(rs));
                }
            }
        }
        return list;
    }

    public void fixAllEncoding() throws SQLException {
        String sql = "SELECT id, title, author, description FROM book";
        String updateSql = "UPDATE book SET title=?, author=?, description=? WHERE id=?";
        try (Connection conn = DBHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String title = fixGarbled(rs.getString("title"));
                String author = fixGarbled(rs.getString("author"));
                String desc = fixGarbled(rs.getString("description"));
                try (PreparedStatement ups = conn.prepareStatement(updateSql)) {
                    ups.setString(1, title);
                    ups.setString(2, author);
                    ups.setString(3, desc);
                    ups.setInt(4, rs.getInt("id"));
                    ups.executeUpdate();
                }
            }
        }
    }

    public static String fixGarbled(String s) {
        if (s == null || s.isEmpty()) return s;
        try {
            byte[] bytes = s.getBytes("ISO-8859-1");
            String fixed = new String(bytes, "UTF-8");
            for (int i = 0; i < fixed.length(); i++) {
                char c = fixed.charAt(i);
                if (c >= 0x4e00 && c <= 0x9fff) return fixed;
            }
        } catch (Exception ignored) {}
        return s;
    }

    private Book mapBook(ResultSet rs) throws SQLException {
        Book book = new Book();
        book.setId(rs.getInt("id"));
        book.setTitle(rs.getString("title"));
        book.setAuthor(rs.getString("author"));
        book.setPrice(rs.getDouble("price"));
        book.setDescription(rs.getString("description"));
        book.setCover(rs.getString("cover"));
        book.setCategoryId(rs.getInt("category_id"));
        book.setStock(rs.getInt("stock"));
        try {
            book.setCategoryName(rs.getString("category_name"));
        } catch (SQLException ignored) {}
        return book;
    }
}
