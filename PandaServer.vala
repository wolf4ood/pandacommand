using Soup;
using Gst;
public class PandaServer : GLib.Object {

  private Soup.Server server;
  private PandaPlayer player;
  
  public PandaServer(int port){
    
    this.server = new Soup.Server(Soup.SERVER_PORT, port);
    this.server.add_handler ("/", default_handler);
    this.server.add_handler ("/command.json", command_handler);  
    this.player = new PandaPlayer();
      
  }
  
  public void run(){
    
    server.run();
  
  }
  protected void default_handler (Soup.Server server, Soup.Message msg, string path,
                      GLib.HashTable? query, Soup.ClientContext client)
  {
	string response_text = "";
    var file = File.new_for_path ("index.html");

    if (!file.query_exists (null)) {
        stderr.printf ("File '%s' doesn't exist.\n", file.get_path ());
        return ;
    }

    try {
        // Open file for reading and wrap returned FileInputStream into a
        // DataInputStream, so we can read line by line
        var in_stream = new DataInputStream (file.read (null));
        string line;
        // Read lines until end of file (null) is reached
       while ((line = in_stream.read_line (null, null)) != null) {
            response_text += line;
            //stdout.printf ("%s\n", line);
        }
    } catch (Error e) {
        error ("%s", e.message);
    }

    msg.set_response ("text/html", Soup.MemoryUse.COPY,
                      response_text, response_text.size ());
    msg.set_status (Soup.KnownStatusCode.OK);
  }
  protected void command_handler(Soup.Server server, Soup.Message msg, string path,
                      GLib.HashTable<string,string> query, Soup.ClientContext client){
	
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
