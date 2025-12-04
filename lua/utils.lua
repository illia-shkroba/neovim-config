local M = {}

function M.try(f, ...)
  local status, result = pcall(f, ...)
  if status then
    return result
  else
    return nil
  end
end

return M
