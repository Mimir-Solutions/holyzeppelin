interface RegistryInterface {
    function getBestPoolsWithLimit(address, address, uint) external view returns (address[] memory);
}