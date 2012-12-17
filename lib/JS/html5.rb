
#       html5.rb
             
#		(The MIT License)
#
#        Copyright 2011 Matt Mesanko <tulnor@linuxwaves.com>
#
#		Permission is hereby granted, free of charge, to any person obtaining
#		a copy of this software and associated documentation files (the
#		'Software'), to deal in the Software without restriction, including
#		without limitation the rights to use, copy, modify, merge, publish,
#		distribute, sublicense, and/or sell copies of the Software, and to
#		permit persons to whom the Software is furnished to do so, subject to
#		the following conditions:
#
#		The above copyright notice and this permission notice shall be
#		included in all copies or substantial portions of the Software.
#
#		THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
#		EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#		MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#		IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
#		CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
#		TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
#		SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# 
require 'gir_ffi'
require 'JS/base'

GirFFI.setup :WebKit,'3.0'

module WebKit::Lib
  attach_function :webkit_web_frame_get_global_context,[:pointer],:pointer
end

c = WebKit::WebFrame
c.class_eval do
  define_method :get_global_context do
    ptr = WebKit::Lib.webkit_web_frame_get_global_context(self)
    p ptr
    JS::GlobalContext.new(:pointer=>ptr)
  end
  alias :global_context :get_global_context
  define_method :get_global_object do
    global_context.get_global_object
  end
  alias :global_object :get_global_object
end

module GLib::Lib
  attach_function :g_list_nth_data,[:pointer,:int],:pointer
  attach_function :g_list_length,[:pointer],:int
end

module Gtk::Lib
  #callback :GtkCallback,[:pointer,:pointer],:void
  #attach_function :gtk_container_for_each,[:pointer,:GtkCallback],:void
end
c = GObject::Object
c.class_eval do
  define_method :signal_connect do |*o,&b|
    GObject.signal_connect self,*o,&b
  end
end

# GLib::List
# NOTE: stores elements as GList's
#       Elements refer to gpointer's
#       item = GLib.g_list_nth_data(list,index) # will return gpointer, Integer
#       GirFFI::ArgHelper.object_pointer_to_object(FFI::Pointer.new(item)) # will convert it to GObject (will upcast), if it is a GObject (or subclass)
c = GLib::List
c.class_eval do
  # i, Integer, index in list
  # returns Integer, gpointer of value at index
  def nth_data i
    pt = GLib::Lib.g_list_nth_data self,i
  end
  
  def length
    GLib::Lib::g_list_length self
  end
  
  alias :size :length
  
  def << q
    append q
  end
end


c = Gtk::Container
c.class_eval do
  # ruby-gtk2 returns Array, it may be operated on, yet does not effect the list.
  # we'll do the same ...
  alias :get_children_ :get_children
  def get_children
    get_children_().map do |child|
      # get the GObject of gpointer, child
      GirFFI::ArgHelper.object_pointer_to_object(FFI::Pointer.new(child))
    end
  end
  
  # Ruby-Gtk2 compatibility
  alias :each :foreach
  alias :each_forall :forall
end

GLib
module GLib::Lib
  attach_function :g_timeout_add,[:uint,:GSourceFunc,:pointer],:uint
  attach_function :g_timeout_add_full,[:int,:uint,:GSourceFunc,:pointer,:pointer],:uint
  attach_function :g_idle_add,[:GSourceFunc,:pointer],:uint
  attach_function :g_idle_add_full,[:int,:GSourceFunc,:pointer,:pointer],:uint
end

module GLib
  class Timeout
    def self.add int,&b
      GLib::Lib.g_timeout_add int,b,nil
    end
 
    def self.add_full pl,int,&b
      GLib::Lib.g_timeout_add_full pl,int,b,nil,nil
    end
  end
  
  class Idle
    def self.add int,&b
      GLib::Lib.g_idle_add b,nil
    end
 
    def self.add_full pl,int,&b
      GLib::Lib.g_idle_add_full pl,b,nil,nil
    end
  end  
end