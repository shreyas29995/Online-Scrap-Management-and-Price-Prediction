import java.io.IOException;
import java.net.*;

public class TestServer {
	public static void main(String[] args) {
		try {
			ServerSocket ss = new ServerSocket(Integer.parseInt(args[0]));
			System.out.println("Server Started "+args[0]);
			while (true) {
				Socket client = ss.accept();
				System.out.println(client.getInetAddress().getHostAddress()
						+ " Incoming Request ");
				client.close();
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
}
