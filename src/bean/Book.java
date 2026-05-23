package bean;

public class Book {
    private int id;
    private String title;
    private String author;
    private double price;
    private String description;
    private String cover;
    private int categoryId;
    private String categoryName;
    private int stock;

    public Book() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getCover() { return cover; }
    public void setCover(String cover) { this.cover = cover; }
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }
}
