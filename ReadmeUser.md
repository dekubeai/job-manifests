# Finetuning models

<br />

You have to prepare everything you need for finetuning (more detailed information at the botom of this page):
- Base model
- Dataset
- Scripts

<br />

There are 2 ways to play with it:
- Launch finetuning through Dekube cabinet
- Launch finetuning locally

<br />


## Launch finetuning through Dekube cabinet

You have scripts for three model:
- llama2-7b - Llama 2 is a collection of pretrained and fine-tuned generative text models ranging in scale 7 billion parameters. 
- baichuan2-7b - Baichuan 2 is the new generation of open-source large language models launched by Baichuan Intelligent Technology. 
- -llama2-70b - Llama 2 is a collection of pretrained and fine-tuned generative text models ranging in scale 70 billion parameters.
You have three way for run tasks:
- Launch preconfigured, simple task ```A-xxxxx```. 
- Launch task with own dataset ```B-xxxxx```.
- Launch task with own dataset and model ```C-xxxxx```.

### Launch A-XXXX task
1. Start the process of creating a task in your account.
2. Select yaml file - ```scripts\A-xxxxx\job.yaml```.
3. Select cluster and run task.
4. After end the task see result in s3 bucket. All resul present in folder results, where `sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc` bucket name
```
C:\test\dekube>mc ls dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/                                                                                                              

[2024-04-26 10:20:59 MSK]     0B results/ 
```
5. Task results present in path `dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/results/oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg/wrk/output` Where `sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc` -backet name, `oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg` - task digest.
```
C:\test\dekube>mc ls dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/results/oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg/wrk/output                
[2024-04-26 10:13:00 MSK]    93B STANDARD README.md                                                                                                              
[2024-04-26 10:13:00 MSK]   497B STANDARD adapter_config.json                                                                                                    
[2024-04-26 10:13:00 MSK] 1.0MiB STANDARD adapter_model.bin                                                                                                      
[2024-04-26 10:13:00 MSK]    42B STANDARD added_tokens.json                                                                                                      
[2024-04-26 10:13:00 MSK]    96B STANDARD special_tokens_map.json                                                                                                
[2024-04-26 10:13:00 MSK] 1.9MiB STANDARD tokenizer.model                                                                                                        
[2024-04-26 10:13:00 MSK]  1001B STANDARD tokenizer_config.json                                                                                                  
[2024-04-26 10:13:00 MSK] 1.1KiB STANDARD trainer_state.json                                                                                                     
[2024-04-26 10:13:00 MSK] 5.7KiB STANDARD training_args.bin                                                                                                      
[2024-04-26 10:36:45 MSK]     0B checkpoint-5/ 
```

6. You might download results to your local storage
```
mc cp --recursive dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/results/oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg/wrk/output .
```

### Launch B-XXXXXX task
1. Start the process of creating a task in your account.
2. Select yaml file - ```scripts\B-baichuan2-7b\job.yaml```.
3. Copy folders `scripts` and `datasets` from local storage to s3 bucket
```
C:\_src\llama2>mc cp --recursive scripts dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/ 
mc cp --recursive datasets dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/
```
After your manipulation in s3 bucket must be present two folder `datasets` and `scripts`
```
C:\_src\llama2>mc ls dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/                                                                                                                                                                                                                                                                                                 
[2024-04-26 13:09:40 MSK]     0B datasets/                                                                                                                                                                                                                                                                                                                                                  
[2024-04-26 13:09:40 MSK]     0B scripts/                                                                                                                                                                                                                                                                                                                                                    
```
4. Start the task.
5. Task results present in path `dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/results/oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg/wrk/output` Where `sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc` -backet name, `oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg` - task digest.
```
C:\test\dekube>mc ls dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/results/oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg/wrk/output                
[2024-04-26 10:13:00 MSK]    93B STANDARD README.md                                                                                                              
[2024-04-26 10:13:00 MSK]   497B STANDARD adapter_config.json                                                                                                    
[2024-04-26 10:13:00 MSK] 1.0MiB STANDARD adapter_model.bin                                                                                                      
[2024-04-26 10:13:00 MSK]    42B STANDARD added_tokens.json                                                                                                      
[2024-04-26 10:13:00 MSK]    96B STANDARD special_tokens_map.json                                                                                                
[2024-04-26 10:13:00 MSK] 1.9MiB STANDARD tokenizer.model                                                                                                        
[2024-04-26 10:13:00 MSK]  1001B STANDARD tokenizer_config.json                                                                                                  
[2024-04-26 10:13:00 MSK] 1.1KiB STANDARD trainer_state.json                                                                                                     
[2024-04-26 10:13:00 MSK] 5.7KiB STANDARD training_args.bin                                                                                                      
[2024-04-26 10:36:45 MSK]     0B checkpoint-5/ 
```

6. You might download results to your local storage
```
mc cp --recursive dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/results/oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg/wrk/output .
```

### Launch C-XXXXXX task
1. Start the process of creating a task in your account.
2. Select yaml file - ```\scripts\C-baichuan2-7b\job.yaml```.
3. Copy folders `scripts` and `datasets` from local storage to s3 bucket.
```
C:\_src\llama2>mc cp --recursive scripts dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/ 
mc cp --recursive datasets dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/
```
Copy folder `model` from local storage to s3 bucket, your model must be present in local folder like this
```
models/LLAMA2/metaAi/Llama-2-7b-chat-hf

C:\_src\llama2>cd models                                                                                                                                                                                                                                                                                             
C:\_src\llama2\models>cd LLAMA2                                                                                                                                                                                                                                                                                    
C:\_src\llama2\models\LLAMA2>cd metaAi                                                                                                                                                                                                                                                                  
C:\_src\llama2\models\LLAMA2\metaAi>cd Llama-2-7b-chat-hf
C:\_src\llama2\models\LLAMA2\metaAi\Llama-2-7b-chat-hf>ls                                                                                                 
generation_utils.py                special_tokens_map.json                      
Readme.md                                                                       
pytorch_model-00001-of-00002.bin   tokenizer.model                               
checkpoints.jpeg                                                                
pytorch_model-00002-of-00002.bin   tokenizer_config.json                         
config.json                                                                     
pytorch_model.bin.index.json                                                     
quantizer.py                                                                     

C:\_src\llama2\models\LLAMA2\metaAi\Llama-2-7b-chat-hf>cd ../../../../                                                                                                                                                                                                                                                        
C:\_src\llama2>mc cp --recursive models dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/ 
```
After your manipulation in s3 bucket must be present two folder `datasets` and `scripts`
```
C:\test\dekube>mc ls dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/                                                                                                                                                                                                                                                                                                              
[2024-04-27 13:00:39 MSK]     0B datasets/                                                                                                                                                                                                                                                                                                                                                  
[2024-04-27 13:00:39 MSK]     0B models/                                                                                                                                                                                                                                                                                                                                                    
[2024-04-27 13:00:39 MSK]     0B scripts/                                                                                                                                                                                                                                                                                                                                                    
```
4. Start the task.
5. Task results present in path `dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/results/oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg/wrk/output` Where `sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc` -backet name, `oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg` - task digest.
```
C:\test\dekube>mc ls dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/results/oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg/wrk/output                
[2024-04-26 10:13:00 MSK]    93B STANDARD README.md                                                                                                              
[2024-04-26 10:13:00 MSK]   497B STANDARD adapter_config.json                                                                                                    
[2024-04-26 10:13:00 MSK] 1.0MiB STANDARD adapter_model.bin                                                                                                      
[2024-04-26 10:13:00 MSK]    42B STANDARD added_tokens.json                                                                                                      
[2024-04-26 10:13:00 MSK]    96B STANDARD special_tokens_map.json                                                                                                
[2024-04-26 10:13:00 MSK] 1.9MiB STANDARD tokenizer.model                                                                                                        
[2024-04-26 10:13:00 MSK]  1001B STANDARD tokenizer_config.json                                                                                                  
[2024-04-26 10:13:00 MSK] 1.1KiB STANDARD trainer_state.json                                                                                                     
[2024-04-26 10:13:00 MSK] 5.7KiB STANDARD training_args.bin                                                                                                      
[2024-04-26 10:36:45 MSK]     0B checkpoint-5/ 
```

6. You might download results to your local storage
```
mc cp --recursive dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/results/oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg/wrk/output .
```


### Hacklife for minio
1. Show remote dir 
```
mc ls dekube/<bucket name>/
```
2. Remove remote dir
```
mc rm -r --force dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/results
```
3. Copy dir (remote or local)
```
mc cp --recursive dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/results/oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg/wrk/output .
```

                     ## Launch finetuning locally


```sh
# Start docker container (from the root of this dir):
docker run --rm -it --gpus all --shm-size=16g -v $(pwd):/llama2 registry.i.sumus.work/ai/env:llama2-ft-test bash

# inside container
apt-get install -y gettext-base

export iRESULTwrk=/llama2/manifests/results/A-01
mkdir -p ${iRESULTwrk}

export MAX_STEPS=22
export CUDA_VISIBLE_DEVICES="0"
export PYTORCH_CUDA_ALLOC_CONF="max_split_size_mb:128"

export DEKUBE_DATASET_PATH=/llama2/manifests/datasets/databricks-dolly-15k
export DEKUBE_MODEL_PATH=/llama2/manifests/models/LLAMA2/metaAi/Llama-2-7b-chat-hf

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


cp /llama2/manifests/scripts/A-01/llama2ft-01.py ${iRESULTwrk}
cd ${iRESULTwrk}
sed -i '/sharded_ddp=.*/d' llama2ft-01.py

accelerate launch llama2ft-01.py | tee ${iRESULTwrk}/llama2ft-01.py_$(hostname).log

```


<br />

# Additional Info

<br />

## Docker image:

Use this: *registry.i.sumus.work/ai/env:llama2-ft-test*


<br />

## Model: 
Copy it from: 
*k8s-st04.i.clive.tk:/exports/ModelAI/LLAMA2/metaAi/Llama-2-7b-chat-hf*
to directory:
*manifests/models/Baichuan/* 

<br />

## Dataset:

### Dataset databricks-dolly-15k-modified:
Copy it from: 
*k8s-st04.i.clive.tk:/exports/DataSetAI/databricks/databricks-dolly-15k*
to directory:
*manifests/datasets/*


### Use your own datasets:
You may use any datatsets
Download datasets to `manifests/datasets/`
Modify `manifests/scripts/A-01/entrypoint-A-01.sh`
Change paths accordingly using your dataset name instead of `"databricks-dolly-15k"`

