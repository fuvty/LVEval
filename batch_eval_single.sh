model_path=$1
model_name=$2
model_max_len=$3
output_dir=$4
lut_path=$5

echo "output dir $output_dir"

# decide whether lut_path is empty
if [ -z "$lut_path" ]
then
    echo "lut_path is empty"
    cmd="python3 prediction.py --model-path $model_path --model-name $model_name --model-max-len $model_max_len --output-dir $output_dir --single-process"
else
    echo "lut_path is not empty"
    cmd="python3 prediction.py --model-path $model_path --model-name $model_name --model-max-len $model_max_len --output-dir $output_dir --single-process --lut_path $lut_path"
fi

echo $cmd
eval $cmd

cmd="python3 evaluation.py --input-dir $output_dir"
echo $cmd
eval $cmd
