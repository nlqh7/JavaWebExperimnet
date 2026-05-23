-- ============================================
-- 网上书店数据库初始化脚本
-- 使用方法: mysql -u root -p < database.sql
-- ============================================

CREATE DATABASE IF NOT EXISTS bookstore DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bookstore;

-- 图书分类表
CREATE TABLE IF NOT EXISTS category (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 图书表
CREATE TABLE IF NOT EXISTS book (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100),
    price DECIMAL(10,2),
    description TEXT,
    cover VARCHAR(255),
    category_id INT,
    stock INT DEFAULT 0,
    FOREIGN KEY (category_id) REFERENCES category(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 用户表
CREATE TABLE IF NOT EXISTS user (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    role VARCHAR(20) DEFAULT 'user'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 购物车表
CREATE TABLE IF NOT EXISTS cart (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    book_id INT,
    quantity INT DEFAULT 1,
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (book_id) REFERENCES book(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 订单主表
CREATE TABLE IF NOT EXISTS orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_no VARCHAR(50) UNIQUE NOT NULL,
    user_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    receiver_name VARCHAR(50) NOT NULL,
    receiver_phone VARCHAR(20) NOT NULL,
    receiver_address VARCHAR(255) NOT NULL,
    status VARCHAR(20) DEFAULT '待发货',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 订单明细表
CREATE TABLE IF NOT EXISTS order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    book_id INT,
    book_title VARCHAR(200) NOT NULL,
    book_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES book(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 初始数据
-- ============================================

-- 分类数据
INSERT INTO category (name) VALUES
('计算机科学'),
('文学小说'),
('经济管理'),
('历史哲学'),
('自然科学'),
('外语学习');

-- 图书数据
INSERT INTO book (title, author, price, description, cover, category_id, stock) VALUES

-- 计算机科学 (category_id=1)
('Java编程思想', 'Bruce Eckel', 108.00, '本书赢得了全球程序员的广泛赞誉，从Java的基础语法到最高级特性，本书都能逐步指导你轻松掌握。', '', 1, 50),
('Spring实战', 'Craig Walls', 89.00, '本书全面介绍了Spring框架的核心特性，包括依赖注入、面向切面编程、Spring MVC等核心内容。', '', 1, 30),
('深入理解Java虚拟机', '周志明', 79.00, '详细讲解了JVM的内存管理、类加载机制、编译优化等内容，是Java开发者的进阶必读之作。', '', 1, 40),
('数据结构与算法分析', 'Mark Allen Weiss', 75.00, '本书是数据结构和算法分析的经典教材，使用Java语言描述，内容深入浅出。', '', 1, 35),
('算法导论', 'Thomas H. Cormen', 128.00, '影响全球千万程序员的算法经典巨著，MIT四大教材之一。', '', 1, 25),
('设计模式：可复用面向对象软件的基础', 'Erich Gamma', 59.00, 'GOF经典之作，23种设计模式的权威参考，软件工程师必读。', '', 1, 40),
('重构：改善既有代码的设计', 'Martin Fowler', 69.00, '不朽经典，教你如何在不改变外在行为的前提下优化代码内部结构。', '', 1, 35),
('代码整洁之道', 'Robert C. Martin', 66.00, 'Clean Code中文版，教你写出可读、可维护的优雅代码。', '', 1, 45),
('计算机网络：自顶向下方法', 'James Kurose', 89.00, '以自顶向下的方式讲解计算机网络的原理与协议，生动易懂。', '', 1, 30),
('深入理解计算机系统', 'Randal E. Bryant', 139.00, 'CSAPP，从程序员视角深入剖析计算机系统的工作原理。', '', 1, 20),

-- 文学小说 (category_id=2)
('活着', '余华', 45.00, '讲述了在大时代背景下，随着内战、三反五反、大跃进、文化大革命等社会变革，徐福贵的人生和家庭不断经受苦难的故事。', '', 2, 100),
('百年孤独', '加西亚·马尔克斯', 55.00, '魔幻现实主义文学的代表作，描写了布恩迪亚家族七代人的传奇故事，以及加勒比海沿岸小镇马孔多的百年兴衰。', '', 2, 80),
('红楼梦', '曹雪芹', 58.00, '中国古典四大名著之首，以贾宝玉、林黛玉、薛宝钗的爱情婚姻悲剧为主线，描绘了一个封建大家族的兴衰。', '', 2, 120),
('三体', '刘慈欣', 93.00, '中国科幻文学的里程碑之作，讲述了地球人类文明和三体文明的信息交流与生死搏杀。', '', 2, 90),
('围城', '钱钟书', 36.00, '中国现代文学的经典之作，深刻描绘了知识分子的精神困境。', '', 2, 85),
('平凡的世界', '路遥', 79.00, '茅盾文学奖获奖作品，全景式展现中国当代城乡社会生活的长篇小说。', '', 2, 70),
('1984', 'George Orwell', 39.00, '反乌托邦文学经典，对极权主义的深刻警示与反思。', '', 2, 95),
('小王子', 'Antoine de Saint-Exupéry', 32.00, '全球发行量仅次于圣经的经典作品，以童话形式探讨爱与责任。', '', 2, 110),
('挪威的森林', '村上春树', 42.00, '日本当代文学的经典，关于青春、爱情与成长的永恒故事。', '', 2, 75),

-- 经济管理 (category_id=3)
('经济学原理', '曼昆', 88.00, '世界上最流行的经济学入门教材，用通俗易懂的语言和丰富的案例解释经济学核心概念。', '', 3, 60),
('国富论', 'Adam Smith', 68.00, '现代经济学奠基之作，全面阐述了自由市场经济的理论基础。', '', 3, 50),
('穷查理宝典', 'Peter D. Kaufman', 98.00, '收录查理·芒格的智慧箴言，关于投资、决策与人生哲学的必读之作。', '', 3, 40),
('卓有成效的管理者', 'Peter Drucker', 45.00, '现代管理学之父的经典著作，定义了什么是真正的管理。', '', 3, 55),
('从0到1', 'Peter Thiel', 49.00, 'PayPal创始人关于创新与创业的独到见解，颠覆你的商业思维。', '', 3, 65),
('思考，快与慢', 'Daniel Kahneman', 79.00, '诺贝尔经济学奖得主的行为经济学经典，揭示人类决策的奥秘。', '', 3, 45),
('创新者的窘境', 'Clayton M. Christensen', 59.00, '颠覆式创新理论的奠基之作，解释了为何大公司会失败。', '', 3, 50),
('影响力', 'Robert Cialdini', 55.00, '社会心理学经典，揭示说服与影响力的六大原理。', '', 3, 70),
('黑天鹅', 'Nassim Nicholas Taleb', 65.00, '重新定义你对不确定性的认知，理解极端事件如何塑造世界。', '', 3, 35),

-- 历史哲学 (category_id=4)
('人类简史', '尤瓦尔·赫拉利', 68.00, '从十万年前有生命迹象开始到21世纪资本、科技交织的人类发展史，理清影响人类发展的重大脉络。', '', 4, 70),
('苏菲的世界', 'Jostein Gaarder', 49.00, '以小说的形式讲述西方哲学史，全球最畅销的哲学入门书。', '', 4, 80),
('中国哲学简史', '冯友兰', 45.00, '系统梳理中国哲学两千多年的发展历程，权威性与可读性并重。', '', 4, 55),
('万历十五年', '黄仁宇', 38.00, '以1587年为横截面，揭示大明帝国走向衰落的深层历史逻辑。', '', 4, 90),
('全球通史', 'Stavrianos', 88.00, '从全球视角审视人类历史，跳出欧洲中心论的经典之作。', '', 4, 40),
('枪炮、病菌与钢铁', 'Jared Diamond', 75.00, '普利策奖获奖作品，探讨人类社会发展不平等的根本原因。', '', 4, 45),
('未来简史', '尤瓦尔·赫拉利', 68.00, '展望人类未来，探讨算法与数据将如何改变人类社会。', '', 4, 65),
('叫魂', '孔飞力', 42.00, '通过乾隆年间的一次妖术恐慌，剖解中国帝制晚期的社会结构。', '', 4, 50),

-- 自然科学 (category_id=5)
('时间简史', '史蒂芬·霍金', 45.00, '讲述关于宇宙的起源、空间和时间以及相对论等古老问题的探索，是探索时间和空间核心秘密的引人入胜的故事。', '', 5, 55),
('物种起源', 'Charles Darwin', 49.00, '进化论的开山之作，彻底改变了人类对生命世界的理解。', '', 5, 45),
('上帝掷骰子吗', '曹天元', 42.00, '中国最畅销的量子力学科普书，用生动的故事讲述量子物理发展史。', '', 5, 80),
('从一到无穷大', 'George Gamow', 38.00, '科学写作的经典之作，横跨数理化生天各领域。', '', 5, 60),
('费曼物理学讲义', 'Richard Feynman', 158.00, '诺贝尔奖得主费曼的经典物理学教材，以独特的视角讲述物理之美。', '', 5, 20),
('自私的基因', 'Richard Dawkins', 49.00, '以基因的视角重新审视进化论，改变了我们对生命的理解。', '', 5, 65),
('七堂极简物理课', 'Carlo Rovelli', 35.00, '用诗意语言在不到100页的篇幅里勾勒出20世纪物理学的革命。', '', 5, 75),
('宇宙的琴弦', 'Brian Greene', 55.00, '弦理论科普经典，带你探索宇宙最深层的结构。', '', 5, 40),
('古今数学思想', 'Morris Kline', 99.00, '全面介绍从古到今数学思想发展的权威著作。', '', 5, 30),

-- 外语学习 (category_id=6)
('新概念英语2', 'L.G. Alexander', 39.00, '风靡全球的英语学习经典教材，构建扎实的语法与词汇基础。', '', 6, 100),
('新概念英语3', 'L.G. Alexander', 42.00, '培养英语语感与写作能力，适合中级学习者进阶。', '', 6, 90),
('牛津高阶英汉双解词典', 'Oxford University Press', 169.00, '全球英语学习者最信赖的词典，收词全面、释义精准。', '', 6, 25),
('英语语法新思维', '张满胜', 59.00, '彻底颠覆传统语法教学的思维模式，让你真正理解英语语法。', '', 6, 60),
('GRE词汇精选', '俞敏洪', 58.00, '新东方经典词汇书，词根+联想记忆法，GRE备考必备。', '', 6, 70),
('大家的日语', 'スリーエーネットワーク', 49.00, '最受欢迎的日语入门教材，适合零基础学习者。', '', 6, 55),
('TOEFL核心词汇', '王玉梅', 42.00, '托福考试词汇宝典，科学划分高频词汇与低频词汇。', '', 6, 65),
('走遍美国', 'James Kelty', 55.00, '经典美式英语听说教材，通过情景剧学习地道英语表达。', '', 6, 50);

-- 管理员账户 (密码: admin123)
INSERT INTO user (username, password, email, role) VALUES
('admin', 'admin123', 'admin@bookstore.com', 'admin'),
('user1', '123456', 'user1@example.com', 'user');
