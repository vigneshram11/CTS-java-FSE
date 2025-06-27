Exercise 1: Setting Up JUnit

import org.junit.Test;
import static org.junit.Assert.*;
public class SetupJUnitTest {
    @Test
    public void testAddition() {
        int result = 2 + 1;
        assertEquals(3, result);  
    }
}
Exercise 3: Assertions in JUnit
import org.junit.Test;
import static org.junit.Assert.*;
public class AssertionsTest {
    @Test
    public void testAssertions() {
               assertEquals(3, 2 + 1);
 assertTrue(3 > 1);
        assertFalse(3< 1);
        assertNull(null);
        assertNotNull(new Object());
    }
}


Exercise 4: AAA Pattern, Setup and Teardown in JUnit
import org.junit.*;
import static org.junit.Assert.*;
public class AAAPatternTest {
    private int a;
    private int b;
    @Before
    public void setUp() {
        a = 10;
        b = 5;
        System.out.println("Setup done");
    }
    @After
    public void tearDown() {
        System.out.println("Teardown done");
    }
    @Test
    public void testSubtraction_AAA() {
        int result = a - b;
         assertEquals(5, result);    }
}
