package dao;

import bean.Book;
import bean.CartItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    public boolean add(int userId, int bookId, int quantity) throws SQLException {
        String checkSql = "SELECT id, quantity FROM cart WHERE user_id=? AND book_id=?";
        try (Connection conn = DBHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int newQty = rs.getInt("quantity") + quantity;
                    String updateSql = "UPDATE cart SET quantity=? WHERE id=?";
                    try (PreparedStatement ups = conn.prepareStatement(updateSql)) {
                        ups.setInt(1, newQty);
                        ups.setInt(2, rs.getInt("id"));
                        return ups.executeUpdate() > 0;
                    }
                } else {
                    String insertSql = "INSERT INTO cart(user_id, book_id, quantity) VALUES(?,?,?)";
                    try (PreparedStatement ips = conn.prepareStatement(insertSql)) {
                        ips.setInt(1, userId);
                        ips.setInt(2, bookId);
                        ips.setInt(3, quantity);
                        return ips.executeUpdate() > 0;
                    }
                }
            }
        }
    }

    public List<CartItem> findByUser(int userId) throws SQLException {
        List<CartItem> list = new ArrayList<>();
        String sql = "SELECT c.*, b.title, b.author, b.price, b.cover FROM cart c JOIN book b ON c.book_id=b.id WHERE c.user_id=?";
        try (Connection conn = DBHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setId(rs.getInt("id"));
                    item.setUserId(rs.getInt("user_id"));
                    item.setBookId(rs.getInt("book_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    Book book = new Book();
                    book.setId(rs.getInt("book_id"));
                    book.setTitle(rs.getString("title"));
                    book.setAuthor(rs.getString("author"));
                    book.setPrice(rs.getDouble("price"));
                    book.setCover(rs.getString("cover"));
                    item.setBook(book);
                    list.add(item);
                }
            }
        }
        return list;
    }

    public boolean updateQuantity(int id, int quantity) throws SQLException {
        String sql = "UPDATE cart SET quantity=? WHERE id=?";
        try (Connection conn = DBHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean remove(int id) throws SQLException {
        String sql = "DELETE FROM cart WHERE id=?";
        try (Connection conn = DBHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean clear(int userId) throws SQLException {
        String sql = "DELETE FROM cart WHERE user_id=?";
        try (Connection conn = DBHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        }
    }
}
