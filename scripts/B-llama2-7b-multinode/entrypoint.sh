#!/bin/bash -x

set -eo pipefail

echo "###############################"
echo "Job name: B-llama2-7b-multinode"
echo "###############################"

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
export DEKUBE_MODEL_PATH=/mnt/dekube/models/LLAMA2/metaAi/Llama-2-7b-chat-hf

export NCCL_P2P_DISABLE=1
export NCCL_IB_DISABLE=1
export NCCL_IGNORE_DISABLED_P2P=1
export NCCL_DEBUG=INFO

mkdir -p ${HOME}/.cache/huggingface/accelerate
idcfg="${HOME}/.cache/huggingface/accelerate/default_config.yaml"


# Get ip/hostname of the main process machine
env | grep TF_CONFIG 2>&1 > /dev/null
if [ $? -eq 1 ];then
  # if there is no TF_CONFIG variable it means that there is only one machine
  IRANK=0
  IPSHOST=127.0.0.1
  NUM_NODES=1
else
  cluster_len=$(echo ${TF_CONFIG} | jq '.cluster | length')
  if [ ${cluster_len} -eq 1 ];then
    # If there is only one type (PS or WORKER) - we can use index as is 
    IRANK=$(echo ${TF_CONFIG} | jq .task.index)
    IPSHOST=$(echo ${TF_CONFIG} | jq -r '.cluster | .[] | .[0]'  |  cut -f 1 -d : )
    NUM_NODES=$(echo ${TF_CONFIG} | jq '.cluster | .[] | length')
  elif [ ${cluster_len} -eq 2 ];then
    if [ $(echo ${TF_CONFIG} | jq -r .task.type) == "ps" ];then
      # For PS we'll use index as is
      IRANK=$(echo ${TF_CONFIG} | jq .task.index)
    else
      # For WORKER we'll use it's own index increased by quantity of PS
      psnum=$(echo ${TF_CONFIG} | jq '.cluster.ps | length')
      IRANK=$(( $(echo ${TF_CONFIG} | jq .task.index) + ${psnum} ))
    fi
    IPSHOST=$(echo ${TF_CONFIG} | jq -r '.cluster.ps[0]'  |  cut -f 1 -d : )
    NUM_NODES=$(( $(echo ${TF_CONFIG} | jq '.cluster.ps | length') + $(echo ${TF_CONFIG} | jq '.cluster.worker | length') ))
  else
    echo "Abnormal cluster length"
    echo "Exiting..."
    exit 1
  fi
fi


### debug
echo "TF_CONFIG = $TF_CONFIG"
echo "IRANK = $IRANK"
echo "IPSHOST = $IPSHOST"
echo "NUM_NODES = $NUM_NODES"
###


iRESULTwrk_=${iRESULTwrk}
[ $IRANK -eq 0 ] || iRESULTwrk=/mnt/wrkSlave
mkdir -p ${iRESULTwrk}

##################################################
envsubst <<EOF > ${idcfg}
compute_environment: LOCAL_MACHINE
distributed_type: MULTI_GPU
downcast_bf16: 'no'
gpu_ids: all
machine_rank: ${IRANK}
main_process_ip: ${IPSHOST}
main_process_port: 9898
main_training_function: main
mixed_precision: fp16
num_machines: $NUM_NODES
num_processes: $NUM_NODES
rdzv_backend: static
same_network: true
tpu_env: []
tpu_use_cluster: false
tpu_use_sudo: false
use_cpu: false
EOF
##################################################


cp /mnt/s3fs/scripts/B-llama2-7b-multinode/llama2-finetune.py ${iRESULTwrk}
cd ${iRESULTwrk}

# accelerate launch llama2-finetune.py | tee ${iRESULTwrk}/llama2-finetune.py_$(hostname).log
# [ $IRANK -eq 0 ] || cp ${iRESULTwrk}/llama2-finetune.py_$(hostname).log ${iRESULTwrk_}

accelerate launch llama2-finetune.py | tee /mnt/s3fs/results/${DEKUBE_TASK_DIGEST}/llama2-finetune.py_$(hostname).log
