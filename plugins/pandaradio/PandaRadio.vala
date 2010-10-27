using Soup;   
using Gst;
using Gee;

public class PandaRadio : PandaPlugin , GLib.Object {

	protected string SERVICE = "/radio";
	private PandaPlayer player;

	public void init(){
 	 
 	}
	public signal void radio_on();	
	public signal void radio_off();
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
    public void play(string url){
    	if(url!=null){ 
			player.open(url);
			player.play();
			radio_on();
		}
    }
    public void stop(){
    	
    }
    public void request_handler(Soup.Server server, Soup.Message msg, string path,
                      GLib.HashTable<string,string>? query, Soup.ClientContext? client){
						 	
		string response ="";
		string company = "";
		if(query!=null){
			if(player==null) player = new PandaPlayer();
			response = msg.request_body.flatten().data;
		 	company  = query.lookup("command");
	 		if(company == "play") {
				string url = query.lookup("url");
				stdout.printf("%s\n",url);
			  	play(url);
	 		}else {
	 			  player.pause();
	 			  radio_off();
	 		}
 		}else {
 			response = get_dashboard_html("/home/maggiolo00/Vala/pandacommand/plugins/pandaradio");
 		}
	 	msg.set_response ("text/html", Soup.MemoryUse.COPY,
                      response + company , response.size () + company.size());
        msg.set_status (Soup.KnownStatusCode.OK);
    
    }
}
public Type register_plugin (Module module) {
    return typeof (PandaRadio);
}


