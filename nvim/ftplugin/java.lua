-- Java LSP configuration using nvim-jdtls
-- This file is automatically loaded when opening .java files (via ftplugin mechanism)

-- Prevent loading twice for the same buffer
if vim.b.jdtls_setup_done then
  return
end
vim.b.jdtls_setup_done = true

local jdtls = require 'jdtls'

-- Find the root directory of the Java project
local root_dir = require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle', 'build.gradle.kts' }

-- Use project name for workspace directory (each project gets its own workspace)
local project_name = vim.fn.fnamemodify(root_dir or vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath 'data' .. '/jdtls-workspace/' .. project_name

-- Find jdtls installed by Mason
local jdtls_path = vim.fn.stdpath 'data' .. '/mason/packages/jdtls'
local launcher_jar = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')

-- Determine the OS config directory
local os_config
if vim.fn.has 'mac' == 1 then
  os_config = 'config_mac'
elseif vim.fn.has 'unix' == 1 then
  os_config = 'config_linux'
else
  os_config = 'config_win'
end

local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', launcher_jar,
    '-configuration', jdtls_path .. '/' .. os_config,
    '-data', workspace_dir,
  },

  root_dir = root_dir,

  settings = {
    java = {
      signatureHelp = { enabled = true },
      completion = {
        favoriteStaticMembers = {
          'org.junit.Assert.*',
          'org.junit.Assume.*',
          'org.junit.jupiter.api.Assertions.*',
          'org.junit.jupiter.api.Assumptions.*',
          'org.junit.jupiter.api.DynamicContainer.*',
          'org.junit.jupiter.api.DynamicTest.*',
          'org.mockito.Mockito.*',
          'org.mockito.ArgumentMatchers.*',
          'org.mockito.Answers.*',
        },
        filteredTypes = {
          'com.sun.*',
          'io.micrometer.shaded.*',
          'java.awt.*',
          'jdk.*',
          'sun.*',
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
        },
        useBlocks = true,
      },
      configuration = {
        -- If you have multiple JDKs, you can configure them here
        -- runtimes = {
        --   { name = 'JavaSE-17', path = '/path/to/jdk-17' },
        --   { name = 'JavaSE-21', path = '/path/to/jdk-21' },
        -- },
      },
    },
  },

  -- nvim-jdtls specific: enable extended capabilities
  init_options = {
    bundles = {},
  },
}

-- Start or attach jdtls
jdtls.start_or_attach(config)

-- Java-specific keymaps (available only in Java buffers)
vim.keymap.set('n', '<leader>jo', function() jdtls.organize_imports() end, { buffer = true, desc = '[J]ava: [O]rganize Imports' })
vim.keymap.set('n', '<leader>jv', function() jdtls.extract_variable() end, { buffer = true, desc = '[J]ava: Extract [V]ariable' })
vim.keymap.set('v', '<leader>jv', function() jdtls.extract_variable { visual = true } end, { buffer = true, desc = '[J]ava: Extract [V]ariable' })
vim.keymap.set('n', '<leader>jc', function() jdtls.extract_constant() end, { buffer = true, desc = '[J]ava: Extract [C]onstant' })
vim.keymap.set('v', '<leader>jc', function() jdtls.extract_constant { visual = true } end, { buffer = true, desc = '[J]ava: Extract [C]onstant' })
vim.keymap.set('v', '<leader>jm', function() jdtls.extract_method { visual = true } end, { buffer = true, desc = '[J]ava: Extract [M]ethod' })
