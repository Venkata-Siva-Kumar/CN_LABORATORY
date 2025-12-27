import java.io.*;
import java.util.*;
import java.net.*;

class Server
{
	public static final int SERVER_PORT = 4900;
	public static final String SERVER_IP = "127.0.0.1";
	public static final String IP_ALLOCATIONS_FILE = "ip_allocations.txt";
	
	public static List<String> availableIpAddresses = new ArrayList<>();
	public static Map<String,String> ipAllocations = new HashMap<>();
	
	public static void main(String [] args)
	{
		loadIpAllocations();
		initializeIpAddresses();
		
		try
		{
			DatagramSocket socket = new DatagramSocket(SERVER_PORT);
			while(true)
			{
				byte[] receivedData = new byte[1024];
				DatagramPacket receivePacket = new DatagramPacket(receivedData,receivedData.length);
				socket.receive(receivePacket);
				System.out.println("Reci");
				InetAddress clientAddress = receivePacket.getAddress();
				String macAddress = extractMacAddress(receivedData);
				String allocatedIp = allocateIpAddress(macAddress);
				
				byte[] responseData = createDHCPResponse(macAddress,allocatedIp);
				DatagramPacket responsePacket = new DatagramPacket(responseData,responseData.length,clientAddress,receivePacket.getPort());
				socket.send(responsePacket);
				System.out.println("Allocated IP : "+allocatedIp+" to client with MAC : "+macAddress);
				saveIpAllocations();
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		
	}
	
	public static void saveIpAllocations()
	{
		try(ObjectOutputStream os = new ObjectOutputStream(new FileOutputStream(IP_ALLOCATIONS_FILE)))
		{
			os.writeObject(ipAllocations);
			System.out.println("Saved IP allocations to "+IP_ALLOCATIONS_FILE);
		}
		catch(IOException e)
		{
			e.printStackTrace();
		}
	}
	
	private static String allocateIpAddress(String macAddress) 
	{
        if (availableIpAddresses.isEmpty()) 
		{
            return "No available IP addresses";
        }

        Random random = new Random();
        int index = random.nextInt(availableIpAddresses.size());
        String allocatedIp = availableIpAddresses.remove(index);
        
        ipAllocations.put(macAddress, allocatedIp);
        return allocatedIp;
    }

	private static byte[] createDHCPResponse(String macAddress , String allocatedIp)
	{
		return ("Allocated IP "+allocatedIp).getBytes();
	}
	
	private static String extractMacAddress(byte [] data)
	{
		return "18-66-DA-99-FE-05";
	}
	
	
	
	private static void initializeIpAddresses()
	{
		for(int i=2;i<254;i++)
		{
			availableIpAddresses.add("192.168.1."+i);
		}
	}
	
	private static void loadIpAllocations()
	{
		try(ObjectInputStream in = new ObjectInputStream(new FileInputStream(IP_ALLOCATIONS_FILE)))
		{
			ipAllocations = (HashMap<String,String>)in.readObject();
			System.out.println("Loaded Ip allocations from "+IP_ALLOCATIONS_FILE);
		}
		catch(FileNotFoundException e)
		{
			System.out.println(IP_ALLOCATIONS_FILE+"not found. Starting with a new ip_allocations map");
		}
		catch(IOException | ClassNotFoundException e)
		{
			e.printStackTrace();
		}
	
	}
}