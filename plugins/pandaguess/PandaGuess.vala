using Gee;


public class PandaGuess : PandaPlugin , GLib.Object  {
	
	 protected string SERVICE = "/pandaguess";
 		
     public string get_handler_path(){
        return SERVICE;
    }
    public string invoke(string cmd,Gee.List<string> args){
    	return "Ok";
    }
    public void init() {
		Gee.List<string> args = new Gee.ArrayList<string>();
		args.add("Url of the stream");
		register("guess_what",args);
	}
    public void guess_what(string guess){
    
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
	public void on_radio_on(){
		warning("Grande: connesso\n" );
	}
}

public Type register_plugin (Module module) {
    return typeof (PandaGuess);
}

