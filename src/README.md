## bip44 - Core Legacy, BSV and Bitcoin-cash

bip44 is a legacy standard for hierchical legacy wallets. bip32 means its a hierchical wallet of some sort and not a particular derivation path.

## bip49 - Core Segregated Witness

bip49 is for Segregated Witness, which is no interest for immutag: must be bitcoin cash or bsv for lower fees of opereturns.

See bip32_derive scripts for hal command. Verify with https://iancoleman.io/bip39/ from the mnemonic.

## p2pkh - Pay to Public Key Hash

This transaction method conceals public keys. p2wpkh is for Segregated Witness.

## User flow

This is a work-in-progess.

**Create a wallet (wallet_info.json) from a mnemonic.**

`cat example_mnemonic | ./create_wallet_info_file_from_mnemonic.sh`

**Add a file.**

`./cmd_add <file> <tags...>`

The above command will copy the file to `files/` and names it as a bip44 bitcoin address. It'll append `file-list.txt` in the following form:

<index> <address> <name> <extension> <tags..>

### Storage and versioning

The file list should be versioned with git. That way if tags are edited, all versions of the tags of a given universal-addressed file can be found in the version history.

## Lower-level commands.

Generate a mnemonic (entropy is low).

`./generate_bip39.sh`

Generate wallet info in json format from a 24 word mnemonic.

`cat example_mnemonic | ./generate_from_24_word_mnemonic.sh`

Get xpriv from generated mnemonic and info.

`cat wallet_info | ./get_xpriv_from_wallet_info.sh`

Get address at a specific index given a specific  xpriv.

```
cat wallet_info | ./get_xpriv_from_wallet_info.sh | \
./get_bip44_address_from_xpriv.sh <index>
```
