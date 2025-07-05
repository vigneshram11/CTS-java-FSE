import java.util.*;
class BookRepository {
    private List<String> books = new ArrayList<>();

    public void saveBook(String title) {
        books.add(title);
        System.out.println("Book saved: " + title);
    }

    public List<String> getAllBooks() {
        return books;
    }
}


class BookService {
    private BookRepository bookRepository;


    public BookService(BookRepository bookRepository) {
        this.bookRepository = bookRepository;
    }

    public void addBook(String title) {
        System.out.println("Adding book: " + title);
        bookRepository.saveBook(title);
    }

    public void listBooks() {
        List<String> books = bookRepository.getAllBooks();
        System.out.println("\nAll Books in Library:");
        for (String book : books) {
            System.out.println("- " + book);
        }
    }
}
public class Main {
    public static void main(String[] args) {

        BookRepository bookRepository = new BookRepository();
        BookService bookService = new BookService(bookRepository);
      
        bookService.addBook("The Great Gatsby");
        bookService.addBook("1984");
        bookService.addBook("To Kill a Mockingbird");
      
        bookService.listBooks();
    }
}
output

Adding book: The Great Gatsby
Book saved: The Great Gatsby
Adding book: 1984
Book saved: 1984
Adding book: To Kill a Mockingbird
Book saved: To Kill a Mockingbird

All Books in Library:
- The Great Gatsby
- 1984
- To Kill a Mockingbird
