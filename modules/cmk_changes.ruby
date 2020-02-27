#!/usr/bin/ruby
# version 23.02.2020
# todo: handle unset_attributes

require 'ansible_module'
# die folgende Zeile unbedingt stehen lassen, sonst werden die Modul-Parameter nicht im JSON-Format übergeben
# WANT_JSON
require "httparty"

class CmkChanges < AnsibleModule
  # zu den virtus attributen siehe https://solnic.codes/2011/06/06/virtus-attributes-for-your-plain-ruby-objects/
  attribute :user, String
  attribute :password, String
  attribute :url, String
  attribute :allow_foreign_changes, Boolean, default: false
  attribute :proxy_server, String
  attribute :proxy_port, String
  attribute :proxy_user, String
  attribute :proxy_password, String

  # mehr zu validations siehe https://guides.rubyonrails.org/active_record_validations.html
  validates :password, :user, :url, presence: true

  HTTParty::Basement.http_proxy(@proxy_server, @proxy_port, @proxy_user, @proxy_password)

  def main
    changed = false
    ret = request("activate_changes", {"allow_foreign_changes" => ( @allow_foreign_changes ? 1 : 0 )})
    exit_json(msg: ret, changed: false)
  end

  private

  def request(action, data=nil)
    options = ( data ? {:body => {:request => data.to_json}} : {} )
    #options = ( data ? {:body => data } : {} )
    ret = HTTParty.post("#{@url}/check_mk/webapi.py?action=#{action}&_username=#{@user}&_secret=#{@password}&request_format=python&output_format=json", options)
    JSON.parse(ret.to_s)
  end
end

CmkChanges.instance.run
