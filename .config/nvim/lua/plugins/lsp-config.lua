return {
  "neovim/nvim-lspconfig",
  ---@class PluginLspOpts
  opts = {
    ---@type lspconfig.options
    servers = {
      solargraph = {
        cmd = { "bundle", "exec", "solargraph", "stdio" },
        settings = {
          solargraph = {
            diagnostics = true,
          },
        },
      },
      ts_ls = {
        settings = {
          typescript = {
            preferences = {
              importModuleSpecifierPreference = "shortest",
              importModuleSpecifier = "relative", -- Can also try "non-relative" or "project-relative"
              importModuleSpecifierEnding = "minimal",
              includePackageJsonAutoImports = "auto",
            },
            tsconfig = {
              baseUrl = "./",
              paths = {
                ["@components/*"] = { "src/components/*" },
                ["@utils/*"] = { "src/utils/*" },
              },
            },
          },
          javascript = {
            preferences = {
              importModuleSpecifier = "relative",
            },
          },
        },
      },
      -- pyright will be automatically installed with mason and loaded with lspconfig
      pyright = {},
      gopls = {
        settings = {
          gopls = {
            gofumpt = true,
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            analyses = {
              fieldalignment = true,
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
            semanticTokens = true,
          },
        },
      },
    },
    setup = {
      ts_ls = function(_, opts)
        require("lspconfig").tsserver.setup(opts)
      end,
      gopls = function(_, opts)
        -- workaround for gopls not supporting semanticTokensProvider
        -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
        LazyVim.lsp.on_attach(function(client, _)
          if not client.server_capabilities.semanticTokensProvider then
            local semantic = client.config.capabilities.textDocument.semanticTokens
            client.server_capabilities.semanticTokensProvider = {
              full = true,
              legend = {
                tokenTypes = semantic.tokenTypes,
                tokenModifiers = semantic.tokenModifiers,
              },
              range = true,
            }
          end
        end, "gopls")
        -- end workaround
      end,
    },
  },
}
