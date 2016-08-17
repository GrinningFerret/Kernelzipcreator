# This as an automated flashable kernel zip generator.
Requires a java installation to run.

$ ./mkflashable -k=, --kernel-path="PATH" -o=, --output-name="FILENAME"

The signed zip can be found at the out folder, along with the matching md5sum.

You can customize the updater script (META-INF/com/google/android/updater-script) to your liking.


The signapk tool wasn't created by me. You can find the source
[here](https://android.googlesource.com/platform/build/+/master/tools/signapk/).
