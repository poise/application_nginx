Description
===========

This cookbook is designed to be able to deploy and configure an nginx reverse proxy in front of one or more application servers, which are also managed with the `application` cookbook.

Note that this cookbook provides the nginx-specific bindings for the `application` cookbook; you will find general documentation in that cookbook.

Requirements
============

Chef 0.10.0 or higher required (for Chef environment use).

The following Opscode cookbooks are dependencies:

* application
* nginx

Resources/Providers
==========

The LWRP provided by this cookbook is not meant to be used by itself; make sure you are familiar with the `application` cookbook before proceeding.

nginx\_load\_balancer
---------------------

The `nginx_load_balancer` sub-resource LWRP installs and configures nginx with an upstream for the given application; the upstream will point to all the nodes returned by a search for a specific role.

Note that the application repository will still be checked out even if this is the only sub-resource applied to a node. This is useful for instance to serve static files directly from the load balancer.

# Attribute Parameters

- application\_server\_role: the role to search for when looking for application servers. Defaults to "#{application name}\_application\_server"
- template: the name of template that will be rendered to create the context file; if specified it will be looked up in the application cookbook. Defaults to "load_balancer.conf.erb" from this cookbook
- server\_name: the virtual host name(s). Defaults to the node FQDN
- port: the port nginx will bind. Defaults to 80
- application_port: the port the application server runs on. Defaults to 8000
- static_files: a Hash mapping URLs to files. Defaults to an empty Hash
- ssl: true/false that we should use SSL
- ssl_certificate: The SSL public certificate full path file name, defaults to #{node.fqdn}.cert if ssl true, append any chained CA certificates to the end of this file.
- ssl_certificate_key: The SSL private certificate full path file name, defaults to #{node.fqdn}.key if ssl true

Usage
=====

A sample application that needs a database connection:

    application "my-app" do
      path "/usr/local/my-app"
      repository "..."
      revision "..."

      rails do
      end

      nginx_load_balancer do
        only_if { node['roles'].include?('my-app_load_balancer') }
      end
    end

Assuming you have a `my-app_application_server` role applied to nodes backend-0..backend-3, and a `my-app_load_balancer` role assigned to frontend-0..frontend-1, then nginx will be installed on the frontends, and configured like this:

    upstream my-app {
      server <IP of backend-0>:8000;
      server <IP of backend-1>:8000;
      server <IP of backend-2>:8000;
      server <IP of backend-3>:8000;
    }

    server {
      listen 80;
      server_name frontend-0;
      location / {
        proxy_pass http://my-app;
      }
    }

You can configure nginx to serve static files by settings the `static_files` attribute:

    application "my-app" do
      path "/usr/local/my-app"
      repository "..."
      revision "..."

      nginx_load_balancer do
        only_if { node['roles'].include?('my-app_load_balancer') }
        static_files "/img" => "images"
      end
    end

which will be expanded to:

    server {
      listen 80;
      server_name frontend-0;

      location /img {
        alias /usr/local/my-app/current/images;
      }

      location / {
        proxy_pass http://my-app;
      }
    }

License and Author
==================

Author:: Adam Jacob (<adam@opscode.com>)
Author:: Andrea Campi (<andrea.campi@zephirworks.com.com>)
Author:: Joshua Timberman (<joshua@opscode.com>)
Author:: Seth Chisamore (<schisamo@opscode.com>)

Copyright 2009-2012, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
