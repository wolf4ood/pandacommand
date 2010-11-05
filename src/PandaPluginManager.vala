using Gee;


public class PandaPluginManager : GLib.Object {

    private Map<string,PandaPluginAction> plugins;   
    public signal void loaded(PandaPlugin p);
    public signal void unloaded(PandaPlugin p);
    private string _name;
    public PandaPluginManager(){
         this.plugins = new HashMap<string,PandaPlugin> (str_hash, str_equal);
         
    }
    public Map<string,PandaPluginAction> get_plugins(){
        return plugins;
    }
    public void loadM(){
        
        PandaConnect front = new PandaConnect(this);
        front.register.connect(register_cmd);
        front.unregister.connect(unregister_cmd);
        this.plugins.set(front.get_handler_path(),new PandaPluginAction(front));
        loaded(front);  
        load_modules(Environment.get_variable ("PWD") + "/plugins/");
        
    }
    public void register_cmd(PandaPlugin plug,string cmd,Gee.List<string> args){
        PandaPluginAction p_action = plugins.get(plug.get_handler_path());
        p_action.add_command(cmd,args);
    }
    public void unregister_cmd (PandaPlugin plug,string cmd){
        PandaPluginAction p_action = plugins.get(plug.get_handler_path());
        p_action.remove_command(cmd);
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
                if(this.plugins==null){
                  this.plugins = new HashMap<string,PandaPlugin>(str_hash, str_equal);
                }
                plugin.register.connect(register_cmd);
                plugin.unregister.connect(unregister_cmd);
                this.plugins.set(plugin.get_handler_path(),new PandaPluginAction(plugin));
                loaded(plugin);              
            }
        
        } catch (Error err) {
            warning("Error: %s\n", err.message);
        }   
    }
}