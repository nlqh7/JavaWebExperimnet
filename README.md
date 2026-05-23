# 网上书店

JSP/Servlet/JavaBean/JDBC 网上书店实验项目，基于 Tomcat + MySQL。

## 功能

- 用户注册/登录
- 图书分类浏览、详情查看
- 购物车（添加、修改数量、删除）
- 订单结算（事务扣库存）
- 订单列表查看
- 后台管理（图书增删改查、搜索、排序）

## 技术栈

- Java, JSP, Servlet, JavaBean, JDBC
- Tomcat, MySQL
- 前端：HTML/CSS/JS（原生）

## 快速开始

1. 用 IntelliJ IDEA 打开项目
2. 把 `src/jdbc.properties.template` 复制为 `src/jdbc.properties`，填入你的 MySQL 连接信息
3. 执行 `database.sql` 创建数据库和表
4. 配置 Tomcat 运行

## 项目结构

```
src/
├── bean/          — JavaBean（Book, User, Order, CartItem 等）
├── dao/           — 数据访问层（BookDAO, UserDAO, OrderDAO 等）
└── servlet/       — Servlet 控制器
web/
├── WEB-INF/       — web.xml, lib/
├── css/, js/, images/  — 静态资源
└── *.jsp          — 页面
```
