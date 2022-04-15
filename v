#!/bin/sh -u

usage() {
    echo "Usage:" 1>&2
    echo "    $0 [-e command] [path]" 1>&2
    echo ""
    echo "    e.g." 1>&2
    echo "        $0 -e \"cat -n\" /var/tmp" 1>&2
    echo ""
    echo "ENVIRONMENT" 1>&2
    echo "    VBINCMD=\"/usr/bin/open\"" 1>&2
    echo "    VTXTCMD=\"/bin/cat\"" 1>&2
    exit 1;
}

VBINCMD=${VBINCMD:-"/usr/bin/open"}
VTXTCMD=${VTXTCMD:-"/bin/cat"}

CMD=""
while getopts e:h flag; do
    case "$flag" in
    h) usage;;
    e) CMD="${OPTARG}";;
    \?) usage;;
    esac
done
shift $((OPTIND - 1))

FINDPATH=${1:-.}
FILE=$(find "${FINDPATH}"/ -type f | peco)
if [ -z "${CMD}" ]; then
    file "${FILE}" | grep text > /dev/null 2>&1
    if [ $? != 0 ]; then
        CMD=${VBINCMD}
    else
        CMD=${VTXTCMD}
    fi
fi

#set -x
${CMD} "${FILE}"
