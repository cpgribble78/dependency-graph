#!/bin/sh

dep_args=""
dir_args=""
dry_run=false
echo_cmd=false

while [[ $# -gt 0 ]]; do
  case $1 in
    # `dependency_graph.py` options
    -c)
      dep_args+="$1 "
      shift
      ;;
    -f)
      dep_args+="$1 $2 "
      shift
      shift
      ;;
    -l)
      dep_args+="--cluster-labels "
      shift
      ;;
    -s)
      dep_args+="$1 "
      shift
      ;;
    -x)
      dep_args+="$1 "
      shift
      ;;
    -v)
      dep_args+="$1 "
      shift
      ;;
    # `gen_dep_graphs.sh` options
    -d)
      dry_run=true
      shift
      ;;
    -e)
      echo_cmd=true
      shift
      ;;
    -*|--*)
      echo "Unknown option \"$1\""
      exit 1
      ;;
    *)
      dir_args+="$1 "
      shift
      ;;
  esac
done

dep_args=`echo ${dep_args} | xargs`
dir_args=`echo ${dir_args} | xargs`

#echo "dep_args = \"${dep_args}\""
#echo "dir_args = \"${dir_args}\""

for dir in ${dir_args} ; do
  if test -d ${dir}; then
    if [ ${dir} == "." ]; then
    out="${PWD##*/}"
  else
    out="${dir}"
    fi
    echo "Generating dependency graph for \"${dir}/\""
    cmd="python dependency_graph.py ${dep_args} ${dir} ${out}_deps"
    if [ ${echo_cmd} = true ]; then
      echo "--> ${cmd}"
      echo ""
    fi
    if [ ${dry_run} = false ]; then
      ${cmd}
    fi
  else
    echo "\"${dir}\" is not a directory"
  fi
done
