#!/bin/bash -x

set -eo pipefail

echo "######################"
echo "Job name: C-llama2-70b"
echo "######################"

mkdir -p ${iRESULTwrk}
mkdir -p /mnt/s3fs/results/${DEKUBE_TASK_DIGEST}

[[ -z ${MAX_STEPS} ]] && export MAX_STEPS=-1

echo "#################"
echo "MAX_STEPS = ${MAX_STEPS}"
echo "#################"

[[ -z ${NUM_TRAIN_EPOCHS} ]] && export NUM_TRAIN_EPOCHS=1

echo "#####################"
echo "NUM_TRAIN_EPOCHS = ${NUM_TRAIN_EPOCHS}"
echo "#####################"

[[ -z ${CUDA_VISIBLE_DEVICES} ]] && export CUDA_VISIBLE_DEVICES=$(echo $(nvidia-smi --query-gpu=memory.free,index --format=csv,nounits,noheader | cut -f 2 -d " ") | tr " " , )

echo "#########################"
echo "CUDA_VISIBLE_DEVICES = ${CUDA_VISIBLE_DEVICES}"
echo "#########################"

export PYTORCH_CUDA_ALLOC_CONF="max_split_size_mb:128"

export DEKUBE_DATASET_PATH=/mnt/s3fs/datasets/databricks-dolly-15k.jsonl
export DEKUBE_MODEL_PATH=/mnt/s3fs/models/LLAMA2/metaAi/Llama-2-70b-chat-hf

export NCCL_P2P_DISABLE=1
export NCCL_IB_DISABLE=1
export NCCL_IGNORE_DISABLED_P2P=1
export NCCL_DEBUG=INFO

mkdir -p ${HOME}/.cache/huggingface/accelerate
idcfg="${HOME}/.cache/huggingface/accelerate/default_config.yaml"

##################################################
envsubst <<EOF > ${idcfg}
compute_environment: LOCAL_MACHINE
distributed_type: 'NO'
downcast_bf16: 'no'
gpu_ids: all
machine_rank: 0
main_process_ip: 127.0.0.1
main_process_port: 9898
main_training_function: main
mixed_precision: fp16
num_machines: 1
num_processes: 1
rdzv_backend: static
same_network: true
tpu_env: []
tpu_use_cluster: false
tpu_use_sudo: false
use_cpu: false
EOF
##################################################

cp /mnt/s3fs/scripts/C-llama2-70b/llama2-finetune.py ${iRESULTwrk}
cd ${iRESULTwrk}
sed -i '/sharded_ddp=.*/d' llama2-finetune.py

accelerate launch llama2-finetune.py | tee /mnt/s3fs/results/${DEKUBE_TASK_DIGEST}/llama2-finetune.py_$(hostname).log
