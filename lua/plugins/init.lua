return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    lazy = false,
    config = function()
      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      local language_servers = vim.lsp.get_clients() -- or list servers manually like {'gopls', 'clangd'}
      for _, ls in ipairs(language_servers) do
        require("lspconfig")[ls].setup {
          capabilities = capabilities,
          -- you can add other fields for setting up lsp server in this table
        }
      end

      require("ufo").setup {
        provider_selector = function(bufnr, filetype, buftype)
          return { "treesitter", "indent" }
        end,
      }
    end,
  },

  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      vim.keymap.set("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', {
        desc = "Toggle Spectre",
      })
      vim.keymap.set("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
        desc = "Search current word",
      })
      vim.keymap.set("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
        desc = "Search current word",
      })
      vim.keymap.set("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
        desc = "Search on current file",
      })
    end,
  },

  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      vim.g.copilot_proxy = "http://127.0.0.1:2080"
      require("copilot").setup {
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-\\>",
          },
          layout = {
            position = "bottom", -- | top | left | right | horizontal | vertical
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = false,
          debounce = 100,
          filetypes = {
            yaml = false,
            markdown = false,
            help = false,
            gitcommit = false,
            gitrebase = false,
            hgcommit = false,
            svn = false,
            cvs = false,
            ["."] = false,
          },
          keymap = {
            accept_word = "<M-l>",
            accept_line = "<M-j>",
            accept = "<M-a>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
      }
    end,
  },

  {
    "smoka7/hop.nvim",
    version = "*",
    opts = {},
    lazy = false,
    enabled = true,
    config = function()
      local hop = require "hop"
      hop.setup { keys = "etovxqpdygfblzhckisuran", multi_windows = true }
      vim.keymap.set("", "<A-,>f", function()
        hop.hint_char1 { current_line_only = false }
      end, { remap = true })
      vim.keymap.set("", "<A-,>t", function()
        hop.hint_char2 { current_line_only = false }
      end, { remap = true })
      vim.keymap.set("", "<A-,>v", function()
        hop.hint_vertical { current_line_only = false }
      end, { remap = true })
      vim.keymap.set("", ",,", function()
        hop.hint_words { current_line_only = false, multi_windows = true }
      end, { remap = true })
      vim.keymap.set("", ",.", function()
        hop.hint_camel_case { current_line_only = false, multi_windows = true }
      end, { remap = true })
    end,
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      settings = {
        save_on_toggle = true,
      },
    },
    keys = function()
      local keys = {
        {
          "<leader>H",
          function()
            require("harpoon"):list():add()
          end,
          desc = "Harpoon File",
        },
        {
          "<leader>h",
          function()
            local harpoon = require "harpoon"
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "Harpoon Quick Menu",
        },
        {
          "<M-x>",
          function()
            require("harpoon"):list():next()
          end,
          desc = "Harpoon Next",
        },
        {
          "<M-z>",
          function()
            require("harpoon"):list():prev()
          end,
          desc = "Harpoon Prev",
        },
      }

      local slots = { "q", "w", "e", "r", "t" }

      for i = 1, 5 do
        table.insert(keys, {
          "<M-" .. slots[i] .. ">",
          function()
            require("harpoon"):list():select(i)
          end,
          desc = "Harpoon to File " .. i,
        })
      end

      return keys
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      -- local dap, dapui = require "dap", require "dapui"
      -- dapui.setup()
      -- dap.listeners.before.attach.dapui_config = function()
      --   dapui.open()
      -- end
      -- dap.listeners.before.launch.dapui_config = function()
      --   dapui.open()
      -- end
      -- dap.listeners.before.event_terminated.dapui_config = function()
      --   dapui.close()
      -- end
      -- dap.listeners.before.event_exited.dapui_config = function()
      --   dapui.close()
      -- end
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "jbyuki/one-small-step-for-vimkind",
      "mxsdev/nvim-dap-vscode-js",
    },
    keys = function()
      local dap = require "dap"
      local dapui = require "dapui"

      return {
        { "<leader>da", dap.continue, desc = "Continue" },
        { "<leader>de", dap.run_to_cursor, desc = "Run to cursor" },
        { "<leader>dd", dap.step_over, desc = "Step over" },
        { "<leader>df", dap.step_into, desc = "Step into" },
        { "<leader>dg", dap.step_out, desc = "Step out" },
        { "<leader>dr", dap.restart, desc = "Restart" },
        { "<leader>ds", dap.pause, desc = "Pause" },
        { "<leader>du", dapui.toggle, desc = "Toggle debug UI" },
        { "<leader>dv", dap.toggle_breakpoint, desc = "Toggle breakpoint" },
        { "<leader>dt", dap.terminate, desc = "Terminate" },
      }
    end,
    config = function()
      local dap = require "dap"

      -- Configure the JavaScript debug adapter
      require("dap-vscode-js").setup {
        debugger_path = require("mason-registry").get_package("js-debug-adapter"):get_install_path(),
        debugger_cmd = { "js-debug-adapter" },
        adapters = {
          "pwa-node",
          "pwa-chrome",
          "pwa-msedge",
          "node-terminal",
          "pwa-extensionHost",
        },
      }

      -- Configure the nlua adapter
      dap.adapters.nlua = function(callback, config)
        callback {
          type = "server",
          host = config.host or "127.0.0.1",
          port = config.port or 8086,
        }
      end

      -- Define the configuration for Lua
      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "Attach to running Neovim instance",
          host = function()
            return vim.fn.input "Host [127.0.0.1]: " or "127.0.0.1"
          end,
          port = function()
            return tonumber(vim.fn.input "Port: ")
          end,
        },
      }

      dap.configurations["javascript"] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
          skipFiles = { "<node_internals>/**" },
        },
        {
          command = "npm run dev",
          name = "Debug with npm run dev",
          request = "launch",
          type = "node-terminal",
          cwd = "${workspaceFolder}",
          skipFiles = {
            "<node_internals>/**",
          },
        },
        {
          command = "npm run dev",
          name = "Debug with npm run dev pwa-node",
          request = "launch",
          type = "pwa-node",
          cwd = "${workspaceFolder}",
          skipFiles = {
            "<node_internals>/**",
          },
        },
      }

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = {
          command = "js-debug-adapter",
          args = {
            "${port}",
          },
        },
      }

      dap.adapters["node-terminal"] = {
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        -- Because of mason we can use this command directly
        executable = {
          command = "js-debug-adapter",
          args = {
            "${port}",
          },
        },
      }

      dap.adapters["node"] = {
        type = "server",
        host = "::1",
        port = "${port}",
        -- Because of mason we can use this command directly
        executable = {
          command = "js-debug-adapter",
          args = {
            "${port}",
          },
        },
      }

      local dapui = require "dapui"
      -- Set up DAP UI
      dapui.setup()

      -- Automatically open DAP UI when debugging starts
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end

      -- Close DAP UI when debugging ends
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
