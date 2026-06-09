return {
  {
    name = [[Macro surrounding line with ("p)prefix and ("s)uffix]],
    flow = function()
      vim.fn.setreg("q", [[^"pP$"sp]])
    end,
  },
}
