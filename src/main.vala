using GLib;

public class Panda: GLib.Object {
	
			
	public static int main (string[] args) {
		Gst.init (ref args);
		PandaServer server = new PandaServer(8088);
		server.run();
		new MainLoop ().run ();	
		return 0;
	}
	
	
}
