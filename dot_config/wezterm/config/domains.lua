return {
   -- ref: https://wezfurlong.org/wezterm/config/lua/SshDomain.html
   ssh_domains = {
    -- {
    --   name = "Parallels CentOS 9", -- 配置标识域名
    -- remote_address = "10.211.55.6", -- 配置远程地址
    -- username = "smoose", -- 配置用户名
    --   ssh_backend = "Ssh2"
    -- },
  },

   -- ref: https://wezfurlong.org/wezterm/multiplexing.html#unix-domains
   unix_domains = {},

   -- ref: https://wezfurlong.org/wezterm/config/lua/WslDomain.html
   wsl_domains = {
   --    {
   --       name = 'WSL:Ubuntu',
   --       distribution = 'Ubuntu',
   --       username = 'kevin',
   --       default_cwd = '/home/kevin',
   --       default_prog = { 'fish', '-l' },
   --    },
   },
}
