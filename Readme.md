# For all manifests

These variables should be redefined by billing system, when launched from within cabinet

```yaml
- name: DEKUBE_S3_ACCESS_KEY
  value: 2FW6RFXFY4MUPYSAFNQV
- name: DEKUBE_S3_SECRET_KEY
  value: 3tovi6sCbzFFS6NKyfkxKbMDjgveqipQz7NZ9FEg
- name: DEKUBE_S3_BUCKET_NAME
  value: 2fw6rfxfy4mupysafnqv9afpzyurpfz7ykmbeymk2skunfx5pr
- name: DEKUBE_TASK_DIGEST
  value: "taskdigest-A-05-slim"
- name: DEKUBE_S3_ACCESS_KEY_READER
  value: "dekubereader"
- name: DEKUBE_S3_SECRET_KEY_READER
  value: "dekubereader"
- name: DEKUBE_S3_DEKUBE_BUCKET_NAME
  value: "dekube"
```

# About 'slim' manifests
To make it possible to run manifests with '-slim' postfix there should be defined an argument 'WORKER_ADDITIONAL_CONTAINER' in the billing pod environment

Either from command line:
k -n billing-system set env deployment.apps/billing WORKER_ADDITIONAL_CONTAINER='... (copy content of the yaml block below) ...'
Or hardcoded to the billing.Deployment.yaml


```yaml
name: s3mounter
image: registry.i.sumus.work/tools/s3mounter
imagePullPolicy: Always
env:
- name: DEKUBE_MINIO_HOST
  value: "https://ml-storage.clive.tk:9000"
- name: iRESULTwrk
  value: "/mnt/wrk"
volumeMounts:
  - name: shared-data
    mountPath: /mnt
    mountPropagation: Bidirectional
command: ["/bin/sh", "-c", "--"]
args: [" \
  set -x \
  && echo ${DEKUBE_S3_ACCESS_KEY}:${DEKUBE_S3_SECRET_KEY} > /root/.passwd-s3fs \
  && chmod 600 /root/.passwd-s3fs \
  && mkdir -p /mnt/s3fs \
  && s3fs ${DEKUBE_S3_BUCKET_NAME} /mnt/s3fs \
    -o passwd_file=/root/.passwd-s3fs \
    -o url=${DEKUBE_MINIO_HOST} \
    -o use_path_request_style \
  && echo ${DEKUBE_S3_ACCESS_KEY_READER}:${DEKUBE_S3_SECRET_KEY_READER} > /root/.passwd-s3fs-reader \
  && chmod 600 /root/.passwd-s3fs-reader \
  && mkdir -p /mnt/dekube  \
  && s3fs ${DEKUBE_S3_DEKUBE_BUCKET_NAME} /mnt/dekube \
    -o passwd_file=/root/.passwd-s3fs-reader \
    -o url=${DEKUBE_MINIO_HOST} \
    -o use_path_request_style \
  && touch /mnt/dummy \
  && inotifywait -e delete /mnt/dummy \
  ; sync \
  ; mcli alias set dekube ${DEKUBE_MINIO_HOST} ${DEKUBE_S3_ACCESS_KEY} ${DEKUBE_S3_SECRET_KEY} \
  && mcli cp -r ${iRESULTwrk}/ dekube/${DEKUBE_S3_BUCKET_NAME}/results/${DEKUBE_TASK_DIGEST}/wrk/ \
  || mcli cp -c -r --limit-upload 512M ${iRESULTwrk}/ dekube/${DEKUBE_S3_BUCKET_NAME}/results/${DEKUBE_TASK_DIGEST}/wrk/ \
  ; while mount | grep -q /mnt/s3fs ; do echo Detect mount ; umount /mnt/s3fs ; umount /mnt/dekube ; umount -l /mnt/s3fs &>/dev/null ; umount -l /mnt/dekube  &>/dev/null ; sleep 1 ; done \
  && true \
    "]
securityContext:
  privileged: true
  capabilities:
    add:
      - SYS_ADMIN
```