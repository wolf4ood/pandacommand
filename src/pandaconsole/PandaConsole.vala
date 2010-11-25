using Gee;
using Soup;
public class PandaConsole : PandaPlugin , GLib.Object  {

	protected string SERVICE = "pandaconsole";
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
    public string invoke_rpc(string json){
        return "ok";
    }
    public string invoke(string cmd,Gee.List<string> args){
    	if(cmd=="parse"){    		
			return parse_args(args[0]);
    		
    	}
    	return "command bad";
    }
    public string parse(string command){
    	return manager.invoke(command);
    }
    public string parse_args(string command){
        if(command!=null){

            string[] args = command.split(" ");
            string plug = args[0];
            Gee.List<string> list = new Gee.ArrayList<string>();

            foreach(string s in args) {
                if(plug!=s) list.add(s);
            }
            string cmd = list.remove_at(0);
            return manager.invoke_cmd(plug,cmd,list);
        }
            return "missing params";
    }
}
public Type register_plugin (Module module) {
    return typeof (PandaConsole);
}


