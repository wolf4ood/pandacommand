using Gee;

public class PandaPluginAction : GLib.Object {
    
    public PandaPlugin plugin { get; private set; }
    
    protected Map<string,Gee.List<string>> actions;
    
    public PandaPluginAction(PandaPlugin plugin) {
        this.plugin = plugin;
        actions = new HashMap<string,Gee.List<string>>();
    }
    public void add_command(string cmd , Gee.List<string> args){
        this.actions.set(cmd,args);
    }
    public void remove_command(string cmd){
        this.actions.unset(cmd);
    }
    public  string invoke(string cmd,Gee.List<string> args){
        if(actions.has_key(cmd)){
            return plugin.invoke(cmd,args);
        }
        stdout.printf("%s\n",args[0]);   
        return "command not found";
    }
    public bool has_action(string cmd) {
        return actions.has_key(cmd);
    }
    
}