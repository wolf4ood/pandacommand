using Soup;
using Gst;
using Json;
using Gee;

public class PandaServer : GLib.Object {

  private Soup.Server server;
  private PandaPluginManager manager;
  public PandaServer(int port){    
    this.server = new Soup.Server(Soup.SERVER_PORT, port);
    this.server.add_handler ("/", default_handler);
    manager = new PandaPluginManager();
    manager.loaded.connect(add_handler);
    manager.unloaded.connect(remove_handler);
    manager.loadM(); 
    
  }
  
  public void run(){   
    server.run();
  }
  protected void default_handler (Soup.Server server, Soup.Message msg, string path,
                      GLib.HashTable<string,string>? query, Soup.ClientContext client)
    { 
	    string response_text = "";
	    if(path !="/") {
	        if(!manager.get_plugins().has_key(path)){
	            resources_handler(server,msg,path,query,client);
                return;
            }else {
                proxy_request(server,msg,path,query,client);
                return;
            }
        }
        try {
           FileUtils.get_contents("data/index.html", out response_text);
        } catch (Error e) {
            warning ("%s", e.message);
        }
        string plugins_html="";
        foreach (PandaPluginAction p in manager.get_plugins().values){
            string name = p.plugin.get_handler_path();
            plugins_html += "<li><iframe src='"+ name +" 'width='800' height='400'></iframe></li>\n";
        }
        string real = response_text.replace("<li>@PandaContent</li>",plugins_html);
        msg.set_response ("text/html", Soup.MemoryUse.COPY,real,real.length);
        msg.set_status (Soup.KnownStatusCode.OK);
    }
    protected void resources_handler(Soup.Server server, Soup.Message msg, string path,
              GLib.HashTable<string,string>? query, Soup.ClientContext client){
    
        string content;
        try {
            FileUtils.get_contents(path[1:path.length], out content);
            msg.set_response ("text/html", Soup.MemoryUse.COPY, content,content.length);
            msg.set_status (Soup.KnownStatusCode.OK);
        } catch (Error err){
            warning("Error: %s\n", err.message);
        }
    }
    public void add_handler(PandaPlugin plugin){
        this.server.add_handler (plugin.get_handler_path(),default_handler);
        plugin.init();
    }
    public void remove_handler(PandaPlugin plugin){
        this.server.remove_handler(plugin.get_handler_path());
    }
    protected void proxy_request(Soup.Server server, Soup.Message msg, string path,
                      GLib.HashTable<string,string>? query, Soup.ClientContext client){
    
        string response ="";
        string context = Environment.get_variable ("PWD") + "/plugins" + path;
        PandaPluginAction p_action = manager.get_plugins().get(path);
        if(query!=null){ 
            GLib.List<string> keys = query.get_keys();
            Gee.List<string> args = new Gee.ArrayList<string>();
            foreach(string s in keys){
                if(s!="command"){
                    args.add(query.lookup(s));
                }
            }
            string command = query.lookup("command");
            response = p_action.invoke(command,args);
        }else {
            response = p_action.plugin.get_dashboard_html(context);
        }
        msg.set_response ("text/html", Soup.MemoryUse.COPY,
                      response, response.size ());
        msg.set_status (Soup.KnownStatusCode.OK);
    }
}
   

