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
