#!/usr/bin/ruby
# version 23.02.2020
# todo: handle unset_attributes

require 'ansible_module'
# die folgende Zeile unbedingt stehen lassen, sonst werden die Modul-Parameter nicht im JSON-Format übergeben
# WANT_JSON
require "httparty"

class CmkUser < AnsibleModule
  # zu den virtus attributen siehe https://solnic.codes/2011/06/06/virtus-attributes-for-your-plain-ruby-objects/
  attribute :data, Hash # das ist der Hash in dem die Daten übergeben werden
  attribute :state, String
  attribute :user, String
  attribute :password, String
  attribute :url, String
  attribute :list, Boolean, default: false
  attribute :set_password_if_exist, Boolean, default: false
  attribute :debug, Boolean, default: false
  attribute :proxy_server, String
  attribute :proxy_port, String
  attribute :proxy_user, String
  attribute :proxy_password, String

  # mehr zu validations siehe https://guides.rubyonrails.org/active_record_validations.html
  validates :password, :user, :url, presence: true

  HTTParty::Basement.http_proxy(@proxy_server, @proxy_port, @proxy_user, @proxy_password)

  def main
    changed = false
    ret = request("get_all_users")
    all_users = ret["result"]
    exit_json(msg: all_users, changed: false) if @list
    #exit_json(msg: @data, changed: false)
    if @state == "present"
      #check if incoming users exist
      @data["users"].keys.each do |u|
        # if not not create
        unless all_users.has_key?(u)
          ret = request("add_users", {"users" => { u => @data["users"][u] }})
          #fail_json(msg: ret, add: {"users" => { u => @data["users"][u] }})
          changed = true
        else
          # check if some attributes are different
          income = @data["users"][u]
          income.delete "password" unless @set_password_if_exist
          now = all_users[u]
          after = now.clone
          after.update income
          #fail_json(msg: {after: after, now: now})
          if after != now
            edit_hash = { "set_attributes" => {} } # unset not implemented yet
            after.keys.each do |attrib|
              if after[attrib] != now[attrib]
                edit_hash["set_attributes"][attrib] = after[attrib]
              end
            end
            edit_data = {"users" => { u => edit_hash }}
            ret = request( "edit_users", edit_data )
            #fail_json(msg: ret, edit: edit_data)
            changed = true
          end
        end
      end
      exit_json(changed: changed)
    else
      fail_json(msg: "state #{@state} not implemented yet")
    end
  end

  private

  def request(action, data=nil)
    options = ( data ? {:body => {:request => data.to_json}} : {} )
    #options = ( data ? {:body => data } : {} )
    ret = HTTParty.post("#{@url}/check_mk/webapi.py?action=#{action}&_username=#{@user}&_secret=#{@password}&request_format=python&output_format=json", options)
    JSON.parse(ret.to_s)
  end
end

CmkUser.instance.run
