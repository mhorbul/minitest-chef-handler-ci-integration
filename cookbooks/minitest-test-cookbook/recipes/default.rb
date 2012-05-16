#
# Cookbook Name:: minitest-test-cookbook
# Recipe:: default
#
# Copyright 2012, LivingSocial
#
# All rights reserved - Do Not Redistribute
#

file "/tmp/minitest.txt" do
  content "minitest test"
  mode 644
  action :create
end
