#
# Author:: Noah Kantrowitz <noah@opscode.com>
# Cookbook Name:: application_nginx
# Resource:: nginx_load_balancer
#
# Copyright:: 2011, Opscode, Inc <legal@opscode.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include ApplicationCookbook::ResourceBase

attribute :application_server_role, :kind_of => [String, Symbol, NilClass], :default => nil
attribute :template, :kind_of => [String, NilClass], :default => nil
attribute :server_name, :kind_of => [String, Array], :default => node['fqdn']
attribute :port, :kind_of => Integer, :default => 80
attribute :application_port, :kind_of => Integer, :default => 8000
attribute :application_socket, :kind_of => [Array, String, NilClass], :default => nil
attribute :static_files, :kind_of => Hash, :default => {}
attribute :ssl, :kind_of => [ TrueClass, FalseClass ], :default => false
attribute :ssl_certificate, :kind_of => String, :default => "#{node['fqdn']}.crt"
attribute :ssl_certificate_key, :kind_of => String, :default => "#{node['fqdn']}.key"
