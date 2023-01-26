# Set up a private network with Ethereum on a single machine

> Copyright is Reserved by Zehua Wang @UBC zwang@ece.ubc.ca.
> 
> This markdown version of tutorial is modified from original one by [@corsola](https://github.com/wus53) wus5353@gmail.com
> 
> Some instructions are updated according to latest resource by the time of writing (Jan. 2023).

### Software needs to be installed
   - Go-ethereum can be installed with the built images which are downable here: https://geth.ethereum.org/downloads
   - Detailed installation instructions can be found here: https://geth.ethereum.org/docs/getting-started/installing-geth

### Installation verification
   - Open a shell or terminal, try to execute `geth --help`. If the help information of `geth` command is shown, it means you have installed the software correctly.
   - If the installation has been finished but the terminal does not show the help information when you run `geth --help`, it may be caused by the settings of your environment variables. Check the installation location of geth and there should be a directory which contains executable files such as “geth”, “bootnode”, “wnode”, etc. Adding the directory in the `PATH` variables should make the terminal find these commands.

### Creating/using a genesis block
   - Genesis block is the first block in a block chain. The peers and miners in the same network should have the identical genesis block for all the following blocks to be mined. The genesis block can be created by a text file.  As an example, we have a file `genesis.json` in current directory. There are many fields defined in the file. While, for now, we only need to keep in mind the field `chainId`. Each chain has its unique `chainId`. In the public network of Ethereum, the public chain has the `chainId` equal to 1. For private and test networks, we can use any integer **except** 1. If you want to run a private network on the local machine, please randomly choose an integer as your `chainId`. For other fields in genesis.json, please refer to https://lightrains.com/blogs/genesis-json-parameter-explained-ethereum for more information if you are interested. Now, please choose your own `chainId` and save the `genesis.json` file.

### Creating a peer in the private network by specifying the genesis block
- Some rules for peers in a private network:
  - Each peer should have its own directory/folder by using --datadir.
  - Each running peer should have its own port number (by using --port) and remote process communication port number (by using --http.port).
  - In case you want to have more than one terminals being associated with the same running peer, the running peer should have a unique inter-process communication pipe (by using --ipcpath)
- Create a new peer (not running automatically).
  - Create a new directory called ethereum (other names for the new directory are also OK, but please keep the consistency for the rest steps in the tutorial). Put genesis.json file to the new directory. Now, the file genesis.json should be at ~/ethereum/genesis.json.
  - Create the new peer by running the following command: 
  ```shell
    geth --datadir "./ethereum/peer1" init ./ethereum/genesis.json
  ```
  - A new directory peer1 should be created. You can also use other directory names if you want, but please keep the consistency in the following steps of the tutorial. In the directory peer1, there are two folders. Folder geth saves the configurations and keystore saves the wallets of accounts that the peer may have. Since we have not yet created any wallets, the keystore folder should be empty.
- Run the peer
  - The peer that we have created is not running right now. To run the peer, please use the following command with the chaindId replaced by the chaindId in your genesis.json: 
    ```shell
        geth --datadir "./ethereum/peer1" --nodiscover --networkid 24601 --port 12341 --http --http.port 9001 --authrpc.port 8551 --http.corsdomain "*" --ipcpath "./ethereum/peer1/geth1.ipc" console
    ```
  - Some information starts to show on the screen. The information is self-explanatory, so you can briefly go through it. Please locate the line as follows: INFO [mm-dd|hh:mm:ss.msc] Started P2P networking               self="peer1-id@ip-address:port?discport=0" 
  The highlighted part should be the day, month, hour, minutes, second, millisecond, the running ethereum node id, the ip of the running node, and the port number of the running node.
  Remember the peer1-id@ip-address:port?discport=0, we will use it later. Note that the "peer1-id", "ip-address", and "port" may be with different values for different persons.
  - The value after --datadir should be the directory that you have just created. The value of --networkid should be identical with the chainId in your genesis.json file. The --port parameter is for the communication purpose of other peers in the same private network. If you do not use --port, the default value of port will be 30303. We will create the second peer in the same private network later. Option --http is to enable the Remote Procedure Call for this running peer. In particular, --http.port specifies what the port number that the peer listens on to receive the remote process callings (default value will be 8545) and --http.corsdomain plays as a filter for the domain names or IP addresses that the remote procedure callings come from. The wild card "*" after --http.corsdomain simply means that the peer accepts remote procedure calling from any remote hosts (and thus, it is risky). The string parameter after --ipcpath is the location of the pipe for inter process communication purpose. In the example, the pipe file is at ~/ethereum/peer1/geth1.ipc. We can connect and control the same peer from another terminal by using command geth attach ~/ethereum/peer1/geth1.ipc in a new terminal/shall.