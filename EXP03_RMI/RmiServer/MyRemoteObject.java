import java.rmi.*;
import java.rmi.server.UnicastRemoteObject;
import java.net.*;
public class MyRemoteObject extends UnicastRemoteObject implements MyRemoteObjectInterface
{
	public MyRemoteObject() throws RemoteException{}
	public long getPower(long num,long pow) throws RemoteException
	{
		return (long) Math.pow(num,pow);
	}
	public static void main(String [] args)throws RemoteException
	{
		try
		{
			System.out.println("ip="+InetAddress.getLocalHost().getHostAddress());
			MyRemoteObjectInterface rem = new MyRemoteObject();
			Naming.rebind("Remote Power : ",rem);
		}
		catch(Exception e){}
	}
}