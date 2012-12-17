ruby_ffi-javascriptcore
=======================

ABOUT
===
    Bridge between RUBY and JavaScript in JavaScriptCore as provided by WebKit (WebKitGTK)
    
    What started out as a way to manipulate the DOM in WebKitGTK, as WebKitDOM (gdom) was not yet
    included in WebKitGTK, has evolved to the unholy union of JavaScript and Ruby.
    We've broken out of DOM and WebView and only require JavaScriptCore.
     
    Allows Ruby and JavaScript to share API's in any application.
    <em>Useful side-effect: JavaScript gets bound to any ruby binding</em>
    
    Write command-line ruby applications leveraging javascript
    Write command-line apps in javascript
    Write GUI applications, Gtk2,Gtk3,Kde,Qt in javascript
    Write HTML5 applications in Ruby
    
    And when Just DOM access is not enough, as WebKitDOM api provides (no access to JS-land), this library
    is there to get it done, thus you can reuse existing JavaScript libraries, making HTML5 applications
    especially easier. 
    
    This is essentially the basis for a suite of HTML5 related libraries for ruby.
    
Example
```ruby
    require 'rubygems'
    require 'JS/base'
    ctx = JS::GlobalContext.new(nil)
    obj = JS::Object.new(ctx,{:name=>'World',:sayHello=> proc do |t,n| "hello #{n}" end})
    p a = JS.execute_script(ctx,'this.sayHello(this.name);',obj) #=> "hello World"
    p a == obj.sayHello(obj.name) #=> true
```
Example 2 
```ruby
    # Example demonstrating JavaScript calls to Ruby
    # Any binding for ruby is available for use by javascript
    # MIT License
    require File.join(File.dirname(__FILE__),'..','lib','JS','base')
    require 'gtk2'

    def takes_block *o,&b
      puts "got arguments: #{o.join(",")}"
      b.call()
    end

    ctx = JS::GlobalContext.new(nil)

    globj = ctx.get_global_object
    globj.Ruby = Object

    JS.execute_script ctx,<<-EOJS
      function add(a,b) {
        return a+b;
      };
      
      Ruby.takes_block("foo",1,[1,2,3],function() {
        Ruby.puts("in a block");
      });
    EOJS

    puts globj.add 1,2
```
