local status, cmp = pcall(require, "cmp")
if (not status) then return end

local lspkind = require("lspkind")

local source_mapping = {
  buffer = "[Buffer]",
  nvim_lsp = "[LSP]",
  cmp_tabnine = "[TN]",
  path = "[Path]",
}

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-j>'] = function()
      if cmp.visible() then
        cmp.select_next_item()
      end
    end,
    ['<C-k>'] = function()
      if cmp.visible() then
        cmp.select_prev_item()
      end
    end,
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true
    }),
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
  }),
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = lspkind.presets.default[vim_item.kind]
      local menu = source_mapping[entry.source.name]

      if entry.source.name == "cmp_tabnine" then
        if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
          menu = entry.completion_item.data.detail .. " " .. menu
        end
        vim_item.kind = ""
      end
      vim_item.menu = menu
      return vim_item
    end,
  },
  sources = cmp.config.sources({
    { name = 'cmp_tabnine' },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'luasnip' },
  }),
})

local tabnine = require("cmp_tabnine.config")
tabnine:setup({
  max_lines = 1000,
  max_num_results = 20,
  sort = true,
  run_on_every_keystroke = true,
  snippet_placeholder = "..",
})

vim.cmd [[
  set completeopt=menuone,noinsert,noselect
  highlight! default link CmpItemKind CmpItemMenuDefault
]]
