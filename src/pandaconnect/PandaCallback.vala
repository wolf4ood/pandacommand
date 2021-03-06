using Gee;


public class PandaCallback : GLib.Object {
    

    public string host  { get; private set; }
    public string cmd  { get; private set; }
    public Gee.List<string> args  { get; private set; }
    
    public PandaCallback(string host,string cmd , Gee.List<string> args){
        this.args = args;
        this.cmd = cmd;
        this.host = host;
    }

}