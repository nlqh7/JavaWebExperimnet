package bean;

public class OrderItem {
    private int id;
    private int orderId;
    private int bookId;
    private String bookTitle;
    private double bookPrice;
    private int quantity;

    public OrderItem() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }
    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }
    public double getBookPrice() { return bookPrice; }
    public void setBookPrice(double bookPrice) { this.bookPrice = bookPrice; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}
