namespace :gem do
	desc "creates a rubygems .gem"
	task :build do
	  sh %{gem build ruby_ffi-javascriptcore.gemspec}
	end

	desc "remove ruby_ffi-javascriptcore-[version] installation from rubygems"
	task :remove do
	  sh %{gem uni ruby_ffi-javascriptcore} if `gem list -d ruby_ffi-javascriptcore`.split("\n").map do |l| l !~ /ruby_ffi-javascriptcore/ end.index(false)
	end

    desc "installs the gem to rubygems"
	task "install" do
      sh %{gem i ruby_ffi-javascriptcore*.gem}
	end
	
	desc "remove local ./ruby_ffi-javascriptcore-*.gem"
	task :clean do
	  sh %{rm ruby_ffi-javascriptcore*.gem}
	end
end

desc "builds and installs gem and removes local ./ruby_ffi-javascriptcore-*.gem"
task :gem => ["gem:build","gem:install","gem:clean"]
