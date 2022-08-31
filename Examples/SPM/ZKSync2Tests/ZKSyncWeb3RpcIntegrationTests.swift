//
//  ZKSyncWeb3RpcIntegrationTests.swift
//  ZKSync2Tests
//
//  Created by Maxim Makhun on 7/26/22.
//

import XCTest
@testable import ZKSync2

//public class IntegrationZkSyncWeb3RpcTest {
//
//    private static final String L1_NODE = "http://127.0.0.1:8545";
//    private static final String L2_NODE = "http://127.0.0.1:3050";
//
//    private static final Token ETH = Token.createETH();
//
//    ZkSync zksync;
//    Credentials credentials;
//    EthSigner signer;
//
//    ZkSyncTransactionReceiptProcessor processor;
//
//    ZkTransactionFeeProvider feeProvider;
//
//    String contractAddress;
//
//    BigInteger chainId;
//
//    @Before
//    public void setUp() {
//        this.zksync = ZkSync.build(new HttpService(L2_NODE));
//        this.credentials = Credentials.create(ECKeyPair.create(BigInteger.ONE));
//
//        chainId = this.zksync.ethChainId().sendAsync().join().getChainId();
//
//        this.signer = new PrivateKeyEthSigner(credentials, chainId.longValue());
//
//        this.processor = new ZkSyncTransactionReceiptProcessor(this.zksync, 200, 100);
//
//        this.feeProvider = new DefaultTransactionFeeProvider(zksync, ETH);
//
//        this.contractAddress = "0x14ba05281495657b009103686f366d7761e7535b";
//    }
//
//    @Test
//    public void printChainId() {
//        System.out.println(chainId);
//        System.out.println(credentials.getAddress());
//    }
//
//    @Test
//    public void sendTestMoney() {
//        Web3j web3j = Web3j.build(new HttpService(L1_NODE));
//
//        String account = web3j.ethAccounts().sendAsync().join().getAccounts().get(0);
//
//        EthSendTransaction sent = web3j.ethSendTransaction(
//                        Transaction.createEtherTransaction(account, null, Convert.toWei("1", Unit.GWEI).toBigInteger(), BigInteger.valueOf(21_000L),
//                                this.credentials.getAddress(), Convert.toWei("1000000", Unit.ETHER).toBigInteger()))
//                .sendAsync().join();
//
//        assertResponse(sent);
//    }
//
//    @Test
//    public void testGetBalanceOfTokenL1() throws IOException {
//        Web3j web3j = Web3j.build(new HttpService(L1_NODE));
//        EthGetBalance getBalance = web3j
//                .ethGetBalance(this.credentials.getAddress(), DefaultBlockParameterName.LATEST)
//                .send();
//
//        System.out.printf("%s: %d\n", this.credentials.getAddress(), Numeric.toBigInt(getBalance.getResult()));
//    }
//
//    @Test
//    public void testDeposit() throws IOException {
//        Web3j web3j = Web3j.build(new HttpService(L1_NODE));
//        BigInteger chainId = web3j.ethChainId().send().getChainId();
//        TransactionManager manager = new RawTransactionManager(web3j, credentials, chainId.longValue());
//        ContractGasProvider gasProvider = new StaticGasProvider(Convert.toWei("1", Unit.GWEI).toBigInteger(), BigInteger.valueOf(555_000L));
//        TransactionReceipt receipt = EthereumProvider
//                .load(zksync, web3j, manager, gasProvider).join()
//                .deposit(ETH, Convert.toWei("100", Unit.ETHER).toBigInteger(), credentials.getAddress()).join();
//
//        System.out.println(receipt);
//    }
//
//    @Test
//    public void testGetBalanceOfNative() throws IOException {
//        EthGetBalance getBalance = this.zksync
//                .ethGetBalance(this.credentials.getAddress(), DefaultBlockParameterName.LATEST)
//                .send();
//
//        System.out.printf("%s: %d\n", this.credentials.getAddress(), Numeric.toBigInt(getBalance.getResult()));
//    }
//
//    @Test
//    public void testGetNonce() throws IOException {
//        EthGetTransactionCount getTransactionCount = this.zksync
//                .ethGetTransactionCount(this.credentials.getAddress(), DefaultBlockParameterName.LATEST)
//                .send();
//
//        System.out.printf("%s: %d\n", this.credentials.getAddress(), Numeric.toBigInt(getTransactionCount.getResult()));
//    }
//
//    @Test
//    public void testGetDeploymentNonce() throws Exception {
//        NonceHolder nonceHolder = NonceHolder.load(ZkSyncAddresses.NONCE_HOLDER_ADDRESS, this.zksync, new ReadonlyTransactionManager(this.zksync, this.credentials.getAddress()), new DefaultGasProvider());
//
//        BigInteger nonce = nonceHolder.getDeploymentNonce(this.credentials.getAddress()).send();
//
//        System.out.printf("%s: %d\n", this.credentials.getAddress(), nonce);
//    }
//
//    @Test
//    public void testGetTransactionReceipt() throws IOException {
//        TransactionReceipt receipt = this.zksync
//                .ethGetTransactionReceipt("0x16e5b7f2445a3d0a1200da416254011da7486e4d67d2ca037395741fb86cd1b3").send()
//                .getResult();
//
//        System.out.println(receipt);
//    }
//
//    @Test
//    public void testGetTransaction() throws IOException {
//        org.web3j.protocol.core.methods.response.Transaction receipt = this.zksync
//                .ethGetTransactionByHash("0x16e5b7f2445a3d0a1200da416254011da7486e4d67d2ca037395741fb86cd1b3").send()
//                .getResult();
//
//        System.out.println(receipt.getNonce());
//    }
//
//    @Test
//    public void testTransferNativeToSelf() throws IOException, TransactionException {
//        BigInteger nonce = this.zksync
//                .ethGetTransactionCount(this.credentials.getAddress(), ZkBlockParameterName.COMMITTED).send()
//                .getTransactionCount();
//
//        io.zksync.methods.request.Transaction estimate = io.zksync.methods.request.Transaction.createFunctionCallTransaction(
//                credentials.getAddress(),
//                credentials.getAddress(),
//                BigInteger.ZERO,
//                BigInteger.ZERO,
//                "0x"
//        );
//
//        EthEstimateGas estimateGas = zksync.ethEstimateGas(estimate).send();
//
//        EthGasPrice gasPrice = zksync.ethGasPrice().send();
//
//        assertResponse(estimateGas);
//        assertResponse(gasPrice);
//
//        System.out.printf("Fee for transaction is: %d\n", estimateGas.getAmountUsed().multiply(gasPrice.getGasPrice()));
//
//        Transaction712 transaction = new Transaction712(
//                chainId.longValue(),
//                nonce,
//                estimateGas.getAmountUsed(),
//                estimate.getTo(),
//                Convert.toWei(BigDecimal.valueOf(1), Unit.ETHER).toBigInteger(),
//                estimate.getData(),
//                BigInteger.valueOf(100000000L),
//                gasPrice.getGasPrice(),
//                credentials.getAddress(),
//                estimate.getEip712Meta()
//        );
//
//        String signature = signer.getDomain().thenCompose(domain -> signer.signTypedData(domain, transaction)).join();
//        byte[] message = TransactionEncoder.encode(transaction, TransactionEncoder.getSignatureData(signature));
//
//        EthSendTransaction sent = this.zksync.ethSendRawTransaction(Numeric.toHexString(message)).send();
//
//        assertResponse(sent);
//
//        TransactionReceipt receipt = this.processor.waitForTransactionReceipt(sent.getResult());
//
//        assertTrue(receipt::isStatusOK);
//    }
//
//    @Test
//    public void testTransferNativeToSelfWeb3j_Legacy() throws Exception {
//        Transfer transfer = new Transfer(this.zksync, new RawTransactionManager(this.zksync, this.credentials, chainId.longValue()));
//
//        TransactionReceipt receipt = transfer.sendFunds(
//                credentials.getAddress(),
//                BigDecimal.valueOf(1),
//                Unit.ETHER,
//                Convert.toWei("3", Unit.GWEI).toBigInteger(),
//                BigInteger.valueOf(50_000L)
//        ).send();
//
//        assertTrue(receipt::isStatusOK);
//    }
//
//    @Test
//    public void testTransferNativeToSelfWeb3j() throws Exception {
//        Transfer transfer = new Transfer(this.zksync, new ZkSyncTransactionManager(this.zksync, this.signer, this.feeProvider));
//
//        TransactionReceipt receipt = transfer.sendFunds(
//                credentials.getAddress(),
//                BigDecimal.valueOf(1),
//                Unit.ETHER,
//                BigInteger.ZERO,
//                BigInteger.valueOf(50_000L)
//        ).send();
//
//        assertTrue(receipt::isStatusOK);
//    }
//
//    @Test
//    public void testTransferTokenToSelf() throws IOException, TransactionException {
//        BigInteger nonce = this.zksync
//                .ethGetTransactionCount(this.credentials.getAddress(), ZkBlockParameterName.COMMITTED).send()
//                .getTransactionCount();
//
//        String tokenAddress = zksync.zksGetConfirmedTokens(0, (short) 100).send()
//                .getResult().stream()
//                .filter(token -> !token.isETH())
//                .map(Token::getL2Address)
//                .findFirst().orElseThrow(IllegalArgumentException::new);
//        Function transfer = ERC20.encodeTransfer(credentials.getAddress(), BigInteger.ZERO);
//        String calldata = FunctionEncoder.encode(transfer);
//
//        io.zksync.methods.request.Transaction estimate = io.zksync.methods.request.Transaction.createFunctionCallTransaction(
//                credentials.getAddress(),
//                tokenAddress,
//                BigInteger.ZERO,
//                BigInteger.ZERO,
//                calldata
//        );
//
//        EthEstimateGas estimateGas = zksync.ethEstimateGas(estimate).send();
//
//        EthGasPrice gasPrice = zksync.ethGasPrice().send();
//
//        assertResponse(estimateGas);
//        assertResponse(gasPrice);
//
//        System.out.printf("Fee for transaction is: %d\n", estimateGas.getAmountUsed().multiply(gasPrice.getGasPrice()));
//
//        Transaction712 transaction = new Transaction712(
//                chainId.longValue(),
//                nonce,
//                estimateGas.getAmountUsed(),
//                estimate.getTo(),
//                estimate.getValueNumber(),
//                estimate.getData(),
//                BigInteger.ZERO,
//                BigInteger.ZERO,
//                credentials.getAddress(),
//                estimate.getEip712Meta()
//        );
//
//        String signature = signer.getDomain().thenCompose(domain -> signer.signTypedData(domain, transaction)).join();
//        byte[] message = TransactionEncoder.encode(transaction, TransactionEncoder.getSignatureData(signature));
//
//        EthSendTransaction sent = this.zksync.ethSendRawTransaction(Numeric.toHexString(message)).send();
//
//        assertResponse(sent);
//
//        TransactionReceipt receipt = this.processor.waitForTransactionReceipt(sent.getResult());
//
//        assertTrue(receipt::isStatusOK);
//    }
//
//    @Test
//    public void testTransferTokenToSelfWeb3jContract() throws Exception {
//        ERC20 erc20 = ERC20.load(ETH.getL2Address(), this.zksync,
//                new ZkSyncTransactionManager(this.zksync, this.signer, this.feeProvider),
//                this.feeProvider);
//
//        TransactionReceipt receipt = erc20.transfer("0xe1fab3efd74a77c23b426c302d96372140ff7d0c", BigInteger.valueOf(1L)).send();
//
//        assertTrue(receipt::isStatusOK);
//    }
//
//    @Test
//    public void testWithdraw() throws IOException, TransactionException {
//        BigInteger nonce = this.zksync
//                .ethGetTransactionCount(this.credentials.getAddress(), ZkBlockParameterName.COMMITTED).send()
//                .getTransactionCount();
//        String l2EthBridge = zksync.zksGetBridgeContracts().send().getResult().getL2EthDefaultBridge();
//        final Function withdraw = new Function(
//                L2ETHBridge.FUNC_WITHDRAW,
//                Arrays.asList(new Address(credentials.getAddress()),
//                        new Address(ETH.getL2Address()),
//                        new Uint256(ETH.toBigInteger(1))),
//                Collections.emptyList());
//
//        String calldata = FunctionEncoder.encode(withdraw);
//
//        io.zksync.methods.request.Transaction estimate = io.zksync.methods.request.Transaction.createFunctionCallTransaction(
//                credentials.getAddress(),
//                l2EthBridge,
//                BigInteger.ZERO,
//                BigInteger.ZERO,
//                calldata
//        );
//
//        EthEstimateGas estimateGas = zksync.ethEstimateGas(estimate).send();
//
//        EthGasPrice gasPrice = zksync.ethGasPrice().send();
//
//        assertResponse(estimateGas);
//        assertResponse(gasPrice);
//
//        System.out.printf("Fee for transaction is: %d\n", estimateGas.getAmountUsed().multiply(gasPrice.getGasPrice()));
//
//        Transaction712 transaction = new Transaction712(
//                chainId.longValue(),
//                nonce,
//                estimateGas.getAmountUsed(),
//                estimate.getTo(),
//                estimate.getValueNumber(),
//                estimate.getData(),
//                BigInteger.ZERO,
//                BigInteger.ZERO,
//                credentials.getAddress(),
//                estimate.getEip712Meta()
//        );
//
//        String signature = signer.getDomain().thenCompose(domain -> signer.signTypedData(domain, transaction)).join();
//        byte[] message = TransactionEncoder.encode(transaction, TransactionEncoder.getSignatureData(signature));
//
//        EthSendTransaction sent = this.zksync.ethSendRawTransaction(Numeric.toHexString(message)).send();
//
//        assertResponse(sent);
//
//        TransactionReceipt receipt = this.processor.waitForTransactionReceipt(sent.getResult());
//
//        assertTrue(receipt::isStatusOK);
//    }
//
//    @Test
//    public void testEstimateGas_Withdraw() throws IOException {
//        String l2EthBridge = zksync.zksGetBridgeContracts().send().getResult().getL2EthDefaultBridge();
//        final Function withdraw = new Function(
//                L2ETHBridge.FUNC_WITHDRAW,
//                Arrays.asList(new Address(credentials.getAddress()),
//                        new Address(ETH.getL2Address()),
//                        new Uint256(ETH.toBigInteger(1))),
//                Collections.emptyList());
//
//        String calldata = FunctionEncoder.encode(withdraw);
//
//        EthEstimateGas estimateGas = zksync.ethEstimateGas(io.zksync.methods.request.Transaction.createFunctionCallTransaction(
//                credentials.getAddress(),
//                l2EthBridge,
//                BigInteger.ZERO,
//                BigInteger.ZERO,
//                calldata
//        )).send();
//
//        assertResponse(estimateGas);
//    }
//
//    @Test
//    public void testEstimateGas_TransferNative() throws IOException {
//        io.zksync.methods.request.Transaction estimate = io.zksync.methods.request.Transaction.createFunctionCallTransaction(
//                credentials.getAddress(),
//                credentials.getAddress(),
//                BigInteger.ZERO,
//                BigInteger.ZERO,
//                "0x"
//        );
//
//        EthEstimateGas estimateGas = zksync.ethEstimateGas(estimate).send();
//
//        assertResponse(estimateGas);
//    }
//
//    @Test
//    public void testEstimateGas_Execute() throws IOException {
//        Function transfer = ERC20.encodeTransfer("0xe1fab3efd74a77c23b426c302d96372140ff7d0c", BigInteger.valueOf(1L));
//        String calldata = FunctionEncoder.encode(transfer);
//
//        EthEstimateGas estimateGas = zksync.ethEstimateGas(io.zksync.methods.request.Transaction.createFunctionCallTransaction(
//                credentials.getAddress(),
//                "0x79f73588fa338e685e9bbd7181b410f60895d2a3",
//                BigInteger.ZERO,
//                BigInteger.ZERO,
//                calldata
//        )).send();
//
//        assertResponse(estimateGas);
//    }
//
//    @Test
//    public void testEstimateFee_DeployContract() throws IOException {
//        EthEstimateGas estimateGas = zksync.ethEstimateGas(io.zksync.methods.request.Transaction.create2ContractTransaction(
//                credentials.getAddress(),
//                BigInteger.ZERO,
//                BigInteger.ZERO,
//                CounterContract.BINARY
//        )).send();
//
//        assertResponse(estimateGas);
//    }
//
//    @Test
//    public void testDeployWeb3jContract() throws Exception {
//        TransactionManager transactionManager = new ZkSyncTransactionManager(zksync, signer, feeProvider);
//        CounterContract contract = CounterContract
//                .deploy(zksync, transactionManager, feeProvider).send();
//
//        assertNotNull(contract.getContractAddress());
//        System.out.println(contract.getContractAddress());
//
//        this.contractAddress = contract.getContractAddress();
//    }
//
//    @Test
//    public void testReadWeb3jContract() throws Exception {
//        TransactionManager transactionManager = new ZkSyncTransactionManager(zksync, signer, feeProvider);
//        CounterContract zkCounterContract = CounterContract.load(contractAddress, zksync, transactionManager, feeProvider);
//
//        BigInteger result = zkCounterContract.get().send();
//
//        System.out.println(result);
//
//        assertEquals(BigInteger.ZERO, result);
//    }
//
//    @Test
//    public void testWriteWeb3jContract() throws Exception {
//        TransactionManager transactionManager = new ZkSyncTransactionManager(zksync, signer, feeProvider);
//        CounterContract zkCounterContract = CounterContract.load(contractAddress, zksync, transactionManager, feeProvider);
//
//        TransactionReceipt receipt = zkCounterContract.increment(BigInteger.TEN).send();
//
//        assertTrue(receipt::isStatusOK);
//
//        BigInteger result = zkCounterContract.get().send();
//
//        assertEquals(BigInteger.TEN, result);
//    }
//
//    @Test
//    public void testDeployContract_Create() throws IOException, TransactionException {
//        BigInteger nonce = this.zksync
//                .ethGetTransactionCount(this.credentials.getAddress(), DefaultBlockParameterName.PENDING).send()
//                .getTransactionCount();
//
//        String precomputedAddress = ContractDeployer.computeL2CreateAddress(new Address(this.credentials.getAddress()), nonce).getValue();
//
//        io.zksync.methods.request.Transaction estimate = io.zksync.methods.request.Transaction.createContractTransaction(
//                credentials.getAddress(),
//                BigInteger.ZERO,
//                BigInteger.ZERO,
//                CounterContract.BINARY
//        );
//
//        EthEstimateGas estimateGas = zksync.ethEstimateGas(estimate).send();
//        EthGasPrice gasPrice = zksync.ethGasPrice().send();
//
//        assertResponse(estimateGas);
//        assertResponse(gasPrice);
//
//        System.out.printf("Fee for transaction is: %d\n", estimateGas.getAmountUsed().multiply(gasPrice.getGasPrice()));
//
//        Transaction712 transaction = new Transaction712(
//                chainId.longValue(),
//                nonce,
//                estimateGas.getAmountUsed(),
//                estimate.getTo(),
//                estimate.getValueNumber(),
//                estimate.getData(),
//                BigInteger.valueOf(100000000L),
//                gasPrice.getGasPrice(),
//                credentials.getAddress(),
//                estimate.getEip712Meta()
//        );
//
//        String signature = signer.getDomain().thenCompose(domain -> signer.signTypedData(domain, transaction)).join();
//        byte[] message = TransactionEncoder.encode(transaction, TransactionEncoder.getSignatureData(signature));
//
//        EthSendTransaction sent = this.zksync.ethSendRawTransaction(Numeric.toHexString(message)).send();
//
//        assertResponse(sent);
//
//        TransactionReceipt receipt = this.processor.waitForTransactionReceipt(sent.getResult());
//
//        assertTrue(receipt::isStatusOK);
//
//        this.contractAddress = receipt.getContractAddress();
//        System.out.println("Deployed `CounterContract as: `" + this.contractAddress);
//        assertEquals(this.contractAddress.toLowerCase(), precomputedAddress.toLowerCase());
//
//        Transaction call = Transaction.createEthCallTransaction(
//                credentials.getAddress(),
//                contractAddress,
//                FunctionEncoder.encode(CounterContract.encodeGet())
//        );
//
//        zksync.ethCall(call, ZkBlockParameterName.COMMITTED).send();
//    }
//
//    @Test
//    public void testDeployContractWithConstructor_Create() throws IOException, TransactionException {
//        BigInteger nonce = this.zksync
//                .ethGetTransactionCount(this.credentials.getAddress(), DefaultBlockParameterName.PENDING).send()
//                .getTransactionCount();
//
//        String precomputedAddress = ContractDeployer.computeL2CreateAddress(new Address(this.credentials.getAddress()), nonce).getValue();
//
//        String constructor = ConstructorContract.encodeConstructor(BigInteger.valueOf(42), BigInteger.valueOf(43), false);
//
//        io.zksync.methods.request.Transaction estimate = io.zksync.methods.request.Transaction.createContractTransaction(
//                credentials.getAddress(),
//                BigInteger.ZERO,
//                BigInteger.ZERO,
//                ConstructorContract.BINARY,
//                constructor
//        );
//
//        EthEstimateGas estimateGas = zksync.ethEstimateGas(estimate).send();
//        EthGasPrice gasPrice = zksync.ethGasPrice().send();
//
//        assertResponse(estimateGas);
//        assertResponse(gasPrice);
//
//        System.out.printf("Fee for transaction is: %d\n", estimateGas.getAmountUsed().multiply(gasPrice.getGasPrice()));
//
//        Transaction712 transaction = new Transaction712(
//                chainId.longValue(),
//                nonce,
//                estimateGas.getAmountUsed(),
//                estimate.getTo(),
//                estimate.getValueNumber(),
//                estimate.getData(),
//                BigInteger.ZERO,
//                BigInteger.ZERO,
//                credentials.getAddress(),
//                estimate.getEip712Meta()
//        );
//
//        String signature = signer.getDomain().thenCompose(domain -> signer.signTypedData(domain, transaction)).join();
//        byte[] message = TransactionEncoder.encode(transaction, TransactionEncoder.getSignatureData(signature));
//
//        EthSendTransaction sent = this.zksync.ethSendRawTransaction(Numeric.toHexString(message)).send();
//
//        assertResponse(sent);
//
//        TransactionReceipt receipt = this.processor.waitForTransactionReceipt(sent.getResult());
//
//        assertTrue(receipt::isStatusOK);
//
//        this.contractAddress = receipt.getContractAddress();
//        System.out.println("Deployed `ConstructorContract as: `" + this.contractAddress);
//        assertEquals(this.contractAddress.toLowerCase(), precomputedAddress.toLowerCase());
//
//        Transaction call = Transaction.createEthCallTransaction(
//                credentials.getAddress(),
//                contractAddress,
//                FunctionEncoder.encode(ConstructorContract.encodeGet())
//        );
//
//        zksync.ethCall(call, ZkBlockParameterName.COMMITTED).send();
//    }
//
//    @Test
//    public void testDeployContract_Create2() throws IOException, TransactionException {
//        BigInteger nonce = this.zksync
//                .ethGetTransactionCount(this.credentials.getAddress(), DefaultBlockParameterName.PENDING).send()
//                .getTransactionCount();
//
//        String precomputedAddress = ContractDeployer.computeL2Create2Address(new Address(this.credentials.getAddress()), Numeric.hexStringToByteArray(CounterContract.BINARY), new byte[]{}, new byte[32]).getValue();
//
//        io.zksync.methods.request.Transaction estimate = io.zksync.methods.request.Transaction.create2ContractTransaction(
//                credentials.getAddress(),
//                BigInteger.ZERO,
//                BigInteger.ZERO,
//                CounterContract.BINARY
//        );
//
//        EthEstimateGas estimateGas = zksync.ethEstimateGas(estimate).send();
//        EthGasPrice gasPrice = zksync.ethGasPrice().send();
//
//        assertResponse(estimateGas);
//        assertResponse(gasPrice);
//
//        System.out.printf("Fee for transaction is: %d\n", estimateGas.getAmountUsed().multiply(gasPrice.getGasPrice()));
//
//        Transaction712 transaction = new Transaction712(
//                chainId.longValue(),
//                nonce,
//                estimateGas.getAmountUsed(),
//                estimate.getTo(),
//                estimate.getValueNumber(),
//                estimate.getData(),
//                BigInteger.ZERO,
//                BigInteger.ZERO,
//                credentials.getAddress(),
//                estimate.getEip712Meta()
//        );
//
//        String signature = signer.getDomain().thenCompose(domain -> signer.signTypedData(domain, transaction)).join();
//        byte[] message = TransactionEncoder.encode(transaction, TransactionEncoder.getSignatureData(signature));
//
//        EthSendTransaction sent = this.zksync.ethSendRawTransaction(Numeric.toHexString(message)).send();
//
//        assertResponse(sent);
//
//        TransactionReceipt receipt = this.processor.waitForTransactionReceipt(sent.getResult());
//
//        assertTrue(receipt::isStatusOK);
//
//        this.contractAddress = receipt.getContractAddress();
//        System.out.println("Deployed `CounterContract as: `" + this.contractAddress);
//        assertEquals(this.contractAddress.toLowerCase(), precomputedAddress.toLowerCase());
//
//        Transaction call = Transaction.createEthCallTransaction(
//                credentials.getAddress(),
//                contractAddress,
//                FunctionEncoder.encode(CounterContract.encodeGet())
//        );
//
//        zksync.ethCall(call, ZkBlockParameterName.COMMITTED).send();
//    }
//
//
//    @Test
//    public void testExecuteContract() throws IOException, TransactionException {
//        BigInteger nonce = this.zksync
//                .ethGetTransactionCount(this.credentials.getAddress(), ZkBlockParameterName.COMMITTED).send()
//                .getTransactionCount();
//
//        Transaction call = Transaction.createEthCallTransaction(
//                credentials.getAddress(),
//                contractAddress,
//                FunctionEncoder.encode(CounterContract.encodeGet())
//        );
//
//        BigInteger value = Numeric.toBigInt(zksync.ethCall(call, ZkBlockParameterName.COMMITTED).send().getValue());
//
//        Function increment = CounterContract.encodeIncrement(BigInteger.ONE);
//        String calldata = FunctionEncoder.encode(increment);
//
//        io.zksync.methods.request.Transaction estimate = io.zksync.methods.request.Transaction.createFunctionCallTransaction(
//                credentials.getAddress(),
//                this.contractAddress,
//                BigInteger.ZERO,
//                BigInteger.ZERO,
//                calldata
//        );
//
//        EthEstimateGas estimateGas = zksync.ethEstimateGas(estimate).send();
//        EthGasPrice gasPrice = zksync.ethGasPrice().send();
//
//        assertResponse(estimateGas);
//        assertResponse(gasPrice);
//
//        System.out.printf("Fee for transaction is: %d\n", estimateGas.getAmountUsed().multiply(gasPrice.getGasPrice()));
//
//        Transaction712 transaction = new Transaction712(
//                chainId.longValue(),
//                nonce,
//                estimateGas.getAmountUsed(),
//                estimate.getTo(),
//                estimate.getValueNumber(),
//                estimate.getData(),
//                BigInteger.ZERO,
//                BigInteger.ZERO,
//                credentials.getAddress(),
//                estimate.getEip712Meta()
//        );
//
//        String signature = signer.getDomain().thenCompose(domain -> signer.signTypedData(domain, transaction)).join();
//        byte[] message = TransactionEncoder.encode(transaction, TransactionEncoder.getSignatureData(signature));
//
//        EthSendTransaction sent = this.zksync.ethSendRawTransaction(Numeric.toHexString(message)).send();
//
//        assertResponse(sent);
//
//        TransactionReceipt receipt = this.processor.waitForTransactionReceipt(sent.getResult());
//
//        assertTrue(receipt::isStatusOK);
//
//        BigInteger result = Numeric.toBigInt(zksync.ethCall(call, ZkBlockParameterName.COMMITTED).send().getValue());
//
//        assertEquals(value.add(BigInteger.ONE), result);
//
//    }
//}

class ZKSyncWeb3RpcIntegrationTests: XCTestCase {
    
    var zkSync: ZKSync!
    
    override func setUpWithError() throws {
        let url = URL(string: "http://206.189.96.247:3050")!
        zkSync = JsonRpc2_0ZkSync(transport: HTTPTransport(url))
    }
    
    override func tearDownWithError() throws {
        
    }

    func sendTestMoney() {
        
    }
    
    func testGetBalanceOfTokenL1() {
        
    }
    
    func testDeposit() {
        
    }
    
    func testGetBalanceOfNative() {
        
    }
    
    func testGetNonce() {
        
    }
    
    func testGetDeploymentNonce() {
        
    }
    
    func testGetTransactionReceipt() {
        
    }

    func testGetTransaction() {
        
    }
    
    func testTransferNativeToSelf() {
        
    }
    
    func testTransferNativeToSelfWeb3j_Legacy() {
        
    }
    
    func testTransferNativeToSelfWeb3j() {
        
    }
    
    func testTransferTokenToSelf() {
        
    }
    
    func testTransferTokenToSelfWeb3jContract() {
        
    }
    
    func testWithdraw() {
        
    }
    
    func testEstimateGas_Withdraw() {
        
    }
    
    func testEstimateGas_TransferNative() {
        
    }
    
    func testEstimateGas_Execute() {
        
    }
    
    func testEstimateFee_DeployContract() {
        
    }
    
    func testDeployWeb3jContract() {
        
    }
    
    func testReadWeb3jContract() {
        
    }
    
    func testWriteWeb3jContract() {
        
    }
    
    func testDeployContract_Create() {
        
    }
    
    func testDeployContractWithConstructor_Create() {
        
    }
    
    func testDeployContract_Create2() {
        
    }
    
    func testExecuteContract() {
        
    }
    
    func testGetAllAccountBalances() {
        let expectation = expectation(description: "Expectation.")
        // TODO: Add credentials storage.
        zkSync.zksGetAllAccountBalances("0x7e5f4552091a69125d5dfcb7b8c2659029395bdf") { accountBalances in
            switch accountBalances {
            case .success(let result):
                print(result)
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetConfirmedTokens() {
        let offset = 0
        // Last 10 transactions.
        let limit = 10
        
        let expectation = expectation(description: "Expectation.")
        zkSync.zksGetConfirmedTokens(offset,
                                     limit: limit) { result in
            switch result {
            case .success(let tokens):
                print(tokens)
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    // FIXME: Clarify whether this method is needed.
    func testIsTokenLiquid() {
        let expectation = expectation(description: "Expectation.")
        zkSync.zksIsTokenLiquid(Token.ETH.l2Address) { result in
            switch result {
            case .success(let isTokenLiquid):
                XCTAssertTrue(isTokenLiquid)
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetTokenPrice() {
        let expectedTokenPrice: Decimal = 3500.0
        let expectation = expectation(description: "Expectation.")
        zkSync.zksGetTokenPrice(Token.ETH.l2Address) { result in
            switch result {
            case .success(let tokenPrice):
                XCTAssertEqual(tokenPrice, expectedTokenPrice)
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetL1ChainId() {
        let expectation = expectation(description: "Expectation.")
        zkSync.zksL1ChainId { result in
            switch result {
            case .success(let chainId):
                print(chainId)
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetBridgeContracts() {
        let expectation = expectation(description: "Expectation.")
        zkSync.zksGetBridgeContracts() { result in
            switch result {
            case .success(let bridgeAddresses):
                print(bridgeAddresses)
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
