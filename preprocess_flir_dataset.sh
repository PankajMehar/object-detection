#!/bin/bash
train_images="$HOME/Downloads/FLIR_ADAS/training/PreviewData"
validation_images="$HOME/Downloads/FLIR_ADAS/validation/PreviewData"
train_anns="$HOME/Downloads/FLIR_ADAS/training/Annotations"
validation_anns="$HOME/Downloads/FLIR_ADAS/validation/Annotations"
train_file="thermal_train.txt"
valid_file="thermal_validation.txt"
cfg_file="yolov3-thermal.cfg"
data_file="thermal.data"
name_file="thermal.names"
image_dir="$PWD/darknet/build/darknet/x64/data/thermal"

[ -f "$train_file" ] && rm "$train_file"
[ -f "$valid_file" ] && rm "$valid_file"


for value in {1..8862}
do
printf "data/thermal/FLIR_%05d.jpeg\n" $value >> "$train_file"
done
for value in {8863..10228}
do
printf "data/thermal/FLIR_%05d.jpeg\n" $value >> "$valid_file"
done

# Copy necessary files to correct directories
cp "$cfg_file"   "$PWD/darknet/build/darknet/x64/"
cp "$train_file" "$PWD/darknet/build/darknet/x64/data/"
cp "$valid_file" "$PWD/darknet/build/darknet/x64/data/"
cp "$data_file"  "$PWD/darknet/build/darknet/x64/data/"
cp "$name_file"  "$PWD/darknet/build/darknet/x64/data/"

# Copy images to correct directory
rm -rf "$image_dir"
mkdir "$image_dir"
cp "$train_images/"* "$image_dir" 2>/dev/null
cp "$validation_images/"* "$image_dir" 2>/dev/null

python convert_coco_yolo.py "$train_anns" "$image_dir"
python convert_coco_yolo.py "$validation_anns" "$image_dir"

# Download pretrained weight
wget https://pjreddie.com/media/files/darknet53.conv.74 -O "$PWD/darknet/build/darknet/x64/darknet53.conv.74"
