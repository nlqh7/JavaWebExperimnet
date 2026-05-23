package dao;

import bean.CartItem;
import bean.Order;
import bean.OrderItem;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class OrderDAO {

    public void create(Order order, List<CartItem> cartItems) throws SQLException {
        Connection conn = DBHelper.getConnection();
        conn.setAutoCommit(false);
        try {
            // 计算总金额
            double total = 0;
            for (CartItem item : cartItems) {
                total += item.getBook().getPrice() * item.getQuantity();
            }
            order.setTotalAmount(total);

            // 生成订单号
            String orderNo = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())
                    + "_" + order.getUserId();
            order.setOrderNo(orderNo);

            // 插入订单头
            String orderSql = "INSERT INTO orders(order_no, user_id, total_amount, receiver_name, receiver_phone, receiver_address) VALUES(?,?,?,?,?,?)";
            try (PreparedStatement ps = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, orderNo);
                ps.setInt(2, order.getUserId());
                ps.setDouble(3, total);
                ps.setString(4, order.getReceiverName());
                ps.setString(5, order.getReceiverPhone());
                ps.setString(6, order.getReceiverAddress());
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        order.setId(rs.getInt(1));
                    }
                }
            }

            // 插入订单明细 + 扣库存
            String itemSql = "INSERT INTO order_items(order_id, book_id, book_title, book_price, quantity) VALUES(?,?,?,?,?)";
            String stockSql = "UPDATE book SET stock = stock - ? WHERE id = ? AND stock >= ?";
            try (PreparedStatement itemPs = conn.prepareStatement(itemSql);
                 PreparedStatement stockPs = conn.prepareStatement(stockSql)) {
                for (CartItem item : cartItems) {
                    itemPs.setInt(1, order.getId());
                    itemPs.setInt(2, item.getBookId());
                    itemPs.setString(3, item.getBook().getTitle());
                    itemPs.setDouble(4, item.getBook().getPrice());
                    itemPs.setInt(5, item.getQuantity());
                    itemPs.addBatch();

                    stockPs.setInt(1, item.getQuantity());
                    stockPs.setInt(2, item.getBookId());
                    stockPs.setInt(3, item.getQuantity());
                    stockPs.addBatch();
                }
                itemPs.executeBatch();
                int[] stockResults = stockPs.executeBatch();
                for (int i = 0; i < stockResults.length; i++) {
                    if (stockResults[i] == 0) {
                        throw new SQLException("《" + cartItems.get(i).getBook().getTitle() + "》库存不足");
                    }
                }
            }

            // 清空购物车
            String clearSql = "DELETE FROM cart WHERE user_id=?";
            try (PreparedStatement ps = conn.prepareStatement(clearSql)) {
                ps.setInt(1, order.getUserId());
                ps.executeUpdate();
            }

            conn.commit();
        } catch (SQLException e) {
            conn.rollback();
            throw e;
        } finally {
            conn.setAutoCommit(true);
            conn.close();
        }
    }

    public List<Order> findByUser(int userId) throws SQLException {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id=? ORDER BY created_at DESC";
        try (Connection conn = DBHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setId(rs.getInt("id"));
                    order.setOrderNo(rs.getString("order_no"));
                    order.setUserId(rs.getInt("user_id"));
                    order.setTotalAmount(rs.getDouble("total_amount"));
                    order.setReceiverName(rs.getString("receiver_name"));
                    order.setReceiverPhone(rs.getString("receiver_phone"));
                    order.setReceiverAddress(rs.getString("receiver_address"));
                    order.setStatus(rs.getString("status"));
                    order.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(order);
                }
            }
        }
        return list;
    }

    public Order findById(int orderId) throws SQLException {
        Order order = null;
        String orderSql = "SELECT * FROM orders WHERE id=?";
        try (Connection conn = DBHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(orderSql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    order = new Order();
                    order.setId(rs.getInt("id"));
                    order.setOrderNo(rs.getString("order_no"));
                    order.setUserId(rs.getInt("user_id"));
                    order.setTotalAmount(rs.getDouble("total_amount"));
                    order.setReceiverName(rs.getString("receiver_name"));
                    order.setReceiverPhone(rs.getString("receiver_phone"));
                    order.setReceiverAddress(rs.getString("receiver_address"));
                    order.setStatus(rs.getString("status"));
                    order.setCreatedAt(rs.getTimestamp("created_at"));
                }
            }
            if (order != null) {
                List<OrderItem> items = new ArrayList<>();
                String itemSql = "SELECT * FROM order_items WHERE order_id=?";
                try (PreparedStatement ps2 = conn.prepareStatement(itemSql)) {
                    ps2.setInt(1, orderId);
                    try (ResultSet rs2 = ps2.executeQuery()) {
                        while (rs2.next()) {
                            OrderItem item = new OrderItem();
                            item.setId(rs2.getInt("id"));
                            item.setOrderId(rs2.getInt("order_id"));
                            item.setBookId(rs2.getInt("book_id"));
                            item.setBookTitle(rs2.getString("book_title"));
                            item.setBookPrice(rs2.getDouble("book_price"));
                            item.setQuantity(rs2.getInt("quantity"));
                            items.add(item);
                        }
                    }
                }
                order.setItems(items);
            }
        }
        return order;
    }
}
