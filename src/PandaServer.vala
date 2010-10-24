using Soup;
using Gst;
using Json;
using Gee;

public class PandaServer : GLib.Object {

  private Soup.Server server;
  private HashMap<string,PandaPlugin> plugins;
  public PandaServer(int port){

    this.server = new Soup.Server(Soup.SERVER_PORT, port);
    this.server.add_handler ("/", default_handler);
    this.plugins = new HashMap<string,PandaPlugin> (str_hash, str_equal);
    load_modules(Environment.get_variable ("PWD") + "/plugins/");
   
      
  }
  
  public void run(){   
    server.run();
  }
    protected void default_handler (Soup.Server server, Soup.Message msg, string path,
                      GLib.HashTable? query, Soup.ClientContext client)
    { 
	    string response_text = "";
	    if(!plugins.has_key(path) && path !="/") {
	        resources_handler(server,msg,path,query,client);
            return;
        }
        try {
           FileUtils.get_contents("data/index.html", out response_text);
        } catch (Error e) {
            warning ("%s", e.message);
        }
        string plugins_html="";
        foreach (PandaPlugin p in plugins.values){
            string name = p.get_handler_path();
            plugins_html += "<li>" +  p.get_dashboard_html("plugins/" + "panda" + name[1:name.length]) + "</li>\n";
        }
        string real = response_text.replace("<li>@PandaContent</li>",plugins_html);
        msg.set_response ("text/html", Soup.MemoryUse.COPY,
                          real, real.size ());
        msg.set_status (Soup.KnownStatusCode.OK);
    }
    protected void resources_handler(Soup.Server server, Soup.Message msg, string path,
              GLib.HashTable<string,string>? query, Soup.ClientContext client){
    
        string content;
        try {
            FileUtils.get_contents(path[1:path.length], out content);
            msg.set_response ("text/html", Soup.MemoryUse.COPY,
                          content, content.size ());
            msg.set_status (Soup.KnownStatusCode.OK);
        } catch (Error err){
            warning("Error: %s\n", err.message);
        }
    }
    protected async void load_modules(string path) {
       
        var dir = File.new_for_path (path);
        try {
        
            string attribute = FILE_ATTRIBUTE_STANDARD_NAME + "," + FILE_ATTRIBUTE_STANDARD_TYPE;
            var e = yield dir.enumerate_children_async( attribute,0, Priority.DEFAULT, null);
            while (true) {
                var files = yield e.next_files_async(10, Priority.DEFAULT, null);
                if (files == null) {
                    break;
                }
                foreach (var info in files) {
                    var type = info.get_file_type ();
                    if(type == FileType.DIRECTORY ){
                        load_modules(Path.build_filename(dir.get_path (), info.get_name()));
                    }else if(info.get_name()=="plugin.json"){
                          yield load_one(Path.build_filename (dir.get_path (), info.get_name()));  
                    }
                  
                    
                }
            }
        } catch (Error err) {
            warning("Error: %s\n", err.message);
        }
    }
    protected async void load_one(string path){
        try  {
        
            
            var parser = new Json.Parser ();
            parser.load_from_file(path);
            var root_object = parser.get_root ().get_object ();
            string module_name = root_object.get_string_member ("name");
            string module_entry = root_object.get_string_member ("entry");
            var loader = new PandaPluginLoader<PandaPlugin>(module_entry);
            if(loader.load()){
                PandaPlugin plugin = loader.new_object();
                this.server.add_handler (plugin.get_handler_path(),plugin.request_handler);
                plugins.set(plugin.get_handler_path(),plugin);
            }
        
        } catch (Error err) {
            warning("Error: %s\n", err.message);
        }   
    }
  
}
   

