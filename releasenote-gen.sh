#!/usr/bin/env bash
# shellcheck disable=SC2016

set -euo pipefail

VERSION="${1:-latest}"
CHANGELOG_FILE="${2:-CHANGELOG.md}"
RELEASENOTES_FILE="${3:-RELEASENOTES.md}"

# show script help
function show_help() {
    cat << EOF

    script to generate release-notes from a changelog

    \$1 -> version
    \$2 -> changelog file. default: '$CHANGELOG_FILE'
    \$3 -> release notes file. default: '$RELEASENOTES_FILE'

    usage:
        ./get_release_notes.sh <new_version>


    example:
        ./get_release_notes.sh "2.0.5"
    or
        ./get_release_notes.sh "latest"

EOF
    exit 0
}

# create changelog for release
function get_release_notes() {
    local matched_ver="${1}"

    if [[ -z "${VERSION}" ]]; then
        show_help
    fi

    echo "-> creating release-notes"

    if [[ "${VERSION,,}" == "latest" ]]; then
        matched_ver="$(grep -o -E "^##\s+\[[vV]?[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}\](\(.*\))?" "${CHANGELOG_FILE}" | head -n 1 | cut -d ' ' -f 2)"
    else
        matched_ver="$(grep -o -E "^##\s+\[[vV]?${matched_ver}\](\(.*\))?" "${CHANGELOG_FILE}" | head -n 1 | cut -d ' ' -f 2)"
    fi
    echo "+ matched line: ${matched_ver}"

    awk -v ver="${matched_ver}" \
        '/^##\s+/ { if (p) { exit }; if ($2 == ver) { p=1 } } p && NF' \
        "${CHANGELOG_FILE}" | tee "${RELEASENOTES_FILE}"

    echo "+ done"
}

# check options
case "${1}" in
    '--help' | '-h' | 'help')
        show_help
        ;;
    *)
        get_release_notes "${@}"
        ;;
esac
