# Example demonstrating JavaScript calls to Ruby
# Any binding for ruby is available for use by javascript
# MIT License
require File.join(File.dirname(__FILE__),'..','lib','JS','base')
require 'gtk2'

ctx = JS::GlobalContext.new(nil)
globj = ctx.get_global_object
globj.Ruby = Object
globj.Gtk = Gtk
globj.GLib = GLib
globj.GObject = GLib::Object

# Hack
# Ruby.loop in a thread in JS land will run once then fault
# so add a loop function to global object
globj.loop = proc do |*o|
  loop do
    o[1].call
  end
end

JS.execute_script ctx,<<EOJS
    // Gtk2 UI
	w=Gtk.Window.new();

	w.signal_connect('show',function(){
	  Ruby.puts('shown');
	});

	w.signal_connect('delete-event',function() {
	  Gtk.main_quit();
	});

	w.show_all();
	
	// GLib::Idle.add
    cnt = 0;
    GLib.Idle.add(200,function() {
      d = Ruby.p('js');
      cnt++;
      return cnt < 3 ? true : false;
    });
    
    // Access ruby Thread
    //             loop
    //             p
    //             sleep
    Ruby.Thread.start(function() {
      loop(function() {
        Ruby.p("in thread");
        Ruby.sleep(1);
      });
    });
    
    // Run the UI
	Gtk.main();
EOJS
