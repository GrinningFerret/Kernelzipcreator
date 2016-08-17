#!/bin/bash
# © 2016 Luis Hagenauer
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
for i in "$@"; do
case $i in
    -k=*|--kernel-path=*)
    KERNEL_PATH="${i#*=}"
    eval KERNEL_PATH=$KERNEL_PATH
    shift
    ;;
    -o=*|--output-name=*)
    OUTPUT_NAME="${i#*=}"
    shift
    ;;
    -c|--clean)
    echo "Cleaning output directory"
    rm -rf $DIR/out/*
    exit 0;
    shift
    ;;
    -h|--help)
    echo -e "Usage: mkflashable [options...]\nOptions:\n"
    echo "   -k, --kernel-path='FILEPATH'  Specify the kernel path"
    echo "   -o, --output-name='NAME'      Specify the output name"
    echo "   -c, --clean                   Clean the output directory"
    echo "   -h, --help                    Display this help message"
    exit 0;
    shift
    ;;
    *)
    ;;
  esac
done
    if [ -z $KERNEL_PATH ] || [ -z $OUTPUT_NAME ]
      then
          echo "You have to specifiy the kernel path (-k) and output name (-o)."
          exit 1
    fi
    # Clean
    rm -f /tmp/$OUTPUT_NAME.zip
    # Workaround for zip not allowing to zip a folder structure without the directories above it
    pushd $DIR > /dev/null
    zip -qj /tmp/$OUTPUT_NAME.zip $KERNEL_PATH
    zip -ur /tmp/$OUTPUT_NAME.zip META-INF > /dev/null
    popd > /dev/null
    java -jar $DIR/signapk.jar $DIR/testkey.x509.pem $DIR/testkey.pk8 /tmp/$OUTPUT_NAME.zip $DIR/out/signed_$OUTPUT_NAME.zip && rm /tmp/$OUTPUT_NAME.zip
    md5=($(md5sum $DIR/out/signed_$OUTPUT_NAME.zip))
    echo "$md5 $(basename $DIR/out/signed_$OUTPUT_NAME.zip)" > $DIR/out/signed_$OUTPUT_NAME.zip.md5sum
    echo "Output: $DIR/out/signed_$OUTPUT_NAME.zip"
