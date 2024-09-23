module MyModule::MembershipSystem {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;
    use std::option;

    /// Struct representing a membership.
    struct Membership has store, key {
        is_active: bool,  // Whether the membership is active
        renewals_left: u64,  // Number of renewals left before expiration
    }

    /// Function to purchase a membership by paying tokens.
    public fun purchase_membership(user: &signer, provider_address: address, amount: u64, renewals: u64) {
        // Transfer payment from the user to the provider
        let payment = coin::withdraw<AptosCoin>(user, amount);
        coin::deposit<AptosCoin>(provider_address, payment);

        // Create a membership for the user with renewals left
        let membership = Membership {
            is_active: true,
            renewals_left: renewals,
        };
        move_to(user, membership);
    }

    /// Function to check if a user's membership is still active.
    public fun check_membership(user_address: address): bool acquires Membership {
        let membership = borrow_global<Membership>(user_address);

        // Check if the membership is still valid based on renewals left
        if (membership.is_active && membership.renewals_left > 0) {
            return true
        };
        false
    }
}
