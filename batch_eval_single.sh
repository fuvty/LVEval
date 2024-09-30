model_path=$1
model_name=$2
model_max_len=$3
output_dir=$4
moa_config=$5

echo "output dir $output_dir"

# decide whether moa_config is empty
if [ -z "$moa_config" ]
then
    echo "moa_config is empty"
    cmd="python3 prediction.py --model-path $model_path --model-name $model_name --model-max-len $model_max_len --output-dir $output_dir --single-process"
else
    echo "moa_config is not empty"
    cmd="python3 prediction.py --model-path $model_path --model-name $model_name --model-max-len $model_max_len --output-dir $output_dir --single-process --moa_config $moa_config"
fi

echo $cmd
eval $cmd

cmd="python3 evaluation.py --input-dir $output_dir"
echo $cmd
eval $cmd
