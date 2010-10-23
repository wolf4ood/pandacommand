using Soup;
public interface PandaPlugin : GLib.Object {

  public abstract string get_handler_path();
  public abstract void request_handler(Soup.Server server, Soup.Message msg, string path,
                      GLib.HashTable<string,string>? query, Soup.ClientContext? client);

}