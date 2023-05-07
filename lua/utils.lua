function require_or(module_name, default)
  return require_safe(module_name) or default
end

function require_safe(module_name)
  return try(require, module_name)
end

function try(f, ...)
  local status, result = pcall(f, ...)
  if status then
    return result
  else
    return nil
  end
end

function dummy_ids(fields)
  local dummy = {}

  for _, field in ipairs(fields) do
    dummy[field] = id
  end

  return dummy
end

function id(x)
  return x
end

return {
  require_or = require_or,
  require_safe = require_safe,
  try = try,
  dummy_ids = dummy_ids,
  id = id,
}
