using Gee;

public class PandaSignal : GLib.Object {


    public uint id { get; private set; } 
    public signal void panda_invoke(string plugin,string cmd,Gee.List<string> args);
    
    protected Map<string,Gee.List<PandaCallback>> plugin_actions  { get; private set; } 
    
    public PandaSignal(uint id) {
        this.id = id;
        stdout.printf("%s - %i\n",(int)id,(int)this);
        string name = GLib.Signal.name(id);
        this.plugin_actions = new Gee.HashMap<string,Gee.List<PandaCallback>>(GLib.str_hash, GLib.str_equal);
    }  
    public void add_callback(string plugin,string cmd,Gee.List<string> args){
        
        if(!plugin_actions.has_key(plugin)){
            var callbacks = new Gee.ArrayList<PandaCallback>();
            plugin_actions.set(plugin,callbacks);
        }
        PandaCallback call = new PandaCallback(cmd,args);
        plugin_actions.get(plugin).add(call);
    }
    public void remove_callback(string plugin , string cmd){
        /*if(plugin_actions.has_key(plugin)){
             plugin_actions.get(plugin).unset(cmd);
        }*/
    }
    public void proxy_signal(){
        //stdout.printf("%d\n",(int)id);
        stdout.printf("%i - %i\n",(int)this.ref_count,(int)this);
        panda_invoke(null,null,null);
        //int i = this.plugin_actions.size;
        //stdout.printf("%d\n",i);
        /*foreach (string plugs in plugin_actions.keys){
          /*var commands = plugin_actions.get(plugs);
            foreach(string cmd in commands.keys){
                panda_invoke(plugs,cmd,commands.get(cmd));
            } 
        }*/     
    }
    public string list_callbacks(){
        string ret="";    
        foreach(string plug in plugin_actions.keys){
            string name = GLib.Signal.name(id);
            ret +="signal: " + name + "\n";
            ret += "\t\t<< " + plug + " >>  ";
            foreach(PandaCallback c in plugin_actions.get(plug)){
                ret += c.cmd  + "\n";
            }
        }
        return ret;
    }
}