#!/bin/bash

kubectl -n cgbu-sdwan-finallog-cgbusdwan get pods
echo -e "\n\n";

#get name of all pods in an array
pods=($(kubectl get pods -n cgbu-sdwan-finallog-cgbusdwan -o jsonpath='{.items[*].metadata.name}'))

total_pods=${#pods[@]};
total_containers=0;
unhealthy_containers=0;

for (( i=0; i<$total_pods; i++ ));
do
  #get containers inside pod
  containers=($(kubectl get pods "${pods[$i]}" -n cgbu-sdwan-finallog-cgbusdwan -o jsonpath='{.spec.containers[*].name}'));

  #get status of each container
  container_status=($(kubectl get pods "${pods[$i]}" -n cgbu-sdwan-finallog-cgbusdwan -o jsonpath='{.status.containerStatuses[*].ready}'));

  len=${#container_status[@]};
  (( total_containers=len+total_containers));
  for (( j=0; j<$len; j++ ));
  do
    if [[ -n "${containers[$j]}"  && "${container_status[$j]}" == "false" ]]; then
      echo "Container ${containers[$j]} is not healthy in pod ${pods[$i]}";
        (( unhealthy_containers+=1));
    fi
  done
done

pod_unhealthy=$(kubectl -n cgbu-sdwan-finallog-cgbusdwan get pods --no-headers --field-selector status.phase!=Running | wc -l);


echo -e  "\n**********************************SUMMARY**********************************"
echo "          Total No. of pods = ${total_pods}";
echo "          Total No. of Unhealthy pods = ${pod_unhealthy}";
echo "          Total No. of Containers = ${total_containers}";
echo "          Total No. of Unhealthy containers = ${unhealthy_containers}";
echo "*****************************************************************************"


if [[ $unhealthy_containers -gt 0 ]]; then
        echo "!!!!!!!!!! Smoketest Failed, your tenant is not healthy !!!!!!!!!!";
        echo "*****************************************************************************"
        exit 1;
        fi
echo "          Smoketest Passed, your tenant is healthy                ";
echo "*****************************************************************************";
exit 0
