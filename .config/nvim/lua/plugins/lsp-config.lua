return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- TypeScript / JavaScript (new name in lspconfig is ts_ls)
      ts_ls = {
        settings = {
          typescript = {
            preferences = {
              importModuleSpecifierPreference = "shortest",
              importModuleSpecifier = "relative",
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
      omnisharp = {
        -- Use your Mason shim with correct case
        cmd = {
          vim.fn.stdpath("data") .. "/mason/bin/OmniSharp",
          "--languageserver",
          "--encoding",
          "utf-8",
          "--hostPID",
          tostring(vim.fn.getpid()), -- be explicit
          "-z",
          "--loglevel",
          "debug", -- log, but...
          "--logfile",
          vim.fn.stdpath("state") .. "/omnisharp.log", -- ...to a file, not stdout
        },
        -- Your project root detection (works with .sln/.csproj/.git)
        root_dir = function(fname)
          local util = require("lspconfig.util")
          return util.root_pattern("*.sln", "*.csproj", ".git")(fname) or util.path.dirname(fname)
        end,
        autostart = true,
      },
    },
  },
}
