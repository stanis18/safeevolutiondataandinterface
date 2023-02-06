
contract ToyWalletRefinement {

	struct StateOld {
		mapping (address => uint) accs;
		address _this;
	}

	struct Account {
		uint bal;
		bool is_open;
	}

	mapping (address => Account) accs;

	struct StateNew {
		mapping (address => Account) accs;
		address _this;
	}

	address msg_sender;
	address msg_sender_old;

	StateOld od;
	StateOld od_old;
	StateNew nw;
	StateNew nw_old;
	
	/**
	* @notice precondition nw.accs[address(nw._this)].bal == 0
	* @notice precondition forall (address addr) nw.accs[addr].bal == od.accs[addr] // Abs func 
	* @notice precondition nw._this == od._this  // Abs func 
	* @notice postcondition od.accs[address(od._this)] == 0
	*/
	function inv() public {}


	/**
	* @notice precondition true
	* @notice postcondition true
	*/
	function constructor_pre() public {}

	/**
	* @notice precondition forall (address addr) (nw.accs[addr].bal == 0)
	* @notice precondition forall (address addr) nw.accs[addr].bal == od.accs[addr] // Abs func 
	* @notice precondition nw._this == od._this // Abs func
	* @notice postcondition forall (address addr) od.accs[addr] == 0
	*/
	function constructor_post() public {}

	/**
	* @notice precondition true
	* @notice postcondition true
	*/
	function deposit_pre() public {}

	/**
	* @notice precondition msg_sender_old != address(nw_old._this)
	* @notice precondition address(nw._this).balance == address(nw_old._this).balance + msg_value
	* @notice precondition nw.accs[msg_sender].bal == nw_old.accs[msg_sender_old].bal + msg_value
	* @notice precondition forall (address addr) addr == msg_sender || nw_old.accs[addr].bal == nw.accs[addr].bal
	* @notice precondition forall (address addr) nw.accs[addr].bal == od.accs[addr] // Abs func 
	* @notice precondition nw._this == od._this // Abs func 
	* @notice precondition forall (address addr) (nw_old.accs[addr].bal == od_old.accs[addr])
	* @notice precondition nw_old._this == od_old._this
	* @notice postcondition msg_sender_old != address(od_old._this)
	* @notice postcondition address(od._this).balance == address(od_old._this).balance + msg_value
	* @notice postcondition od.accs[msg_sender] == od_old.accs[msg_sender_old] + msg_value
	* @notice postcondition forall (address addr) addr == msg_sender || od_old.accs[addr] == od.accs[addr]
	*/
	function deposit_post(uint msg_value) public {}

	/**
	* @notice precondition true
	* @notice postcondition true
	*/
	function withdraw_pre() public {}

	/**
	* @notice precondition nw_old.accs[msg_sender_old].bal >= value_old
	* @notice precondition msg_sender_old != address(nw_old._this)
	* @notice precondition address(nw._this).balance == address(nw_old._this).balance - value
	* @notice precondition nw.accs[msg_sender].bal == nw_old.accs[msg_sender_old].bal - value
	* @notice precondition forall (address addr) addr == msg_sender || nw_old.accs[addr].bal == nw.accs[addr].bal
	* @notice precondition forall (address addr) nw.accs[addr].bal == od.accs[addr] // Abs func 
	* @notice precondition nw._this == od._this // Abs func 
	* @notice precondition forall (address addr) (nw_old.accs[addr].bal == od_old.accs[addr])
	* @notice precondition nw_old._this == od_old._this
	* @notice postcondition od_old.accs[msg_sender_old] >= value_old
	* @notice postcondition msg_sender_old != address(od_old._this)
	* @notice postcondition address(od._this).balance == address(od_old._this).balance - value
	* @notice postcondition od.accs[msg_sender] == od_old.accs[msg_sender_old] - value
	* @notice postcondition forall (address addr) addr == msg_sender || od_old.accs[addr] == od.accs[addr]
	*/
	function withdraw_pre(uint value, uint value_old) public {}



	
}	