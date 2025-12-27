import java.rmi.*;
import java.io.*;

class Client 
{
	public static void main(String [] args)throws RemoteException
	{
		new Client(args[0]);
	}
	public Client(String host)
	{
		try
		{
			MyRemoteObjectInterface remobj =  (MyRemoteObjectInterface)Naming.lookup("rmi://"+host+"/RemotePower");
			System.out.println("Enter x and y in x^y : ");
			BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
			Long x = Long.parseLong(br.readLine());
			Long y = Long.parseLong(br.readLine());
			System.out.println(Long.toString(x)+"^"+Long.toString(y));
			System.out.println(Long.toString(remobj.getPower(x,y)));
		}
		catch(Exception e){}
	}
}