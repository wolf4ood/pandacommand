

public class PandaPluginLoader<T> : Object {

    public string path { get; private set; } 
    private Type type;
    private Module module;

    private delegate Type RegisterPluginFunction (Module module);

    public PandaPluginLoader (string pathP,string name) {
        assert (Module.supported ());
        this.path = Module.build_path (Environment.get_variable ("PWD") + "/" + pathP +"/" + name , name);
    }
    public bool load () {
        stdout.printf ("Loading plugin with path: '%s'\n", path);
        module = Module.open (path, ModuleFlags.BIND_LOCAL);
        if (module == null) {
            return false;
        }
        stdout.printf ("Loaded module: '%s'\n", module.name ());
        void* function;
        module.symbol ("register_plugin", out function);    
        RegisterPluginFunction register_plugin = (RegisterPluginFunction) function;
        type = register_plugin (module);
        
        stdout.printf ("Plugin type: %s\n\n", type.name ());
        module.make_resident ();
        return true;
    }

    public T new_object () {
        return Object.new (type);
    }

}