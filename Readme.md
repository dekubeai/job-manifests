# General Information
This repository contains manifests and scripts to help you effectively use Dekube for fine-tuning and training machine learning models.

This guide is designed to provide you with comprehensive information on setting up and running large language models (LLM) in the Dekube system. It includes detailed instructions on installing and configuring the necessary tools, explains the main concepts and components, and provides examples of using manifests for various scenarios.

#### Overview of Dekube

Dekube is a powerful platform for running and managing machine learning tasks, built on Kubernetes and Kubeflow – an ecosystem of open-source projects to address each stage in the machine learning (ML) lifecycle.

We offer users the ability to rent computing resources to perform complex computations required for training neural networks. The system integrates with numerous frameworks and libraries, allowing for convenient management of diverse models and tasks.

The workflow is managed through the Dekube web console, where you can create and interact with tasks.

### Brief Overview of Manifest Types

Manifests in Dekube are main configuration files that contain information about additional scripts, datasets, and models, as well as directives about all required resources. They define the necessary components and setup for machine learning tasks. Manifests can be written using various frameworks with KubeFlow and are described in YAML format.

For a deeper understanding of how manifests work and their role within KubeFlow, you can refer to the [Kubeflow documentation](https://www.kubeflow.org/docs/components/training/).

#### **Types of Manifests and Their Use**

>[!Note]
>These "types" of manifests are conditional and merely illustrate the specifics and essence of the examples provided in this repository.

**Type A**

Type A manifests contain preloaded models, datasets, and scripts already uploaded to the Dekube storage. These manifests are preconfigured and ready to use without additional setup. Type A is ideal for quickly starting and training on preset data. You can find examples of these manifests in the [repository folder](https://github.com/dekubeai/job-manifests/tree/main/manifest-examples).

**Type B**

Type B manifests allow you to use your own scripts and datasets. These manifests require you to upload your data to your own S3 storage bucket and specify the paths to this data in the manifest, allowing flexible adaptation of tasks to specific requirements.

**Type C**

Type C manifests are intended for advanced users who can independently adapt scripts, write manifests, and use their own models and datasets. These manifests provide maximum flexibility in task configuration, allowing users to tailor the setup according to their specific requirements.

### Available Models

* **Llama2-7b**: A collection of pretrained and fine-tuned generative text models with a scale of 7 billion parameters.
* **CodeLlama-34b-hf**: A collection of pretrained and fine-tuned generative text models with a scale ranging from 7 billion to 34 billion parameters.
* **Llama2-70b**: A collection of pretrained and fine-tuned generative text models with a scale of 70 billion parameters.
* **Baichuan2-7b**: The new generation of open-source large-scale language models launched by Baichuan Intelligent Technology.
* **Baichuan2-13B-Base**: An open-source large-scale language model developed by Baichuan Intelligent Technology containing 13 billion parameters.

>[!Note]
>Upon request, we will expand the lineup of available models and datasets. You can leave a request to receive services such as the preparation of manifests and scripts to launch tasks in Dekube. The manifests and entrypoint scripts we have published serve as examples that you can use to guide you in writing your own manifests and entrypoint scripts. All the necessary data is placed in storage in a bucket named 'dekube'. The name of this bucket - 'dekube', is already hardcoded in the manifests of Type A and B.

### **Entities Involved in Model Tuning Process**

**Hardware and Kubernetes Software**

Dekube uses Kubernetes architecture to manage containers and orchestrate computing resources. The primary element of Kubernetes is [pods](https://kubernetes.io/docs/concepts/workloads/pods/), which are groups of one or more containers running together on a host. Each pod includes containers with applications and necessary dependencies.

Pods allow us to efficiently distribute computing resources, and you can adjust the number of required GPUs by specifying the appropriate values in the YAML manifest file.

```yaml
spec:
  containers:
    - name: my-container
      image: my-docker-image
      resources:
        limits:
          nvidia.com/gpu: 2  # Number of GPUs
```

**Computing Environment**

The computing environment in Dekube consists of the operating system, all necessary software packages, modules, and frameworks pre-installed in [Docker images](https://docs.docker.com/guides/docker-overview/#images). These Docker images are stored in the Dekube registry and can be selected by users to run their tasks.

Docker images ensure reproducibility and consistency of the computing environment, allowing users to use pre-installed packages and libraries without the need for additional installation.

To use Docker images, you need to specify the appropriate image in the YAML manifest file. The choice of Docker image depends on the requirements of your task, including the frameworks and packages used.

Example of specifying a Docker image in the manifest:

```yaml
containers:
  - name: tensorflow
    image: ml-registry.clive.tk/ai/llm-finetune:12836
```

It is important to use pre-built Docker images hosted in the DEKUBE registry to ensure compatibility and correct task execution.

Inside your Docker container, the following paths are used:

* **`/mnt/s3fs`**- your S3 bucket is mounted here. Only you and your scripts have read and write access.

```yaml
env:
  - name: DEKUBE_ENTRYPOINT
    value: "/mnt/s3fs/scripts/C-llama2-7b/entrypoint.sh"
```

* **`/mnt/dekube`** - the standard DEKUBE bucket is mounted here. Any DEKUBE user has read-only access.

```yaml
env:
  - name: DEKUBE_ENTRYPOINT
    value: "/mnt/dekube/scripts/A-baichuan2-7b/entrypoint.sh"
```

Example entrypoint script using mounted buckets:

<pre class="language-bash"><code class="lang-bash">#!/bin/bash
mkdir -p /mnt/s3fs/results/${DEKUBE_TASK_DIGEST}
<strong>export DEKUBE_DATASET_PATH=/mnt/dekube/datasets/databricks-dolly-15k.jsonl
</strong>export DEKUBE_MODEL_PATH=/mnt/dekube/models/LLAMA2/metaAi/Llama-2-7b-chat-hf
...
</code></pre>

**Entrypoint Scripts**

Entrypoint scripts perform initial setup of the computing environment. They export environment variables and mount Dekube and user S3 buckets containing models, datasets, and any necessary data. Entrypoint scripts can also install additional packages using commands depending on the operating system and frameworks.

The path to the entrypoint script is specified in the manifest, while the datasets and models' paths are defined within the entrypoint script itself. Additionally, these scripts can install extra packages.Moreover, any variables defined in the manifest can be utilized during runtime.

By correctly specifying these paths, users ensure that scripts stored in personal or shared S3 buckets are automatically mounted into the container, making the required data accessible for task execution.

The path to the entrypoint script is specified in the YAML manifest file:

```yaml
env:
  - name: DEKUBE_ENTRYPOINT
    value: "/mnt/s3fs/scripts/C-llama2-7b/entrypoint.sh"
```

[Example of an entrypoint script:](https://github.com/dekubeai/job-manifests/blob/main/scripts/A-llama2-7b/entrypoint.sh)

```bash
entrypoint.sh

export DEKUBE_MODEL_PATH=/mnt/dekube/models/LLAMA2/metaAi/Llama-2-7b-chat-hf
export DEKUBE_DATASET_PATH=/mnt/dekube/datasets/databricks-dolly-15k.jsonl
...
apt update && apt install some-package
pip install some-package
```

**Fine-tuning Scripts**

Fine-tuning scripts perform the main job of fine-tuning models using all the prepared resources and data. These scripts run after the entrypoint scripts and include commands for training and tuning models.

[Example o Fine-tuning script:](https://github.com/dekubeai/job-manifests/blob/main/scripts/A-llama2-70b/llama2-finetune.py)

```python
    def train(model, tokenizer, dataset, output_dir, max_steps, num_train_epochs, gradient_accumulation_steps):
    # Apply preprocessing to the model to prepare it by
    # 1 - Enabling gradient checkpointing to reduce memory usage during fine-tuning
    model.gradient_checkpointing_enable()
    # 2 - Using the prepare_model_for_kbit_training method from PEFT
    model = prepare_model_for_kbit_training(model)
    # Get lora module names
    modules = find_all_linear_names(model)
    # Create PEFT config for these modules and wrap the model to PEFT
    peft_config = create_peft_config(modules)
    model = get_peft_model(model, peft_config)
    # Print information about the percentage of trainable parameters
    print_trainable_parameters(model)
    ...
```

### **Setting Up the Environment**

To work with Dekube, you will need to:

* Install MinIO Client
* Create and set up a profile to work with the web console
* Configure local access to storage within the web console

**1. Installing MinIO Client**

MinIO Client (mc) is a tool for managing files in S3-compatible storage, providing a convenient command-line interface for performing operations on storage objects.

You can find installation instructions in the [official MinIO documentation.](https://min.io/docs/minio/linux/reference/minio-mc.html)

**2. Creating and Setting Up a Profile in the Web Console**

Register on the Dekube web console, top up your balance, and verify your account via the Telegram bot. You can find the full instructions on our documentation website; this guide will not cover these steps in detail.

**3. Configuring Storage Access**

The internal S3 storage allows you to upload all the necessary data (datasets, scripts, models) for running your tasks. It also ensures the preservation of results, execution logs, and any other files needed for your work.

Before uploading datasets or other files, you need to configure local access to the storage through the console page. This setup step only needs to be performed once for each device, after which you can seamlessly use the storage.

To set up local access to your S3 storage bucket, copy the ready command directly from the website, in the Storage section and execute it in MinIO Client:

```bash
mc alias set dekube https://ml-storage.clive.tk:9000 OFQA8YM6AUK3IOYGXXHD MxV2MqWAnxQY7wgzD1dwzdShV9iXFsFudSG3rsg
```

After executing this command, you will be able to manage your S3 storage through MinIO Client, upload data and scripts, and save task execution results.

### **Commands for MinIO Client**

Below are the basic commands that will help you effectively work with your S3 storage. These commands will be frequently used before, during, and after task execution, so we will cover them in advance to avoid repetition later.

**Viewing Directories**

To view the contents of directories in your S3 storage, use the `mc ls` command:

```bash
mc ls dekube/<your_bucket_name>/results/<task_digest>
```

* `<your_bucket_name>` - the address of your S3 storage bucket, which you can find in your profile details in the web console, e.g., `ofqa8ym6auk3ioygxxhdtaygw6izjhg9rvs3wrhyxntbzcbxd`.
* `results` - the directory inside your storage where task execution results are stored.
* `<task_digest>` - the identifier of your task. You can find it in the completed task row in the web console table.

**Copying files**

To copy files between your local computer and S3 storage, use the `mc cp --recursive` command.

To copy from your local computer to S3 storage bucket:

```bash
file_path> mc cp --recursive <folder_name> dekube/<your_bucket_name>
```

* `<folder_name>` - the name of the folder you want to copy from your device, e.g., `scripts`.

To copy files from S3 storage to your local computer:

```bash
mc cp --recursive dekube/<your_bucket_name>/<folder_name>/wrk/output .
```

* `<folder_name>` - in this case, the name of the folder you want to copy to your local device, e.g., `results`.
* `.` - the dot at the end of the command indicates copying to the current directory from which the command is executed.

**Deleting Directories**

To delete directories in your S3 storage bucket, use the `mc rm -r --force` command:

```bash
mc rm -r --force dekube/<your_bucket_name>/<file_or_directory>
```

You can find more details on different commands and their usage in the[ official MinIO documentation.](https://min.io/docs/minio/linux/reference/minio-mc.html#command-quick-reference)

### **Task Execution Cycle in Dekube**

Launching tasks in the DEKUBE web console involves several main steps, such as configuring and uploading manifests, preparing and copying scripts and datasets, and accessing results.

In this section, we will cover the general pattern of task execution, and in the next section, we will move on to examples of their execution with different types of manifests.

**1. Using the Manifest:**

1. Creating or Editing a Task Manifest: Create or edit the YAML file of the task manifest, specifying the necessary parameters such as paths to scripts and datasets.
2. Uploading the Manifest: Log into the web console, click "Create Task," and upload the task manifest.

**2. Preparing and Copying Scripts and Datasets:** For types B and C manifests, you need to prepare and upload your scripts and datasets to S3 storage. To do this:

1. Prepare Scripts and Datasets: Create local directories for storing scripts and datasets, for example, `C:\dekube\datasets` and `C:\dekube\scripts`, and then add the necessary files there.
2. Copy to S3 Storage: Use MinIO Client to copy the prepared files to your S3 storage bucket.

```bash
C:\dekube\> mc cp --recursive scripts dekube/<your_bucket_name>
C:\dekube\> mc cp --recursive datasets dekube/<your_bucket_name>
```

After this is done, you can find the directories `datasets` and `scripts` in your S3 storage bucket:

```bash
mc ls dekube/<your_bucket_name>/
[2024-04-26 13:09:40]     0B datasets/
[2024-04-26 13:09:40]     0B scripts/
```

**3. Launching a Task:** After uploading the manifest and necessary components, select a cluster and runtime estimate, then click the "Pay and run a new task" button and wait for the system to process and accept the task.

**4. Accessing Results:** After the task is completed, the results will be saved in your S3 storage bucket. To access the results, you can use both the web console interface and MinIO Client:

**5. Viewing Results**: Use the `mc ls` command to view the contents of the results directory:

```bash
> mc ls dekube/<your_bucket_name>/results/<task_digest>/
[2024-06-22 10:20:59]     0B results/
```

**6. Copying Results:** Copy the results to your local computer for further analysis using the `mc cp --recursive` command:

```bash
> mc cp --recursive dekube/<your_bucket_name>/results/<task_digest>/wrk/output .
```

### **Task Execution Examples**

#### Example 1: Type A

This example demonstrates the use of the CodeLlama-34b model with pre-configured manifests of type A:

1. Copy the [pre-configured manifest for CodeLlama-34b](https://github.com/dekubeai/job-manifests/blob/main/manifest-examples/A-codellama-34b.yaml).
2. Log into the Dekube web console, click "Create Task," upload the manifest, and proceed to the next step.
3. Select a cluster and estimate the runtime. Click "Pay" to launch a new task.
4. After the task is completed, the results will be saved in your S3 storage bucket. Use the web interface or MinIO Client to access the results and download them to your local device:

```bash
> mc ls dekube/<your_bucket_name>/results/<task_digest>/wrk/output 
[2024-06-22 10:13:00]    93B STANDARD README.md
[2024-06-22 10:13:00]   497B STANDARD adapter_config.json
[2024-06-22 10:13:00] 1.0MiB STANDARD adapter_model.bin
[2024-06-22 10:13:00]    42B STANDARD added_tokens.json
[2024-06-22 10:13:00]    96B STANDARD special_tokens_map.json
[2024-06-22 10:13:00] 1.9MiB STANDARD tokenizer.model
[2024-06-22 10:13:00]  1001B STANDARD tokenizer_config.json
[2024-06-22 10:13:00] 1.1KiB STANDARD trainer_state.json
```

```bash
C:\dekube\> mc cp --recursive dekube/<your_bucket_name>/results/<task_digest>/wrk/output .
```

#### Example 2: Type B. Using a Custom Dataset

This example shows how to use a custom dataset to configure a model using Type B manifests.

1. Create local directories for scripts and datasets and add the necessary files:

```bash
C:\dekube\> mkdir datasets
C:\dekube\> mkdir scripts
```

2. Copy these directories to S3 storage bucket:

```
mc cp --recursive scripts dekube/<your_bucket_name>
mc cp --recursive datasets dekube/<your_bucket_name>
```

3. Create or edit the manifest, specifying the paths to your scripts and datasets. You can use this example manifest as a reference: [Llama2-7b Manifest](https://github.com/dekubeai/job-manifests/blob/main/scripts/B-llama2-7b/job.yaml)
4. Login to the Dekube web console, click "Create Task," upload the manifest, and proceed to the next step.
5. Select the cluster and estimate the runtime for the task. Click "Pay and run a new task."
6. Access the results: Once the task is complete, the results will be saved in your S3 storage bucket. Use the web interface or MinIO Client to access the results and download them to your local machine as shown in the previous example.

#### Example 3: Type C. Full Task Customization

This example demonstrates full task customization, including using unique models, data, and scripts with Type C manifests.

1. Create local directories `scripts`, `models`, and `datasets`, and add the necessary files.
2. Copy these directories to S3 storage bucket as shown in the second example.
3. Create or edit the manifest, specifying the paths to your scripts, models, and datasets.
4. Login to the Dekube web console, click "Create Task," upload the manifest, and proceed to the next step.
5. Select the cluster and estimate the runtime for the task. Click "Pay and run a new task."
6. Access the results: Once the task is complete, the results will be saved in your S3 storage bucket. Use the web interface or MinIO Client to access the results and download them to your local machine as shown in the previous examples.

### **Feedback and Support**

If you have any questions or issues, please contact our support team [on Telegram](https://t.me/Dekube\_official\_support/3). We are happy to assist you.