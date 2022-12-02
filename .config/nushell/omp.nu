export-env {
    let-env POWERLINE_COMMAND = 'oh-my-posh'
    let-env POSH_THEME = $"($env.HOME)/.config/theme.omp.yaml"
    let-env PROMPT_INDICATOR = ""
    # By default displays the right prompt on the first line
    # making it annoying when you have a multiline prompt
    # making the behavior different compared to other shells
    let-env PROMPT_COMMAND_RIGHT = {''}
    let-env NU_VERSION = (version | get version)
    let omp_path = $"($env.HOME)/.nix-profile"

    # PROMPTS
    let-env PROMPT_MULTILINE_INDICATOR = (^$"($omp_path)/bin/oh-my-posh" print secondary $"--config=($env.POSH_THEME)" --shell=nu $"--shell-version=($env.NU_VERSION)")

    let-env PROMPT_COMMAND = {
        # We have to do this because the initial value of `$env.CMD_DURATION_MS` is always `0823`,
        # which is an official setting.
        # See https://github.com/nushell/nushell/discussions/6402#discussioncomment-3466687.
        let cmd_duration = if $env.CMD_DURATION_MS == "0823" { 0 } else { $env.CMD_DURATION_MS }

        let width = ((term size).columns | into string)
        ^$"($omp_path)/bin/oh-my-posh" print primary $"--config=($env.POSH_THEME)" --shell=nu $"--shell-version=($env.NU_VERSION)" $"--execution-time=($cmd_duration)" $"--error=($env.LAST_EXIT_CODE)" $"--terminal-width=($width)"
    }
}
