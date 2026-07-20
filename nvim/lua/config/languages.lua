local M = {}

local vue_language_server_path = vim.fn.stdpath("data")
  .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

local function filetype_map(filetypes, tools, options)
  local map = {}
  for _, filetype in ipairs(filetypes) do
    map[filetype] = vim.tbl_extend("force", vim.deepcopy(tools), options or {})
  end
  return map
end

local prettier = { "prettierd", "prettier" }
local prettier_fallback = { stop_after_first = true }

M.shared = {
  parsers = {
    "diff",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "query",
    "regex",
    "toml",
    "vim",
    "vimdoc",
    "yaml",
  },
}

M.stacks = {
  web = {
    parsers = {
      "css",
      "html",
      "javascript",
      "json",
      "jsonc",
      "tsx",
      "typescript",
      "vue",
    },
    lsp = {
      vtsls = {
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = vue_language_server_path,
                  languages = { "vue" },
                  configNamespace = "typescript",
                },
              },
            },
          },
        },
      },
      vue_ls = { filetypes = { "vue" } },
      html = {},
      cssls = {},
      jsonls = {},
      tailwindcss = {},
      eslint = {},
    },
    formatters = filetype_map({
      "css",
      "html",
      "javascript",
      "javascriptreact",
      "json",
      "jsonc",
      "scss",
      "typescript",
      "typescriptreact",
      "vue",
      "yaml",
    }, prettier, prettier_fallback),
    tools = { "prettierd", "prettier" },
    dap = { js = "js-debug-adapter" },
  },
  python = {
    parsers = { "python" },
    lsp = {
      basedpyright = {
        settings = {
          basedpyright = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              typeCheckingMode = "standard",
            },
          },
        },
      },
      ruff = {
        on_attach = function(client)
          client.server_capabilities.hoverProvider = false
        end,
      },
    },
    formatters = filetype_map({ "python" }, { "ruff_format" }),
    tools = { "ruff" },
    dap = { python = "debugpy" },
  },
  go = {
    parsers = { "go", "gomod", "gosum", "gowork" },
    lsp = {
      gopls = {
        settings = {
          gopls = {
            gofumpt = true,
            staticcheck = true,
            usePlaceholders = true,
          },
        },
      },
    },
    formatters = filetype_map({ "go" }, { "goimports", "gofumpt" }),
    linters = filetype_map({ "go" }, { "golangcilint" }),
    tools = { "goimports", "gofumpt", "golangci-lint" },
    dap = { delve = "delve" },
  },
  rust = {
    parsers = { "rust" },
    lsp = {
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            check = { command = "clippy" },
          },
        },
      },
    },
    formatters = filetype_map({ "rust" }, { "rustfmt" }),
    dap = { codelldb = "codelldb" },
  },
  c_cpp = {
    parsers = { "c", "cpp" },
    lsp = {
      clangd = {
        cmd = { "clangd", "--background-index" },
      },
    },
    formatters = filetype_map({ "c", "cpp" }, { "clang_format" }),
    tools = { "clang-format" },
    dap = { codelldb = "codelldb" },
  },
  lua = {
    parsers = { "lua", "luadoc" },
    lsp = {
      lua_ls = {
        settings = {
          Lua = {
            completion = { callSnippet = "Replace" },
            runtime = { version = "LuaJIT" },
            telemetry = { enable = false },
          },
        },
      },
    },
    formatters = filetype_map({ "lua" }, { "stylua" }),
    tools = { "stylua" },
  },
  shell = {
    parsers = { "bash" },
    lsp = {
      bashls = {},
    },
    formatters = filetype_map({ "bash", "sh", "zsh" }, { "shfmt" }),
    linters = filetype_map({ "bash", "sh", "zsh" }, { "shellcheck" }),
    tools = { "shfmt", "shellcheck" },
    dap = { bash = "bash-debug-adapter" },
  },
  markdown = {
    parsers = { "markdown", "markdown_inline" },
    lsp = {
      marksman = {},
    },
    formatters = filetype_map({ "markdown", "markdown.mdx" }, prettier, prettier_fallback),
    linters = filetype_map({ "markdown", "markdown.mdx" }, { "markdownlint-cli2" }),
    tools = { "prettierd", "prettier", "markdownlint-cli2" },
  },
}

function M.treesitter_parsers()
  local parsers = {}
  local seen = {}

  local function add(items)
    for _, parser in ipairs(items or {}) do
      if not seen[parser] then
        seen[parser] = true
        table.insert(parsers, parser)
      end
    end
  end

  add(M.shared.parsers)
  for _, stack in pairs(M.stacks) do
    add(stack.parsers)
  end

  table.sort(parsers)
  return parsers
end

function M.treesitter_install_parsers()
  return vim.tbl_filter(function(parser)
    -- nvim-treesitter registers the json parser for the jsonc filetype.
    return parser ~= "jsonc"
  end, M.treesitter_parsers())
end

function M.lsp_servers()
  local servers = {}

  for _, stack in pairs(M.stacks) do
    for name, config in pairs(stack.lsp or {}) do
      servers[name] = vim.deepcopy(config)
    end
  end

  return servers
end

local function tools_by_filetype(field)
  local map = {}

  for _, stack in pairs(M.stacks) do
    for filetype, tools in pairs(stack[field] or {}) do
      map[filetype] = vim.deepcopy(tools)
    end
  end

  return map
end

function M.formatters_by_ft()
  return tools_by_filetype("formatters")
end

function M.linters_by_ft()
  return tools_by_filetype("linters")
end

function M.mason_tools()
  local tools = {}
  local seen = {}

  for _, stack in pairs(M.stacks) do
    for _, tool in ipairs(stack.tools or {}) do
      if not seen[tool] then
        seen[tool] = true
        table.insert(tools, tool)
      end
    end
  end

  table.sort(tools)
  return tools
end

local function dap_values(value_selector)
  local values = {}
  local seen = {}

  for _, stack in pairs(M.stacks) do
    for adapter, package in pairs(stack.dap or {}) do
      local value = value_selector(adapter, package)
      if not seen[value] then
        seen[value] = true
        table.insert(values, value)
      end
    end
  end

  table.sort(values)
  return values
end

function M.dap_adapters()
  return dap_values(function(adapter)
    return adapter
  end)
end

function M.mason_dap_packages()
  return dap_values(function(_, package)
    return package
  end)
end

return M
