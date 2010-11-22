using Soup;   
using Gst;
using Gee;

public class PandaRadio : PandaPlugin , GLib.Object {

	protected string SERVICE = "/pandaradio";
	private PandaPlayer player;
	
	public signal void radio_on();	
	public signal void radio_off();
	public signal void radio_pause();
	
	public void init() {
		Gee.List<string> args = new Gee.ArrayList<string>();
		args.add("Url of the stream");
		register("play",args);
		register("pause",null);
		register("stop",null);
		player = new PandaPlayer();
	}
	public string invoke_command(string cmd, ...){
        return "ok";
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
			stdout.printf("%s\n",args[0]);    		
			play(args[0]);
    		return "playing";
    	}
    	if(cmd=="pause"){
    		pause();
    		return "paused";
    	}
    	if(cmd=="stop"){
    		stop();
    		return "stopped";
    	}
    	return "bad";
    }
    public void play(string url){
    	
    	if(url!=null){ 
			player.open(url);
			player.play();
			radio_on();
		}
    }
    public void pause(){
    	player.pause();
	 	radio_pause();
    }
    public void stop(){
    	player.stop();
	 	radio_off();
    }
}
public Type register_plugin (Module module) {
	return typeof (PandaRadio);
}


