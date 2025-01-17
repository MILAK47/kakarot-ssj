mod test_contract_account;
mod test_eoa;
use contracts::kakarot_core::interface::IExtendedKakarotCoreDispatcherTrait;
use contracts::tests::test_utils::{setup_contracts_for_testing, fund_account_with_native_token};
use evm::model::account::AccountTrait;
use evm::model::{Account, ContractAccountTrait, AccountType, EOATrait, AddressTrait};
use evm::tests::test_utils::{evm_address};
use openzeppelin::token::erc20::interface::IERC20CamelDispatcherTrait;
use starknet::testing::set_contract_address;

#[test]
#[available_gas(20000000)]
fn test_is_registered_eoa_exists() {
    // Given
    let (native_token, kakarot_core) = setup_contracts_for_testing();
    let eoa_address = EOATrait::deploy(evm_address()).expect('failed deploy contract account',);

    // When

    // When
    set_contract_address(kakarot_core.contract_address);
    let is_registered = AddressTrait::is_registered(evm_address());

    // Then
    assert(is_registered, 'account should be deployed');
}

#[test]
#[available_gas(20000000)]
fn test_is_registered_ca_exists() {
    // Given
    let (native_token, kakarot_core) = setup_contracts_for_testing();
    ContractAccountTrait::deploy(evm_address(), array![].span())
        .expect('failed deploy contract account',);

    // When
    let is_registered = AddressTrait::is_registered(evm_address());

    // Then
    assert(is_registered, 'account should be deployed');
}

#[test]
#[available_gas(20000000)]
fn test_is_registered_undeployed() {
    // Given
    let (native_token, kakarot_core) = setup_contracts_for_testing();

    // When
    set_contract_address(kakarot_core.contract_address);
    let is_registered = AddressTrait::is_registered(evm_address());

    // Then
    assert(!is_registered, 'account should be undeployed');
}


#[test]
#[available_gas(5000000)]
fn test_account_balance_eoa() {
    // Given
    let (native_token, kakarot_core) = setup_contracts_for_testing();
    let eoa_address = EOATrait::deploy(evm_address()).expect('failed deploy contract account',);

    fund_account_with_native_token(eoa_address.starknet, native_token, 0x1);

    // When
    set_contract_address(kakarot_core.contract_address);
    let account = AccountTrait::fetch(evm_address()).unwrap().unwrap();
    let balance = account.balance().unwrap();

    // Then
    assert(balance == native_token.balanceOf(eoa_address.starknet), 'wrong balance');
}

#[test]
#[available_gas(5000000)]
fn test_address_balance_eoa() {
    // Given
    let (native_token, kakarot_core) = setup_contracts_for_testing();
    let eoa_address = EOATrait::deploy(evm_address()).expect('failed deploy contract account',);

    fund_account_with_native_token(eoa_address.starknet, native_token, 0x1);

    // When
    set_contract_address(kakarot_core.contract_address);
    let account = AccountTrait::fetch(evm_address()).unwrap().unwrap();
    let balance = account.balance().unwrap();

    // Then
    assert(balance == native_token.balanceOf(eoa_address.starknet), 'wrong balance');
}


#[test]
#[available_gas(5000000)]
fn test_account_is_deployed_eoa() {
    // Given
    let (native_token, kakarot_core) = setup_contracts_for_testing();
    let mut eoa_address = EOATrait::deploy(evm_address()).expect('failed deploy eoa',);

    // When
    let account = AccountTrait::fetch(evm_address()).unwrap().unwrap();

    // Then
    assert(account.is_deployed() == true, 'account should be deployed');
}


#[test]
#[available_gas(5000000)]
fn test_account_is_deployed_contract_account() {
    // Given
    let (native_token, kakarot_core) = setup_contracts_for_testing();
    let mut ca_address = ContractAccountTrait::deploy(evm_address(), array![].span())
        .expect('failed deploy contract account',);

    // When
    let account = AccountTrait::fetch(evm_address()).unwrap().unwrap();

    // Then
    assert(account.is_deployed() == true, 'account should be deployed');
}


#[test]
#[available_gas(5000000)]
fn test_account_is_deployed_undeployed() {
    // Given
    let (native_token, kakarot_core) = setup_contracts_for_testing();

    // When
    let account = AccountTrait::fetch_or_create(evm_address()).unwrap();

    // Then
    assert(account.is_deployed() == false, 'account should be deployed');
}


#[test]
#[available_gas(5000000)]
fn test_account_balance_contract_account() {
    // Given
    let (native_token, kakarot_core) = setup_contracts_for_testing();
    let mut ca_address = ContractAccountTrait::deploy(evm_address(), array![].span())
        .expect('failed deploy contract account',);

    fund_account_with_native_token(ca_address.starknet, native_token, 0x1);

    // When
    let account = AccountTrait::fetch(evm_address()).unwrap().unwrap();
    let balance = account.balance().unwrap();

    // Then
    assert(balance == native_token.balanceOf(ca_address.starknet), 'wrong balance');
}

#[test]
#[available_gas(5000000)]
fn test_address_balance_contract_account() {
    // Given
    let (native_token, kakarot_core) = setup_contracts_for_testing();
    let mut ca_address = ContractAccountTrait::deploy(evm_address(), array![].span())
        .expect('failed deploy contract account',);

    fund_account_with_native_token(ca_address.starknet, native_token, 0x1);

    // When
    let account = AccountTrait::fetch(evm_address()).unwrap().unwrap();
    let balance = account.balance().unwrap();

    // Then
    // Then
    assert(balance == native_token.balanceOf(ca_address.starknet), 'wrong balance');
}
