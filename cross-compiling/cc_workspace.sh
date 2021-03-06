#!/bin/bash

if [ -z "$1" ]; then
    echo "You must provide an absolute path to a workspace as positional argument!"
    echo "bash cc_workspace.sh /absolute/path/to/workspace"
    exit 1
fi

if [[ "$1" != /* ]]; then
    echo "You must provide an absolute path to a workspace, not a relative path:"
    echo "$1"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "The provided absolute path does not exist:"
    echo "$1"
    exit 1
fi

if [ -z "$TARGET_ARCHITECTURE" ]; then
    echo "Missing TARGET_ARCHITECTURE environment variables. Please run first"
    echo "source env.sh <TARGET_ARCHITECTURE_NAME>";
    exit 1;
fi

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

WORKSPACE_PATH=$1
SYSROOT_PATH="$THIS_DIR/sysroots/$TARGET_ARCHITECTURE"
TOOLCHAIN_PATH="$THIS_DIR/toolchains/generic_linux.cmake"
TOOLCHAIN_VARIABLES_PATH="$THIS_DIR/toolchains/"$TARGET_ARCHITECTURE".sh"

INTERACTIVE_DOCKER="-it"
COMMAND=(/bin/bash -c "source /root/.bashrc && bash /root/compilation_scripts/cross_compile.sh")

for i in "$@"
do
case $i in
    --no-it)
    INTERACTIVE_DOCKER=""
    shift
    ;;
    --debug)
    COMMAND=(bash)
    shift
    ;;
esac
done

if [ ! -d "$SYSROOT_PATH" ]; then
    echo "Sysroot for target architecture $TARGET_ARCHITECTURE not found. Looking for"
    echo "$SYSROOT_PATH"
    echo "Please run first get_sysroot.sh"
    exit 1
fi

docker run \
    $INTERACTIVE_DOCKER \
    --volume $WORKSPACE_PATH:/root/ws \
    --volume $SYSROOT_PATH:/root/sysroot \
    --volume $TOOLCHAIN_PATH:/root/ws/toolchainfile.cmake \
    --volume $TOOLCHAIN_VARIABLES_PATH:/root/cc_export.sh \
    -w="/root/ws" \
    ros2_cc_$TARGET_ARCHITECTURE \
    "${COMMAND[@]}"
