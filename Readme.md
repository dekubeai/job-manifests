# General Information
In this repository you can find manifests and scripts we have prepared that can be used to fine-tuning LLMs (Large Language Models) in the DEKUBE system.
Each model has its own manifest and entrypoint scripts. Manifests and scripts should be used in conjunction.  
There are 3 types of manifests:
- Type A - models, datasets, and entrypoint scripts are already preloaded by storage, and manifests are prepared and upload in the repository. Upon request, we will expand the lineup as well as dataset options. You can leave a request and get such services as preparation of manifests and scripts to launch tasks in the DEKUBE. The manifests and entrypoint scripts we have published are examples that you can use to guide you in writing your own manifests and entrypoint scripts. All the necessary data is placed in storage in a bucket named 'dekube'. The name of this  bucket is -'dekube' is already hardcoded in the manifests of type A and B.
- Type B - is an option where you can use your own scripts, datasets and a customized manifest. Your own scripts and datasets must be placed in your own S3 storage bucket in specific directories. As we have shown in this repository (do not count the manifest-examples folder in this structure).
- Type C - This option is intended for professionals who can independently adapt scripts, write manifests to the LLM model they have chosen for fine-tuning and a selected or self-prepared dataset. The manifest is uploaded via the web interface, and all other listed data is uploaded to S3 storage.   

You can find these prefixes (A-,B-,C-) in the files namings. For example the name of the directory `scripts/A-codellama-34b` means that the type is - A, and this task is about to fine-tune CodeLlama-34b model.   
<br />

# Quick start (using manifests of type-A)
Just pick up and go :)  
Pick any manifest from [```manifest-examples```](./manifest-examples/) directory of this repo and use it in your account in the DEKUBE web console while creating a task.  
<br />

# For advanced users. There are a bunch of entities involved in the process of finetuning:

- Hardware, k8s software - DEKUBE brings it to you through k8s Pods.  
         *You can choose how many GPUs you need by specifying the right value in your manifest yaml file (take a look into examples)*
- Computing environment - consist of OS (operating system), all needed software packages, modules, frameworks, which are preinstalled in the docker images. These docker images are living in the DEKUBE registry.  
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
*Beaware that you should use those prebuilt docker images that are currently placed in the DEKUBE registry*
<br />

## Paths inside your docker container
Those paths that can be used inside your docker container are:
- /mnt/s3fs  - your S3-bucket is mounted here. Read-write access only for you and your scripts.
```yaml
              - name: DEKUBE_ENTRYPOINT
                value: "/mnt/s3fs/scripts/C-llama2-7b/entrypoint.sh"
```

- /mnt/dekube  - the standart DEKUBE bucket is mounted here. Read-only access for any DeKube user.  
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

# Fine-tuning LLMs
You have to prepare everything you need for fine-tuning:
- Base LLM
- Dataset
- Scripts
- Manifests
<br />

## Launch fine-tuning through DEKUBE console
You have scripts for five model:
- Llama2-7b is a collection of pretrained and fine-tuned generative text models ranging in scale 7 billion parameters. 
- CodeLlama-34b-hf is a collection of pretrained and fine-tuned generative text models ranging in scale from 7 billion to 34 billion parameters.
- Llama2-70b is a collection of pretrained and fine-tuned generative text models ranging in scale 70 billion parameters.
- Baichuan2-7b is the new generation of open-source large language models launched by Baichuan Intelligent Technology. 
- Baichuan2-13B-Base is an open-source large-scale language model developed by Baichuan Intelligent Technology containing 13 billion parameters. 

You have three types of tasks to run:
- Launch preconfigured, simple task  ```A-xxxxx```. 
- Launch task with your own dataset and scripts, manifest  ```B-xxxxx```.
- Launch task with your own dataset, model, scripts and manifests  ```C-xxxxx```.
<br />

### Launch A-XXXX task
1. Start the process of creating a task in your DEKUBE account.
2. Download and upload the yaml file through DEKUBE web interface - ```manifest-examples\A-xxxxx.yaml```.
3. In the next step, select cluster and Runtime estimate.
4. Click the Pay and run a new task button and wait for the system to process the task and accept it.
5. After the task is finished, you can find the result in your s3 storage bucket. All result will be present in the folder results/'task digest'. In our example  `sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc`  is the bucket name, 'mc' - is the MinIO client, 'dekube' - is the connection alias.
```
C:\test\dekube>mc ls dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/
[2024-06-22 10:20:59]     0B results/
```
6. The task results is present in the path `dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/results/oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg/wrk/output`  
Where `sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc` - is your bucket name - you can find it in your account profile,  
`oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg` - task digest - you can find it in the completed task row in the task table of your account.
```
C:\test\dekube>mc ls dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/results/oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg/wrk/output
[2024-06-22 10:13:00]    93B STANDARD README.md
[2024-06-22 10:13:00]   497B STANDARD adapter_config.json
[2024-06-22 10:13:00] 1.0MiB STANDARD adapter_model.bin
[2024-06-22 10:13:00]    42B STANDARD added_tokens.json
[2024-06-22 10:13:00]    96B STANDARD special_tokens_map.json
[2024-06-22 10:13:00] 1.9MiB STANDARD tokenizer.model
[2024-06-22 10:13:00]  1001B STANDARD tokenizer_config.json
[2024-06-22 10:13:00] 1.1KiB STANDARD trainer_state.json
[2024-06-22 10:13:00] 5.7KiB STANDARD training_args.bin
[2024-06-22 10:36:45]     0B checkpoint-5/
```
7. You can download results to your local storage (dot at the end of this command tells to copy in the current directoy from which you are running this command)
```
mc cp --recursive dekube/your_bucket_name/results/task_digest/wrk/output .
```
<br />

### Launch B-XXXXXX task
1. Copy folders `scripts` and `datasets` from local storage to your s3 storage bucket. Substitute the name of your bucket.
```
C:\_src\llama2>mc cp --recursive scripts dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/
mc cp --recursive datasets dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/
```
After this is done you can find directories  `datasets` and `scripts`  in your s3 storage bucket.
```
C:\_src\llama2>mc ls dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/
[2024-04-26 13:09:40]     0B datasets/
[2024-04-26 13:09:40]     0B scripts/
```
2. Start the process of creating a task in your account.
3. Download and upload the yaml file through DEKUBE web interface - ```scripts\B-baichuan2-7b\job.yaml```.
4. In the next step, select cluster and Runtime estimate.
5. Click the Pay and run a new task button and wait for the system to process the task and accept it.
6. The task results are present in the path `dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/results/oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg/wrk/output`  
Where: `sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc` - is your bucket name- you can find it in your account,  
`oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg` - is the task digest - you can find it in your account.
```
C:\test\dekube>mc ls dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/results/oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg/wrk/output
[2024-06-22 10:13:00]    93B STANDARD README.md
[2024-06-22 10:13:00]   497B STANDARD adapter_config.json
[2024-06-22 10:13:00] 1.0MiB STANDARD adapter_model.bin
[2024-06-22 10:13:00]    42B STANDARD added_tokens.json
[2024-06-22 10:13:00]    96B STANDARD special_tokens_map.json
[2024-06-22 10:13:00] 1.9MiB STANDARD tokenizer.model
[2024-06-22 10:13:00]  1001B STANDARD tokenizer_config.json
[2024-06-22 10:13:00] 1.1KiB STANDARD trainer_state.json
[2024-06-22 10:13:00] 5.7KiB STANDARD training_args.bin
[2024-06-22 10:36:45]     0B checkpoint-5/
```
7. You can download results to your local storage (dot at the end of this command tells to copy in the current directoy from which you are running this command)
```
mc cp --recursive dekube/your_bucket_name/results/task_digest/wrk/output .
```
<br />

### Launch C-XXXXXX task
1. Copy folders `scripts` and `datasets` from the local storage to your s3 storage bucket.
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
Copy folder `model` from the local storage to your s3 storage bucket.
```
C:\_src\llama2>mc cp --recursive models dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/ 
```
After your manipulation in your s3 storage bucket must be present three folders `datasets` , `models` and `scripts`
```
C:\test\dekube>mc ls dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/
[2024-04-27 13:00:39]     0B datasets/
[2024-04-27 13:00:39]     0B models/
[2024-04-27 13:00:39]     0B scripts/
```
3. Start the process of creating a task in your account.
4. Download and upload the yaml file through DEKUBE web interface - ```\scripts\C-baichuan2-7b\job.yaml```.
5. In the next step, select cluster and Runtime estimate.
6. Click the Pay and run a new task button and wait for the system to process the task and accept it. 
7. The task results are present in the path `dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/results/oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg/wrk/output`  
Where: `sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc` - is your bucket name- you can find it in your account,  
`oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg` - is the task digest - you can find it in your account.
```
C:\test\dekube>mc ls dekube/sq4x86fkhj6y91hhpaq9ntsxzh7zwhna5jbbhqmpnwfhsg4tc/results/oWGEYiBcautSih6nsgWBCJcoF6hoWX7x978ryjSgTS4uFWYmg/wrk/output
[2024-06-22 10:13:00]    93B STANDARD README.md
[2024-06-22 10:13:00]   497B STANDARD adapter_config.json
[2024-06-22 10:13:00] 1.0MiB STANDARD adapter_model.bin
[2024-06-22 10:13:00]    42B STANDARD added_tokens.json
[2024-06-22 10:13:00]    96B STANDARD special_tokens_map.json
[2024-06-22 10:13:00] 1.9MiB STANDARD tokenizer.model
[2024-06-22 10:13:00]  1001B STANDARD tokenizer_config.json
[2024-06-22 10:13:00] 1.1KiB STANDARD trainer_state.json
[2024-06-22 10:13:00] 5.7KiB STANDARD training_args.bin
[2024-06-22 10:36:45]     0B checkpoint-5/
```
8. You can download results to your local storage (dot at the end of this command tells to copy in the current directoy from which you are running this command)
```
mc cp --recursive dekube/your_bucket_name/results/task_digest/wrk/output .
```
<br />

### Useful commands for MinIO client
1. Show remote dir 
```
mc ls dekube/<bucket name>/
```
2. Remove remote dir
```
mc rm -r --force dekube/your_bucket_name/results
```
3. Copy remote dir (from S3 bucket) to local
```
mc cp --recursive dekube/your_bucket_name/results/task_digest/wrk/output .
```
