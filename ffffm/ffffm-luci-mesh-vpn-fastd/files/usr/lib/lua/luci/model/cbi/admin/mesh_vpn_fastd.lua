local uci = luci.model.uci.cursor()
local util = luci.util

local f = SimpleForm('mesh_vpn', translate('Mesh VPN'))
f.template = "admin/expertmode"

local s = f:section(SimpleSection)

local o = s:option(Value, 'mode')
o.template = "gluon/cbi/mesh-vpn-fastd-mode"

local mtu = uci:get('fastd', 'mesh_vpn', 'mtu')
if util.contains(mtu, '1426') then
  o.default = '1426'
else
  o.default = '1280'
end

function f.handle(self, state, data)
  if state == FORM_VALID then
    local site = require 'gluon.site_config'

    local methods = {}
    if data.mode == 'performance' then
      table.insert(methods, 'null')
    end

    for _, method in ipairs(site.fastd_mesh_vpn.methods) do
      if method ~= 'null' then
	table.insert(methods, method)
      end
    end

    uci:set('fastd', 'mesh_vpn', 'mtu', mval)
    uci:save('fastd')
    uci:commit('fastd')
  end
end

return f
