# General Information
In this repo you can find manifests and scripts that can be used with DeKube system to perform finetuning of LLMs (Large Language Models).
Manifests and scripts should be used in conjunction.
There are 3 types of manifests:
- Type A - is the easiest way to launch predefined finetuning tasks through DeKube cabinet. It was made just for demonstration purposes. LLMs, entrypoint scripts and all needed files for the finetuning process are already placed in the standart DeKube bucket. The name of this  bucket is -'dekube', and it is already hardcoded in the manifests of type A and B.
- Type B - here you can use your own scripts and datasets, that should be placed in your own S3 bucket in the certain directories.
- Type C - full freedom for the user of DeKube system. Here you can use your own LLMs, entrypoints and all the scripts that are needed for finetuning process.
You can find these prefixes (A-,B-,C-) in the files namings. For example the name of the directory `scripts/A-codellama-34b` means that the type is - A, and this task is about to finetune CodeLlama-34b model.   
<br />

# Quick start (using manifests of type-A)
Just pick up and go :)  
Pick any manifest from [```manifest-examples```](./manifest-examples/) directory of this repo and use it in your account in the Dekube cabinet while creating a task.  
<br />

# Next steps
When you become more or less familiar with DeKube cabinet and how to launch tasks throug it by using manifests of type-A, the next step is - start using manifests of type-B and type-C.  
There are a bunch of entities involved in the process of finetuning:
- Hardware, k8s software - DeKube brings it to you through k8s Pods.
         *You can choose how many GPUs you need by specifying the right value in your manifest yaml file (take a look into examples)*
- Computing environment - consist of OS (operating system), all needed software packages, modules, frameworks, which are preinstalled in the docker images. These docker images are living in the DeKube registry.
         *You can choose the docker image you need by specifying it in your manifest yaml file*
- Entrypoint scripts - which makes internal job for the computing environment:
		-  export environment variables
		-  mount DeKube-S3 buckets with LLMs, datasets
		-  mount user-S3 buckets with desirable stuff
		-  it is also possible to install additional packages by using special commands, depends on OS, frameworks, etc (apt install... dnf install... pip install...)
- Finetuning scripts - makes the main job of finetuning by utilising everything, that was prepared for it
         *Specify the path to your entrypoint file in your manifest yaml.* 
<br />

## Docker image
Find the appropriate block in your manifest yaml file, and use the right `pth/imagename:tag` of the desired docker image 
```yaml
          containers:
            - name: tensorflow
              image: ml-registry.clive.tk/ai/llm-finetune:12836
```
*Beaware that you should use those prebuilt docker images that are currently placed in the DeKube registry*
<br />

## Paths inside your docker container
Those paths that can be used inside your docker container are:
- /mnt/s3fs  - your S3-bucket is mounted here. Read-write access only for you and your scripts.
```yaml
              - name: DEKUBE_ENTRYPOINT
                value: "/mnt/s3fs/scripts/C-llama2-7b/entrypoint.sh"
```

- /mnt/dekube  - the standart DeKube bucket is mounted here. Read-only access for any DeKube user.  
*Here is a part of the entrypoint bash script, as an example of the mounted buckets:*
```sh
#!/bin/bash
...
mkdir -p /mnt/s3fs/results/${DEKUBE_TASK_DIGEST}
export DEKUBE_DATASET_PATH=/mnt/dekube/datasets/databricks-dolly-15k.jsonl
export DEKUBE_MODEL_PATH=/mnt/dekube/models/LLAMA2/metaAi/Llama-2-7b-chat-hf
...
```
<br />

# Finetuning LLMs
You have to prepare everything you need for finetuning:
- Base LLM
- Dataset
- Scripts
<br />

## Launch finetuning through Dekube cabinet
You have scripts for three model:
- llama2-7b - Llama 2 is a collection of pretrained and fine-tuned generative text models ranging in scale 7 billion parameters. 
- baichuan2-7b - Baichuan 2 is the new generation of open-source large language models launched by Baichuan Intelligent Technology. 
- -llama2-70b - Llama 2 is a collection of pretrained and fine-tuned generative text models ranging in scale 70 billion parameters.
You have three types of tasks to run:
- Launch preconfigured, simple task  ```A-xxxxx```. 
- Launch task with your own dataset and scripts  ```B-xxxxx```.
- Launch task with your own dataset, model and scripts  ```C-xxxxx```.
<br />

### Launch A-XXXX task
1. Start the process of creating a task in your account.
2. Select yaml file - ```manifest-examples\A-xxxxx\job.yaml```.
3. Select cluster and run the task.
4. After the task is finished, you can find the result in your s3 bucket. All result will be present in the folder results/'task digest'. In our example  `sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc`  is the bucket name, 'mc' - is the MinIO client, 'dekube' - is the connection alias (see our tutorial in the DeKube cabinet on how to deal with MinIO S3 buckets)
```
C:\test\dekube>mc ls dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/
[2024-04-26 10:20:59 MSK]     0B results/
```
5. The task results is present in the path `dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/results/oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg/wrk/output` Where `sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc` -bucket name, `oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg` - task digest.
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
6. You can download results to your local storage (dot at the end of this command tells to copy in the current directoy from which you are running this command)
```
mc cp --recursive dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/results/oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg/wrk/output .
```
<br />

### Launch B-XXXXXX task
1. Copy folders `scripts` and `datasets` from local storage to your s3 bucket
```
C:\_src\llama2>mc cp --recursive scripts dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/
mc cp --recursive datasets dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/
```
After this is done you can find direcories  `datasets` and `scripts`  in your s3 bucket.
```
C:\_src\llama2>mc ls dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/
[2024-04-26 13:09:40 MSK]     0B datasets/
[2024-04-26 13:09:40 MSK]     0B scripts/
```
2. Start the process of creating a task in your account.
3. Select yaml file - ```scripts\B-baichuan2-7b\job.yaml```.
4. Start the task through DeKube cabinet.
5. The task results are present in the path `dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/results/oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg/wrk/output` Where: `sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc` - is your bucket name, `oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg` - is the task digest.
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
6. You can download results to your local storage (dot at the end of this command tells to copy in the current directoy from which you are running this command)
```
mc cp --recursive dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/results/oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg/wrk/output .
```
<br />

### Launch C-XXXXXX task
1. Copy folders `scripts` and `datasets` from the local storage to your s3 bucket.
```
C:\_src\llama2>mc cp --recursive scripts dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/ 
mc cp --recursive datasets dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/
```
2. Your model must be present in local folder like this. 
```
models/LLAMA2/metaAi/Llama-2-7b-chat-hf

C:\_src\llama2>cd models
C:\_src\llama2\models>cd LLAMA2
C:\_src\llama2\models\LLAMA2>cd metaAi
C:\_src\llama2\models\LLAMA2\metaAi>cd Llama-2-7b-chat-hf
C:\_src\llama2\models\LLAMA2\metaAi\Llama-2-7b-chat-hf>ls
generation_utils.py
special_tokens_map.json
Readme.md
pytorch_model-00001-of-00002.bin
tokenizer.model
checkpoints.jpeg
pytorch_model-00002-of-00002.bin
tokenizer_config.json
config.json
pytorch_model.bin.index.json
quantizer.py

C:\_src\llama2\models\LLAMA2\metaAi\Llama-2-7b-chat-hf>cd ../../../../
```
Copy folder `model` from the local storage to your s3 bucket.
```
C:\_src\llama2>mc cp --recursive models dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/ 
```
After your manipulation in your s3 bucket must be present three folders `datasets` , `models` and `scripts`
```
C:\test\dekube>mc ls dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/
[2024-04-27 13:00:39 MSK]     0B datasets/
[2024-04-27 13:00:39 MSK]     0B models/
[2024-04-27 13:00:39 MSK]     0B scripts/
```
3. Start the process of creating a task in your account.
4. Select yaml file - ```\scripts\C-baichuan2-7b\job.yaml```.
5. Start the task.
6. The task results are present in the path `dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/results/oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg/wrk/output` Where: `sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc` - is your bucket name, `oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg` - is the task digest.
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
7. You can download results to your local storage (dot at the end of this command tells to copy in the current directoy from which you are running this command)
```
mc cp --recursive dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/results/oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg/wrk/output .
```
<br />

### Useful commands for MinIO client
1. Show remote dir 
```
mc ls dekube/<bucket name>/
```
2. Remove remote dir
```
mc rm -r --force dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/results
```
3. Copy remote dir (from S3 bucket) to local
```
mc cp --recursive dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/results/oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg/wrk/output .
```
