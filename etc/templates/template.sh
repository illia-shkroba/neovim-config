#!/usr/bin/env sh

set -eu

main() {
  if [ "$#" -eq 0 ]; then
    help
    exit
  fi

  while [ "$#" -gt 0 ]; do
    case "$1" in
      '-h' | '--help')
        help
        exit
        ;;
      '--')
        shift
        break
        ;;
      *)
        break
        ;;
    esac
  done
}

help() {
  cat >&2 << 'EOF'
my-script - here is a helpful short description of what my-script does

Usage: my-script [-h|--help]

  Here is a helpful long description of what my-script does.

Available options:
  -h,--help                Show this help text
EOF
}

main "$@"
