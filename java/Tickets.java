
class TicketMaker
{
    private static TicketMaker tm = new TicketMaker();
    private static int ticket = 1000;

    private TicketMaker() 
    {
    }

    public synchronized int getNextTicketNumber()
    {
        return ticket++;
    }

    public static TicketMaker getInstance()
    {
        return tm;
    }
}


public class Tickets
{
    public static void main(String[] args)
    {
        TicketMaker tm1 = TicketMaker.getInstance();
        TicketMaker tm2 = TicketMaker.getInstance();

        for (int i = 0; i < 10; i++) {
            System.out.println(tm1.getNextTicketNumber());
            System.out.println(tm2.getNextTicketNumber());
        }
    }
}

