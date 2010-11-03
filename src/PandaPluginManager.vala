using Gee;


public class PandaPluginManager : GLib.Object {

    private Map<string,PandaPlugin> plugins;   
    public signal void loaded(PandaPlugin p);
    public signal void unloaded(PandaPlugin p);
    private string _name;
    

    public PandaPluginManager(){
         this.plugins = new HashMap<string,PandaPlugin> (str_hash, str_equal);
         
    }
    public Map<string,PandaPlugin> get_plugins(){
        return plugins;
    }
    public void loadM(){
        
        foreach( ParamSpec p in this.get_class().list_properties()) {
            stdout.printf("%s\n",p.get_name());
        }
        load_modules(Environment.get_variable ("PWD") + "/plugins/");
    }
    public void signal_handler(string path){
         stdout.printf ("Path: %s\n\n",path);
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
            string module_entry = root_object.get_string_member ("entry");
            var loader = new PandaPluginLoader<PandaPlugin>(module_entry);
            if(loader.load()){
                PandaPlugin plugin = loader.new_object();
                stdout.printf ("Plugin type: %s\n\n",plugin.get_type().name());
                if(this.plugins==null){
                  this.plugins = new HashMap<string,PandaPlugin>(str_hash, str_equal);
                }
                this.plugins.set(plugin.get_handler_path(),plugin);
                plugin.register.connect(signal_handler);
                loaded(plugin);
              
            }
        
        } catch (Error err) {
            warning("Error: %s\n", err.message);
        }   
    }
}