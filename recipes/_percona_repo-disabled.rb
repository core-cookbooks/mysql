#
# Cookbook Name:: mysql
# Recipe:: percona_repo
#
# Copyright 2015, Cloudenablers
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

##################################################
# SHOULD THIS SHOULD BE MOVED TO ITS OWN COOKBOOK?
# A WRAPPER AROUND MYSQL THAT SETS PACKAGE NAMES?
##################################################

case node['platform_family']
when 'debian'
  include_recipe 'apt::default'

  apt_repository 'percona' do
    uri          node['mysql']['percona']['apt_uri']
    distribution node['lsb']['codename']
    components   %w[main]
    keyserver    node['mysql']['percona']['apt_keyserver']
    key          node['mysql']['percona']['apt_key_id']
    action       :add
  end
when 'rhel'
  include_recipe 'yum::default'

  yum_key 'RPM-GPG-KEY-percona' do
    url    'http://www.percona.com/downloads/RPM-GPG-KEY-percona'
    action :add
  end

  arch = node['kernel']['machine']
  arch = 'i386' unless arch == 'x86_64'
  pversion = node['platform_version'].split('.').first

  yum_repository 'percona' do
    repo_name   'Percona'
    description 'Percona Repo'
    url         "http://repo.percona.com/centos/#{pversion}/os/#{arch}/"
    key         'RPM-GPG-KEY-percona'
    action      :add
  end
end
