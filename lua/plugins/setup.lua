return function(module_name)
  local m = require("utils").require_safe(module_name)
  if type(m) == "table" and m.setup then
    return m.setup
  else
    return function() end
  end
end
