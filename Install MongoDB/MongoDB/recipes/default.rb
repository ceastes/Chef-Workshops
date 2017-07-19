##########################################################################
# Cookbook Name:: mongodb
# Recipe:: default (install)
# Chris Eastes
#
# Not sure how to get started?
#
# You could:
# 1.  copy the relevant commands from http://docs.mongodb.org/manual/tutorial/install-mongodb-on-red-hat-centos-or-fedora-linux/
# 2.  comment out everything
# 3.  add the Chef resources and other Chef code necessary
#

# Create a /etc/yum.repos.d/mongodb-org-3.4.repo file for the MongoDB repository config info
cookbook_file '/etc/yum.repos.d/mongodb-org-3.4.repo' do
  source 'mongodb-org-3.4.repo'
  action :create
end

# Install the MongoDB packages and associated tools
package "mongodb-org" do
  action :install
end

# Start MongoDB now and on reboot
service "mongod" do
  action [:start, :enable]
end
