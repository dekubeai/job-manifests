#!/bin/bash -x

set -eo pipefail

echo "#########################"
echo "Job name: C-baichuan2-13b"
echo "#########################"

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

export DEKUBE_DATASET_PATH=/mnt/s3fs/datasets/databricks-dolly-15k-modified.json
export DEKUBE_MODEL_PATH=/mnt/s3fs/models/Baichuan/Baichuan2-13B-Base

export NCCL_P2P_DISABLE=1
export NCCL_IB_DISABLE=1
export NCCL_IGNORE_DISABLED_P2P=1
export NCCL_DEBUG=INFO

export NCCL_SOCKET_IFNAME=lo

cp /mnt/s3fs/scripts/C-baichuan2-13b/fine-tune.py ${iRESULTwrk}
cp /mnt/s3fs/scripts/C-baichuan2-13b/ds_config.json ${iRESULTwrk}
cd ${iRESULTwrk}


hostfile=""
deepspeed --hostfile=$hostfile fine-tune.py  \
    --report_to "none" \
    --data_path ${DEKUBE_DATASET_PATH} \
    --model_name_or_path ${DEKUBE_MODEL_PATH} \
    --output_dir ${iRESULTwrk} \
    --model_max_length 512 \
    --max_steps ${MAX_STEPS} \
    --num_train_epochs ${NUM_TRAIN_EPOCHS} \
    --per_device_train_batch_size 1 \
    --gradient_accumulation_steps 1 \
    --save_strategy epoch \
    --learning_rate 2e-5 \
    --lr_scheduler_type constant \
    --adam_beta1 0.9 \
    --adam_beta2 0.98 \
    --adam_epsilon 1e-8 \
    --max_grad_norm 1.0 \
    --weight_decay 1e-4 \
    --warmup_ratio 0.0 \
    --logging_steps 1 \
    --gradient_checkpointing True \
    --deepspeed ds_config.json \
    --bf16 True \
    --use_lora True \
    | tee /mnt/s3fs/results/${DEKUBE_TASK_DIGEST}/fine-tune.py_$(hostname).log
