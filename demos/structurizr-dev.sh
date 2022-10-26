#!/bin/bash

args=$@

# The below variables are defaulted to generic structurizr values.  The workspace defaults to directory the script resides in when it's executed.
workspace="."
port="8080"
name="strcturizr-development"
stop="structurizr"
label="local"


# This function will run the structurizr/lite container.  It will name, label, and define a workspace path the the container to mount 
# in the container.  If more than one model is running at once, it will support specifying a separate port for the container. 
# The label can be used to stop the container as well. See stopDevelopmentContainer() below.
function startDevelopmentContainer() {
    echo "Starting Development Structurizr Container"
    echo "docker run -d --rm -l structurizr -l $workspace -l $label --name $name -p $port:8080 -v $(PWD):/usr/local/structurizr -e STRUCTURIZR_WORKSPACE_PATH=$workspace structurizr/lite"
    docker pull structurizr/lite 
    docker run -d --rm -l structurizr -l $workspace -l $label --name $name -p $port:8080 -v $(PWD):/usr/local/structurizr -e STRUCTURIZR_WORKSPACE_PATH=$workspace structurizr/lite 
}

# This function will simplify cleaning up running containers.  Assuming you recall the label used when starting the container, 
# one can specify --start [label] to stop the running container.
function stopDevelopmentContainer(){
    echo "docker stop $(docker ps -q --filter "label=structurizr")"
    docker stop $(docker ps -q --filter "label=$stop")
}

# parseWorkspaceArg will parse each argument prefixed with "--".
# The workspace argument is an optional argument when starting 
# the structurizr lite development container.  If missing 
# the workspace defaults to "."
function parseWorkspaceArg(){
    set -- ${args}

    if [[ $# == 0 ]]; then
        echo "No arguments are specified.  Starting container using argument defaults. "
        echoHelp
    fi
    # echo the help information and exit
    if [[ $1 == "--help" || $1 == "--h" ]]; then
        echoHelp
        exit 0
    fi
    while [ $# -gt 0 ]; do

        if [[ $1 == *"--"* ]]; then
                param="${1/--/}"
                if [[ $param == "workspace" ]]; then
                    workspace=$2
                fi
                if [[ $param == "port" ]]; then
                    port=$2
                fi
                if [[ $param == "name" ]]; then
                    name=$2
                fi
                if [[ $param == "label" ]]; then
                    label=$2
                fi
                if [[ $param == "stop" ]]; then
                    stop=$2
                    stopDevelopmentContainer
                    exit 0
                fi
               # echo $1 $2 // Optional to see the parameter:value result
        fi

    shift
    done

}


function echoHelp(){
    echo "    Usage:\n  ./structurizr.sh --name [name of the container] --workspace [directory name of workspace] --port [optional port] --label [optional label/the label is used to find the correct container with the stop argument] \n  --help or --h will echo usage information."
    echo "      --name   must be unique if running multiple containers"
    echo "      --workspace   will create a sub-directory to house your dsl files"
    echo "      --port   must be unique if running mutiple containers"
    echo "      --label  custom label to help users filter on running containers"
    echo "     One can stop running containers with the --stop [container label].  Other arguments will be ignored."
}

parseWorkspaceArg
startDevelopmentContainer