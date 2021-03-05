name="$1"

addresses_type="$2"

sha_version="$3"
sha_addr="$4"

ipfs_version="$5"
ipfs_addr="$6"

gitannex_version="$7"
gitannex_addr="$8"

immutag_path="$HOME/immutag"
config_path=$immutag_path/$name/"$addresses_type"-addresses

ls $config_path
config_exists=$(eval echo $?)

if [ "$config_exists" = "2" ]; then
    # Create config
    echo '{ "sha256": { "version": "arg", "addr": "arg" }, "ipfs": { "version": "arg", "addr": "arg"}, "git_annex": { "version": "arg", "addr": "arg"} }' > $config_path
fi

cat $config_path \
| jq --arg sha_version "$sha_version" '.sha256.version = $sha_version' \
| jq --arg sha_addr "$sha_addr" '.sha256.addr = $sha_addr' \
| jq --arg ipfs_version "$ipfs_version" '.ipfs.version = $ipfs_version' \
| jq --arg ipfs_addr "$ipfs_addr" '.ipfs.addr = $ipfs_addr' \
| jq --arg gitannex_version "$gitannex_version" '.git_annex.version = $gitannex_version' \
| jq --unbuffered --arg gitannex_addr "$gitannex_addr" '.git_annex.addr = $gitannex_addr' \
> $config_path
