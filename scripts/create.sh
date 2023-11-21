#!/bin/bash

exec &> logs

NB_CLUSTER=1
let "MAX=NB_CLUSTER-1"

terraform init

START_date=$(date)
echo $START_date
START=$(date +%s)

terraform plan -var="nb_cluster=${NB_CLUSTER}"

terraform apply -var="nb_cluster=${NB_CLUSTER}" -auto-approve
# terraform apply -var="nb_cluster=${NB_CLUSTER}" -parallelism=${NB_CLUSTER} -auto-approve

MIDDLE_date=$(date)
echo $MIDDLE_date
MIDDLE=$(date +%s)
MIDDLE_time=$(echo $((MIDDLE-START)) | awk '{printf "%d:%02d:%02d", $1/3600, ($1/60)%60, $1%60}' )
echo $MIDDLE_time

apply_deploy() {
    KUBECONFIG_FILE="my-kube-cluster-$1.yml"
    kubectl --kubeconfig=$KUBECONFIG_FILE get nodes
    # kubectl --kubeconfig=$KUBECONFIG_FILE apply -f yaml/hello.yaml -n default
    kubectl --kubeconfig=$KUBECONFIG_FILE apply -f yaml/hello_octavia_classic.yaml -n default
    kubectl --kubeconfig=$KUBECONFIG_FILE get all -n default
    kubectl --kubeconfig=$KUBECONFIG_FILE get services -n default -l app=hello-world

    ip=""
    while [ -z $ip ]; do
        echo "Waiting for external IP"
        ip=$(kubectl --kubeconfig=${KUBECONFIG_FILE} -n default get service hello-world -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
        [ -z "$ip" ] && sleep 10
    done
    echo 'Found external IP: '$ip
    export APP_IP=$ip
    echo $APP_IP
    curl $APP_IP
}

wait 

# Deploy on each cluster as jobs
for ((i=0;i<=$MAX;i++)); 
do
    apply_deploy $i &
done

# Wait for jobs to finish
wait

END_date=$(date)
echo $END_date
END=$(date +%s)
END_time=$(echo $((END-START)) | awk '{printf "%d:%02d:%02d", $1/3600, ($1/60)%60, $1%60}' )
echo $END_time

echo "---------------------"
echo "Report:"
echo "START:" $START_date
echo "CLUSTER & NODE POOL CREATED:" $MIDDLE_date "("$MIDDLE_time")"
echo "END:" $END_date "("$END_time")"
echo "\n"
echo "Details:"
echo "- cluster creation: "
echo "- nodepool creation: "
echo "\n"
echo "Total:"
echo "- Cluster & node pool creation:" $MIDDLE_time
echo "- Total (after app deployment):" $END_time
echo "---------------------"
