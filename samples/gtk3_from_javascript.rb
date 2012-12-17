# Example demonstrating JavaScript calls to Ruby
# Any binding for ruby is available for use by javascript
# MIT License
require File.join(File.dirname(__FILE__),'..','lib','JS','base')
require 'gir_ffi'
GirFFI.setup(:Gtk,"3.0")

ctx = JS::GlobalContext.new(nil)
globj = ctx.get_global_object
globj.Ruby = Object
globj.Gtk = Gtk
globj.GLib = GLib
GLib.idle_add 200,(proc do Thread.pass;true end),nil,nil
globj.GObject = GObject

JS.execute_script ctx,<<EOJS
    // Gtk2 UI
    Gtk.send("init",[]);
	w=Gtk.const_get("Window").new(0);

	w.signal_connect('show',function(){
	  Ruby.puts('shown');
	});

	w.signal_connect('delete-event',function() {
	  Gtk.main_quit();
	});

	w.show_all();
	
	// GLib::Idle.add
    cnt = 0;
    GLib.idle_add(200,function() {
      d = Ruby.p('js');
      cnt++;
      return cnt < 3 ? true : false;
    },null,null);
    
    // Run the UI
	Gtk.send("main");
EOJS
