using Gee;

public class PandaPluginAction : GLib.Object {
    
    public PandaPlugin plugin { get; private set; }
    
    protected Map<string,Gee.List<string>> actions;
    
    public PandaPluginAction(PandaPlugin plugin) {
        this.plugin = plugin;
        actions = new HashMap<string,Gee.List<string>>();
    }
    public void add_command(string cmd , Gee.List<string>? args){
        this.actions.set(cmd,args);
    }
    public void remove_command(string cmd){
        this.actions.unset(cmd);
    }
    public  string invoke(string cmd,Gee.List<string> args){
        if(actions.has_key(cmd)){
            return plugin.invoke(cmd,args);
        }
        return "Command not found";
    }
    public bool has_action(string cmd) {
        return actions.has_key(cmd);
    }
    public bool can_invoke(string cmd,int args,out string error){
        

        if(!has_action(cmd)){
            error="Action not found";
            return false;
        }

        Gee.List<string> params = actions.get(cmd);
        error = "Wrong parameter number";
        if(params==null) return args==0;
        stdout.printf("%d", params.size);
        return params.size == args;
    }
    public string list_actions(){
        string list = "";
        foreach(string a in actions.keys){
            list += "\t" +  a + " ";
            if(actions.get(a)!=null){
                foreach(string par in actions.get(a)){
                    list += par + "  ";
                }
            }
            list +="\n";
        }
        return list;
    }
}