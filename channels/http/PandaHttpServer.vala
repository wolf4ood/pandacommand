using Soup;
using Gst;
using Json;
using Gee;

public class PandaHttpServer : PandaAbstractServer {

  private Soup.Server server;
  //private PandaPluginManager manager;
  public PandaHttpServer(int port){    
    this.server = new Soup.Server(Soup.SERVER_PORT, port);
    this.server.add_handler ("/", default_handler);
    //manager = new PandaPluginManager();
  }
  public override void init(){
    manager.loaded.connect(add_handler);
    manager.unloaded.connect(remove_handler);
    manager.loadM();
  }
  public override void run(){   
    server.run();
  }
  protected void default_handler (Soup.Server server, Soup.Message msg, string path,
                      GLib.HashTable<string,string>? query, Soup.ClientContext client)
    { 
	    string response_text = "";
	    if(path !="/") {
	        if(!manager.has_plugin(path)){
	            resources_handler(server,msg,path,query,client);
                return;
            }else {  
                proxy_request(msg,path,query);
                return;
            }
        }
        try {
           FileUtils.get_contents("data/index.html", out response_text);
        } catch (Error e) {
            warning ("%s", e.message);
        }
        string plugins_html="";
        foreach (PandaPluginAction p in manager.plugins.values){
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
    protected async void proxy_request(Soup.Message msg, string path,
                      GLib.HashTable<string,string>? query){
        
        string response ="";
        if(query!=null){ 
            GLib.List<string> keys = query.get_keys();
            string args = "";
            foreach(string s in keys){
                if(s!="command"){
                    args += s + " ";
                }
            }
            string command = query.lookup("command");
            response = invoke(path + command + args);
        }else {
            response = manager.get_plugin_control_panel(path); 
        }
        msg.set_response ("text/html", Soup.MemoryUse.COPY,
                      response, response.size ());
        msg.set_status (Soup.KnownStatusCode.OK);
    }
}
   

