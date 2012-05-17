# Directory to store cookbook tests
directory "minitest test location" do
  path node[:minitest][:path]
  owner "root"
  group "root"
  recursive true
end

ruby_block "delete tests from old cookbooks" do
  block do
    raise "minitest-handler cookbook could not find directory '#{node[:minitest][:path]}'" unless File.directory?(node[:minitest][:path])
    expired_cookbooks = Dir.entries(node[:minitest][:path]).delete_if { |dir| dir == '.' || dir == '..' || node[:recipes].include?(dir) }
    expired_cookbooks.each do |cookbook|
      Chef::Log.info("Cookbook #{cookbook} no longer in run list, remove minitest tests")
      FileUtils.rm_rf "#{node[:minitest][:path]}/#{cookbook}"
    end
  end
end

# Search through all cookbooks in the run list for tests
node[:recipes].each do |recipe|
  # recipes is actually a list of cookbooks and recipes with :: as a delimiter
  cookbook_name = recipe.split('::').first
  remote_directory "tests-#{cookbook_name}" do
    source "tests/minitest"
    cookbook cookbook_name
    path "#{node[:minitest][:path]}/#{cookbook_name}"
    purge true
    ignore_failure true
  end
end

git "/opt/minitest-chef-handler" do
  repository "https://github.com/mhorbul/minitest-chef-handler"
  reference "ci-integration"
  action :sync
end

chef_gem "minitest"

ruby_block "activate minitest handler" do
  block do
    $:.push "/opt/minitest-chef-handler/lib"
    require "/opt/minitest-chef-handler/lib/minitest-chef-handler"
    handler = MiniTest::Chef::Handler.new({
        :path    => "#{node[:minitest][:path]}/**/*_test.rb",
        :verbose => true,
        :output_file_path => "#{node[:minitest][:path]}/minitest-status.log",
        :keep_output_file => true
      })
    Chef::Log.info("Enabling minitest-chef-handler as a report handler")
    Chef::Config.send("report_handlers").delete_if {|v| v.class.to_s.include? MiniTest::Chef::Handler}
    Chef::Config.send("report_handlers") << handler
  end
end
