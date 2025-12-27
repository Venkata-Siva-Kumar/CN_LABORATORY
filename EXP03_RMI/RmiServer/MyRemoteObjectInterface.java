import java.rmi.*;

public interface MyRemoteObjectInterface extends Remote
{
	public long getPower(long num,long pow) throws RemoteException;
}