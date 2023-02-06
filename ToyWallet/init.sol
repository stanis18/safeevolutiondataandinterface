
contract Init {

    struct AddrBal {
        address addr;
		uint bal;
	}

    struct OldFacetStorage {
        AddrBal[] accs;
    }

    struct AddrBalIsOpen {
        AddrBal addr_bal;
		bool is_open;
	}

    struct NewFacetStorage {
	    AddrBalIsOpen[] accs;
    }

    OldFacetStorage old_storage;
    NewFacetStorage new_storage;


    /**
    * @notice postcondition forall (uint i) i < 0 || i >= old_storage.accs.length || new_storage.accs[i].addr_bal.addr == old_storage.accs[i].addr
    * @notice postcondition forall (uint i) i < 0 || i >= old_storage.accs.length || new_storage.accs[i].addr_bal.bal == old_storage.accs[i].bal
    * @notice modifies new_storage
	*/
    function init() public {
        //new_storage.accs.length = old_storage.accs.length;
        /**
         * @notice invariant forall (uint j) j < 0 || j >= i || new_storage.accs[j].addr_bal.addr == old_storage.accs[j].addr
         * @notice invariant forall (uint j) j < 0 || j >= i || new_storage.accs[j].addr_bal.bal == old_storage.accs[j].bal
         */
        for (uint i = 0; i < old_storage.accs.length; i++) {
            new_storage.accs[i].addr_bal.addr = old_storage.accs[i].addr;
            new_storage.accs[i].addr_bal.bal = old_storage.accs[i].bal;
            new_storage.accs[i].is_open = true;
        }
    }

}
