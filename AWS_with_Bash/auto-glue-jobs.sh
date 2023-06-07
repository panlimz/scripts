#! /bin/sh/bash

echo "What is your user? (Em C:\Users\)"
read user_name

echo "Which environment do you want to update? (Options: dev/hml/prd)"
read env_name

echo "Which region do you want to use?"
read region_name

if [ $env_name = "dev" ]
then
 bucket_name=<dev-bucket-name>
 script_bucket_name=<dev-path-to-save-the-script>
elif [ $env_name = "hml" ]
then
 bucket_name=<hml-bucket-name>
 script_bucket_name=<hml-path-to-save-the-script>
elif [ $env_name = "prd" ]
then
 bucket_name=<prd-bucket-name>
 script_bucket_name=<prd-path-to-save-the-script>
else
 echo "Invalid environment"
fi

echo "What is the AWS profile name? (For AWS CLI use - You must do aws login before continue)"
read profile_name


echo "Choose a step to execute:"
echo "1 - Data upload"
echo "2 - Script upload"
echo "3 - Glue Jobs creation"
echo "4 - Glue Jobs execution"
echo "Press any key to quit"
read stage_n


case $stage_n in
1)
 echo "Step 1: Data upload. Continue? (y/n)"
 read confirm_flag
 if [ $confirm_flag != "y" ]
 then exit
 fi
 sleep 1
 aws s3 sync --profile $profile_name <local-data-path-to-upload> s3://$bucket_name/
 sleep 1
;;

2)
 echo "Step 2: Scripts upload on s3. Continue? (y/n)"
 read confirm_flag
 if [ $confirm_flag != "y" ]
 then exit
 fi
 sleep 1
 aws s3 sync --profile $profile_name <local-scripts-folder-path-to-upload> s3://$script_bucket_name/
 sleep 1
;;
3)
 echo "Step 3: Glue Jobs Creation. Continue? (y/n)"
 read confirm_flag
 if [ $confirm_flag != "y" ]
 then exit
 fi
 sleep 1
 for filename in _jsons/$env_name/*.json; do
  aws glue create-job --profile $profile_name --cli-input-json <local-json-folder-path> --region $region_name
 done
;;
4)
 echo "Step 4: Glue Jobs Execution. Continue? (y/n)"
 read confirm_flag
 if [ $confirm_flag != "y" ]
 then exit
 fi
 sleep 1
 jobs=("List" "of" "jobs" "names" "to" "execute")

 for job in ${jobs[@]}; do
  aws glue start-job-run --profile $profile_name --job-name $job --region $region_name
 done
;;
*) exit;;
esac