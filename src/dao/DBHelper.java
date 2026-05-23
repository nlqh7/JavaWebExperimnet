package dao;

import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.util.Properties;

public class DBHelper {
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    private static String url;
    private static String user;
    private static String password;

    static {
        try {
            Class.forName(DRIVER);
            Properties props = new Properties();
            try (InputStream in = DBHelper.class.getClassLoader().getResourceAsStream("jdbc.properties")) {
                if (in == null) {
                    throw new RuntimeException("jdbc.properties 未找到，请将 src/jdbc.properties.template 复制为 jdbc.properties 并填入数据库连接信息");
                }
                props.load(in);
            }
            url = props.getProperty("db.url");
            user = props.getProperty("db.user");
            password = props.getProperty("db.password");
            if (url == null || user == null || password == null) {
                throw new RuntimeException("jdbc.properties 中缺少 db.url, db.user 或 db.password");
            }
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL驱动未找到，请将 mysql-connector-java.jar 放入 WEB-INF/lib/", e);
        } catch (IOException e) {
            throw new RuntimeException("读取 jdbc.properties 失败", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        try {
            return DriverManager.getConnection(url, user, password);
        } catch (SQLException e) {
            System.err.println("数据库连接失败: " + e.getMessage());
            throw e;
        }
    }
}
