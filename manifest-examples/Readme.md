# Predefined manifests
Here you can find manifests that are ready for usage through DEKUBE web interface.
Models, datasets, and entrypoint scripts are already preloaded to the standart S3 bucket of DEKUBE.


| Name                       | Description           | Number of GPUs set in the manifest    |
| -------------              | -------------         | -------------         |
| A-baichuan2-13b.yaml       | Fine-tune Baichuan2 model (13 Billion parameters)   | 5 GPUs    |
| A-baichuan2-7b.yaml        | Fine-tune Baichuan2 model (7 Billion parameters)    | 5 GPUs    |
| A-codellama-34b.yaml       | Fine-tune Codellama model (34 Billion parameters)   | 3 GPUs    |
| A-llama2-70b.yaml          | Fine-tune Llama2 model (70 Billion parameters)      | 10 GPUs   |
| A-llama2-7b.yaml           | Fine-tune Llama2 model (7 Billion parameters)       | 1 GPU     |


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
