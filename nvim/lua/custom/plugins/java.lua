-- nvim-jdtls: Enhanced Java LSP support
-- Provides better jdtls integration than plain lspconfig,
-- including code actions, refactoring, and debugging support.
-- The actual configuration lives in ftplugin/java.lua

return {
  'mfussenegger/nvim-jdtls',
  ft = { 'java' }, -- Only load when opening Java files
}
