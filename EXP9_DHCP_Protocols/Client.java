import java.util.*;
import java.net.*;

class Client
{
	public static final int SERVER_PORT = 4900;
	public static final String SERVER_IP = "127.0.0.1";
	
	public static void main(String [] args)
	{
		try
		{
			DatagramSocket socket = new DatagramSocket();
			InetAddress serverAddress = InetAddress.getByName(SERVER_IP);
			
			byte[] requestData = createDHCPRequest("18-66-DA-99-FE-05");
			DatagramPacket requestPacket = new DatagramPacket(requestData,requestData.length,serverAddress,SERVER_PORT);
			socket.send(requestPacket);
			System.out.println("Sent DHCP Request...");
			
			byte[] receiveData = new byte[1024];
			DatagramPacket receivePacket = new DatagramPacket(receiveData,receiveData.length);
			socket.receive(receivePacket);
			
			String response = new String(receivePacket.getData()).trim();
			System.out.println("Received DHCP Response : "+response);
			
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	
	
	private static byte[] createDHCPRequest(String macAddress)
	{
		String request = "DHCP Request with mac "+macAddress;
		return request.getBytes();
	}
}