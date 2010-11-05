using Gee;
using Soup;
public class PandaConsole : PandaPlugin , GLib.Object {

	protected string SERVICE = "/pandaconsole";
	public signal void word_ok();	
	
	public void init() {
		Gee.List<string> args = new Gee.ArrayList<string>();
		args.add("String to play");
		register("parse",args);
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
    	if(cmd=="parse"){    		
			parse(args[0]);
    		return "command ok";
    	}
    	return "command bad";
    }
    public void parse(string command){
    	
    	if(command!=null){ 
			var session = new Soup.SessionAsync ();
			string[] args = command.split(" ");
			var message = new Soup.Message ("GET", "http://localhost:8088" + args[0]);
			session.send_message (message);
    		stdout.printf("ciccio\n");
    		/*  message.response_headers.foreach ((name, val) => {
        	  stdout.printf ("Name: %s -> Value: %s\n", name, val);
        	});*/
    		//stdout.printf ("Message length: %lld\n%s\n",message.response_body.length,message.response_body.data);
		
		}
    }

}
public Type register_plugin (Module module) {
    return typeof (PandaConsole);
}


