#!/bin/bash
if [ ! -d "build" ]; then
    mkdir build
fi
cd build
file=`ls ../bmp`;
echo $file
for item in $file
do
filename=${item%.*}
command="format=bin_565_swap&cf=true_color&name=${filename}&img=../bmp/${item}"
echo ${command}
php $TOOL_PATH/lv_utils/img_conv_core.php ${command}
done
