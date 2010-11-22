using Gee;
using Soup;
public class PandaConsole : PandaPlugin , GLib.Object  {

	protected string SERVICE = "/pandaconsole";
	protected PandaPluginManager manager;
	public signal void word_ok();	
    
    public PandaConsole(PandaPluginManager manager){
        this.manager = manager;
    }
	public void init() {
		Gee.List<string> args = new Gee.ArrayList<string>();
		args.add("String to play");
		register("parse",args);
	}
	public string get_dashboard_html(string context){
		string content ="";
		try {
			FileUtils.get_contents("data/pandaconsole/index.html", out content);	
		}catch (Error err){
			warning("Error: %s\n", err.message);
		}
		return content;
	}
    public string get_handler_path(){
        return SERVICE;
    }
    public string invoke_command(string cmd, ...){
        return "ok";
    }
    public string invoke(string cmd,Gee.List<string> args){
    	if(cmd=="parse"){    		
			return parse(args[0]);
    		
    	}
    	return "command bad";
    }
    public string parse(string command){
    	return manager.invoke(command);
    }

}
public Type register_plugin (Module module) {
    return typeof (PandaConsole);
}


