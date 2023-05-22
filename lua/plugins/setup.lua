return function(module_name, field)
  local field = field or "setup"

  local m = require("utils").require_safe(module_name)
  if type(m) == "table" and m[field] then
    return m[field]
  else
    return function() end
  end
end
