# Tutorial 1 & 2 🏗️

> Copyright is Reserved by Zehua Wang @UBC zwang@ece.ubc.ca.
> 
> This markdown version is modified from original one by [@corsola](https://github.com/wus53) wus5353@gmail.com
> 
> Some instructions are updated according to latest resource by the time of writing (Jan. 2023).

## Tutorial 1: Set up a private network with Ethereum on a single machine

### Software needs to be installed
   - Go-ethereum can be installed with the built images which are downable here: https://geth.ethereum.org/downloads
   - Detailed installation instructions can be found here: https://geth.ethereum.org/docs/getting-started/installing-geth

### Installation verification
   - Open a shell or terminal, try to execute `geth --help`. If the help information of `geth` command is shown, it means you have installed the software correctly.
   - If the installation has been finished but the terminal does not show the help information when you run `geth --help`, it may be caused by the settings of your environment variables. Check the installation location of geth and there should be a directory which contains executable files such as “geth”, “bootnode”, “wnode”, etc. Adding the directory in the `PATH` variables should make the terminal find these commands.

### Creating/using a genesis block
   - Genesis block is the first block in a block chain. The peers and miners in the same network should have the identical genesis block for all the following blocks to be mined. The genesis block can be created by a text file.  As an example, we have a file `genesis.json` in current directory. There are many fields defined in the file. While, for now, we only need to keep in mind the field `chainId`. Each chain has its unique `chainId`. In the public network of Ethereum, the public chain has the `chainId` equal to 1. For private and test networks, we can use any integer **except** 1. If you want to run a private network on the local machine, please randomly choose an integer as your `chainId`. For other fields in genesis.json, please refer to https://lightrains.com/blogs/genesis-json-parameter-explained-ethereum for more information if you are interested. Now, please choose your own `chainId` and save the `genesis.json` file.

### Creating a peer in the private network by specifying the genesis block
#### Some rules for peers in a private network:
  - Each peer should have its own directory/folder by using `--datadir`.
  - Each running peer should have its own port number (by using `--port`) and remote process communication port number (by using `--http.port`).
  - In case you want to have more than one terminals being associated with the same running peer, the running peer should have a unique inter-process communication pipe (by using `--ipcpath`)
#### Create a new peer (not running automatically).
  - Change directory to current directory `cd ./go-ethereum`
  - Create a new directory called `ethereum` (other names for the new directory are also OK, but please keep the consistency for the rest steps in the tutorial). Put `genesis.json` file to the new directory. Now, the file `genesis.json` should be at /go-ethereum/ethereum/genesis.json.
  - Create the new peer by running the following command:
  
     ```shell
     geth --datadir "./ethereum/peer1" init ./ethereum/genesis.json
     ```
  - A new directory `peer1` should be created. You can also use other directory names if you want, but please keep the consistency in the following steps of the tutorial. In the directory `peer1`, there are two folders. Folder `geth` saves the configurations and `keystore` saves the wallets of accounts that the peer may have. Since we have not yet created any wallets, the keystore folder should be empty.
#### Run the peer
  - The peer that we have created is not running right now. To run the peer, please use the following command with the chaindId replaced by the chaindId in your genesis.json:
  
     ```shell
     geth --datadir "./ethereum/peer1" --nodiscover --networkid 24601 --port 12341 --http --http.port 9001 --authrpc.port 8551 --http.corsdomain "*" --ipcpath "./ethereum/peer1/geth1.ipc" console
     ```
  - Some information starts to show on the screen. The information is self-explanatory, so you can briefly go through it. Please locate the line as follows:
  
     ```js
      INFO [mm-dd|hh:mm:ss.msc] Started P2P networking   self="peer1-id@ip-address:port?discport=0"
     ```
  - The part we are interested should be the day, month, hour, minutes, second, millisecond, the running ethereum node id, the ip of the running node, and the port number of the running node. Remember the `peer1-id@ip-address:port?discport=0`, we will use it later. Note that the "peer1-id", "ip-address", and "port" may be with different values for different persons.
  - The value after `--datadir` should be the directory that you have just created. The value of `--networkid` should be identical with the `chainId` in your `genesis.json` file. The `--port` parameter is for the communication purpose of other peers in the same private network. If you do not use `--port`, the default value of port will be `30303`. We will create the second peer in the same private network later.
  - Option `--http` is to enable the Remote Procedure Call for this running peer. In particular, `--http.port` specifies what the port number that the peer listens on to receive the remote process callings (default value will be 8545) and `--http.corsdomain` plays as a filter for the domain names or IP addresses that the remote procedure callings come from. The wild card `"*"` after `--http.corsdomain` simply means that the peer accepts remote procedure calling from any remote hosts (and thus, it is risky).
  - The string parameter after `--ipcpath` is the location of the pipe for inter process communication purpose. In the example, the pipe file is at `./ethereum/peer1/geth1.ipc`. We can connect and control the same peer from another terminal by this command in a new terminal/shall.
  
     ```shell
     geth attach ./ethereum/peer1/geth1.ipc
     ``` 
  - After executing the command, we should see the following output:
  
     ```
     Welcome to the Geth JavaScript console!

     instance: Geth/v1.9.25-stable-e7872729/linux-amd64/go1.15.6
     at block: 0 (Wed Dec 31 1969 16:00:00 GMT-0800 (PST))
     datadir: /home/david/ethereum/peer1
     modules: admin:1.0 debug:1.0 eth:1.0 ethash:1.0 miner:1.0 net:1.0 personal:1.0 rpc:1.0 txpool:1.0 web3:1.0
     ```
  - We see there are some modules have been automatically loaded in the console, i.e., `admin`, `debug`, `eth`, `ethash`, `miner`, `net`, `personal`, `rpc`, `txpool`, and `web3`. In the given console, we can run some functions provided by these modules. For example, we can run `admin.nodeInfo` to see the information about the node. Since we have no other peers running in the same private network, there would be no other peers listed after running command `admin.peers` in the console.
  
### Run a second peer
#### Run a second peer with the following commands in a new terminal.
- First, run the following command in a new terminal under `go-ethereum` directory:

   ```shell
   geth --datadir "./ethereum/peer2" init ./ethereum/genesis.json
   ```
- Again, you can change the name of the directory to be created, but just need to keep consistency in the following steps of the tutorial. Then, run command:

   ```shell
   geth --datadir "./ethereum/peer2" --nodiscover --networkid 24601 --port 12342 --http --http.port 9002 --authrpc.port 8552 --http.corsdomain "*" --ipcpath "./ethereum/peer2/geth2.ipc" console
   ```
- Still, form the output, we need to locate something like

   ```js
   INFO [mm-dd|hh:mm:ss.msc] Started P2P networking   self="peer2-id@ip-address:port?discport=0"
   ```
   Remember the `peer2-id@ip-address:port?discport=0`, we will use it later. Note that the `peer2-id`, `ip-address`, and `port` may be with different values for different persons.
- Now, the second peer is running in the second terminal. However, these two peers cannot see each other yet. Thus, if we run command `admin.peers` now in one of the two consoles, we still cannot see the other peer in the private network, even though both of the two peers have the same `networkid` equal to `chainId` in your `genesis.json`. While, `networkid` can be also revealed by running `admin.nodeInfo` in the console of the running peer.

#### To trigger the node discovery, we need to run admin.addPeer() function.
- We can choose either one of these two peers to add the other. Assume that we are in the console of the first peer. We need to run command with `peer2-id`:

   ```js
   admin.addPeer("peer2-id@ip-address:port?discport=0")
   ```
   `peer2-id`, `ip-address`, and `port` should be the same with the values you have found above).

### Create your first account and mine the blocks
- We have no account on either of the peers. We have to create an account before mining, so the rewards of mining blocks can be received by the account. 
- Run command

   ```js
   personal.newAccount()
   ```
   in the first terminal. According to the name of the above command, we should realize that there is actually a function called `newAccount()`, requiring no argument, defined in the module `personal`.
- The console will ask you to enter the password twice. There is no way to recover your password if you forget it, so please remember your password firmly. We suggest using `EECE571` as the password for test purposes.
- Assume the command `personal.newAccount()` has been executed in the console of the first peer, now in the console  we can call function 

   ```js
   miner.start(1)
   ```
   to start the mining process with 1 worker. You can also increase the number if you want. Apparently, you may not want to occupy too many workers if you are mining with CPU, since your computer will be very slow due to the limited number of cores on your CPU. However, the more workers we use, the faster the blocks can be generated in your block chain. It will return you a null after you run the command, but it is OK.
- Now, run command 

   ```js
   eth.blockNumber
   ```
   in the same terminal, it will show you the number of blocks in the current block chain. The number of blocks in the current block chain should increase as your mining process is going.
- Run command `eth.blockNumber` in the other console, it will show you the number of blocks as well. The value should be the same with that in your first console.
- Using the command

   ```js
   miner.stop()
   ```
   to stop the mining process, and the results of `eth.blockNumber` would not change any more in both consoles.
 
#### Check your balance after mining
- Assume you have run `miner.start(3)` in a console for a while, you can check your balance in the same console by running

   ```js
   eth.getBalance(eth.accounts[0])
   ```
   Here, `eth.accounts` will return a list of all accounts that we have created for the peers. Since we have just created one account, `eth.accounts[0]` returns the only account that we have with the peer. Function `eth.getBalance()` takes an account as the input argument to check its balance.

### Extensions
- More peers can be created and added into the private network. Note that **each peer should be placed in a new directory and run with a unique port number, remote process communication port number, and inter process communication path**.
- The new created peer cannot be automatically known by the existing peers. In the next tutorial, we will introduce `bootnode` which is a server process automatically notifying the existing peers for a new joining peer.
- Each peer could be a miner and all these peers can mine the blocks together. Note that for the miner to run, as least one account should be created.

### Tutorial 1 Footnotes
- If you have any problems when you try to reproduce the experiment, please reach out for help.

   - zwang@ece.ubc.ca (Original author)
   - wus5353@gmail.com (Markdown version contributor)
- In the next tutorial, we will learn how to enable the peers in a private network to discover each other automatically and how to create a transaction to transfer Ethers between accounts.

---

## Tutorial 2: Automatical peer discovery and sending transactions

### Install node version manager. Please read through steps before running any command.
- node version manager (nvm) Please go to this page and follow the steps: https://github.com/nvm-sh/nvm
- If you do not want to read, in most of the cases, simply running the following command (on Linux/Unix) should work:

   ```shell
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
   ```
- Close your console/terminal and start a new one. In the new terminal, run

   ```shell
   command -v nvm
   ```
   If you see nvm, it means you have nvm installed successfully.
- Run each of the following command

   ```shell
   nvm install 8.0.0 
   nvm install 12.13.0
   nvm use 8.0.0
   node --version
   nvm use 12.13.0
   node --version
   ```
   Now, you should know how to install and switch between different versions of node.

### Verification of the installation:
- Run the following command to use node version 8.

   ```shell
   nvm use 8.0.0
   ```
- Clone the following repo to your local machine

   ```shell
   git clone https://github.com/sthnaqvi/explorer
   ```
- Change directory to the cloned repo

   ```shell
   cd explorer
   ```
- In the terminal, run the following command (**make sure** you are using node version 8.0.0, have python2 (Python 2.7 works for me) installed in your computer, and have PYTHON env variable configured correctly, otherwise the command will not run successfully)

   ```shell
   npm install
   ```
- In the cloned repo, find file /explorer/app/app.js and change `8545` in `line 9` to `9001`, which is the value of `--http.port` of your running peer1.
- Make sure you have done the first tutorial and have several blocks mined already in your private blockchain. Make sure your peer1 is also running in another terminal/console. Then, please run

   ```shell
   npm start
   ```
- If the installation is successful, we can be the following output:

   ```js
   Starting up http-webnode, serving ./app
   Available on:
     http://localhost:8000
   Hit CTRL-C to stop the server
   ```
- Open your web browser and go to http://localhost:8000 you can now view the mined blocks like this:

   ![image](https://user-images.githubusercontent.com/118578313/214979341-ce1129c3-85ba-42f8-be82-58edb41a4568.png)

### Usage of bootnode
- Assume we have created *x* peers in the private network. If we want all of them know each other, we need to call function `admin.addPeer()` for *x(x-1)/2* times. It is definitely not a good solution to add them one by one, so we have the `bootnode` provided with `geth` to automatically add new peers in the network and let peers know each other.
- There are three steps to use bootnode: **create it**, **run it**, and **use it**.

   - **Create it**. Use command under current directory `(/go-ethereum)`
   
      ```shell
      bootnode -genkey ./ethereum/bootnode.key
      ```
      to create a `bootnode.key` file.
      The utility program `bootnode` should be in the same directory of `geth`. Option `-genkey` is to create an ID for a new bootnode. You can pick a different location and choose a different file name if you want by changing the last argument in the above example. A new file `bootnode.key` will be generated after running this command.
   - **Run it**. In a new terminal, use this command to run the bootnode.
   
      ```shell
      bootnode -nodekey ./ethereum/bootnode.key -addr :39999
      ```
      We need to specify the nodekey by using option `-nodekey` follows the location of the file that you have just created. The bootnode program has a port number for communication purposes. The port number is specified by using `-addr` option. In this example, the port number is `39999`. Please note that we used a colon at the beginning. Running this command will create a process and we will see the following output in the terminal:
      
      ```
      enode://bootnode-id@ip-address:0?discport=39999
      Note: you're using cmd/bootnode, a developer tool.
      We recommend using a regular node as bootstrap node for production deployments.
      ```
      It is basically an enode with an address. In the output, the IP address of the bootnode. A running bootnode is just like a server. A new peer will communicate with the server and say “Hi, I am a new peer with ID: Blah-blah”. The server then broadcast the information of the new peer to all the existing peers in the network.
   - **Use it**. Please make sure that you have already terminated the first peer running by the previous tutorial, otherwise it would not work (as the port number is being used). The `geth` program has another option that we have not used in the previous tutorial, the `--bootnode`. To use it, we run the following command in a new terminal:
   
      ```shell
      geth --datadir "./ethereum/peer1" --networkid 24601 --port 12341 --http --http.port 9001 --authrpc.port 8551 --http.corsdomain "*" --ipcpath "./ethereum/peer1/geth1.ipc" --bootnodes "enode://bootnode-id@ip-address:0?discport=39999" console
      ```
      It is the same command that we used in the previous tutorial but with a new option `--bootnodes` `"enode://bootnode-id@ip-address:0?discport=39999"` and without the `–nodiscover` option.
   - Then, run a second peer by using the following command in a new terminal:
   
      ```shell
      geth --datadir "./ethereum/peer2" --networkid 24601 --port 12342 --http --http.port 9002 --authrpc.port 8552 --http.corsdomain "*" --ipcpath "./ethereum/peer2/geth2.ipc" --bootnodes "enode://bootnode-id@ip-address:0?discport=39999" console
      ```
      It should be noticed that both peers are using the same bootnode, so the second peer to be run can be automatically known by the first peer.
   - Now, in either of your two terminals, this command should list the other peer:
   
      ```js
      admin.peers
      ```

### Tips
- In some cases, you may see a lot of warnings **WARN** in the console. It is a little bit annoying to have so many warnings. So, you can open another terminal and connect to the console of the running peers by using

   ```shell
   geth attach ~/ethereum/peer1/geth1.ipc
   ```
  
### Sending "money" from one account to another
- Prerequisites
   - You should have at least two accounts, either on the same peer, or on different peers.
   - The sender must have enough balance to pay the transaction fee.
- From the previous tutorial, you should have an account in the first peer. This account should have sufficient amounts of “money” to send to another account, as long as the peer has mined some blocks. This is because the reward of mining a block is `2 ether`, which is `2e+18 wei`. `wei` is the smallest unit of "money" in Ethereum. Basically, `1 Ether = 1e+18 Wei`.
- Now, you can create another account for the second peer in the console where the second peer is running by using
   
   ```js
   personal.newAccount()
   ```
   command. Typing in your password twice and do not forget it. Also, EECE571 is suggested to be your password. The new account has a 160 bit hexadecimal value in a pair of quotation marks, e.g., `"0x0123456789abcdef0123456789abcdef01234567"`
- Assume we want to transfer "money" from the first account on the first peer to the account on the second peer. For ease of presentation, we use `HASH_ACNT_1` to represent the address of the sender account with double quotes included, and use `HASH_ACNT_2` to represent the address of the receiver account with double quotes included.
- We now use the following command to send money from `HASH_ACNT_1` to `HASH_ACNT_2`
   
   ```js
   eth.sendTransaction({from : HASH_ACNT_1, to : HASH_ACNT_2, value : 1e+18})
   ```
   The parameter in the function `sendTransaction()` is given in JavaScript Object Notation (JSON) with three fields. The order of these three values in JSON can be shuffled.
- Running the command probably will give you the following error.

   ```js
   Error: authentication needed: password or unlock
    at web3.js:6347:37(47)
    at web3.js:5081:62(37)
    at <eval>:1:20(10)
   ```
   This is because you have to first unlock the account `HASH_ACNT_1` before sending "money" out of it.
- To unlock the account, you can run either of the two following commands in the console of first peer:

   ```js
   personal.unlockAccount(HASH_ACNT_1)
   ```
   The terminal will ask you to enter the password. But, eventually, it says:
   
   ```js
   GoError: Error: account unlock with HTTP access is forbidden at web3.js:6347:37(47)
    at native
    at <eval>:1:24(3)
   ```
- In order to make the above steps work, we need to add `--allow-insecure-unlock` option when running the `peer1`. Now, terminate the running `peer1` and rerun it

   ```shell
   geth --datadir "./ethereum/peer1" --networkid 24601 --port 12341 --http --http.port 9001 --authrpc.port 8551 --http.corsdomain "*" --ipcpath "./ethereum/peer1/geth1.ipc" --bootnodes "enode://bootnode-id@ip-address:0?discport=39999" --allow-insecure-unlock console
   ```
- Please make sure there is no mining in the network. Then, repeat steps above, you will have the follows:

   ```js
   > personal.unlockAccount(HASH_ACNT_1)
   Unlock account 0x2974c433ad308226c24b9831c7a2ca511b990fd7
   Passphrase:
   true
   > eth.sendTransaction({from : HASH_ACNT_1, to : HASH_ACNT_2, value : 1e+18})
   "0x25e3befee9603c57d657e1541063f9787b372e82262273b36fa375d261318bb8"
   ```
- The returned hash code is the transaction ID, we use `HASH_TRANS_1` to represent it with both double quotes included.
- Run command

   ```js
   eth.pendingTransactions
   ```
   in the console of the first peer (i.e., the same console that you sent the transaction). It will list you the information about the transaction that you have just created. The transaction will not disappear from `eth.pendingTransactions` until a new block is mined and the transaction is inserted into it.
- Now, you can start a miner by calling

   ```js
   miner.start(1) 
   ```
   in either one of the two consoles. As long as a new block is mined, the transaction information will disappear when you run `eth.pendingTransactions` again. 
- After the transaction has been mined into a block, we can run command to see where the transaction is logged.
   
   ```js
   eth.getTransaction(HASH_TRANS_1)
   ```
- You can also try to play with the block explorer in the webpage at http://localhost:8000/. On the page, you can go through each of the mined blocks and locate the transaction. Or, you can search `HASH_TRANS_1` in the search box. You can also try to search `HASH_ACNT_1` or block number (e.g., 0, 1, 12, etc).
- Also using 
   ```js
   eth.getBalance(HASH_ACNT_2)
   ```
   command in the console of the peer1 where the receiver’s account exists to see that there should be 1e+18 Wei (which is 1 Ether) has been received by the receiver account. 

### Tutorial 2 Footnotes
- In this tutorial, we learnt how to run blockchain explorers for your private blockchain and how to create transact ions from your local wallet. In the next tutorial we will learn how to write the deploy a very simple smart contract.
- If you have any problems when you try to reproduce the experiment, please reach out for help.

   - zwang@ece.ubc.ca (Original author)
   - wus5353@gmail.com (Markdown version contributor)
- In the next tutorial, we will learn how to deploy a smart contact in the blockchain and call the functions defined in the smart contract.

