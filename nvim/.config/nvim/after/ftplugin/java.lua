local env = vim.fn.environ()

local jdtls_path = vim.fn.stdpath('data') .. '/mason/packages/jdtls'

local root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1])
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

local data_dir = env['HOME'] .. '/.jdtls/' .. project_name

local config = {
    cmd = {

        -- 💀
        env.JAVA_21_HOME .. '/bin/java',

        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-javaagent:' .. jdtls_path .. '/lombok.jar',

        -- 💀
        '-jar', jdtls_path .. '/plugins/org.eclipse.equinox.launcher_1.7.0.v20250331-1702.jar',
        --                                                                       ^^^^^^^^^^^^^^
        --                                                                       Change this to
        --                                                                       the actual version


        -- 💀
        '-configuration', jdtls_path .. '/config_mac',


        -- 💀
        -- See `data directory configuration` section in the README
        '-data', data_dir
    },
    root_dir = root_dir,
    settings = {
        java = {
            configuration = {
                runtimes = {
                    {
                        name = 'JavaSE-17',
                        path = env['JAVA_HOME']
                    },
                    {
                        name = 'JavaSE-21',
                        path = env['JAVA_21_HOME']
                    }
                }
            }
        }
    }
}

require('jdtls').start_or_attach(config)
