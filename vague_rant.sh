#!/bin/bash

# Provides a shorthand for fab vagrant test_module:module_name
# Allows use of bash auto-completion for deploying modules to vagrant vm
# Does not require removal of trailing / characters
# Automates movement of directories to redcap_deployment/root

# Replace with the path to your redcap_deployment directory
redcap_deployment_root_dir="/Users/kyle.chesney/projects/redcap_deployment"

# Suggested use:
# 1 make callable anywhere:
# 1.1 chmod +x vague_rant.sh
# 1.2 cp vague_rant.sh /usr/local/bin/vt
# 2 vt path/to/module_to_test/

args=("$@")

if [[ $(pwd) =~ .*/redcap_deployment$ ]]; then
    is_in_root=true
fi

# Splits path by directories
module_path_array=(${1//\// })
# Takes only last value (negative array indices only work in bash 4.1+)
module_name=${module_path_array[${#module_path_array[@]}-1]}

clone_module_directory () {
    # TODO: if != *_vX.Y.Z, append _v0.0.0
    new_path="${redcap_deployment_root_dir}/modules/${module_name}/"
    mkdir $new_path
    cp -r $1 $new_path
    echo "${module_name} was cloned to:
         ${new_path}
Please make changes to files there"
}

clone_module_directory $1

if [[ "$is_in_root" != true ]]; then
    cd $redcap_deployment_root_dir
fi

test_module () {
	  fab vagrant test_module:$1
}

test_module $module_name

