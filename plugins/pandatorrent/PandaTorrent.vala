using Soup;   
using Json;
public class PandaTorrent : PandaPlugin ,GLib.Object {

	protected Transmission  transmission ;
	
    public string get_handler_path(){
        return "/torrent.json";
    }
    public void request_handler(Soup.Server server, Soup.Message msg, string path,
                      GLib.HashTable<string,string>? query, Soup.ClientContext? client){
			
			if(transmission==null) transmission  = new Transmission("192.168.0.2", 9091, null, null);
			string response = transmission.request_list();
			msg.set_response ("text/html", Soup.MemoryUse.COPY,
                      response , response.size ());
        	msg.set_status (Soup.KnownStatusCode.OK);
    }
}
public Type register_plugin (Module module) {
    return typeof (PandaTorrent);
}

public class Transmission {
   
   private SessionAsync session;
   private string user;
   private string password;
   private string path;
   private string sessionid;
   private static string[] std_fields = { "id","name","percentDone","rateDownload","rateUpload","sizeWhenDone"};

   public Transmission(string host, int port, string? user, string? password) {
      if(user != null && password != null) {
         this.user = user; this.password = password;
      }
      path = @"http://$host:$port/transmission/rpc";
      session = new SessionAsync();
      //In case you setup Transmission with authentication this sets a callback for handling it
      session.authenticate.connect(auth);

      //Newer Transmission versions require a sessionid to be carried with each request. Get one!
      var msg = new Message("GET", path);
      session.send_message(msg);
      sessionid = msg.response_headers.get("X-Transmission-Session-Id");
      if(sessionid == null)
         error("Transmission version to old or not configured on that port");

   }
   public string request_list() {
      size_t length;
      string json;

      var msg = new Message("POST", path);
      //Start a Generator and setup some fields for it
      var gen = new Generator();
      var root = new Json.Node(NodeType.OBJECT);
      var object = new Json.Object();
      root.set_object(object);
      gen.set_root(root);

      var args = new Json.Object();
      object.set_object_member("arguments", args);
      object.set_string_member("method", "torrent-get");

      var fields = new Json.Array();
      foreach(string s in std_fields)
         fields.add_string_element(s);
      args.set_array_member("fields", fields);

      //Send the request json to the server and carry the sessionid along with the request
      json = gen.to_data(out length);
      msg.request_body.append(MemoryUse.COPY, json, length);
      msg.request_headers.append("X-Transmission-Session-Id", sessionid);
      session.send_message(msg);
	  return msg.response_body.flatten().data;
      try {
         //Setup a Parser and load the data from the transmission response
         var parser = new Json.Parser();
    
         parser.load_from_data(msg.response_body.flatten().data, -1);
         //This basically iterates the whole json tree of elements down to the one with the torrent informations
         var info = parser.get_root().get_object().get_object_member("arguments").get_array_member("torrents").get_elements();
         foreach(var node in info) {
            var obj = node.get_object();
            stdout.printf("%d: %s - %.2f%% [%.2f/%.2f] %d byte\n",
               (int)obj.get_int_member("id"),
               obj.get_string_member("name"),
               (float)obj.get_double_member("percentDone")*100,
               (float)obj.get_double_member("rateDownload"),
               (float)obj.get_double_member("rateUpload"),
               (int)obj.get_int_member("sizeWhenDone"));
         }
      }
      catch(Error e) {
         error("%s", e.message);
      }
   }
   private void auth(Message msg, Auth auth, bool retry) {
      if(user != null && password != null)
         auth.authenticate(user, password);
      else if(retry)
 			error("Wrong username/password");
      else
         error("Transmission server requires authentication");

   }
}

