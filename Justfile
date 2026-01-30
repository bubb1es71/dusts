set quiet := true
wallet := "test"
datadir := "data"
chain := "main" # can also be main, test, testnet4, signet
logdir := if chain == "main" {
          "."
        } else if chain == "test" {
          "testnet"
        } else if chain == "testnet4" {
          "testnet4"
        } else if chain == "signet" {
          "signet"
        } else if chain == "regtest" {
          "regtest"
        } else {
          error("invalid chain: " + chain)
        }

# list of recipes
default:
  just --list
  echo "\nDefault variables:"
  just --evaluate

# format the project code
fmt:
    cargo fmt

# lint the project
clippy: fmt
    cargo clippy --tests

# build the project
build: clippy
    cargo build --tests

# test the project
test:
    cargo test --tests

# run the project
run *args: fmt
    cargo run --release -- {{args}}

# run gnuplot to plot the data
plot:
    gnuplot -p dusts.gp

# clean the project target directory
clean:
    cargo clean

# start bitcoind in default data directory
[group('rpc')]
start:
    if [ ! -d "{{datadir}}" ]; then \
        mkdir -p "{{datadir}}"; \
    fi
    bitcoind -datadir={{datadir}} -chain={{chain}} -txindex -server -fallbackfee=0.0002 -blockfilterindex=1 -peerblockfilters=1 -rpcallowip=0.0.0.0/0 -rpcbind=0.0.0.0 -daemon

# stop bitcoind
[group('rpc')]
stop:
    -bitcoin-cli -datadir={{datadir}} -chain={{chain}} stop

# tail bitcoind debug.log
[group('rpc')]
debug:
    tail {{datadir}}/{{logdir}}/debug.log

# dump txouts data to <datadir>/<chain>_utxo.dat file
[group('rpc')]
dumptxouts:
    bitcoin-cli -datadir={{datadir}} -chain={{chain}} -rpcwallet={{wallet}} dumptxoutset {{chain}}_utxo.dat latest

# run node getblockchaininfo command
[group('rpc')]
chaininfo:
    bitcoin-cli -datadir={{datadir}} -chain={{chain}} -rpcwallet={{wallet}} getblockchaininfo

# run node gettxoutsetinfo command
[group('rpc')]
txoutsinfo:
    bitcoin-cli -datadir={{datadir}} -chain={{chain}} -rpcwallet={{wallet}} gettxoutsetinfo

# run any bitcoin-cli rpc command
[group('rpc')]
rpc *command:
    bitcoin-cli -datadir={{datadir}} -chain={{chain}} -rpcwallet={{wallet}} {{command}}