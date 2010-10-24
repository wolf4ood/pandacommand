

public class PandaGuess : PandaPlugin , GLib.Object  {
	
	 protected string SERVICE = "/guess";
	 
	 public void request_handler(Soup.Server server, Soup.Message msg, string path,
                      GLib.HashTable<string,string>? query, Soup.ClientContext? client){
                      	
     }
     public string get_handler_path(){
        return SERVICE;
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
}









public Type register_plugin (Module module) {
    return typeof (PandaGuess);
}

