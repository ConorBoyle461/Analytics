import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.DataInputStream;
import java.io.InputStreamReader;
import java.io.FileReader;
import kx.c;
import java.security.SecureRandom;
import java.util.logging.Logger;
import java.util.logging.Level;

//public class csvLoad {

 //   public static void main(String[] args)  {
  //    try { 
//	String path = "/home/conor/Analytics/config/testTrade.csv";
//	String line = "";
 //       BufferedReader br = new BufferedReader(new FileReader(path) );
  //      while((line = br.readLine()) != null) {
//	   System.out.println(line);	
//	  }
 //       } catch(Exception e) {
  //        e.getStackTrace();
   //    }
//   }
   
//    public static void printValue(String[] x)  {
//	System.out.println(x);
//   }
//}

public class Feed{
  private static final Logger LOGGER = Logger.getLogger(Feed.class.getName());
  private static final String QFUNC = ".u.upd";
  private static final String TABLENAME = "trade";

  /**
   * Example of 10 single row inserts to a table
   * @param kconn Connection that will be sent the inserts
   * @throws java.io.IOException when issue with KDB+ comms
   */

  static void rowInserts(c kconn) throws java.io.IOException{
    // Single row insert - not as efficient as bulk insert
    LOGGER.log(Level.INFO,"Populating 'trade' on kdb server with 10 rows...");
    String path = "/home/conor/Analytics/config/testJava.csv";
    String line = "";
      BufferedReader br = new BufferedReader(new FileReader(path) );
      while((line = br.readLine()) != null) {	 
        System.out.println(line);  
	Object[] data= line.split(",");
        c.Timespan[] time=new c.Timespan[]{new c.Timespan()};
        String[] sym=new String[]{(String )data[0]};
        Double[] price=new Double[]{Double.parseDouble((String) data[1])};
        Integer[] size=new Integer[]{Integer.parseInt((String) data[2])};
        Object[] tbl=new  Object[] {new c.Flip(new c.Dict(new String[]{"time","sym","price","size"},new Object[]{time,sym,price,size}))};
        //Object[] row={new c.Timespan(),"CONR.T",new Double(93.5),new Long(300)};
        //System.out.println(row);
        kconn.ks(QFUNC,TABLENAME,tbl);
    }
  }

  public static void main(String[] args){// example tick feed
    c c=null;
    try{
      c=new c("localhost",5000);
      rowInserts(c);
    }
    catch(Exception e){
      LOGGER.log(Level.SEVERE,e.toString());
    }finally{
      if(c!=null)
        try{c.close();}catch(java.io.IOException e){
          // ingnore exception
        }
    }
  }
}
