#!/bin/bash
# bashrc.ble.bash — ble.sh integration (sourced only when ble.sh is available)

# Load ble.sh with deferred attach
[[ $- == *i* ]] && source -- "$HOME/.local/share/blesh/ble.sh" --attach=none

# oh-my-posh + ble.sh performance optimization
# Pre-compute prompts in main shell to eliminate subshell forks during ble.sh rendering
# NOTE: Depends on oh-my-posh internals (tested with v29.x)
if [[ -v _omp_executable ]]; then
  _omp_hook() {
    _omp_status=$? _omp_pipestatus=("${PIPESTATUS[@]}")
    [[ -v BP_PIPESTATUS && ${#BP_PIPESTATUS[@]} -ge ${#_omp_pipestatus[@]} ]] && _omp_pipestatus=("${BP_PIPESTATUS[@]}")
    _omp_stack_count=$(("${#DIRSTACK[@]}" - 1))
    _omp_execution_time=-1
    if [[ $_omp_start_time ]]; then
      local omp_now
      printf -v omp_now '%(%s)T' -1
      omp_now=$((omp_now * 1000))
      _omp_execution_time=$((omp_now - _omp_start_time))
      _omp_no_status=false
    fi
    _omp_start_time=''
    [[ ${_omp_pipestatus[-1]} != "$_omp_status" ]] && _omp_pipestatus=("$_omp_status")
    set_poshcontext
    _omp_set_cursor_position

    local _args=(--shell=bash --shell-version="$BASH_VERSION"
      --status="$_omp_status" --pipestatus="${_omp_pipestatus[*]}"
      --no-status="$_omp_no_status" --execution-time="$_omp_execution_time"
      --stack-count="$_omp_stack_count" --terminal-width="${COLUMNS-0}")

    local primary
    primary=$("$_omp_executable" print primary --save-cache "${_args[@]}")
    primary=${primary//$'\0'/}
    PS1="${primary@P}"

    bleopt prompt_rps1="$("$_omp_executable" print right --save-cache "${_args[@]}" --escape=false)" 2>/dev/null

    # Transient prompt (green/red ❯)
    if (( _omp_status == 0 )); then
      bleopt prompt_ps1_final=$'\001\e[38;2;158;206;106m\002❯ \001\e[0m\002' 2>/dev/null
    else
      bleopt prompt_ps1_final=$'\001\e[38;2;247;118;142m\002❯ \001\e[0m\002' 2>/dev/null
    fi

    PS2='$(_omp_get_secondary)'
    shopt -s promptvars
    return $_omp_status
  }

  # EPOCHSECONDS-based timer (eliminates 2 subshell forks per command)
  # shellcheck disable=SC2016
  PS0='${_omp_start_time:0:$((_omp_start_time=EPOCHSECONDS*1000,0))}'
fi

# kiro-cli: detach/attach ble.sh for interactive sessions
kiro-cli() {
  case ${1-} in
    chat|inline)
      if [[ ${BLE_VERSION-} ]]; then
        ble-detach
        command kiro-cli "$@"
        ble-attach
      else
        command kiro-cli "$@"
      fi ;;
    *) command kiro-cli "$@" ;;
  esac
}

# Attach ble.sh (must be near the end)
[[ ! ${BLE_VERSION-} ]] || ble-attach
