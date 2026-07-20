local M = {}

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })

vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })

vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle reveal<CR>", { desc = "Toggle file explorer" })

vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
vim.keymap.set("n", "<leader>sg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Search current buffer" })
vim.keymap.set("n", "<leader>sd", "<cmd>Telescope diagnostics<CR>", { desc = "Search diagnostics" })
vim.keymap.set("n", "<leader>sh", "<cmd>Telescope help_tags<CR>", { desc = "Search help" })
vim.keymap.set("n", "<leader>sk", "<cmd>Telescope keymaps<CR>", { desc = "Search keymaps" })
vim.keymap.set("n", "<leader>sc", "<cmd>Telescope commands<CR>", { desc = "Search commands" })
vim.keymap.set("n", "<leader>ss", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Document symbols" })
vim.keymap.set("n", "<leader>sS", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", { desc = "Workspace symbols" })

vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineTogglePin<CR>", { desc = "Toggle buffer pin" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

vim.keymap.set("n", "[h", "<cmd>Gitsigns nav_hunk prev<CR>", { desc = "Previous Git hunk" })
vim.keymap.set("n", "]h", "<cmd>Gitsigns nav_hunk next<CR>", { desc = "Next Git hunk" })
vim.keymap.set("n", "<leader>ghs", "<cmd>Gitsigns stage_hunk<CR>", { desc = "Stage Git hunk" })
vim.keymap.set("n", "<leader>ghr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Reset Git hunk" })
vim.keymap.set("n", "<leader>ghp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Preview Git hunk" })
vim.keymap.set("n", "<leader>ghb", "<cmd>Gitsigns blame_line<CR>", { desc = "Blame Git line" })
vim.keymap.set("n", "<leader>ghd", "<cmd>Gitsigns diffthis<CR>", { desc = "Diff against index" })

vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Workspace diagnostics" })
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer diagnostics" })
vim.keymap.set(
  "n",
  "<leader>xr",
  "<cmd>Trouble lsp toggle focus=false win.position=right<CR>",
  { desc = "LSP references" }
)
vim.keymap.set("n", "<leader>cs", "<cmd>AerialToggle!<CR>", { desc = "Symbols outline" })

vim.keymap.set("n", "<leader>cf", function()
  local formatters = require("config.languages").formatters_by_ft()
  require("conform").format({
    async = true,
    lsp_format = formatters[vim.bo.filetype] and "never" or "fallback",
  })
end, { desc = "Format buffer" })

vim.keymap.set("n", "<leader>cl", function()
  require("lint").try_lint()
end, { desc = "Lint buffer" })

vim.keymap.set("n", "<leader>dc", function()
  require("dap").continue()
end, { desc = "Debug continue" })
vim.keymap.set("n", "<leader>db", function()
  require("dap").toggle_breakpoint()
end, { desc = "Toggle breakpoint" })
vim.keymap.set("n", "<leader>dB", function()
  require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Set conditional breakpoint" })
vim.keymap.set("n", "<leader>di", function()
  require("dap").step_into()
end, { desc = "Debug step into" })
vim.keymap.set("n", "<leader>do", function()
  require("dap").step_over()
end, { desc = "Debug step over" })
vim.keymap.set("n", "<leader>dO", function()
  require("dap").step_out()
end, { desc = "Debug step out" })
vim.keymap.set("n", "<leader>dt", function()
  require("dap").terminate()
end, { desc = "Terminate debugger" })
vim.keymap.set("n", "<leader>du", function()
  require("dapui").toggle()
end, { desc = "Toggle debug UI" })

vim.keymap.set("n", "<leader>tn", function()
  require("neotest").run.run()
end, { desc = "Run nearest test" })
vim.keymap.set("n", "<leader>tf", function()
  require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Run test file" })
vim.keymap.set("n", "<leader>ta", function()
  require("neotest").run.run(vim.uv.cwd())
end, { desc = "Run all tests" })
vim.keymap.set("n", "<leader>td", function()
  require("neotest").run.run({ strategy = "dap" })
end, { desc = "Debug nearest test" })
vim.keymap.set("n", "<leader>ts", function()
  require("neotest").summary.toggle()
end, { desc = "Toggle test summary" })
vim.keymap.set("n", "<leader>to", function()
  require("neotest").output.open({ enter = true })
end, { desc = "Show test output" })
vim.keymap.set("n", "<leader>tS", function()
  require("neotest").run.stop()
end, { desc = "Stop nearest test" })

vim.keymap.set("n", "<leader>rr", "<cmd>OverseerRun<CR>", { desc = "Run task" })
vim.keymap.set("n", "<leader>rt", "<cmd>OverseerToggle<CR>", { desc = "Toggle task list" })
vim.keymap.set("n", "<leader>ra", "<cmd>OverseerTaskAction<CR>", { desc = "Task action" })
vim.keymap.set("n", "<leader>ut", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Lazygit" })

vim.keymap.set("n", "<leader>qs", function()
  require("persistence").load()
end, { desc = "Restore directory session" })
vim.keymap.set("n", "<leader>qS", function()
  require("persistence").select()
end, { desc = "Select session" })
vim.keymap.set("n", "<leader>ql", function()
  require("persistence").load({ last = true })
end, { desc = "Restore last session" })
vim.keymap.set("n", "<leader>qd", function()
  require("persistence").stop()
end, { desc = "Stop session saving" })

function M.setup_lsp(bufnr)
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  map("n", "gd", vim.lsp.buf.definition, "Go to definition")
  map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
  map("n", "gri", vim.lsp.buf.implementation, "Go to implementation")
  map("n", "grr", vim.lsp.buf.references, "Go to references")
  map("n", "grn", vim.lsp.buf.rename, "Rename symbol")
  map({ "n", "x" }, "gra", vim.lsp.buf.code_action, "Code action")
  map("n", "K", vim.lsp.buf.hover, "Hover documentation")
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-keymaps", { clear = true }),
  callback = function(args)
    M.setup_lsp(args.buf)
  end,
})

return M
