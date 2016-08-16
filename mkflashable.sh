#!/bin/bash
# © 2016 Luis Hagenauer
for i in "$@"; do
case $i in
    -k=*|--kernel-path=*)
    KERNEL_PATH="${i#*=}"
    shift
    ;;
    -o=*|--output-name=*)
    OUTPUT_NAME="${i#*=}"
    shift
    ;;
    *)
    ;;
  esac
done
    if [ -z $KERNEL_PATH ] || [ -z $OUTPUT_NAME ]
    then
    echo "You have to specifiy the kernel path (-k) and output name (-o).\n"
    exit 1
  fi
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    # Workaround for zip not allowing to zip a folder structure without the directories above it
    pushd $DIR > /dev/nul
    zip -qj /tmp/$OUTPUT_NAME.zip $KERNEL_PATH
    zip -ur /tmp/$OUTPUT_NAME.zip META-INF
    popd > /dev/nul
    mv /tmp/$OUTPUT_NAME.zip $DIR/out/$OUTPUT_NAME.zip
    java -jar $DIR/signapk.jar $DIR/testkey.x509.pem $DIR/testkey.pk8 $DIR/out/$OUTPUT_NAME.zip $DIR/out/signed_$OUTPUT_NAME.zip
    md5sum $DIR/out/signed_$OUTPUT_NAME.zip > $DIR/out/signed_$OUTPUT_NAME.zip.md5sum
    echo "Output: $DIR/out/signed_$OUTPUT_NAME.zip"
