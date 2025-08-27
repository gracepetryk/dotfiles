local env = vim.fn.environ()

local jdtls_path = vim.fn.stdpath('data') .. '/mason/packages/jdtls'

local root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1])
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

local lombok_jar = jdtls_path .. '/lombok.jar'

local data_dir = env['HOME'] .. '/.jdtls/' .. project_name

local config = {
    cmd = {
        vim.fn.exepath('jdtls'),
        '--java-executable', env.JAVA_21_HOME .. '/bin/java',
        '--jvm-arg=-javaagent:' .. lombok_jar,
        '-configuration', jdtls_path .. '/config_mac',
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
