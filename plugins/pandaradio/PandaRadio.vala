using Soup;   
using Gst;

public class PandaRadio : PandaPlugin ,GLib.Object {

	private PandaPlayer player;

    public string get_handler_path(){
        return "/radio.json";
    }
    public void request_handler(Soup.Server server, Soup.Message msg, string path,
                      GLib.HashTable<string,string>? query, Soup.ClientContext? client){
			
		if(player==null) player = new PandaPlayer();		 	
		string response = msg.request_body.flatten().data;
	 	string company  = query.lookup("command");
 		if(company == "play") {
			string url = query.lookup("url");
			stdout.printf("%s\n",url);
		  if(url!=null){ 
			  player.open(url);
			  player.play();
		  }
 		}else {
 			  player.pause();
 		}
	 	msg.set_response ("text/html", Soup.MemoryUse.COPY,
                      response + company , response.size () + company.size());
        msg.set_status (Soup.KnownStatusCode.OK);
    
    }
}
public Type register_plugin (Module module) {
    return typeof (PandaRadio);
}


