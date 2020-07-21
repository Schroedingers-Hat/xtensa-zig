# shellcheck disable=SC2128,SC2169,SC2039 # ignore array expansion warning
if [ -n "${BASH_SOURCE}" ] && [ "${BASH_SOURCE[0]}" = "${0}" ]
then
    echo "This script should be sourced, not executed:"
    # shellcheck disable=SC2039  # reachable only with bash
    echo ". ${BASH_SOURCE[0]}"
    return 1
fi

# shellcheck disable=SC2128,SC2169,SC2039 # ignore array expansion warning
if [ -n "${BASH_SOURCE}" ] && [ "${BASH_SOURCE[0]}" = "${0}" ]
then
    echo "This script should be sourced, not executed:"
    # shellcheck disable=SC2039  # reachable only with bash
    echo ". ${BASH_SOURCE[0]}"
    return 1
fi

self_path="${BASH_SOURCE}"

script_name="$(readlink -f "${self_path}")"
script_dir="$(dirname "${script_name}")"

ZIG_DIR=${script_dir}/out/zig-install
if [ -f "${ZIG_DIR}/bin/zig" ]
then
    export PATH=${script_dir}/out/bin:$PATH
    cd "${script_dir}/esp-idf"
    source "${script_dir}/esp-idf/export.sh"
    echo "${script_dir}"
    cd "${script_dir}"
else
    echo "Couldn't find zig, something went wrong."
fi

