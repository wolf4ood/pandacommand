using Gee;


public class PandaPluginManager : GLib.Object {

    public Map<string,PandaPluginAction> plugins {get; set;}   
    public signal void loaded(PandaPlugin p);
    public signal void unloaded(PandaPlugin p);
    public PandaPluginManager(){
         this.plugins = new HashMap<string,PandaPluginAction> (str_hash, str_equal);        
    }
    
    public void loadM(){
        
        
        PandaConnect front = new PandaConnect(this);
        front.register.connect(register_cmd);
        front.unregister.connect(unregister_cmd);
        PandaConsole console = new PandaConsole(this);
        console.register.connect(register_cmd);
        console.unregister.connect(unregister_cmd);
        this.plugins.set(front.get_handler_path(),new PandaPluginAction(front));
        loaded(front);
        this.plugins.set(console.get_handler_path(),new PandaPluginAction(console));
        loaded(console);    
        load_modules(Environment.get_variable ("PWD") + "/plugins/");
        
    }
    public bool has_action(string plug,string cmd){
        if(!plugins.has_key(plug)) return false;
        return plugins.get(plug).has_action(cmd);
    }
    public bool has_plugin(string plug){
        return plugins.has_key(plug);
    }
    private bool can_invoke(string plug,string cmd,int args,out string error){
           if(!has_plugin(plug)) {
             error = "Command not found";
             return false;
           }
           return  plugins.get(plug).can_invoke(cmd,args,out error);

    }
    public string list_commands(){
        string list = "";
        foreach(string s in plugins.keys)
        {
            list += s.replace("/","") + "\n";
        }
        return list;
    }
    public string list_actions(string plug){
        if(!has_plugin(plug)) return "Command not found";
        return plugins.get(plug).list_actions();
    }
    public void register_cmd(PandaPlugin plug,string cmd,Gee.List<string>? args){
        PandaPluginAction p_action = plugins.get(plug.get_handler_path());
        p_action.add_command(cmd,args);
    }
    public void unregister_cmd (PandaPlugin plug,string cmd){
        PandaPluginAction p_action = plugins.get(plug.get_handler_path());
        p_action.remove_command(cmd);
    }
    public string invoke(string command){
        
        if(command!=null && command!=""){
        	string[] args = command.split(" ");
			string plug = "/" + args[0];
			if(args.length ==1)  return list_actions(plug);
			Gee.List<string> list = new Gee.ArrayList<string>();
			foreach(string s in args) {
			    if(args[0]!=s) list.add(s);
			}
			string cmd = list.remove_at(0);
			string err = "";
			if(!can_invoke(plug,cmd,list.size,out err)) return err;
			return invoke_cmd(plug,cmd,list);
        }
        return list_commands();
    }

    public string invoke_cmd(string plugin,string cmd ,Gee.List<string> args) {
        return plugins.get(plugin).invoke(cmd,args);
    }
    public string get_plugin_control_panel(string path){
        string context = Environment.get_variable ("PWD") + "/plugins" + path;
        if(plugins.has_key(path)){
            return plugins.get(path).plugin.get_dashboard_html(context);
        }else {
            return "Panel not found";
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
            string module_entry = root_object.get_string_member ("entry");
            var loader = new PandaPluginLoader<PandaPlugin>("plugins",module_entry);
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