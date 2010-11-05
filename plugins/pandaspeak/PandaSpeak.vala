using Posix;
using Gee;

public class PandaSpeak : PandaPlugin , GLib.Object {

	protected string SERVICE = "/pandaspeak";
	
	public signal void word_ok();	
	
	public void init() {
		Gee.List<string> args = new Gee.ArrayList<string>();
		args.add("String to play");
		register("play",args);
	}
	public string get_dashboard_html(string context){
		string content ="";
		try {
			FileUtils.get_contents(context + "/data/index.html", out content);	
		}catch (Error err){
			warning("Error: %s\n", err.message);
		}
		return content;
	}
    public string get_handler_path(){
        return SERVICE;
    }
    public string invoke(string cmd,Gee.List<string> args){
    	if(cmd=="play"){    		
			play(args[0]);
    		return "playing";
    	}
    	return "bad";
    }
    public void play(string url){
    	
    	if(url!=null){ 
			 string[] runme = { "/usr/bin/espeak", url };
			try  {
			if (!Process.spawn_sync (null, runme, null, SpawnFlags.STDERR_TO_DEV_NULL, null)) return;			
			} catch (SpawnError err) {
				warning("Error: %s\n", err.message);
			}	        	
		}
    }

}
public Type register_plugin (Module module) {
    return typeof (PandaSpeak);
}


