
#       lib.rb
             
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
if !defined?(GObjectIntrospection)
  begin
    require 'gir_ffi'
  rescue => LoadError
    require 'rubygems'
    require 'gir_ffi'
  end
end

module JS
  if !defined?(self::WEBKIT_VERSION)
    WEBKIT_VERSION = 3.0
  end
  module Lib
    require "#{File.dirname(__FILE__)}/base_object"
    require File.join(File.dirname(__FILE__),'Object')
    require File.join(File.dirname(__FILE__),'Value')
    require File.join(File.dirname(__FILE__),'Context')
    require File.join(File.dirname(__FILE__),'GlobalContext')
    require File.join(File.dirname(__FILE__),'ContextGroup')
    require File.join(File.dirname(__FILE__),'Value')
    require File.join(File.dirname(__FILE__),'String')
    require File.join(File.dirname(__FILE__),'PropertyNameArray')

    extend FFI::Library
    @gir = GObjectIntrospection::IRepository.default
    @gir.require "WebKit", JS::WEBKIT_VERSION.to_s
    a = @gir.shared_library("WebKit").split(",")
    lib = a.find do |q| q =~ /webkit/ end
    ffi_lib lib

    typedef :pointer,:JSClassRef
    typedef :pointer,:JSObjectRef
    typedef :pointer,:JSStringRef
    typedef :pointer,:JSValueRef
    typedef :pointer,:JSPropertyNameArrayRef
    typedef :pointer,:JSGlobalContextRef
    typedef :pointer,:JSContextGroupRef
    typedef :pointer,:JSContextRef
    typedef :uint,:unsigned

    callback :JSObjectCallAsFunctionCallback,[:JSContextRef,:JSObjectRef,:JSObjectRef,:size_t,:pointer,:JSValueRef],:JSValueRef

    attach_function :JSEvaluateScript,[:JSContextRef,:JSStringRef,:JSObjectRef,:JSStringRef,:int,:JSValueRef],:JSValueRef
    attach_function :JSCheckScriptSyntax,[:JSContextRef,:JSStringRef,:JSStringRef,:int,:JSValueRef],:bool
    attach_function :JSObjectMake,[:JSContextRef,:JSClassRef,:pointer],:JSObjectRef
    attach_function :JSObjectMakeFunctionWithCallback,[:JSContextRef,:JSStringRef,:JSObjectCallAsFunctionCallback],:JSObjectRef
    attach_function :JSObjectMakeConstructor,[:JSContextRef,:JSClassRef,:pointer],:JSObjectRef
    attach_function :JSObjectMakeArray,[:JSContextRef,:size_t,:JSValueRef,:pointer],:JSObjectRef
    attach_function :JSObjectMakeFunction,[:JSContextRef,:JSStringRef,:unsigned,:JSStringRef,:JSStringRef,:JSStringRef,:int,:pointer],:JSObjectRef
    attach_function :JSObjectGetPrototype,[:JSContextRef,:JSObjectRef],:JSValueRef
    attach_function :JSObjectSetPrototype,[:JSContextRef,:JSObjectRef,:JSValueRef],:void
    attach_function :JSObjectHasProperty,[:JSContextRef,:JSObjectRef,:JSStringRef],:bool
    attach_function :JSObjectGetProperty,[:JSContextRef,:JSObjectRef,:JSStringRef,:pointer],:JSValueRef
    attach_function :JSObjectSetProperty,[:JSContextRef,:JSObjectRef,:JSStringRef,:JSValueRef,:pointer,:pointer],:void
    attach_function :JSObjectDeleteProperty,[:JSContextRef,:JSObjectRef,:JSStringRef,:pointer],:bool
    attach_function :JSObjectGetPropertyAtIndex,[:JSContextRef,:JSObjectRef,:unsigned,:pointer],:JSValueRef
    attach_function :JSObjectSetPropertyAtIndex,[:JSContextRef,:JSObjectRef,:unsigned,:JSValueRef,:pointer],:void
    attach_function :JSObjectGetPrivate,[:JSObjectRef],:pointer
    attach_function :JSObjectSetPrivate,[:JSObjectRef,:pointer],:bool
    attach_function :JSObjectIsFunction,[:JSContextRef,:JSObjectRef],:bool
    attach_function :JSObjectCallAsFunction,[:JSContextRef,:JSObjectRef,:JSObjectRef,:size_t,:JSValueRef,:pointer],:JSValueRef
    attach_function :JSObjectIsConstructor,[:JSContextRef,:JSObjectRef],:bool
    attach_function :JSObjectCallAsConstructor,[:JSContextRef,:JSObjectRef,:size_t,:JSValueRef,:pointer],:JSObjectRef
    attach_function :JSObjectCopyPropertyNames,[:JSContextRef,:JSObjectRef],:JSPropertyNameArrayRef
    attach_function :JSValueMakeUndefined,[:JSContextRef],:JSValueRef
    attach_function :JSValueMakeNull,[:JSContextRef],:JSValueRef
    attach_function :JSValueMakeBoolean,[:JSContextRef,:bool],:JSValueRef
    attach_function :JSValueMakeNumber,[:JSContextRef,:double],:JSValueRef
    attach_function :JSValueMakeString,[:JSContextRef,:JSStringRef],:JSValueRef
    attach_function :JSValueGetType,[:JSContextRef,:JSValueRef],:pointer
    attach_function :JSValueIsUndefined,[:JSContextRef,:JSValueRef],:bool
    attach_function :JSValueIsNull,[:JSContextRef,:JSValueRef],:bool
    attach_function :JSValueIsBoolean,[:JSContextRef,:JSValueRef],:bool
    attach_function :JSValueIsNumber,[:JSContextRef,:JSValueRef],:bool
    attach_function :JSValueIsString,[:JSContextRef,:JSValueRef],:bool
    attach_function :JSValueIsObject,[:JSContextRef,:JSValueRef],:bool
    attach_function :JSValueIsObjectOfClass,[:JSContextRef,:JSValueRef,:JSClassRef],:bool
    attach_function :JSValueIsEqual,[:JSContextRef,:JSValueRef,:JSValueRef,:pointer],:bool
    attach_function :JSValueIsStrictEqual,[:JSContextRef,:JSValueRef,:JSValueRef],:bool
    attach_function :JSValueIsInstanceOfConstructor,[:JSContextRef,:JSValueRef,:JSObjectRef,:pointer],:bool
    attach_function :JSValueToBoolean,[:JSContextRef,:JSValueRef],:bool
    attach_function :JSValueToNumber,[:JSContextRef,:JSValueRef,:pointer],:double
    attach_function :JSValueToStringCopy,[:JSContextRef,:JSValueRef,:pointer],:JSStringRef
    attach_function :JSValueToObject,[:JSContextRef,:JSValueRef,:pointer],:JSObjectRef
    attach_function :JSValueProtect,[:JSContextRef,:JSValueRef],:void
    attach_function :JSValueUnprotect,[:JSContextRef,:JSValueRef],:void
    attach_function :JSContextGetGlobalObject,[:JSContextRef],:JSObjectRef
    attach_function :JSContextGetGroup,[:JSContextRef],:JSContextGroupRef
    attach_function :JSGlobalContextCreate,[:JSClassRef],:JSGlobalContextRef
    attach_function :JSGlobalContextCreateInGroup,[:JSContextGroupRef,:JSClassRef],:JSGlobalContextRef
    attach_function :JSGlobalContextRetain,[:JSGlobalContextRef],:JSGlobalContextRef
    attach_function :JSGlobalContextRelease,[:JSGlobalContextRef],:void
    attach_function :JSContextGroupCreate,[],:JSContextGroupRef
    attach_function :JSContextGroupRetain,[:JSContextGroupRef],:JSContextGroupRef
    attach_function :JSValueMakeUndefined,[:JSContextRef],:JSValueRef
    attach_function :JSValueMakeNull,[:JSContextRef],:JSValueRef
    attach_function :JSValueMakeBoolean,[:JSContextRef,:bool],:JSValueRef
    attach_function :JSValueMakeNumber,[:JSContextRef,:double],:JSValueRef
    attach_function :JSValueMakeString,[:JSContextRef,:JSStringRef],:JSValueRef
    attach_function :JSValueGetType,[:JSContextRef,:JSValueRef],:pointer
    attach_function :JSValueIsUndefined,[:JSContextRef,:JSValueRef],:bool
    attach_function :JSValueIsNull,[:JSContextRef,:JSValueRef],:bool
    attach_function :JSValueIsBoolean,[:JSContextRef,:JSValueRef],:bool
    attach_function :JSValueIsNumber,[:JSContextRef,:JSValueRef],:bool
    attach_function :JSValueIsString,[:JSContextRef,:JSValueRef],:bool
    attach_function :JSValueIsObject,[:JSContextRef,:JSValueRef],:bool
    attach_function :JSValueIsObjectOfClass,[:JSContextRef,:JSValueRef,:JSClassRef],:bool
    attach_function :JSValueIsEqual,[:JSContextRef,:JSValueRef,:JSValueRef,:pointer],:bool
    attach_function :JSValueIsStrictEqual,[:JSContextRef,:JSValueRef,:JSValueRef],:bool
    attach_function :JSValueIsInstanceOfConstructor,[:JSContextRef,:JSValueRef,:JSObjectRef,:pointer],:bool
    attach_function :JSValueToBoolean,[:JSContextRef,:JSValueRef],:bool
    attach_function :JSValueToNumber,[:JSContextRef,:JSValueRef,:pointer],:double
    attach_function :JSValueToStringCopy,[:JSContextRef,:JSValueRef,:pointer],:JSStringRef
    attach_function :JSValueToObject,[:JSContextRef,:JSValueRef,:pointer],:JSObjectRef
    attach_function :JSValueProtect,[:JSContextRef,:JSValueRef],:void
    attach_function :JSValueUnprotect,[:JSContextRef,:JSValueRef],:void
    attach_function :JSStringCreateWithCharacters,[:pointer,:size_t],:JSStringRef
    attach_function :JSStringCreateWithUTF8CString,[:pointer],:JSStringRef
    attach_function :JSStringRetain,[:JSStringRef],:JSStringRef
    attach_function :JSStringRelease,[:JSStringRef],:void
    attach_function :JSStringGetLength,[:JSStringRef],:size_t
    attach_function :JSStringGetCharactersPtr,[:JSStringRef],:pointer
    attach_function :JSStringGetMaximumUTF8CStringSize,[:JSStringRef],:size_t
    attach_function :JSStringGetUTF8CString,[:JSStringRef,:pointer,:size_t],:void
    attach_function :JSStringIsEqual,[:JSStringRef,:JSStringRef],:bool
    attach_function :JSStringIsEqualToUTF8CString,[:JSStringRef,:pointer],:bool
    attach_function :JSPropertyNameArrayRetain,[:JSPropertyNameArrayRef],:JSPropertyNameArrayRef
    attach_function :JSPropertyNameArrayRelease,[:JSPropertyNameArrayRef],:void
    attach_function :JSPropertyNameArrayGetCount,[:JSPropertyNameArrayRef],:size_t
    attach_function :JSPropertyNameArrayGetNameAtIndex,[:JSPropertyNameArrayRef,:size_t],:JSStringRef
    attach_function :JSGarbageCollect,[:JSContextRef],:void
  end
end
