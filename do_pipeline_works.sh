#!/usr/bin/expect

# max. 10 seconds waiting for the server response
set timeout 10

set user ecchen
set pass rae0ooJ_eic5bah5
set host 140.112.51.222
set styleTransferDir ~/NTU2017DeepArt/src/chainer-fast-neuralstyle
set model_dir ~/NTU2017DeepArt/src/chainer-fast-neuralstyle/models
set input_dir ~/NTU2017DeepArt/ForApp/imagesFromApp
set output_dir ~/NTU2017DeepArt/ForApp/imagesToApp
set photo_path [lindex $argv 0]
set output_path [lindex $argv 1]
set photo_name [exec basename $photo_path]
set model [lindex $argv 2]

# Upload files to "input_dir"
spawn rsync -avzhe ssh $photo_path $user@$host:$input_dir
expect "password:"
send "$pass\r"
interact
close $spawn_id


# Connect to cluster
spawn ssh $user@$host
expect "password:"
send "$pass\r"
expect "$ "

# delete previous transformed images
send "cd $output_dir\r"
expect "$ "
send "rm *.jpg\r"
expect "$ "

# Change directory to where script is saved.
send "cd $styleTransferDir\r"
expect "$ "

# Execute script on cluster
send "python generate.py $input_dir/$photo_name -m $model_dir/$model -o $output_dir/$photo_name -g 0\r"
expect "$ "


# delete upload images
send "cd $input_dir\r"
expect "$ "
send "rm *.jpg\r"
expect "$ "

# Disconnect
send "exit\r"
expect eof
close $spawn_id

# Download output file from "output_dir"
spawn rsync -avzhe ssh $user@$host:$output_dir $output_path
expect "password:"
send "$pass\r"

interact
