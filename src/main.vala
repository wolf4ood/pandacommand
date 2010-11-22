using GLib;

public class Panda: GLib.Object {
	
			
	public static int main (string[] args) {
		Gst.init (ref args);
		PandaChannelManager manager = new PandaChannelManager();
		manager.startup();
		new MainLoop ().run ();	
		return 0;
	}
	
	
}
