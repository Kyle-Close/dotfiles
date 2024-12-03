local js_based_languages = {
  "typescript",
  "javascript",
  "typescriptreact",
  "javascriptreact",
  "vue",
}

return {
  { "nvim-neotest/nvim-nio" },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      -- Highlight for stopped lines
      local Config = require("lazyvim.config")
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      -- Set up DAP signs
      for name, sign in pairs(Config.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      -- JavaScript/Node.js configurations (existing code)
      for _, language in ipairs(js_based_languages) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
          },
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch & Debug Chrome",
            url = function()
              local co = coroutine.running()
              return coroutine.create(function()
                vim.ui.input({
                  prompt = "Enter URL: ",
                  default = "http://localhost:3000",
                }, function(url)
                  if url == nil or url == "" then
                    return
                  else
                    coroutine.resume(co, url)
                  end
                end)
              end)
            end,
            webRoot = vim.fn.getcwd(),
            protocol = "inspector",
            sourceMaps = true,
            userDataDir = false,
          },
          {
            name = "----- ↓ launch.json configs ↓ -----",
            type = "",
            request = "launch",
          },
        }
      end
    end,

    dependencies = {
      {
        "leoluz/nvim-dap-go",
        opts = {
          dap_configurations = {
            {
              type = "go",
              name = "Debug Package with Args",
              request = "launch",
              program = "${workspaceFolder}",
              args = function()
                local input = vim.fn.input("Enter arguments: ")
                return vim.split(input, " ")
              end,
            },
          },
        },
      },
      -- Install the vscode-js-debug adapter
      {
        "microsoft/vscode-js-debug",
        -- After install, build it and rename the dist directory to out
        build = "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
        version = "1.*",
      },
      {
        "mxsdev/nvim-dap-vscode-js",
        config = function()
          ---@diagnostic disable-next-line: missing-fields
          require("dap-vscode-js").setup({
            -- Path of node executable. Defaults to $NODE_PATH, and then "node"
            -- node_path = "node",

            -- Path to vscode-js-debug installation.
            debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),

            -- Command to use to launch the debug server. Takes precedence over "node_path" and "debugger_path"
            -- debugger_cmd = { "js-debug-adapter" },

            -- which adapters to register in nvim-dap
            adapters = {
              "chrome",
              "pwa-node",
              "pwa-chrome",
              "pwa-msedge",
              "pwa-extensionHost",
              "node-terminal",
            },

            -- Path for file logging
            -- log_file_path = "(stdpath cache)/dap_vscode_js.log",

            -- Logging level for output to file. Set to false to disable logging.
            -- log_file_level = false,

            -- Logging level for output to console. Set to false to disable console output.
            -- log_console_level = vim.log.levels.ERROR,
          })
        end,
      },
      {
        "Joakker/lua-json5",
        build = "./install.sh",
      },
      {
        "williamboman/mason.nvim",
        opts = { ensure_installed = { "delve" } },
      },
    },
  },
}
