
#       test_property_name_array.rb
             
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
require File.join(File.dirname(__FILE__),'..','lib','JS')

ctx = JS::GlobalContext.new(nil)
obj = JS::Object.new(ctx)
names = ['foo','bar','baz','moof']

names.each_with_index do |n,i|
  obj[n] = "property #{i}"
end

names << 'myFunc'

obj['myFunc'] = JS::Object.make_function_with_callback(ctx,'myFun') do
  true
end
p obj;

if idx=[
  obj.copy_property_names.get_count == names.count,
  obj.properties == names,
  obj.properties[2] == 'baz',
  'baz' == obj.copy_property_names.get_name_at_index(2),
  obj.functions == ['myFunc']
].index(false) then
  puts "#{File.basename(__FILE__)} test #{idx} failed"
  exit(1)
else
  puts "#{File.basename(__FILE__)} all passed"
end
