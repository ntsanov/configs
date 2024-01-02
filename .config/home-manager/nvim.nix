{ pkgs, ... }: {
  programs.neovim = let
    toLua = str: ''
      lua << EOF
      ${str}
      EOF
    '';
    #requireSetup = str: "lua << EOF\nrequire(\"${str}\").setup()\nEOF\n";
    requireSetup = name: config: toLua ''require("${name}").setup(${config})'';
    requireDefaultSetup = name: requireSetup "${name}" "{}";
    toLuaFile = file: ''
      lua << EOF
      ${builtins.readFile file}
      EOF
    '';
  in {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = with pkgs; [
      # Optional dependencies for telescope
      ripgrep
      fd
      lua-language-server
      marksman
      ansible-language-server
      openscad-lsp
      pgformatter
      stylua
      shfmt
      # sqlls - not in nix packges at this moment
      nixfmt
      golines
      gofumpt
      gotools
      delve
      nodePackages.bash-language-server
      nodePackages_latest.vscode-langservers-extracted
      nodePackages.typescript-language-server
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.yaml-language-server
      nodePackages.pyright
      nodePackages.vls
      nodePackages.prettier
    ];
    extraConfig = ''
      set list
      set clipboard=unnamedplus
      set number
      set relativenumber
      set shiftwidth=4
      set tabstop=4
      map <Space> <Leader>
      nnoremap <A-l> :tabNext<CR>
      nnoremap <A-h> :tabprevious<CR>
      nnoremap <A-1> :1tabnext<CR>
      nnoremap <A-2> :2tabnext<CR>
      nnoremap <A-3> :3tabnext<CR>
      nnoremap <A-4> :4tabnext<CR>
      nnoremap <A-5> :5tabnext<CR>
      nnoremap <A-6> :6tabnext<CR>
      nnoremap <A-7> :7tabnext<CR>
      nnoremap <A-8> :8tabnext<CR>
      nnoremap <A-9> :9tabnext<CR>
      nnoremap <leader>w :tabclose<CR>
      nnoremap <leader>tt :NvimTreeToggle<CR>
      nnoremap <leader>tf :NvimTreeFocus<CR>
      nnoremap <leader>tc :NvimTreeClose<CR>
    '';
    plugins = with pkgs.vimPlugins; [
      vim-nix
      vim-go
      solarized-nvim
      plenary-nvim
      # nvim-cmp dependencies
      cmp-path
      cmp-buffer
      cmp-nvim-lsp
      cmp-cmdline
      cmp-nvim-lsp-signature-help
      lspkind-nvim
      minimap-vim
      # TODO finish nvim-dap config
      {
        plugin = nvim-colorizer-lua;
        config = requireDefaultSetup "colorizer";

      }
      {
        plugin = nvim-dap-go;
        config = toLuaFile ./nvim/plugin/dap-go.lua;
      }
      nvim-dap
      nvim-dap-ui
      {
        plugin = nvim-autopairs;
        config = toLuaFile ./nvim/plugin/autopairs.lua;
      }
      {
        plugin = codewindow-nvim;
        config = toLuaFile ./nvim/plugin/codewindow.lua;
      }
      {
        plugin = gitsigns-nvim;
        config = toLuaFile ./nvim/plugin/gitsigns.lua;
      }
      {
        plugin = nvim-cmp;
        config = toLuaFile ./nvim/plugin/cmp.lua;
      }
      {
        plugin = formatter-nvim;
        config = toLuaFile ./nvim/plugin/formatter.lua;
      }
      {
        plugin = telescope-nvim;
        config = toLuaFile ./nvim/plugin/telescope.lua;
      }
      # {
      #   plugin = coc-nvim;
      #   config = toLuaFile ./nvim/plugin/coc.lua;
      # }
      {
        plugin = nvim-lspconfig;
        config = toLuaFile ./nvim/plugin/lspconfig.lua;
      }
      {
        plugin = nvim-treesitter;
        config = toLuaFile ./nvim/plugin/tree-splitter.lua;
      }
      {
        plugin = lualine-nvim;
        config = toLuaFile ./nvim/plugin/lualine.lua;
      }
      {
        plugin = nvim-tree-lua;
        config = requireDefaultSetup "nvim-tree";
      }
      {
        plugin = dashboard-nvim;
        config = requireDefaultSetup "dashboard";
      }
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
        p.go
        p.gosum
        p.gowork
        p.gomod
        p.python
        p.bash
        p.rust
        p.json
        p.javascript
        p.c
        p.nix
        p.vim
        p.vimdoc
        # p.sql - causes buffer overflow
        p.lua
        p.css
        p.html
        p.css
        p.awk
        p.yaml
        p.toml
        p.make
        p.regex
        p.pem
        p.gitignore
        p.gitcommit
      ]))
      {
        plugin = nvim-surround;
        config = requireDefaultSetup "nvim-surround";
      }
      {
        plugin = comment-nvim;
        config = requireDefaultSetup "Comment";
      }
      {
        plugin = gruvbox-nvim;
        config = "colorscheme gruvbox";
      }
      nvim-web-devicons
    ];
  };
}
