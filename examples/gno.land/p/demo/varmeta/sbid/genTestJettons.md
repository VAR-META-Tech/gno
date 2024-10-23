package main

import (
	"crypto/rand"
	"encoding/base64"
	"encoding/csv"
	"encoding/json"
	"fmt"
	"math/big"
	"os"
	"time"

	"github.com/ton-blockchain/ton/go/ton"
	"github.com/ton-blockchain/ton/go/ton/crypto"
	"github.com/ton-blockchain/ton/go/ton/wallet"
)

const (
	N = 20
	P = 6

	AIRDROP_START = 1722366929
	AIRDROP_END   = 1724183052
)

type AirdropData struct {
	Amount     *big.Int
	StartFrom  int64
	ExpireAt   int64
}

func convertToMerkleProof(c *ton.Cell) *ton.Cell {
	return ton.BeginCell().
		StoreUint(3, 8).
		StoreBuffer(c.Hash(0)).
		StoreUint(c.Depth(0), 16).
		StoreRef(c).
		EndCell(true)
}

func convertToPrunedBranch(c *ton.Cell) *ton.Cell {
	return ton.BeginCell().
		StoreUint(1, 8).
		StoreUint(1, 8).
		StoreBuffer(c.Hash(0)).
		StoreUint(c.Depth(0), 16).
		EndCell(true)
}

func generateWalletsWithAirdropData() (map[string]interface{}, error) {
	var allWallets [][][3]string
	workchain := 0
	totalSupply := big.NewInt(0)
	airdropData := make(map[string]AirdropData)

	for pack := 0; pack < P; pack++ {
		var wallets [][3]string
		for i := 0; i < N; i++ {
			mnemonic := crypto.GenerateMnemonic()
			keyPair, err := crypto.MnemonicToPrivateKey(mnemonic)
			if err != nil {
				return nil, err
			}
			wallet := wallet.NewV3R2(workchain, keyPair.PublicKey)
			amount := big.NewInt(int64(rand.Intn(22)+1) * 1e9)
			totalSupply.Add(totalSupply, amount)
			startFrom := AIRDROP_START
			expireAt := AIRDROP_START + (AIRDROP_END-AIRDROP_START)*(i+1)/N
			airdropData[wallet.Address().String()] = AirdropData{amount, startFrom, expireAt}
			wallets = append(wallets, [3]string{mnemonic, "v3r2", wallet.Address().String()})
		}
		for i := 0; i < N; i++ {
			mnemonic := crypto.GenerateMnemonic()
			keyPair, err := crypto.MnemonicToPrivateKey(mnemonic)
			if err != nil {
				return nil, err
			}
			wallet := wallet.NewV4(workchain, keyPair.PublicKey)
			amount := big.NewInt(int64(rand.Intn(22)+1) * 1e9)
			totalSupply.Add(totalSupply, amount)
			startFrom := AIRDROP_START
			expireAt := AIRDROP_START + (AIRDROP_END-AIRDROP_START)*(i+1)/N
			airdropData[wallet.Address().String()] = AirdropData{amount, startFrom, expireAt}
			wallets = append(wallets, [3]string{mnemonic, "v4", wallet.Address().String()})
		}
		for i := 0; i < N; i++ {
			mnemonic := crypto.GenerateMnemonic()
			keyPair, err := crypto.MnemonicToPrivateKey(mnemonic)
			if err != nil {
				return nil, err
			}
			wallet := wallet.NewV5R1(keyPair.PublicKey, -3)
			amount := big.NewInt(int64(rand.Intn(22)+1) * 1e9)
			totalSupply.Add(totalSupply, amount)
			startFrom := AIRDROP_START
			expireAt := AIRDROP_START + (AIRDROP_END-AIRDROP_START)*(i+1)/N
			airdropData[wallet.Address().String()] = AirdropData{amount, startFrom, expireAt}
			wallets = append(wallets, [3]string{mnemonic, "v5r1", wallet.Address().String()})
		}
		allWallets = append(allWallets, wallets)
	}

	airdropCell := ton.BeginCell().StoreDictDirect(airdropData).EndCell()
	merkleRoot := airdropCell.Hash(0)

	for pack := 0; pack < P; pack++ {
		wallets := allWallets[pack]
		var csvData [][]string
		for _, w := range wallets {
			mnemonic := w[0]
			walletType := w[1]
			address := w[2]
			airdrop := airdropData[address]
			amount := airdrop.Amount.String()
			startFrom := fmt.Sprintf("%d", airdrop.StartFrom)
			expireAt := fmt.Sprintf("%d", airdrop.ExpireAt)
			receiverProof := convertToMerkleProof(airdropCell)
			serializedProof := base64.StdEncoding.EncodeToString(receiverProof.ToBoc())
			csvData = append(csvData, []string{mnemonic, walletType, address, amount, startFrom, expireAt, serializedProof})
		}
		file, err := os.Create(fmt.Sprintf("wallets%d.csv", pack))
		if err != nil {
			return nil, err
		}
		defer file.Close()
		writer := csv.NewWriter(file)
		defer writer.Flush()
		writer.Write([]string{"mnemonic", "type", "address", "amount", "start_from", "expire_at", "receiver_proof"})
		writer.WriteAll(csvData)
	}

	serializedAirdropCell := airdropCell.ToBoc()
	err := os.WriteFile("airdropData.boc", serializedAirdropCell, 0644)
	if err != nil {
		return nil, err
	}

	return map[string]interface{}{
		"merkleRoot": merkleRoot,
		"allWallets": allWallets,
		"airdropData": airdropData,
		"totalSupply": totalSupply,
	}, nil
}

func run(provider *ton.NetworkProvider) error {
	isTestnet := provider.Network() != "mainnet"
	data, err := generateWalletsWithAirdropData()
	if err != nil {
		return err
	}

	ui := provider.UI()
	adminAddress, err := promptUserFriendlyAddress("Enter the address of the jetton owner (admin):", ui, isTestnet)
	if err != nil {
		return err
	}

	jettonMetadataUri, err := promptUrl("Enter jetton metadata uri (https://jettonowner.com/jetton.json)", ui)
	if err != nil {
		return err
	}

	merkleRoot := data["merkleRoot"].(*big.Int)
	allWallets := data["allWallets"].([][][3]string)

	walletCodeRaw, err := compile("JettonWallet")
	if err != nil {
		return err
	}
	walletCode := jettonWalletCodeFromLibrary(walletCodeRaw)
	minterCode, err := compile("JettonMinter")
	if err != nil {
		return err
	}
	minterContract := wallet.NewJettonMinter(adminAddress.Address(), walletCode, merkleRoot, jettonContentToCell(map[string]string{"uri": jettonMetadataUri}), data["totalSupply"].(*big.Int), nil)
	minter := provider.Open(minterContract)
	err = minter.SendDeploy(provider.Sender(), big.NewInt(1500000000))
	if err != nil {
		return err
	}
	fmt.Println("Minter deployed at address:", minter.Address().String())
	err = os.WriteFile("minter.json", []byte(fmt.Sprintf(`{"address":"%s"}`, minter.Address().String())), 0644)
	if err != nil {
		return err
	}

	mnemonic := allWallets[0][0][0]
	keyPair, err := crypto.MnemonicToPrivateKey(mnemonic)
	if err != nil {
		return err
	}
	walletContract := wallet.NewV3R2(0, keyPair.PublicKey)
	wallet := provider.Open(walletContract)
	time.Sleep(40 * time.Second)
	err = provider.Sender().Send(&ton.Message{
		To:   wallet.Address(),
		Value: big.NewInt(1e9),
	})
	if err != nil {
		return err
	}
	walletSender := wallet.Sender(keyPair.SecretKey)
	fmt.Println("Wallet address:", wallet.Address().String())

	jettonWalletContract := wallet.NewJettonWallet(wallet.Address(), minter.Address(), merkleRoot, walletCode)
	jettonWallet := provider.Open(jettonWalletContract)

	receiverProof := convertToMerkleProof(data["airdropData"].(map[string]AirdropData)[wallet.Address().String()].Amount)
	claimPayload := wallet.JettonWalletClaimPayload(receiverProof)

	err = jettonWallet.SendTransfer(walletSender, big.NewInt(300000000), big.NewInt(100000000), wallet.Address(), wallet.Address(), claimPayload, big.NewInt(1))
	if err != nil {
		return err
	}

	return nil
}

func main() {
	provider := ton.NewNetworkProvider("your_network_provider_url")
	err := run(provider)
	if err != nil {
		fmt.Println("Error:", err)
	}
}

