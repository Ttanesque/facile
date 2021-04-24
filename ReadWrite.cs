using System;

public class ReadWrite {
    static public void Main () {
        int a = Convert.ToInt32(Console.ReadLine());
        if (a > -1 || a < 1)
        {
            Console.WriteLine("Hello");
        } else
        {
            Console.WriteLine("World");
        }
    }
}