my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")"; pwd -P )"
export PATH=$PATH:$my_dir/bin

source $my_dir/include/autocomplete.sh
