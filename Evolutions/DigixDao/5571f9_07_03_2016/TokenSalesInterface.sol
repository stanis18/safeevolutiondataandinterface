contract TokenSalesInterface {
  struct Info {
    uint256 startDate;
    uint256 endDate;
    uint256 amount;
    uint256 totalWeiSold;
    uint256 totalUsdSold;
  }

  Info saleInfo;

  function claim(address _buyer) public returns (bool success);

  function getUsdWei() public  returns (uint);

  function totalWeiSold() public  returns (uint);

  function totalUsdSold() public  returns (uint);

  event Sold(address indexed _buyer, uint256 indexed _amount, uint256 indexed _weitotal);

}
