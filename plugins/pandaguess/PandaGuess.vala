using Gee;


public class PandaGuess : PandaPlugin , GLib.Object  {
	
	 protected string SERVICE = "/guess";
 	
 	 public void init(){
 	 	register("/radio",guess_what);
 	 }
	 public void request_handler(Soup.Server server, Soup.Message msg, string path,
                      GLib.HashTable<string,string>? query, Soup.ClientContext? client){
     		
     	string response ="";
     	if(query!=null){
     		
     	}else {
     		response = get_dashboard_html("/home/maggiolo00/Vala/pandacommand/plugins/pandaguess");
     	}	
     }
     public string get_handler_path(){
        return SERVICE;
    }
    public void guess_what(){
    
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

