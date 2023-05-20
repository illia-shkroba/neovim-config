local function try(f, ...)
  local status, result = pcall(f, ...)
  if status then
    return result
  else
    return nil
  end
end

local function require_safe(module_name)
  return try(require, module_name)
end

return {
  require_safe = require_safe,
  try = try,
}
