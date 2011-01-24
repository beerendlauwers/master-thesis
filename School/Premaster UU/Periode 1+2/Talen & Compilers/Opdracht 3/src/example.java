class Hello
{
    int g;

    void main()
    {
        int y;
        y = 2;
        y += 2;
        y -= 2;
        y = x*x;
        return y; 
    }
    
    // BOSNEGERS
       // dap
    
    int correct()
    {
        return (5 * 2) + 10;
    }
    
    int withoutQuotesPlus()
    {
        return 5 * 2 + 10; 
    }
    
    int modulus()
    {
        return 8 % 2 + 8;
    }
    
   /* boolean booleanTest()
    {
        return 0 && true || 1; 
    } *  /**/ */
    
    /*
    //boolean assignBoolean()
    //{
    //    boolean b; // fdgffvdgffg
    //    b = true;
    //    return 0 || b;
    //}*/
    
    boolean assignChar()
    {
        char c;
        //return 5;
        c = 'a';
        return c;
    }
    
    int withoutQuotesMinus()
    {
        return 5 * 2 + 10; 
    }
    
    int square( int x )
    {
        int y;
        y = x*x;
        return y;   
    }

    int abs(int x)
    {
        if (x<0)
            x = 0-x;
        return x;
    }
    
    int singleIncrement()
    {
        int t;
        t = t + 1;
    }
    
    int fac(int x)
    {
        int r; int t;
        t=1; r=1;
        while (t<=x)
        {
            r = r*t;
            t = t+1;
        }
        return r;
   }
}
